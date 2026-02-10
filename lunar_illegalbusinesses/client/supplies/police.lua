local MISSION_TYPE = "police"
local missionConfig = Config.resupplyMissions[MISSION_TYPE]
local missionActive = false
local cleanupHandlers = {}

CreateThread(function()
    local iplObject = exports.bob74_ipl:GetImportVehicleWarehouseObject()
    iplObject.Upper.Style.Set(iplObject.Upper.Style.basic)
    RefreshInterior(iplObject.Upper.interiorId)
end)

function AddCleanupHandlers(...)
    local handlers = {...}
    for i = 1, #handlers do
        cleanupHandlers[#cleanupHandlers + 1] = handlers[i]
    end
end

function RunCleanupHandlers()
    for i = 1, #cleanupHandlers do
        cleanupHandlers[i].remove()
    end
    table.wipe(cleanupHandlers)
end

function FailMission(message)
    TriggerServerEvent("lunar_illegalbusiness:cancelSuppliesMission")
    LR.notify(message, "error")
    LR.hideObjective()
    RunCleanupHandlers()
    missionActive = false
end

RegisterNetEvent("lunar_illegalbusiness:suppliesMissionCanceled", function()
    RunCleanupHandlers()
    LR.hideObjective()
    missionActive = false
end)

function WaitForPlayerDistance(targetCoords, maxDistance)
    Utils.distanceWait(targetCoords.xyz, maxDistance)
    return missionActive
end

local hackScene = nil
local hackSceneObjects = {}

function StartHackAnimation()
    local animDict = "anim@heists@ornate_bank@hack"
    local animClip = "hack_loop"
    local sceneProps = {
        { model = -676527372, clip = "hack_loop_laptop" }
    }

    lib.requestAnimDict(animDict)
    local pedCoords = GetEntityCoords(cache.ped)
    local pedHeading = GetEntityHeading(cache.ped)

    hackScene = NetworkCreateSynchronisedScene(pedCoords.x, pedCoords.y, pedCoords.z + 0.4, 0.0, 0.0, pedHeading, 2, false, true, 0, 1.0, 1.0)

    NetworkAddPedToSynchronisedScene(cache.ped, hackScene, animDict, animClip, 3.0, 3.0, 16, 1148846080, 0)

    for i = 1, #sceneProps do
        local propData = sceneProps[i]
        lib.requestModel(propData.model)
        local propEntity = CreateObject(propData.model, pedCoords.x, pedCoords.y, pedCoords.z, true, true, false)
        SetEntityNoCollisionEntity(propEntity, cache.ped, false)
        NetworkAddEntityToSynchronisedScene(propEntity, hackScene, animDict, propData.clip, 1.0, 1.0, 1)
        hackSceneObjects[#hackSceneObjects + 1] = propEntity
    end

    NetworkStartSynchronisedScene(hackScene)
end

function StopHackAnimation()
    NetworkStopSynchronisedScene(hackScene)
    for i = 1, #hackSceneObjects do
        DeleteEntity(hackSceneObjects[i])
    end
end

function StartPoliceMission(businessName)
    local businessLocation = Config.locations[businessName]
    local locationIndex = lib.callback.await("lunar_illegalbusiness:police:getLocationIndex", false)
    local missionLocation = missionConfig.locations[locationIndex]

    if not missionLocation then
        return
    end

    Interior.exit()

    local destinationBlip = Utils.createBlip(missionLocation.coords, missionConfig.destinationBlip)
    SetBlipRoute(destinationBlip.value, true)

    LR.showObjective(locale("resupply_mission"), locale("go_to_warehouse"))
    missionActive = true
    AddCleanupHandlers(destinationBlip)

    if missionConfig.failOnDeath then
        CreateThread(function()
            while missionActive do
                if Editable.isDead(cache.ped) then
                    FailMission(locale("you_died"))
                    return
                end
                Wait(500)
            end
        end)
    end

    if not WaitForPlayerDistance(missionLocation.coords, 50.0) then
        return
    end

    local vehicleNetId = lib.callback.await("lunar_illegalbusiness:police:spawnEntities", false)
    local suppliesVehicle = nil

    LR.showObjective(locale("resupply_mission"), locale("go_inside_warehouse"))

    CreateThread(function()
        local interactionPoint = nil
        local isHacking = nil
        while true do
            if not missionActive then
                break
            end

            if NetworkDoesEntityExistWithNetworkId(vehicleNetId) then
                suppliesVehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
            else
                suppliesVehicle = nil
            end

            if not missionActive then
                return
            end

            if not interactionPoint then
                if suppliesVehicle then
                    LR.showObjective(locale("resupply_mission"), locale("hack_van"))

                    interactionPoint = Utils.createEntityPoint({
                        entity = suppliesVehicle,
                        offset = vector3(-1.0, 1.0, 0.4),
                        radius = 1.0,
                        options = {
                            {
                                label = locale("hack_police_van"),
                                icon = "code",
                                onSelect = function()
                                    if isHacking then
                                        return
                                    end
                                    isHacking = true

                                    Editable.hideActiveWeapon()
                                    StartHackAnimation()

                                    LR.progressBar(locale("starting_hack"), 1500, false)

                                    local hackSuccess = Editable.hackingMinigame(missionConfig.minigame)
                                    if hackSuccess then
                                        if not Editable.isDead(cache.ped) then
                                            TriggerServerEvent("lunar_illegalbusiness:police:hacked")
                                            Editable.addKeys(suppliesVehicle)
                                            interactionPoint.remove()
                                        end
                                    end

                                    StopHackAnimation()
                                    isHacking = false
                                end
                            }
                        }
                    })
                end
            elseif interactionPoint then
                if not suppliesVehicle then
                    interactionPoint.remove()
                    interactionPoint = nil
                end
            end
            Wait(500)
        end
    end)

    while cache.vehicle ~= suppliesVehicle do
        Wait(500)
    end

    RunCleanupHandlers()
    LR.showObjective(locale("resupply_mission"), locale("exit_police_warehouse"))

    if not WaitForPlayerDistance(missionLocation.coords, 10.0) then
        return
    end

    LR.showObjective(locale("resupply_mission"), locale("deliver_van"))

    local dropoffCoords = businessLocation.vehicleSpawn
    local dropoffBlip = Utils.createBlip(dropoffCoords, {
        name = locale("supplies_dropoff"),
        sprite = 1,
        color = 2,
        size = 0.75
    })
    SetBlipRoute(dropoffBlip.value, true)
    AddCleanupHandlers(dropoffBlip)

    local uiShown = false
    local deliveryActive = true

    local deliveryPoint = lib.points.new({
        coords = dropoffCoords.xyz,
        distance = 100.0,
        nearby = function(self)
            if not missionActive then
                self:remove()
                return
            end

            local vehicleCoords = GetEntityCoords(suppliesVehicle)
            local distanceToDropoff = #(self.coords - vehicleCoords)
            local vehicleHeading = GetEntityHeading(suppliesVehicle)

            if vehicleHeading < 0.0 then
                vehicleHeading = 360.0 + vehicleHeading
            end

            local headingDiffWrapped = (vehicleHeading - dropoffCoords.w + 180) % 360 - 180
            local headingDiffAlt = (vehicleHeading - dropoffCoords.w) % 360 - 180

            local isInPosition = distanceToDropoff < 1.0

            if isInPosition then
                if not uiShown then
                    LR.showUI(locale("deliver_supplies"), "truck")
                    uiShown = true
                end
            elseif uiShown then
                LR.hideUI()
                uiShown = false
            end

            if isInPosition then
                if IsControlJustReleased(0, 38) then
                    local deliverySuccess = lib.callback.await("lunar_illegalbusiness:police:deliverSupplies", false)
                    if deliverySuccess then
                        TaskLeaveAnyVehicle(cache.ped)
                        LR.hideUI()
                        LR.hideObjective()
                        self:remove()
                        RunCleanupHandlers()
                        deliveryActive = false
                        missionActive = false
                        SetTimeout(1000, function()
                            Interior.enter(businessName, false)
                        end)
                        return
                    end
                end
            end

            if not deliveryActive then
                return
            end

            local colorR, colorG, colorB
            if isInPosition then
                colorR, colorG, colorB = 50, 255, 50
            else
                colorR, colorG, colorB = 255, 150, 50
            end

            RenderRotatedBox(dropoffCoords.x, dropoffCoords.y, dropoffCoords.z, 6.0, 3.75, 5.0, dropoffCoords.w + 90, colorR, colorG, colorB, 100)
        end
    })

    while deliveryActive do
        if DoesEntityExist(suppliesVehicle) and IsVehicleDriveable(suppliesVehicle, false) then
        else
            FailMission(locale("supplies_destroyed"))
            deliveryPoint:remove()
            break
        end
        Wait(200)
    end
end

function ConfigureGuardPed(guardPed)
    SetPedDropsWeaponsWhenDead(guardPed, false)
    SetPedCombatAbility(guardPed, missionConfig.guard.combatAbility)
    SetPedAccuracy(guardPed, missionConfig.guard.accuracy)
    SetPedRelationshipGroupHash(guardPed, -325466320)
    SetPedCombatAttributes(guardPed, 5, true)
    SetPedCombatAttributes(guardPed, 68, false)
    SetPedCombatAttributes(guardPed, 28, true)
    SetPedCombatAttributes(guardPed, 21, true)
    SetPedCurrentWeaponVisible(guardPed, true)

    local combatMovement = math.random(4)
    if combatMovement == 1 then
        combatMovement = 1
    end
    combatMovement = 2
    SetPedCombatMovement(guardPed, combatMovement)

    SetBlockingOfNonTemporaryEvents(guardPed, true)

    local guardCoords = GetEntityCoords(guardPed)
    local playerZ = GetEntityCoords(cache.ped).z
    local heightDiff = playerZ - guardCoords.z
    if heightDiff > 1.0 then
        SetEntityCoords(guardPed, guardCoords.x, guardCoords.y, guardCoords.z + 2.0)
        PlaceObjectOnGroundProperly(guardPed)
    end
end

function FindNearestCombatTarget(guardPed)
    local guardCoords = GetEntityCoords(guardPed)
    local nearbyPlayers = lib.getNearbyPlayers(guardCoords, 100.0, true)
    local nearestTarget = nil
    local nearestDistance = math.huge

    for i = 1, #nearbyPlayers do
        local playerData = nearbyPlayers[i]
        local playerDistance = #(playerData.coords - guardCoords)

        if nearestDistance > playerDistance then
            if missionConfig.guard.ignorePolice then
                local playerState = Player(GetPlayerServerId(playerData.id)).state
                if playerState.isPolice then
                    goto continue
                end
            end

            if not Editable.isDead(playerData.ped) then
                nearestDistance = playerDistance
                nearestTarget = playerData
            end
        end
        ::continue::
    end

    if nearestTarget then
        if not GetIsTaskActive(guardPed, 343) then
            TaskCombatPed(guardPed, nearestTarget.ped, 0, 16)
        end
    else
        if not GetIsTaskActive(guardPed, 357) then
            TaskGuardCurrentPosition(guardPed, 15.0, 10.0, true)
        end
    end
end

AddRelationshipGroup("POLICE_OFFICER_AI")

function ProcessGuardLogic(guardNetIds)
    SetRelationshipBetweenGroups(0, -325466320, -325466320)
    SetRelationshipBetweenGroups(4, -325466320, 1862763509)
    SetRelationshipBetweenGroups(4, 1862763509, -325466320)

    for i = 1, #guardNetIds do
        local guardNetId = guardNetIds[i]
        if NetworkDoesEntityExistWithNetworkId(guardNetId) then
            local guardEntity = NetworkGetEntityFromNetworkId(guardNetId)
            if NetworkGetEntityOwner(guardEntity) == cache.playerId then
                if not IsEntityDead(guardEntity) then
                    ConfigureGuardPed(guardEntity)
                    FindNearestCombatTarget(guardEntity)
                end
            end
        end
    end
end

local coveredVehicleModels = {
    1171954070,
    -239044249,
    -2063295939,
    726001049,
    -556906753,
    -758434067,
    -812602640
}

local insideWarehouse = false
local scriptCamera = nil

function CreateWarehouseCamera()
    local camPosition = GetOffsetFromEntityInWorldCoords(cache.ped, 1.5, -0.5, 0.5)
    scriptCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camPosition.x, camPosition.y, camPosition.z, 0.0, 0.0, 0.0, 70.0, true, 2)

    local lookAtPosition = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 2.0, 0.0)
    PointCamAtCoord(scriptCamera, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z)
    RenderScriptCams(true, false, 1, false)
