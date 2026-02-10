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
HeistSync = {
    ['vault'] = false,
    ['stacks'] = {},
    ['trollys'] = {},
    ['lockboxs'] = {},
    ['mainStack'] = false,
    ['plant'] = false,
    ['blowtorch'] = false,
    ['extendedKeypad'] = false
}
ESX, QBCore = nil, nil
Citizen.CreateThread(function()
    if Config['PaletoHeist']['framework']['name'] == 'ESX' then
        while not ESX do
            pcall(function() ESX = exports[Config['PaletoHeist']['framework']['scriptName']]:getSharedObject() end)
            if not ESX then
                TriggerEvent(Config['PaletoHeist']['framework']['eventName'], function(library) 
                    ESX = library 
                end)
            end
            Citizen.Wait(1)
        end
    elseif Config['PaletoHeist']['framework']['name'] == 'QB' then
        while not QBCore do
            pcall(function() QBCore =  exports[Config['PaletoHeist']['framework']['scriptName']]:GetCoreObject() end)
            if not QBCore then
                pcall(function() QBCore =  exports[Config['PaletoHeist']['framework']['scriptName']]:GetSharedObject() end)
            end
            if not QBCore then
                TriggerEvent(Config['PaletoHeist']['framework']['eventName'], function(obj) QBCore = obj end)
            end
            Citizen.Wait(1)
        end
    end
end)

function TriggerCallback(cbName, cb, data)
    if Config['PaletoHeist']['framework']['name'] == 'ESX' then
        ESX.TriggerServerCallback(cbName, function(data)
            if cb then cb(data) else return data end
        end, data)
    elseif Config['PaletoHeist']['framework']['name'] == 'QB' then
        QBCore.Functions.TriggerCallback(cbName, function(data)
            if cb then cb(data) else return data end
        end, data)
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)
        local sleep = 1000
        local dist = #(pedCo - Config['PaletoSetup']['enter'])
        if dist <= 5.0 then
            sleep = 1
            if IsPedShooting(ped) then
                StartPaletoHeist()
                Citizen.Wait(5000)
            end
        end
        Citizen.Wait(sleep)
    end
end)

function StartPaletoHeist()
    TriggerCallback('paletoheist:server:checkPoliceCount', function(data)
        if data['status'] then
            TriggerCallback('paletoheist:server:checkTime', function(data)
                if data['status'] then
                    Citizen.CreateThread(function()
                        while true do
                            local ped = PlayerPedId()
                            local pedCo = GetEntityCoords(ped)
                            local sleep = 1
                            local dist = #(pedCo - Config['PaletoSetup']['storm'])
                            if dist <= 5.0 then
                                ShowHelpNotification(Strings['storm_bank'])
                                if IsControlJustPressed(0, 38) then
                                    PaletoEnterScene()
                                    break
                                end
                            end
                            Citizen.Wait(sleep)
                        end
                    end)
                end
            end)
        end
    end)
end

