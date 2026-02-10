local MISSION_TYPE = "cartel"
local missionConfig = Config.resupplyMissions[MISSION_TYPE]
local missionActive = false
local cleanupHandlers = {}

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
    Utils.distanceWait(targetCoords, maxDistance)
    return missionActive
end

function MonitorGuardBlip(guardNetId)
    local guardBlip = nil
    while true do
        if missionActive then
            if NetworkDoesEntityExistWithNetworkId(guardNetId) then
                local guardEntity = NetworkGetEntityFromNetworkId(guardNetId)
                if IsEntityDead(guardEntity) then
                    guardBlip.remove()
                    break
                end
                if not guardBlip then
                    guardBlip = Utils.createEntityBlip(guardEntity, missionConfig.guard.blip)
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

function StartCartelMission(businessName)
    local businessLocation = Config.locations[businessName]
    local locationIndex = lib.callback.await("lunar_illegalbusiness:cartel:getLocationIndex", false)
    local missionLocation = missionConfig.locations[locationIndex]
    local targetCoords = missionLocation.coords

    if not targetCoords then
        return
    end

    Interior.exit()

    local destinationBlip = Utils.createBlip(targetCoords, missionConfig.destinationBlip)
    SetBlipRoute(destinationBlip.value, true)
    local radiusBlip = Utils.createRadiusBlip(targetCoords, missionConfig.destinationBlip.name, 100.0, missionConfig.destinationBlip.color)

    LR.showObjective(locale("resupply_mission"), locale("go_to_cartel"))
    missionActive = true
    AddCleanupHandlers(destinationBlip, radiusBlip)

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

    if not WaitForPlayerDistance(targetCoords, 400.0) then
        return
    end

    local suppliesVehicleNetId, guardNetIds = lib.callback.await("lunar_illegalbusiness:cartel:spawnEntities", false)

    if not WaitForPlayerDistance(targetCoords, 200.0) then
        return
    end

    RunCleanupHandlers()
    LR.showObjective(locale("resupply_mission"), locale("steal_supplies_van"))

    for i = 1, #guardNetIds do
        CreateThread(function()
            MonitorGuardBlip(guardNetIds[i])
        end)
    end

    while not NetworkDoesEntityExistWithNetworkId(suppliesVehicleNetId) do
        Wait(0)
    end

    local suppliesVehicle = NetworkGetEntityFromNetworkId(suppliesVehicleNetId)

    local vehicleBlip = Utils.createEntityBlip(suppliesVehicle, missionConfig.suppliesBlip)
    SetBlipPriority(vehicleBlip.value, 9)
    AddCleanupHandlers(vehicleBlip)

    while cache.vehicle ~= suppliesVehicle do
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
                    local deliverySuccess = lib.callback.await("lunar_illegalbusiness:cartel:deliverSupplies", false)
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

local guardPoints = {}

function ConfigureGuardPed(guardPed)
    SetPedDropsWeaponsWhenDead(guardPed, false)
    SetPedCombatAbility(guardPed, missionConfig.guard.combatAbility)
    SetPedAccuracy(guardPed, missionConfig.guard.accuracy)
    SetPedRelationshipGroupHash(guardPed, 1145918567)
    SetPedCombatAttributes(guardPed, 5, true)
    SetPedCombatAttributes(guardPed, 13, true)
    SetPedCombatAttributes(guardPed, 68, false)
    SetPedCurrentWeaponVisible(guardPed, true)
end

local combatTriggered = false

function HandleGuardBehavior(guardPed)
    if not GetIsTaskActive(guardPed, 357) then
        if not GetIsTaskActive(guardPed, 343) then
            if math.random(1, 8) == 1 then
                TaskGuardCurrentPosition(guardPed, 15.0, 10.0, true)
            end
        end
    end

    if not combatTriggered then
        combatTriggered = GetIsTaskActive(guardPed, 343)
    end

    if combatTriggered then
        if not GetIsTaskActive(guardPed, 343) then
            TaskCombatHatedTargetsAroundPed(guardPed, 400.0, 0)
            SetPedAlertness(guardPed, 3)
        end
    end
end

AddRelationshipGroup("CARTEL_GUARD")

function ProcessGuardLogic(guardNetIds)
    SetRelationshipBetweenGroups(0, 1145918567, 1145918567)
    SetRelationshipBetweenGroups(5, 1145918567, 1862763509)
    SetRelationshipBetweenGroups(5, 1862763509, 1145918567)

    for i = 1, #guardNetIds do
        local guardNetId = guardNetIds[i]
        if NetworkDoesEntityExistWithNetworkId(guardNetId) then
            local guardEntity = NetworkGetEntityFromNetworkId(guardNetId)
            if NetworkGetEntityOwner(guardEntity) == cache.playerId then
                ConfigureGuardPed(guardEntity)
                HandleGuardBehavior(guardEntity)
            end
        end
    end
end

RegisterNetEvent("lunar_illegalbusiness:cartel:handleGuardsLogic", function(locationId, guardCoords, guardNetIds)
    local point = lib.points.new({
        coords = guardCoords,
        distance = 420.0,
        nearby = function()
            ProcessGuardLogic(guardNetIds)
            Wait(500)
        end
    })
    guardPoints[locationId] = point
end)

RegisterNetEvent("lunar_illegalbusiness:cartel:removeGuards", function(locationId)
    guardPoints[locationId]:remove()
    guardPoints[locationId] = nil
    combatTriggered = false
end)

local spawnedProps = {}

RegisterNetEvent("lunar_illegalbusiness:cartel:spawnProps", function(locationId, propsData)
    local props = {}
    for i = 1, #propsData do
        local propData = propsData[i]
        local propCoords = propData.coords
        local propEntity = CreateObject(propData.model, propCoords.x, propCoords.y, propCoords.z, false, true, false)
        SetEntityHeading(propEntity, propCoords.w)
        FreezeEntityPosition(propEntity, true)

        CreateThread(function()
            Utils.distanceWait(propCoords, 420.0)
            while IsEntityWaitingForWorldCollision(propEntity) do
                Wait(200)
            end
            while true do
                local currentCoords = GetEntityCoords(propEntity)
                local distFromOrigin = #(currentCoords - propCoords.xyz)
                if not (distFromOrigin < 0.5) then
                    break
                end
                PlaceObjectOnGroundProperly(propEntity)
                Wait(100)
            end
        end)

        props[#props + 1] = propEntity
    end
    spawnedProps[locationId] = props
end)

RegisterNetEvent("lunar_illegalbusiness:cartel:deleteProps", function(locationId)
    for i = 1, #spawnedProps[locationId] do
        DeleteEntity(spawnedProps[locationId][i])
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= cache.resource then
        return
    end
    for _, props in pairs(spawnedProps) do
        for i = 1, #props do
            DeleteEntity(props[i])
        end
    end
end)

RegisterResupplyMission(MISSION_TYPE, {
    start = StartCartelMission
})