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
HeistSync = {
    ['stack'] = false,
    ['lockbox_1'] = false,
    ['lockbox_2'] = false,
    ['trolly_1'] = false,
    ['trolly_2'] = false,
    ['bolt_cutter'] = false,
    ['vault_drill'] = false,
    ['enter_thermite'] = false
}
math.randomseed(GetGameTimer())
BettaHeist = {
    ['startPeds'] = {}
}
crateIndexCheck = {}

ESX, QBCore, TargetScript = nil, nil, Config['BettaHeist']['framework']['targetScript']
Citizen.CreateThread(function()
    if Config['BettaHeist']['framework']['name'] == 'ESX' then
        while not ESX do
            pcall(function() ESX = exports[Config['BettaHeist']['framework']['scriptName']]:getSharedObject() end)
            if not ESX then
                TriggerEvent(Config['BettaHeist']['framework']['eventName'], function(library) 
                    ESX = library 
                end)
            end
            Citizen.Wait(1)
        end
    elseif Config['BettaHeist']['framework']['name'] == 'QB' then
        while not QBCore do
            pcall(function() QBCore =  exports[Config['BettaHeist']['framework']['scriptName']]:GetCoreObject() end)
            if not QBCore then
                pcall(function() QBCore =  exports[Config['BettaHeist']['framework']['scriptName']]:GetSharedObject() end)
            end
            if not QBCore then
                TriggerEvent(Config['BettaHeist']['framework']['eventName'], function(obj) QBCore = obj end)
            end
            Citizen.Wait(1)
        end
    end
end)

function TriggerCallback(cbName, cb, data)
    if Config['BettaHeist']['framework']['name'] == 'ESX' then
        ESX.TriggerServerCallback(cbName, function(data)
            if cb then cb(data) else return data end
        end, data)
    elseif Config['BettaHeist']['framework']['name'] == 'QB' then
        QBCore.Functions.TriggerCallback(cbName, function(data)
            if cb then cb(data) else return data end
        end, data)
    end
end

Citizen.CreateThread(function()
    for k, v in pairs(Config['BettaHeist']['startHeist']['peds']) do
        loadModel(v['ped'])
        BettaHeist['startPeds'][k] = CreatePed(4, GetHashKey(v['ped']), v['pos']['x'], v['pos']['y'], v['pos']['z'] - 0.95, v['heading'], false, true)
        FreezeEntityPosition(BettaHeist['startPeds'][k], true)
        SetEntityInvincible(BettaHeist['startPeds'][k], true)
        SetBlockingOfNonTemporaryEvents(BettaHeist['startPeds'][k], true)
    end
    if TargetScript == 'qtarget' or TargetScript == 'qb-target' then
        exports[TargetScript]:AddBoxZone("BettaHeist", Config['BettaHeist']['startHeist']['pos'], 1.1, 2.35, 
        {
            name = "BettaHeist",
            heading = 20.0,
            debugPoly = false,
            minZ = Config['BettaHeist']['startHeist']['pos'] - 1.0,
            maxZ = Config['BettaHeist']['startHeist']['pos'] + 0.3,
        }, 
        {
            options = {
                {
                    event = "bettaheist:client:startHeist",
                    icon = "fa-solid fa-mask",
                    label = Strings['t_heist'],
                    job = "all",
                },
            },
            distance = 1.5
        })
    elseif TargetScript == 'ox_target' then
        exports[TargetScript]:addBoxZone({
            coords = Config['BettaHeist']['startHeist']['pos'],
            size = vec3(2, 2, 2),
            rotation = 20,
            debug = false,
            options = {
                {
                    name = "BettaHeist",
                    event = "bettaheist:client:startHeist",
                    icon = "fa-solid fa-mask",
                    label = Strings['t_heist'],
                    canInteract = function(entity, distance, coords, name)
                        return true
                    end
                }
            }
        })
    end
end)

RegisterNetEvent('bettaheist:client:startHeist')
AddEventHandler('bettaheist:client:startHeist', function()
    TriggerCallback('bettaheist:server:checkPoliceCount', function(data)
        if data['status'] then
            TriggerCallback('bettaheist:server:checkTime', function(data)
                if data['status'] then
                    bettaBlip = addBlip(Config['BettaSetup']['main'], 128, 70, Strings['betta_blip'])
                    ShowNotification(Strings['heist_info'])
                    ShowNotification(Strings['heist_info2'])
                    SetupBetta()
                end
            end)
        end
    end)
end)

