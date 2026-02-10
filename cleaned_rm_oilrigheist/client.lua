math.randomseed(GetGameTimer())
OilRigHeist = {
    ['startPeds'] = {}
}
crateIndexCheck = {}

ESX, QBCore, targetScript = nil, nil, Config['OilRigHeist']['framework']['targetScript']
Citizen.CreateThread(function()
    if Config['OilRigHeist']['framework']['name'] == 'ESX' then
        while not ESX do
            pcall(function() ESX = exports[Config['OilRigHeist']['framework']['scriptName']]:getSharedObject() end)
            if not ESX then
                TriggerEvent(Config['OilRigHeist']['framework']['eventName'], function(library) 
                    ESX = library 
                end)
            end
            Citizen.Wait(1)
        end
    elseif Config['OilRigHeist']['framework']['name'] == 'QB' then
        while not QBCore do
            pcall(function() QBCore =  exports[Config['OilRigHeist']['framework']['scriptName']]:GetCoreObject() end)
            if not QBCore then
                pcall(function() QBCore =  exports[Config['OilRigHeist']['framework']['scriptName']]:GetSharedObject() end)
            end
            if not QBCore then
                TriggerEvent(Config['OilRigHeist']['framework']['eventName'], function(obj) QBCore = obj end)
            end
            Citizen.Wait(1)
        end
    end
end)

function TriggerCallback(cbName, cb, data)
    if Config['OilRigHeist']['framework']['name'] == 'ESX' then
        ESX.TriggerServerCallback(cbName, function(data)
            if cb then cb(data) else return data end
        end, data)
    elseif Config['OilRigHeist']['framework']['name'] == 'QB' then
        QBCore.Functions.TriggerCallback(cbName, function(data)
            if cb then cb(data) else return data end
        end, data)
    end
end

