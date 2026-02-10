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
LootSync = {
    ['stacks'] = {},
    ['trollys'] = {}
}
HeistSync = {
    ['start'] = false,
    ['server-switch'] = false
}
UnionHeist = {
    ['startPeds'] = {}
}
ESX, QBCore = nil, nil
Citizen.CreateThread(function()
    if Config['UnionHeist']['enableIPL'] then
        RequestIpl("v_tunnel_hole")
	    RequestIpl('FINBANK')
    end
    if Config['UnionHeist']['framework']['name'] == 'ESX' then
        while not ESX do
            pcall(function() ESX = exports[Config['UnionHeist']['framework']['scriptName']]:getSharedObject() end)
            if not ESX then
                TriggerEvent(Config['UnionHeist']['framework']['eventName'], function(library) 
                    ESX = library 
                end)
            end
            Citizen.Wait(1)
        end
    elseif Config['UnionHeist']['framework']['name'] == 'QB' then
        while not QBCore do
            pcall(function() QBCore =  exports[Config['UnionHeist']['framework']['scriptName']]:GetCoreObject() end)
            if not QBCore then
                pcall(function() QBCore =  exports[Config['UnionHeist']['framework']['scriptName']]:GetSharedObject() end)
            end
            if not QBCore then
                TriggerEvent(Config['UnionHeist']['framework']['eventName'], function(obj) QBCore = obj end)
            end
            Citizen.Wait(1)
        end
    end
    for k, v in pairs(Config['UnionHeist']['startHeist']['peds']) do
        loadModel(v['ped'])
        UnionHeist['startPeds'][k] = CreatePed(4, GetHashKey(v['ped']), v['pos']['x'], v['pos']['y'], v['pos']['z'] - 0.95, v['heading'], false, true)
        FreezeEntityPosition(UnionHeist['startPeds'][k], true)
        SetEntityInvincible(UnionHeist['startPeds'][k], true)
        SetBlockingOfNonTemporaryEvents(UnionHeist['startPeds'][k], true)
    end
end)

function TriggerCallback(cbName, cb, data)
    if Config['UnionHeist']['framework']['name'] == 'ESX' then
        ESX.TriggerServerCallback(cbName, function(data)
            if cb then cb(data) else return data end
        end, data)
    elseif Config['UnionHeist']['framework']['name'] == 'QB' then
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
        local startDist = #(pedCo - Config['UnionHeist']['startHeist']['pos'])
        if startDist <= 2.0 then
            sleep = 1
            ShowHelpNotification(Strings['e_start'])
            if IsControlJustPressed(0, 38) then
                StartUnionHeist()
            end
        end
        if HeistSync['start'] then
            local dist = #(pedCo - vector3(9.06080, -656.23, 16.0938))
            if dist <= 100.0 then
                sleep = 1
                local tunnel = GetRayfireMapObject(7.25, -656.98, 17.14, 50.0, "des_finale_tunnel")
                local vault = GetRayfireMapObject(7.25, -656.98, 17.14, 50.0, "des_finale_vault")
                local tunnelState = GetStateOfRayfireMapObject(tunnel) - 1
                local vaultState = GetStateOfRayfireMapObject(vault) - 1
                if not HeistSync['server-switch'] then
                    if tunnelState ~= 2 and vaultState ~= 2 then
                        SetStateOfRayfireMapObject(tunnel, 2)
                        SetStateOfRayfireMapObject(vault, 2)
                    end
                else
                    if tunnelState ~= 9 and vaultState ~= 9 then
                        for i = 1, 3 do
                            SetStateOfRayfireMapObject(tunnel, 9)
                            SetStateOfRayfireMapObject(vault, 9)
                            Citizen.Wait(500)
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function StartUnionHeist()
    TriggerCallback('unionheist:server:checkPoliceCount', function(data)
        if data['status'] then
            TriggerCallback('unionheist:server:checkTime', function(data)
                if data['status'] then
                    builderCfg = Config['UnionSetup']['builder']
                    builderBlip = addBlip(builderCfg['coords'], 128, 70, Strings['builder_blip'])
                    ShowNotification(Strings['go_to_rent'])
                    ShowNotification(Strings['start_heist'])
                    while true do
                        local ped = PlayerPedId()
                        local pedCo = GetEntityCoords(ped)
                        local dist = #(pedCo - builderCfg['coords'])
                        if dist <= 30.0 then
                            break
                        end
                        Wait(1)
                    end
                    loadModel(builderCfg['model'])
                    builder = CreatePed(4, GetHashKey(builderCfg['model']), builderCfg['coords'], builderCfg['heading'], 1, 0)
                    NetworkRegisterEntityAsNetworked(builder)
                    networkID = NetworkGetNetworkIdFromEntity(builder)
                    SetNetworkIdCanMigrate(builder, true)
                    SetNetworkIdExistsOnAllMachines(networkID, true)
                    SetEntityInvincible(builder, true)
                    SetBlockingOfNonTemporaryEvents(builder, true)
                    FreezeEntityPosition(builder, true)
                    TaskStartScenarioInPlace(builder, 'WORLD_HUMAN_SMOKING', 0, true)
                    Citizen.CreateThread(function()
                        builderLoop = true
                        while builderLoop do
                            local ped = PlayerPedId()
                            local pedCo = GetEntityCoords(ped)
                            local dist = #(pedCo - builderCfg['coords'])
                            if dist <= 2.0 then
                                ShowHelpNotification(Strings['rent_cutter'])
                                if IsControlJustPressed(0, 38) then
                                    BuilderMeet()
                                end
                            end
                            Citizen.Wait(1)
                        end
                    end)
                end
            end)
        end
    end)
