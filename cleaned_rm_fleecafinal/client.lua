Lockbox = {
    ['objects'] = {
        'ch_prop_vault_drill_01a',
        'hei_p_m_bag_var22_arm_s',
        'ch_prop_ch_moneybag_01a'
    },
    ['animations'] = {
        {'enter', 'enter_ch_prop_ch_sec_cabinet_01', 'enter_ch_prop_vault_drill_01a', 'enter_p_m_bag_var22_arm_s'},
        {'action', 'action_ch_prop_ch_sec_cabinet_01', 'action_ch_prop_vault_drill_01a', 'action_p_m_bag_var22_arm_s'},
        {'reward', 'reward_ch_prop_ch_sec_cabinet_01', 'reward_ch_prop_vault_drill_01a', 'reward_p_m_bag_var22_arm_s', 'reward_ch_prop_ch_moneybag_01a'},
        {'no_reward', 'no_reward_ch_prop_ch_sec_cabinet_01', 'no_reward_ch_prop_vault_drill_01a', 'no_reward_p_m_bag_var22_arm_s'},
    },
    ['sceneObjects'] = {},
    ['scenes'] = {}
}
animDicts = {
    ['abc'] = {
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_01@male@',
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_02@male@',
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_03@male@',
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_04@male@',
    },
    ['def'] = {
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_02@lockbox_01@male@',
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_02@lockbox_02@male@',
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_02@lockbox_03@male@',
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_02@lockbox_04@male@',
    },
    ['ghi'] = {
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_03@lockbox_01@male@',
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_03@lockbox_02@male@',
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_03@lockbox_03@male@',
        'anim_heist@hs3f@ig10_lockbox_drill@pattern_03@lockbox_04@male@',
    }
}
GrabCash = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s'
    },
    ['animations'] = {
        {'enter', 'enter_bag'},
        {'grab', 'grab_bag', 'grab_cash'},
        {'grab_idle', 'grab_idle_bag'},
        {'exit', 'exit_bag'},
    },
    ['scenes'] = {},
    ['scenesObjects'] = {}
}
TrollyAnimation = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s'
    },
    ['animations'] = {
        {'intro', 'bag_intro'},
        {'grab', 'bag_grab', 'cart_cash_dissapear'},
        {'exit', 'bag_exit'}
    },
    ['scenes'] = {},
    ['scenesObjects'] = {}
}
Planting = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s'
    },
    ['animations'] = {
        {'thermal_charge', 'bag_thermal_charge'}
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}
HackKeypad = {
    ['animations'] = {
        {'action_var_01', 'action_var_01_ch_prop_ch_usb_drive01x', 'action_var_01_prop_phone_ing'},
        {'hack_loop_var_01', 'hack_loop_var_01_ch_prop_ch_usb_drive01x', 'hack_loop_var_01_prop_phone_ing'},
        {'success_react_exit_var_01', 'success_react_exit_var_01_ch_prop_ch_usb_drive01x', 'success_react_exit_var_01_prop_phone_ing'},
        {'fail_react', 'fail_react_ch_prop_ch_usb_drive01x', 'fail_react_prop_phone_ing'},
        {'reattempt', 'reattempt_ch_prop_ch_usb_drive01x', 'reattempt_prop_phone_ing'},
    },
    ['scenes'] = {}
}
doorModels = {
    -2075524880,
    839234948,
    -1591004109,
}
mainLoop = {}
HeistSync = {
    ['vault'] = {},
    ['stack'] = {},
    ['trolly'] = {},
    ['keycard'] = {},
    ['lockboxs'] = {},
    ['door1'] = {},
    ['door2'] = {},
    ['door3'] = {},
}
ESX, QBCore = nil, nil
Citizen.CreateThread(function()
    for k, v in pairs(HeistSync) do
        for i = 1, #Config['FleecaSetup'] do
            if k == 'lockboxs' then
                HeistSync[k][i] = {}
            else
                HeistSync[k][i] = false
            end
        end
    end
    if Config['FleecaHeist']['framework']['name'] == 'ESX' then
        while not ESX do
            pcall(function() ESX = exports[Config['FleecaHeist']['framework']['scriptName']]:getSharedObject() end)
            if not ESX then
                TriggerEvent(Config['FleecaHeist']['framework']['eventName'], function(library) 
                    ESX = library 
                end)
            end
            Citizen.Wait(1)
        end
    elseif Config['FleecaHeist']['framework']['name'] == 'QB' then
        while not QBCore do
            pcall(function() QBCore =  exports[Config['FleecaHeist']['framework']['scriptName']]:GetCoreObject() end)
            if not QBCore then
                pcall(function() QBCore =  exports[Config['FleecaHeist']['framework']['scriptName']]:GetSharedObject() end)
            end
            if not QBCore then
                TriggerEvent(Config['FleecaHeist']['framework']['eventName'], function(obj) QBCore = obj end)
            end
            Citizen.Wait(1)
        end
    end
end)

function TriggerCallback(cbName, cb, data)
    if Config['FleecaHeist']['framework']['name'] == 'ESX' then
        ESX.TriggerServerCallback(cbName, function(data)
            if cb then cb(data) else return data end
        end, data)
    elseif Config['FleecaHeist']['framework']['name'] == 'QB' then
        QBCore.Functions.TriggerCallback(cbName, function(data)
            if cb then cb(data) else return data end
        end, data)
    end
end

