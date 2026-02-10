MoneyStacks = {
    ['objects'] = {
        'p_ld_heist_bag_s_1',
        'p_csh_strap_01_s'
    },
    ['animations'] = {
        {'enter', 'enter_bag', 'enter_strap'},
        {'loop', 'loop_bag', 'loop_strap'},
        {'exit', 'exit_bag', 'exit_strap'},
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}
GrabCash = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s'
    },
    ['animations'] = {
        {'enter', 'enter_bag'},
        {'grab', 'grab_bag', 'grab_cash'},
        {'exit', 'exit_bag'},
    },
    ['scenes'] = {},
    ['scenesObjects'] = {}
}
LaserDrill = {
    ['animations'] = {
        {'intro', 'bag_intro', 'intro_drill_bit'},
        {'drill_straight_start', 'bag_drill_straight_start', 'drill_straight_start_drill_bit'},
        {'drill_straight_end_idle', 'bag_drill_straight_idle', 'drill_straight_idle_drill_bit'},
        {'drill_straight_fail', 'bag_drill_straight_fail', 'drill_straight_fail_drill_bit'},
        {'drill_straight_end', 'bag_drill_straight_end', 'drill_straight_end_drill_bit'},
        {'exit', 'bag_exit', 'exit_drill_bit'},
    },
    ['scenes'] = {}
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
SafeCrack = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s'
    },
    ['animations'] = {
        {'enter_player', 'enter_bag', 'enter_safe'},
        {'idle_player', 'idle_bag', 'idle_safe'},
        {'fail_player', 'fail_bag', 'fail_safe'},
        {'exit_player', 'exit_bag', 'exit_safe'},
        {'door_open_player', 'door_open_bag', 'door_open_safe'},
        {'success_with_stack_bonds_player', 'success_with_stack_bonds_bag', 'success_with_stack_bonds_safe', 'success_with_stack_bonds_cash_bond'},
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
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
UndergroundHeist = {
    ['start'] = false,
    ['switch'] = false,
    ['startPeds'] = {}
}
Client = {
    ['switch'] = false
}
LootSync = {
    ['virus'] = false,
    ['drugs'] = {},
    ['moneyStacks'] = {},
    ['chests'] = {},
    ['vault'] = false,
    ['vaultOpening'] = false,
    ['vaultGold'] = false,
    ['plantCell'] = false,
    ['extendedDoor'] = false,
    ['safecrack'] = false,
}
ClientScenes = {
    ['objects'] = {},
    ['scenes'] = {}
}
ESX, QBCore = nil, nil
Citizen.CreateThread(function()
    if Config['UndergroundHeist']['framework']['name'] == 'ESX' then
        while not ESX do
            pcall(function() ESX = exports[Config['UndergroundHeist']['framework']['scriptName']]:getSharedObject() end)
            if not ESX then
                TriggerEvent(Config['UndergroundHeist']['framework']['eventName'], function(library) 
                    ESX = library 
                end)
            end
            Citizen.Wait(1)
        end
    elseif Config['UndergroundHeist']['framework']['name'] == 'QB' then
        while not QBCore do
            pcall(function() QBCore =  exports[Config['UndergroundHeist']['framework']['scriptName']]:GetCoreObject() end)
            if not QBCore then
                pcall(function() QBCore =  exports[Config['UndergroundHeist']['framework']['scriptName']]:GetSharedObject() end)
            end
            if not QBCore then
                TriggerEvent(Config['UndergroundHeist']['framework']['eventName'], function(obj) QBCore = obj end)
            end
            Citizen.Wait(1)
        end
    end
    for k, v in pairs(Config['UndergroundHeist']['startHeist']['peds']) do
        loadModel(v['ped'])
        UndergroundHeist['startPeds'][k] = CreatePed(4, GetHashKey(v['ped']), v['pos']['x'], v['pos']['y'], v['pos']['z'] - 0.95, v['heading'], false, true)
        FreezeEntityPosition(UndergroundHeist['startPeds'][k], true)
        SetEntityInvincible(UndergroundHeist['startPeds'][k], true)
        SetBlockingOfNonTemporaryEvents(UndergroundHeist['startPeds'][k], true)
    end
end)

function TriggerCallback(cbName, cb, data)
    if Config['UndergroundHeist']['framework']['name'] == 'ESX' then
        ESX.TriggerServerCallback(cbName, function(data)
            if cb then cb(data) else return data end
        end, data)
    elseif Config['UndergroundHeist']['framework']['name'] == 'QB' then
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
        if UndergroundHeist['start'] then
            local performDist = #(pedCo - Config['UndergroundSetup']['bomb'])
            if performDist <= 100.0 then
                sleep = 1
                if not UndergroundHeist['switch'] then
                    if Client['switch'] then
                        RemoveModelSwap(Config['UndergroundSetup']['bomb'], 5.0, GetHashKey('k4mb1_bunkerheist_wallnormal'), GetHashKey('k4mb1_bunkerheist_walldamaged'), 0)
                        Client['switch'] = false
                    end
                    local dist = #(pedCo - Config['UndergroundSetup']['bomb'])
                    if dist <= 2.5 and not busy then
                        ShowHelpNotification(Strings['plant_bbomb'])
                        if IsControlJustPressed(0, 38) then
                            PlantingWall()
                        end
                    end
                else
                    if not Client['switch'] then
                        CreateModelSwap(Config['UndergroundSetup']['bomb'], 5.0, GetHashKey('k4mb1_bunkerheist_wallnormal'), GetHashKey('k4mb1_bunkerheist_walldamaged'), 0)
                        Client['switch'] = true
                    end
                end
                local vault = GetClosestObjectOfType(Config['UndergroundSetup']['vault'], 5.0, 961976194, 0, 0, 0)
                if LootSync['vault'] then
                    if not LootSync['vaultOpening'] then
                        SetEntityHeading(vault, 125.0)
                        FreezeEntityPosition(vault, true)
                    end
                else
                    if not LootSync['vaultOpening'] then
                        SetEntityHeading(vault, 307.0)
                        FreezeEntityPosition(vault, true)
                    end
                end
                local extendedDoors = {
                    GetClosestObjectOfType(Config['UndergroundSetup']['extendedDoors'][1], 5.0, 2099085616, 0, 0, 0),
                    GetClosestObjectOfType(Config['UndergroundSetup']['extendedDoors'][2], 5.0, 2099085616, 0, 0, 0),
                }
                if not LootSync['extendedDoor'] then
                    FreezeEntityPosition(extendedDoors[1], true)
                    FreezeEntityPosition(extendedDoors[2], true)
                else
                    FreezeEntityPosition(extendedDoors[1], false)
                    FreezeEntityPosition(extendedDoors[2], false)
                end
            end
        else
            local startDist = #(pedCo - Config['UndergroundHeist']['startHeist']['pos'])
            if startDist <= 2.0 then
                sleep = 1
                ShowHelpNotification(Strings['e_start'])
                if IsControlJustPressed(0, 38) then
                    StartHeist()
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function StartHeist()
    TriggerCallback('undergroundheist:server:checkPoliceCount', function(data)
        if data['status'] then
            TriggerCallback('undergroundheist:server:checkTime', function(data)
                if data['status'] then
                    ShowNotification(Strings['start_heist'])
                    ShowNotification(Strings['start_heist2'])
                    TriggerServerEvent('undergroundheist:server:sync', 'start')
                    policeAlert(Config['UndergroundSetup']['bomb'])
                    undergroundBlip = addBlip(Config['UndergroundSetup']['bomb'], 128, 70, Strings['underground_blip'])
                end
            end)
        end
    end)
end

function PlantingWall()
    TriggerCallback('undergroundheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@scripted@heist@ig11_bomb_plant@male@'
            loadAnimDict(animDict)
            loadModel('hei_p_m_bag_var22_arm_s')
            loadModel('h4_prop_h4_ld_bomb_01a')
        
            bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), pedCo, 1, 1, 0)
            bomb = CreateObject(GetHashKey('h4_prop_h4_ld_bomb_01a'), pedCo, 1, 1, 0)
        
            scenePos = vector3(918.97, -96.037, 26.5535)
            sceneRot = vector3(0.0, 0.0, 300.0)
        
            scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.0)
            NetworkAddPedToSynchronisedScene(ped, scene, animDict, 'enter', 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(bag, scene, animDict, 'enter_bag', 4.0, -8.0, 1)
            NetworkAddEntityToSynchronisedScene(bomb, scene, animDict, 'enter_bomb', 4.0, -8.0, 1)
            
            NetworkStartSynchronisedScene(scene)
        
            Wait(GetAnimDuration(animDict, 'enter') * 1000 - 500)

            TriggerServerEvent('undergroundheist:server:removeItem', Config['UndergroundHeist']['requiredItems'][4])
        
            DeleteObject(bag)
            FreezeEntityPosition(bomb, true)
            ClearPedTasks(ped)
        
            AddTimerBar(10, 'DETONATE', function(status)
                DeleteObject(bomb)
                loadPtfxAsset('scr_josh3')
                UseParticleFxAssetNextCall('scr_josh3')
                StartNetworkedParticleFxNonLoopedAtCoord("scr_josh3_explosion", 919.207, -96.277, 26.5535, 0.0, 0.0, 0.0, 3.0, false, false, false, 0)
                PlaySoundFromCoord(-1, "MAIN_EXPLOSION_CHEAP", 919.207, -96.277, 26.5535, 0, true, 100, 0)
                TriggerServerEvent('undergroundheist:server:mainLoop')
                TriggerServerEvent('undergroundheist:server:sync', 'switch')
                SetupUnderground()
            end)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['UndergroundHeist']['requiredItems'][4]})