end

function BuilderMeet()
    TriggerCallback('unionheist:server:hasMoney', function(data)
        if data['status'] then
            builderLoop = false
            RemoveBlip(builderBlip)
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            loadAnimDict('mp_ped_interaction')
            ClearPedTasksImmediately(builder)
            ShowNotification(Strings['cutter_ready'])
            Wait(1000)
            scene = NetworkCreateSynchronisedScene(GetEntityCoords(builder), GetEntityRotation(builder), 2, false, false, 1065353216, 0, 0.8)
            NetworkAddPedToSynchronisedScene(builder, scene, 'mp_ped_interaction', 'hugs_guy_a', 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddPedToSynchronisedScene(ped, scene, 'mp_ped_interaction', 'hugs_guy_b', 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkStartSynchronisedScene(scene)
            PlayPedAmbientSpeechWithVoiceNative(builder, "GENERIC_THANKS", "MP_M_SHOPKEEP_01_PAKISTANI_MINI_01", "SPEECH_PARAMS_FORCE", 1)
            Wait(5000)
            FreezeEntityPosition(builder, false)
            TaskWanderStandard(builder, 10.0, -1)
            Citizen.CreateThread(function()
                Citizen.Wait(15000)
                DeletePed(builder)
            end)
            TriggerServerEvent('unionheist:server:spawnCutter')
            TriggerServerEvent('unionheist:server:sync', 'startHeist')
            cutterBlip = addBlip(Config['UnionSetup']['cutter']['coords'], 128, 70, Strings['cutter_blip'])
        else
            PlayPedAmbientSpeechWithVoiceNative(builder, "APOLOGY_NO_TROUBLE", "MP_M_SHOPKEEP_01_PAKISTANI_MINI_01", "SPEECH_PARAMS_FORCE", 1)
        end
    end, {count = Config['UnionHeist']['cutterPrice']})
end

function StartDrill()
    policeAlert(vector3(17.82935, -655.7859, 17.53649))
    TriggerServerEvent('unionheist:server:sync', 'cutter')
    TriggerServerEvent('unionheist:server:sync', 'enterSync')

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 17.82935, -655.7859, 17.53649, -2.166965, -0.006385, 90.21768, 29.27551, true, 2)
    SetCamParams(cam, 17.83112, -656.2527, 17.53645, -2.166965, -0.006385, 90.21768, 29.27551, 7000, 0, 0, 2)
    RenderScriptCams(true, true, 3000, true, false, 0)

    PrepareMusicEvent('FH2B_DRILL_START')

    while not LoadStream("DRILL_WALL", "BIG_SCORE_3B_SOUNDS") do
        LoadStream("DRILL_WALL", "BIG_SCORE_3B_SOUNDS")
        Wait(1)
    end

    while not HasVehicleRecordingBeenLoaded(551, 'finheistb') do
        RequestVehicleRecording(551, 'finheistb')
        Wait(1)
    end

    PlayStreamFrontend()
    StartAudioScene('BS_2B_VAULT_RAYFIRE')
    TriggerMusicEvent("FH2B_DRILL_START");
    FreezeEntityPosition(cutter, true)
    StartPlaybackRecordedVehicle(cutter, 551, 'finheistb', false)
    ForcePlaybackRecordedVehicleUpdate(cutter, false)
    SetVehicleActiveDuringPlayback(cutter, true)
    ResetVehicleWheels(cutter, false)
    SetPlaybackSpeed(cutter, 0.55)

    Wait(6000)

    SetCamParams(cam, 0.046478, -670.565, 15.83248, 3.964742, 0.0234, -32.68171, 33.15422, 0, 1, 1, 2)
    SetCamParams(cam, -0.497207, -671.4125, 15.76269, 7.658487, 0.023399, -33.58463, 33.15422, 20000, 3, 3, 2)
                    
    Wait(10000)

    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    UnionSetup()
    FreezeEntityPosition(cutter, false)
end

RegisterNetEvent('unionheist:client:sync')
AddEventHandler('unionheist:client:sync', function(type, index, index2)
    if type == 'startHeist' then
        cutterLoop = true
        Citizen.CreateThread(function()
            while cutterLoop do
                local ped = PlayerPedId()
                local pedCo = GetEntityCoords(ped)
                local dist = #(pedCo - vector3(9.06080, -656.23, 16.0938))
                local vehicle = GetVehiclePedIsIn(ped, false)
                if GetEntityModel(vehicle) == GetHashKey('cutter') then
                    if dist <= 10.0 then
                        ShowHelpNotification(Strings['drill'])
                        if IsControlJustPressed(0, 38) then
                            cutter = vehicle
                            StartDrill()
                            break
                        end
                    end
                end
                Citizen.Wait(1)
            end
        end)
    elseif type == 'enterSync' then
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)
        local dist = #(pedCo - vector3(7.25, -656.98, 17.14))
        if dist <= 50.0 then
            for i = 1, 3 do
                local tunnel = GetRayfireMapObject(7.25, -656.98, 17.14, 50.0, "des_finale_tunnel")
                local vault = GetRayfireMapObject(7.25, -656.98, 17.14, 50.0, "des_finale_vault")
                while tunnel == 0 or vault == 0 do
                    tunnel = GetRayfireMapObject(7.25, -656.98, 17.14, 50.0, "des_finale_tunnel")
                    vault = GetRayfireMapObject(7.25, -656.98, 17.14, 50.0, "des_finale_vault")
                    Wait(1)
                end
                SetStateOfRayfireMapObject(tunnel, 4)
                SetStateOfRayfireMapObject(vault, 4)
                Wait(100)
                SetStateOfRayfireMapObject(tunnel, 6)
                SetStateOfRayfireMapObject(vault, 6)
                Wait(500)
            end
        else
            Citizen.CreateThread(function()
                Citizen.Wait(20000)
                HeistSync['server-switch'] = true
                HeistSync['start'] = true
            end)
        end
        mainLoop = true
        Citizen.CreateThread(function()
            while mainLoop do
                local ped = PlayerPedId()
                local pedCo = GetEntityCoords(ped)
                local unionDist = #(pedCo - vector3(7.25, -656.98, 17.14))
                local unionVault = GetClosestObjectOfType(-3.3058, -685.26, 16.1305, 3.0, -1932297301, 0, 0, 0)
                FreezeEntityPosition(unionVault, true)
                SetEntityHeading(unionVault, GetEntityHeading(unionVault))
                if Config['UnionHeist']['buyerFinishScene'] then
                    if unionDist >= 150.0 and robber then
                        Outside()
                        break
                    end
                end
                for k, v in pairs(Config['UnionSetup']['doors']) do
                    local object = GetClosestObjectOfType(v['coords'], 2.0, GetHashKey('v_ilev_fingate'), 0, 0, 0)
                    local dist = #(pedCo - v['coords'])
                    if object ~= 0 then
                        if not v['crack'] then
                            if v['heading'] then
                                SetEntityHeading(object, v['heading'])
                            end
                            FreezeEntityPosition(object, true)
                        else
                            FreezeEntityPosition(object, false)
                        end
                    end
                    if dist <= 1.0 and not v['plant'] and k ~= 9 and k ~= 10 and k ~= 11 and k ~= 12 then
                        ShowHelpNotification(Strings['plant_bomb'])
                        if IsControlJustPressed(0, 38) then
                            PlantingAnim(k)
                        end
                    end
                end
                for k, v in pairs(Config['UnionSetup']['tables']) do
                    local dist = #(pedCo - v['coords'])
                    if dist <= 1.5 and not LootSync['stacks'][k] then
                        ShowHelpNotification(Strings['grab_stack'])
                        if IsControlJustPressed(0, 38) then
                            GrabStacks(k)
                        end
                    end
                end
                for k, v in pairs(Config['UnionSetup']['trollys']) do
                    local dist = #(pedCo - v['coords'])
                    if dist <= 1.5 and not LootSync['trollys'][k] then
                        ShowHelpNotification(Strings['grab_trolly'])
                        if IsControlJustPressed(0, 38) then
                            GrabTrollys(k)
                        end
                    end
                end
                Citizen.Wait(1)
            end
        end)
    elseif type == 'plant' then
        Config['UnionSetup']['doors'][index]['plant'] = true
    elseif type == 'crack' then
        Config['UnionSetup']['doors'][index]['crack'] = true
    elseif type == 'stacks' then
        LootSync['stacks'][index] = true
    elseif type == 'trollys' then
        LootSync['trollys'][index] = true
    elseif type == 'cutter' then
        cutterLoop = false
        RemoveBlip(cutterBlip)
    elseif type == 'delete' then
        local entity =  NetworkGetEntityFromNetworkId(index)
        DeleteObject(entity)
    elseif type == 'resetHeist' then
        ClearArea(7.25, -656.98, 17.14)
        mainLoop = false
        for k, v in pairs(Config['UnionSetup']['doors']) do
            v['plant'] = false
            v['crack'] = false
        end
        LootSync['stacks'] = {}
        LootSync['trollys'] = {}
        busy = false
        robber = false
        HeistSync['start'] = true
        HeistSync['server-switch'] = false
        Wait(1000)
        HeistSync['start'] = false
    end
end)

