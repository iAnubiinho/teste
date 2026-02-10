
local doorhacked = false
local fuseboxbreaked = false
local PlayerProps = {}
local startdstcheckart = false
local initiatorart = false
local blowndoor = nil
local interiorid = GetInteriorAtCoords(27.478, 143.0223, 97.945)


QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while QBCore == nil do
        Citizen.Wait(100)
    end

    while QBCore.Functions.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    PlayerData = QBCore.Functions.GetPlayerData()

    -- Additional logic can go here if needed after PlayerData is initialized
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    ArtFusebox = CreateObject(GetHashKey('tr_prop_tr_elecbox_01a'), vector3(7.294, 135.976, 88.160), 1, 1, 0)
    SetEntityRotation(ArtFusebox, 1.771, 1.557, -18.506)
    ActivateInteriorEntitySet(interiorid, "set_windows_normal")
    ActivateInteriorEntitySet(interiorid, "set_painting_1")
    ActivateInteriorEntitySet(interiorid, "set_painting_2")
    ActivateInteriorEntitySet(interiorid, "set_painting_3")
    ActivateInteriorEntitySet(interiorid, "set_painting_4")
    ActivateInteriorEntitySet(interiorid, "set_painting_5")
    ActivateInteriorEntitySet(interiorid, "set_painting_6")
    ActivateInteriorEntitySet(interiorid, "set_painting_7")
    ActivateInteriorEntitySet(interiorid, "set_painting_8")
    ActivateInteriorEntitySet(interiorid, "set_painting_9")
    ActivateInteriorEntitySet(interiorid, "set_painting_10")
    ActivateInteriorEntitySet(interiorid, "set_shutters")
    ActivateInteriorEntitySet(interiorid, "egg1") -- (Default with egg)
    ActivateInteriorEntitySet(interiorid, "keypad_01")
    ActivateInteriorEntitySet(interiorid, "slidedoors_unlocked")  -- (door slide animation when near door)
    RefreshInterior(interiorid)
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(job)
    PlayerData.job = job
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    local interiorid = GetInteriorAtCoords(27.478, 143.0223, 97.945)
    ArtFusebox = CreateObject(GetHashKey('tr_prop_tr_elecbox_01a'), vector3(7.294, 135.976, 88.160), 1, 1, 0)
    SetEntityRotation(ArtFusebox, 1.771, 1.557, -18.506)
    ActivateInteriorEntitySet(interiorid, "set_windows_normal")
    ActivateInteriorEntitySet(interiorid, "set_painting_1")
    ActivateInteriorEntitySet(interiorid, "set_painting_2")
    ActivateInteriorEntitySet(interiorid, "set_painting_3")
    ActivateInteriorEntitySet(interiorid, "set_painting_4")
    ActivateInteriorEntitySet(interiorid, "set_painting_5")
    ActivateInteriorEntitySet(interiorid, "set_painting_6")
    ActivateInteriorEntitySet(interiorid, "set_painting_7")
    ActivateInteriorEntitySet(interiorid, "set_painting_8")
    ActivateInteriorEntitySet(interiorid, "set_painting_9")
    ActivateInteriorEntitySet(interiorid, "set_painting_10")
    ActivateInteriorEntitySet(interiorid, "set_shutters")
    ActivateInteriorEntitySet(interiorid, "egg1") -- (Default with egg)
    ActivateInteriorEntitySet(interiorid, "keypad_01")
    ActivateInteriorEntitySet(interiorid, "slidedoors_unlocked")  -- (door slide animation when near door)
    RefreshInterior(interiorid)
end)

--local slidersopen = false
local mainopen = false
local cellgateRopen = false
local cellgateLopen = false
local officedoorsopen = false
local mainvaultopen = false

