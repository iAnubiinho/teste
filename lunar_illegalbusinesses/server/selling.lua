-- Server-side Selling Mission Management

-- Registered selling mission handlers
sellingMissionHandlers = {}

-- Active selling missions per player
activeSellingMissions = {}

-- Checks if a business already has an active selling mission
function IsBusinessSelling(businessName)
    for _, missionData in pairs(activeSellingMissions) do
        if missionData.business.name == businessName then
            return true
        end
    end
    return false
end

-- Starts a selling mission for a player
function StartSellingMission(playerId, businessData)
    local player = Framework.getPlayerFromId(playerId)
    
    -- Check minimum police requirement
    local minPolice = Config.minPolice and Config.minPolice.selling or 0
    local policeCount = Utils.getPoliceCount()
    
    if minPolice > policeCount then
        return nil, locale("not_enough_police")
    end
    
    -- Check if player already has an active mission
    if activeSellingMissions[playerId] then
        return nil
    end
    
    -- Check if business already has an active selling mission
    if IsBusinessSelling(businessData.name) then
        return nil
    end
    
    -- Check if business has enough products
    if businessData.products < 25 then
        return nil
    end
    
    if not player then
        return nil
    end
    
    -- Get available mission types
    local availableMissions = {}
    for missionName, _ in pairs(Config.sellingMissions) do
        if sellingMissionHandlers[missionName].canStart() then
            availableMissions[#availableMissions + 1] = missionName
        end
    end
    
    if #availableMissions == 0 then
        return nil, locale("cant_start")
    end
    
    -- Select random mission and start it
    local selectedMission = Utils.randomFromTable(availableMissions)
    sellingMissionHandlers[selectedMission].start(playerId, businessData)
    
    -- Track active mission
    activeSellingMissions[playerId] = {
        name = selectedMission,
        business = businessData
    }
    
    -- Log to Discord
    LogToDiscord(player, string.format([[
Started a selling mission.
Business name: %s
Mission name: %s]], businessData.name, selectedMission))
    
    -- Set up timeout for mission expiration
    local missionDuration = Config.sellingMissions[selectedMission].duration
    
    SetTimeout(missionDuration - 300000, function()
        if not activeSellingMissions[playerId] then
            return
        end
        
        LR.notify(playerId, locale("5_mins_left"), "inform")
        
        SetTimeout(300000, function()
            if not activeSellingMissions[playerId] then
                return
            end
            
            LR.notify(playerId, locale("time_ran_out"), "error")
            TriggerClientEvent("lunar_illegalbusiness:sellingMissionCanceled", playerId)
            activeSellingMissions[playerId] = nil
        end)
    end)
    
    return selectedMission
end

-- Finishes an active selling mission
function FinishSellingMission(playerId)
    activeSellingMissions[playerId] = nil
end

-- Clean up when player disconnects
AddEventHandler("playerDropped", function()
    local playerId = source
    local missionData = activeSellingMissions[playerId]
    local missionName = missionData and missionData.name
    
    if missionName then
        sellingMissionHandlers[missionName].stop(playerId)
        activeSellingMissions[playerId] = nil
    end
end)

-- Handle player canceling their mission
RegisterNetEvent("lunar_illegalbusiness:cancelSellingMission", function()
    local playerId = source
    local missionName = activeSellingMissions[playerId].name
    
    if missionName then
        sellingMissionHandlers[missionName].stop(playerId)
        activeSellingMissions[playerId] = nil
    end
end)

-- Registers a new selling mission type
function RegisterSellingMission(missionName, handler)
    sellingMissionHandlers[missionName] = handler
end

-- Dispatch System
activeDispatchBlips = {}
dispatchVehicles = {}

-- Creates a dispatch blip for police tracking
function CreateDispatchBlip(playerId, vehicle, missionName)
    local missionConfig = Config.sellingMissions[missionName]
    if not missionConfig.dispatch.enabled then
        return
    end
    
    local coords = GetEntityCoords(vehicle)
    Dispatch.call(coords, {
        Code = Config.sellingDispatch.code,
        Title = Config.sellingDispatch.title,
        Message = Config.sellingDispatch.message
    })
    
    activeDispatchBlips[playerId] = { name = missionName }
    dispatchVehicles[playerId] = vehicle
end

-- Removes a dispatch blip
function RemoveDispatchBlip(playerId, missionName)
    local missionConfig = Config.sellingMissions[missionName]
    if not missionConfig.dispatch.enabled then
        return
    end
    
    dispatchVehicles[playerId] = nil
    activeDispatchBlips[playerId] = nil
end

-- Periodically update dispatch blip positions for police
SetInterval(function()
    for playerId, blipData in pairs(activeDispatchBlips) do
        local vehicle = dispatchVehicles[playerId]
        
        if DoesEntityExist(vehicle) then
            local coords = GetEntityCoords(vehicle)
            local heading = GetEntityHeading(vehicle)
            blipData.coords = vector4(coords.x, coords.y, coords.z, heading)
        else
            dispatchVehicles[playerId] = nil
            activeDispatchBlips[playerId] = nil
        end
    end
    
    TriggerClientEvent("lunar_illegalbusiness:updateDispatchBlips", -1, activeDispatchBlips)
end, Config.sellingDispatch.interval)