local lootTables = {}
local loots = {}
local trollys = {}
function UnionSetup()
    for k, v in pairs(Config['UnionSetup']['tables']) do
        if v['type'] == 'money' then
            lootModel = 'h4_prop_h4_cash_stack_01a'
        else
            lootModel = 'h4_prop_h4_gold_stack_01a'
        end
        loadModel('h4_prop_h4_table_isl_01a')
        loadModel(lootModel)
        lootTables[k] = CreateObject(GetHashKey('h4_prop_h4_table_isl_01a'), v['coords'], 1, 1, 0)
        SetEntityHeading(lootTables[k], v['heading'])
        FreezeEntityPosition(lootTables[k], true)
        loots[k] = CreateObject(GetHashKey(lootModel), GetOffsetFromEntityInWorldCoords(lootTables[k], vector3(0.001086, 0.151552, 0.945132)), 1, 1, 0)
        SetEntityHeading(loots[k], GetEntityHeading(lootTables[k]) + 180)
    end
    for k, v in pairs(Config['UnionSetup']['trollys']) do
        if v['type'] == 'money' then
            trollyModel = 'ch_prop_ch_cash_trolly_01b'
        else
            trollyModel = 'ch_prop_gold_trolly_01a'
        end
        loadModel(trollyModel)
        trollys[k] = CreateObject(GetHashKey(trollyModel), v['coords'], 1, 1, 0)
        SetEntityHeading(trollys[k], v['heading'])
    end