Citizen.CreateThread(function()
    local MainR = 110411286
    local MainL = 110411286
    local SliderR = -1726883306
    local SliderL = -1726883306
    local CellR = -1508355822
    local CellL = -1508355822
    local OfficeR = 110411286
    local OfficeL = 110411286
    local Mainvault = -660779536


    local MainRCoords = vector3(11.04154, 147.6955, 93.91224) --- ukse rot: 69.750
    local MainLCoords = vector3(11.93743, 150.1374, 93.91224) --- ukse rot: 249.765
    local SliderRCoords = vector3(17.19212, 145.4035, 92.79331) --- ukse rot: 249.796
    local SliderLCoords = vector3(18.09389, 147.8586, 92.79331) --- ukse rot: 69.796
    local CellRCoords = vector3(33.83084, 135.0609, 93.94281) --- ukse rot: 340.112
    local CellLCoords = vector3(37.47181, 144.9566, 93.91935) --- ukse rot: 340.112
    local OfficeRCoords = vector3(21.22908, 156.5222, 93.91043) --- ukse rot: 249.796
    local OfficeLCoords = vector3(20.33793, 154.0804, 93.91622) --- ukse rot: 70.796
    local MainvaultCoords = vector3(14.76239, 138.72, 93.98164) --- ukse rot: 69.832

    while true do
        Citizen.Wait(1000) 
        local MainRobj = GetClosestObjectOfType(MainRCoords, 20.0, MainR, false, false, false)
        local MainLobj = GetClosestObjectOfType(MainLCoords, 20.0, MainL, false, false, false)
        local SliderRobj = GetClosestObjectOfType(SliderRCoords, 20.0, SliderR, false, false, false)
        local SliderLobj = GetClosestObjectOfType(SliderLCoords, 20.0, SliderL, false, false, false)
        local CellRobj = GetClosestObjectOfType(CellRCoords, 20.0, CellR, false, false, false)
        local CellLobj = GetClosestObjectOfType(CellLCoords, 20.0, CellL, false, false, false)
        local OfficeRobj = GetClosestObjectOfType(OfficeRCoords, 20.0, OfficeR, false, false, false)
        local OfficeLobj = GetClosestObjectOfType(OfficeLCoords, 20.0, OfficeL, false, false, false)
        local Mainvaultobj = GetClosestObjectOfType(MainvaultCoords, 20.0, Mainvault, false, false, false)

        -- Handle main doors locking
         if not mainopen and MainRobj then
            local headingMainR = GetEntityHeading(MainRobj)
            if headingMainR ~= 69.750 then
            SetEntityHeading(MainRobj, 69.750)
            FreezeEntityPosition(MainRobj, true)
            end
        elseif mainopen and MainRobj then
            FreezeEntityPosition(MainRobj, false)
        end
         if not mainopen and MainLobj then
            local headingMainL = GetEntityHeading(MainLobj)
            if headingMainL ~= 249.765 then
            SetEntityHeading(MainLobj, 249.765)
            FreezeEntityPosition(MainLobj, true)
            end
        elseif mainopen and MainLobj then
            FreezeEntityPosition(MainLobj, false)
        end
        -- Handle main vault door locking
        if not mainvaultopen and Mainvaultobj then
            local headingVault = GetEntityHeading(Mainvaultobj)
            if headingVault ~= 69.832 then
            SetEntityHeading(Mainvaultobj, 69.832)
            FreezeEntityPosition(Mainvaultobj, true)
            end
        elseif mainvaultopen and Mainvaultobj then
            FreezeEntityPosition(Mainvaultobj, false)
        end
         -- Handle slider door locking
         if not slidersopen and SliderRobj then
            FreezeEntityPosition(SliderRobj, true)
        elseif slidersopen and SliderRobj then
            FreezeEntityPosition(SliderRobj, false)
        end
         if not slidersopen and SliderLobj then
            FreezeEntityPosition(SliderLobj, true)
        elseif slidersopen and SliderLobj then
            FreezeEntityPosition(SliderLobj, false)
        end
        -- Handle celldoor R locking
        if not cellgateRopen and CellRobj then
            local headingCellR = GetEntityHeading(CellRobj)
            if headingCellR ~= 340.112 then
            SetEntityHeading(CellRobj, 340.112)
            FreezeEntityPosition(CellRobj, true)
            end
        elseif cellgateRopen and CellRobj then
            FreezeEntityPosition(CellRobj, false)
        end
        -- Handle celldoor L locking
         if not cellgateLopen and CellLobj then
            local headingCellL = GetEntityHeading(CellLobj)
            if headingCellL ~= 2340.112 then
            SetEntityHeading(CellLobj, 340.112)
            FreezeEntityPosition(CellLobj, true)
            end
        elseif cellgateLopen and CellLobj then
            FreezeEntityPosition(CellLobj, false)
        end
         -- Handle office doors locking
         if not officedoorsopen and OfficeRobj then
            local headingMainR = GetEntityHeading(OfficeRobj)
            if headingMainR ~= 249.796 then
            SetEntityHeading(OfficeRobj, 249.796)
            FreezeEntityPosition(OfficeRobj, true)
            end
        elseif officedoorsopen and OfficeRobj then
            FreezeEntityPosition(OfficeRobj, false)
        end
         if not officedoorsopen and OfficeLobj then
            local headingMainL = GetEntityHeading(OfficeLobj)
            if headingMainL ~= 70.796 then
            SetEntityHeading(OfficeLobj, 70.796)
            FreezeEntityPosition(OfficeLobj, true)
            end
        elseif officedoorsopen and OfficeLobj then
            FreezeEntityPosition(OfficeLobj, false)
        end
     end
end)

RegisterNetEvent("estrp-artheist:client:placethermite")
AddEventHandler("estrp-artheist:client:placethermite", function()
    startdstcheckart = true
    initiatorart = true
    PlantingAnim(pos, rot)
end)

RegisterNetEvent('estrp-artheist:client:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
end)

RegisterNetEvent('estrp-artheist:client:setPaintingState', function(stateType, state, k)
    Config.Paintings[k][stateType] = state
end)

-- Ensure Planting is properly initialized globally if it's needed
Planting = {
    ['scenes'] = {},
    ['sceneitems'] = {}
}

RegisterNetEvent('estrp-artheist:client:particleFx')
AddEventHandler('estrp-artheist:client:particleFx', function(pos)
    local plantingConfig = Config.ArtThermite.Planting
    loadPtfxAsset('scr_ornate_heist')
    UseParticleFxAssetNextCall('scr_ornate_heist')
    local ptfx = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", pos, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    if ptfx then
        print('Particle effect started successfully')
    else
        print('Failed to start particle effect')
    end
    Wait(9000)
    StopParticleFxLooped(ptfx, 0)
end)

-- Utility function to calculate the distance between two vectors
local function GetDistanceBetweenCoords(vec1, vec2)
    return #(vec1 - vec2)
end

-- Function to find the closest scene configuration to the player's position
local function GetClosestSceneConfig(playerPos, sceneConfigs, threshold)
    local closestConfig = nil
    local minDistance = math.huge

    for id, sceneConfig in pairs(sceneConfigs) do
        local scenePos = sceneConfig.scene.pos
        local distance = GetDistanceBetweenCoords(playerPos, scenePos)
        if distance < minDistance and distance <= threshold then
            minDistance = distance
            closestConfig = { id = id, config = sceneConfig }
        end
    end

    return closestConfig
end

