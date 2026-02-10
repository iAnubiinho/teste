-- Server-side Setup Mission Management

-- Active setup missions per player
activeSetupMissions = {}

-- Active setup vehicles per player
setupVehicles = {}

-- Callback: Start a setup mission
lib.callback.register("lunar_illegalbusiness:startSetup", function(playerId)
    local player = Framework.getPlayerFromId(playerId)
    local spawnCoords = Utils.randomFromTable(Config.equipment.locations)
    local business = Businesses.get(GetInside(playerId))
    
    if not spawnCoords or not player or not business then
        return
    end
    
    -- Check if already in setup mission
    if activeSetupMissions[playerId] then
        return
    end
    
    -- Check if business needs setup
    if business.equipment ~= "none" then
        return
    end
    
    activeSetupMissions[playerId] = business
    return spawnCoords
end)

-- Event: Register the setup vehicle
RegisterNetEvent("lunar_illegalbusiness:registerSetupVehicle", function(vehicleNetId)
    local playerId = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    
    if not activeSetupMissions[playerId] then
        return
    end
    
    if setupVehicles[playerId] then
        return
    end
    
    if DoesEntityExist(vehicle) then
        setupVehicles[playerId] = vehicle
    end
end)

-- Callback: Deliver the setup vehicle
lib.callback.register("lunar_illegalbusiness:deliverSetupVehicle", function()
    local playerId = source
    local registeredVehicle = setupVehicles[playerId]
    local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(playerId))
    
    if registeredVehicle ~= playerVehicle then
        return false
    end
    
    -- Set up the business
    local business = activeSetupMissions[playerId]
    business.equipment = "low"
    business.employees = "low"
    business.supplies = 100
    business:update()
    
    -- Delete vehicle after delay
    local vehicleToDelete = setupVehicles[playerId]
    SetTimeout(5000, function()
        DeleteEntity(vehicleToDelete)
    end)
    
    -- Clean up tracking
    setupVehicles[playerId] = nil
    activeSetupMissions[playerId] = nil
    
    return true
end)

-- Clean up when player disconnects
AddEventHandler("playerDropped", function()
    local playerId = source
    
    if activeSetupMissions[playerId] then
        setupVehicles[playerId] = nil
        activeSetupMissions[playerId] = nil
    end
end)