targetIds = {}
RegisterNetEvent('bettaheist:client:sync')
AddEventHandler('bettaheist:client:sync', function(type, args)
    if type == 'enterDoors' then
        enterDoorsLoop = true
        Citizen.CreateThread(function()
            while enterDoorsLoop do
                local doors = {
                    GetClosestObjectOfType(vector3(-1228.9, -336.97, 36.5160), 1.0, GetHashKey('v_ilev_genbankdoor1'), 0, 0, 0),
                    GetClosestObjectOfType(vector3(-1231.2, -338.16, 36.5160), 1.0, GetHashKey('v_ilev_genbankdoor2'), 0, 0, 0),
                }
                SetEntityHeading(doors[1], GetEntityHeading(doors[1]) + 1.5)
                SetEntityHeading(doors[2], GetEntityHeading(doors[2]) - 1.5)
                if GetEntityHeading(doors[1]) >= 105.0 then
                    enterDoorsLoop = false
                    break
                end
                Citizen.Wait(1)
            end
        end)
    elseif type == 'vaultDoor' then
        vaultDoorsLoop = true
        Citizen.CreateThread(function()
            while vaultDoorsLoop do
                local door = GetClosestObjectOfType(vector3(-1223.727, -342.5209, 36.6874), 1.0, GetHashKey('prop_ld_vault_door'), 0, 0, 0)
                SetEntityHeading(door, GetEntityHeading(door) - 1.5)
                if GetEntityHeading(door) <= 175.0 then
                    vaultDoorsLoop = false
                    break
                end
                Citizen.Wait(1)
            end
        end)
    elseif type == 'lockedDoor' then
        lockedDoorLoop = true
        Citizen.CreateThread(function()
            while lockedDoorLoop do
                local lockedDoor = GetClosestObjectOfType(vector3(-1218.855, -343.2368, 36.4724), 1.0, GetHashKey('v_ilev_gb_vaubar'), 0, 0, 0)
                SetEntityHeading(lockedDoor, GetEntityHeading(lockedDoor) + 0.5)
                if GetEntityHeading(lockedDoor) >= 275.0 then
                    lockedDoor = false
                    break
                end
                Citizen.Wait(1)
            end
        end)
    elseif type == 'heistSync' then
        if args[2] then
            HeistSync[args[1]][args[2]] = not HeistSync[args[1]][args[2]]
        else
            HeistSync[args[1]] = not HeistSync[args[1]]
        end
    elseif type == 'mainLoop' then
        for k, v in pairs(Config['BettaSetup']['actions']) do
            if TargetScript == 'qtarget' or TargetScript == 'qb-target' then
                exports[TargetScript]:AddBoxZone("BettaHeist"..k, v['coords'], v['length'], v['width'], 
                {
                    name = "BettaHeist"..k,
                    heading = v['heading'],
                    debugPoly = v['debugPoly'],
                    minZ = v['minZ'],
                    maxZ = v['maxZ'],
                }, 
                {
                    options = v['options'],
                    distance = v['distance']
                })
            elseif TargetScript == 'ox_target' then
                targetIds[#targetIds + 1] = exports[TargetScript]:addBoxZone({
                    coords = v['coords'],
                    size = vec3(2, 2, 2),
                    rotation = v['heading'],
                    debug = false,
                    options = v['options'],
                })
            end
        end
        if Config['BettaHeist']['buyerFinishScene'] then
            Citizen.CreateThread(function()
                while true do
                    local ped = PlayerPedId()
                    local pedCo = GetEntityCoords(ped)
                    local dist = #(pedCo - Config['BettaSetup']['main'])

                    if dist >= 100.0 and robber then
                        Outside()
                        break
                    end
                    
                    Citizen.Wait(1)
                end
            end)
        end
    elseif type == 'deleteLockbox' then
        local object = GetClosestObjectOfType(args[1], 2.0, GetHashKey('ch_prop_ch_sec_cabinet_01b'), 0, 0, 0)
        SetEntityAsMissionEntity(object, 1, 1)
        DeleteObject(object)
    elseif type == 'ptfx' then
        loadPtfxAsset('scr_ornate_heist')
        UseParticleFxAssetNextCall('scr_ornate_heist')
        ptfx = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", args[1], 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        Wait(13000)
        StopParticleFxLooped(ptfx, 0)
    elseif type == 'delete' then
        local entity =  NetworkGetEntityFromNetworkId(args[1])
        DeleteObject(entity)
    elseif type == 'resetHeist' then
        for k, v in pairs(Config['BettaSetup']['actions']) do
            if TargetScript == 'qtarget' or TargetScript == 'qb-target' then
                exports[TargetScript]:RemoveZone("BettaHeist"..k)
            elseif TargetScript == 'ox_target' then
                for i = 1, #targetIds do
                    exports[TargetScript]:removeZone(targetIds[i])
                end
                targetIds = {}
            end
        end
        dTrollys = {}
        for k, v in pairs(Config['BettaSetup']['trollys']) do
            if v['type'] == 'diamond' then
                dTrollys[k] = GetClosestObjectOfType(v['coords'], 1.5, GetHashKey('ch_prop_diamond_trolly_01c'), 0, 0, 0)
            elseif v['type'] == 'gold' then
                dTrollys[k] = GetClosestObjectOfType(v['coords'], 1.5, GetHashKey('ch_prop_gold_trolly_01a'), 0, 0, 0)
            elseif v['type'] == 'money' then
                dTrollys[k] = GetClosestObjectOfType(v['coords'], 1.5, GetHashKey('ch_prop_ch_cash_trolly_01b'), 0, 0, 0)
            end
            DeleteObject(dTrollys[k])
        end
        HeistSync = {
            ['stack'] = false,
            ['lockbox_1'] = false,
            ['lockbox_2'] = false,
            ['trolly_1'] = false,
            ['trolly_2'] = false,
            ['bolt_cutter'] = false,
            ['vault_drill'] = false,
            ['enter_thermite'] = false
        }
        CreateBettaMap()
        ClearArea(Config['BettaSetup']['main'], 50.0)
    end