RegisterNetEvent('paletoheist:client:sync')
AddEventHandler('paletoheist:client:sync', function(type, args)
    if type == 'loot' then
        HeistSync[args[1]][args[2]] = not HeistSync[args[1]][args[2]]
    elseif type == 'mainStack' then
        HeistSync['mainStack'] = not HeistSync['mainStack']
    elseif type == 'plant' then
        HeistSync['plant'] = not HeistSync['plant']
    elseif type == 'enterScene' then
        PaletoDoorScene(args[1], args[2], args[3], args[4], args[5])
    elseif type == 'breakDoor' then
        HeistSync['breakDoor'] = true
        Config['PaletoSetup']['doors'][2]['locked'] = false
    elseif type == 'keycard' then
        HeistSync['keycard'] = true
    elseif type == 'cardswipe' then
        HeistSync['cardswipe'] = true
    elseif type == 'blowtorch' then
        HeistSync['blowtorch'] = true
    elseif type == 'extendedHack' then 
        HeistSync['extendedKeypad'] = not HeistSync['extendedKeypad']
    elseif type == 'deleteLockbox' then
        object = GetClosestObjectOfType(args[1], 2.0, args[2], 0, 0, 0)
        SetEntityAsMissionEntity(object, 1, 1)
        DeleteObject(object)
    elseif type == 'extendedDoor' then
        Config['PaletoSetup']['doors'][3]['locked'] = false
    elseif type == 'openVault' then
        vaultLoop = true
        Config['PaletoSetup']['doors'][1]['locked'] = false
        Citizen.CreateThread(function()
            while vaultLoop do
                vault = GetClosestObjectOfType(-104.47, 6472.69, 31.6267, 3.0, -1185205679, 0, 0, 0)
                FreezeEntityPosition(vault, true)
                SetEntityHeading(vault, GetEntityHeading(vault) + 0.15)
                if math.floor(GetEntityHeading(vault)) >= 145 then
                    vaultLoop = false
                    break
                end
                Citizen.Wait(1)
            end
        end)
    elseif type == 'enterLoop' then
        Citizen.CreateThread(function()
            while not HeistSync['blowtorch'] or not HeistSync['breakDoor'] or not HeistSync['keycard'] or not HeistSync['cardswipe'] do
                local ped = PlayerPedId()
                local pedCo = GetEntityCoords(ped)
                local sleep = 1
                local dist = #(pedCo - Config['PaletoSetup']['getKeyCard'])
                local dist2 = #(pedCo - Config['PaletoSetup']['cardSwipe'])
                local dist3 = #(pedCo - Config['PaletoSetup']['blowtorch'])
                local dist4 = #(pedCo - Config['PaletoSetup']['breakDoor'])
                if dist <= 2.0 and not HeistSync['keycard'] then 
                    ShowHelpNotification(Strings['take_keycard'])
                    if IsControlJustPressed(0, 38) then
                        getKeyCard = true
                        TriggerServerEvent('paletoheist:server:sync', 'keycard')
                    end
                end
                if dist2 <= 1.2 and not HeistSync['cardswipe'] then 
                    ShowHelpNotification(Strings['open_vault'])
                    if IsControlJustPressed(0, 38) then
                        CardSwipe()
                    end
                end
                if dist3 <= 1.2 and not HeistSync['blowtorch'] and HeistSync['cardswipe'] and not busy then 
                    ShowHelpNotification(Strings['blowtorch'])
                    if IsControlJustPressed(0, 38) then
                        Blowtorch()
                    end
                end
                if dist4 <= 1.2 and not HeistSync['breakDoor'] and HeistSync['blowtorch'] then 
                    ShowHelpNotification(Strings['break_door'])
                    if IsControlJustPressed(0, 38) then
                        BreakDoor()
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    elseif type == 'mainLoop' then
        tellerDoor = GetClosestObjectOfType(-109.47, 6468.40, 31.6267, 2.0, -1184592117, 0, 0, 0)
        SetEntityHeading(tellerDoor, 320.0)
        FreezeEntityPosition(tellerDoor, true)
        mainLoop = true
        Citizen.CreateThread(function()
            while mainLoop do
                local ped = PlayerPedId()
                local pedCo = GetEntityCoords(ped)
                local sleep = 1000
                local mainStackDist = #(pedCo - Config['PaletoSetup']['mainStack']['coords'])
                local plantDist = #(pedCo - Config['PaletoSetup']['cellPlant'])
                local keypadDist = #(pedCo - Config['PaletoSetup']['extendedKeypad']['coords'])
                if Config['PaletoHeist']['buyerFinishScene'] then
                    if mainStackDist >= 100.0 and robber then
                        Outside()
                        break
                    end
                end
                if keypadDist <= 1.2 and not HeistSync['extendedKeypad'] then
                    sleep = 1
                    ShowHelpNotification(Strings['hack'])
                    if IsControlJustPressed(0, 38) then
                        ExtendedHack()
                    end
                end
                if plantDist <= 1.2 and not HeistSync['plant'] and not busy then
                    sleep = 1
                    ShowHelpNotification(Strings['plant_bomb'])
                    if IsControlJustPressed(0, 38) then
                        CellBomb()
                    end
                end
                if mainStackDist <= 1.2 and not HeistSync['mainStack'] then
                    sleep = 1
                    ShowHelpNotification(Strings['grab_stack'])
                    if IsControlJustPressed(0, 38) then
                        GrabStacks(nil)
                    end
                end
                for k, v in pairs(Config['PaletoSetup']['lockboxSetup']) do
                    if v['model'] ~= 'ch_prop_ch_sec_cabinet_01j' then
                        local dist = #(pedCo - v['coords'])
                        if dist <= 1.2 and not HeistSync['lockboxs'][k] and not busy then
                            sleep = 1
                            ShowHelpNotification(Strings['drill'])
                            if IsControlJustPressed(0, 38) then
                                LockboxDrill(k)
                            end
                        end
                    end
                end
                for k, v in pairs(Config['PaletoSetup']['tables']) do
                    local dist = #(pedCo - v['coords'])
                    if dist <= 1.4 and not HeistSync['stacks'][k] and not busy then
                        sleep = 1
                        ShowHelpNotification(Strings['grab_stack'])
                        if IsControlJustPressed(0, 38) then
                            GrabStacks(k)
                        end
                    end
                end
                for k, v in pairs(Config['PaletoSetup']['trollys']) do
                    local dist = #(pedCo - v['coords'])
                    if dist <= 1.4 and not HeistSync['trollys'][k] and not busy then
                        sleep = 1
                        ShowHelpNotification(Strings['grab_trolly'])
                        if IsControlJustPressed(0, 38) then
                            GrabTrollys(k)
                        end
                    end
                end
                for k, v in pairs(Config['PaletoSetup']['doors']) do
                    local door = GetClosestObjectOfType(v['coords'], 2.0, v['model'], 0, 0, 0)
                    local dist = #(pedCo - v['coords'])
                    if v['locked'] then
                        FreezeEntityPosition(door, true)
                        SetEntityHeading(door, v['heading'])
                    else
                        FreezeEntityPosition(door, false)
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    elseif type == 'delete' then
        local entity =  NetworkGetEntityFromNetworkId(args[1])
        DeleteObject(entity)
    end
end)

function Blowtorch()
    TriggerCallback('paletoheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            TriggerServerEvent('paletoheist:server:removeItem', Config['PaletoHeist']['requiredItems'][4])
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local pedRot = GetEntityRotation(ped)
            local animDict = 'missheistpaletoscore2mcs_2_p5'
            loadAnimDict(animDict)
            loadModel('hei_p_m_bag_var22_arm_s')
            loadModel('prop_welding_mask_01_s')
            loadModel('prop_tool_blowtorch')
            mask = CreateObject(GetHashKey('prop_welding_mask_01_s'), -105.414, 6474.93, 30.63, 1, 1, 0)
            blowtorch = CreateObject(GetHashKey('prop_tool_blowtorch'), pedCo.x, pedCo.y, pedCo.z, 1, 1, 0)
            AttachEntityToEntity(blowtorch, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, true, false, false, 2, true)
            AttachEntityToEntity(mask, ped, GetPedBoneIndex(ped, 31086), 0.1, 0.01, 0.0, 0.0, 270.0, 180.0, false, false, false, false, 2, true)

            scene = NetworkCreateSynchronisedScene(vector3(-105.414, 6474.93, 30.63), vector3(0.0, 0.0, -45.0), 2, true, false, 1065353216, 0, 1.0)
            NetworkAddPedToSynchronisedScene(ped, scene, 'missheistpaletoscore2mcs_2_p5', 'burn_door_intro_gunman', 1.5, -4.0, 1, 16, 1148846080, 0)
            PlayEntityAnim(mask, "burn_door_intro_Mask", "missheistpaletoscore2mcs_2_p5", 1000.0, false, true, false, 0.0, 0)
            NetworkStartSynchronisedScene(scene)
            Wait(6000)
            scene = NetworkCreateSynchronisedScene(vector3(-105.414, 6474.93, 30.63), vector3(0.0, 0.0, -45.0), 2, false, true, 1065353216, 0, 1.0)
            NetworkAddPedToSynchronisedScene(ped, scene, 'missheistpaletoscore2mcs_2_p5', 'burn_door_loop_gunman', 1.5, -4.0, 1, 16, 1148846080, 0)
            PlayEntityAnim(mask, "burn_door_loop_Mask", "missheistpaletoscore2mcs_2_p5", 1000.0, false, true, false, 0.0, 0)
            loadPtfxAsset('cut_paletoscore')
            UseParticleFxAssetNextCall('cut_paletoscore')
            blowPtfx = StartParticleFxLoopedOnEntity('cs_paleto_blowtorch', blowtorch, 0.05, 0.0, 0.58, 0.0, 0.0, 0.0, 1.0, false, false, false)
            NetworkStartSynchronisedScene(scene)
            Wait(15000)
            StopParticleFxLooped(blowPtfx, 1)
            scene = NetworkCreateSynchronisedScene(vector3(-105.414, 6474.93, 30.63), vector3(0.0, 0.0, -45.0), 2, true, false, 1065353216, 0, 1.0)
            NetworkAddPedToSynchronisedScene(ped, scene, 'missheistpaletoscore2mcs_2_p5', 'burn_door_gunman', 1.5, -4.0, 1, 16, 1148846080, 0)
            PlayEntityAnim(mask, "burn_door_mask", "missheistpaletoscore2mcs_2_p5", 1000.0, false, true, false, 0.0, 0)
            PlayEntityAnim(blowtorch, "burn_door_blowtorch", "missheistpaletoscore2mcs_2_p5", 1000.0, false, true, false, 0.0, 0)
            NetworkStartSynchronisedScene(scene)
            Wait(5500)
            NetworkStopSynchronisedScene(scene)
            DeleteObject(blowtorch)
            DeleteObject(mask)
            busy = false
            TriggerServerEvent('paletoheist:server:sync', 'blowtorch')
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['PaletoHeist']['requiredItems'][4]})
end

function BreakDoor()
    busy = true
    TriggerServerEvent('paletoheist:server:sync', 'breakDoor')
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local pedRot = GetEntityRotation(ped)
    local animDict = 'missheistpaletoscore2mcs_2_p5'
    loadAnimDict(animDict)
    scene = NetworkCreateSynchronisedScene(vector3(-105.414, 6474.93, 30.63), vector3(0.0, 0.0, -45.0), 2, false, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, scene, 'missheistpaletoscore2mcs_2_p5', 'burn_door_player0', 1.5, -4.0, 1, 16, 1148846080, 0)
    TriggerServerEvent('paletoheist:server:sync', 'enterScene', {'v_ilev_cbankvaulgate01', 'missheistpaletoscore2mcs_2_p5', 'burn_door_vaultgate', vector3(-105.414, 6474.93, 30.63), vector3(0.0, 0.0, -45.0)})
    NetworkStartSynchronisedScene(scene)
    Wait(6000)
    ClearPedTasks(PlayerPedId())
    busy = false
end

function CardSwipe()
    if getKeyCard then
        busy = true
        TriggerServerEvent('paletoheist:server:sync', 'cardswipe')
        local ped = PlayerPedId()
        local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
        local animDict = 'anim_heist@hs3f@ig3_cardswipe@male@'
        local card = 'ch_prop_swipe_card_01a'
        local sceneObject = GetClosestObjectOfType(pedCo, 3.0, GetHashKey('ch_prop_casino_keypad_01'), 0, 0, 0)
        local scenePos = GetEntityCoords(sceneObject)
        local sceneRot = GetEntityRotation(sceneObject)
        loadAnimDict(animDict)
        loadModel(card)

        cardObj = CreateObject(GetHashKey(card), pedCo, 1, 1, 0)

        cardSwipe = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, cardSwipe, animDict, 'success_var01', 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(cardObj, cardSwipe, animDict, 'success_var01_card', 4.0, -8.0, 1)

        NetworkStartSynchronisedScene(cardSwipe)
        Wait(3000)
        DeleteObject(cardObj)
        TriggerServerEvent('paletoheist:server:sync', 'openVault')
        busy = false
    else
        ShowNotification(Strings['no_keycard'])
    end
end

lockboxSetup = {}
lootTables = {}
loots = {}
trollys = {}
function PaletoSetup()
    for k, v in pairs(Config['PaletoSetup']['tables']) do
        if v['type'] == 'money' then
            lootModel = 'h4_prop_h4_cash_stack_01a'
        else
            lootModel = 'h4_prop_h4_gold_stack_01a'
        end
        loadModel('ch_prop_ch_service_trolley_01a')
        loadModel(lootModel)
        lootTables[k] = CreateObject(GetHashKey('ch_prop_ch_service_trolley_01a'), v['coords'], 1, 1, 0)
        SetEntityHeading(lootTables[k], v['heading'])
        FreezeEntityPosition(lootTables[k], true)
        loots[k] = CreateObject(GetHashKey(lootModel), GetOffsetFromEntityInWorldCoords(lootTables[k], vector3(0.001086, -0.051552, 0.995132)), 1, 1, 0)
        SetEntityHeading(loots[k], GetEntityHeading(lootTables[k]))
        Wait(100)
    end
    for k, v in pairs(Config['PaletoSetup']['trollys']) do
        if v['type'] == 'money' then
            trollyModel = 'ch_prop_ch_cash_trolly_01b'
        elseif v['type'] == 'gold' then
            trollyModel = 'ch_prop_gold_trolly_01a'
        elseif v['type'] == 'diamond' then
            trollyModel = 'ch_prop_diamond_trolly_01c'
        end
        loadModel(trollyModel)
        trollys[k] = CreateObject(GetHashKey(trollyModel), v['coords'], 1, 1, 0)
        SetEntityHeading(trollys[k], v['heading'])
        Wait(100)
    end
    loadModel('h4_prop_h4_cash_stack_01a')
    mainStack = CreateObject(GetHashKey('h4_prop_h4_cash_stack_01a'), Config['PaletoSetup']['mainStack']['coords'], 1, 1, 0)
    SetEntityHeading(mainStack, Config['PaletoSetup']['mainStack']['heading'])
    loadModel('ch_prop_casino_keypad_01')
    keypad = CreateObject(GetHashKey('ch_prop_casino_keypad_01'), Config['PaletoSetup']['keypad']['coords'], 1, 1, 0)
    SetEntityHeading(keypad, Config['PaletoSetup']['keypad']['heading'])
    Wait(500)
    first = nil
    for k, v in pairs(Config['PaletoSetup']['lockboxSetup']) do
        loadModel(v['model'])
        if type(v['model']) ~= 'number' then
            if v['model'] ~= 'ch_prop_ch_sec_cabinet_01j' then
                first = k
                lockboxSetup[k] = CreateObject(GetHashKey(v['model']), v['coords'], true, true, false)
                SetEntityHeading(lockboxSetup[k], v['heading'])
            else
                coords = GetOffsetFromEntityInWorldCoords(lockboxSetup[first], 1.555, 0.0, 0.0)
                lockboxSetup[k] = CreateObject(GetHashKey(v['model']), coords, true, true, false)
                SetEntityHeading(lockboxSetup[k], v['heading'])
            end
        else
            TriggerServerEvent('paletoheist:server:sync', 'deleteLockbox', {v['coords'], v['model']})
            Wait(250)
            lockboxSetup[k] = CreateObject(v['model'], v['coords'], true, true, false)
            SetEntityHeading(lockboxSetup[k], v['heading'])
        end
        Wait(250)
    end
end

enterPeds = {}
function PaletoEnterScene()
    policeAlert(GetEntityCoords(PlayerPedId()))
    TriggerServerEvent('paletoheist:server:sync', 'mainLoop')
    local ped = PlayerPedId()
    local animDict = 'missheistpaletoscore2mcs_2_pt1'
    loadAnimDict(animDict)
    networkScene = NetworkCreateSynchronisedScene(vector3(-109.622, 6467.932, 30.712), vector3(0.0, 0.0, -45.0), 2, true, false, 1065353216, 0, 0.8)
    NetworkAddPedToSynchronisedScene(ped, networkScene, 'missheistpaletoscore2mcs_2_pt1', 'walk_in_bank_player2', 1.5, -4.0, 1, 16, 1148846080, 0)
    for k, v in pairs(Config['PaletoSetup']['enterPeds']) do
        loadModel(v['model'])
        enterPeds[k] = CreatePed(4, GetHashKey(v['model']), v['coords'], 0.0, true, false)
        SetBlockingOfNonTemporaryEvents(enterPeds[k], true)
        SetPedCanRagdollFromPlayerImpact(enterPeds[k], false)
        SetPedConfigFlag(enterPeds[k], 208, true)
        SetPedKeepTask(enterPeds[k], true)
        FreezeEntityPosition(enterPeds[k], true)
        if k == 1 then
            NetworkAddPedToSynchronisedScene(enterPeds[k], networkScene, 'missheistpaletoscore2mcs_2_pt1', 'walk_in_bank_f', 1.5, -4.0, 1, 16, 1148846080, 0)
        elseif k == 2 then
            NetworkAddPedToSynchronisedScene(enterPeds[k], networkScene, 'missheistpaletoscore2mcs_2_pt1', 'walk_in_bank_m1', 1.5, -4.0, 1, 16, 1148846080, 0)
        elseif k == 3 then
            NetworkAddPedToSynchronisedScene(enterPeds[k], networkScene, 'missheistpaletoscore2mcs_2_pt1', 'walk_in_bank_m2', 1.5, -4.0, 1, 16, 1148846080, 0)
        elseif k == 4 then
            NetworkAddPedToSynchronisedScene(enterPeds[k], networkScene, 'missheistpaletoscore2mcs_2_pt1', 'walk_in_bank_m3', 1.5, -4.0, 1, 16, 1148846080, 0)
        elseif k == 5 then
            NetworkAddPedToSynchronisedScene(enterPeds[k], networkScene, 'missheistpaletoscore2mcs_2_pt1', 'walk_in_bank_m4', 1.5, -4.0, 1, 16, 1148846080, 0)
        end
    end
    NetworkStartSynchronisedScene(networkScene)
    Wait(500)
    TriggerServerEvent('paletoheist:server:sync', 'enterScene', {'v_ilev_bank4door01', 'missheistpaletoscore2mcs_2_pt1', 'walk_in_bank_door_r', vector3(-109.622, 6467.932, 30.712), vector3(0.0, 0.0, -45.0)})
    Wait(3000)
    SetPedShootsAtCoord(ped, -108.2059, 6462.725, 33.3677, false)
    Wait(20000)
    ClearPedTasks(ped)
    PaletoSetup()
    TriggerServerEvent('paletoheist:server:sync', 'enterLoop')
end

function PaletoDoorScene(model, animDict, animName, pos, rotation)
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), vector3(0.0, 0.0, 0.0)
    loadAnimDict(animDict)

    ClientScenes['objects'][#ClientScenes['objects'] + 1] = GetClosestObjectOfType(pedCo, 5.0, GetHashKey(model), 0, 0, 0)
    ClientScenes['scenes'][#ClientScenes['scenes'] + 1] = CreateSynchronizedScene(pos, rotation, 2, true, false, 1065353216, 0, 1065353216)

    PlaySynchronizedEntityAnim(ClientScenes['objects'][#ClientScenes['objects']], ClientScenes['scenes'][#ClientScenes['scenes']], animName, animDict, 1.0, -1.0, 0, 1148846080)
    ForceEntityAiAndAnimationUpdate(ClientScenes['objects'][#ClientScenes['objects']])
end

function LockboxDrill(index)
    TriggerCallback('paletoheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            TriggerServerEvent('paletoheist:server:removeItem', Config['PaletoHeist']['requiredItems'][2])
            TriggerServerEvent('paletoheist:server:sync', 'loot', {'lockboxs', index})
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), vector3(0.0, 0.0, 0.0)

            -- while not RequestScriptAudioBank("DLC_HEIST3/CASINO_HEIST_FINALE_GENERAL_01", false, -1) do 
            --     RequestScriptAudioBank("DLC_HEIST3/CASINO_HEIST_FINALE_GENERAL_01", false, -1)
            --     Wait(1)
            -- end

            local model = Config['PaletoSetup']['lockboxSetup'][index]['model']
            local getModelPattern = string.sub(model, string.len(model))
            if getModelPattern == 'a' or getModelPattern == 'b' or getModelPattern == 'c' then
                pattern = 'abc'
            elseif getModelPattern == 'd' or getModelPattern == 'e' or getModelPattern == 'f' then
                pattern = 'def'
            elseif getModelPattern == 'g' or getModelPattern == 'h' or getModelPattern == 'i' then
                pattern = 'ghi'
            else
                if model == -2109233454 then
                    pattern = 'def'
                elseif model == 1034526103 then
                    pattern = 'ghi'
                elseif model == 1227076747 then
                    pattern = 'ghi'
                elseif model == 376131363 then
                    pattern = 'ghi'
                end
            end

            if type(model) ~= 'number' then
                model = GetHashKey(model)
            end
            
            local test = GetClosestObjectOfType(pedCo, 5.0, model, 0, 0, 0)
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
                local reward = Config['PaletoHeist']['rewardLockbox']()
                TriggerServerEvent('paletoheist:server:rewardItem', reward.item, reward.count, 'item')
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
                local reward = Config['PaletoHeist']['rewardLockbox']()
                TriggerServerEvent('paletoheist:server:rewardItem', reward.item, reward.count, 'item')
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
                local reward = Config['PaletoHeist']['rewardLockbox']()
                TriggerServerEvent('paletoheist:server:rewardItem', reward.item, reward.count, 'item')
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
                local reward = Config['PaletoHeist']['rewardLockbox']()
                TriggerServerEvent('paletoheist:server:rewardItem', reward.item, reward.count, 'item')
            else
                NetworkStartSynchronisedScene(Lockbox['scenes']['44'])
                Wait((GetAnimDuration(animDicts[pattern][4], 'no_reward') * 1000) - 1000)
            end
            TriggerServerEvent('paletoheist:server:sceneSync', model, animDicts[pattern][4], Lockbox['animations'][4][2]..pattern, GetEntityCoords(test), GetEntityRotation(test))
            DeleteObject(test)
            ClearPedTasks(ped)
            RenderScriptCams(false, true, 1500, true, false)
            DestroyCam(cam, false)
            SetPedComponentVariation(ped, 5, Config['PaletoHeist']['bagClothesID'], 0, 0)
            for k, v in pairs(Lockbox['sceneObjects']) do
                DeleteObject(v)
            end
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['PaletoHeist']['requiredItems'][2]})
end

function GrabStacks(index)
    TriggerCallback('paletoheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict
            local stackModel
            
            if index ~= nil then
                TriggerServerEvent('paletoheist:server:sync', 'loot', {'stacks', index})
                if Config['PaletoSetup']['tables'][index]['type'] == 'money' then
                    stackModel = GetHashKey('h4_prop_h4_cash_stack_01a')
                    animDict = 'anim@scripted@heist@ig1_table_grab@cash@male@'
                    loadAnimDict(animDict)
                else
                    stackModel = GetHashKey('h4_prop_h4_gold_stack_01a')
                    animDict = 'anim@scripted@heist@ig1_table_grab@gold@male@'
                    loadAnimDict(animDict)
                end
            else
                TriggerServerEvent('paletoheist:server:sync', 'mainStack')
                stackModel = GetHashKey('h4_prop_h4_cash_stack_01a')
                animDict = 'anim@scripted@heist@ig1_table_grab@cash@male@'
                loadAnimDict(animDict)
            end
            
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
            if stackModel == -180074230 then
                TriggerServerEvent('paletoheist:server:rewardItem', Config['PaletoHeist']['rewardItems'][1]['itemName'], Config['PaletoHeist']['rewardGoldStacks'], 'item')
            else
                TriggerServerEvent('paletoheist:server:rewardItem', 'nil', Config['PaletoHeist']['rewardMoneys']['stacks'](), 'money')
            end
            NetworkStartSynchronisedScene(GrabCash['scenes'][4])
            Wait(GetAnimDuration(animDict, 'exit') * 1000)
            SetPedComponentVariation(ped, 5, Config['PaletoHeist']['bagClothesID'], 0, 0)

            DeleteObject(bag)
            ClearPedTasks(ped)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['PaletoHeist']['requiredItems'][1]})
end

function GrabTrollys(index)
    TriggerCallback('paletoheist:server:hasItem', function(data)
        if data['status'] then
            TriggerServerEvent('paletoheist:server:sync', 'loot', {'trollys', index})
            busy = true
            robber = true
            local ped = PlayerPedId()
            local pedCo  = GetEntityCoords(ped)
            local animDict = 'anim@heists@ornate_bank@grab_cash'
            local grabModel = Config['PaletoSetup']['trollys'][index]['type']
            if grabModel == 'gold' then
                grabModel = 'ch_prop_gold_bar_01a'
                trollyModel = 'ch_prop_gold_trolly_01a'
            elseif grabModel == 'money' then
                grabModel = 'hei_prop_heist_cash_pile'
                trollyModel = 'ch_prop_ch_cash_trolly_01b'
            elseif grabModel == 'diamond' then
                grabModel = 'ch_prop_vault_dimaondbox_01a'
                trollyModel = 'ch_prop_diamond_trolly_01c'
            end

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
            SetPedComponentVariation(ped, 5, Config['PaletoHeist']['bagClothesID'], 0, 0)
            DeleteObject(bag)
            ClearPedTasks(ped)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['PaletoHeist']['requiredItems'][1]})
end

function CashAppear(grabModel)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    if grabModel == 'ch_prop_gold_bar_01a' then
        reward = 'gold'
    elseif grabModel == 'hei_prop_heist_cash_pile' then
        reward = 'money'
    else
        reward = 'diamond'
    end

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
                    if reward == 'money' then
                        TriggerServerEvent('paletoheist:server:rewardItem', 'nil', Config['PaletoHeist']['rewardMoneys']['trollys'](), 'money')
                    elseif reward == 'gold' then
                        TriggerServerEvent('paletoheist:server:rewardItem', Config['PaletoHeist']['rewardItems'][1]['itemName'], Config['PaletoHeist']['rewardItems'][1]['count'], 'item')
                    else
                        TriggerServerEvent('paletoheist:server:rewardItem', Config['PaletoHeist']['rewardItems'][2]['itemName'], Config['PaletoHeist']['rewardItems'][2]['count'], 'item')
                    end
                end
            end
        end
        DeleteObject(grabobj)
    end)
end

local remote = {}
local remoteLoop = false
function CellBomb()
    TriggerCallback('paletoheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@heists@ornate_bank@thermal_charge'
            local pos = vector3(-105.88, 6460.88, 31.7267)
            local rot = vector3(0.0, 0.0, 130.0)
            loadAnimDict(animDict)
            loadModel(Planting['objects'][1])
            sceneObjectModel = 'prop_bomb_01'
            loadModel(sceneObjectModel)

            bag = CreateObject(GetHashKey(Planting['objects'][1]), pedCo, 1, 1, 0)
            SetEntityCollision(bag, false, true)
            Planting['scenes'][1] = NetworkCreateSynchronisedScene(pos, rot, 2, false, false, 1065353216, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, Planting['scenes'][1], animDict, Planting['animations'][1][1], 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(bag, Planting['scenes'][1], animDict, Planting['animations'][1][2], 4.0, -8.0, 1)

            NetworkStartSynchronisedScene(Planting['scenes'][1])
            Wait(1500)
            plantObject = CreateObject(GetHashKey(sceneObjectModel), pedCo, 1, 1, 0)
            SetEntityCollision(plantObject, false, true)
            AttachEntityToEntity(plantObject, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0.0, 0.0, 200.0, true, true, false, true, 1, true)
            Wait(3000)
            TriggerServerEvent('paletoheist:server:sync', 'plant')
            TriggerServerEvent('paletoheist:server:removeItem', Config['PaletoHeist']['requiredItems'][3])
            DeleteObject(bag)
            DetachEntity(plantObject, 1, 1)
            FreezeEntityPosition(plantObject, true)
            table.insert(remote, {object = plantObject, coords = GetEntityCoords(plantObject)})
            busy = false
            if not remoteLoop then
                remoteLoop = true
                Citizen.CreateThread(function()
                    pressed = false
                    repeat
                        ShowHelpNotification(Strings['detonate_bombs'])
                        if IsControlJustPressed(0, 38) then
                            loadAnimDict('anim@mp_player_intmenu@key_fob@')
                            TaskPlayAnim(ped, "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                            Wait(500)
                            for i =1, #remote do
                                AddExplosion(remote[i].coords, 2, 300.0, 1)
                                DeleteObject(remote[i].object)
                            end
                            remote = {}
                            pressed = true
                            remoteLoop = false
                        end
                        Citizen.Wait(1)
                    until pressed == true
                end)
            end
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['PaletoHeist']['requiredItems'][3]})
end

function ExtendedHack()
    TriggerCallback('paletoheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            TriggerServerEvent('paletoheist:server:removeItem', Config['PaletoHeist']['requiredItems'][5])
            TriggerServerEvent('paletoheist:server:sync', 'extendedHack')
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim_heist@hs3f@ig1_hack_keypad@arcade@male@'
            local usbModel = 'ch_prop_ch_usb_drive01x'
            local phoneModel = 'prop_phone_ing'
            loadAnimDict(animDict)
            loadModel(usbModel)
            loadModel(phoneModel)

            usb = CreateObject(GetHashKey(usbModel), pedCo, 1, 1, 0)
            phone = CreateObject(GetHashKey(phoneModel), pedCo, 1, 1, 0)
            keypad = GetClosestObjectOfType(pedCo, 5.0, 1321190118, false, false, false)

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
                    TriggerServerEvent('paletoheist:server:sync', 'extendedDoor')
                    busy = false
                else
                    Wait(5000)
                    NetworkStartSynchronisedScene(HackKeypad['scenes'][4])
                    Wait(4000)
                    DeleteObject(usb)
                    DeleteObject(phone)
                    ClearPedTasks(ped)
                    TriggerServerEvent('paletoheist:server:sync', 'extendedHack')
                    busy = false
                end
            end)
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['PaletoHeist']['requiredItems'][5]})
end

