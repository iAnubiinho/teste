-- Server-side Plane Selling Mission

local MISSION_NAME = "plane"
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

-- Register the plane selling mission
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
        
        -- Calculate delivery count based on product amount
        local deliveryCount = math.floor(math.ceil(business.products / 25) * missionConfig.stops)
        
        activeMissions[playerId] = {
            business = business,
            locationIndex = locationIndex,
            delivered = 0,
            count = deliveryCount,
            products = business.products
        }
    end,
    
    stop = function(playerId)
        activeMissions[playerId] = nil
    end
})

-- Callback: Get location data
lib.callback.register("lunar_illegalbusiness:plane:getLocationIndex", function(playerId)
    local mission = activeMissions[playerId]
    return mission.locationIndex, mission.count
end)

-- Checks if player is near any delivery location
function IsNearDeliveryLocation(playerId)
    local playerCoords = GetEntityCoords(GetPlayerPed(playerId))
    local playerCoords2D = playerCoords.xy
    
    for i = 1, #missionConfig.deliveryLocations do
        local locationCoords2D = missionConfig.deliveryLocations[i].xy
        local distance = #(locationCoords2D - playerCoords2D)
        
        if distance < 150.0 then
            return true
        end
    end
    
    return false
end

-- Event: Player entered vehicle (creates dispatch blip)
RegisterNetEvent("lunar_illegalbusiness:plane:insideVehicle", function(vehicleNetId, trailerNetId)
    local playerId = source
    local mission = activeMissions[playerId]
    
    if not mission or mission.vehicle then
        return
    end
    
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    CreateDispatchBlip(playerId, vehicle, MISSION_NAME)
    mission.vehicle = vehicle
    
    -- Delete trailer after delay
    local trailer = NetworkGetEntityFromNetworkId(trailerNetId)
    SetTimeout(30000, function()
        DeleteEntity(trailer)
    end)
end)

-- Event: Deliver product
RegisterNetEvent("lunar_illegalbusiness:plane:deliverProduct", function()
    local playerId = source
    local mission = activeMissions[playerId]
    
    if not mission or not IsNearDeliveryLocation(playerId) then
        return
    end
    
    mission.delivered = mission.delivered + 1
end)

-- Event: Mission payout
RegisterNetEvent("lunar_illegalbusiness:plane:payout", function()
    local playerId = source
    local player = Framework.getPlayerFromId(playerId)
    local mission = activeMissions[playerId]
    
    if not player or not mission then
        return
    end
    
    -- Verify all deliveries completed
    if mission.delivered ~= mission.count then
        return
    end
    
    -- Clean up mission
    activeMissions[playerId] = nil
    
    -- Remove products and update business
    mission.business.products = mission.business.products - mission.products
    mission.business:update(true)
    
    -- Pay player
    local price = mission.business:getSellPrice(mission.products)
    player:addAccountMoney(missionConfig.account, price)
    
    RemoveDispatchBlip(playerId, MISSION_NAME)
    DeleteEntity(mission.vehicle)
    FinishSellingMission(playerId)
end)