Citizen.CreateThread(function()
    local shoot = false
    while true do
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)
        local sleep = 1000
        for k, v in pairs(Config['FleecaSetup']) do
            local fleecaDist = #(pedCo - v['main'])
            if fleecaDist <= 20.0 then
                sleep = 1
                if fleecaDist <= 10.0 then
                    if IsPedShooting(ped) and not shoot then
                        shoot = true
                        StartFleecaHeist(k)
                        Citizen.CreateThread(function()
                            Citizen.Wait(5000)
                            shoot = false
                        end)
                    end
                end
                for x, y in pairs(v['doors']) do
                    local dist = #(pedCo - y['coords'])
                    if dist <= 5.0 then
                        sleep = 1
                        local object = GetClosestObjectOfType(y['coords'], 2.0, doorModels[x], 0, 0, 0)
                        if y['locked'] then
                            FreezeEntityPosition(object, true)
                            SetEntityHeading(object, y['heading'])
                        else
                            FreezeEntityPosition(object, false)
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('fleeca:client:sync')
AddEventHandler('fleeca:client:sync', function(type, args)
    if type == 'action' then
        if args[3] then
            HeistSync[args[1]][args[2]][args[3]] = not HeistSync[args[1]][args[2]][args[3]]
        else
            HeistSync[args[1]][args[2]] = not HeistSync[args[1]][args[2]]
        end
    elseif type == 'doors' then
        Config['FleecaSetup'][args[1]]['doors'][args[2]]['locked'] = false
    elseif type == 'ptfx' then
        loadPtfxAsset('scr_ornate_heist')
        UseParticleFxAssetNextCall('scr_ornate_heist')
        if args[1] ~= 4 and args[1] ~= 5 and args[1] ~= 6 then 
            ptfx = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", args[2], 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        elseif args[1] == 4 then
            ptfx = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", -1208.7, -334.70, 37.8092, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        elseif args[1] == 5 then
            ptfx = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", 1173.78, 2714.11, 38.0662, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        elseif args[1] == 6 then
            ptfx = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", -2956.17, 484.90, 15.7, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        end
        Wait(13000)
        StopParticleFxLooped(ptfx, 0)
    elseif type == 'mainLoop' then
        Citizen.CreateThread(function()
            index = args[1]
            mainLoop[index] = true
            while mainLoop[index] do
                local ped = PlayerPedId()
                local pedCo = GetEntityCoords(ped)
                local keycardDist = #(pedCo - Config['FleecaSetup'][index]['keycard'])
                local trollyDist = #(pedCo - Config['FleecaSetup'][index]['trolly']['coords'])
                local stackDist = #(pedCo - Config['FleecaSetup'][index]['cashStack']['coords'])
                if Config['FleecaHeist']['buyerFinishScene'] then
                    if keycardDist >= 100.0 and robber then
                        Outside()
                        break
                    end
                end
                if not busy then
                    if keycardDist <= 1.0 and not HeistSync['keycard'][index] then
                        ShowHelpNotification(Strings['keycard'])
                        if IsControlJustPressed(0, 38) then
                            KeycardAction(index)
                        end
                    end
                    if trollyDist <= 1.2 and not HeistSync['trolly'][index] then
                        ShowHelpNotification(Strings['grab_trolly'])
                        if IsControlJustPressed(0, 38) then
                            GrabTrollys(index)
                        end
                    end
                    if stackDist <= 1.0 and not HeistSync['stack'][index] then
                        ShowHelpNotification(Strings['grab_stack'])
                        if IsControlJustPressed(0, 38) then
                            GrabStacks(index)
                        end
                    end
                    for k, v in pairs(Config['FleecaSetup'][index]['lockboxs']) do
                        local dist = #(pedCo - v['coords'])
                        if dist <= 0.5 and not HeistSync['lockboxs'][index][k] then
                            ShowHelpNotification(Strings['drill'])
                            if IsControlJustPressed(0, 38) then
                                LockboxDrill(index, k)
                            end
                        end
                    end
                    for k, v in pairs(Config['FleecaSetup'][index]['doors']) do
                        local dist = #(pedCo - v['coords'])
                        if dist <= 1.0 and not HeistSync['door'..k][index] then
                            ShowHelpNotification(Strings['door_'..k])
                            if IsControlJustPressed(0, 38) then
                                DoorActions(index, k)
                            end
                        end
                    end
                end
                Citizen.Wait(1)
            end
        end)
    elseif type == 'delete' then
        local entity =  NetworkGetEntityFromNetworkId(args[1])
        DeleteObject(entity)
    elseif type == 'resetHeist' then
        mainLoop[args[1]] = false
        for k, v in pairs(Config['FleecaSetup'][args[1]]['doors']) do
            v['locked'] = true
        end
        for k, v in pairs(HeistSync) do
            if k == 'lockboxs' then
                HeistSync[k][args[1]] = {}
            else
                HeistSync[k][args[1]] = false
            end
        end
        ClearArea(Config['FleecaSetup'][args[1]]['main'], 50.0)
    end
end)

function StartFleecaHeist(index)
    TriggerCallback('fleeca:server:checkPoliceCount', function(data)
        if data['status'] then
            TriggerCallback('fleeca:server:checkTime', function(data)
                if data['status'] then
                    SetupFleeca(index)
                    policeAlert(Config['FleecaSetup'][index]['main'])
                end
            end, index)
        end
    end)
end