end

function SetupUnderground()
    SetupDrugs()
    Wait(500)
    ExtendedSetup()
    Wait(500)
    loadModel('h4_prop_h4_gold_stack_01a')
    goldVaultStack = CreateObject(GetHashKey('h4_prop_h4_gold_stack_01a'), 946.140, -93.903, 25.574, 1, 1, 0)
    SetEntityHeading(goldVaultStack, 307.0)
end

RegisterNetEvent('undergroundheist:client:mainLoop')
AddEventHandler('undergroundheist:client:mainLoop', function()
    mainLoop = true
    while mainLoop do
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)
        local virusDist = #(pedCo - Config['UndergroundSetup']['virus'])
        local cellDist = #(pedCo - Config['UndergroundSetup']['plantCell'])
        local vaultDist = #(pedCo - Config['UndergroundSetup']['vault'])
        local extendedDist = #(pedCo - Config['UndergroundSetup']['extendedDoors'][1])
        local safecrackDist = #(pedCo - Config['UndergroundSetup']['safecrack'])
        local goldDist = #(pedCo - Config['UndergroundSetup']['vaultGold'])

        if Config['UndergroundHeist']['buyerFinishScene'] then
            if vaultDist >= 200.0 and robber then
                Outside()
                break
            end
        end

        if not busy then
            if virusDist <= 1.5 and not LootSync['virus'] then
                ShowHelpNotification(Strings['grab2'])
                if IsControlJustPressed(0, 38) then
                    Virus()
                end
            end

            if cellDist <= 1.5 and not LootSync['plantCell'] then
                ShowHelpNotification(Strings['plant_bomb'])
                if IsControlJustPressed(0, 38) then
                    CellBomb()
                end
            end

            if safecrackDist <= 1.5 and not LootSync['safecrack'] then
                ShowHelpNotification(Strings['safecrack'])
                if IsControlJustPressed(0, 38) then
                    SafeCrackStart()
                end
            end

            if goldDist <= 1.5 and not LootSync['vaultGold'] then
                ShowHelpNotification(Strings['grab1'])
                if IsControlJustPressed(0, 38) then
                    GrabGold()
                end
            end

            if extendedDist <= 1.5 and not LootSync['extendedDoor'] then
                ShowHelpNotification(Strings['hacking'])
                if IsControlJustPressed(0, 38) then
                    ExtendedDoor()
                end
            end

            if vaultDist <= 1.5 and not LootSync['vault'] then
                ShowHelpNotification(Strings['drill'])
                if IsControlJustPressed(0, 38) then
                    Laser()
                end
            end

            for k, v in pairs(Config['UndergroundSetup']['moneyStacks']) do
                local dist = #(pedCo - v['scenePos'])
                if dist <= 1.5 and not LootSync['moneyStacks'][k] then
                    ShowHelpNotification(Strings['grab4'])
                    if IsControlJustPressed(0, 38) then
                        GrabStacks(k)
                    end
                end
            end

            for k, v in pairs(Config['UndergroundSetup']['chests']) do
                local dist = #(pedCo - v['scenePos'])
                if dist <= 1.5 and not LootSync['chests'][k] then
                    ShowHelpNotification(Strings['chests'])
                    if IsControlJustPressed(0, 38) then
                        LootChest(k)
                    end
                end
            end

            for k, v in pairs(Config['UndergroundSetup']['drugs']) do
                local dist = #(pedCo - v['pos'])
                if dist <= 1.5 and not LootSync['drugs'][k] then
                    ShowHelpNotification(Strings['grab3'])
                    if IsControlJustPressed(0, 38) then
                        GrabDrugs(k)
                    end
                end
            end
        end
        Wait(1)
    end
