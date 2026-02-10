-- Client-side Helicopter Selling Mission

local MISSION_NAME = "heli"
local missionConfig = Config.sellingMissions[MISSION_NAME]

-- Mission state
local isMissionActive = false
local activeBlips = {}
local helicopterEntity = nil
local heliInteractionPoint = nil
local carryingPropEntity = nil
local totalDeliveries = nil

-- Active delivery peds indexed by location
local deliveryPeds = {}

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

-- Attaches a product prop to the player for carrying
local function AttachProductProp(args)
    local business = args.business
    local businessType = args.type
    
    if carryingPropEntity then
        return
    end
    
    -- Determine prop variant based on equipment level
    local propVariant = "upgraded"
    if business and business.equipment == "high" then
        propVariant = "upgraded"
    end
    
    local propConfig = businessType.product.prop[propVariant]
    if not propConfig then
        propConfig = businessType.product.prop
    end
    
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
                TriggerServerEvent("lunar_illegalbusiness:heli:payout")
                LR.hideObjective()
                isMissionActive = false
                
                -- Play handshake animation
                lib.requestAnimDict("mp_common")
                TaskPlayAnim(ped, "mp_common", "givetake1_a", 2.0, 1.0, 2000, 16)
                Wait(3000)
                
                payoutPed.free()
                
                -- Have ped drive away in helicopter
                if Utils.distanceCheck(ped, helicopterEntity, 100.0) then
                    TaskEnterVehicle(ped, helicopterEntity, 20000, -1, 2.0, 1, 0)
                    
                    while GetScriptTaskStatus(ped, "SCRIPT_TASK_ENTER_VEHICLE") ~= 7 do
                        Wait(100)
                    end
                    
                    TaskVehicleDriveWander(ped, helicopterEntity, 20.0, 703)
                end
            end
        }
    })
    
    local payoutBlip = Utils.createBlip(payoutLocation, missionConfig.payoutPed.blip)
    SetBlipRoute(payoutBlip.value, true)
    AddBlip(payoutBlip)
    
    LR.showObjective(locale("product_selling"), locale("go_to_payout"))
end

-- Handles delivering a product to a specific location
local function DeliverProduct(locationIndex)
    if not deliveryPeds[locationIndex] then
        return
    end
    
    local delivered, total = lib.callback.await("lunar_illegalbusiness:heli:deliverProduct", false, locationIndex)
    
    if delivered < total then
        LR.notify(locale("delivered", delivered, total), "inform")
    else
        LR.notify(locale("all_delivered"), "success")
        
        deliveryPeds[locationIndex].markAsNotNeeded()
        deliveryPeds[locationIndex] = nil
        
        local remainingPeds = Utils.getTableSize(deliveryPeds)
        LR.showObjective(
            locale("product_selling"), 
            locale("deliver_locations", totalDeliveries - remainingPeds, totalDeliveries)
        )
        
        -- All deliveries complete - create payout
        if remainingPeds == 0 then
            heliInteractionPoint.remove()
            ClearAllBlips()
            CreatePayoutPed()
        end
    end
    
    -- Remove carrying prop
    DeleteEntity(carryingPropEntity)
    carryingPropEntity = nil
end