end)

RegisterNetEvent('bettaheist:client:actions')
AddEventHandler('bettaheist:client:actions', function(data)
    if data['scene'] == 'lockbox_1' then
        LockboxDrill(1)
    elseif data['scene'] == 'lockbox_2' then
        LockboxDrill(2)
    elseif data['scene'] == 'trolly_1' then
        GrabTrollys(1)
    elseif data['scene'] == 'trolly_2' then
        GrabTrollys(2)
    elseif data['scene'] == 'stack' then
        GrabStacks()
    elseif data['scene'] == 'bolt_cutter' then
        BoltCutter()
    elseif data['scene'] == 'vault_drill' then
        VaultDrill()
    elseif data['scene'] == 'enter_thermite'then
        CellBomb()
    end
end)

trollys = {}
function SetupBetta()
    while true do
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)
        local dist = #(pedCo - Config['BettaSetup']['main'])
        if dist <= 50.0 then
            break
        end
        Wait(1)
    end
    policeAlert(Config['BettaSetup']['main'])
    loadModel('h4_prop_h4_chain_lock_01a')
    chainlock = CreateObject(GetHashKey('h4_prop_h4_chain_lock_01a'), vector3(-1220.249, -343.9683, 37.9083), 1, 1, 0)
    SetEntityHeading(chainlock, -153.0)
    FreezeEntityPosition(chainlock, true)
    loadModel('h4_prop_h4_cash_stack_01a')
    cashStack = CreateObject(GetHashKey('h4_prop_h4_cash_stack_01a'), vector3(-1218.7, -346.15, 37.6852), 1, 1, 0)
    SetEntityHeading(cashStack, 208.2)
    for k, v in pairs(Config['BettaSetup']['trollys']) do
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
    end
    TriggerServerEvent('bettaheist:server:sync', 'mainLoop')
end