end)

RegisterNetEvent('undergroundheist:client:sync')
AddEventHandler('undergroundheist:client:sync', function(type, index)
    if type == 'vault' then
        Citizen.CreateThread(function()
            LootSync['vaultOpening'] = true
            LootSync['vault'] = true
            local vault = GetClosestObjectOfType(Config['UndergroundSetup']['vault'], 5.0, 961976194, 0, 0, 0)
            repeat
                SetEntityHeading(vault, GetEntityHeading(vault) - 0.15)
                Wait(10)
            until GetEntityHeading(vault) <= 125.0
            LootSync['vaultOpening'] = false
        end)
    elseif type == 'start' then
        UndergroundHeist['start'] = true
    elseif type == 'switch' then
        UndergroundHeist['switch'] = true
    elseif type == 'moneyStacks' then
        LootSync['moneyStacks'][index] = true
    elseif type == 'drugs' then
        LootSync['drugs'][index] = true
    elseif type == 'chests' then
        LootSync['chests'][index] = true
    elseif type == 'virus' then
        LootSync['virus'] = true
    elseif type == 'plantCell' then
        LootSync['plantCell'] = true
    elseif type == 'safecrack' then
        LootSync['safecrack'] = not LootSync['safecrack']
    elseif type == 'vaultGold' then
        LootSync['vaultGold'] = true
    elseif type == 'extendedDoors' then
        LootSync['extendedDoor'] = not LootSync['extendedDoor']
    elseif type == 'deleteObject' then
        local entity =  NetworkGetEntityFromNetworkId(index)
        DeleteObject(entity)
    end
end)

