-- Setup Mission - Equipment Delivery

-- Starts the setup mission for a business
function StartSetupMission(businessName)
    if Editable.isDead(cache.ped) then
        return
    end
    
    local locationConfig = Config.locations[businessName]
    
    local vehicleSpawnCoords = lib.callback.await("lunar_illegalbusiness:startSetup", false)
    if not vehicleSpawnCoords then
        return
    end
    
    Interior.exit()
    
    -- Create blip for vehicle spawn location
    local vehicleBlip = Utils.createBlip(vehicleSpawnCoords, Config.equipment.blip)
    SetBlipRoute(vehicleBlip.value, true)
    
    LR.showObjective(locale("setup_mission"), locale("go_to_truck"))
    
    -- Wait for player to get near the vehicle spawn
    Utils.distanceWait(vehicleSpawnCoords, 100.0)
    
    -- Spawn the delivery vehicle
    local vehiclePromise = promise.new()
    Framework.spawnVehicle(1653666139, vehicleSpawnCoords.xyz, vehicleSpawnCoords.w, function(vehicle)
        SetTimeout(1000, function()
            TriggerServerEvent("lunar_illegalbusiness:registerSetupVehicle", NetworkGetNetworkIdFromEntity(vehicle))
        end)
        Editable.addKeys(vehicle)
        vehiclePromise:resolve(vehicle)
    end)
    
    local spawnedVehicle = Citizen.Await(vehiclePromise)
    
    -- Wait for player to get in the vehicle
    Utils.distanceWait(vehicleSpawnCoords, 10.0)
    LR.showObjective(locale("setup_mission"), locale("go_inside_truck"))
    
    while cache.vehicle ~= spawnedVehicle do
        Wait(500)
    end
    
    vehicleBlip.remove()
    LR.showObjective(locale("setup_mission"), locale("deliver_truck"))
    
    -- Create dropoff location blip
    local dropoffCoords = locationConfig.vehicleSpawn
    local dropoffBlip = Utils.createBlip(dropoffCoords, {
        name = locale("truck_dropoff"),
        sprite = 1,
        color = 2,
        size = 0.75
    })
    SetBlipRoute(dropoffBlip.value, true)
    
    -- State tracking
    local isShowingUI = false
    local missionActive = true
    
    -- Create dropoff zone
    local dropoffZone = lib.points.new({
        coords = dropoffCoords.xyz,
        distance = 100.0,
        nearby = function(point)
            local vehicleRear = GetOffsetFromEntityInWorldCoords(spawnedVehicle, 0.0, -2.0, 0.0)
            local distanceToDropoff = #(point.coords - vehicleRear)
            local vehicleHeading = GetEntityHeading(spawnedVehicle)
            
            if vehicleHeading < 0.0 then
                vehicleHeading = 360.0 + vehicleHeading
            end
            
            -- Calculate heading difference
            local headingDiff = (vehicleHeading - dropoffCoords.w + 180) % 360 - 180
            local altHeadingDiff = (vehicleHeading - dropoffCoords.w) % 360 - 180
            
            local isInPosition = distanceToDropoff < 1.0
            
            -- Show/hide delivery UI
            if isInPosition and not isShowingUI then
                LR.showUI(locale("deliver_equipment"), "truck")
                isShowingUI = true
            elseif not isInPosition and isShowingUI then
                LR.hideUI()
                isShowingUI = false
            end
            
            -- Handle delivery input
            if isInPosition and IsControlJustReleased(0, 38) then
                local success = lib.callback.await("lunar_illegalbusiness:deliverSetupVehicle", false)
                if success then
                    TaskLeaveAnyVehicle(cache.ped)
                    LR.hideUI()
                    LR.hideObjective()
                    point:remove()
                    dropoffBlip.remove()
                    missionActive = false
                    
                    SetTimeout(1000, function()
                        Interior.enter(businessName, false)
                    end)
                    return
                end
            end
            
            if not missionActive then
                return
            end
            
            -- Render dropoff zone box
            local boxR, boxG, boxB = 255, 150, 50
            if isInPosition then
                boxR, boxG, boxB = 50, 255, 50
            end
            
            RenderRotatedBox(
                dropoffCoords.x, dropoffCoords.y, dropoffCoords.z,
                14.0, 3.75, 7.0,
                dropoffCoords.w + 90,
                boxR, boxG, boxB, 100
            )
        end
    })
    
    -- Monitor vehicle status during mission
    while missionActive do
        local vehicleExists = DoesEntityExist(spawnedVehicle)
        local vehicleDriveable = vehicleExists and IsVehicleDriveable(spawnedVehicle, false)
        
        if not vehicleExists or not vehicleDriveable then
            TriggerServerEvent("lunar_illegalbusiness:equipmentDestroyed")
            LR.hideObjective()
            dropoffZone:remove()
            dropoffBlip.remove()
            break
        end
        
        Wait(200)
    end
end