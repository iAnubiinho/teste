local MISSION_TYPE = "bikers"
local missionConfig = Config.resupplyMissions[MISSION_TYPE]
local missionActive = false
local cleanupHandlers = {}
local suppliesVehicle = nil

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

function MonitorGuardBlip(guardNetId)
    local guardBlip = nil
    while true do
        if missionActive then
            if NetworkDoesEntityExistWithNetworkId(guardNetId) then
                local guardEntity = NetworkGetEntityFromNetworkId(guardNetId)
                if IsEntityDead(guardEntity) then
                    if guardBlip then
                        guardBlip.remove()
                    end
                    break
                end
                if not guardBlip then
                    if IsPedInCombat(guardEntity, cache.ped) then
                        guardBlip = Utils.createEntityBlip(guardEntity, missionConfig.guard.blip)
                    end
                end
            end
        elseif guardBlip then
            guardBlip.remove()
            guardBlip = nil
        end
        if not missionActive then
            return
        end
        Wait(500)
    end
end

function SpawnLocalVehicle(spawnCoords, velocity)
    RequestCollisionAtCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z)

    suppliesVehicle = CreateVehicle(-1745203402, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, false, true)

    CreateThread(function()
        while not HasCollisionLoadedAroundEntity(suppliesVehicle) do
            RequestCollisionAtCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z)
            Wait(0)
        end
    end)

    SetVehicleHasBeenOwnedByPlayer(suppliesVehicle, true)
    SetVehicleNeedsToBeHotwired(suppliesVehicle, false)
    SetVehRadioStation(suppliesVehicle, "OFF")
    SetModelAsNoLongerNeeded(model)

    local vehicleBlip = Utils.createEntityBlip(suppliesVehicle, missionConfig.suppliesBlip)
    SetBlipPriority(vehicleBlip.value, 9)
    SetBlipAsShortRange(vehicleBlip.value, false)
    SetBlipRoute(vehicleBlip.value, true)
    AddCleanupHandlers(vehicleBlip)

    lib.requestModel(missionConfig.guard.model)
    local guardSpawnCoords = Utils.offsetCoords(spawnCoords, 2.0, 0.0, 0.0)
    local guardPed = CreatePed(4, missionConfig.guard.model, guardSpawnCoords.x, guardSpawnCoords.y, guardSpawnCoords.z, guardSpawnCoords.w, false, true)
    SetPedIntoVehicle(guardPed, suppliesVehicle, -1)
    TaskVehicleDriveWander(guardPed, suppliesVehicle, 20.0, 1074528293)
    SetEntityVelocity(suppliesVehicle, velocity)
end

function CleanupLocalVehicle()
    if suppliesVehicle then
        if NetworkGetEntityIsLocal(suppliesVehicle) then
            local driverPed = GetPedInVehicleSeat(suppliesVehicle, -1)
            DeleteEntity(driverPed)
            DeleteEntity(suppliesVehicle)
        end
    end
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= cache.resource then
        return
    end
    CleanupLocalVehicle()
end)

function SpawnNetworkedVehicle(spawnCoords, velocity)
    local vehicleNetId, guardNetIds = lib.callback.await("lunar_illegalbusiness:bikers:spawnVehicle", false, spawnCoords, velocity)
    if not guardNetIds then
        return
    end

    for i = 2, #guardNetIds do
        CreateThread(function()
            MonitorGuardBlip(guardNetIds[i])
        end)
    end

    while not NetworkDoesEntityExistWithNetworkId(vehicleNetId) do
        Wait(0)
    end

    suppliesVehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

    local vehicleBlip = Utils.createEntityBlip(suppliesVehicle, missionConfig.suppliesBlip)
    SetBlipPriority(vehicleBlip.value, 9)
    SetBlipAsShortRange(vehicleBlip.value, false)
    SetBlipFlashInterval()
    AddCleanupHandlers(vehicleBlip)
end

function HandleVehicleProximity(spawnCoords)
    local isLocalEntity = false
    local reinforcementWarned = false

    lib.requestModel(-1745203402)
    SpawnLocalVehicle(spawnCoords)

    local vehicleData = {}
    local proximityInterval = SetInterval(function()
        local playerCoords = GetEntityCoords(cache.ped)
        local vehicleCoords = GetEntityCoords(suppliesVehicle)
        local distance = #(playerCoords - vehicleCoords)

        if DoesEntityExist(suppliesVehicle) then
            vehicleData.coords = GetEntityCoords(suppliesVehicle)
            vehicleData.coords = vector4(vehicleData.coords.x, vehicleData.coords.y, vehicleData.coords.z, GetEntityHeading(suppliesVehicle))
            vehicleData.velocity = GetEntityVelocity(suppliesVehicle)
        end

        if distance < 400.0 then
            if not isLocalEntity then
                CleanupLocalVehicle()
                SpawnNetworkedVehicle(vehicleData.coords, vehicleData.velocity)
                isLocalEntity = true
            end
        elseif distance >= 400.0 then
            if isLocalEntity then
                TriggerServerEvent("lunar_illegalbusiness:bikers:vehicleTooFar")
                lib.requestModel(-1745203402)
                while DoesEntityExist(suppliesVehicle) do
                    Wait(0)
                end
                SpawnLocalVehicle(vehicleData.coords, vehicleData.velocity)
                isLocalEntity = false
            end
        elseif distance > 300.0 then
            if not reinforcementWarned then
                if isLocalEntity then
                    LR.notify(locale("possible_reinforcement"), "inform")
                    reinforcementWarned = true
                end
            end
        end
    end, 200)

    CreateThread(function()
        while true do
            if not missionActive then
                break
            end
            if cache.vehicle == suppliesVehicle then
                break
            end
            Wait(200)
        end
        ClearInterval(proximityInterval)
    end)