function BoltCutter()
    TriggerCallback('bettaheist:server:hasItem', function(data)
        if data['status'] then
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local animDict = 'anim@scripted@heist@ig4_bolt_cutters@male@'
            busy = true
            robber = true

            loadModel('h4_prop_h4_bolt_cutter_01a')
            loadModel('h4_p_h4_m_bag_var22_arm_s')
            cutter = CreateObject(GetHashKey('h4_prop_h4_bolt_cutter_01a'), pedCo, 1, 1, 0)
            bag = CreateObject(GetHashKey('h4_p_h4_m_bag_var22_arm_s'), pedCo, 1, 1, 0)

            sceneObject = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('h4_prop_h4_chain_lock_01a'), 0, 0, 0)
            scenePos = GetEntityCoords(sceneObject)
            sceneRot = GetEntityRotation(sceneObject)

            cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamActive(cam, true)
            RenderScriptCams(true, true, 1000, true, false)
            SetCamCoord(cam, -1221.05, -344.08, 38.03)
            SetCamRot(cam, vector3(0.0, 0.0, -66.08))

            scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.0)
            NetworkAddPedToSynchronisedScene(ped, scene, animDict, 'action_male', 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(bag, scene, animDict, 'action_bag', 4.0, -8.0, 1)
            NetworkAddEntityToSynchronisedScene(cutter, scene, animDict, 'action_cutter', 4.0, -8.0, 1)
            NetworkAddEntityToSynchronisedScene(sceneObject, scene, animDict, 'action_chain', 4.0, -8.0, 1)

            SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(scene)
            Wait(7500)
            SetPedComponentVariation(ped, 5, Config['BettaHeist']['bagClothesID'], 0, 0)
            DeleteObject(sceneObject)
            DeleteObject(bag)
            DeleteObject(cutter)
            RenderScriptCams(false, true, 1000, 1, 0)
            DestroyCam(cam, false)
            ClearPedTasks(ped)
            TriggerServerEvent('bettaheist:server:sync', 'heistSync', {'bolt_cutter'})
            TriggerServerEvent('bettaheist:server:sync', 'lockedDoor')
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['BettaHeist']['requiredItems'][5]})
end

function VaultDrill()
    TriggerCallback('bettaheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            TriggerServerEvent('bettaheist:server:sync', 'heistSync', {'vault_drill'})
            TriggerServerEvent('bettaheist:server:removeItem', Config['BettaHeist']['requiredItems'][3])
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local door = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('prop_ld_vault_door'), 0, 0, 0)
            local animDict = 'anim@scripted@heist@ig11_bomb_plant@male@'
            local drillCo = vector3(-1222.43, -342.4396, 37.2323)
            local drillRot = vector3(-90.0, 0.0, 117.0)
            loadModel('gr_prop_gr_speeddrill_01c')
            loadAnimDict(animDict)
            loadModel('hei_p_m_bag_var22_arm_s')
            RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
            RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
            RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
            bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), pedCo, 1, 1, 0)
            
            scenePos = GetOffsetFromEntityInWorldCoords(door, 0.5, -0.52, 0.5)
            sceneRot = GetEntityRotation(door)
            
            scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 0.5)
            NetworkAddPedToSynchronisedScene(ped, scene, animDict, 'enter', 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(bag, scene, animDict, 'enter_bag', 4.0, -8.0, 1)
            SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(scene)

            Wait(2000)
            SetPedComponentVariation(ped, 5, Config['BettaHeist']['bagClothesID'], 0, 0)
            DeleteObject(bag)
            
            drill = CreateObject(GetHashKey('gr_prop_gr_speeddrill_01c'), drillCo, true, true, false)
            SetEntityRotation(drill, drillRot)
            FreezeEntityPosition(drill, true)
            soundId = GetSoundId()
            PlaySoundFromEntity(soundId, "Drill", drill, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
            loadPtfxAsset('scr_fbi5a')
            UseParticleFxAssetNextCall('scr_fbi5a')
            ptfx = StartNetworkedParticleFxLoopedOnEntity('scr_bio_grille_cutting', drill, -0.044, -0.15, 1.2, 0.0, 90.0, 0.0, 1.2, false, false, false)
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
            AddTimerBar(Config['BettaHeist']['drillTime'], Strings['drill_bar'], function(status)
                if status then
                    TriggerServerEvent('bettaheist:server:sync', 'vaultDoor')
                    DeleteObject(drill)
                    busy = false
                    StopSound(soundId)
                    effectTimer = false
                end
            end)
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['BettaHeist']['requiredItems'][3]})
end

