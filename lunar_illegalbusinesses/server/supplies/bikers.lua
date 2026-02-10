-- Server-side Bikers Resupply Mission

MISSION_NAME = "bikers"
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

-- Register the bikers resupply mission
RegisterResupplyMission(MISSION_NAME, {
    canStart = function()
        return true
    end,
    
    start = function(playerId, business)
        activeMissions[playerId] = {
            business = business
        }
    end,
    
    stop = function(playerId)
        local entities = spawnedEntities[playerId]
        
        -- Cleanup after delay
        SetTimeout(300000, function()
            TriggerClientEvent("lunar_illegalbusiness:bikers:removeGuards", -1, playerId)
            
            for i = 1, #entities do
                if DoesEntityExist(entities[i]) then
                    DeleteEntity(entities[i])
                end
            end
        end)
        
        spawnedEntities[playerId] = nil
        activeMissions[playerId] = nil
    end
})

-- Callback: Spawn supply vehicle and guards
lib.callback.register("lunar_illegalbusiness:bikers:spawnVehicle", function(playerId, spawnCoords, velocity)
    if spawnedEntities[playerId] or not activeMissions[playerId] then
        return
    end
    
    -- Create supply van
    local supplyVan = Utils.createVehicle(-1745203402, spawnCoords, "automobile")
    SetEntityVelocity(supplyVan, velocity)
    
    local entities = {}
    activeMissions[playerId].targetVehicle = supplyVan
    entities[#entities + 1] = supplyVan
    
    local vanNetId = NetworkGetNetworkIdFromEntity(supplyVan)
    
    -- Spawn biker guards
    local guardNetIds = {}
    
    for i = 1, missionConfig.bikeCount do
        local bikeOffset = -3.0 * i
        local bikeCoords = Utils.offsetCoords(spawnCoords, 0.0, -4 + bikeOffset, 0.0)
        local bike = Utils.createVehicle(-570033273, bikeCoords, "bike")
        entities[#entities + 1] = bike
        
        local guardCoords = Utils.offsetCoords(spawnCoords, 4.0, 0.0, 0.0)
        local guard = CreatePed(4, missionConfig.guard.model, guardCoords.x, guardCoords.y, guardCoords.z, guardCoords.w, true, true)
        
        local weapon = Utils.randomFromTable(missionConfig.guard.weapons)
        GiveWeaponToPed(guard, weapon, 200, true, true)
        SetPedArmour(guard, 100)
        SetPedRandomComponentVariation(guard, 0)
        
        -- Put guard in bike
        CreateThread(function()
            repeat
                SetPedIntoVehicle(guard, bike, -1)
                Wait(0)
            until GetVehiclePedIsIn(guard, false) == bike
        end)
        
        guardNetIds[i] = NetworkGetNetworkIdFromEntity(guard)
        entities[#entities + 1] = guard
    end
    
    TriggerClientEvent("lunar_illegalbusiness:bikers:handleGuardsLogic", -1, playerId, vanNetId, guardNetIds)
    spawnedEntities[playerId] = entities
    
    return vanNetId, guardNetIds
end)

-- Event: Vehicle went too far from player
RegisterNetEvent("lunar_illegalbusiness:bikers:vehicleTooFar", function()
    local playerId = source
    
    if spawnedEntities[playerId] then
        CleanupEntities(playerId)
        TriggerClientEvent("lunar_illegalbusiness:bikers:removeGuards", -1, playerId)
        spawnedEntities[playerId] = nil
    end
end)

-- Callback: Deliver supplies
lib.callback.register("lunar_illegalbusiness:bikers:deliverSupplies", function(playerId)
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
            TriggerClientEvent("lunar_illegalbusiness:bikers:removeGuards", -1, playerId)
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