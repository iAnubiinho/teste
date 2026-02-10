-- Interior Management - Business Interior Loading, UI, and Interactions

Interior = {}
SuppliesMissions = {}

-- Current business state
currentBusinessName = nil
currentBusinessData = nil
currentLocationConfig = nil
currentBusinessTypeConfig = nil
isRaidMode = nil

-- Active interaction points in the interior
activeInteractionPoints = {}

-- Active security guard entities
activeSecurityGuards = {}

-- Teleport camera reference
teleportCamera = nil

-- Guard ped models by business type
GUARD_PED_MODELS = {
    meth = -306958529,
    coke = 1456705429,
    weed = -306958529,
    counterfeit_factory = 1456705429,
    document_forgery = -306958529
}

-- Guard ped variants by business type
GUARD_PED_VARIANTS = {
    meth = 2,
    coke = 1,
    weed = 2,
    counterfeit_factory = 1,
    document_forgery = 2
}

-- Restore player position if they were in a business on reconnect
Framework.onPlayerLoaded(function()
    local lastBusiness = GetResourceKvpString("lunar_illegalbusiness:lastBusiness")
    
    if lastBusiness then
        local locationConfig = Config.locations[lastBusiness]
        if not locationConfig then
            return
        end
        
        SetTimeout(1000, function()
            local coords = locationConfig.coords
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            SetEntityCoords(cache.ped, coords.x, coords.y, coords.z - 0.8)
            SetEntityHeading(cache.ped, coords.w)
            PlaceObjectOnGroundProperly(cache.ped)
            SetResourceKvp("lunar_illegalbusiness:lastBusiness", "")
        end)
    end
end)

-- Returns whether a teleport is in progress
function IsTeleporting()
    return teleportCamera ~= nil
end

-- Creates a scripted camera for teleport transition
function CreateTeleportCamera()
    local cameraOffset = GetOffsetFromEntityInWorldCoords(cache.ped, 2.0, -0.25, 0.5)
    
    teleportCamera = CreateCamWithParams(
        "DEFAULT_SCRIPTED_CAMERA",
        cameraOffset.x, cameraOffset.y, cameraOffset.z,
        0.0, 0.0, 0.0, 50.0, true, 2
    )
    
    local lookAtOffset = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, -0.1, 0.5)
    PointCamAtCoord(teleportCamera, lookAtOffset.x, lookAtOffset.y, lookAtOffset.z)
    RenderScriptCams(true, false, 1, false)
end

-- Destroys the teleport camera
function DestroyTeleportCamera()
    if teleportCamera then
        RenderScriptCams(false, false, 1, false)
        DestroyCam(teleportCamera, true)
        teleportCamera = nil
    end
end

-- Performs the teleport transition between locations
function PerformTeleportTransition(fromCoords, toCoords, playAnimation)
    if playAnimation then
        lib.requestAnimDict("anim@apt_trans@hinge_l")
        
        CreateThread(function()
            SetEntityCoords(cache.ped, fromCoords.x, fromCoords.y, fromCoords.z - 1.0)
            SetEntityHeading(cache.ped, fromCoords.w + 180.0)
            CreateTeleportCamera()
            
            local offsetCoords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, -1.75, 0.0)
            SetEntityCoords(cache.ped, offsetCoords.x, offsetCoords.y, offsetCoords.z - 1.0)
            TaskPlayAnim(cache.ped, "anim@apt_trans@hinge_l", "ext_player", 8.0, 8.0, 2000, 1, 1.0, false, false, false)
        end)
        
        Wait(800)
    end
    
    DoScreenFadeOut(750)
    RequestCollisionAtCoord(toCoords.x, toCoords.y, toCoords.z)
    Wait(1000)
    
    DestroyTeleportCamera()
    SetArtificialLightsState(false)
    SetEntityVisible(cache.ped, false, false)
    SetEntityCoords(cache.ped, toCoords.x, toCoords.y, toCoords.z)
    SetEntityHeading(cache.ped, toCoords.w)
    SetGameplayCamRelativeHeading(0.0)
    PlaceObjectOnGroundProperly(cache.ped)
    Wait(500)
    
    if not currentBusinessName then
        SetTimeout(1250, function()
            DoScreenFadeIn(500)
            SetEntityVisible(cache.ped, true, false)
        end)
    end
end

