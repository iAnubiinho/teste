-- Client-side Plane Selling Mission (Airdrop)

local MISSION_NAME = "plane"
local missionConfig = Config.sellingMissions[MISSION_NAME]

-- Mission state
local isMissionActive = false
local activeBlips = {}
local planeEntity = nil
local carryingPropEntity = nil

-- Adds blips to the tracking list for cleanup
local function AddBlip(...)
    local blips = {...}
    for i = 1, #blips do
        activeBlips[#activeBlips + 1] = blips[i]
    end
end

-- Clears all tracked blips
local function ClearAllBlips()
    for i = 1, #activeBlips do
        activeBlips[i].remove()
    end
    table.wipe(activeBlips)
end

-- Waits for player to get within distance of coordinates
local function WaitForDistance(coords, distance)
    Utils.distanceWait(coords, distance)
    return isMissionActive
end

-- Cancels the current mission with a notification
local function CancelMission(message)
    TriggerServerEvent("lunar_illegalbusiness:cancelSellingMission")
    LR.notify(message, "error")
    LR.hideObjective()
    ClearAllBlips()
    isMissionActive = false
end

-- Handle mission cancellation from server
RegisterNetEvent("lunar_illegalbusiness:sellingMissionCanceled", function()
    ClearAllBlips()
    LR.hideObjective()
    isMissionActive = false
end)

-- Returns a list of random unique delivery locations
local function GetRandomDeliveryLocations(count)
    local selectedLocations = {}
    
    function IsLocationSelected(location)
        for i = 1, #selectedLocations do
            if selectedLocations[i] == location then
                return true
            end
        end
        return false
    end
    
    repeat
        local location = Utils.randomFromTable(missionConfig.deliveryLocations)
        if not IsLocationSelected(location) then
            selectedLocations[#selectedLocations + 1] = location
        end
        Wait(0)
    until #selectedLocations == math.min(count, #missionConfig.deliveryLocations)
    
    return selectedLocations
end

-- Attaches a cargo box prop to the player for carrying
local function AttachCargoProp()
    if carryingPropEntity then
        return
    end
    
    local propConfig = {
        model = 377646791,
        bone = 28422,
        offset = vector3(0.0, -0.2, 0.1),
        rot = vector3(30.0, 0.0, 0.0),
        dict = "anim@heists@box_carry@",
        clip = "idle"
    }
    
    local playerCoords = GetEntityCoords(cache.ped)
    
    lib.requestModel(propConfig.model)
    lib.requestAnimDict(propConfig.dict)
    
    carryingPropEntity = CreateObject(propConfig.model, playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)
    
    SetEntityVisible(carryingPropEntity, false, false)
    SetEntityCollision(carryingPropEntity, false, false)
    
    AttachEntityToEntity(
        carryingPropEntity,
        cache.ped,
        GetPedBoneIndex(cache.ped, propConfig.bone),
        propConfig.offset.x, propConfig.offset.y, propConfig.offset.z,
        propConfig.rot.x, propConfig.rot.y, propConfig.rot.z,
        true, true, false, true, 2, true
    )
    
    SetTimeout(200, function()
        SetEntityVisible(carryingPropEntity, true, false)
    end)
    
    -- Play carrying animation loop
    CreateThread(function()
        while carryingPropEntity do
            if not IsEntityPlayingAnim(cache.ped, propConfig.dict, propConfig.clip, 3) then
                TaskPlayAnim(cache.ped, propConfig.dict, propConfig.clip, 20.0, 8.0, -1, 49, 1.0, false, false, false)
            end
            Wait(100)
        end
        StopAnimTask(cache.ped, propConfig.dict, propConfig.clip, 8.0)
    end)
end

-- Creates the payout ped after deliveries are complete
local function CreatePayoutPed()
    local payoutLocation = Utils.randomFromTable(missionConfig.payoutLocations)
    local payoutPed = nil
    
    payoutPed = Utils.createPed(payoutLocation, missionConfig.payoutPed.model, {
        {
            label = locale("payout"),
            icon = "dollar-sign",
            onSelect = function()
                local ped = payoutPed.get()
                if not ped then
                    return
                end
                
                ClearAllBlips()
                LR.notify(locale("received_payout"), "success")
                TriggerServerEvent("lunar_illegalbusiness:plane:payout")
                LR.hideObjective()
                isMissionActive = false
                
                -- Play handshake animation
                lib.requestAnimDict("mp_common")
                TaskPlayAnim(ped, "mp_common", "givetake1_a", 2.0, 1.0, 2000, 16)
                Wait(3500)
                
                payoutPed.free()
            end
        }
    })
    
    local payoutBlip = Utils.createBlip(payoutLocation, missionConfig.payoutPed.blip)
    SetBlipRoute(payoutBlip.value, true)
    SetBlipAsShortRange(payoutBlip.value, false)
    AddBlip(payoutBlip)
    
    LR.showObjective(locale("product_selling"), locale("go_to_payout"))
end

-- Main mission start function
function StartPlaneMission(business)
    local businessName = business.name
    local locationConfig = Config.locations[businessName]
    
    local spawnIndex, deliveryCount = lib.callback.await("lunar_illegalbusiness:plane:getLocationIndex", false)
    local spawnLocation = missionConfig.spawnLocations[spawnIndex]
    
    if not spawnLocation then
        return
    end
    
    Interior.exit()
    isMissionActive = true
    Wait(500)
    
    -- Spawn van at business location
    local vanEntity = nil
    Framework.spawnVehicle(missionConfig.van.model, locationConfig.vehicleSpawn.xyz, locationConfig.vehicleSpawn.w, function(vehicle)
        Editable.addKeys(vehicle)
        Editable.setVehicleLockState(vehicle, false)
        vanEntity = vehicle
    end)
    
    LR.showObjective(locale("product_selling"), locale("enter_van"))
    
    -- Wait for player to enter van
    while cache.vehicle ~= vanEntity do
        Wait(500)
    end
    
    -- Create blip for plane spawn
    local planeSpawnBlip = Utils.createBlip(spawnLocation, missionConfig.plane.blip)
    SetBlipRotation(planeSpawnBlip.value, math.ceil(spawnLocation.w))
    SetBlipRoute(planeSpawnBlip.value, true)
    SetBlipPriority(planeSpawnBlip.value, 9)
    SetBlipAsShortRange(planeSpawnBlip.value, false)
    AddBlip(planeSpawnBlip)
    
    LR.showObjective(locale("product_selling"), locale("go_to_plane"))
    
    -- Wait for player to get near plane spawn
    if not WaitForDistance(spawnLocation, 100.0) then
        return
    end
    
    -- Spawn plane
    local planePromise = promise.new()
    Framework.spawnVehicle(missionConfig.plane.model, spawnLocation.xyz, spawnLocation.w, function(vehicle)
        planePromise:resolve(vehicle)
        Editable.addKeys(vehicle)
        Editable.setVehicleLockState(vehicle, false)
    end)
    
    planeEntity = Citizen.Await(planePromise)
    
    -- Wait for player to get close to plane
    if not WaitForDistance(spawnLocation, 20.0) then
        return
    end
    
    -- Package count to load
    local packagesRemaining = deliveryCount
    LR.showObjective(locale("product_selling"), locale("move_packages_plane", 0, packagesRemaining))
    
    -- Create van interaction point for taking packages
    local vanInteractionPoint = Utils.createEntityPoint({
        entity = vanEntity,
        offset = missionConfig.van.offset,
        radius = 2.0,
        options = {
            {
                label = locale("take_package"),
                icon = "box",
                onSelect = AttachCargoProp,
                canInteract = function()
                    return not carryingPropEntity and not cache.vehicle
                end
            }
        }
    })
    
    -- Create plane interaction point for storing packages
    local totalPackages = packagesRemaining
    local planeInteractionPoint = Utils.createEntityPoint({
        entity = planeEntity,
        offset = missionConfig.plane.offset,
        radius = 2.0,
        options = {
            {
                label = locale("put_package"),
                icon = "box",
                onSelect = function()
                    packagesRemaining = packagesRemaining - 1
                    DeleteEntity(carryingPropEntity)
                    ClearPedTasks(cache.ped)
                    carryingPropEntity = nil
                    
                    if packagesRemaining > 0 then
                        LR.showObjective(
                            locale("product_selling"), 
                            locale("move_packages_plane", totalPackages - packagesRemaining, totalPackages)
                        )
                    end
                end,
                canInteract = function()
                    return carryingPropEntity and not cache.vehicle
                end
            }
        }
    })
    
    -- Monitor plane health
    CreateThread(function()
        while isMissionActive do
            if not DoesEntityExist(planeEntity) or not IsVehicleDriveable(planeEntity, true) then
                CancelMission(locale("plane_destroyed"))
                return
            end
            Wait(500)
        end
    end)
    
    -- Wait for all packages to be loaded (while monitoring van)
    while packagesRemaining > 0 do
        if not isMissionActive then
            return
        end
        
        if not DoesEntityExist(vanEntity) or not IsVehicleDriveable(vanEntity, true) then
            CancelMission(locale("van_destroyed"))
            return
        end
        
        Wait(500)
    end
    
    -- All packages loaded, remove interaction points
    vanInteractionPoint.remove()
    planeInteractionPoint.remove()
    
    LR.showObjective(locale("product_selling"), locale("enter_plane"))
    
    -- Wait for player to enter plane
    while cache.vehicle ~= planeEntity do
        if not isMissionActive then
            return
        end
        Wait(500)
    end
    
    -- Notify server player is in vehicle
    TriggerServerEvent(
        "lunar_illegalbusiness:plane:insideVehicle", 
        NetworkGetNetworkIdFromEntity(planeEntity),
        NetworkGetNetworkIdFromEntity(vanEntity)
    )
    
    ClearAllBlips()
    
    -- Get random delivery locations
    local deliveryLocations = GetRandomDeliveryLocations(deliveryCount)
    
    -- Track blips and particles per location
    local locationBlips = {}
    local locationParticles = {}
    
    -- Request particle asset
    local particleAsset = "core"
    local particleName = "exp_grd_flare"
    lib.requestNamedPtfxAsset(particleAsset)
    
    -- Create blips and flares at each delivery location
    for i = 1, #deliveryLocations do
        local location = deliveryLocations[i]
        
        local deliveryBlip = Utils.createBlip(location, missionConfig.deliveryBlip)
        SetBlipAsShortRange(deliveryBlip.value, false)
        SetBlipPriority(deliveryBlip.value, 9)
        
        local radiusBlip = Utils.createRadiusBlip(location, "", 100.0, missionConfig.deliveryBlip.color)
        AddBlip(deliveryBlip, radiusBlip)
        
        locationBlips[i] = {deliveryBlip, radiusBlip}
        
        -- Create flare particle effect
        UseParticleFxAssetNextCall(particleAsset)
        locationParticles[i] = StartParticleFxLoopedAtCoord(
            particleName,
            location.x, location.y, location.z - 1.0,
            0.0, 0.0, 0.0,
            1.5, false, false, false, false
        )
    end
    
    local deliveredCount = 0
    LR.showObjective(locale("product_selling"), locale("deliver_locations", 0, deliveryCount))
    
    -- Delivery monitoring thread
    CreateThread(function()
        while deliveredCount < deliveryCount do
            local heightAboveGround = GetEntityHeightAboveGround(planeEntity)
            
            if cache.vehicle ~= planeEntity then
                -- Player left vehicle, skip this iteration
            elseif not isMissionActive then
                -- Mission cancelled, stop particles and exit
                for i = 1, #locationParticles do
                    if locationParticles[i] then
                        StopParticleFxLooped(locationParticles[i], false)
                    end
                end
                return
            else
                -- Check each delivery location
                for i = 1, #deliveryLocations do
                    local location = deliveryLocations[i]
                    
                    if locationBlips[i] then
                        local distance2D = #(location.xy - GetEntityCoords(cache.ped).xy)
                        
                        if distance2D < 70.0 then
                            -- Check if plane is too high
                            if heightAboveGround > missionConfig.maxHeightAboveGround then
                                LR.notify(locale("plane_too_high"), "error")
                                break
                            end
                            
                            -- Deliver package
                            TriggerServerEvent("lunar_illegalbusiness:plane:deliverProduct")
                            deliveredCount = deliveredCount + 1
                            
                            LR.showObjective(
                                locale("product_selling"), 
                                locale("deliver_locations", deliveredCount, deliveryCount)
                            )
                            
                            -- Remove blips for this location
                            locationBlips[i][1].remove()
                            locationBlips[i][2].remove()
                            locationBlips[i] = nil
                            
                            -- Stop particle after delay
                            local particleIndex = i
                            SetTimeout(30000, function()
                                StopParticleFxLooped(locationParticles[particleIndex], false)
                                locationParticles[particleIndex] = nil
                            end)
                            
                            -- Drop package visual
                            OpenBombBayDoors(cache.vehicle)
                            lib.requestModel(377646791)
                            Wait(500)
                            
                            LR.notify(locale("package_delivered"), "success")
                            
                            local vehicleCoords = GetEntityCoords(cache.vehicle)
                            local droppedPackage = CreateObject(
                                377646791, 
                                vehicleCoords.x, vehicleCoords.y, vehicleCoords.z - 1.0, 
                                true, true, false
                            )
                            
                            local velocity = GetEntityVelocity(droppedPackage)
                            SetEntityVelocity(droppedPackage, velocity.x, velocity.y, -2.0)
                            SetEntityAsNoLongerNeeded(droppedPackage)
                            
                            Wait(1500)
                            CloseBombBayDoors(cache.vehicle)
                        end
                    end
                end
            end
            
            Wait(200)
        end
        
        -- All deliveries complete, create payout
        CreatePayoutPed()
    end)
end

-- Register the plane selling mission
RegisterSellingMission(MISSION_NAME, {
    start = StartPlaneMission
})