-- Client-side Resupply Mission Management

-- Registered resupply mission handlers
resupplyMissionHandlers = {}

-- Registers a resupply mission type with its handler
function RegisterResupplyMission(missionName, handler)
    resupplyMissionHandlers[missionName] = handler
end

-- Starts a resupply mission for the current business
function StartResupplyMission(businessName)
    local missionType, errorMessage = lib.callback.await("lunar_illegalbusiness:startResupplyMission", false)
    
    if not missionType then
        local message = errorMessage or locale("resupply_already_started")
        LR.notify(message, "error")
        return
    end
    
    resupplyMissionHandlers[missionType].start(businessName)
end