function PlantingAnim()
    busy = true

    local plantingConfig = Config.ArtThermite.Planting
    local animDict = 'anim@heists@ornate_bank@thermal_charge'

    loadAnimDict(animDict)
    loadModel(plantingConfig['items'][1])
    loadModel('hei_prop_heist_thermite')

    local ped = PlayerPedId()
    DisableControlAction(19, true)
    DisableControlAction(73, true)
    local pedCo = GetEntityCoords(ped)

    local thresholdDistance = 5.0

    local closestScene = GetClosestSceneConfig(pedCo, plantingConfig['scenecoords'], thresholdDistance)

    if closestScene then
        local pos = closestScene.config.scene.pos
        local rot = closestScene.config.scene.rot
        local ptfx = closestScene.config.scene.ptfx

        local bag = CreateObject(GetHashKey(plantingConfig['items'][1]), pedCo, 1, 1, 0)
        SetEntityCollision(bag, false, true)
        
        Planting['scenes'][1] = NetworkCreateSynchronisedScene(pos, rot, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Planting['scenes'][1], animDict, plantingConfig['anims'][1][1], 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, Planting['scenes'][1], animDict, plantingConfig['anims'][1][2], 4.0, -8.0, 1)

        NetworkStartSynchronisedScene(Planting['scenes'][1])
        Wait(1500)
        
        local plantObject = CreateObject(GetHashKey('hei_prop_heist_thermite'), pedCo, 1, 1, 0)
        SetEntityCollision(plantObject, false, true)
        AttachEntityToEntity(plantObject, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0.0, 0.0, 200.0, true, true, false, true, 1, true)
        TriggerServerEvent("estrp-artheist:server:removethermite")
        
        Wait(4000)
        DeleteObject(bag)
        DetachEntity(plantObject, 1, 1)
        FreezeEntityPosition(plantObject, true)
        
        TriggerServerEvent('estrp-artheist:server:particleFx', ptfx)
        ClearPedTasks(ped)
        Wait(9000)
        DeleteObject(plantObject)

        local CellRCoordinates = vector3(33.831, 135.061, 93.943) 
        local CellLCoordinates = vector3(37.471809387207, 144.9566192627, 93.91934967041) 
        local specificDistanceThreshold = 5.0 

        if GetDistanceBetweenCoords(pos, CellRCoordinates) <= specificDistanceThreshold then
            TriggerServerEvent('estrp-artheist:server:synced', 'cellrmelted')
            Notifi({ title = Config.title, text = Text('doorlockmelted'), icon = 'fa-solid fa-toolbox', color = '#9eeb34' })
        elseif GetDistanceBetweenCoords(pos, CellLCoordinates) <= specificDistanceThreshold then
            TriggerServerEvent('estrp-artheist:server:synced', 'cellLmelted')
            Notifi({ title = Config.title, text = Text('doorlockmelted'), icon = 'fa-solid fa-toolbox', color = '#9eeb34' })
        else   
        end
    else
    end

    busy = false
end

-- Checks Player For Whitelisted Weapon
local function validWeapon()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, v in pairs(Config.WhitelistedWeapons) do
        if pedWeapon == k then
            return true
        end
    end
    return false
end