-- NUI Callback: Upgrade equipment
RegisterNUICallback("upgrade_equipment", function(data, cb)
    cb({})
    
    local success = lib.callback.await("lunar_illegalbusiness:upgradeEquipment", false)
    
    if success then
        Wait(3000)
        LR.notify(locale("upgraded_equipment"), "success")
    else
        LR.notify(locale("not_enough_" .. Config.equipment.account), "error")
    end
end)

-- NUI Callback: Upgrade employees
RegisterNUICallback("upgrade_employees", function(data, cb)
    cb({})
    
    local success = lib.callback.await("lunar_illegalbusiness:upgradeEmployees", false)
    
    if success then
        Wait(3000)
        LR.notify(locale("upgraded_employees"), "success")
    else
        LR.notify(locale("not_enough_" .. Config.employees.account), "error")
    end
end)

-- NUI Callback: Upgrade security
RegisterNUICallback("upgrade_security", function(data, cb)
    cb({})
    
    local success = lib.callback.await("lunar_illegalbusiness:buySecurity", false)
    
    if success then
        Wait(3000)
        LR.notify(locale("upgraded_security"), "success")
    else
        LR.notify(locale("not_enough_" .. Config.security.account), "error")
    end
end)

-- NUI Callback: Buy supplies
RegisterNUICallback("buy_supplies", function(data, cb)
    cb({})
    
    if currentBusinessData.supplies == 100 then
        LR.notify(locale("supplies_full"), "error")
        return
    end
    
    local success = lib.callback.await("lunar_illegalbusiness:buySupplies")
    
    if success then
        Wait(3000)
        LR.notify(locale("bought_supplies"), "success")
    else
        LR.notify(locale("not_enough_" .. Config.supplies.account), "error")
    end
end)

-- NUI Callback: Steal supplies (start resupply mission)
RegisterNUICallback("steal_supplies", function(data, cb)
    cb({})
    
    if currentBusinessData.supplies == 100 then
        LR.notify(locale("supplies_full"), "error")
        return
    end
    
    StartResupplyMission(currentBusinessName)
end)

-- NUI Callback: Sell products (start selling mission)
RegisterNUICallback("sell_products", function(data, cb)
    cb({})
    
    if currentBusinessData.products < 25 then
        LR.notify(locale("not_enough_product"), "error")
        return
    end
    
    StartSellingMission(currentBusinessData)
end)

-- NUI Callback: Give keys to another player
RegisterNUICallback("give_keys", function(targetPlayerId, cb)
    TriggerServerEvent("lunar_illegalbusiness:giveKeys", targetPlayerId)
    cb({})
end)

-- NUI Callback: Remove keys from a player
RegisterNUICallback("remove_keys", function(identifier, cb)
    TriggerServerEvent("lunar_illegalbusiness:removeKeys", identifier)
    LR.notify(locale("removed_keys"), "success")
    cb({})
end)

-- NUI Callback: Transfer business ownership
RegisterNUICallback("transfer_ownership", function(targetPlayerId, cb)
    TriggerServerEvent("lunar_illegalbusiness:transferOwnership", targetPlayerId)
    cb({})
end)

-- Calculates the estimated product value
function CalculateProductValue()
    local avgPrice = (currentBusinessTypeConfig.product.price.max + currentBusinessTypeConfig.product.price.min) / 2
    local value = currentBusinessData.products * avgPrice
    
    if currentBusinessData.equipment == "high" then
        value = value * Config.product.multipliers.equipmentUpgrade
    end
    
    return math.floor(value)
end

-- Opens the business management UI
function OpenManagementUI()
    if Editable.isDead(cache.ped) then
        return
    end
    
    local uiData = {
        type = currentLocationConfig.type,
        image = currentLocationConfig.image,
        supplies = currentBusinessData.supplies,
        products = currentBusinessData.products,
        worth = CalculateProductValue(),
        upgrades = {
            currentBusinessData.equipment == "high",
            currentBusinessData.employees == "high",
            currentBusinessData.security
        },
        keys = lib.callback.await("lunar_illegalbusiness:getBusinessKeys", false),
        isOwner = IsOwner(currentBusinessData.name),
        characterName = Framework.getCharacterName()
    }
    
    UI.open("management", uiData, true)
end