end

function GrabStacks(index)
    if busy then return end
    TriggerCallback('unionheist:server:hasItem', function(data)
        if data['status'] then
            TriggerServerEvent('unionheist:server:sync', 'stacks', index)
            busy = true
            robber = true
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict
            local stackModel

            if Config['UnionSetup']['tables'][index]['type'] == 'money' then
                stackModel = GetHashKey('h4_prop_h4_cash_stack_01a')
                animDict = 'anim@scripted@heist@ig1_table_grab@cash@male@'
                loadAnimDict(animDict)
            else
                stackModel = GetHashKey('h4_prop_h4_gold_stack_01a')
                animDict = 'anim@scripted@heist@ig1_table_grab@gold@male@'
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
                TriggerServerEvent('unionheist:server:rewardItem', Config['UnionHeist']['rewardItems'][1]['itemName'], Config['UnionHeist']['rewardItems'][1]['count'], 'item')
            else
                TriggerServerEvent('unionheist:server:rewardItem', 'nil', Config['UnionHeist']['rewardMoneys']['stacks'](), 'money')
            end
            NetworkStartSynchronisedScene(GrabCash['scenes'][4])
            Wait(GetAnimDuration(animDict, 'exit') * 1000)
            SetPedComponentVariation(ped, 5, Config['UnionHeist']['bagClothesID'], 0, 0)

            DeleteObject(bag)
            ClearPedTasks(ped)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['UnionHeist']['requiredItems'][1]})
