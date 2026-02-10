-- Server-side Police Warehouse Resupply Mission

MISSION_NAME = "police"
missionConfig = Config.resupplyMissions[MISSION_NAME]

-- Active mission data per player
activeMissions = {}

-- Spawned entities per player
spawnedEntities = {}

-- Players currently inside warehouse
playersInWarehouse = {}

-- Default vehicle models for warehouse
DEFAULT_OTHER_VEHICLES = { 2046537925, -1627000575, 1912215274 }

-- Cleans up spawned entities for a player
function CleanupEntities(playerId)
    local entities = spawnedEntities[playerId]
    if not entities then
        return
    end
    
    for i = 1, #entities do
        if DoesEntityExist(entities[i]) then
            DeleteEntity(entities[i])
        end
    end
end

-- Checks if a location is in use by any player
function IsLocationInUse(locationIndex)
    for _, missionData in pairs(activeMissions) do
        if missionData.locationIndex == locationIndex then
            return true
        end
    end
    return false
end

-- Register the police resupply mission
RegisterResupplyMission(MISSION_NAME, {
    canStart = function()
        return Utils.getTableSize(activeMissions) < #missionConfig.locations
    end,
    
    start = function(playerId, business)
        -- Select random unused location
        local locationIndex
        repeat
            locationIndex = math.random(#missionConfig.locations)
        until not IsLocationInUse(locationIndex)
        
        activeMissions[playerId] = {
            business = business,
            locationIndex = locationIndex
        }
    end,
    
    stop = function(playerId)
        local entities = spawnedEntities[playerId]
        
        -- Cleanup after delay
        SetTimeout(300000, function()
            TriggerClientEvent("lunar_illegalbusiness:police:removeGuards", -1, playerId)
            
            if entities then
                for i = 1, #entities do
                    if DoesEntityExist(entities[i]) then
                        DeleteEntity(entities[i])
                    end
                end
            end
        end)
        
        spawnedEntities[playerId] = nil
        activeMissions[playerId] = nil
    end
})

-- Callback: Get location index for player
lib.callback.register("lunar_illegalbusiness:police:getLocationIndex", function(playerId)
    return activeMissions[playerId].locationIndex
end)

-- Callback: Spawn police warehouse entities
lib.callback.register("lunar_illegalbusiness:police:spawnEntities", function(playerId)
    if spawnedEntities[playerId] then
        return
    end
    
    local routingBucket = 5000 + playerId
    local targetVehicleIndex = math.random(#missionConfig.interior.vehicles)
    local targetVehicle = nil
    
    local entities = {}
    local guardPeds = {}
    local guardNetIds = {}
    
    -- Spawn vehicles
    for i, vehicleCoords in ipairs(missionConfig.interior.vehicles) do
        if i == targetVehicleIndex then
            -- Target supply van
            local vanModel = missionConfig.vehicles and missionConfig.vehicles.van or 456714581
            targetVehicle = Utils.createVehicle(vanModel, vehicleCoords, "automobile")
            SetEntityRoutingBucket(targetVehicle, routingBucket)
            Entity(targetVehicle).state:set("freeze", true, true)
            entities[#entities + 1] = targetVehicle
        else
            -- Other random vehicles
            local otherVehicles = missionConfig.vehicles and missionConfig.vehicles.other or DEFAULT_OTHER_VEHICLES
            local vehicleModel = Utils.randomFromTable(otherVehicles)
            local vehicle = Utils.createVehicle(vehicleModel, vehicleCoords, "automobile")
            SetEntityRoutingBucket(vehicle, routingBucket)
            entities[#entities + 1] = vehicle
        end
    end
    
    -- Select random unique guard positions
    local usedPositions = {}
    
    local function isPositionUsed(coords)
        for _, usedCoords in ipairs(usedPositions) do
            if usedCoords == coords then
                return true
            end
        end
        return false
    end
    
    for i = 1, missionConfig.guard.count do
        local guardCoords
        repeat
            guardCoords = Utils.randomFromTable(missionConfig.interior.guards)
        until not isPositionUsed(guardCoords)
        
        usedPositions[#usedPositions + 1] = guardCoords
    end
    
    -- Spawn guards
    for i, guardCoords in ipairs(usedPositions) do
        local guard = CreatePed(4, missionConfig.guard.model, guardCoords.x, guardCoords.y, guardCoords.z, guardCoords.w, true, true)
        SetPedArmour(guard, 100)
        SetPedRandomComponentVariation(guard, 0)
        SetEntityRoutingBucket(guard, routingBucket)
        
        guardPeds[#guardPeds + 1] = guard
        guardNetIds[#guardNetIds + 1] = NetworkGetNetworkIdFromEntity(guard)
        entities[#entities + 1] = guard
    end
    
    TriggerClientEvent("lunar_illegalbusiness:police:addEntrance", -1, playerId, activeMissions[playerId].locationIndex, guardNetIds)
    spawnedEntities[playerId] = entities
    
    activeMissions[playerId].targetVehicle = targetVehicle
    activeMissions[playerId].guards = guardPeds
    
    return NetworkGetNetworkIdFromEntity(targetVehicle)
end)

-- Event: Player entering warehouse
RegisterNetEvent("lunar_illegalbusiness:police:enterWarehouse", function(missionPlayerId)
    local playerId = source
    local mission = activeMissions[missionPlayerId]
    
    if not mission then
        return
    end
    
    playersInWarehouse[playerId] = GetPlayerPed(playerId)
    
    local routingBucket = 5000 + missionPlayerId
    SetPlayerRoutingBucket(playerId, routingBucket)
    SetRoutingBucketPopulationEnabled(routingBucket, false)
    
    -- Arm guards after short delay
    SetTimeout(500, function()
        local guards = activeMissions[playerId] and activeMissions[playerId].guards
        
        if guards then
            for i = 1, #guards do
                local guard = guards[i]
                local weapon = Utils.randomFromTable(missionConfig.guard.weapons)
                GiveWeaponToPed(guard, weapon, 400, true, true)
                SetCurrentPedWeapon(guard, weapon, true)
            end
        end
    end)
end)

-- Event: Player leaving warehouse
RegisterNetEvent("lunar_illegalbusiness:police:leaveWarehouse", function()
    local playerId = source
    local playerPed = playersInWarehouse[playerId]
    
    if not playerPed then
        return
    end
    
    playersInWarehouse[playerId] = nil
    
    -- Move vehicle to normal routing bucket if player is in one
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(playerId), false)
    if vehicle ~= 0 then
        SetEntityRoutingBucket(vehicle, 0)
        
        -- Move other players in same vehicle
        for otherPlayerId, otherPed in pairs(playersInWarehouse) do
            if GetVehiclePedIsIn(otherPed, false) == vehicle then
                SetPlayerRoutingBucket(otherPlayerId, 0)
            end
        end
    end
    
    SetPlayerRoutingBucket(playerId, 0)
end)

-- Event: Vehicle hacked
RegisterNetEvent("lunar_illegalbusiness:police:hacked", function()
    local playerId = source
    local mission = activeMissions[playerId]
    local targetVehicle = mission and mission.targetVehicle
    
    if targetVehicle then
        local vehicleCoords = GetEntityCoords(targetVehicle)
        
        if Utils.distanceCheck(playerId, vehicleCoords, 4.0) then
            Entity(targetVehicle).state:set("hacked", true, true)
        end
    end
end)

-- Callback: Deliver supplies
lib.callback.register("lunar_illegalbusiness:police:deliverSupplies", function(playerId)
    local mission = activeMissions[playerId]
    local targetVehicle = mission and mission.targetVehicle
    local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(playerId))
    
    if targetVehicle == playerVehicle then
        -- Add supplies to business
        local supplyAmount = missionConfig.addSupplies or 100
        mission.business.supplies = math.min(100, mission.business.supplies + supplyAmount)
        mission.business:update(true)
        
        -- Cleanup after delay
        SetTimeout(5000, function()
            CleanupEntities(playerId)
            TriggerClientEvent("lunar_illegalbusiness:police:removeGuards", -1, playerId)
            spawnedEntities[playerId] = nil
        end)
        
        FinishResupplyMission(playerId)
        activeMissions[playerId] = nil
        return true
    end
    
    return false
end)

-- Cleanup on resource stop
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= cache.resource then
        return
    end
    
    for playerId, _ in pairs(spawnedEntities) do
        CleanupEntities(playerId)
    end
end)