Citizen.CreateThread(function()
    for k, v in pairs(Config['OilRigHeist']['startHeist']['peds']) do
        loadModel(v['ped'])
        OilRigHeist['startPeds'][k] = CreatePed(4, GetHashKey(v['ped']), v['pos']['x'], v['pos']['y'], v['pos']['z'] - 0.95, v['heading'], false, true)
        FreezeEntityPosition(OilRigHeist['startPeds'][k], true)
        SetEntityInvincible(OilRigHeist['startPeds'][k], true)
        SetBlockingOfNonTemporaryEvents(OilRigHeist['startPeds'][k], true)
    end
    if targetScript == 'qtarget' or targetScript == 'qb-target' or targetScript == 'nc-target' then
        exports[targetScript]:AddBoxZone("OilRigHeist", Config['OilRigHeist']['startHeist']['pos'], 1.1, 2.35, 
        {
            name = "OilRigHeist",
            heading = 20.0,
            debugPoly = false,
            minZ = Config['OilRigHeist']['startHeist']['pos'] - 1.0,
            maxZ = Config['OilRigHeist']['startHeist']['pos'] + 0.3,
        }, 
        {
            options = {
                {
                    event = "oilrig:client:startHeist",
                    icon = "fa-solid fa-mask",
                    label = Strings['t_heist'],
                    job = "all",
                },
            },
            distance = 1.5
        })
    elseif targetScript == 'ox_target' then
        exports[targetScript]:addBoxZone({
            coords = Config['OilRigHeist']['startHeist']['pos'],
            size = vec3(2, 2, 2),
            rotation = 20,
            debug = false,
            options = {
                {
                    name = "OilRigHeist",
                    event = "oilrig:client:startHeist",
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

RegisterNetEvent('oilrig:client:startHeist')
AddEventHandler('oilrig:client:startHeist', function()
    TriggerCallback('oilrig:server:checkPlayersInArea', function(data)
        if data['status'] then
            TriggerCallback('oilrig:server:checkPoliceCount', function(data)
                if data['status'] then
                    TriggerCallback('oilrig:server:checkTime', function(data)
                        if data['status'] then
                            oilrigBlip = addBlip(Config['OilRigSetup']['middleArea'], 181, 1, Strings['oilrig_blip'])
                            ShowNotification(Strings['heist_info'])
                            SetupOilRig()
                        end
                    end)
                end
            end)
        end
    end)
end)

clientCrates = {}
targetIds = {}
RegisterNetEvent('oilrig:client:sync')
AddEventHandler('oilrig:client:sync', function(type, args)
    if type == 'crateSync' then
        local crateConfig = Config['OilRigSetup']['crates'][args[1]]
        clientCrates[#clientCrates + 1] = crateConfig['coords']
        if targetScript == 'qtarget' or targetScript == 'qb-target' or targetScript == 'nc-target' then
            exports[targetScript]:AddBoxZone("OilRigCrates"..args[1], crateConfig['coords'], 1.1, 2.35, 
            {
                name = "OilRigCrates"..args[1],
                heading = crateConfig['heading'],
                debugPoly = false,
                minZ = crateConfig['coords']['z'] - 1.0,
                maxZ = crateConfig['coords']['z'] + 0.3,
            }, 
            {
                options = {
                    {
                        event = "oilrig:client:lootCrate",
                        icon = "fa-solid fa-box-open",
                        label = Strings['t_search'],
                        job = "all",
                        crateIndex = args[1]
                    },
                },
                distance = 1.5
            })
        elseif targetScript == 'ox_target' then
            targetIds[#targetIds + 1] = exports[targetScript]:addBoxZone({
                coords = crateConfig['coords'],
                size = vec3(2, 2, 2),
                rotation = 20,
                debug = false,
                options = {
                    {
                        name = "OilRigCrates"..args[1],
                        event = "oilrig:client:lootCrate",
                        icon = "fa-solid fa-box-open",
                        label = Strings['t_search'],
                        crateIndex = args[1],
                        targetId = #targetIds + 1,
                        canInteract = function(entity, distance, coords, name)
                            return true
                        end
                    }
                }
            })
        end
    elseif type == 'removeCrate' then
        if targetScript == 'qtarget' or targetScript == 'qb-target' or targetScript == 'nc-target' then
            exports[targetScript]:RemoveZone("OilRigCrates"..args[1])
        elseif targetScript == 'ox_target' then
            exports[targetScript]:removeZone(targetIds[args[2]])
        end
    elseif type == 'resetCrates' then
        if targetScript == 'qtarget' or targetScript == 'qb-target' or targetScript == 'nc-target' then
            for i = 1, #Config['OilRigSetup']['crates'] do
                exports[targetScript]:RemoveZone("OilRigCrates"..i)
            end
            exports[targetScript]:RemoveZone("OilRigLaptop")
        elseif targetScript == 'ox_target' then
            for i = 1, #targetIds do
                exports[targetScript]:removeZone(targetIds[i])
            end
            targetIds = {}
        end
        ClearArea(Config['OilRigSetup']['middleArea'], 100.0)
    elseif type == 'hackSync' then
        if targetScript == 'qtarget' or targetScript == 'qb-target' or targetScript == 'nc-target' then
            exports[targetScript]:AddBoxZone("OilRigLaptop", Config['OilRigSetup']['laptop']['coords'], 0.5, 0.35, 
            {
                name = "OilRigLaptop",
                heading = Config['OilRigSetup']['laptop']['heading'],
                debugPoly = false,
                minZ = Config['OilRigSetup']['laptop']['coords']['z'] - 1.0,
                maxZ = Config['OilRigSetup']['laptop']['coords']['z'] + 1.5,
            }, 
            {
                options = {
                    {
                        event = "oilrig:client:hackLaptop",
                        icon = "fa-solid fa-laptop-code",
                        label = Strings['t_laptop'],
                        job = "all",
                    },
                },
                distance = 1.5
            })
        elseif targetScript == 'ox_target' then
            targetLaptop = exports[targetScript]:addBoxZone({
                coords = Config['OilRigSetup']['laptop']['coords'],
                size = vec3(2, 2, 2),
                rotation = 20,
                debug = false,
                options = {
                    {
                        name = "OilRigLaptop",
                        event = "oilrig:client:hackLaptop",
                        icon = "fa-solid fa-laptop-code",
                        label = Strings['t_laptop'],
                        canInteract = function(entity, distance, coords, name)
                            return true
                        end
                    }
                }
            })
        end
    elseif type == 'removeHack' then
        if targetScript == 'qtarget' or targetScript == 'qb-target' or targetScript == 'nc-target' then
            exports[targetScript]:RemoveZone("OilRigLaptop")
        elseif targetScript == 'ox_target' then
            exports[targetScript]:removeZone(targetLaptop)
        end
    end
end)

RegisterNetEvent('oilrig:client:hackLaptop')
AddEventHandler('oilrig:client:hackLaptop', function(data)
    TriggerCallback('oilrig:server:hasItem', function(data)
        if data['status'] then
            TriggerServerEvent('oilrig:server:sync', 'removeHack')
            local ped = PlayerPedId()
            loadAnimDict('anim@heists@prison_heiststation@cop_reactions')
            TaskPlayAnim(ped, "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 8.0, 8.0, -1, 1, 1, false, false, false)
            StartFingerprint(function(result)
                if result then 
                    ClearPedTasks(ped)
                    local crateBlips = {}
                    for k, v in pairs(clientCrates) do
                        local alpha = 250
                        crateBlips[k] = AddBlipForRadius(v.x, v.y, v.z, 5.0)
            
                        SetBlipHighDetail(crateBlips[k], true)
                        SetBlipColour(crateBlips[k], 1)
                        SetBlipAlpha(crateBlips[k], alpha)
                        SetBlipAsShortRange(crateBlips[k], true)
                        Citizen.CreateThread(function()
                            while alpha ~= 0 do
                                Citizen.Wait(500)
                                alpha = alpha - 1
                                SetBlipAlpha(crateBlips[k], alpha)
                
                                if alpha == 0 then
                                    RemoveBlip(crateBlips[k])
                                    return
                                end
                            end
                        end)
                    end
                    ShowNotification(Strings['hack_info'])
                else
                    ClearPedTasks(ped)
                    TriggerEvent('oilrig:client:sync', 'hackSync')
                end
            end)
        else
            ShowNotification(Strings['need_this'] .. data['label'])
        end
    end, {itemName = Config['OilRigHeist']['requiredItems'][1]})
end)

RegisterNetEvent('oilrig:client:lootCrate')
AddEventHandler('oilrig:client:lootCrate', function(data)
    TriggerServerEvent('oilrig:server:sync', 'removeCrate', {data['crateIndex'], data['targetId']})
    local ped = PlayerPedId()
    loadAnimDict('mp_take_money_mg')
    TaskPlayAnim(ped, "mp_take_money_mg", "stand_cash_in_bag_loop", 1.0, 1.0, -1, 1, 1, false, false, false)
    AddTimerBar(Config['OilRigHeist']['crateSettings']['lootTime'], Strings['looting'], function(status)
        if status then
            ClearPedTasks(ped)
            TriggerServerEvent('oilrig:server:rewardItem', data)
        end
    end)
end)

guardPeds = {}
function SetupOilRig()
    while true do
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)
        local dist = #(pedCo - Config['OilRigSetup']['middleArea'])
        if dist <= 100.0 then
            break
        end
        Wait(1)
    end
    policeAlert(Config['OilRigSetup']['middleArea'])
    for i = 1, Config['OilRigHeist']['crateSettings']['crateCount'] do
        local crateIndex = math.random(1, #Config['OilRigSetup']['crates'])
        repeat
            if crateIndexCheck[crateIndex] then
                crateIndex = math.random(1, #Config['OilRigSetup']['crates'])
            end
            Wait(1)
        until not crateIndexCheck[crateIndex]
        crateIndexCheck[crateIndex] = true
        TriggerServerEvent('oilrig:server:sync', 'crateSync', {crateIndex})
    end
    crateIndexCheck = {}
    TriggerServerEvent('oilrig:server:sync', 'hackSync')
    local ped = PlayerPedId()
    SetPedRelationshipGroupHash(ped, GetHashKey('PLAYER'))
    AddRelationshipGroup('GuardPeds')
    for k, v in pairs(Config['OilRigSetup']['guards']['peds']) do
        loadModel(v['model'])
        guardPeds[k] = CreatePed(4, v['model'], v['coords'], 1, 1, 0)
        SetEntityHeading(guardPeds[k], v['heading'])
        NetworkRegisterEntityAsNetworked(guardPeds[k])
        networkID = NetworkGetNetworkIdFromEntity(guardPeds[k])
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetEntityAsMissionEntity(guardPeds[k])
        SetEntityVisible(guardPeds[k], true)
        SetPedRelationshipGroupHash(guardPeds[k], GetHashKey("GuardPeds"))
        SetPedAccuracy(guardPeds[k], 50)
        SetPedArmour(guardPeds[k], 100)
        SetPedCanSwitchWeapon(guardPeds[k], true)
        SetPedDropsWeaponsWhenDead(guardPeds[k], false)
		SetPedFleeAttributes(guardPeds[k], 0, false)
        local randomWeapon = math.random(1, #Config['OilRigSetup']['guards']['weapons'])
        GiveWeaponToPed(guardPeds[k], GetHashKey(Config['OilRigSetup']['guards']['weapons'][randomWeapon]), 255, false, false)
        TaskGuardCurrentPosition(guardPeds[k], 115.0, 115.0, 1)
        Wait(50)
    end
    SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(0, GetHashKey("GuardPeds"), GetHashKey("GuardPeds"))
	SetRelationshipBetweenGroups(5, GetHashKey("GuardPeds"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("GuardPeds"))
    CreateThread(function()
        Wait(20000)
        RemoveBlip(oilrigBlip)
    end)
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