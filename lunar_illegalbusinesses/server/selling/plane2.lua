-- Server-side Plane2 (Bag Drop) Selling Mission

local MISSION_NAME = "plane2"
local missionConfig = Config.sellingMissions[MISSION_NAME]

-- Active mission data per player
local activeMissions = {}

-- Checks if a location is in use by any player
local function IsLocationInUse(locationIndex)
    for _, missionData in pairs(activeMissions) do
        if missionData.locationIndex == locationIndex then
            return true
        end
    end
    return false
end

-- Register the plane2 selling mission
RegisterSellingMission(MISSION_NAME, {
    canStart = function()
        return Utils.getTableSize(activeMissions) < #missionConfig.spawnLocations
    end,
    
    start = function(playerId, business)
        -- Select random unused location
        local locationIndex
        repeat
            locationIndex = math.random(#missionConfig.spawnLocations)
        until not IsLocationInUse(locationIndex)
        
        -- Calculate bag count based on product amount
        local bagCount = math.floor(math.ceil(business.products / 25) * missionConfig.bags)
        
        activeMissions[playerId] = {
            business = business,
            locationIndex = locationIndex,
            count = bagCount,
            products = business.products
        }
    end,
    
    stop = function(playerId)
        activeMissions[playerId] = nil
    end
})

-- Callback: Get location data
lib.callback.register("lunar_illegalbusiness:plane2:getLocationIndex", function(playerId)
    local mission = activeMissions[playerId]
    return mission.locationIndex, mission.count
end)

-- Event: Vehicle created (creates dispatch blip)
RegisterNetEvent("lunar_illegalbusiness:plane2:createdVehicle", function(vehicleNetId, trailerNetId)
    local playerId = source
    local mission = activeMissions[playerId]
    
    if not mission or mission.vehicleCreated then
        return
    end
    
    mission.vehicleCreated = true
    
    -- Notify all clients for cutscene sync
    TriggerClientEvent("lunar_illegalbusiness:plane2:waitForCutscene", -1, vehicleNetId)
    
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    CreateDispatchBlip(playerId, vehicle, MISSION_NAME)
    
    -- Delete trailer after delay
    local trailer = NetworkGetEntityFromNetworkId(trailerNetId)
    SetTimeout(30000, function()
        DeleteEntity(trailer)
    end)
end)

-- Event: Mission payout
RegisterNetEvent("lunar_illegalbusiness:plane2:payout", function()
    local playerId = source
    local player = Framework.getPlayerFromId(playerId)
    local mission = activeMissions[playerId]
    
    if not player or not mission then
        return
    end
    
    -- Verify player is near delivery zone
    if not Utils.distanceCheck(playerId, missionConfig.delivery.coords, 200.0) then
        return
    end
    
    -- Clean up mission
    activeMissions[playerId] = nil
    
    -- Remove products and update business
    mission.business.products = mission.business.products - mission.products
    mission.business:update(true)
    
    FinishSellingMission(playerId)
    RemoveDispatchBlip(playerId, MISSION_NAME)
    
    -- Pay player after small delay
    SetTimeout(2000, function()
        local price = mission.business:getSellPrice(mission.products)
        player:addAccountMoney(missionConfig.account, price)
    end)
end)