function Outside()
    if robber then
        robber = false
        ShowNotification(Strings['deliver_to_buyer'])
        loadModel('baller')
        buyerBlip = addBlip(Config['PaletoHeist']['finishHeist']['buyerPos'], 500, 0, Strings['buyer_blip'])
        buyerVehicle = CreateVehicle(GetHashKey('baller'), Config['PaletoHeist']['finishHeist']['buyerPos'].xy + 7.0, Config['PaletoHeist']['finishHeist']['buyerPos'].z, 269.4, 0, 0)
        while true do
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local dist = #(pedCo - Config['PaletoHeist']['finishHeist']['buyerPos'])

            if dist <= 15.0 then
                PlayCutscene('hs3f_all_drp3', Config['PaletoHeist']['finishHeist']['buyerPos'])
                DeleteVehicle(buyerVehicle)
                RemoveBlip(buyerBlip)
                TriggerServerEvent('paletoheist:server:sellRewardItems')
                break
            end
            Wait(1)
        end
    end
end

RegisterNetEvent('paletoheist:client:resetHeist')
AddEventHandler('paletoheist:client:resetHeist', function()
    ClearArea(-111.92, 6460.86, 31.4684)
    mainLoop = false
    for k, v in pairs(Config['PaletoSetup']['doors']) do
        v['locked'] = true
    end
    for i = 1, 5 do
        DeletePed(enterPeds[i])
    end
    for i = 1, #lockboxSetup do
        DeleteObject(lockboxSetup[i])
    end
    for i = 1, #lootTables do
        DeleteObject(lootTables[i])
    end
    for i = 1, #loots do
        DeleteObject(loots[i])
    end
    for i = 1, #trollys do
        DeleteObject(trollys[i])
    end
    HeistSync = {
        ['vault'] = false,
        ['stacks'] = {},
        ['trollys'] = {},
        ['lockboxs'] = {},
        ['mainStack'] = false,
        ['plant'] = false,
        ['blowtorch'] = false,
        ['extendedKeypad'] = false
    }
end)

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
RegisterNetEvent('paletoheist:client:sceneSync')
AddEventHandler('paletoheist:client:sceneSync', function(model, animDict, animName, pos, rotation)
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
    TriggerServerEvent('paletoheist:server:sync', 'delete', {NetworkGetNetworkIdFromEntity(entity)})
end