-- Exits the business interior
function Interior.exit(playAnimation)
    UI.hide()
    currentBusinessName = nil
    
    PerformTeleportTransition(
        currentBusinessTypeConfig.interior.exit.coords,
        currentLocationConfig.coords,
        playAnimation
    )
    
    TriggerServerEvent("lunar_illegalbusiness:exit")
    SetResourceKvp("lunar_illegalbusiness:lastBusiness", "")
    
    -- Unload IPL
    IPLs[currentLocationConfig.type].unload()
    
    -- Remove interaction points
    for _, point in ipairs(activeInteractionPoints) do
        point:remove()
    end
    table.wipe(activeInteractionPoints)
end

-- Opens the CCTV camera view
function OpenCCTVCamera()
    if Editable.isDead(cache.ped) then
        return
    end
    
    Utils.makeEntityFaceCoords(cache.ped, currentBusinessTypeConfig.interior.cctv)
    
    lib.requestAnimDict("anim@amb@warehouse@laptop@")
    TaskPlayAnim(cache.ped, "anim@amb@warehouse@laptop@", "idle_a", 8.0, 8.0, -1, 11, 1.0, false, false, false)
    
    LR.progressBar(locale("opening_cctv"), 1500, false)
    
    local playerCoords = GetEntityCoords(cache.ped)
    local playerHeading = GetEntityHeading(cache.ped)
    local cameraCoords = Utils.offsetCoords(currentLocationConfig.camera, 0.0, 0.25, 0.0)
    
    DoScreenFadeOut(500)
    Wait(500)
    
    -- Clone player ped for camera view
    local clonePed = ClonePed(cache.ped, true, true, true)
    NetworkSetEntityInvisibleToNetwork(cache.ped, true)
    SetEntityVisible(cache.ped, false, false)
    
    lib.requestAnimDict("anim@amb@warehouse@laptop@")
    TaskPlayAnim(clonePed, "anim@amb@warehouse@laptop@", "idle_a", 8.0, 8.0, -1, 11, 1.0, false, false, false)
    
    -- Move real player below ground
    SetEntityCoords(cache.ped, cameraCoords.x, cameraCoords.y, cameraCoords.z - 8.5)
    FreezeEntityPosition(cache.ped, true)
    
    TriggerServerEvent("lunar_illegalbusiness:openedCamera", NetworkGetNetworkIdFromEntity(clonePed))
    Wait(500)
    
    -- Set up camera
    local scaleform = lib.requestScaleformMovie("TRAFFIC_CAM")
    if scaleform then
        PushScaleformMovieFunction(scaleform, "PLAY_CAM_MOVIE")
        PopScaleformMovieFunctionVoid()
    end
    
    local cameraObject = GetClosestObjectOfType(cameraCoords.x, cameraCoords.y, cameraCoords.z, 5.0, 548760764, false)
    local cctvCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cameraCoords.x, cameraCoords.y, cameraCoords.z, 0.0, 0.0, cameraCoords.w, 60.0, true, 2)
    
    SetCamActive(cctvCamera, true)
    RenderScriptCams(true, false, 1, false)
    SetTimecycleModifier("scanline_cam_cheap")
    SetTimecycleModifierStrength(1.0)
    SetEntityVisible(cameraObject, false)
    DoScreenFadeIn(500)
    
    LR.showUI(locale("cctv_controls"))
    RequestAmbientAudioBank("Phone_Soundset_Franklin", false)
    RequestAmbientAudioBank("HintCamSounds", false)
    
    -- Camera rotation limits
    local baseHeading = cameraCoords.w < 0.0 and (180.0 + cameraCoords.w) or cameraCoords.w
    local rotationLimits = { left = 90, right = -90, up = 45.0, down = -45.0 }
    
    -- Camera control loop
    CreateThread(function()
        while true do
            DisableAllControlActions(0)
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(9)
            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(19)
            HideHudAndRadarThisFrame()
            
            -- Exit camera
            if IsDisabledControlJustReleased(0, 38) then
                LR.hideUI()
                DoScreenFadeOut(500)
                Wait(500)
                
                TriggerServerEvent("lunar_illegalbusiness:closedCamera")
                SetEntityVisible(cameraObject, true)
                DestroyCam(cctvCamera)
                RenderScriptCams(false, false, 1, false)
                
                SetEntityCoords(cache.ped, playerCoords.x, playerCoords.y, playerCoords.z - 1.0)
                SetEntityHeading(cache.ped, playerHeading)
                FreezeEntityPosition(cache.ped, false)
                Wait(200)
                
                NetworkSetEntityInvisibleToNetwork(cache.ped, false)
                SetEntityVisible(cache.ped, true, false)
                
                if scaleform then
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                end
                
                ClearTimecycleModifier()
                Wait(500)
                DoScreenFadeIn(500)
                return
            end
            
            -- Get current camera rotation
            local currentRot = GetCamRot(cctvCamera, 2)
            local normalizedZ = currentRot.z < 0.0 and (360.0 + currentRot.z) or currentRot.z
            local relativeDiff = ((normalizedZ - baseHeading + 180) % 360) - 180
            
            -- Draw scaleform overlay
            if scaleform then
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
            end
            
            -- Camera rotation controls
            if IsDisabledControlPressed(0, Config.camera.controls.left) then
                if relativeDiff < rotationLimits.left then
                    currentRot = vector3(currentRot.x, currentRot.y, currentRot.z + Config.camera.rotateSpeed)
                end
            end
            
            if IsDisabledControlPressed(0, Config.camera.controls.right) then
                if relativeDiff > rotationLimits.right then
                    currentRot = vector3(currentRot.x, currentRot.y, currentRot.z - Config.camera.rotateSpeed)
                end
            end
            
            if IsDisabledControlPressed(0, Config.camera.controls.up) then
                if currentRot.x < rotationLimits.up then
                    currentRot = vector3(currentRot.x + Config.camera.rotateSpeed, currentRot.y, currentRot.z)
                end
            end
            
            if IsDisabledControlPressed(0, Config.camera.controls.down) then
                if currentRot.x > rotationLimits.down then
                    currentRot = vector3(currentRot.x - Config.camera.rotateSpeed, currentRot.y, currentRot.z)
                end
            end
            
            SetCamRot(cctvCamera, currentRot.x, currentRot.y, currentRot.z, 2)
            Wait(0)
        end
    end)