function CellBomb()
    TriggerCallback('bettaheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            TriggerServerEvent('bettaheist:server:sync', 'heistSync', {'enter_thermite'})
            TriggerServerEvent('bettaheist:server:removeItem', Config['BettaHeist']['requiredItems'][4])
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@heists@ornate_bank@thermal_charge'
            local door = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('v_ilev_genbankdoor1'), 0, 0, 0)
            scenePos = GetOffsetFromEntityInWorldCoords(door, -1.30, 0.10, -0.15)
            sceneRot = GetEntityRotation(door) + vector3(0.0, 0.0, 175.0)
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
            SetPedComponentVariation(ped, 5, Config['BettaHeist']['bagClothesID'], 0, 0)
            DeleteObject(bag)
            DetachEntity(plantObject, 1, 1)
            FreezeEntityPosition(plantObject, true)
            ptfxPos = GetOffsetFromEntityInWorldCoords(door, -0.85, 1.0, -0.15)
            TriggerServerEvent('bettaheist:server:sync', 'ptfx', {ptfxPos})
            TaskPlayAnim(ped, animDict, "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
            TaskPlayAnim(ped, animDict, "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
            Wait(2000)
            ClearPedTasks(ped)
            busy = false
            Wait(11000)
            TriggerServerEvent('bettaheist:server:sync', 'enterDoors')
            DeleteObject(plantObject)
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['BettaHeist']['requiredItems'][4]})
end

function GrabTrollys(index)
    TriggerCallback('bettaheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            TriggerServerEvent('bettaheist:server:sync', 'heistSync', {'trolly_'..index})
            local ped = PlayerPedId()
            local pedCo  = GetEntityCoords(ped)
            local animDict = 'anim@heists@ornate_bank@grab_cash'
            local grabModel = Config['BettaSetup']['trollys'][index]['type']
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
            SetPedComponentVariation(ped, 5, Config['BettaHeist']['bagClothesID'], 0, 0)
            DeleteObject(bag)
            ClearPedTasks(ped)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['BettaHeist']['requiredItems'][1]})
end

function CashAppear(grabModel)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    if grabModel == 'ch_prop_gold_bar_01a' then
        reward = 'gold'
    elseif grabModel == 'hei_prop_heist_cash_pile' then
        reward = 'money'
    elseif grabModel == 'ch_prop_vault_dimaondbox_01a' then
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
                    if reward == 'gold' then
                        TriggerServerEvent('bettaheist:server:rewardItem', Config['BettaHeist']['rewardItems'][1]['itemName'], 1, 'item')
                    else
                        TriggerServerEvent('bettaheist:server:rewardItem', Config['BettaHeist']['rewardItems'][2]['itemName'], 1, 'item')
                    end
                end
            end
        end
        DeleteObject(grabobj)
    end)
end

function GrabStacks()
    TriggerCallback('bettaheist:server:hasItem', function(data)
        if data['status'] then
            TriggerServerEvent('bettaheist:server:sync', 'heistSync', {'stack'})
            for i = 1, 2 do
                busy = true
                robber = true
                local ped = PlayerPedId()
                local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
                local stackModel = GetHashKey('h4_prop_h4_cash_stack_01a')
                local animDict = 'anim@scripted@heist@ig1_table_grab@cash@male@'
                
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

                SetEntityCoords(ped, pedCo['xy'], pedCo['z'] - 0.95)
                Wait(100)
                SetPedComponentVariation(ped, 5, 0, 0, 0)
                NetworkStartSynchronisedScene(GrabCash['scenes'][1])
                if i ~= 1 then
                    Wait(GetAnimDuration(animDict, 'enter') * 1000)
                end
                NetworkStartSynchronisedScene(GrabCash['scenes'][2])
                if i ~= 1 then
                    Wait(GetAnimDuration(animDict, 'grab') * 1000)
                end
                if i == 2 or canDelete then
                    DeleteObjectSync(sceneObject)
                end
                NetworkStartSynchronisedScene(GrabCash['scenes'][4])
                if i ~= 1 then
                    Wait(GetAnimDuration(animDict, 'exit') * 1000)
                end
                SetPedComponentVariation(ped, 5, Config['BettaHeist']['bagClothesID'], 0, 0)

                DeleteObject(bag)
                ClearPedTasks(ped)
                busy = false
            end
            TriggerServerEvent('bettaheist:server:rewardItem', 'nil', Config['BettaHeist']['rewardMoneys']['stacks'](), 'money')
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['BettaHeist']['requiredItems'][1]})
end