function SetupFleeca(index)
    loadModel('ch_prop_gold_trolly_01a')
    loadModel('h4_prop_h4_cash_stack_01a')
    trolly = CreateObject(GetHashKey('ch_prop_gold_trolly_01a'), Config['FleecaSetup'][index]['trolly']['coords'], 1, 1, 0)
    SetEntityHeading(trolly, Config['FleecaSetup'][index]['trolly']['heading'])
    cashStack = CreateObject(GetHashKey('h4_prop_h4_cash_stack_01a'), Config['FleecaSetup'][index]['cashStack']['coords'], 1, 1, 0)
    SetEntityHeading(cashStack, Config['FleecaSetup'][index]['cashStack']['heading'])
    TriggerServerEvent('fleeca:server:sync', 'mainLoop', {index})
end

function KeycardAction(index)
    robber = true
    TriggerServerEvent('fleeca:server:sync', 'action', {'keycard', index})
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local animDict = 'anim_heist@arcade_property@arcade_safe_open@male@'
    loadAnimDict(animDict)
    loadAnimDict("mini@safe_cracking")
    loadAnimDict("anim@am_hold_up@male")
    safe = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('ch_prop_ch_arcade_safe_door'), 0, 0, 0)
    -- keycard = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('k4mb1_genbank_card2'), 0, 0, 0)
    CreateModelSwap(pedCo, 2.0, GetHashKey('k4mb1_genbank_card2'), GetHashKey('k4mb1_genbank_card'), 0)
    while not NetworkGetEntityIsNetworked(safe) do
        NetworkRegisterEntityAsNetworked(safe)
        Wait(1)
    end
    scenePos = GetOffsetFromEntityInWorldCoords(safe, 6.15, 1.192, -2.38)
    sceneRot = GetEntityRotation(safe) + vector3(0.0, 0.0, 90.0)
    liftScenePos = GetOffsetFromEntityInWorldCoords(safe, -0.2, -0.7, 0.2)
    
    turnScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(safe, -0.8, -0.0, -0.78), sceneRot, 2, false, true, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, turnScene, "mini@safe_cracking", 'dial_turn_clock_normal', 1.5, -4.0, 1, 16, 1148846080, 0)
    
    scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 0.8)
    NetworkAddPedToSynchronisedScene(ped, scene, animDict, 'safe_open', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(safe, scene, animDict, 'safe_open_safedoor', 4.0, -8.0, 1)

    scene2 = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 0.8)
    NetworkAddPedToSynchronisedScene(ped, scene2, animDict, 'safe_close', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(safe, scene2, animDict, 'safe_close_safedoor', 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(turnScene)
    StartSafeCrack(4, function(status)
    end)
    Cracking = true
    while Cracking do
        Wait(1)
    end
    if gStatus then
        gStatus = false
        SafeCrackSuccess()
        NetworkStartSynchronisedScene(scene)
        Wait(7000)
        scene = NetworkCreateSynchronisedScene(liftScenePos, GetEntityRotation(ped), 2, false, false, 1065353216, 0, 1.0)
        NetworkAddPedToSynchronisedScene(ped, scene, "anim@am_hold_up@male", 'shoplift_high', 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(scene)
        Wait(1000)
        RemoveModelSwap(pedCo, 2.0, GetHashKey('k4mb1_genbank_card2'), GetHashKey('k4mb1_genbank_card'), 0)
        NetworkStartSynchronisedScene(scene2)
        ShowNotification(Strings['got_keycard'])
    end
end

function DoorActions(a, b)
    if b == 1 then
        DrillDoor(a, b)
    elseif b == 2 then
        OpenVault(a, b)
    elseif b == 3 then
        CellBomb(a, b)
    end
end

function CellBomb(a, b)
    TriggerCallback('fleeca:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            TriggerServerEvent('fleeca:server:sync', 'action', {'door'.. b, a})
            TriggerServerEvent('fleeca:server:removeItem', Config['FleecaHeist']['requiredItems'][4])
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@heists@ornate_bank@thermal_charge'
            local door = GetClosestObjectOfType(pedCo, 2.0, doorModels[b], 0, 0, 0)
            scenePos = GetOffsetFromEntityInWorldCoords(door, 1.5, -0.05, -0.2)
            sceneRot = GetEntityRotation(door)
            loadAnimDict(animDict)
            loadModel(Planting['objects'][1])

            sceneObjectModel = 'hei_prop_heist_thermite'
            loadModel(sceneObjectModel)

            bag = CreateObject(GetHashKey(Planting['objects'][1]), pedCo, 1, 1, 0)
            SetEntityCollision(bag, false, true)
            Planting['scenes'][1] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, Planting['scenes'][1], animDict, Planting['animations'][1][1], 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(bag, Planting['scenes'][1], animDict, Planting['animations'][1][2], 4.0, -8.0, 1)

            SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(Planting['scenes'][1])
            Wait(1500)
            plantObject = CreateObject(GetHashKey(sceneObjectModel), pedCo, 1, 1, 0)
            SetEntityCollision(plantObject, false, true)
            AttachEntityToEntity(plantObject, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0.0, 0.0, 200.0, true, true, false, true, 1, true)
            Wait(4000)
            SetPedComponentVariation(ped, 5, Config['FleecaHeist']['bagClothesID'], 0, 0)
            DeleteObject(bag)
            DetachEntity(plantObject, 1, 1)
            FreezeEntityPosition(plantObject, true)
            ptfxPos = GetOffsetFromEntityInWorldCoords(door, 1.85, -1.0, -0.2)
            TriggerServerEvent('fleeca:server:sync', 'ptfx', {a, ptfxPos})
            TaskPlayAnim(ped, animDict, "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
            TaskPlayAnim(ped, animDict, "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
            Wait(2000)
            ClearPedTasks(ped)
            busy = false
            Wait(11000)
            TriggerServerEvent('fleeca:server:sync', 'doors', {a, b})
            DeleteObject(plantObject)
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['FleecaHeist']['requiredItems'][4]})
end

function OpenVault(a, b)
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    keypad = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('k4mb1_genbank_keypad'), 0, 0, 0)
    if keycard then
        robber = true
        local animDict = 'anim_heist@hs3f@ig3_cardswipe@male@'
        local card = 'prop_cs_swipe_card'
        local scenePos = GetEntityCoords(keypad)
        local sceneRot = GetEntityRotation(keypad)
        loadAnimDict(animDict)
        loadModel(card)

        cardObj = CreateObject(GetHashKey(card), pedCo, 1, 1, 0)

        cardSwipe = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, cardSwipe, animDict, 'success_var01', 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(cardObj, cardSwipe, animDict, 'success_var01_card', 4.0, -8.0, 1)

        NetworkStartSynchronisedScene(cardSwipe)
        Wait(3000)
        DeleteObject(cardObj)
        TriggerServerEvent('fleeca:server:sync', 'doors', {a, b})
        TriggerServerEvent('fleeca:server:sync', 'action', {'door'.. b, a})
        busy = false
    else
        TriggerCallback('fleeca:server:hasItem', function(data)
            if data['status'] then
                robber = true
                TriggerServerEvent('fleeca:server:sync', 'action', {'door'.. b, a})
                TriggerServerEvent('fleeca:server:removeItem', Config['FleecaHeist']['requiredItems'][5])
                local animDict = 'anim_heist@hs3f@ig1_hack_keypad@arcade@male@'
                local usbModel = 'ch_prop_ch_usb_drive01x'
                local phoneModel = 'prop_phone_ing'
                loadAnimDict(animDict)
                loadModel(usbModel)
                loadModel(phoneModel)
            
                usb = CreateObject(GetHashKey(usbModel), pedCo, 1, 1, 0)
                phone = CreateObject(GetHashKey(phoneModel), pedCo, 1, 1, 0)
            
                for i = 1, #HackKeypad['animations'] do
                    HackKeypad['scenes'][i] = NetworkCreateSynchronisedScene(GetEntityCoords(keypad)['xy'], GetEntityCoords(keypad)['z'] - 0.03, GetEntityRotation(keypad), 2, true, false, 1065353216, 0, 1.3)
                    NetworkAddPedToSynchronisedScene(ped, HackKeypad['scenes'][i], animDict, HackKeypad['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
                    NetworkAddEntityToSynchronisedScene(usb, HackKeypad['scenes'][i], animDict, HackKeypad['animations'][i][2], 1.0, -1.0, 1148846080)
                    NetworkAddEntityToSynchronisedScene(phone, HackKeypad['scenes'][i], animDict, HackKeypad['animations'][i][3], 1.0, -1.0, 1148846080)
                end
            
                NetworkStartSynchronisedScene(HackKeypad['scenes'][1])
                Wait(4000)
                NetworkStartSynchronisedScene(HackKeypad['scenes'][2])
                Wait(2000)
                StartFingerprint(function(result)
                    if result then 
                        Wait(5000)
                        NetworkStartSynchronisedScene(HackKeypad['scenes'][3])
                        Wait(4000)
                        DeleteObject(usb)
                        DeleteObject(phone)
                        ClearPedTasks(ped)
                        TriggerServerEvent('fleeca:server:sync', 'doors', {a, b})
                        busy = false
                    else
                        Wait(5000)
                        NetworkStartSynchronisedScene(HackKeypad['scenes'][4])
                        Wait(4000)
                        DeleteObject(usb)
                        DeleteObject(phone)
                        ClearPedTasks(ped)
                        busy = false
                        TriggerServerEvent('fleeca:server:sync', 'action', {'door'.. b, a})
                    end
                end)
            else
                ShowNotification(Strings['need_this'] .. data['label'])
            end
        end, {itemName = Config['FleecaHeist']['requiredItems'][5]})
    end
end

function DrillDoor(a, b)
    TriggerCallback('fleeca:server:hasItem', function(data)
        if data['status'] then
            TriggerServerEvent('fleeca:server:sync', 'action', {'door'.. b, a})
            TriggerServerEvent('fleeca:server:removeItem', Config['FleecaHeist']['requiredItems'][3])
            busy = true
            robber = true
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local door = GetClosestObjectOfType(pedCo, 2.0, doorModels[b], 0, 0, 0)
            local animDict = 'anim@scripted@heist@ig11_bomb_plant@male@'
            local drillCo = GetOffsetFromEntityInWorldCoords(door, -1.05, -0.32, -0.0)
            local drillRot = GetEntityRotation(door) + vector3(0.0, 0.0, 180.0)
            loadModel('k4mb1_prop_drill2')
            loadAnimDict(animDict)
            loadModel('hei_p_m_bag_var22_arm_s')
            RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
            RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
            RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
            bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), pedCo, 1, 1, 0)
            
            scenePos = GetOffsetFromEntityInWorldCoords(door, -1.05, -0.12, 0.6)
            sceneRot = GetEntityRotation(door)
            
            scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 0.5)
            NetworkAddPedToSynchronisedScene(ped, scene, animDict, 'enter', 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(bag, scene, animDict, 'enter_bag', 4.0, -8.0, 1)
            SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(scene)

            Wait(2000)
            SetPedComponentVariation(ped, 5, Config['FleecaHeist']['bagClothesID'], 0, 0)
            DeleteObject(bag)
            
            drill = CreateObject(GetHashKey('k4mb1_prop_drill2'), drillCo, true, true, false)
            SetEntityRotation(drill, drillRot)
            FreezeEntityPosition(drill, true)
            soundId = GetSoundId()
            PlaySoundFromEntity(soundId, "Drill", drill, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
            loadPtfxAsset('scr_fbi5a')
            UseParticleFxAssetNextCall('scr_fbi5a')
            ptfx = StartNetworkedParticleFxLoopedOnEntity('scr_bio_grille_cutting', drill, 0.044, -0.25, 0.0, 0.0, 90.0, 0.0, 1.2, false, false, false)
            effectTimer = true
            Citizen.CreateThread(function()
                while effectTimer do
                    for i = 1, 4 do
                        SetEntityCoords(drill, GetEntityCoords(drill) + vector3(0.0015, 0.0015, 0.0015))
                        Citizen.Wait(100)
                        SetEntityCoords(drill, GetEntityCoords(drill) - vector3(0.0015, 0.0015, 0.0015))
                        Citizen.Wait(100)
                        SetEntityCoords(drill, GetEntityCoords(drill) - vector3(-0.0015, 0.0015, 0.0015))
                        Citizen.Wait(100)
                        SetEntityCoords(drill, GetEntityCoords(drill) + vector3(-0.0015, 0.0015, 0.0015))
                    end
                    Citizen.Wait(100)
                end
            end)
            AddTimerBar(Config['FleecaHeist']['drillTime'], Strings['drill_bar'], function(status)
                if status then
                    TriggerServerEvent('fleeca:server:sync', 'doors', {a, b})
                    DeleteObject(drill)
                    busy = false
                    StopSound(soundId)
                    effectTimer = false
                end
            end)
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['FleecaHeist']['requiredItems'][3]})
end

function LockboxDrill(a, b)
    TriggerCallback('fleeca:server:hasItem', function(data)
        if data['status'] then
            TriggerServerEvent('fleeca:server:removeItem', Config['FleecaHeist']['requiredItems'][2])
            busy = true
            robber = true
            TriggerServerEvent('fleeca:server:sync', 'action', {'lockboxs', a, b})
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), vector3(0.0, 0.0, 0.0)

            -- while not RequestScriptAudioBank("DLC_HEIST3/CASINO_HEIST_FINALE_GENERAL_01", false, -1) do 
            --     RequestScriptAudioBank("DLC_HEIST3/CASINO_HEIST_FINALE_GENERAL_01", false, -1)
            --     Wait(1)
            -- end

            local model = Config['FleecaSetup'][a]['lockboxs'][b]['model']
            local getModelPattern = string.sub(model, string.len(model))
            if getModelPattern == 'a' or getModelPattern == 'b' or getModelPattern == 'c' then
                pattern = 'abc'
            elseif getModelPattern == 'd' or getModelPattern == 'e' or getModelPattern == 'f' then
                pattern = 'def'
            elseif getModelPattern == 'g' or getModelPattern == 'h' or getModelPattern == 'i' then
                pattern = 'ghi'
            end

            if type(model) ~= 'number' then
                model = GetHashKey(model)
            end
            
            local test = GetClosestObjectOfType(pedCo, 2.0, model, 0, 0, 0)
            while not NetworkGetEntityIsNetworked(test) do
                NetworkRegisterEntityAsNetworked(test)
                Wait(1)
            end
            for i = 1, #animDicts[pattern] do
                loadAnimDict(animDicts[pattern][i])
            end

            for k, v in pairs(Lockbox['objects']) do
                loadModel(v)
                if k ~= 3 then
                    Lockbox['sceneObjects'][k] = CreateObject(GetHashKey(v), GetEntityCoords(test), 1, 1, 0)
                else
                    Lockbox['sceneObjects'][k] = CreateObject(GetHashKey(v), GetEntityCoords(test).xy, GetEntityCoords(test).z - 5.0, 1, 1, 0)
                end
            end

            cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            camOffset = vector3(0.8, -1.0, 1.2)
            SetCamActive(cam, true)
            RenderScriptCams(true, true, 1500, true, false)
            SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(test, camOffset))
            SetCamRot(cam, vector3(-10.0, 0.0, GetEntityHeading(test) + 45))

            while not NetworkHasControlOfEntity(test) do
                Citizen.Wait(1)
                NetworkRequestControlOfEntity(test)
            end

            for j = 1, #animDicts[pattern] do
                for i = 1, #Lockbox['animations'] do
                    Lockbox['scenes'][j..i] = NetworkCreateSynchronisedScene(GetEntityCoords(test), GetEntityRotation(test), 2, true, false, 1065353216, 0, 1.0)
                    NetworkAddPedToSynchronisedScene(ped, Lockbox['scenes'][j..i], animDicts[pattern][j], Lockbox['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
                    NetworkAddEntityToSynchronisedScene(test, Lockbox['scenes'][j..i], animDicts[pattern][j], Lockbox['animations'][i][2]..pattern, 1.0, -1.0, 1148846080)
                    NetworkAddEntityToSynchronisedScene(Lockbox['sceneObjects'][1], Lockbox['scenes'][j..i], animDicts[pattern][j], Lockbox['animations'][i][3], 1.0, -1.0, 1148846080)
                    NetworkAddEntityToSynchronisedScene(Lockbox['sceneObjects'][2], Lockbox['scenes'][j..i], animDicts[pattern][j], Lockbox['animations'][i][4], 1.0, -1.0, 1148846080)
                    if i == 3 then
                        NetworkAddEntityToSynchronisedScene(Lockbox['sceneObjects'][3], Lockbox['scenes'][j..i], animDicts[pattern][j], Lockbox['animations'][i][5], 1.0, -1.0, 1148846080)
                    end
                end
            end

            SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(Lockbox['scenes']['11'])
            Wait(GetAnimDuration(animDicts[pattern][1], 'enter') * 1000)
            NetworkStartSynchronisedScene(Lockbox['scenes']['12'])
            soundId = GetSoundId()
            PlaySoundFromCoord(soundId, 'drill', pedCo, 'dlc_ch_heist_finale_lockbox_drill_sounds', 1, 0, 0)
            Wait(GetAnimDuration(animDicts[pattern][1], 'action') * 1000 - 1000)
            StopSound(soundId)
            local random = math.random(1, 100)
            if random >= 40 then
                NetworkStartSynchronisedScene(Lockbox['scenes']['13'])
                Wait(GetAnimDuration(animDicts[pattern][1], 'reward') * 1000)
                local reward = Config['FleecaHeist']['rewardLockbox']()
                TriggerServerEvent('fleeca:server:rewardItem', reward.item, reward.count, 'item', index)
            else
                NetworkStartSynchronisedScene(Lockbox['scenes']['14'])
                Wait(GetAnimDuration(animDicts[pattern][1], 'no_reward') * 1000)
            end
            NetworkStartSynchronisedScene(Lockbox['scenes']['22'])
            soundId = GetSoundId()
            PlaySoundFromCoord(soundId, 'drill', pedCo, 'dlc_ch_heist_finale_lockbox_drill_sounds', 1, 0, 0)
            Wait(GetAnimDuration(animDicts[pattern][2], 'action') * 1000 - 1000)
            StopSound(soundId)
            local random = math.random(1, 100)
            if random >= 40 then
                NetworkStartSynchronisedScene(Lockbox['scenes']['23'])
                Wait(GetAnimDuration(animDicts[pattern][2], 'reward') * 1000)
                local reward = Config['FleecaHeist']['rewardLockbox']()
                TriggerServerEvent('fleeca:server:rewardItem', reward.item, reward.count, 'item', index)
            else
                NetworkStartSynchronisedScene(Lockbox['scenes']['24'])
                Wait(GetAnimDuration(animDicts[pattern][2], 'no_reward') * 1000)
            end
            NetworkStartSynchronisedScene(Lockbox['scenes']['32'])
            soundId = GetSoundId()
            PlaySoundFromCoord(soundId, 'drill', pedCo, 'dlc_ch_heist_finale_lockbox_drill_sounds', 1, 0, 0)
            Wait(GetAnimDuration(animDicts[pattern][3], 'action') * 1000 - 1000)
            StopSound(soundId)
            local random = math.random(1, 100)
            if random >= 40 then
                NetworkStartSynchronisedScene(Lockbox['scenes']['33'])
                Wait(GetAnimDuration(animDicts[pattern][3], 'reward') * 1000)
                local reward = Config['FleecaHeist']['rewardLockbox']()
                TriggerServerEvent('fleeca:server:rewardItem', reward.item, reward.count, 'item', index)
            else
                NetworkStartSynchronisedScene(Lockbox['scenes']['34'])
                Wait(GetAnimDuration(animDicts[pattern][3], 'no_reward') * 1000)
            end
            NetworkStartSynchronisedScene(Lockbox['scenes']['42'])
            soundId = GetSoundId()
            PlaySoundFromCoord(soundId, 'drill', pedCo, 'dlc_ch_heist_finale_lockbox_drill_sounds', 1, 0, 0)
            Wait(GetAnimDuration(animDicts[pattern][4], 'action') * 1000 - 1000)
            StopSound(soundId)
            local random = math.random(1, 100)
            if random >= 40 then
                NetworkStartSynchronisedScene(Lockbox['scenes']['43'])
                Wait((GetAnimDuration(animDicts[pattern][4], 'reward') * 1000) - 1000)
                local reward = Config['FleecaHeist']['rewardLockbox']()
                TriggerServerEvent('fleeca:server:rewardItem', reward.item, reward.count, 'item', index)
            else
                NetworkStartSynchronisedScene(Lockbox['scenes']['44'])
                Wait((GetAnimDuration(animDicts[pattern][4], 'no_reward') * 1000) - 1000)
            end
            TriggerServerEvent('fleeca:server:sceneSync', model, animDicts[pattern][4], Lockbox['animations'][4][2]..pattern, GetEntityCoords(test), GetEntityRotation(test))
            ClearPedTasks(ped)
            RenderScriptCams(false, true, 1500, true, false)
            DestroyCam(cam, false)
            SetPedComponentVariation(ped, 5, Config['FleecaHeist']['bagClothesID'], 0, 0)
            for k, v in pairs(Lockbox['sceneObjects']) do
                DeleteObject(v)
            end
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['FleecaHeist']['requiredItems'][2]})
end

function GrabStacks(index)
    TriggerCallback('fleeca:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict
            local stackModel
            
            TriggerServerEvent('fleeca:server:sync', 'action', {'stack', index})
            stackModel = GetHashKey('h4_prop_h4_cash_stack_01a')
            animDict = 'anim@scripted@heist@ig1_table_grab@cash@male@'
            loadAnimDict(animDict)
            
            loadModel(stackModel)
            loadModel('hei_p_m_bag_var22_arm_s')
            bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), pedCo, 1, 1, 0)
            sceneObject = GetClosestObjectOfType(pedCo, 3.0, stackModel, 0, 0, 0)
            NetworkRequestControlOfEntity(sceneObject)
            scenePos = GetEntityCoords(sceneObject)
            sceneRot = GetEntityRotation(sceneObject)

            for i = 1, #GrabCash['animations'] do
                GrabCash['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.0)
                NetworkAddPedToSynchronisedScene(ped, GrabCash['scenes'][i], animDict, GrabCash['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
                NetworkAddEntityToSynchronisedScene(bag, GrabCash['scenes'][i], animDict, GrabCash['animations'][i][2], 1.0, -1.0, 1148846080)
                if i == 2 then
                    if stackModel == -180074230 then
                        NetworkAddEntityToSynchronisedScene(sceneObject, GrabCash['scenes'][i], animDict, 'grab_gold', 1.0, -1.0, 1148846080)
                    else
                        NetworkAddEntityToSynchronisedScene(sceneObject, GrabCash['scenes'][i], animDict, GrabCash['animations'][i][3], 1.0, -1.0, 1148846080)
                    end
                end
            end

            SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(GrabCash['scenes'][1])
            Wait(GetAnimDuration(animDict, 'enter') * 1000)
            NetworkStartSynchronisedScene(GrabCash['scenes'][2])
            Wait(GetAnimDuration(animDict, 'grab') * 1000)
            DeleteObjectSync(sceneObject)
            TriggerServerEvent('fleeca:server:rewardItem', 'nil', Config['FleecaHeist']['rewardMoneys']['stacks'](), 'money', index)
            NetworkStartSynchronisedScene(GrabCash['scenes'][4])
            Wait(GetAnimDuration(animDict, 'exit') * 1000)
            SetPedComponentVariation(ped, 5, Config['FleecaHeist']['bagClothesID'], 0, 0)
            
            DeleteObject(bag)
            ClearPedTasks(ped)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['FleecaHeist']['requiredItems'][1]})
end

function GrabTrollys(index)
    TriggerCallback('fleeca:server:hasItem', function(data)
        if data['status'] then
            TriggerServerEvent('fleeca:server:sync', 'action', {'trolly', index})
            busy = true
            robber = true
            local ped = PlayerPedId()
            local pedCo  = GetEntityCoords(ped)
            local animDict = 'anim@heists@ornate_bank@grab_cash'
            grabModel = 'ch_prop_gold_bar_01a'
            trollyModel = 'ch_prop_gold_trolly_01a'

            loadAnimDict(animDict)
            loadModel('hei_p_m_bag_var22_arm_s')
            
            sceneObject = GetClosestObjectOfType(pedCo, 2.0, GetHashKey(trollyModel), false, false, false)
            scenePos = GetEntityCoords(sceneObject)
            sceneRot = GetEntityRotation(sceneObject)
            bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), pedCo, true, true, false)

            while not NetworkHasControlOfEntity(sceneObject) do
                Citizen.Wait(1)
                NetworkRequestControlOfEntity(sceneObject)
            end

            for i = 1, #TrollyAnimation['animations'] do
                TrollyAnimation['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.3)
                NetworkAddPedToSynchronisedScene(ped, TrollyAnimation['scenes'][i], animDict, TrollyAnimation['animations'][i][1], 1.5, -4.0, 1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(bag, TrollyAnimation['scenes'][i], animDict, TrollyAnimation['animations'][i][2], 4.0, -8.0, 1)
                if i == 2 then
                    NetworkAddEntityToSynchronisedScene(sceneObject, TrollyAnimation['scenes'][i], animDict, "cart_cash_dissapear", 4.0, -8.0, 1)
                end
            end

            SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(TrollyAnimation['scenes'][1])
            Wait(1750)
            CashAppear(grabModel)
            NetworkStartSynchronisedScene(TrollyAnimation['scenes'][2])
            Wait(37000)
            NetworkStartSynchronisedScene(TrollyAnimation['scenes'][3])
            Wait(2000)
            SetPedComponentVariation(ped, 5, Config['FleecaHeist']['bagClothesID'], 0, 0)
            DeleteObject(bag)
            ClearPedTasks(ped)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['FleecaHeist']['requiredItems'][1]})
end

function CashAppear(grabModel)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    local grabmodel = GetHashKey(grabModel)

    loadModel(grabmodel)
    local grabobj = CreateObject(grabmodel, pedCoords, true)

    FreezeEntityPosition(grabobj, true)
    SetEntityInvincible(grabobj, true)
    SetEntityNoCollisionEntity(grabobj, ped)
    SetEntityVisible(grabobj, false, false)
    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    local startedGrabbing = GetGameTimer()

    Citizen.CreateThread(function()
        while GetGameTimer() - startedGrabbing < 37000 do
            Citizen.Wait(1)
            DisableControlAction(0, 73, true)
            if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
                if not IsEntityVisible(grabobj) then
                    SetEntityVisible(grabobj, true, false)
                end
            end
            if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
                if IsEntityVisible(grabobj) then
                    SetEntityVisible(grabobj, false, false)
                    TriggerServerEvent('fleeca:server:rewardItem', Config['FleecaHeist']['rewardItems'][1]['itemName'], Config['FleecaHeist']['rewardItems'][1]['count'], 'item', index)
                end
            end
        end
        DeleteObject(grabobj)
    end)
end

RegisterNetEvent('fleeca:client:nearBank')
AddEventHandler('fleeca:client:nearBank', function()
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    for k, v in pairs(Config['FleecaSetup']) do
        local dist = #(pedCo - v['main'])
        if dist <= 20.0 then
            bank = k
        end
    end
    if bank then
        TriggerServerEvent('fleeca:server:sync', 'resetHeist', {bank})
    end
end)

function Outside()
    if robber then
        robber = false
        ShowNotification(Strings['deliver_to_buyer'])
        loadModel('baller')
        buyerBlip = addBlip(Config['FleecaHeist']['finishHeist']['buyerPos'], 500, 0, Strings['buyer_blip'])
        buyerVehicle = CreateVehicle(GetHashKey('baller'), Config['FleecaHeist']['finishHeist']['buyerPos'].xy + 5.0, Config['FleecaHeist']['finishHeist']['buyerPos'].z, 269.4, 0, 0)
        while true do
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local dist = #(pedCo - Config['FleecaHeist']['finishHeist']['buyerPos'])

            if dist <= 15.0 then
                PlayCutscene('hs3f_all_drp3', Config['FleecaHeist']['finishHeist']['buyerPos'])
                DeleteVehicle(buyerVehicle)
                RemoveBlip(buyerBlip)
                TriggerServerEvent('fleeca:server:sellRewardItems')
                break
            end
            Wait(1)
        end
    end
end

--Thanks to d0p3t
function PlayCutscene(cut, coords)
    while not HasThisCutsceneLoaded(cut) do 
        RequestCutscene(cut, 8)
        Wait(0) 
    end
    CreateCutscene(false, coords)
    Finish(coords)
    RemoveCutscene()
    DoScreenFadeIn(500)
end

function CreateCutscene(change, coords)
    local ped = PlayerPedId()
        
    local clone = ClonePedEx(ped, 0.0, false, true, 1)
    local clone2 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone3 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone4 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone5 = ClonePedEx(ped, 0.0, false, true, 1)

    SetBlockingOfNonTemporaryEvents(clone, true)
    SetEntityVisible(clone, false, false)
    SetEntityInvincible(clone, true)
    SetEntityCollision(clone, false, false)
    FreezeEntityPosition(clone, true)
    SetPedHelmet(clone, false)
    RemovePedHelmet(clone, true)
    
    if change then
        SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
        RegisterEntityForCutscene(ped, 'MP_2', 0, GetEntityModel(ped), 64)
        
        SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
        RegisterEntityForCutscene(clone2, 'MP_1', 0, GetEntityModel(clone2), 64)
    else
        SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
        RegisterEntityForCutscene(ped, 'MP_1', 0, GetEntityModel(ped), 64)

        SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
        RegisterEntityForCutscene(clone2, 'MP_2', 0, GetEntityModel(clone2), 64)
    end

    SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
    RegisterEntityForCutscene(clone3, 'MP_3', 0, GetEntityModel(clone3), 64)
    
    SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
    RegisterEntityForCutscene(clone4, 'MP_4', 0, GetEntityModel(clone4), 64)
    
    SetCutsceneEntityStreamingFlags('MP_5', 0, 1)
    RegisterEntityForCutscene(clone5, 'MP_5', 0, GetEntityModel(clone5), 64)
    
    Wait(10)
    if coords then
        StartCutsceneAtCoords(coords, 0)
    else
        StartCutscene(0)
    end
    Wait(10)
    ClonePedToTarget(clone, ped)
    Wait(10)
    DeleteEntity(clone)
    DeleteEntity(clone2)
    DeleteEntity(clone3)
    DeleteEntity(clone4)
    DeleteEntity(clone5)
    Wait(50)
    DoScreenFadeIn(250)
end

function Finish(coords)
    if coords then
        local tripped = false
        repeat
            Wait(0)
            if (GetCutsceneTotalDuration() - GetCutsceneTime() <= 250) then
            DoScreenFadeOut(250)
            tripped = true
            end
        until not IsCutscenePlaying()
        if (not tripped) then
            DoScreenFadeOut(100)
            Wait(150)
        end
        return
    else
        Wait(18500)
        StopCutsceneImmediately()
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

function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

function addBlip(coords, sprite, colour, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

ClientScenes = {
    ['objects'] = {},
    ['scenes'] = {}
}
RegisterNetEvent('fleeca:client:sceneSync')
AddEventHandler('fleeca:client:sceneSync', function(model, animDict, animName, pos, rotation)
    local lockboxObject = GetClosestObjectOfType(pos, 2.0, model, 0, 0, 0)
    SetEntityAsMissionEntity(lockboxObject, 1, 1)
    DeleteObject(lockboxObject)
    loadAnimDict(animDict)

    ClientScenes['objects'][#ClientScenes['objects'] + 1] = CreateObject(model, pos, 0, 0, 0)
    SetEntityHeading(ClientScenes['objects'][#ClientScenes['objects']], rotation.z)
    ClientScenes['scenes'][#ClientScenes['scenes'] + 1] = CreateSynchronizedScene(pos, rotation, 2, true, false, 1065353216, 0, 1065353216)

    PlaySynchronizedEntityAnim(ClientScenes['objects'][#ClientScenes['objects']], ClientScenes['scenes'][#ClientScenes['scenes']], animName, animDict, 1.0, -1.0, 0, 1148846080)
    ForceEntityAiAndAnimationUpdate(ClientScenes['objects'][#ClientScenes['objects']])

    SetSynchronizedScenePhase(ClientScenes['scenes'][#ClientScenes['scenes']], 0.99)
    FreezeEntityPosition(ClientScenes['objects'][#ClientScenes['objects']], true)
end)

function DeleteObjectSync(entity)
    TriggerServerEvent('fleeca:server:sync', 'delete', {NetworkGetNetworkIdFromEntity(entity)})
end