end

function GrabTrollys(index)
    if busy then return end
    TriggerCallback('unionheist:server:hasItem', function(data)
        if data['status'] then
            TriggerServerEvent('unionheist:server:sync', 'trollys', index)
            busy = true
            robber = true
            local ped = PlayerPedId()
            local pedCo  = GetEntityCoords(ped)
            local animDict = 'anim@heists@ornate_bank@grab_cash'
            local grabModel = Config['UnionSetup']['trollys'][index]['type']
            if grabModel == 'gold' then
                grabModel = 'ch_prop_gold_bar_01a'
                trollyModel = 'ch_prop_gold_trolly_01a'
            else
                grabModel = 'hei_prop_heist_cash_pile'
                trollyModel = 'ch_prop_ch_cash_trolly_01b'
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
            SetPedComponentVariation(ped, 5, Config['UnionHeist']['bagClothesID'], 0, 0)
            DeleteObject(bag)
            ClearPedTasks(ped)
            busy = false
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['UnionHeist']['requiredItems'][1]})
end

function CashAppear(grabModel)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    if grabModel == 'ch_prop_gold_bar_01a' then
        reward = 'gold'
    elseif grabModel == 'hei_prop_heist_cash_pile' then
        reward = 'money'
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
                        TriggerServerEvent('unionheist:server:rewardItem', 'nil', Config['UnionHeist']['rewardMoneys']['trollys'](), 'money')
                    else
                        TriggerServerEvent('unionheist:server:rewardItem', Config['UnionHeist']['rewardItems'][1]['itemName'], 1, 'item')
                    end
                end
            end
        end
        DeleteObject(grabobj)
    end)
end

function nearCellGates()
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    for k, v in pairs(Config['UnionSetup']['doors']) do
        if not v['plant'] then
            local dist = #(pedCo - v['coords'])
            if dist <= 1.5 then
                return true
            end
        end
    end
end

