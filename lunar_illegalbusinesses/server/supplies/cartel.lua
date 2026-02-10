-- Server-side Cartel Resupply Mission

MISSION_NAME = "cartel"
missionConfig = Config.resupplyMissions[MISSION_NAME]

-- Active mission data per player
activeMissions = {}

-- Spawned entities per player
spawnedEntities = {}

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

-- Register the cartel resupply mission
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
            TriggerClientEvent("lunar_illegalbusiness:cartel:removeGuards", -1, playerId)
            TriggerClientEvent("lunar_illegalbusiness:cartel:deleteProps", -1, playerId)
            
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
lib.callback.register("lunar_illegalbusiness:cartel:getLocationIndex", function(playerId)
    return activeMissions[playerId].locationIndex
end)

-- Callback: Spawn cartel entities
lib.callback.register("lunar_illegalbusiness:cartel:spawnEntities", function(playerId)
    if spawnedEntities[playerId] then
        return
    end
    
    local locationIndex = activeMissions[playerId].locationIndex
    local location = missionConfig.locations[locationIndex]
    
    if not location then
        return
    end
    
    -- Create supply vehicle
    local supplyVehicle = Utils.createVehicle(1475773103, location.coords, "automobile")
    
    local entities = {}
    activeMissions[playerId].targetVehicle = supplyVehicle
    entities[#entities + 1] = supplyVehicle
    
    local vehicleNetId = NetworkGetNetworkIdFromEntity(supplyVehicle)
    
    -- Create additional cartel vehicles
    for _, vehicleCoords in ipairs(location.vehicles) do
        local vehicle = Utils.createVehicle(683047626, vehicleCoords, "automobile")
        entities[#entities + 1] = vehicle
    end
    
    -- Spawn guards
    local guardNetIds = {}
    
    for i, guardCoords in ipairs(location.guards) do
        local guard = CreatePed(4, missionConfig.guard.model, guardCoords.x, guardCoords.y, guardCoords.z, guardCoords.w, true, true)
        
        local weapon = Utils.randomFromTable(missionConfig.guard.weapons)
        GiveWeaponToPed(guard, weapon, 200, true, true)
        SetPedArmour(guard, 100)
        SetPedRandomComponentVariation(guard, 0)
        
        guardNetIds[i] = NetworkGetNetworkIdFromEntity(guard)
        entities[#entities + 1] = guard
    end
    
    TriggerClientEvent("lunar_illegalbusiness:cartel:handleGuardsLogic", -1, playerId, location.coords.xyz, guardNetIds)
    TriggerClientEvent("lunar_illegalbusiness:cartel:spawnProps", -1, playerId, location.props)
    
    spawnedEntities[playerId] = entities
    
    return vehicleNetId, guardNetIds
end)

-- Callback: Deliver supplies
lib.callback.register("lunar_illegalbusiness:cartel:deliverSupplies", function(playerId)
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
            TriggerClientEvent("lunar_illegalbusiness:cartel:removeGuards", -1, playerId)
            TriggerClientEvent("lunar_illegalbusiness:cartel:deleteProps", -1, playerId)
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