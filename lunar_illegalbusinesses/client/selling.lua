-- Selling Mission Management

-- Registered selling mission handlers
sellingMissionHandlers = {}

-- Active dispatch blips for police
activeDispatchBlips = {}

-- Registers a selling mission type with its handler
function RegisterSellingMission(missionName, handler)
    sellingMissionHandlers[missionName] = handler
end

-- Starts a selling mission for the current business
function StartSellingMission(businessName)
    local missionType, errorMessage = lib.callback.await("lunar_illegalbusiness:startSellingMission", false)
    
    if not missionType then
        local message = errorMessage or locale("selling_already_started")
        LR.notify(message, "error")
        return
    end
    
    sellingMissionHandlers[missionType].start(businessName)
end

-- Updates dispatch blips for police tracking
RegisterNetEvent("lunar_illegalbusiness:updateDispatchBlips", function(activeVehicles)
    if not Utils.isPolice() then
        return
    end
    
    -- Update or create blips for active vehicles
    for vehicleId, vehicleData in pairs(activeVehicles) do
        local coords = vehicleData.coords
        
        -- Create blip if it doesn't exist
        if not activeDispatchBlips[vehicleId] then
            local missionConfig = Config.sellingMissions[vehicleData.name]
            activeDispatchBlips[vehicleId] = Utils.createBlip(coords, missionConfig.dispatch.blip)
        end
        
        -- Update blip position and rotation
        local blipHandle = activeDispatchBlips[vehicleId].value
        SetBlipCoords(blipHandle, coords.x, coords.y, coords.z)
        SetBlipRotation(blipHandle, math.ceil(coords.w))
    end
    
    -- Remove blips for vehicles that are no longer active
    for vehicleId, blip in pairs(activeDispatchBlips) do
        if not activeVehicles[vehicleId] then
            blip.remove()
            activeDispatchBlips[vehicleId] = nil
        end
    end
end)