local remote = {}
local remoteLoop = false
function PlantingAnim(index)
    TriggerCallback('unionheist:server:hasItem', function(data)
        if data['status'] then
            local ped = PlayerPedId()
            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
            local animDict = 'anim@heists@ornate_bank@thermal_charge'
            local sceneObjectModel = 'prop_bomb_01'
            busy = true
            loadAnimDict(animDict)
            loadModel(Planting['objects'][1])
            loadModel(sceneObjectModel)

            TriggerServerEvent('unionheist:server:sync', 'plant', index)
            TriggerServerEvent('unionheist:server:removeItem', Config['UnionHeist']['requiredItems'][2])

            if index == 1 or index == 2 then
                sceneObject = GetClosestObjectOfType(Config['UnionSetup']['doors'][index]['coords'], 2.0, GetHashKey('prop_gold_vault_gate_01'), 0, 0, 0)
                pos = GetOffsetFromEntityInWorldCoords(sceneObject, vector3(0.056873, -1.352, -0.053897))
            else
                sceneObject = GetClosestObjectOfType(Config['UnionSetup']['doors'][index]['coords'], 2.0, GetHashKey('v_ilev_fingate'), 0, 0, 0)
                pos = GetOffsetFromEntityInWorldCoords(sceneObject, vector3(1.356873, -0.052, -0.053897))
            end
            rot = GetEntityRotation(sceneObject)
            if index == 5 or index == 6 or index == 8 then
                pos = GetOffsetFromEntityInWorldCoords(sceneObject, vector3(1.356873, 0.052, -0.053897))
                rot = rot + vector3(0.0, 0.0, 180.0)
            elseif index == 1 or index == 2 then
                rot = rot + vector3(0.0, 0.0, 90.0)
            end

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
            SetPedComponentVariation(ped, 5, Config['UnionHeist']['bagClothesID'], 0, 0)
            DeleteObject(bag)
            DetachEntity(plantObject, 1, 1)
            FreezeEntityPosition(plantObject, true)
            table.insert(remote, {object = plantObject, coords = GetEntityCoords(plantObject), index = index})
            busy = false
            if not remoteLoop then
                remoteLoop = true
                Citizen.CreateThread(function()
                    pressed = false
                    repeat
                        if not nearCellGates() and not busy then
                            ShowHelpNotification(Strings['detonate_bombs'])
                            if IsControlJustPressed(0, 38) then
                                loadAnimDict('anim@mp_player_intmenu@key_fob@')
                                TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                                Wait(500)
                                for i = 1, #remote do
                                    TriggerServerEvent('unionheist:server:sync', 'crack', remote[i].index)
                                    Wait(300)
                                    AddExplosion(remote[i].coords, 2, 300.0, 1)
                                    DeleteObject(remote[i].object)
                                end
                                remote = {}
                                pressed = true
                                remoteLoop = false
                            end
                        end
                        Citizen.Wait(1)
                    until pressed == true
                end)
            end
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['UnionHeist']['requiredItems'][2]})
end

function Outside()
    if robber then
        robber = false
        ShowNotification(Strings['deliver_to_buyer'])
        loadModel('baller')
        buyerBlip = addBlip(Config['UnionHeist']['finishHeist']['buyerPos'], 500, 0, Strings['buyer_blip'])
        buyerVehicle = CreateVehicle(GetHashKey('baller'), Config['UnionHeist']['finishHeist']['buyerPos'].xy + 7.0, Config['UnionHeist']['finishHeist']['buyerPos'].z, 269.4, 0, 0)
        while true do
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local dist = #(pedCo - Config['UnionHeist']['finishHeist']['buyerPos'])

            if dist <= 15.0 then
                PlayCutscene('hs3f_all_drp2', Config['UnionHeist']['finishHeist']['buyerPos'])
                DeleteVehicle(buyerVehicle)
                RemoveBlip(buyerBlip)
                TriggerServerEvent('unionheist:server:sellRewardItems')
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

function DeleteObjectSync(entity)
    TriggerServerEvent('unionheist:server:sync', 'delete', NetworkGetNetworkIdFromEntity(entity))
end