end

-- Event: Remove temporary ped (camera clone) when owner leaves camera
RegisterNetEvent("lunar_illegalbusiness:removeTempPed", function(netId)
    if NetworkDoesEntityExistWithNetworkId(netId) then
        local entity = NetworkGetEntityFromNetworkId(netId)
        if NetworkGetEntityOwner(entity) ~= cache.serverId then
            return
        end
        DeleteEntity(entity)
    end
end)

-- Spawns security guard peds in the interior
function SpawnSecurityGuards()
    -- Clear existing guards
    for i = 1, #activeSecurityGuards do
        DeleteEntity(activeSecurityGuards[i])
    end
    table.wipe(activeSecurityGuards)
    
    if not currentBusinessData.security or isRaidMode then
        return
    end
    
    local guardModel = GUARD_PED_MODELS[currentLocationConfig.type]
    lib.requestModel(guardModel)
    
    for _, guardCoords in ipairs(currentBusinessTypeConfig.interior.guards) do
        local guard = CreatePed(4, guardModel, guardCoords.x, guardCoords.y, guardCoords.z - 1.0, guardCoords.w, false, true)
        
        FreezeEntityPosition(guard, true)
        SetBlockingOfNonTemporaryEvents(guard, true)
        SetEntityInvincible(guard, true)
        GiveWeaponToPed(guard, Config.guards.weapon, 200, true, true)
        TaskStartScenarioInPlace(guard, Config.guards.scenario)
        SetPedCanBeTargetted(guard, false)
        
        -- Apply ped variation
        local variant = GUARD_PED_VARIANTS[currentLocationConfig.type]
        for component = 0, 11 do
            SetPedComponentVariation(guard, component, variant, 0, 1)
        end
        
        activeSecurityGuards[#activeSecurityGuards + 1] = guard
    end
    
    SetModelAsNoLongerNeeded(guardModel)
end

-- Confiscate products during a raid
function ConfiscateProducts()
    if Editable.isDead(cache.ped) then
        return
    end
    
    local success = LR.progressBar(locale("confiscating_product"), 5000, false, {
        scenario = "PROP_HUMAN_BUM_BIN"
    })
    
    if success then
        TriggerServerEvent("lunar_illegalbusiness:confiscateProduct")
        LR.notify(locale("confiscated_product"), "success")
    end
end

-- Take out products as inventory items
function TakeOutProducts()
    if Editable.isDead(cache.ped) then
        return
    end
    
    local confirmed = lib.alertDialog({
        header = locale("take_out_products"),
        content = locale("take_out_products_content"),
        centered = true,
        cancel = true
    })
    
    if confirmed == "confirm" then
        TriggerServerEvent("lunar_illegalbusiness:takeOutProducts")
    end
end

-- Creates all interaction points in the interior
function CreateInteriorInteractionPoints()
    -- Clear existing points
    for i = 1, #activeInteractionPoints do
        activeInteractionPoints[i].remove()
    end
    table.wipe(activeInteractionPoints)
    
    -- Exit door
    activeInteractionPoints[#activeInteractionPoints + 1] = Utils.createInteractionPoint({
        coords = currentBusinessTypeConfig.interior.exit.target,
        radius = 1.0,
        options = {
            {
                label = locale("exit_business"),
                icon = "door-open",
                onSelect = function()
                    if not Editable.isDead(cache.ped) then
                        Interior.exit(true)
                    end
                end,
                canInteract = function()
                    return not IsTeleporting()
                end
            }
        }
    })
    
    -- Stash (if equipment is set up)
    if currentBusinessData.equipment ~= "none" then
        local stashConfig = currentBusinessTypeConfig.interior.stash
        
        if type(stashConfig) == "table" then
            -- Stash is a prop
            activeInteractionPoints[#activeInteractionPoints + 1] = Utils.createProp(stashConfig.coords, {
                model = stashConfig.model,
                offset = vector3(0.0, 0.0, -0.6),
                rotation = vector3(0.0, 0.0, -90.0)
            }, {
                {
                    label = locale("stash"),
                    icon = "boxes",
                    onSelect = Editable.openStash,
                    args = currentBusinessData.stash
                }
            })
        else
            -- Stash is just coordinates
            activeInteractionPoints[#activeInteractionPoints + 1] = Utils.createInteractionPoint({
                coords = stashConfig,
                radius = 1.0,
                options = {
                    {
                        label = locale("stash"),
                        icon = "boxes",
                        onSelect = Editable.openStash,
                        args = currentBusinessData.stash
                    }
                }
            })
        end
    end
    
    -- Check player access for laptop
    local hasAccess = currentBusinessData.keys[Framework.getIdentifier()] or currentBusinessData.identifier == Framework.getIdentifier()
    
    -- Laptop (management and setup)
    activeInteractionPoints[#activeInteractionPoints + 1] = Utils.createInteractionPoint({
        coords = currentBusinessTypeConfig.interior.laptop,
        radius = 1.0,
        options = {
            {
                label = locale("laptop"),
                icon = "laptop",
                onSelect = OpenManagementUI,
                canInteract = function()
                    return currentBusinessData.equipment ~= "none"
                end
            },
            {
                label = locale("setup_business"),
                icon = "laptop",
                onSelect = StartSetupMission,
                args = currentBusinessName,
                canInteract = function()
                    return currentBusinessData.equipment == "none"
                end
            }
        }
    })
    
    -- CCTV (if security is enabled)
    if currentBusinessData.security then
        activeInteractionPoints[#activeInteractionPoints + 1] = Utils.createInteractionPoint({
            coords = currentBusinessTypeConfig.interior.cctv,
            radius = 1.0,
            options = {
                {
                    label = locale("cctv"),
                    icon = "camera",
                    onSelect = OpenCCTVCamera
                }
            }
        })
    end
    
    -- Product interactions (take out + confiscate during raid)
    if currentBusinessTypeConfig.product.item then
        activeInteractionPoints[#activeInteractionPoints + 1] = Utils.createInteractionPoint({
            coords = currentBusinessTypeConfig.interior.confiscate,
            radius = 1.0,
            options = {
                {
                    label = locale("take_out_products"),
                    icon = "boxes",
                    onSelect = TakeOutProducts
                }
            }
        })
        
        -- Confiscate option for police during raids
        if currentBusinessData.products > 0 then
            activeInteractionPoints[#activeInteractionPoints + 1] = Utils.createInteractionPoint({
                coords = currentBusinessTypeConfig.interior.confiscate,
                radius = 1.0,
                options = {
                    {
                        label = locale("confiscate_product"),
                        icon = "hand",
                        onSelect = ConfiscateProducts
                    }
                }
            })
        end
    end