local remote = {}
local remoteLoop = false
function CellBomb()
    TriggerCallback('undergroundheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@heists@ornate_bank@thermal_charge'
            local pos = vector3(918.850, -84.848, 25.8908)
            local rot = vector3(0.0, 0.0, 30.0)
            loadAnimDict(animDict)
            loadModel(Planting['objects'][1])
            sceneObjectModel = 'prop_bomb_01'
            loadModel(sceneObjectModel)

            bag = CreateObject(GetHashKey(Planting['objects'][1]), pedCo, 1, 1, 0)
            SetEntityCollision(bag, false, true)
            Planting['scenes'][1] = NetworkCreateSynchronisedScene(pos, rot, 2, false, false, 1065353216, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, Planting['scenes'][1], animDict, Planting['animations'][1][1], 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(bag, Planting['scenes'][1], animDict, Planting['animations'][1][2], 4.0, -8.0, 1)

            SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(Planting['scenes'][1])
            Wait(1500)
            plantObject = CreateObject(GetHashKey(sceneObjectModel), pedCo, 1, 1, 0)
            SetEntityCollision(plantObject, false, true)
            AttachEntityToEntity(plantObject, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0.0, 0.0, 200.0, true, true, false, true, 1, true)
            Wait(3000)
            TriggerServerEvent('undergroundheist:server:sync', 'plantCell')
            TriggerServerEvent('undergroundheist:server:removeItem', Config['UndergroundHeist']['requiredItems'][3])
            SetPedComponentVariation(ped, 5, Config['UndergroundHeist']['bagClothesID'], 0, 0)
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
    end, {itemName = Config['UndergroundHeist']['requiredItems'][3]})
end

drugs = {}
function SetupDrugs()
    local drugOffset = vector3(0.051086, -0.151552, 0.945132)
    for k, v in pairs(Config['UndergroundSetup']['drugs']) do
        local desk = GetClosestObjectOfType(v['pos'], 1.5, GetHashKey('h4_prop_h4_table_isl_01a'), 0, 0, 0)
        if v['type'] == 'coke' then
            drugs[k] = CreateObject(GetHashKey('h4_prop_h4_coke_stack_01a'), GetOffsetFromEntityInWorldCoords(desk, drugOffset), 1, 1, 0)
        elseif v['type'] == 'weed' then
            drugs[k] = CreateObject(GetHashKey('h4_prop_h4_weed_stack_01a'), GetOffsetFromEntityInWorldCoords(desk, drugOffset), 1, 1, 0)
        else
            return
        end
        SetEntityHeading(drugs[k], GetEntityHeading(desk))
    end
end

function GrabDrugs(index)
    TriggerCallback('undergroundheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            TriggerServerEvent('undergroundheist:server:sync', 'drugs', index)
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@scripted@heist@ig1_table_grab@cash@male@'
            local stackModel = Config['UndergroundSetup']['drugs'][index]['type']
            
            if stackModel == 'coke' then
                stackModel = GetHashKey('h4_prop_h4_coke_stack_01a')
            elseif stackModel == 'weed' then 
                stackModel = GetHashKey('h4_prop_h4_weed_stack_01a')
            end
            
            loadAnimDict(animDict)
            loadModel('hei_p_m_bag_var22_arm_s')
            bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), pedCo, 1, 1, 0)
            sceneObject = GetClosestObjectOfType(pedCo, 2.0, stackModel, 0, 0, 0)

            scenePos = GetEntityCoords(sceneObject)
            sceneRot = GetEntityRotation(sceneObject)

            for i = 1, #GrabCash['animations'] do
                GrabCash['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.0)
                NetworkAddPedToSynchronisedScene(ped, GrabCash['scenes'][i], animDict, GrabCash['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
                NetworkAddEntityToSynchronisedScene(bag, GrabCash['scenes'][i], animDict, GrabCash['animations'][i][2], 1.0, -1.0, 1148846080)
                if i == 2 then
                    NetworkAddEntityToSynchronisedScene(sceneObject, GrabCash['scenes'][i], animDict, GrabCash['animations'][i][3], 1.0, -1.0, 1148846080)
                end
            end

            SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(GrabCash['scenes'][1])
            Wait(2000)
            NetworkStartSynchronisedScene(GrabCash['scenes'][2])
            Wait(13000)
            DeleteObjectSync(sceneObject)
            if Config['UndergroundSetup']['drugs'][index]['type'] == 'coke' then
                TriggerServerEvent('undergroundheist:server:rewardItem', Config['UndergroundHeist']['rewardItems'][2]['itemName'], Config['UndergroundHeist']['rewardItems'][2]['count'], 'item')
            elseif Config['UndergroundSetup']['drugs'][index]['type'] == 'weed' then
                TriggerServerEvent('undergroundheist:server:rewardItem', Config['UndergroundHeist']['rewardItems'][1]['itemName'], Config['UndergroundHeist']['rewardItems'][1]['count'], 'item')
            end
            NetworkStartSynchronisedScene(GrabCash['scenes'][4])
            Wait(2000)
            SetPedComponentVariation(ped, 5, Config['UndergroundHeist']['bagClothesID'], 0, 0)

            DeleteObject(bag)
            ClearPedTasks(ped)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['UndergroundHeist']['requiredItems'][2]})
end

function Virus()
    TriggerCallback('undergroundheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            TriggerServerEvent('undergroundheist:server:sync', 'virus')
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@scripted@player@mission@tunf_conv_ig1_monyplate@male@'
            loadAnimDict(animDict)
            loadModel('hei_p_m_bag_var22_arm_s')
            loadModel('tr_prop_tr_carry_box_01a')

            bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), pedCo, 1, 1, 0)
            carry = CreateObject(GetHashKey('tr_prop_tr_carry_box_01a'), pedCo, 1, 1, 0)

            sceneObject = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('gr_prop_gr_adv_case'), 0, 0, 0)
            NetworkRegisterEntityAsNetworked(sceneObject)
            scenePos = GetEntityCoords(sceneObject)
            sceneRot = GetEntityRotation(sceneObject)

            scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.0)
            NetworkAddPedToSynchronisedScene(ped, scene, animDict, 'action', 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(bag, scene, animDict, 'action_bag', 4.0, -8.0, 1)
            NetworkAddEntityToSynchronisedScene(carry, scene, animDict, 'action_carry_box', 4.0, -8.0, 1)
            NetworkAddEntityToSynchronisedScene(sceneObject, scene, animDict, 'action_case', 4.0, -8.0, 1)
            
            NetworkStartSynchronisedScene(scene)

            Wait(GetAnimDuration(animDict, 'action') * 1000 - 500)

            TriggerServerEvent('undergroundheist:server:rewardItem', Config['UndergroundHeist']['rewardItems'][3]['itemName'], Config['UndergroundHeist']['rewardItems'][3]['count'], 'item')

            DeleteObject(bag)
            DeleteObject(carry)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['UndergroundHeist']['requiredItems'][2]})
