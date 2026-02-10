-- Server-side Resupply Mission Management

-- Registered resupply mission handlers
resupplyMissionHandlers = {}

-- Active resupply missions per player
activeResupplyMissions = {}

-- Checks if a mission type is currently active
function IsMissionActive(missionName)
    for _, missionData in pairs(activeResupplyMissions) do
        if missionData.name == missionName then
            return true
        end
    end
    return false
end

-- Starts a resupply mission for a player
function StartResupplyMission(playerId, businessData)
    local player = Framework.getPlayerFromId(playerId)
    
    -- Check minimum police requirement
    local minPolice = Config.minPolice and Config.minPolice.resupplying or 0
    local policeCount = Utils.getPoliceCount()
    
    if minPolice > policeCount then
        return nil, locale("not_enough_police")
    end
    
    -- Check if player already has an active mission
    if activeResupplyMissions[playerId] then
        return nil
    end
    
    -- Check if mission type is already in use by another player
    if IsMissionActive(businessData.name) then
        return nil
    end
    
    if not player then
        return nil
    end
    
    -- Get available mission types
    local availableMissions = {}
    for missionName, _ in pairs(Config.resupplyMissions) do
        if resupplyMissionHandlers[missionName].canStart() then
            availableMissions[#availableMissions + 1] = missionName
        end
    end
    
    if #availableMissions == 0 then
        return nil, locale("cant_start")
    end
    
    -- Select random mission and start it
    local selectedMission = Utils.randomFromTable(availableMissions)
    resupplyMissionHandlers[selectedMission].start(playerId, businessData)
    
    -- Track active mission
    activeResupplyMissions[playerId] = {
        name = selectedMission,
        business = businessData
    }
    
    -- Log to Discord
    LogToDiscord(player, string.format([[
Started a resupply mission.
Business name: %s
Mission name: %s]], businessData.name, selectedMission))
    
    -- Set up timeout for mission expiration
    local missionDuration = Config.resupplyMissions[selectedMission].duration
    
    SetTimeout(missionDuration - 300000, function()
        if not activeResupplyMissions[playerId] then
            return
        end
        
        LR.notify(playerId, locale("5_mins_left"), "inform")
        
        SetTimeout(300000, function()
            if not activeResupplyMissions[playerId] then
                return
            end
            
            LR.notify(playerId, locale("time_ran_out"), "error")
            TriggerClientEvent("lunar_illegalbusiness:suppliesMissionCanceled", playerId)
            activeResupplyMissions[playerId] = nil
        end)
    end)
    
    return selectedMission
end

-- Finishes an active resupply mission
function FinishResupplyMission(playerId)
    activeResupplyMissions[playerId] = nil
end

-- Clean up when player disconnects
AddEventHandler("playerDropped", function()
    local playerId = source
    local missionData = activeResupplyMissions[playerId]
    local missionName = missionData and missionData.name
    
    if missionName then
        resupplyMissionHandlers[missionName].stop(playerId)
        activeResupplyMissions[playerId] = nil
    end
end)

-- Handle player canceling their mission
RegisterNetEvent("lunar_illegalbusiness:cancelSuppliesMission", function()
    local playerId = source
    local missionName = activeResupplyMissions[playerId].name
    
    if missionName then
        resupplyMissionHandlers[missionName].stop(playerId)
        activeResupplyMissions[playerId] = nil
    end
end)

-- Registers a new resupply mission type
function RegisterResupplyMission(missionName, handler)
    resupplyMissionHandlers[missionName] = handler
end