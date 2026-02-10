-- Server-side Helicopter Selling Mission

local MISSION_NAME = "heli"
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

-- Register the heli selling mission
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
        
        -- Calculate delivery stops based on product amount
        local stopCount = math.ceil(business.products / 25) * missionConfig.stops
        
        -- Initialize delivery tracking
        local delivered = {}
        local maxPerStop = {}
        
        for i = 1, stopCount do
            delivered[i] = 0
            maxPerStop[i] = math.random(missionConfig.productsPerLocation.min, missionConfig.productsPerLocation.max)
        end
        
        activeMissions[playerId] = {
            business = business,
            locationIndex = locationIndex,
            maxes = maxPerStop,
            delivered = delivered,
            products = business.products
        }
    end,
    
    stop = function(playerId)
        activeMissions[playerId] = nil
    end
})

-- Callback: Get location data
lib.callback.register("lunar_illegalbusiness:heli:getLocationIndex", function(playerId)
    local mission = activeMissions[playerId]
    
    -- Calculate total products to deliver
    local totalProducts = 0
    for i = 1, #mission.maxes do
        totalProducts = totalProducts + mission.maxes[i]
    end
    
    return mission.locationIndex, #mission.delivered, totalProducts
end)

-- Event: Player entered vehicle (creates dispatch blip)
RegisterNetEvent("lunar_illegalbusiness:heli:insideVehicle", function(vehicleNetId, trailerNetId)
    local playerId = source
    local mission = activeMissions[playerId]
    
    if not mission or mission.dispatched then
        return
    end
    
    mission.dispatched = true
    
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    CreateDispatchBlip(playerId, vehicle, MISSION_NAME)
    
    -- Delete trailer after delay
    local trailer = NetworkGetEntityFromNetworkId(trailerNetId)
    SetTimeout(30000, function()
        DeleteEntity(trailer)
    end)
end)

-- Checks if player is near any delivery location
function IsNearDeliveryLocation(playerId)
    for i = 1, #missionConfig.deliveryLocations do
        if Utils.distanceCheck(playerId, missionConfig.deliveryLocations[i], 10.0) then
            return true
        end
    end
    return false
end

-- Callback: Deliver product at a stop
lib.callback.register("lunar_illegalbusiness:heli:deliverProduct", function(playerId, stopIndex)
    local mission = activeMissions[playerId]
    local delivered = mission and mission.delivered
    local stopDelivered = delivered and delivered[stopIndex]
    
    if not stopDelivered or not IsNearDeliveryLocation(playerId) then
        return
    end
    
    -- Increment delivery count for this stop
    delivered[stopIndex] = delivered[stopIndex] + 1
    
    return delivered[stopIndex], mission.maxes[stopIndex]
end)

-- Event: Mission payout
RegisterNetEvent("lunar_illegalbusiness:heli:payout", function()
    local playerId = source
    local player = Framework.getPlayerFromId(playerId)
    local mission = activeMissions[playerId]
    
    if not player or not mission then
        return
    end
    
    -- Verify all deliveries completed
    for i = 1, #mission.delivered do
        if mission.delivered[i] ~= mission.maxes[i] then
            return
        end
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
    FinishSellingMission(playerId)
end)