end

function GrabGold()
    TriggerCallback('undergroundheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@scripted@heist@ig1_table_grab@gold@male@'
            local stackModel = -180074230
            loadAnimDict(animDict)
            loadModel('hei_p_m_bag_var22_arm_s')
            bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), pedCo, 1, 1, 0)
            sceneObject = GetClosestObjectOfType(pedCo, 3.0, stackModel, 0, 0, 0)

            scenePos = GetEntityCoords(sceneObject)
            sceneRot = GetEntityRotation(sceneObject)

            for i = 1, #GrabCash['animations'] do
                GrabCash['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.0)
                NetworkAddPedToSynchronisedScene(ped, GrabCash['scenes'][i], animDict, GrabCash['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
                NetworkAddEntityToSynchronisedScene(bag, GrabCash['scenes'][i], animDict, GrabCash['animations'][i][2], 1.0, -1.0, 1148846080)
                if i == 2 then
                    NetworkAddEntityToSynchronisedScene(sceneObject, GrabCash['scenes'][i], animDict, 'grab_gold', 1.0, -1.0, 1148846080)
                end
            end

            NetworkStartSynchronisedScene(GrabCash['scenes'][1])
            Wait(1500)
            NetworkStartSynchronisedScene(GrabCash['scenes'][2])
            Wait(10500)
            DeleteObjectSync(sceneObject)
            NetworkStartSynchronisedScene(GrabCash['scenes'][4])
            Wait(2000)
            
            DeleteObject(bag)
            ClearPedTasks(ped)
            TriggerServerEvent('undergroundheist:server:sync', 'vaultGold')
            TriggerServerEvent('undergroundheist:server:rewardItem', Config['UndergroundHeist']['rewardItems'][4]['itemName'], Config['UndergroundHeist']['rewardItems'][4]['count'], 'item')
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['UndergroundHeist']['requiredItems'][2]})
end

function GrabStacks(index)
    TriggerCallback('undergroundheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            TriggerServerEvent('undergroundheist:server:sync', 'moneyStacks', index)
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@heists@money_grab@duffel'

            for k, v in pairs(MoneyStacks['objects']) do
                loadModel(v)
                MoneyStacks['sceneObjects'][k] = CreateObject(GetHashKey(v), pedCo, 1, 1, 0)
            end
            
            sceneObject = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('prop_cash_crate_01'), 0, 0, 0)
            scenePos = GetEntityCoords(sceneObject)
            sceneRot = GetEntityRotation(sceneObject)
            NetworkRequestControlOfEntity(sceneObject)
            
            cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            camOffset = vector3(-0.029938, 2.228577, 0.703409)
            SetCamActive(cam, true)
            RenderScriptCams(true, true, 1500, true, false)
            SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(sceneObject, camOffset))
            SetCamRot(cam, vector3(0.0, 0.0, GetEntityHeading(sceneObject) + 180))

            for i = 1, #MoneyStacks['animations'] do
                if i == 1 then
                    MoneyStacks['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.0)
                else
                    MoneyStacks['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, true, 1065353216, 0, 1.0)
                end
                NetworkAddPedToSynchronisedScene(ped, MoneyStacks['scenes'][i], animDict, MoneyStacks['animations'][i][1], 1.5, -4.0, 1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(MoneyStacks['sceneObjects'][1], MoneyStacks['scenes'][i], animDict, MoneyStacks['animations'][i][2], 1000.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(MoneyStacks['sceneObjects'][2], MoneyStacks['scenes'][i], animDict, MoneyStacks['animations'][i][3], 4.0, -8.0, 1)
            end

            NetworkStartSynchronisedScene(MoneyStacks['scenes'][1])
            Wait(GetAnimDuration(animDict, 'enter') * 1000)
            NetworkStartSynchronisedScene(MoneyStacks['scenes'][2])
            Wait(500)
            money1 = CreateObject(GetHashKey('hei_prop_heist_cash_pile'), pedCo, 1, 1, 0)
            money2 = CreateObject(GetHashKey('hei_prop_heist_cash_pile'), pedCo, 1, 1, 0)
            AttachEntityToEntity(money1, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
            AttachEntityToEntity(money2, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -21.0, 0, 1, 1, 1, 0, 1)
            Wait(10000)
            DeleteObject(money1)
            DeleteObject(money2)
            DeleteObjectSync(sceneObject)
            NetworkStartSynchronisedScene(MoneyStacks['scenes'][3])
            Wait(GetAnimDuration(animDict, 'exit') * 1000 - 1000)
            TriggerServerEvent('undergroundheist:server:rewardItem', 'money', Config['UndergroundHeist']['moneyStacksReward'], 'money')
            ClearPedTasks(ped)
            DeleteObject(MoneyStacks['sceneObjects'][1])
            DeleteObject(MoneyStacks['sceneObjects'][2])
            RenderScriptCams(false, true, 1500, true, false)
            DestroyCam(cam, false)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['UndergroundHeist']['requiredItems'][2]})
end

function LootChest(index)
    busy = true
    robber = true
    TriggerServerEvent('undergroundheist:server:sync', 'chests', index)
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
    local animDict = 'anim@scripted@heist@ig20_chest_land@male@'
    loadAnimDict(animDict)
    loadModel('h4_prop_h4_gold_coin_01a')
    loadModel('h4_prop_h4_gold_pile_01a')

    sceneObject = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('h4_prop_h4_chest_01a'), 0, 0, 0)
    scenePos = GetEntityCoords(sceneObject)
    sceneRot = GetEntityRotation(sceneObject)
    NetworkRequestControlOfEntity(sceneObject)

    obj2 = CreateObject(GetHashKey('h4_prop_h4_gold_coin_01a'), pedCo, 1, 1, 0)
    obj3 = CreateObject(GetHashKey('h4_prop_h4_gold_pile_01a'), pedCo, 1, 1, 0)

    scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 0.8)
    NetworkAddPedToSynchronisedScene(ped, scene, animDict, 'action_male', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(sceneObject, scene, animDict, 'action_chest', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(obj2, scene, animDict, 'action_coin', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(obj3, scene, animDict, 'action_coinpile', 4.0, -8.0, 1)
    
    NetworkStartSynchronisedScene(scene)
    PlayCamAnim(cam, 'action_cam', animDict, pedCo, pedRotation, 0, 2)

    Wait(7500)

    TriggerServerEvent('undergroundheist:server:rewardItem', Config['UndergroundHeist']['rewardItems'][5]['itemName'], Config['UndergroundHeist']['rewardItems'][5]['count'], 'item')

    ClearPedTasks(ped)
    DeleteObject(obj2)
    DeleteObject(obj3)
    busy = false
end

stacks = {}
chests = {}
function ExtendedSetup()
    loadModel('prop_cash_crate_01')
    for k, v in pairs(Config['UndergroundSetup']['moneyStacks']) do
        stacks[k] = CreateObject(GetHashKey('prop_cash_crate_01'), v['scenePos'], 1, 1, 0)
        SetEntityRotation(stacks[k], v['sceneRot'])
        FreezeEntityPosition(stacks[k], true)
    end
    loadModel('h4_prop_h4_chest_01a')
    for k, v in pairs(Config['UndergroundSetup']['chests']) do
        chests[k] = CreateObject(GetHashKey('h4_prop_h4_chest_01a'), v['scenePos'], 1, 1, 0)
        SetEntityRotation(chests[k], v['sceneRot'])
        FreezeEntityPosition(chests[k], true)
    end
end

function ExtendedDoor()
    TriggerCallback('undergroundheist:server:hasItem', function(data)
        if data['status'] then
            TriggerServerEvent('undergroundheist:server:removeItem', Config['UndergroundHeist']['requiredItems'][5])
            busy = true
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
            keypad = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('tr_prop_tr_fp_scanner_01a'), false, false, false)

            for i = 1, #HackKeypad['animations'] do
                HackKeypad['scenes'][i] = NetworkCreateSynchronisedScene(GetEntityCoords(keypad), GetEntityRotation(keypad), 2, true, false, 1065353216, 0, 1.3)
                NetworkAddPedToSynchronisedScene(ped, HackKeypad['scenes'][i], animDict, HackKeypad['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
                NetworkAddEntityToSynchronisedScene(usb, HackKeypad['scenes'][i], animDict, HackKeypad['animations'][i][2], 1.0, -1.0, 1148846080)
                NetworkAddEntityToSynchronisedScene(phone, HackKeypad['scenes'][i], animDict, HackKeypad['animations'][i][3], 1.0, -1.0, 1148846080)
            end

            NetworkStartSynchronisedScene(HackKeypad['scenes'][1])
            Wait(4000)
            NetworkStartSynchronisedScene(HackKeypad['scenes'][2])
            Wait(2000)
            TriggerEvent("utk_fingerprint:Start", 4, 6, 2, function(outcome, reason)
                if outcome == true then 
                    Wait(5000)
                    NetworkStartSynchronisedScene(HackKeypad['scenes'][3])
                    Wait(4000)
                    DeleteObject(usb)
                    DeleteObject(phone)
                    ClearPedTasks(ped)
                    hacking = false
                    busy = false
                    TriggerServerEvent('undergroundheist:server:sync', 'extendedDoors')
                elseif outcome == false then
                    Wait(5000)
                    NetworkStartSynchronisedScene(HackKeypad['scenes'][4])
                    Wait(4000)
                    DeleteObject(usb)
                    DeleteObject(phone)
                    ClearPedTasks(ped)
                    busy = false    
                    hacking = false
                end
            end)
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['UndergroundHeist']['requiredItems'][5]})
end

function Laser()
    TriggerCallback('undergroundheist:server:hasItem', function(data)
        if data['status'] then
            TriggerServerEvent('undergroundheist:server:removeItem', Config['UndergroundHeist']['requiredItems'][1])
            busy = true
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim_heist@hs3f@ig9_vault_drill@laser_drill@'
            loadAnimDict(animDict)
            local bagModel = 'hei_p_m_bag_var22_arm_s'
            loadModel(bagModel)
            local laserDrillModel = 'ch_prop_laserdrill_01a'
            loadModel(laserDrillModel)

            cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
            SetCamActive(cam, true)
            RenderScriptCams(true, 0, 3000, 1, 0)

            bag = CreateObject(GetHashKey(bagModel), pedCo, 1, 0, 0)
            laserDrill = CreateObject(GetHashKey(laserDrillModel), pedCo, 1, 0, 0)
            SetEntityCollision(laserDrill, false, false)
            
            vaultPos = vector3(942.598, -97.969, 26.2259)
            vaultRot = vector3(0.0, 0.0, 315.0)

            for i = 1, #LaserDrill['animations'] do
                LaserDrill['scenes'][i] = NetworkCreateSynchronisedScene(vaultPos, vaultRot, 2, true, false, 1065353216, 0, 1.3)
                NetworkAddPedToSynchronisedScene(ped, LaserDrill['scenes'][i], animDict, LaserDrill['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
                NetworkAddEntityToSynchronisedScene(bag, LaserDrill['scenes'][i], animDict, LaserDrill['animations'][i][2], 1.0, -1.0, 1148846080)
                NetworkAddEntityToSynchronisedScene(laserDrill, LaserDrill['scenes'][i], animDict, LaserDrill['animations'][i][3], 1.0, -1.0, 1148846080)
            end

            NetworkStartSynchronisedScene(LaserDrill['scenes'][1])
            PlayCamAnim(cam, 'intro_cam', animDict, vaultPos, vaultRot, 0, 2)
            Wait(GetAnimDuration(animDict, 'intro') * 1000)
            
            NetworkStartSynchronisedScene(LaserDrill['scenes'][2])
            PlayCamAnim(cam, 'drill_straight_start_cam', animDict, vaultPos, vaultRot, 0, 2)
            Wait(GetAnimDuration(animDict, 'drill_straight_start') * 1000)

            NetworkStartSynchronisedScene(LaserDrill['scenes'][3])
            PlayCamAnim(cam, 'drill_straight_idle_cam', animDict, vaultPos, vaultRot, 0, 2)
            Drilling.Type = 'VAULT_LASER'
            Drilling.Start(function(status)
                if status then
                    NetworkStartSynchronisedScene(LaserDrill['scenes'][5])
                    PlayCamAnim(cam, 'drill_straight_end_cam', animDict, vaultPos, vaultRot, 0, 2)
                    Wait(GetAnimDuration(animDict, 'drill_straight_end') * 1000)
                    NetworkStartSynchronisedScene(LaserDrill['scenes'][6])
                    PlayCamAnim(cam, 'exit_cam', animDict, vaultPos, vaultRot, 0, 2)
                    Wait(GetAnimDuration(animDict, 'exit') * 1000)
                    RenderScriptCams(false, false, 0, 1, 0)
                    DestroyCam(cam, false)
                    ClearPedTasks(ped)
                    DeleteObject(bag)
                    DeleteObject(laserDrill)
                    TriggerServerEvent('undergroundheist:server:sync', 'vault')
                    busy = false
                else
                    NetworkStartSynchronisedScene(LaserDrill['scenes'][4])
                    PlayCamAnim(cam, 'drill_straight_fail_cam', animDict, vaultPos, vaultRot, 0, 2)
                    Wait(GetAnimDuration(animDict, 'drill_straight_fail') * 1000 - 1500)
                    RenderScriptCams(false, false, 0, 1, 0)
                    DestroyCam(cam, false)
                    ClearPedTasks(ped)
                    DeleteObject(bag)
                    DeleteObject(laserDrill)
                    busy = false
                end
            end)
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['UndergroundHeist']['requiredItems'][1]})
end

function Outside()
    if robber then
        robber = false
        ShowNotification(Strings['deliver_to_buyer'])
        loadModel('baller')
        RemoveBlip(undergroundBlip)
        buyerBlip = addBlip(Config['UndergroundHeist']['finishHeist']['buyerPos'], 500, 0, Strings['buyer_blip'])
        buyerVehicle = CreateVehicle(GetHashKey('baller'), Config['UndergroundHeist']['finishHeist']['buyerPos'].xy + 3.0, Config['UndergroundHeist']['finishHeist']['buyerPos'].z, 269.4, 0, 0)
        while true do
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local dist = #(pedCo - Config['UndergroundHeist']['finishHeist']['buyerPos'])

            if dist <= 15.0 then
                PlayCutscene('hs3f_all_drp2', Config['UndergroundHeist']['finishHeist']['buyerPos'])
                DeleteVehicle(buyerVehicle)
                RemoveBlip(buyerBlip)
                TriggerServerEvent('undergroundheist:server:sellRewardItems')
                break
            end
            Wait(1)
        end
    end
end

RegisterNetEvent('undergroundheist:client:resetHeist')
AddEventHandler('undergroundheist:client:resetHeist', function()
    mainLoop = false
    Client = {
        ['switch'] = true
    }
    UndergroundHeist['switch'] = false
    LootSync = {
        ['virus'] = false,
        ['drugs'] = {},
        ['moneyStacks'] = {},
        ['chests'] = {},
        ['vault'] = false,
        ['vaultOpening'] = false,
        ['vaultGold'] = false,
        ['plantCell'] = false,
        ['extendedDoor'] = false,
        ['safecrack'] = false,
    }
    ClientScenes = {
        ['objects'] = {},
        ['scenes'] = {}
    }
    stacks = {}
    chests = {}
    drugs = {}
    ClearArea(942.598, -97.969, 26.2259, 300.0)
    Wait(2000)
    UndergroundHeist['start'] = false
    Client['switch'] = false
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

function AddTimerBar(time, text, cb)
    RequestStreamedTextureDict("timerbars", true)
    while not HasStreamedTextureDictLoaded("timerbars") do
        Citizen.Wait(50)
    end
    timer = true
    percent = 1700
    width = 0.005
    w = width * (percent / 100)
    x = (0.95 - (width * (percent / 100)) / 2) - width / 2
    while timer do
        percent = percent - (1700 / (time * 100))
        width = 0.005
        w = width * (percent / 100)
        x = (0.91 - (width * (percent / 100)) / 2) - width / 2
        DrawSprite('TimerBars', 'ALL_BLACK_bg', 0.95, 0.95, 0.15, 0.0305, 0.0, 255, 255, 255, 180)
        DrawRect(0.95, 0.95, 0.085, 0.0109, 100, 0, 0, 180)
        DrawRect(x + w , 0.95, w, 0.0109, 150, 0, 0, 255)
        SetTextColour(255, 255, 255, 180)
        SetTextFont(0)
        SetTextScale(0.3, 0.3)
        SetTextCentre(true)
        SetTextEntry('STRING')
        AddTextComponentString(text)
        DrawText(0.878, 0.938)
        if percent <= 0 then
            cb(true)
            break
        end
        Wait(0)
    end
    SetStreamedTextureDictAsNoLongerNeeded("timerbars")
end

RegisterNetEvent('undergroundheist:client:sceneSync')
AddEventHandler('undergroundheist:client:sceneSync', function(model, animDict, animName, pos, rotation)
    loadAnimDict(animDict)

    ClientScenes['objects'][#ClientScenes['objects'] + 1] = CreateObject(GetHashKey(model), pos, 0, 0, 0)
    ClientScenes['scenes'][#ClientScenes['scenes'] + 1] = CreateSynchronizedScene(pos['xy'], pos['z'], rotation, 2, true, false, 1065353216, 0, 1065353216)

    PlaySynchronizedEntityAnim(ClientScenes['objects'][#ClientScenes['objects']], ClientScenes['scenes'][#ClientScenes['scenes']], animName, animDict, 1.0, -1.0, 0, 1148846080)
    ForceEntityAiAndAnimationUpdate(ClientScenes['objects'][#ClientScenes['objects']])

    SetSynchronizedScenePhase(ClientScenes['scenes'][#ClientScenes['scenes']], 0.99)
    FreezeEntityPosition(ClientScenes['objects'][#ClientScenes['objects']], true)
end)

function DeleteObjectSync(entity)
    TriggerServerEvent('undergroundheist:server:sync', 'deleteObject', NetworkGetNetworkIdFromEntity(entity))
end