end

function DestroyWarehouseCamera()
    if scriptCamera then
        RenderScriptCams(false, false, 1, false)
        DestroyCam(scriptCamera, true)
        scriptCamera = nil
    end
end

function EnterWarehouse(warehouseData)
    RunCleanupHandlers()

    local ownerServerId = warehouseData.owner
    local entranceCoords = warehouseData.enteranceCoords
    local guardNetIds = warehouseData.netIds

    insideWarehouse = true

    local playerState = Player(cache.serverId).state
    playerState:set("isPolice", Utils.isPolice(), true)

    TriggerServerEvent("lunar_illegalbusiness:police:enterWarehouse", ownerServerId)
    SetEntityCoords(cache.ped, entranceCoords.x, entranceCoords.y, entranceCoords.z - 1.0)
    SetEntityHeading(cache.ped, entranceCoords.w)

    CreateWarehouseCamera()
    lib.requestAnimDict("anim@apt_trans@garage")

    CreateThread(function()
        LR.progressBar(locale("entering_warehouse"), 3000, false, {
            dict = "anim@apt_trans@garage",
            clip = "gar_open_1_left",
            flag = 1
        })
    end)

    Wait(2000)
    DoScreenFadeOut(1000)
    Wait(1000)
    DestroyWarehouseCamera()

    local interiorCoords = missionConfig.interior.coords
    SetEntityCoords(cache.ped, interiorCoords.x, interiorCoords.y, interiorCoords.z)
    SetEntityHeading(cache.ped, interiorCoords.w)
    ClearPedTasks(cache.ped)
    PlaceObjectOnGroundProperly(cache.ped)
    SetGameplayCamRelativeHeading(0.0)

    Wait(1000)
    DoScreenFadeIn(1000)

    while not RequestScriptAudioBank("ALARM_KLAXON_03", false) do
        Wait(0)
    end

    local alarmSoundId = GetSoundId()
    local alarmCoords = missionConfig.interior.alarmCoords
    PlaySoundFromCoord(alarmSoundId, "ALARMS_KLAXON_03_CLOSE", alarmCoords.x, alarmCoords.y, alarmCoords.z, "", false, 200, false)

    local coveredVehicleEntities = {}
    for i = 1, #missionConfig.interior.coveredVehicles do
        local vehicleCoords = missionConfig.interior.coveredVehicles[i]
        local randomModel = Utils.randomFromTable(coveredVehicleModels)
        local vehicleEntity = CreateObjectNoOffset(randomModel, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, false, true, false)
        SetEntityHeading(vehicleEntity, vehicleCoords.w)
        PlaceObjectOnGroundProperly(vehicleEntity)
        coveredVehicleEntities[#coveredVehicleEntities + 1] = vehicleEntity
    end

    local guardInterval = SetInterval(function()
        ProcessGuardLogic(guardNetIds)
    end, 500)

    local exitPoint = nil
    local exitInteraction = Utils.createInteractionPoint({
        coords = missionConfig.interior.coords,
        radius = 2.0,
        options = {
            {
                label = locale("exit_warehouse"),
                icon = "right-from-bracket",
                onSelect = function()
                    for i = 1, #coveredVehicleEntities do
                        DeleteEntity(coveredVehicleEntities[i])
                    end

                    if guardInterval and exitPoint then
                        ClearInterval(guardInterval)
                        exitPoint.remove()
                    end

                    TriggerServerEvent("lunar_illegalbusiness:police:leaveWarehouse", ownerServerId)
                    insideWarehouse = false

                    if not cache.vehicle then
                        SetEntityCoords(cache.ped, interiorCoords.x, interiorCoords.y, interiorCoords.z - 1.0)
                        SetEntityHeading(cache.ped, interiorCoords.w + 180.0)
                        CreateWarehouseCamera()
                        lib.requestAnimDict("anim@apt_trans@garage")

                        CreateThread(function()
                            LR.progressBar(locale("exiting_warehouse"), 3000, false, {
                                dict = "anim@apt_trans@garage",
                                clip = "gar_open_1_left",
                                flag = 1
                            })
                        end)

                        Wait(2000)
                    end

                    DoScreenFadeOut(1000)
                    Wait(1000)
                    DestroyWarehouseCamera()

                    local entityToMove = cache.vehicle or cache.ped
                    SetEntityCoords(entityToMove, entranceCoords.x, entranceCoords.y, entranceCoords.z)
                    SetEntityHeading(entityToMove, entranceCoords.w + 180.0)
                    ClearPedTasks(cache.ped)
                    PlaceObjectOnGroundProperly(cache.ped)
                    SetGameplayCamRelativeHeading(0.0)
                    StopSound(alarmSoundId)

                    Wait(1000)
                    DoScreenFadeIn(1000)
                end,
                canInteract = function()
                    return insideWarehouse == true
                end
            }
        }
    }, false)
    exitPoint = exitInteraction
end

local warehouseEntrances = {}

RegisterNetEvent("lunar_illegalbusiness:police:addEntrance", function(ownerServerId, locationIndex, guardNetIds)
    local locationData = missionConfig.locations[locationIndex]

    local entrance = Utils.createInteractionPoint({
        coords = locationData.target,
        radius = 2.0,
        options = {
            {
                label = locale("enter_warehouse"),
                icon = "warehouse",
                onSelect = EnterWarehouse,
                args = {
                    owner = ownerServerId,
                    enteranceCoords = locationData.coords,
                    netIds = guardNetIds
                },
                canInteract = function()
                    return insideWarehouse == false
                end
            }
        }
    })
    warehouseEntrances[ownerServerId] = entrance
end)

RegisterNetEvent("lunar_illegalbusiness:police:removeGuards", function(ownerServerId)
    warehouseEntrances[ownerServerId]:remove()
    warehouseEntrances[ownerServerId] = nil
end)

Utils.entityStateHandler("freeze", function(entity, key, value)
    if value then
        if NetworkGetEntityOwner(entity) == cache.serverId then
        end
    end
    do return end
    SetVehicleOnGroundProperly(entity)
    Editable.setVehicleLockState(entity, true)
end, true)

Utils.entityStateHandler("hacked", function(entity, key, value)
    if value then
        if NetworkGetEntityOwner(entity) == cache.serverId then
        end
    end
    do return end
    FreezeEntityPosition(entity, false)
    Editable.setVehicleLockState(entity, false)
end, true)

RegisterResupplyMission(MISSION_TYPE, {
    start = StartPoliceMission
})