end

function StartBikersMission(businessName)
    local businessLocation = Config.locations[businessName]
    local missionLocation = Utils.randomFromTable(missionConfig.locations)
    if not missionLocation then
        return
    end

    Interior.exit()
    missionActive = true

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

    HandleVehicleProximity(missionLocation)

    LR.showObjective(locale("resupply_mission"), locale("go_to_bikers"))

    while true do
        if cache.vehicle == suppliesVehicle then
            break
        end
        if DoesEntityExist(suppliesVehicle) then
            if not IsVehicleDriveable(suppliesVehicle, false) then
                FailMission(locale("supplies_destroyed"))
                return
            end
        end
        if DoesEntityExist(suppliesVehicle) then
            if Utils.distanceCheck(cache.ped, suppliesVehicle, 50.0) then
                LR.showObjective(locale("resupply_mission"), locale("steal_supplies_van"))
            end
        end
        Wait(500)
    end

    RunCleanupHandlers()
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
                    local deliverySuccess = lib.callback.await("lunar_illegalbusiness:bikers:deliverSupplies", false)
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

local guardIntervals = {}

function ConfigureGuardPed(guardPed)
    SetPedDropsWeaponsWhenDead(guardPed, false)
    SetPedCombatAbility(guardPed, missionConfig.guard.combatAbility)
    SetPedAccuracy(guardPed, missionConfig.guard.accuracy)
    SetPedRelationshipGroupHash(guardPed, -1978173708)
    SetPedCombatAttributes(guardPed, 5, true)
    SetPedCombatAttributes(guardPed, 13, true)
    SetPedCombatAttributes(guardPed, 68, false)
    SetPedCurrentWeaponVisible(guardPed, true)
end

local vehicleEscortTracking = {}

function HandleGuardVehicleBehavior(targetVehicle, guardPed)
    local guardVehicle = GetVehiclePedIsIn(guardPed, false)
    if guardVehicle == 0 then
        local lastVehicle = GetVehiclePedIsIn(guardPed, true)
        TaskEnterVehicle(guardPed, lastVehicle, 0, -1, 2.0, 1)
    end

    if not GetIsTaskActive(guardPed, 343) then
        if not GetIsTaskActive(guardPed, 295) then
            if guardVehicle ~= targetVehicle then
                TaskVehicleEscort(guardPed, guardVehicle, targetVehicle, 1, 25.0, 1074528293, 10.0, 0, 0.0)
            else
                TaskVehicleDriveWander(guardPed, guardVehicle, 15.0, 1074528293)
            end
        end
    end

    local driverPed = GetPedInVehicleSeat(targetVehicle, -1)
    local driverModel = GetEntityModel(driverPed)
    if driverModel ~= missionConfig.guard.model then
        TaskCombatPed(guardPed, driverPed, 0, 16)
    end

    if not vehicleEscortTracking[targetVehicle] then
        vehicleEscortTracking[targetVehicle] = GetIsTaskActive(guardPed, 343)
    end

    if vehicleEscortTracking[targetVehicle] then
        if not GetIsTaskActive(guardPed, 343) then
            SetRelationshipBetweenGroups(5, -1978173708, 1862763509)
            SetRelationshipBetweenGroups(5, 1862763509, -1978173708)
        end
    end
end

AddRelationshipGroup("MC_GANG_MEMBER")

function ProcessGuardLogic(vehicleNetId, guardNetIds)
    SetRelationshipBetweenGroups(0, -1978173708, -1978173708)
    SetRelationshipBetweenGroups(4, -1978173708, 1862763509)
    SetRelationshipBetweenGroups(4, 1862763509, -1978173708)

    if not NetworkDoesEntityExistWithNetworkId(vehicleNetId) then
        return
    end

    local vehicleEntity = NetworkGetEntityFromNetworkId(vehicleNetId)

    for i = 1, #guardNetIds do
        local guardNetId = guardNetIds[i]
        if NetworkDoesEntityExistWithNetworkId(guardNetId) then
            local guardEntity = NetworkGetEntityFromNetworkId(guardNetId)
            if NetworkGetEntityOwner(guardEntity) == cache.playerId then
                ConfigureGuardPed(guardEntity)
                HandleGuardVehicleBehavior(vehicleEntity, guardEntity)
            end
        end
    end
end

RegisterNetEvent("lunar_illegalbusiness:bikers:handleGuardsLogic", function(locationId, vehicleNetId, guardNetIds)
    guardIntervals[locationId] = SetInterval(function()
        ProcessGuardLogic(vehicleNetId, guardNetIds)
    end, 500)
end)

RegisterNetEvent("lunar_illegalbusiness:bikers:removeGuards", function(locationId)
    ClearInterval(guardIntervals[locationId])
    guardIntervals[locationId] = nil
end)

RegisterResupplyMission(MISSION_TYPE, {
    start = StartBikersMission
})