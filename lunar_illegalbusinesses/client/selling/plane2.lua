-- Client-side Plane2 Selling Mission (Bag Drop with Cutscene)

local MISSION_NAME = "plane2"
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

-- Attaches a money bag prop to the player for carrying
local function AttachMoneyBagProp()
    if carryingPropEntity then
        return
    end
    
    local propConfig = {
        model = -711724000,
        bone = 28422,
        offset = vector3(0.0, -0.05, -0.25),
        rot = vector3(90.0, 0.0, -78.99),
        dict = "move_weapon@jerrycan@generic",
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

-- Main mission start function
function StartPlane2Mission(business)
    local businessName = business.name
    local locationConfig = Config.locations[businessName]
    
    local spawnIndex, bagCount = lib.callback.await("lunar_illegalbusiness:plane2:getLocationIndex", false)
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
        SetVehicleModColor_2(vehicle, 0, 143)
    end)
    
    planeEntity = Citizen.Await(planePromise)
    
    -- Wait for player to get close to plane
    if not WaitForDistance(spawnLocation, 20.0) then
        return
    end
    
    -- Bag count to load
    local bagsRemaining = bagCount
    local totalBags = bagCount
    LR.showObjective(locale("product_selling"), locale("move_bags", 0, bagsRemaining))
    
    -- Create van interaction point for taking bags
    local vanInteractionPoint = Utils.createEntityPoint({
        entity = vanEntity,
        offset = missionConfig.van.offset,
        radius = 2.0,
        options = {
            {
                label = locale("take_package"),
                icon = "box",
                onSelect = AttachMoneyBagProp,
                canInteract = function()
                    return not carryingPropEntity and not cache.vehicle
                end
            }
        }
    })
    
    -- Create plane interaction point for storing bags
    local planeInteractionPoint = Utils.createEntityPoint({
        entity = planeEntity,
        offset = missionConfig.plane.offset,
        radius = 2.0,
        options = {
            {
                label = locale("put_package"),
                icon = "box",
                onSelect = function()
                    bagsRemaining = bagsRemaining - 1
                    DeleteEntity(carryingPropEntity)
                    ClearPedTasks(cache.ped)
                    carryingPropEntity = nil
                    
                    LR.showObjective(
                        locale("product_selling"), 
                        locale("move_bags", totalBags - bagsRemaining, totalBags)
                    )
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
    
    -- Wait for all bags to be loaded (while monitoring van)
    while bagsRemaining > 0 do
        if not isMissionActive then
            return
        end
        
        if not DoesEntityExist(vanEntity) or not IsVehicleDriveable(vanEntity, true) then
            CancelMission(locale("van_destroyed"))
            return
        end
        
        Wait(500)
    end
    
    -- All bags loaded, remove interaction points
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
    
    ClearAllBlips()
    
    LR.showObjective(locale("product_selling"), locale("deliver_plane"))
    
    -- Create delivery blip
    local deliveryBlip = Utils.createBlip(missionConfig.delivery.coords, missionConfig.delivery.blip)
    SetBlipAsShortRange(deliveryBlip.value, false)
    AddBlip(deliveryBlip)
    
    -- Notify server vehicle was created
    TriggerServerEvent(
        "lunar_illegalbusiness:plane2:createdVehicle", 
        NetworkGetNetworkIdFromEntity(planeEntity),
        NetworkGetNetworkIdFromEntity(vanEntity)
    )
end

-- Plays the multi-player drop off cutscene
local function PlayDropOffCutscene(vehicleOccupants)
    local cutsceneName = "hs3f_all_drp3"
    
    RequestCutscene(cutsceneName)
    while not HasCutsceneLoaded() do
        Wait(0)
    end
    
    DoScreenFadeIn(1000)
    
    local deliveryCoords = missionConfig.delivery.coords
    SetCutsceneOrigin(deliveryCoords.x, deliveryCoords.y, deliveryCoords.z - 1.0, deliveryCoords.w, 0)
    
    SetEntityVisible(cache.ped, false, false)
    NetworkSetEntityInvisibleToNetwork(cache.ped, true)
    
    -- Clone peds for cutscene registration
    local cutsceneClones = {}
    for i = 1, 4 do
        local sourcePed = vehicleOccupants[i] or cache.ped
        local clonePed = ClonePed(sourcePed, false, true)
        
        if not vehicleOccupants[i] then
            SetEntityVisible(clonePed, false, false)
        end
        
        RegisterEntityForCutscene(clonePed, "MP_" .. i, 0, GetEntityModel(clonePed), 64)
        SetCutsceneEntityStreamingFlags("MP_" .. i, 0, 1)
        
        cutsceneClones[#cutsceneClones + 1] = clonePed
    end
    
    StartCutscene(0)
    Wait(10)
    
    -- Apply appearance to clones
    for i = 1, #cutsceneClones do
        ClonePedToTarget(vehicleOccupants[i], cutsceneClones[i])
    end
    
    Wait(9000)
    DoScreenFadeOut(1000)
    Wait(1000)
    StopCutsceneImmediately()
    
    NetworkSetEntityInvisibleToNetwork(cache.ped, false)
    SetEntityVisible(cache.ped, true, true)
    
    -- Clean up clones
    for i = 1, #cutsceneClones do
        DeleteEntity(cutsceneClones[i])
    end
    
    -- If player was the driver, spawn new plane and trigger payout
    if vehicleOccupants[1] == cache.ped then
        Framework.spawnVehicle(
            missionConfig.plane.model, 
            missionConfig.delivery.planeCoords.xyz, 
            missionConfig.delivery.planeCoords.w, 
            function(vehicle)
                Editable.addKeys(vehicle)
                Editable.setVehicleLockState(vehicle, false)
                SetVehicleModColor_2(vehicle, 0, 143)
            end
        )
        
        TriggerServerEvent("lunar_illegalbusiness:plane2:payout")
        ClearAllBlips()
    end
    
    -- Position player based on their seat
    for i = 1, #vehicleOccupants do
        if vehicleOccupants[i] == cache.ped then
            local playerPosition = missionConfig.delivery.playerCoords[i]
            SetEntityCoords(cache.ped, playerPosition.x, playerPosition.y, playerPosition.z)
            SetEntityHeading(cache.ped, playerPosition.w)
            SetGameplayCamRelativeHeading(0.0)
            FreezeEntityPosition(cache.ped, false)
            SetPedConfigFlag(cache.ped, 3, true)
            break
        end
    end
    
    Wait(2000)
    DoScreenFadeIn(1000)
    LR.notify(locale("plane2_finished"), "success")
    ClearAllBlips()
end

-- Handles the delivery cutscene when approaching destination
local function HandleDeliveryCutscene()
    local vehicleOccupants = {}
    local seatCount = GetVehicleModelNumberOfSeats(GetEntityModel(cache.vehicle)) - 2
    
    for seatIndex = -1, seatCount do
        local occupant = GetPedInVehicleSeat(cache.vehicle, seatIndex)
        
        if occupant ~= 0 then
            local playerIndex = NetworkGetPlayerIndexFromPed(occupant)
            local occupantIndex = #vehicleOccupants + 1
            vehicleOccupants[occupantIndex] = occupant
            
            -- Keep tracking player ped updates
            CreateThread(function()
                for _ = 1, 260 do
                    if NetworkIsPlayerActive(playerIndex) then
                        vehicleOccupants[occupantIndex] = GetPlayerPed(playerIndex)
                    end
                    Wait(100)
                end
            end)
        end
    end
    
    -- Create dealer peds at delivery location
    local dealerPeds = {}
    local dealerConfigs = {
        { model = -664900312, offset = vector3(0.0, 0.0, 0.0) },
        { model = -245247470, offset = vector3(2.0, -1.0, 0.0) },
        { model = 691061163, offset = vector3(-2.0, -1.0, 0.0) }
    }
    
    for i = 1, #dealerConfigs do
        local dealerConfig = dealerConfigs[i]
        lib.requestModel(dealerConfig.model)
        
        local dealerCoords = Utils.offsetCoords(
            missionConfig.delivery.coords,
            dealerConfig.offset.x, dealerConfig.offset.y, dealerConfig.offset.z
        )
        
        local dealerPed = CreatePed(
            4, dealerConfig.model,
            dealerCoords.x, dealerCoords.y, dealerCoords.z - 1.0,
            dealerCoords.w + 180.0,
            false, true
        )
        
        TaskStartScenarioInPlace(dealerPed, "WORLD_HUMAN_AA_SMOKE")
        
        for component = 0, 11 do
            SetPedComponentVariation(dealerPed, component, 0, 0, 0)
        end
        
        dealerPeds[#dealerPeds + 1] = dealerPed
    end
    
    -- Load and play landing cutscene
    local cutsceneName = "hs4_vel_lsa_isd"
    RequestCutscene(cutsceneName)
    while not HasCutsceneLoaded() do
        Wait(0)
    end
    
    local playerClone = ClonePed(vehicleOccupants[1], false, true)
    RegisterEntityForCutscene(playerClone, "MP_1", 0, GetEntityModel(playerClone), 64)
    SetCutsceneEntityStreamingFlags("MP_1", 0, 1)
    
    NetworkSetEntityInvisibleToNetwork(cache.ped, true)
    SetEntityVisible(cache.ped, false, false)
    
    StartCutscene(0)
    Wait(10)
    ClonePedToTarget(vehicleOccupants[1], playerClone)
    
    -- If player was driver, process mission completion
    if vehicleOccupants[1] == cache.ped then
        DeleteEntity(cache.vehicle)
        LR.hideObjective()
        isMissionActive = false
    end
    
    TaskLeaveAnyVehicle(cache.ped, 0, 16)
    
    -- Position each player based on their seat
    for i = 1, #vehicleOccupants do
        if vehicleOccupants[i] == cache.ped then
            local playerPosition = missionConfig.delivery.playerCoords[i]
            SetEntityCoords(cache.ped, playerPosition.x, playerPosition.y, playerPosition.z)
            SetEntityHeading(cache.ped, playerPosition.w)
            SetGameplayCamRelativeHeading(0.0)
            FreezeEntityPosition(cache.ped, true)
            SetPedConfigFlag(cache.ped, 3, false)
            break
        end
    end
    
    Wait(11000)
    DoScreenFadeOut(1000)
    Wait(1000)
    StopCutsceneImmediately()
    
    DeleteEntity(playerClone)
    Wait(2000)
    
    -- Clean up dealer peds
    for i = 1, #dealerPeds do
        DeleteEntity(dealerPeds[i])
    end
    
    PlayDropOffCutscene(vehicleOccupants)
end

-- Event: Wait for cutscene trigger when near delivery
RegisterNetEvent("lunar_illegalbusiness:plane2:waitForCutscene", function(vehicleNetId)
    local deliveryCoords = missionConfig.delivery.coords
    
    while true do
        if Utils.distanceCheck(cache.ped, deliveryCoords, 1200.0) then
            if NetworkDoesEntityExistWithNetworkId(vehicleNetId) then
                local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
                
                if cache.vehicle == vehicle then
                    HandleDeliveryCutscene()
                    return
                end
            end
        end
        
        Wait(200)
    end
end)

-- Register the plane2 selling mission
RegisterSellingMission(MISSION_NAME, {
    start = StartPlane2Mission
})