function LockboxDrill(index)
    TriggerCallback('bettaheist:server:hasItem', function(data)
        if data['status'] then
            busy = true
            robber = true
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), vector3(0.0, 0.0, 0.0)
            TriggerServerEvent('bettaheist:server:sync', 'heistSync', {'lockbox_'..index})
            TriggerServerEvent('bettaheist:server:removeItem', Config['BettaHeist']['requiredItems'][2])

            -- while not RequestScriptAudioBank("DLC_HEIST3/CASINO_HEIST_FINALE_GENERAL_01", false, -1) do 
            --     RequestScriptAudioBank("DLC_HEIST3/CASINO_HEIST_FINALE_GENERAL_01", false, -1)
            -- end

            local model = 'ch_prop_ch_sec_cabinet_01b'
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
            local pos_n = GetEntityCoords(test)
            local hea_n = GetEntityHeading(test)
            TriggerServerEvent('bettaheist:server:sync', 'deleteLockbox', {pos_n})
            local test = CreateObject(model, pos_n, 1, 1, 0)
            SetEntityHeading(test, hea_n)
            FreezeEntityPosition(test, true)
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
                local reward = Config['BettaHeist']['rewardLockbox']()
                TriggerServerEvent('bettaheist:server:rewardItem', reward.item, reward.count, 'item', index)
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
                local reward = Config['BettaHeist']['rewardLockbox']()
                TriggerServerEvent('bettaheist:server:rewardItem', reward.item, reward.count, 'item', index)
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
                local reward = Config['BettaHeist']['rewardLockbox']()
                TriggerServerEvent('bettaheist:server:rewardItem', reward.item, reward.count, 'item', index)
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
                local reward = Config['BettaHeist']['rewardLockbox']()
                TriggerServerEvent('bettaheist:server:rewardItem', reward.item, reward.count, 'item', index)
            else
                NetworkStartSynchronisedScene(Lockbox['scenes']['44'])
                Wait((GetAnimDuration(animDicts[pattern][4], 'no_reward') * 1000) - 1000)
            end
            TriggerServerEvent('bettaheist:server:sceneSync', model, animDicts[pattern][4], Lockbox['animations'][4][2]..pattern, GetEntityCoords(test), GetEntityRotation(test))
            ClearPedTasks(ped)
            RenderScriptCams(false, true, 1500, true, false)
            DestroyCam(cam, false)
            SetPedComponentVariation(ped, 5, Config['BettaHeist']['bagClothesID'], 0, 0)
            for k, v in pairs(Lockbox['sceneObjects']) do
                DeleteObject(v)
            end
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['BettaHeist']['requiredItems'][2]})
end

function Outside()
    if robber then
        robber = false
        ShowNotification(Strings['deliver_to_buyer'])
        loadModel('baller')
        RemoveBlip(bettaBlip)
        buyerBlip = addBlip(Config['BettaHeist']['finishHeist']['buyerPos'], 500, 0, Strings['buyer_blip'])
        buyerVehicle = CreateVehicle(GetHashKey('baller'), Config['BettaHeist']['finishHeist']['buyerPos'].xy + 7.0, Config['BettaHeist']['finishHeist']['buyerPos'].z, 269.4, 0, 0)
        while true do
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local dist = #(pedCo - Config['BettaHeist']['finishHeist']['buyerPos'])

            if dist <= 15.0 then
                PlayCutscene('hs3f_all_drp3', Config['BettaHeist']['finishHeist']['buyerPos'])
                DeleteVehicle(buyerVehicle)
                RemoveBlip(buyerBlip)
                TriggerServerEvent('bettaheist:server:sellRewardItems')
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
RegisterNetEvent('bettaheist:client:sceneSync')
AddEventHandler('bettaheist:client:sceneSync', function(model, animDict, animName, pos, rotation)
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
    TriggerServerEvent('bettaheist:server:sync', 'delete', {NetworkGetNetworkIdFromEntity(entity)})
end