end

-- Shows the overlay UI for the business
function ShowOverlayUI()
    local hasAccess = currentBusinessData.identifier == Framework.getIdentifier() or currentBusinessData.keys[Framework.getIdentifier()]
    
    if not hasAccess then
        return
    end
    
    UI.open("overlay", {
        value = CalculateProductValue(),
        supplies = currentBusinessData.supplies,
        products = currentBusinessData.products
    }, false)
end

-- Updates the overlay UI with new data
function UpdateOverlayUI()
    local hasAccess = currentBusinessData.identifier == Framework.getIdentifier() or currentBusinessData.keys[Framework.getIdentifier()]
    
    if not hasAccess then
        return
    end
    
    UI.update("overlay", {
        value = CalculateProductValue(),
        supplies = currentBusinessData.supplies,
        products = currentBusinessData.products
    }, false)
end

-- Enters a business interior
function Interior.enter(businessName, playAnimation)
    if currentBusinessName then
        return
    end
    
    currentBusinessName = businessName
    
    local businessData, raidOpen = lib.callback.await("lunar_illegalbusiness:enter", false, businessName)
    isRaidMode = raidOpen
    currentBusinessData = businessData
    
    currentLocationConfig = Config.locations[businessName]
    currentBusinessTypeConfig = Config.businessTypes[currentLocationConfig.type]
    
    -- Check if business is seized
    if currentBusinessData.seizedIntervals > 0 then
        LR.notify(locale("business_is_seized"), "error")
        return
    end
    
    -- Set player state for guard targeting
    local hasAccess = currentBusinessData.identifier == Framework.getIdentifier() or currentBusinessData.keys[Framework.getIdentifier()]
    Player(cache.serverId).state:set("hasBusinessAccess", hasAccess, true)
    
    -- Teleport to interior
    PerformTeleportTransition(
        currentLocationConfig.coords,
        currentBusinessTypeConfig.interior.exit.coords,
        playAnimation
    )
    
    -- Load IPL
    IPLs[currentLocationConfig.type].load(currentBusinessData, isRaidMode)
    
    Wait(1250)
    DoScreenFadeIn(500)
    SetEntityVisible(cache.ped, true, false)
    SetResourceKvp("lunar_illegalbusiness:lastBusiness", businessName)
    
    CreateInteriorInteractionPoints()
    SpawnSecurityGuards()
    
    -- Show welcome dialog on first entry
    if not currentBusinessData.entered then
        lib.alertDialog({
            header = locale("welcome_header"),
            content = locale("welcome_content"),
            centered = true,
            labels = { confirm = locale("understood") }
        })
    end
    
    -- Show seized dialog if business was recently seized
    if currentBusinessData.seizedIntervals == 0 then
        lib.alertDialog({
            header = locale("seized_header"),
            content = locale("seized_content"),
            centered = true,
            labels = { confirm = locale("understood") }
        })
    end
    
    SetTimeout(1500, ShowOverlayUI)