function smashVitrineArt(k)
    if busy  then
        Notifi({ title = Config.title, text = Text('cantdo'), icon = 'fa-regular fa-gem', color = '#ff0000' })
        return
    end

    -- Check if the weapon is valid
    if validWeapon() then
        TriggerServerEvent('estrp-artheist:server:setVitrineState', "isBusy", true, k)
        -- Check and initialize startdstcheckvangelico
        busy = true
        
        -- Get player and configuration
        local ped = PlayerPedId()
        local sceneConfig = Config.Locations[k]
        local animDict = 'missheist_jewel'
        local ptfxAsset = "scr_jewelheist"
        local particleFx = "scr_jewel_cab_smash"
        
        -- Load animation and particle effects
        loadAnimDict(animDict)
        loadPtfxAsset(ptfxAsset)
        
        -- Define possible animations
        local anims = {
            {'smash_case_necklace', 300},
            {'smash_case_d', 300},
            {'smash_case_e', 300},
            {'smash_case_f', 300}
        }
        
        -- Select a random animation or a specific one based on k
        local selected = anims[math.random(1, #anims)]
        if k == 4 or k == 10 or k == 14 or k == 8 then
            selected = {'smash_case_necklace_skull', 300}
        end
        
        
        -- Create and start the synchronized scene
        scene = NetworkCreateSynchronisedScene(sceneConfig['SceneLoc'], sceneConfig['SceneRot'], 2, true, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene, animDict, selected[1], 2.0, 4.0, 1, 0, 1148846080, 0)
        NetworkStartSynchronisedScene(scene)
        PlayCamAnim(cam, 'cam_' .. selected[1], animDict, sceneConfig['SceneLoc'], sceneConfig['SceneRot'], 0, 2)
        
        -- Wait for a short duration
        Wait(300)
        
        for i = 1, 5 do
            PlaySoundFromCoord(-1, "Glass_Smash", sceneConfig['PropPos'], 0, 0, 0)
        end
        
        -- Start particle effect
        SetPtfxAssetNextCall(ptfxAsset)
        StartNetworkedParticleFxNonLoopedAtCoord(particleFx, sceneConfig['PropPos'], 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
        
        -- Wait for the animation duration
        Wait(GetAnimDuration(animDict, selected[1]) * 1000 - 1000)
        
        -- Update the vitrine state and reward the player
        TriggerServerEvent('estrp-artheist:server:setVitrineState', "isOpened", true, k)
        TriggerServerEvent('estrp-artheist:server:setVitrineState', "isBusy", false, k)
        TriggerServerEvent('estrp-artheist:server:vitrineReward')
        
        -- Clear tasks and reset the camera
        ClearPedTasks(ped)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        busy = false
    else
        Notifi({ title = Config.title, text = Text('novalidweapon'), icon = 'fa-regular fa-gem', color = '#ff0000' })
        busy = false
    end
end

function OpenShutters()
    local ped = PlayerPedId()
    local targetCoords = vector3(18, 144.63, 92.79)
    local targetHeading = 70.0
    local animDict = 'missheistdocksprep1ig_1'
    loadAnimDict(animDict)
    TaskGoStraightToCoord(ped, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, targetHeading, 0.1)
    while #(GetEntityCoords(ped) - targetCoords) > 2.0 do
        Citizen.Wait(100)
    end
    SetEntityHeading(ped, targetHeading)
    TaskPlayAnim(ped, animDict, "ig_1_button", 1.0, -1.0, -1, 0, 0.0, 0, 0, 0)
    Wait(1500)
    TriggerServerEvent('estrp-artheist:server:synced', 'openshutters')
    ClearPedTasks(ped)
end


Codeentering = {
    ['items'] = {
        'hei_p_m_bag_var22_arm_s',
        'hei_prop_hst_laptop',
    },
    ['anims'] = {
        {'hack_enter', 'hack_enter_bag', 'hack_enter_laptop'},
        {'hack_loop', 'hack_loop_bag', 'hack_loop_laptop'},
        {'hack_exit', 'hack_exit_bag', 'hack_exit_laptop'}
    },
    ['scenes'] = {},
    ['sceneitems'] = {}
}
function VaultPanelAction()
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
    local animDict = 'anim@heists@ornate_bank@hack'

    local vaultpanel = GetClosestObjectOfType(pedCo, 2.0, -160937700, false, false, false)
    if vaultpanel then
        local scenePos = GetEntityCoords(vaultpanel)
        local sceneRot = GetEntityRotation(vaultpanel)

        for k, v in pairs(Codeentering['items']) do
            loadModel(v)
            Codeentering['sceneitems'][k] = CreateObject(GetHashKey(v), pedCo, true, true, false)
        end

        for i = 1, #Codeentering['anims'] do
            Codeentering['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, Codeentering['scenes'][i], animDict, Codeentering['anims'][i][1], 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(Codeentering['sceneitems'][1], Codeentering['scenes'][i], animDict, Codeentering['anims'][i][2], 4.0, -8.0, 1)
            NetworkAddEntityToSynchronisedScene(Codeentering['sceneitems'][2], Codeentering['scenes'][i], animDict, Codeentering['anims'][i][3], 4.0, -8.0, 1)
        end

        NetworkStartSynchronisedScene(Codeentering['scenes'][1])
        Wait(6300)
        NetworkStartSynchronisedScene(Codeentering['scenes'][2])
        Wait(2000)
        ArtVaultPanelHack(success)
    else
        print("No valid scene object found.")
    end
end


function VaultPanelActionResult(success)
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
    local animDict = 'anim@heists@ornate_bank@hack'

    local vaultpanel = GetClosestObjectOfType(pedCo, 2.0, -160937700, false, false, false)
    local scenePos = GetEntityCoords(vaultpanel)
    local sceneRot = GetEntityRotation(vaultpanel)


    for i = 1, #Codeentering['anims'] do
        Codeentering['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Codeentering['scenes'][i], animDict, Codeentering['anims'][i][1], 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(Codeentering['sceneitems'][1], Codeentering['scenes'][i], animDict, Codeentering['anims'][i][2], 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(Codeentering['sceneitems'][2], Codeentering['scenes'][i], animDict, Codeentering['anims'][i][3], 4.0, -8.0, 1)
    end

    NetworkStartSynchronisedScene(Codeentering['scenes'][3])
    Wait(4600)

    -- Clean up scene objects and tasks regardless of success
    DeleteObject(Codeentering['sceneitems'][1])
    DeleteObject(Codeentering['sceneitems'][2])
    DeleteObject(Codeentering['sceneitems'][3])
    ClearPedTasks(ped)

    if success then
        TriggerServerEvent('estrp-artheist:server:synced', 'mainvaultopen')
    else
    end
end

PanelHack = {
    ['anims'] = {
        {'action_var_01', 'action_var_01_ch_prop_ch_usb_drive01x', 'action_var_01_prop_phone_ing'},
        {'hack_loop_var_01', 'hack_loop_var_01_ch_prop_ch_usb_drive01x', 'hack_loop_var_01_prop_phone_ing'},
        {'success_react_exit_var_01', 'success_react_exit_var_01_ch_prop_ch_usb_drive01x', 'success_react_exit_var_01_prop_phone_ing'},
        {'fail_react', 'fail_react_ch_prop_ch_usb_drive01x', 'fail_react_prop_phone_ing'},
        {'reattempt', 'reattempt_ch_prop_ch_usb_drive01x', 'reattempt_prop_phone_ing'},
    },
    ['scenes'] = {}
}

local usb = nil
local phone = nil

RegisterNetEvent('estrp-artheist:client:PanelAction')
AddEventHandler('estrp-artheist:client:PanelAction', function()
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
    local animDict = 'anim_heist@hs3f@ig1_hack_keypad@arcade@male@'
    local usbhash = 'ch_prop_ch_usb_drive01x'
    local phonehash = 'prop_phone_ing'
    loadAnimDict(animDict)
    loadModel(usbhash)
    loadModel(phonehash)

     usb = CreateObject(GetHashKey(usbhash), pedCo, 1, 1, 0)
     phone = CreateObject(GetHashKey(phonehash), pedCo, 1, 1, 0)
     panel = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('k4mb1_fingerprint_scanner_01a'), false, false, false)

    for i = 1, #PanelHack['anims'] do
        PanelHack['scenes'][i] = NetworkCreateSynchronisedScene(GetEntityCoords(panel), GetEntityRotation(panel), 2, true, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, PanelHack['scenes'][i], animDict, PanelHack['anims'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(usb, PanelHack['scenes'][i], animDict, PanelHack['anims'][i][2], 1.0, -1.0, 1148846080)
        NetworkAddEntityToSynchronisedScene(phone, PanelHack['scenes'][i], animDict, PanelHack['anims'][i][3], 1.0, -1.0, 1148846080)
    end

    NetworkStartSynchronisedScene(PanelHack['scenes'][1])
    Wait(4000)
    NetworkStartSynchronisedScene(PanelHack['scenes'][2])
    Wait(2000)
end)

RegisterNetEvent('estrp-artheist:client:OpenDoor')
AddEventHandler('estrp-artheist:client:OpenDoor', function(k, success)
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
    local animDict = 'anim_heist@hs3f@ig1_hack_keypad@arcade@male@'
    local usbModel = 'ch_prop_ch_usb_drive01x'
    local phoneModel = 'prop_phone_ing'
    loadAnimDict(animDict)
    loadModel(usbModel)
    loadModel(phoneModel)

    local panel = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('k4mb1_fingerprint_scanner_01a'), false, false, false)
    
    if not panel then
        print("No object nearby!")
        return
    end
if success then
    if k == 1 then
    TriggerServerEvent('estrp-artheist:server:synced', 'officedoorsopenart')
    end
    Wait(5000)
    NetworkStartSynchronisedScene(PanelHack['scenes'][3])
    Wait(4000)
    DeleteObject(usb)
    DeleteObject(phone)
    ClearPedTasks(ped)
    else
    Wait(5000)
    NetworkStartSynchronisedScene(PanelHack['scenes'][4])
    Wait(4000)
    DeleteObject(usb)
    DeleteObject(phone)
    ClearPedTasks(ped)
    end
end)

RegisterNetEvent('estrp-artheist:client:OpenSlideDoor')
AddEventHandler('estrp-artheist:client:OpenSlideDoor', function(success)
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
    local animDict = 'anim_heist@hs3f@ig1_hack_keypad@arcade@male@'
    local usbModel = 'ch_prop_ch_usb_drive01x'
    local phoneModel = 'prop_phone_ing'
    loadAnimDict(animDict)
    loadModel(usbModel)
    loadModel(phoneModel)

    local panel = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('ch_prop_fingerprint_scanner_01'), false, false, false)
    
    if not panel then
        print("No object nearby!")
        return
    end
if success then
    TriggerServerEvent('estrp-artheist:server:synced', 'slidedooropen')
    Wait(5000)
    NetworkStartSynchronisedScene(PanelHack['scenes'][3])
    Wait(4000)
    DeleteObject(usb)
    DeleteObject(phone)
    ClearPedTasks(ped)
    else
    Wait(5000)
    NetworkStartSynchronisedScene(PanelHack['scenes'][4])
    Wait(4000)
    DeleteObject(usb)
    DeleteObject(phone)
    ClearPedTasks(ped)
    end
end)

function Takepainting(k)
    local paintingID = Config.Paintings[k]["PaintingID"]
    local Painting = Config.Paintings[k]
    -- Animation dictionaries
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local animDict = 'anim_heist@hs3f@ig11_steal_painting@male@'
    heistbag = "hei_p_m_bag_var22_arm_s"
    knife = "w_me_switchblade"
    painting = "ch_prop_vault_painting_01h"
    loadModel(heistbag)
    loadModel(knife)
    loadModel(painting)
    loadAnimDict(animDict)

    ScenePaint = GetClosestObjectOfType(pedCo, 7.0, GetHashKey(Painting.objectname), 0, 0, 0)
    
    local bag = CreateObject(heistbag, pedCo, true, true, false)
    local cuttingknife = CreateObject(knife, pedCo, true, true, false)

       -- Get the coordinates of the ScenePaint
    paintCoords = GetEntityCoords(ScenePaint)
    
    -- Find the closest object to the ScenePaint's coordinates (within a range)
    closestPaintingObj = GetClosestObjectOfType(paintCoords, 5.0, GetHashKey(Painting.objectname), false, false, false)
       

   CamAnim = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
   SetCamActive(CamAnim, true)
   RenderScriptCams(true, 0, 3000, 1, 0)

    
    if not ScenePaint then
        print("No object found near player!")
        return
    end

    TriggerServerEvent('estrp-artheist:server:setPaintingState', 'isBusy', true, k)

    -- Ensure the object is networked
    if not NetworkGetEntityIsNetworked(ScenePaint) then
        NetworkRegisterEntityAsNetworked(ScenePaint)
    end

    local netId = NetworkGetNetworkIdFromEntity(ScenePaint)
    NetworkRequestControlOfEntity(ScenePaint)
    Wait(100)

    if not NetworkHasControlOfEntity(ScenePaint) then
        print("Failed to get network control of sceneobject!")
        return
    end

    ScenPos = Painting.objectpos
    ScenRotation = Painting.objectheading

    SceneStart = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, SceneStart, animDict, 'ver_01_top_left_enter', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(ScenePaint, SceneStart, animDict, 'ver_01_top_left_enter_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, SceneStart, animDict, 'ver_01_top_left_enter_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, SceneStart, animDict, 'ver_01_top_left_enter_w_me_switchblade', 4.0, -8.0, 1)
    
    lefttorightScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, lefttorightScene, animDict, 'ver_01_cutting_top_left_to_right', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(ScenePaint, lefttorightScene, animDict, 'ver_01_cutting_top_left_to_right_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, lefttorightScene, animDict, 'ver_01_cutting_top_left_to_right_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, lefttorightScene, animDict, 'ver_01_cutting_top_left_to_right_w_me_switchblade', 4.0, -8.0, 1)
    
    toptobottomScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, toptobottomScene, animDict, 'ver_01_cutting_right_top_to_bottom', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(ScenePaint, toptobottomScene, animDict, 'ver_01_cutting_right_top_to_bottom_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, toptobottomScene, animDict, 'ver_01_cutting_right_top_to_bottom_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, toptobottomScene, animDict, 'ver_01_cutting_right_top_to_bottom_w_me_switchblade', 4.0, -8.0, 1)
    
    bottomrighttoleftScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, bottomrighttoleftScene, animDict, 'ver_01_cutting_bottom_right_to_left', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(ScenePaint, bottomrighttoleftScene, animDict, 'ver_01_cutting_bottom_right_to_left_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, bottomrighttoleftScene, animDict, 'ver_01_cutting_bottom_right_to_left_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, bottomrighttoleftScene, animDict, 'ver_01_cutting_bottom_right_to_left_w_me_switchblade', 4.0, -8.0, 1)
    
    lefttoptobottomScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, lefttoptobottomScene, animDict, 'ver_01_cutting_left_top_to_bottom', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(ScenePaint, lefttoptobottomScene, animDict, 'ver_01_cutting_left_top_to_bottom_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, lefttoptobottomScene, animDict, 'ver_01_cutting_left_top_to_bottom_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, lefttoptobottomScene, animDict, 'ver_01_cutting_left_top_to_bottom_w_me_switchblade', 4.0, -8.0, 1)
    

    exitscene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, exitscene, animDict, 'ver_01_with_painting_exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(ScenePaint, exitscene, animDict, 'ver_01_with_painting_exit_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, exitscene, animDict, 'ver_01_with_painting_exit_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, exitscene, animDict, 'ver_01_with_painting_exit_w_me_switchblade', 4.0, -8.0, 1)
    
    NetworkStartSynchronisedScene(SceneStart)
    PlayCamAnim(CamAnim, 'ver_01_top_left_enter_cam_ble', animDict, GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(lefttorightScene)
   PlayCamAnim(CamAnim, 'ver_01_cutting_top_left_to_right_cam', animDict, GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(toptobottomScene)
    PlayCamAnim(CamAnim, 'ver_01_cutting_right_top_to_bottom_cam', animDict, GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(bottomrighttoleftScene)
  PlayCamAnim(CamAnim, 'ver_01_cutting_bottom_right_to_left_cam', animDict, GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(lefttoptobottomScene)
   PlayCamAnim(CamAnim, 'ver_01_cutting_left_top_to_bottom_cam', animDict, GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 0, 2)
    Wait(1500)
    NetworkStartSynchronisedScene(exitscene)
  PlayCamAnim(CamAnim, 'ver_01_with_painting_exit_cam', animDict, GetOffsetFromEntityInWorldCoords(ScenePaint, -0.0, -0.43, -1.2), ScenRotation, 0, 2)
    Wait(7000)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(CamAnim, false)
    ClearPedTasks(ped)
    DeleteEntity(bag)
    DeleteEntity(cuttingknife)
    -- Randomly select a reward and amount
    local function RandomPaintingReward(Painting)
        local reward = Painting.rewards[math.random(#Painting.rewards)]
        local amount = 1
        return reward, amount
    end

    local reward, amount = RandomPaintingReward(Painting)

    ClearPedTasks(ped)
    TriggerServerEvent('estrp-artheist:server:setPaintingState', "isBusy", false, k)
    TriggerServerEvent('estrp-artheist:server:setPaintingState', "IsTaken", true, k)
    TriggerServerEvent('estrp-artheist:server:synced', 'paintingtaken', paintingID)
    TriggerServerEvent("estrp-artheist:server:PaintingReward", k,  reward, amount)
end
    



RegisterNetEvent('estrp-artheist:client:OpenBox')
AddEventHandler('estrp-artheist:client:OpenBox', function(k)
    -- Animation dictionaries
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local animDict = 'anim@scripted@player@mission@tun_control_tower@male@'
    loadAnimDict(animDict)

    Fusebox = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('tr_prop_tr_elecbox_01a'), 0, 0, 0)
    
    if not Fusebox then
        print("No object found near player!")
        return
    end

    ScenRotation = GetEntityRotation(Fusebox)

    OpenScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(Fusebox, -0.0, -0.0, -0.0), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, OpenScene, "anim@scripted@player@mission@tun_control_tower@male@", 'enter', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(Fusebox, OpenScene, animDict, 'enter_electric_box', 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(OpenScene)
    Wait(1500)

    LoopScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(Fusebox, -0.0, -0.0, -0.0), ScenRotation, 2, false, true, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, LoopScene, "anim@scripted@player@mission@tun_control_tower@male@", 'loop', 1.5, -4.0, 1, 16, 1148846080, 0)

    NetworkStartSynchronisedScene(LoopScene)
end)

RegisterNetEvent('estrp-artheist:client:CloseBox')
AddEventHandler('estrp-artheist:client:CloseBox', function(k, success)
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local animDict = 'anim@scripted@player@mission@tun_control_tower@male@'
    loadAnimDict(animDict)

    Fusebox = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('tr_prop_tr_elecbox_01a'), 0, 0, 0)
    
    if not Fusebox then
        print("No object found near player!")
        return
    end
if success then
    Wait(2000)
    ExitScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(Fusebox, -0.0, -0.0, -0.0), ScenRotation, 2, false, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, ExitScene, "anim@scripted@player@mission@tun_control_tower@male@", 'exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(Fusebox, ExitScene, animDict, 'exit_electric_box', 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(ExitScene)
    if k == 1 then
    Policenotify()
    TriggerServerEvent("estrp-artheist:server:artrefresh")
    TriggerServerEvent('estrp-artheist:server:synced', 'opensliders')
    end
    Notifi({ title = Config.title, text = Text('wiresbroken'), icon = 'fa-solid fa-toolbox', color = '#9eeb34' })
    else
    ExitScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(Fusebox, -0.0, -0.0, -0.0), ScenRotation, 2, false, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, ExitScene, "anim@scripted@player@mission@tun_control_tower@male@", 'exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(Fusebox, ExitScene, animDict, 'exit_electric_box', 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(ExitScene)
    Notifi({ title = Config.title, text = "failedbreak", icon = 'fa-regular fa-gem', color = '#ff0000' })  
    end
end)
------ /

function GlassCuttingScene(success)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local drillObjectHash = GetHashKey('k4mb1_laserdrill_01a')
    
    -- Load the drill object model
    loadModel(drillObjectHash)

    -- Create the drill object and attach it to the ped
    local drillObject = CreateObject(drillObjectHash, pedCoords, true, true, false)
    AttachEntityToEntity(drillObject, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.005, 20.0, 190.0, 0.0, true, true, false, true, 1, true)

    -- Load and play animation
    local animDict = 'anim_heist@hs3f@ig9_vault_drill@laser_drill@'
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end

    -- Load particle effect
    loadPtfxAsset('core')
    while not HasNamedPtfxAssetLoaded('core') do
        Citizen.Wait(0)
    end

    if success then
        -- Play animation
        TaskPlayAnim(ped, animDict, 'drill_straight_idle', 1.0, -1.0, -1, 3, 0.0, 0, 0, 0)
        Wait(900)
        -- Play sound
        local sound1 = GetSoundId()
        PlaySoundFromEntity(sound1, "StartCutting", drillObject, 'DLC_H4_anims_glass_cutter_Sounds', true, 80)

        -- Start particle effect
        UseParticleFxAssetNextCall('core')
        local particle = StartParticleFxLoopedOnEntity('proj_laser_enemy', drillObject, 0.0, -0.68, 0.018, 0.0, 0.0, 0.0, 0.1, 0, 0, 0, 0)

        -- Progress bar
        lib.progressBar({
            duration = Config.DrillVitrine,
            label = Text("cuttingglass"),
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
        })

        -- Handle interior changes (specific to the scenario)
        TriggerServerEvent("estrp-artheist:server:synced", "VaultVitrineCutted")
        StopParticleFxLooped(particle, false)
        StopSound(sound1)
        DeleteObject(drillObject)
        ClearPedTasks(ped)
        FreezeEntityPosition(ped, true)
        -----------
        Wait(300)
        RequestAnimDict('mp_common')
        while not HasAnimDictLoaded('mp_common') do
            Citizen.Wait(0)
        end
        TaskPlayAnim(ped, 'mp_common', 'givetake1_b', 8.0, -8, 2000, 0, 0, 0, 0, 0)
        -- Handle interior changes (specific to the scenario)
        TriggerServerEvent("estrp-artheist:server:synced", "EggTaken")
        -- Cleanup after success
        TriggerServerEvent("estrp-artheist:server:EggReward")
        TriggerServerEvent("estrp-artheist:server:removelaser")
        FreezeEntityPosition(ped, false)
        ClearPedTasks(ped)
    else
        -- Cleanup on failure
        ClearPedTasks(ped)
        FreezeEntityPosition(ped, false)
        if DoesParticleFxLoopedExist(particle) then
            StopParticleFxLooped(particle, false)
        end
        if DoesEntityExist(drillObject) then
            DeleteObject(drillObject)
        end
    end
end

----- Functions:


function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local Player = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(Player))
  
    if not HasModelLoaded(prop1) then
      LoadPropDict(prop1)
    end
  
    prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
end

function EmoteCancel()
    ClearPedTasks(GetPlayerPed(-1))
    ClearPedTasksImmediately(PlayerPedId())
    DestroyAllProps()
end

function DestroyAllProps()
    for _,v in pairs(PlayerProps) do
      DeleteEntity(v)
    end
end

function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
      RequestModel(GetHashKey(model))
      Wait(10)
    end
  end

  function loadModel(model)
    if HasModelLoaded(model) then return end
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(10)
    end
  end

  function loadPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Citizen.Wait(50)
	end
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(50)
    end
end

RegisterNetEvent('estrp-artheist:client:synced')
AddEventHandler('estrp-artheist:client:synced', function(syncevent, paintingID, index, index2)
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    if syncevent == 'openmain' then
        ArtHeistGallery = true
          mainopen = true
    elseif syncevent == 'opensliders' then
        slidersopen = true
    elseif syncevent == 'officedoorsopenart' then
        officedoorsopen = true
    elseif syncevent == 'disablesecurity' then
        sliderinteraction = true
    elseif syncevent == 'openshutters' then
        DeactivateInteriorEntitySet(interiorid, "set_shutters")
        shuttersopen = true
        RefreshInterior(interiorid)
    elseif syncevent == 'paintingtaken' then
            DeactivateInteriorEntitySet(interiorid, paintingID)
            RefreshInterior(interiorid)
    elseif syncevent == 'cellrmelted' then
           cellgateRopen = true
           initiatorart = true
    elseif syncevent == 'cellLmelted' then
           cellgateLopen = true
           initiatorart = true
    elseif syncevent == 'mainvaultopen' then
        local ArtVaultCoords = vector3(14.762, 138.720, 93.982)
        mainvaultopen = true
        startdstcheckart = true
        initiatorart = true
    
            -- Handle bank vault door
            local ArtVaultObj = GetClosestObjectOfType(ArtVaultCoords, 15.0, -660779536, false, false, false)
            if bankVaultDoorObj ~= 0 then
                local openheading = 173.939  -- Use the bank's door heading
                Citizen.CreateThread(function()
                    while true do
                        local closedheading = GetEntityHeading(ArtVaultObj)
    
                        -- If the door is not at the desired heading, adjust it
                    if math.abs(closedheading - openheading) > 0.5 then
                        -- Smoothly adjust the heading
                        SetEntityHeading(ArtVaultObj, closedheading + 0.5)
                    else
                        -- Freeze the door in the open state
                        FreezeEntityPosition(ArtVaultObj, true)
                        break
                    end
    
                        Citizen.Wait(10) -- Smooth transition with a delay
                     end
                end)
            end
    elseif syncevent == 'VaultVitrineCutted' then
        CreateModelSwap(11.313621520996, 139.21713256836, 93.160148620605, 20.0, GetHashKey('k4mb1_egg'), GetHashKey('k4mb1_egg2'), 0)
    elseif syncevent == 'EggTaken' then
        eggtaken = true
        CreateModelSwap(11.313621520996, 139.21713256836, 93.160148620605, 20.0, GetHashKey('k4mb1_egg2'), GetHashKey('k4mb1_egg3'), 0)
    elseif syncevent == 'finishheist' then
        initiatorart = false
        mainopen = false
        slidersopen = false
        officedoorsopen = false
        sliderinteraction = false
        shuttersopen = false
        cellgateRopen = false
        cellgateLopen = false
        mainvaultopen = false
        startdstcheckart = false
        ArtHeistGallery = false
        eggtaken = false
        RemoveModelSwap(11.313621520996, 139.21713256836, 93.160148620605, 20.0, GetHashKey('k4mb1_egg'), GetHashKey('k4mb1_egg2'), 0)
        RemoveModelSwap(11.313621520996, 139.21713256836, 93.160148620605, 20.0, GetHashKey('k4mb1_egg2'), GetHashKey('k4mb1_egg3'), 0)
        if DoesEntityExist(ArtFusebox) then
        DeleteEntity(ArtFusebox)
        end
        ActivateInteriorEntitySet(interiorid, "set_windows_normal")
        ActivateInteriorEntitySet(interiorid, "set_painting_1")
        ActivateInteriorEntitySet(interiorid, "set_painting_2")
        ActivateInteriorEntitySet(interiorid, "set_painting_3")
        ActivateInteriorEntitySet(interiorid, "set_painting_4")
        ActivateInteriorEntitySet(interiorid, "set_painting_5")
        ActivateInteriorEntitySet(interiorid, "set_painting_6")
        ActivateInteriorEntitySet(interiorid, "set_painting_7")
        ActivateInteriorEntitySet(interiorid, "set_painting_8")
        ActivateInteriorEntitySet(interiorid, "set_painting_9")
        ActivateInteriorEntitySet(interiorid, "set_painting_10")
        ActivateInteriorEntitySet(interiorid, "set_shutters")
        ActivateInteriorEntitySet(interiorid, "egg1") -- (Default with egg)
        ActivateInteriorEntitySet(interiorid, "keypad_01")
        ActivateInteriorEntitySet(interiorid, "slidedoors_unlocked")  -- (door slide animation when near door)
        RefreshInterior(interiorid)
        TriggerServerEvent("estrp-artheist:cleanUp")
        TriggerServerEvent("estrp-artheist:resetrobbery")
    end
end)

-- Client-Side Script to Handle Reset
RegisterNetEvent("estrp-artheist:resetRobberyClient")
AddEventHandler("estrp-artheist:resetRobberyClient", function()
    initiatorart = false
    mainopen = false
    slidersopen = false
    officedoorsopen = false
    sliderinteraction = false
    shuttersopen = false
    cellgateRopen = false
    cellgateLopen = false
    mainvaultopen = false
    startdstcheckart = false
    eggtaken = false
    ArtHeistGallery = false
    TriggerServerEvent("estrp-artheist:server:synced", "finishheist")
    RemoveModelSwap(11.313621520996, 139.21713256836, 93.160148620605, 20.0, GetHashKey('k4mb1_egg'), GetHashKey('k4mb1_egg2'), 0)
    RemoveModelSwap(11.313621520996, 139.21713256836, 93.160148620605, 20.0, GetHashKey('k4mb1_egg2'), GetHashKey('k4mb1_egg3'), 0)
    if DoesEntityExist(ArtFusebox) then
    DeleteEntity(ArtFusebox)
    end
    ActivateInteriorEntitySet(interiorid, "set_windows_normal")
        ActivateInteriorEntitySet(interiorid, "set_painting_1")
        ActivateInteriorEntitySet(interiorid, "set_painting_2")
        ActivateInteriorEntitySet(interiorid, "set_painting_3")
        ActivateInteriorEntitySet(interiorid, "set_painting_4")
        ActivateInteriorEntitySet(interiorid, "set_painting_5")
        ActivateInteriorEntitySet(interiorid, "set_painting_6")
        ActivateInteriorEntitySet(interiorid, "set_painting_7")
        ActivateInteriorEntitySet(interiorid, "set_painting_8")
        ActivateInteriorEntitySet(interiorid, "set_painting_9")
        ActivateInteriorEntitySet(interiorid, "set_painting_10")
        ActivateInteriorEntitySet(interiorid, "set_shutters")
        ActivateInteriorEntitySet(interiorid, "egg1") -- (Default with egg)
        ActivateInteriorEntitySet(interiorid, "keypad_01")
        ActivateInteriorEntitySet(interiorid, "slidedoors_unlocked")  -- (door slide animation when near door)
        RefreshInterior(interiorid)
    TriggerServerEvent("estrp-artheist:cleanUp")
    TriggerServerEvent("estrp-artheist:resetrobbery")
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    initiatorart = false
    mainopen = false
    slidersopen = false
    officedoorsopen = false
    sliderinteraction = false
    shuttersopen = false
    cellgateRopen = false
    cellgateLopen = false
    mainvaultopen = false
    startdstcheckart = false
    eggtaken = false
    ArtHeistGallery = false
    RemoveModelSwap(11.313621520996, 139.21713256836, 93.160148620605, 20.0, GetHashKey('k4mb1_egg'), GetHashKey('k4mb1_egg2'), 0)
    RemoveModelSwap(11.313621520996, 139.21713256836, 93.160148620605, 20.0, GetHashKey('k4mb1_egg2'), GetHashKey('k4mb1_egg3'), 0)
    if DoesEntityExist(ArtFusebox) then
    DeleteEntity(ArtFusebox)
    end
    DeactivateInteriorEntitySet(interiorid, "set_windows_normal")
    DeactivateInteriorEntitySet(interiorid, "set_painting_1")
    DeactivateInteriorEntitySet(interiorid, "set_painting_2")
    DeactivateInteriorEntitySet(interiorid, "set_painting_3")
    DeactivateInteriorEntitySet(interiorid, "set_painting_4")
    DeactivateInteriorEntitySet(interiorid, "set_painting_5")
    DeactivateInteriorEntitySet(interiorid, "set_painting_6")
    DeactivateInteriorEntitySet(interiorid, "set_painting_7")
    DeactivateInteriorEntitySet(interiorid, "set_painting_8")
    DeactivateInteriorEntitySet(interiorid, "set_painting_9")
    DeactivateInteriorEntitySet(interiorid, "set_painting_10")
    DeactivateInteriorEntitySet(interiorid, "set_shutters")
    DeactivateInteriorEntitySet(interiorid, "egg1") -- (Default with egg)
    DeactivateInteriorEntitySet(interiorid, "keypad_01")
    DeactivateInteriorEntitySet(interiorid, "slidedoors_unlocked")  -- (door slide animation when near door)
    RefreshInterior(interiorid)
    TriggerServerEvent("estrp-artheist:cleanUp")
    TriggerServerEvent("estrp-artheist:resetrobbery")
end)