-- Main mission start function
function StartHeliMission(business)
    local businessName = business.name
    local locationConfig = Config.locations[businessName]
    
    local spawnIndex, deliveryCount = lib.callback.await("lunar_illegalbusiness:heli:getLocationIndex", false)
    local spawnLocation = missionConfig.spawnLocations[spawnIndex]
    totalDeliveries = deliveryCount
    
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
        if not isMissionActive then
            return
        end
        
        if vanEntity then
            if not DoesEntityExist(vanEntity) or not IsVehicleDriveable(vanEntity, true) then
                CancelMission(locale("van_destroyed"))
                return
            end
        end
        
        Wait(500)
    end
    
    -- Create blip for helicopter spawn
    local heliSpawnBlip = Utils.createBlip(spawnLocation, missionConfig.helicopter.blip)
    SetBlipRoute(heliSpawnBlip.value, true)
    AddBlip(heliSpawnBlip)
    
    LR.showObjective(locale("product_selling"), locale("go_to_heli"))
    
    -- Wait for player to get near helicopter spawn
    if not WaitForDistance(spawnLocation, 100.0) then
        return
    end
    
    -- Spawn helicopter
    local heliPromise = promise.new()
    Framework.spawnVehicle(missionConfig.helicopter.model, spawnLocation.xyz, spawnLocation.w, function(vehicle)
        heliPromise:resolve(vehicle)
        lib.setVehicleProperties(vehicle, {color1 = 0})
        Editable.addKeys(vehicle)
        Editable.setVehicleLockState(vehicle, false)
    end)
    
    helicopterEntity = Citizen.Await(heliPromise)
    
    -- Monitor helicopter health
    CreateThread(function()
        while isMissionActive do
            if helicopterEntity then
                if not DoesEntityExist(helicopterEntity) or not IsVehicleDriveable(helicopterEntity, true) then
                    CancelMission(locale("heli_destroyed"))
                    return
                end
            end
            Wait(500)
        end
    end)
    
    -- Wait for player to get close to helicopter
    if not WaitForDistance(spawnLocation, 20.0) then
        return
    end
    
    -- Package count to move
    local packagesRemaining = deliveryCount
    LR.showObjective(locale("product_selling"), locale("move_packages_heli", 0, packagesRemaining))
    
    -- Create van interaction point for taking packages
    local vanInteractionPoint = Utils.createEntityPoint({
        entity = vanEntity,
        offset = missionConfig.van.offset,
        radius = 2.0,
        options = {
            {
                label = locale("take_package"),
                icon = "box",
                onSelect = AttachProductProp,
                args = {
                    business = business,
                    type = Config.businessTypes[locationConfig.type]
                },
                canInteract = function()
                    return not carryingPropEntity and not cache.vehicle
                end
            }
        }
    })
    
    -- Create helicopter interaction point for storing/taking packages
    local totalPackages = packagesRemaining
    heliInteractionPoint = Utils.createEntityPoint({
        entity = helicopterEntity,
        offset = missionConfig.helicopter.offset,
        radius = 2.0,
        options = {
            {
                label = locale("take_package"),
                icon = "box",
                onSelect = AttachProductProp,
                args = {
                    business = business,
                    type = Config.businessTypes[locationConfig.type]
                },
                canInteract = function()
                    return not carryingPropEntity
                end
            },
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
                            locale("move_packages_heli", totalPackages - packagesRemaining, totalPackages)
                        )
                    end
                end,
                canInteract = function()
                    return carryingPropEntity and not cache.vehicle
                end
            }
        }
    })
    
    -- Wait for all packages to be loaded
    while packagesRemaining > 0 do
        if not isMissionActive then
            return
        end
        Wait(500)
    end
    
    -- All packages loaded, remove van interaction
    vanInteractionPoint.remove()
    
    LR.showObjective(locale("product_selling"), locale("enter_heli"))
    
    -- Wait for player to enter helicopter
    while cache.vehicle ~= helicopterEntity do
        if not isMissionActive then
            return
        end
        Wait(500)
    end
    
    -- Notify server player is in vehicle
    TriggerServerEvent(
        "lunar_illegalbusiness:heli:insideVehicle", 
        NetworkGetNetworkIdFromEntity(helicopterEntity),
        NetworkGetNetworkIdFromEntity(vanEntity)
    )
    
    ClearAllBlips()
    
    -- Get random delivery locations
    local deliveryLocations = GetRandomDeliveryLocations(deliveryCount)
    
    LR.showObjective(locale("product_selling"), locale("deliver_locations", 0, deliveryCount))
    
    -- Create blips and peds at each delivery location
    for i = 1, #deliveryLocations do
        local location = deliveryLocations[i]
        
        local deliveryBlip = Utils.createBlip(location, missionConfig.deliveryBlip)
        AddBlip(deliveryBlip)
        
        deliveryPeds[i] = Utils.createPed(location, -245247470, {
            {
                label = locale("give_package"),
                icon = "box",
                onSelect = DeliverProduct,
                args = i,
                canInteract = function()
                    return carryingPropEntity
                end
            }
        })
    end
end

-- Register the helicopter selling mission
RegisterSellingMission(MISSION_NAME, {
    start = StartHeliMission
})