end

-- Event: Sync business data updates
RegisterNetEvent("lunar_illegalbusiness:syncBusiness", function(businessData, reloadIPL)
    if #activeInteractionPoints == 0 then
        return
    end
    
    if currentBusinessName ~= businessData.name then
        return
    end
    
    currentBusinessData = businessData
    
    if reloadIPL then
        UI.hide()
        DoScreenFadeOut(750)
        Wait(1000)
        
        -- Remove interaction points
        for _, point in ipairs(activeInteractionPoints) do
            point:remove()
        end
        table.wipe(activeInteractionPoints)
        
        -- Reload IPL
        IPLs[currentLocationConfig.type].unload()
        IPLs[currentLocationConfig.type].load(currentBusinessData)
        
        CreateInteriorInteractionPoints()
        SpawnSecurityGuards()
        
        Wait(1000)
        DoScreenFadeIn(750)
        ShowOverlayUI()
    else
        UpdateOverlayUI()
        IPLs[currentLocationConfig.type].softReload(currentBusinessData)
    end
    
    CreateInteriorInteractionPoints()
end)

-- Event: Remove access (kick from business)
RegisterNetEvent("lunar_illegalbusiness:removeAccess", function(businessName)
    if currentBusinessName == businessName then
        Interior.exit(false)
    end
end)

-- Event: Force exit
RegisterNetEvent("lunar_illegalbusiness:forceExit", function()
    Interior.exit(false)
end)

-- Event: Force raid exit (police only)
RegisterNetEvent("lunar_illegalbusiness:forceRaidExit", function(businessName)
    if currentBusinessName == businessName then
        if Utils.isPolice() then
            Interior.exit(false)
        end
    end
end)

-- Event: Hide UI when closing management panel
AddEventHandler("lunar_illegalbusiness:hideUI", function()
    if currentBusinessName then
        ShowOverlayUI()
    end
end)