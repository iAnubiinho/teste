
local doorhacked = false
local fuseboxbreaked = false
local PlayerProps = {}
local startdstcheckcasino = false
local initiatorcasino = false
local blowndoor = nil
local C4armed = {}


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
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer)
    CasinoFuseBox = CreateObject(GetHashKey('tr_prop_tr_elecbox_01a'), vector3(896.760, -0.479, 77.848), 1, 1, 0)
    SetEntityRotation(CasinoFuseBox, 0.000, 0.000, 146.628)
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(job)
    PlayerData.job = job
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    CasinoFuseBox = CreateObject(GetHashKey('tr_prop_tr_elecbox_01a'), vector3(896.760, -0.479, 77.848), 1, 1, 0)
    SetEntityRotation(CasinoFuseBox, 0.000, 0.000, 146.628)
end)

--local slidersopen = false
local garageopen = false
--local singleentranceopen = false
--local innderdoubleopen = false
--local innerdouble2open = false
--local lowersingleopen = false
--local garagetoguardopen = false
--local garageslidersopen = false
--local elevatoropen = false
--local guardtovaultopen = false
local casinotostairsopen = false
local vaultdoubleglassopen = false
local casinomainvaultopen = false
local vaultcellopen = false
local smallvaultopen = false
local bossminisafeopen = false

Citizen.CreateThread(function()
    local garage = -1081024910
    local single = 634417522
    local innerR = 37530187
    local innerL = 37530187
    local innerR2 = 37530187
    local innerL2 = 37530187
    local lower = 634417522
    local garagetoguard = 634417522
    local garagesliderR = -1929764584
    local garagesliderL = -1929764584
    local elevatorR = 87445183
    local elevatorL = 87445183
    local guardtovault = 634417522
    local casinotostairs = 634417522
    local vglassR = -1740884984
    local vglassL = -1740884984
    local vaultdoor = -127348208
    local vaultcell = 1671627351
    local smallvault = 1405979971
    local minisafe = -1992154984


    local garageCoords = vector3(936.79876708984, 2.0370280742645, 77.812423706055) 
    local singleCoords = vector3(931.193359375, 32.758609771729, 81.267692565918) --- rot: 148.0
    local innerRCoords = vector3(921.0094, 20.68193, 81.25546) -- rot: 328.031
    local innerLCoords = vector3(922.7065, 19.62145, 81.25546) --- rot: 148.00
    local innerR2Coords = vector3(929.8862, 25.16949, 81.25546) -- rot: 148.037
    local innerL2Coords = vector3(928.191, 26.22882, 81.25546) --- rot: 328.067
    local lowerCoords = vector3(939.2563, 27.42797, 78.95571) --- rot: 57.897
    local garagetoguardCoords = vector3(943.049, 23.70649, 78.94761) --- rot: 58.040
    local garagesliderRCoords = vector3(946.4028, 11.87978, 77.79363) --- rot: 147.99
    local garagesliderLCoords = vector3(941.4604, 14.96816, 77.79363) --- rot: 328.0
    local elevatorRCoords = vector3(951.1687, 13.30923, 77.84391) --- rot: 238.00
    local elevatorLCoords = vector3(953.4191, 16.91384, 77.84391) --- rot: 57.99
    local guardtovaultCoords = vector3(941.4492, 28.69982, 78.96188) --- rot: 328.00
    local casinotostairsCoords = vector3(957.4836, 25.41841, 81.16417) --- rot: 327.93
    local vglassRCoords = vector3(950.29, 32.33371, 73.07195) --- rot: 238.00
    local vglassLCoords = vector3(951.4854, 34.24665, 73.07195) --- rot: 57.999
    local vaultdoorCoords = vector3(956.1699, 30.18544, 73.39164) --- rot:  58.247
    local vaultcellCoords = vector3(957.6292, 30.40726, 73.15677) --- rot:  237.826
    local smallvaultCoords = vector3(971.5598, 23.28996, 73.10324) --- rot:  238.0000
    local minisafeCoords = vector3(930.6054, 7.890648, 80.878) --- rot:  147.99

    while true do
        Citizen.Wait(1000) 
        local garageobj = GetClosestObjectOfType(garageCoords, 5.0, garage, false, false, false)
        local singleobj = GetClosestObjectOfType(singleCoords, 5.0, single, false, false, false)
        local innerRobj = GetClosestObjectOfType(innerRCoords, 5.0, innerR, false, false, false)
        local innerLobj = GetClosestObjectOfType(innerLCoords, 5.0, innerL, false, false, false)
        local innerR2obj = GetClosestObjectOfType(innerR2Coords, 5.0, innerR2, false, false, false)
        local innerL2obj = GetClosestObjectOfType(innerL2Coords, 5.0, innerL2, false, false, false)
        local lowerobj = GetClosestObjectOfType(lowerCoords, 2.0, lower, false, false, false)
        local garagetoguardobj = GetClosestObjectOfType(garagetoguardCoords, 5.0, garagetoguard, false, false, false)
        local garagesliderRobj = GetClosestObjectOfType(garagesliderRCoords, 5.0, garagesliderR, false, false, false)
        local garagesliderLobj = GetClosestObjectOfType(garagesliderLCoords, 5.0, garagesliderL, false, false, false)
        local elevatorRobj = GetClosestObjectOfType(elevatorRCoords, 5.0, elevatorR, false, false, false)
        local elevatorLobj = GetClosestObjectOfType(elevatorLCoords, 5.0, elevatorL, false, false, false)
        local guardtovaultobj = GetClosestObjectOfType(guardtovaultCoords, 2.0, guardtovault, false, false, false)
        local casinotostairsobj = GetClosestObjectOfType(casinotostairsCoords, 5.0, casinotostairs, false, false, false)
        local vglassRobj = GetClosestObjectOfType(vglassRCoords, 5.0, vglassR, false, false, false)
        local vglassLobj = GetClosestObjectOfType(vglassLCoords, 5.0, vglassL, false, false, false)
        local vaultdoorobj = GetClosestObjectOfType(vaultdoorCoords, 5.0, vaultdoor, false, false, false)
        local vaultcellobj = GetClosestObjectOfType(vaultcellCoords, 5.0, vaultcell, false, false, false)
        local smallvaultobj = GetClosestObjectOfType(smallvaultCoords, 5.0, smallvault, false, false, false)
        local minisafeobj = GetClosestObjectOfType(minisafeCoords, 5.0, minisafe, false, false, false)

         -- Handle garage door locking
         if not garageopen and garageobj then
            FreezeEntityPosition(garageobj, true)
        elseif garageopen and garageobj then
            FreezeEntityPosition(garageobj, false)
        end
         -- Handle garage slider doors locking
         if not garageslidersopen and garagesliderRobj then
            FreezeEntityPosition(garagesliderRobj, true)
        elseif garageslidersopen and garagesliderRobj then
            FreezeEntityPosition(garagesliderRobj, false)
        end
         if not garageslidersopen and garagesliderLobj then
            FreezeEntityPosition(garagesliderLobj, true)
        elseif garageslidersopen and garagesliderLobj then
            FreezeEntityPosition(garagesliderLobj, false)
        end
         -- Handle elevator doors locking
         if not elevatoropen and elevatorRobj then
            FreezeEntityPosition(elevatorRobj, true)
        elseif elevatoropen and elevatorRobj then
            FreezeEntityPosition(elevatorRobj, false)
        end
         if not elevatoropen and elevatorLobj then
            FreezeEntityPosition(elevatorLobj, true)
        elseif elevatoropen and elevatorLobj then
            FreezeEntityPosition(elevatorLobj, false)
        end
         -- Handle single door locking
         if not singleentranceopen and singleobj then
            local headingsingle = GetEntityHeading(singleobj)
            if headingsingle ~= 148.0 then
            SetEntityHeading(singleobj, 148.0)
            FreezeEntityPosition(singleobj, true)
            end
        elseif singleentranceopen and singleobj then
            FreezeEntityPosition(singleobj, false)
        end
         -- Handle inner double door locking
         if not innderdoubleopen and innerRobj then
            local headingdoubleR = GetEntityHeading(innerRobj)
            if headingdoubleR ~= 328.031 then
            SetEntityHeading(innerRobj, 328.031)
            FreezeEntityPosition(innerRobj, true)
            end
        elseif innderdoubleopen and innerRobj then
            FreezeEntityPosition(innerRobj, false)
        end
        if not innderdoubleopen and innerLobj then
            local headingdoubleL = GetEntityHeading(innerLobj)
            if headingdoubleL ~= 148.0 then
            SetEntityHeading(innerLobj, 148.0)
            FreezeEntityPosition(innerLobj, true)
            end
        elseif innderdoubleopen and innerLobj then
            FreezeEntityPosition(innerLobj, false)
        end
        -- Handle scnd inner double door locking
        if not innerdouble2open and innerR2obj then
            local headingdoubleR2 = GetEntityHeading(innerR2obj)
            if headingdoubleR2 ~= 148.037 then
            SetEntityHeading(innerR2obj, 148.037)
            FreezeEntityPosition(innerR2obj, true)
            end
        elseif innerdouble2open and innerR2obj then
            FreezeEntityPosition(innerR2obj, false)
        end
        if not innerdouble2open and innerL2obj then
            local headingdoubleL2 = GetEntityHeading(innerL2obj)
            if headingdoubleL2 ~= 328.067 then
            SetEntityHeading(innerL2obj, 328.067)
            FreezeEntityPosition(innerL2obj, true)
            end
        elseif innerdouble2open and innerL2obj then
            FreezeEntityPosition(innerL2obj, false)
        end
        --- handle minisafe door locking
        if not bossminisafeopen and minisafeobj then
            local headingminisafe = GetEntityHeading(innerR2obj)
            if headingminisafe ~= 147.99 then
            SetEntityHeading(minisafeobj, 147.99)
          --  FreezeEntityPosition(minisafeobj, true)
            end
        elseif bossminisafeopen and minisafeobj then
           -- FreezeEntityPosition(minisafeobj, false)
        end
        -- Handle lower door locking
        if not lowersingleopen and lowerobj then
            local headinglowersingle = GetEntityHeading(lowerobj)
            if headinglowersingle ~= 57.897 then
            SetEntityHeading(lowerobj, 57.897)
            FreezeEntityPosition(lowerobj, true)
            end
        elseif lowersingleopen and lowerobj then
            FreezeEntityPosition(lowerobj, false)
        end
         -- Handle garage to guard office door locking
         if not garagetoguardopen and garagetoguardobj then
            local headinggtog = GetEntityHeading(garagetoguardobj)
            if headinggtog ~= 58.040 then
            SetEntityHeading(garagetoguardobj, 58.040)
            FreezeEntityPosition(garagetoguardobj, true)
            end
        elseif garagetoguardopen and garagetoguardobj then
            FreezeEntityPosition(garagetoguardobj, false)
        end
        -- Handle guard office to vault staircase door locking
        if not guardtovaultopen and guardtovaultobj then
            local headinggtov = GetEntityHeading(guardtovaultobj)
            if headinggtov ~= 328.00 then
            SetEntityHeading(guardtovaultobj, 328.00)
            FreezeEntityPosition(guardtovaultobj, true)
            end
        elseif guardtovaultopen and guardtovaultobj then
            FreezeEntityPosition(guardtovaultobj, false)
        end
         -- Handle casino to staircase door locking
         if not casinotostairsopen and casinotostairsobj then
            local headinggtov = GetEntityHeading(casinotostairsobj)
            if headinggtov ~= 327.93 then
            SetEntityHeading(casinotostairsobj, 327.93)
            FreezeEntityPosition(casinotostairsobj, true)
            end
        elseif casinotostairsopen and casinotostairsobj then
            FreezeEntityPosition(casinotostairsobj, false)
        end
        -- Handle vault glass doors locking
        if not vaultdoubleglassopen and vglassRobj then
            local headingvglassR = GetEntityHeading(vglassRobj)
            if headingvglassR ~= 238.00 then
            SetEntityHeading(vglassRobj, 238.00)
            FreezeEntityPosition(vglassRobj, true)
            end
        elseif vaultdoubleglassopen and vglassRobj then
            FreezeEntityPosition(vglassRobj, false)
        end
        if not vaultdoubleglassopen and vglassLobj then
            local headingvglassL = GetEntityHeading(vglassLobj)
            if headingvglassL ~= 57.999 then
            SetEntityHeading(vglassLobj, 57.999)
            FreezeEntityPosition(vglassLobj, true)
            end
        elseif vaultdoubleglassopen and vglassLobj then
            FreezeEntityPosition(vglassLobj, false)
        end
         -- Handle vault main door locking
         if not casinomainvaultopen and vaultdoorobj then
            local headingvaultmain = GetEntityHeading(vaultdoorobj)
            if headingvaultmain ~= 58.247 then
            SetEntityHeading(vaultdoorobj, 58.247)
            FreezeEntityPosition(vaultdoorobj, true)
            end
        elseif casinomainvaultopen and vaultdoorobj then
            Wait(1500)
            SetEntityHeading(vaultdoorobj, 163.9)
            FreezeEntityPosition(vaultdoorobj, false)
        end
        -- Handle small vault door locking
        if not smallvaultopen and smallvaultobj then
            local headingsmallvault = GetEntityHeading(smallvaultobj)
            if headingsmallvault ~= 238.0000 then
            SetEntityHeading(smallvaultobj, 238.0000)
            FreezeEntityPosition(smallvaultobj, true)
            end
        elseif smallvaultopen and smallvaultobj then
            Wait(1500)
            SetEntityHeading(smallvaultobj, 121.73)
            FreezeEntityPosition(smallvaultobj, false)
        end
        -- Handle vault cell door locking
        if not vaultcellopen and vaultcellobj then
            local headingvaultcell = GetEntityHeading(vaultcellobj)
            if headingvaultcell ~= 237.826 then
            SetEntityHeading(vaultcellobj, 237.826)
            FreezeEntityPosition(vaultcellobj, true)
            end
        elseif vaultcellopen and vaultcellobj then
            FreezeEntityPosition(vaultcellobj, false)
        end
     end
end)

RegisterNetEvent('estrp-casinoheist:client:setPCState', function(stateType, state, k)
    Config.PCS[k][stateType] = state
end)

RegisterNetEvent('estrp-casinoheist:client:setC4State', function(stateType, state, k)
    Config.C4placements[k][stateType] = state
end)

RegisterNetEvent('estrp-casinoheist:client:setGTrolleyState', function(stateType, state, k)
    Config.GoldTrolleys[k][stateType] = state
end)

RegisterNetEvent('estrp-casinoheist:client:setCTrolleyState', function(stateType, state, k)
    Config.CashTrolleys[k][stateType] = state
end)

RegisterNetEvent('estrp-casinoheist:client:setPaintingState', function(stateType, state, k)
    Config.Paintings[k][stateType] = state
end)

RegisterNetEvent('estrp-casinoheist:client:setDrillState', function(stateType, state, k)
    Config.DrillTargets[k][stateType] = state
end)

RegisterNetEvent('estrp-casinoheist:client:SetSafeState', function(stateType, state, k)
    Config.Minisafes[k][stateType] = state
end)

RegisterNetEvent('estrp-casinoheist:client:SetStackState', function(stateType, state, k)
    Config.SceneStacks[k][stateType] = state
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

function neardoor(k)
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    
    -- Check if Config.C4placements[k] is not nil and contains the 'coords' field
    if Config.C4placements[k] and Config.C4placements[k]['C4Pos'] then
        for _, v in pairs(Config.C4placements[k]['C4Pos']) do
            -- Only check for the desired indices (1, 2, 3, 4)
            if _ == 1 or _ == 2 or _ == 3 or _ == 4 then
                -- Ensure that the 'c4planted' key exists and is not true
                if not v['c4planted'] then
                    local dist = Vdist(pedCo, v['C4Pos'])  -- Use Vdist for accurate distance calculation
                    if dist <= 1.5 then
                        return true
                    end
                end
            end
        end
    end
    return false
end

PlantingScene = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s'
    },
    ['animations'] = {
        {'thermal_charge', 'bag_thermal_charge'}
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}

-- Table to track C4 state for each door
local C4States = {}

function PlantC4(k)
    -- Check if the player is already drilling or grabbing to avoid conflicts
    if busy or drilling or grabbing then
        Notifi({ title = Config.title, text = Text('busy'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
        return
    end
    
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
    local animDict = 'anim@heists@ornate_bank@thermal_charge'
    local sceneObjectModel = 'prop_c4_final_green'
    busy = true
    loadAnimDict(animDict)
    loadModel(PlantingScene['objects'][1])
    loadModel(sceneObjectModel)
    TriggerServerEvent("estrp-casinoheist:server:removec4")
    
    -- Ensure that the C4 isn't already planted at this position
    if C4States[k] and C4States[k].planted then
        Notifi({ title = Config.title, text = Text('c4planteddoor'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
        busy = false
        return
    end

    TriggerServerEvent('estrp-casinoheist:server:setC4State', 'isBusy', true, k)

    -- Use the config for door coordinates
    local doorCoords = Config.C4placements[k].C4Pos
    TriggerServerEvent("estrp-casinoheist:removec4")
    -- Determine the correct position for the C4 on specific doors (k == 1, 2, 3, 4)
    local sceneObject = GetClosestObjectOfType(doorCoords, 5.0, GetHashKey('k4mb1_casino5_gate3'), 0, 0, 0)
    local pos = GetOffsetFromEntityInWorldCoords(sceneObject, vector3(0.056873, -1.352, -0.0))
    local rot = GetEntityRotation(sceneObject) + vector3(0.0, 0.0, 90.0)

    if k == 1 then
        rot = GetEntityRotation(sceneObject) + vector3(0.0, 0.0, -90.0)
        pos = GetOffsetFromEntityInWorldCoords(sceneObject, vector3(-0.08, -1.50, -0.00))
    elseif k == 3 then 
        rot = GetEntityRotation(sceneObject) + vector3(0.0, 0.0, -90.0)
        pos = GetOffsetFromEntityInWorldCoords(sceneObject, vector3(-0.08, -1.50, -0.00))
    end

    -- Create the C4 bag and synchronize the scene
    local bag = CreateObject(GetHashKey(PlantingScene['objects'][1]), pedCo, 1, 1, 0)
    SetEntityCollision(bag, false, true)
    PlantingScene['scenes'][1] = NetworkCreateSynchronisedScene(pos, rot, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, PlantingScene['scenes'][1], animDict, PlantingScene['animations'][1][1], 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, PlantingScene['scenes'][1], animDict, PlantingScene['animations'][1][2], 4.0, -8.0, 1)

    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(PlantingScene['scenes'][1])

    Wait(1500)

    -- Create the C4 object and attach it
    local C4Object = CreateObject(GetHashKey(sceneObjectModel), pedCo, 1, 1, 0)
    SetEntityCollision(C4Object, false, true)
    AttachEntityToEntity(C4Object, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, -90.0, 0.0, 0.0, true, true, false, true, 1, true)
    FreezeEntityPosition(C4Object, true)
    Wait(3000)
    
    -- Cleanup
    DeleteObject(bag)
    DetachEntity(C4Object, 1, 1)

    -- Mark the C4 as planted
    C4States[k] = {object = C4Object, planted = true, coords = GetEntityCoords(C4Object)}
    table.insert(C4armed, {object = C4Object, coords = GetEntityCoords(C4Object), index = k})

    busy = false

    -- Check for C4 detonation
    if not c4planted then
        c4planted = true
        Citizen.CreateThread(function()
            local Text1 = nil
            local Area = nil 
            local pressed = false

            repeat
                local Zone = false
                if not neardoor() and not busy then
                    Zone = true 
                    Text1 = Text("setoff")

                    -- Show help notification
                    if IsControlJustPressed(0, 38) then
                        loadAnimDict('anim@mp_player_intmenu@key_fob@')
                        TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                        Wait(500)
                        
                        -- Detonate the C4s
                        for i = 1, #C4armed do
                            TriggerServerEvent('estrp-casinoheist:server:setC4State', 'isBusy', false, k)
                            TriggerServerEvent('estrp-casinoheist:server:setC4State', 'isBlown', true, k)
                            Wait(300)
                            AddExplosion(C4armed[i].coords, 2, 300.0, 1)
                            DeleteObject(C4armed[i].object)

                            -- Reset the state after detonation
                            C4States[C4armed[i].index].planted = false
                        end
                        C4armed = {}
                        pressed = true
                        Zone = false 
                        c4planted = false
                    end

                    if not Area and Zone then
                        Area = true
                        lib.showTextUI(Text1, {
                            icon = 'fa-solid fa-explosion',
                        })
                    end

                    if Area and not Zone then
                        Area = false 
                        lib.hideTextUI()
                    end
                end
                Citizen.Wait(1)
            until pressed == true
        end)
    end
end

-- Function to spawn all scene stacks
function SpawnStacks()
    for k, v in pairs(Config.SceneStacks) do
        local model = GetHashKey(v.objectname)

        -- Load the object model
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end

        -- Spawn the object
        local object = CreateObject(model, v.objectpos.x, v.objectpos.y, v.objectpos.z, false, false, false)
        SetEntityHeading(object, v.objectheading)
        FreezeEntityPosition(object, true) -- Freeze the object in place

        -- Save the spawned object handle
        v.objectHandle = object
    end
end

function GrabbingScene(k)
    local stackobj = Config.SceneStacks[k]
    -- Animation dictionaries
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)

    -- Determine animation dictionary
    local animDict = (k == 1 or k == 2 or k == 3) 
        and 'anim@scripted@heist@ig1_table_grab@gold@male@' 
        or 'anim@scripted@heist@ig1_table_grab@cash@male@'

    loadAnimDict(animDict)

    local heistbag = "hei_p_m_bag_var22_arm_s"
    loadModel(heistbag)

    -- Find the closest stack from the spawned objects
    local closestStack = nil
    local closestDistance = math.huge

    for _, v in pairs(Config.SceneStacks) do
        if v.objectHandle and DoesEntityExist(v.objectHandle) then
            local stackPos = GetEntityCoords(v.objectHandle)
            local distance = #(pedCo - stackPos)
            if distance < closestDistance then
                closestDistance = distance
                closestStack = v
            end
        end
    end

    if not closestStack then
        print("No stack found near player!")
        return
    end

    local scenestack = closestStack.objectHandle

    -- Ensure scenestack is networked
    if not NetworkGetEntityIsNetworked(scenestack) then
        NetworkRegisterEntityAsNetworked(scenestack)
        Wait(10)
    end

    -- Request control of the scenestack
    if not NetworkHasControlOfEntity(scenestack) then
        NetworkRequestControlOfEntity(scenestack)
        Wait(10)
    end

    if not NetworkHasControlOfEntity(scenestack) then
        print("Failed to gain control of the scenestack!")
        return
    end

    -- Create the heist bag
    local bag = CreateObject(heistbag, pedCo, true, true, false)

    -- Notify the server about the interaction
    TriggerServerEvent('estrp-casinoheist:server:SetStackState', "isBusy", true, k)

    -- Prepare the synchronized scenes
    local ScenRotation = GetEntityRotation(scenestack)

    local SceneStart = NetworkCreateSynchronisedScene(GetEntityCoords(scenestack), ScenRotation, 2, true, false, 1.0, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, SceneStart, animDict, 'enter', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, SceneStart, animDict, 'enter_bag', 4.0, -8.0, 1)

    local GrabbingScene = NetworkCreateSynchronisedScene(GetEntityCoords(scenestack), ScenRotation, 2, true, false, 1.0, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, GrabbingScene, animDict, 'grab', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, GrabbingScene, animDict, 'grab_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(scenestack, GrabbingScene, animDict, (k == 1 or k == 2 or k == 3) and 'grab_gold' or 'grab_cash', 4.0, -8.0, 1)

    local ExitScene = NetworkCreateSynchronisedScene(GetEntityCoords(scenestack), ScenRotation, 2, true, false, 1.0, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, ExitScene, animDict, 'exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, ExitScene, animDict, 'exit_bag', 4.0, -8.0, 1)

    -- Start the scenes
    NetworkStartSynchronisedScene(SceneStart)
    Wait((k == 1 or k == 2 or k == 3) and 1600 or 1600)
    NetworkStartSynchronisedScene(GrabbingScene)
    Wait((k == 1 or k == 2 or k == 3) and 10266 or 13366)
    NetworkStartSynchronisedScene(ExitScene)
    Wait((k == 1 or k == 2 or k == 3) and 2433 or 1733)

    -- Cleanup
    DeleteObject(bag)
    DeleteObject(scenestack)
    ClearPedTasks(ped)
     -- Notify the server about the interaction
     TriggerServerEvent('estrp-casinoheist:server:SetStackState', "isBusy", false, k)
     TriggerServerEvent('estrp-casinoheist:server:SetStackState', "IsTaken", true, k)
    -- Trigger server-side reward
    TriggerServerEvent("estrp-casinoheist:StackReward", k)
end



-- Function to delete all coke blocks
function DeleteStacks()
    for k, v in pairs(Config.SceneStacks) do
        if v.objectHandle and DoesEntityExist(v.objectHandle) then
            DeleteObject(v.objectHandle)
            v.objectHandle = nil -- Clear the handle after deletion
        end
    end
end


Drillanims = {
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

function OpenCasinoMinisafe(k)
    TriggerServerEvent("estrp-casinoheist:server:synced", "openminisafe")
    TriggerServerEvent("estrp-casinoheist:rewardCashMinisafe")
end


function Drill(box, drillIndex)
    -- Check if the player is already drilling or grabbing to avoid conflicts
    if drilling or grabbing then
        Notifi({ title = Config.title, text = Text('busy'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
        return
    end
    drilling = true
    local target = Config.DrillTargets[drillIndex]
    -- Check if drilling item is required and should be removed
    local removeItemOnSuccess = target.Removeitem or false
    local removeItemOnFail = target.Removeitemonfail or false
    grabNow = true
    robber = true
    TriggerServerEvent('estrp-casinoheist:server:SetDrillState', 'isBusy', true, drillIndex)
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
    local animDict = 'anim_heist@hs3f@ig9_vault_drill@laser_drill@'
    loadAnimDict(animDict)
    local bagModel = 'hei_p_m_bag_var22_arm_s'
    loadModel(bagModel)
    local laserDrillModel = 'hei_prop_heist_drill'
    loadModel(laserDrillModel)

    RequestAmbientAudioBank("DLC_HEIST_pacificbank_SOUNDSET", 0)
    RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_pacificbank_DRILL", 0)
    RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_pacificbank_DRILL_2", 0)

    soundId = GetSoundId()

    cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, 0, 3000, 1, 0)

    bag = CreateObject(GetHashKey(bagModel), pedCo, 1, 0, 0)
    laserDrill = CreateObject(GetHashKey(laserDrillModel), pedCo, 1, 0, 0)

    local vaultPos = Config.DrillTargets[drillIndex].vaultpos
    local vaultRot = Config.DrillTargets[drillIndex].vaultRot

    for i = 1, #Drillanims['animations'] do
        Drillanims['scenes'][i] = NetworkCreateSynchronisedScene(vaultPos, vaultRot, 2, true, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Drillanims['scenes'][i], animDict, Drillanims['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(bag, Drillanims['scenes'][i], animDict, Drillanims['animations'][i][2], 1.0, -1.0, 1148846080)
        NetworkAddEntityToSynchronisedScene(laserDrill, Drillanims['scenes'][i], animDict, Drillanims['animations'][i][3], 1.0, -1.0, 1148846080)
    end

    NetworkStartSynchronisedScene(Drillanims['scenes'][1])
    PlayCamAnim(cam, 'intro_cam', animDict, vaultPos, vaultRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'intro') * 1000)

    NetworkStartSynchronisedScene(Drillanims['scenes'][2])
    PlayCamAnim(cam, 'drill_straight_start_cam', animDict, vaultPos, vaultRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'drill_straight_start') * 1000)

    NetworkStartSynchronisedScene(Drillanims['scenes'][3])
    PlayCamAnim(cam, 'drill_straight_idle_cam', animDict, vaultPos, vaultRot, 0, 2)
    PlaySoundFromEntity(soundId, "Drill", laserDrill, "DLC_HEIST_pacificbank_SOUNDSET", 1, 0)

    Drilling.Start(function(status)
        if status then
            StopSound(soundId)
            NetworkStartSynchronisedScene(Drillanims['scenes'][5])
            PlayCamAnim(cam, 'drill_straight_end_cam', animDict, vaultPos, vaultRot, 0, 2)
            Wait(GetAnimDuration(animDict, 'drill_straight_end') * 1000)
            NetworkStartSynchronisedScene(Drillanims['scenes'][6])
            TriggerServerEvent('estrp-casinoheist:server:SetDrillState', 'isOpened', true, drillIndex)
            TriggerServerEvent('estrp-casinoheist:server:SetDrillState', 'isBusy', false, drillIndex)
            TriggerServerEvent('estrp-casinoheist:server:rewardItem')
            PlayCamAnim(cam, 'exit_cam', animDict, vaultPos, vaultRot, 0, 2)
            Wait(GetAnimDuration(animDict, 'exit') * 1000)
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            ClearPedTasks(ped)
            DeleteObject(bag)
            DeleteObject(laserDrill)
            drilling = false
        else
            StopSound(soundId)
            NetworkStartSynchronisedScene(Drillanims['scenes'][4])
            PlayCamAnim(cam, 'drill_straight_fail_cam', animDict, vaultPos, vaultRot, 0, 2)
            Wait(GetAnimDuration(animDict, 'drill_straight_fail') * 1000 - 1500)
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            ClearPedTasks(ped)
            DeleteObject(bag)
            DeleteObject(laserDrill)
            TriggerServerEvent('estrp-casinoheist:server:SetDrillState', 'isOpened', false, drillIndex)
            TriggerServerEvent('estrp-casinoheist:server:SetDrillState', 'isBusy', false, drillIndex)
            Notifi({ title = Config.title, text = Text('overheated'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })  
            drilling = false
            if Config.removedrill then
                TriggerServerEvent("estrp-casinoheist:server:removedrill")
            end
    end
end)
end


function CasinoVaultDrill()
    busy = true
    robber = true
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
    local drillCo = vector3(956.893, 32.123, 72.667)
    local drillRot = vector3(0.000, 0.000, 58.543)
    cvaultdoor = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('k4mb1_casino5_vaultdoor'), false, false, false)
    scenePos = vector3(956.2258, 32.5920, 72.5051)
    sceneRot = GetEntityRotation(cvaultdoor)
    scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 0.5)
    NetworkAddPedToSynchronisedScene(ped, scene, animDict, 'machinic_loop_mechandplayer', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkStartSynchronisedScene(scene)
    loadModel('k4mb1_prop_thermaldrill')
    loadAnimDict(animDict)
    loadModel('hei_p_m_bag_var22_arm_s')

    -- Request the sound banks and wait for them to load
    RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
    RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
    RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)

    Wait(2000)
    ClearPedTasks(ped)
    
    drill = CreateObject(GetHashKey('k4mb1_prop_thermaldrill'), drillCo, true, true, false)
    TriggerServerEvent("estrp-casinoheist:server:removethermal")
    SetEntityRotation(drill, drillRot)
    FreezeEntityPosition(drill, true)
    
    -- Play sound from the drill object
    local soundId = GetSoundId()
    if soundId then
        PlaySoundFromEntity(soundId, "Drill", drill, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
    else
    end
    
    loadPtfxAsset('scr_fbi5a')
    UseParticleFxAssetNextCall('scr_fbi5a')
    ptfx = StartNetworkedParticleFxLoopedOnEntity('scr_bio_grille_cutting', drill, -0.044, -0.50, 0, 0.0, 90.0, 0.0, 1.2, false, false, false)
    
    Citizen.CreateThread(function()
        while true do
            for i = 1, 4 do
                SetEntityCoords(drill, GetEntityCoords(drill) + vector3(0.0015, 0.0015, 0.0015))
                Citizen.Wait(100)
                SetEntityCoords(drill, GetEntityCoords(drill) - vector3(0.0015, 0.0015, 0.0015))
                Citizen.Wait(100)
                SetEntityCoords(drill, GetEntityCoords(drill) - vector3(-0.0015, 0.0015, 0.0015))
                Citizen.Wait(100)
                SetEntityCoords(drill, GetEntityCoords(drill) + vector3(-0.0015, 0.0015, 0.0015))
            end
            Citizen.Wait(10000)
        end
    end)
    
    lib.progressBar({
        duration = Config.DrillVault,
        label = Text("drillingvault"),
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = false,
            move = false,
            combat = false,
        },
    })
    
    DeleteObject(drill)
    busy = false
    StopSound(soundId)
    TriggerServerEvent("estrp-casinoheist:server:synced", "mainvaultopen") 
    Notifi({ title = Config.title, text = Text("vaultopen"), icon = 'fa-solid fa-vault', color = '#07eb16' })
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

RegisterNetEvent('estrp-casinoheist:client:PanelAction')
AddEventHandler('estrp-casinoheist:client:PanelAction', function(k)
    casinopanel = Config.Panels[k]['prop']
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
     panel = GetClosestObjectOfType(pedCo, 6.0, GetHashKey(casinopanel), false, false, false)

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

RegisterNetEvent('estrp-casinoheist:client:OpenDoor')
AddEventHandler('estrp-casinoheist:client:OpenDoor', function(k, success)
    casinopanel = Config.Panels[k]['prop']
    local ped = PlayerPedId()
    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
    local animDict = 'anim_heist@hs3f@ig1_hack_keypad@arcade@male@'
    local usbModel = 'ch_prop_ch_usb_drive01x'
    local phoneModel = 'prop_phone_ing'
    loadAnimDict(animDict)
    loadModel(usbModel)
    loadModel(phoneModel)

    local panel = GetClosestObjectOfType(pedCo, 6.0, GetHashKey(casinopanel), false, false, false)
    
    if not panel then
        print("No object nearby!")
        return
    end
if success then
    Notifi({ title = Config.title, text = Text('doorunlocked'), icon = 'fa-solid fa-door-open', color = '#32a852' })
    if k == 1 then
    Policenotify()
    SpawnStacks()
    TriggerServerEvent("estrp-casinoheist:server:casinorefresh")
    TriggerServerEvent('estrp-casinoheist:server:synced', 'openmain')
    end
    if k == 2 then
    TriggerServerEvent('estrp-casinoheist:server:synced', 'bossroom')
    end
    if k == 3 then
    TriggerServerEvent('estrp-casinoheist:server:synced', 'guardofficeback')
    end
    if k == 4 then
    TriggerServerEvent('estrp-casinoheist:server:synced', 'garagesliders')
    end
    if k == 5 then
    TriggerServerEvent('estrp-casinoheist:server:synced', 'togarage')
    end
    if k == 6 then
    Policenotify()
    SpawnStacks()
    TriggerServerEvent("estrp-casinoheist:server:casinorefresh")
    TriggerServerEvent('estrp-casinoheist:server:synced', 'tobackrooms')
    end
    if k == 7 or k == 8 then
    TriggerServerEvent('estrp-casinoheist:server:synced', 'vaultglassdoors')
    end
    if k == 9 then
    TriggerServerEvent('estrp-casinoheist:server:synced', 'elevator')
    TriggerServerEvent('estrp-casinoheist:server:synced', 'vaultglassdoors')
    end
    if k == 10 then
    TriggerServerEvent('estrp-casinoheist:server:synced', 'elevator')
    end
    if k == 11 then
    TriggerServerEvent("estrp-casinoheist:server:synced", "smallvaultopen")
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

RegisterNetEvent('estrp-casinoheist:client:OpenBox')
AddEventHandler('estrp-casinoheist:client:OpenBox', function(k)
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

RegisterNetEvent('estrp-casinoheist:client:CloseBox')
AddEventHandler('estrp-casinoheist:client:CloseBox', function(k, success)
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
    SpawnStacks()
    TriggerServerEvent("estrp-casinoheist:server:casinorefresh")
    TriggerServerEvent('estrp-casinoheist:server:synced', 'garage')
    end
    Notifi({ title = Config.title, text = Text('wiresbroken'), icon = 'fa-solid fa-toolbox', color = '#9eeb34' })
    else
    ExitScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(Fusebox, -0.0, -0.0, -0.0), ScenRotation, 2, false, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, ExitScene, "anim@scripted@player@mission@tun_control_tower@male@", 'exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(Fusebox, ExitScene, animDict, 'exit_electric_box', 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(ExitScene)
    Notifi({ title = Config.title, text = Text("failedbreak"), icon = 'fa-regular fa-gem', color = '#ff0000' })  
    end
end)



function Stealpainting(k)
    paintobj = Config.Paintings[k]
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

    SceneCabinet = GetClosestObjectOfType(pedCo, 5.0, GetHashKey('ch_prop_ch_sec_cabinet_02a'), 0, 0, 0)
    ScenePaint = GetClosestObjectOfType(pedCo, 7.0, GetHashKey(paintobj.PaintingObj), 0, 0, 0)
    
    local bag = CreateObject(heistbag, pedCo, true, true, false)
    local cuttingknife = CreateObject(knife, pedCo, true, true, false)

       -- Get the coordinates of the ScenePaint
    paintCoords = GetEntityCoords(ScenePaint)
    
    -- Find the closest object to the ScenePaint's coordinates (within a range)
    closestPaintingObj = GetClosestObjectOfType(paintCoords, 5.0, GetHashKey(paintobj.PaintingObj), false, false, false)
       

    CamAnim = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(CamAnim, true)
    RenderScriptCams(true, 0, 3000, 1, 0)

    
    if not SceneCabinet then
        print("No object found near player!")
        return
    end

    TriggerServerEvent('estrp-casinoheist:server:setPaintingState', 'isBusy', true, k)

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

    ScenRotation = GetEntityRotation(ScenePaint)

    SceneStart = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, SceneStart, animDict, 'ver_02_top_left_enter', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(SceneCabinet, SceneStart, animDict, 'ver_02_top_left_enter_ch_prop_ch_sec_cabinet_02a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(ScenePaint, SceneStart, animDict, 'ver_02_top_left_enter_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, SceneStart, animDict, 'ver_02_top_left_enter_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, SceneStart, animDict, 'ver_02_top_left_enter_w_me_switchblade', 4.0, -8.0, 1)
    
    lefttorightScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, lefttorightScene, animDict, 'ver_02_cutting_top_left_to_right', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(SceneCabinet, lefttorightScene, animDict, 'ver_02_cutting_top_left_to_right_ch_prop_ch_sec_cabinet_02a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(ScenePaint, lefttorightScene, animDict, 'ver_02_cutting_top_left_to_right_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, lefttorightScene, animDict, 'ver_02_cutting_top_left_to_right_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, lefttorightScene, animDict, 'ver_02_cutting_top_left_to_right_w_me_switchblade', 4.0, -8.0, 1)
    
    toptobottomScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, toptobottomScene, animDict, 'ver_02_cutting_right_top_to_bottom', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(SceneCabinet, toptobottomScene, animDict, 'ver_02_cutting_right_top_to_bottom_ch_prop_ch_sec_cabinet_02a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(ScenePaint, toptobottomScene, animDict, 'ver_02_cutting_right_top_to_bottom_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, toptobottomScene, animDict, 'ver_02_cutting_right_top_to_bottom_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, toptobottomScene, animDict, 'ver_02_cutting_right_top_to_bottom_w_me_switchblade', 4.0, -8.0, 1)
    
    bottomrighttoleftScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, bottomrighttoleftScene, animDict, 'ver_02_cutting_bottom_right_to_left', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(SceneCabinet, bottomrighttoleftScene, animDict, 'ver_02_cutting_bottom_right_to_left_ch_prop_ch_sec_cabinet_02a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(ScenePaint, bottomrighttoleftScene, animDict, 'ver_02_cutting_bottom_right_to_left_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, bottomrighttoleftScene, animDict, 'ver_02_cutting_bottom_right_to_left_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, bottomrighttoleftScene, animDict, 'ver_02_cutting_bottom_right_to_left_w_me_switchblade', 4.0, -8.0, 1)
    
    lefttoptobottomScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, lefttoptobottomScene, animDict, 'ver_02_cutting_left_top_to_bottom', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(SceneCabinet, lefttoptobottomScene, animDict, 'ver_02_cutting_left_top_to_bottom_ch_prop_ch_sec_cabinet_02a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(ScenePaint, lefttoptobottomScene, animDict, 'ver_02_cutting_left_top_to_bottom_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, lefttoptobottomScene, animDict, 'ver_02_cutting_left_top_to_bottom_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, lefttoptobottomScene, animDict, 'ver_02_cutting_left_top_to_bottom_w_me_switchblade', 4.0, -8.0, 1)
    

    exitscene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 2, true, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, exitscene, animDict, 'ver_02_with_painting_exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(SceneCabinet, exitscene, animDict, 'ver_02_with_painting_exit_ch_prop_ch_sec_cabinet_02a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(ScenePaint, exitscene, animDict, 'ver_02_with_painting_exit_ch_prop_vault_painting_01a', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, exitscene, animDict, 'ver_02_with_painting_exit_hei_p_m_bag_var22_arm_s', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cuttingknife, exitscene, animDict, 'ver_02_with_painting_exit_w_me_switchblade', 4.0, -8.0, 1)
    
    NetworkStartSynchronisedScene(SceneStart)
    PlayCamAnim(CamAnim, 'ver_02_top_left_enter_cam_ble', animDict, GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(lefttorightScene)
    PlayCamAnim(CamAnim, 'ver_02_cutting_top_left_to_right_cam', animDict, GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(toptobottomScene)
    PlayCamAnim(CamAnim, 'ver_02_cutting_right_top_to_bottom_cam', animDict, GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(bottomrighttoleftScene)
    PlayCamAnim(CamAnim, 'ver_02_cutting_bottom_right_to_left_cam', animDict, GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 0, 2)
    Wait(3000)
    NetworkStartSynchronisedScene(lefttoptobottomScene)
    PlayCamAnim(CamAnim, 'ver_02_cutting_left_top_to_bottom_cam', animDict, GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 0, 2)
    Wait(1500)
    NetworkStartSynchronisedScene(exitscene)
    PlayCamAnim(CamAnim, 'ver_02_with_painting_exit_cam', animDict, GetOffsetFromEntityInWorldCoords(SceneCabinet, -0.0, -0.0, -0.0), ScenRotation, 0, 2)
    Wait(7000)
    TriggerServerEvent('estrp-casinoheist:server:setPaintingState', 'isBusy', k, false)
    TriggerServerEvent('estrp-casinoheist:server:setPaintingState', 'isTaken', k, true)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(CamAnim, false)
    ClearPedTasks(ped)
    DeleteEntity(bag)
    DeleteEntity(cuttingknife)
    -- Randomly select a reward and amount
    local function RandomCasinoPaintingReward(paintobj)
        local reward = paintobj.rewards[math.random(#paintobj.rewards)]
        local amount = 1
        return reward, amount
    end

    local reward, amount = RandomCasinoPaintingReward(paintobj)
    TriggerServerEvent("estrp-casinoheist:server:PaintingReward", k,  reward, amount)
    TriggerServerEvent("estrp-casinoheist:server:synced", "removepainting")
end

VitrineAnims = {
    ['items'] = {
        'hei_p_m_bag_var22_arm_s',
        'h4_prop_h4_cutter_01a',
    },
    ['anims'] = {
        {'enter', 'enter_bag', 'enter_cutter', 'enter_glass_display'},
        {'idle', 'idle_bag', 'idle_cutter', 'idle_glass_display'},
        {'cutting_loop', 'cutting_loop_bag', 'cutting_loop_cutter', 'cutting_loop_glass_display'},
        {'overheat_react_01', 'overheat_react_01_bag', 'overheat_react_01_cutter', 'overheat_react_01_glass_display'},
        {'success', 'success_bag', 'success_cutter', 'success_glass_display_cut'},
    },
    ['scenes'] = {},
    ['sceneitems'] = {},
}

function GlassCuttingScene()
     -- Check if the player is already drilling or grabbing to avoid conflicts
     if busy or taken then
        Notifi({ title = Config.title, text = Text('cantdo'), icon = 'fa-solid fa-vault', color = '#ff0000' })
        return
    end
 
    DisableControlAction(19, true)
    DisableControlAction(73, true)
    busy = true
    local ped = PlayerPedId()
   local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
   local animDict = 'anim@scripted@heist@ig16_glass_cut@male@'
   sceneVitrineObject = GetClosestObjectOfType(973.9462, 20.7737, 72.8073, 1.0, GetHashKey('h4_prop_h4_glass_disp_01a'), 0, 0, 0)
   CasinoDiamond = GetClosestObjectOfType(973.9462, 20.7737, 72.8073, 6.0, GetHashKey('k4mb1_casino5_diamond'), 0, 0, 0)
   scenePos = GetEntityCoords(sceneVitrineObject)
   sceneRot = GetEntityRotation(sceneVitrineObject)
   loadAnimDict(animDict)
   RequestScriptAudioBank('DLC_HEI4/DLCHEI4_GENERIC_01', -1)
 
    cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, 0, 3000, 1, 0)

    -- Get the coordinates of the obj
     VitrineObjCoords = GetEntityCoords(sceneVitrineObject)
     DiamondObjCoords = GetEntityCoords(CasinoDiamond)
    
   -- Find the closest object to the obj coordinates (within a range)
    closestVitrineObj = GetClosestObjectOfType(VitrineObjCoords, 6.0, GetHashKey("h4_prop_h4_glass_disp_01a"), false, false, false)
    closestDiamondObj = GetClosestObjectOfType(DiamondObjCoords, 6.0, GetHashKey("k4mb1_casino5_diamond"), false, false, false)
 
 
 
    for k, v in pairs(VitrineAnims['items']) do
        loadModel(v)
        VitrineAnims['sceneitems'][k] = CreateObject(GetHashKey(v), pedCo, 1, 1, 0)
    end

    newObj = CreateObject(GetHashKey('h4_prop_h4_glass_disp_01b'), GetEntityCoords(sceneObject), 1, 1, 0)
    SetEntityHeading(newObj, GetEntityHeading(sceneObject))
     -- Ensure control over the entity
     while not NetworkHasControlOfEntity(newObj) do
         Citizen.Wait(1)
         NetworkRequestControlOfEntity(newObj)
     end
 
     while not NetworkHasControlOfEntity(CasinoDiamond) do
         Citizen.Wait(1)
         NetworkRequestControlOfEntity(CasinoDiamond)
     end
     while not NetworkHasControlOfEntity(sceneVitrineObject) do
        Citizen.Wait(1)
        NetworkRequestControlOfEntity(sceneVitrineObject)
    end
 
    for i = 1, #VitrineAnims['anims'] do
        VitrineAnims['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, VitrineAnims['scenes'][i], animDict, VitrineAnims['anims'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(VitrineAnims['sceneitems'][1], VitrineAnims['scenes'][i], animDict, VitrineAnims['anims'][i][2], 1.0, -1.0, 1148846080)
        NetworkAddEntityToSynchronisedScene(VitrineAnims['sceneitems'][2], VitrineAnims['scenes'][i], animDict, VitrineAnims['anims'][i][3], 1.0, -1.0, 1148846080)
        if i ~= 5 then
            NetworkAddEntityToSynchronisedScene(sceneObject, VitrineAnims['scenes'][i], animDict, VitrineAnims['anims'][i][4], 1.0, -1.0, 1148846080)
        else
            NetworkAddEntityToSynchronisedScene(newObj, VitrineAnims['scenes'][i], animDict, VitrineAnims['anims'][i][4], 1.0, -1.0, 1148846080)
        end
    end
 
    local sound1 = GetSoundId()
    local sound2 = GetSoundId()
 
    NetworkStartSynchronisedScene(VitrineAnims['scenes'][1])
    PlayCamAnim(cam, 'enter_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'enter') * 1000)
 
    NetworkStartSynchronisedScene(VitrineAnims['scenes'][2])
    PlayCamAnim(cam, 'idle_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'idle') * 1000)
 
    NetworkStartSynchronisedScene(VitrineAnims['scenes'][3])
    PlaySoundFromEntity(sound1, "StartCutting", VitrineAnims['sceneitems'][2], 'DLC_H4_anims_glass_cutter_Sounds', true, 80)
    loadPtfxAsset('scr_ih_fin')
    UseParticleFxAssetNextCall('scr_ih_fin')
    fire1 = StartParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_cut', VitrineAnims['sceneitems'][2], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0.0, 0.0, 0.0, 1065353216, 1065353216, 1065353216, 0)
    PlayCamAnim(cam, 'cutting_loop_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'cutting_loop') * 1000)
    StopSound(sound1)
    StopParticleFxLooped(fire1)
 
    NetworkStartSynchronisedScene(VitrineAnims['scenes'][4])
    PlaySoundFromEntity(sound2, "Overheated", VitrineAnims['sceneitems'][2], 'DLC_H4_anims_glass_cutter_Sounds', true, 80)
    UseParticleFxAssetNextCall('scr_ih_fin')
    fire2 = StartParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_overheat', VitrineAnims['sceneitems'][2], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0.0, 0.0, 0.0)
    PlayCamAnim(cam, 'overheat_react_01_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'overheat_react_01') * 1000)
    StopSound(sound2)
    StopParticleFxLooped(fire2)
    TriggerServerEvent("estrp-casinoheist:server:synced", "removevitrine")
    NetworkStartSynchronisedScene(VitrineAnims['scenes'][5])
    Wait(2000)
    TriggerServerEvent('estrp-casinoheist:server:DiamondReward')
    TriggerServerEvent("estrp-casinoheist:server:synced", "removediamond")
    PlayCamAnim(cam, 'success_cam', animDict, scenePos, sceneRot, 0, 2)
    Wait(GetAnimDuration(animDict, 'success') * 1000 - 2000)
    DeleteObject(VitrineAnims['sceneitems'][1])
    DeleteObject(VitrineAnims['sceneitems'][2])
    ClearPedTasks(ped)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    busy = false
    taken = true
    if Config.removecutter then
        TriggerServerEvent("estrp-casinoheist:server:removecutter")
    end
 end


------ /

function GrabGold(k)
     -- Check if the player is already drilling or grabbing to avoid conflicts
     if drilling or grabbing then
        Notifi({ title = Config.title, text = Text('busy'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
        return
    end
    TriggerServerEvent('estrp-casinoheist:server:setGTrolleyState', 'isBusy', true, k)
    -- Set the player to a grabbing state and disable input
    grabbing = true
    disableinput = true
    startdstcheck = true

    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local model = "ch_prop_gold_bar_01a"

    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, -735318549, false, false, false)
   
    -- Ensure the object is networked
    if not NetworkGetEntityIsNetworked(Trolley) then
        NetworkRegisterEntityAsNetworked(Trolley)
    end

    local netId = NetworkGetNetworkIdFromEntity(Trolley)
    NetworkRequestControlOfEntity(Trolley)
    Wait(100)

    if not NetworkHasControlOfEntity(Trolley) then
        print("Failed to get network control of scenecase!")
        return
    end
    local CashAppear = function()
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Citizen.Wait(100)
        end
	    local grabobj = CreateObject(grabmodel, pedCoords, true)

	    --FreezeEntityPosition(grabobj, true)
	    SetEntityInvincible(grabobj, true)
	    SetEntityNoCollisionEntity(grabobj, ped)
	    SetEntityVisible(grabobj, false, false)
	    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	    local startedGrabbing = GetGameTimer()

	    Citizen.CreateThread(function()
		    while GetGameTimer() - startedGrabbing < 37000 do
			    Citizen.Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, `CASH_APPEAR`) then
				    if not IsEntityVisible(grabobj) then
					    SetEntityVisible(grabobj, true, false)
				    end
			    end
			    if HasAnimEventFired(ped, `RELEASE_CASH_DESTROY`) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
				    end
			    end
		    end
		    DeleteObject(grabobj)
	    end)
    end
	local trollyobj = Trolley

	if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end
    local baghash =`hei_p_m_bag_var22_arm_s`

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Citizen.Wait(100)
    end
	while not NetworkHasControlOfEntity(trollyobj) do
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)
	Citizen.Wait(1500)
	CashAppear()
	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Citizen.Wait(37000)
	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)
     
     -- Get the coordinates of the Gold trolley
     GTrolleyCoords = GetEntityCoords(Trolley)
    
     -- Find the closest object to the Gold trolley coordinates (within a range)
     closestGTrolleyObj = GetClosestObjectOfType(GTrolleyCoords, 1.0, GetHashKey("ch_prop_gold_trolly_01c"), false, false, false)

    TriggerServerEvent("estrp-casinoheist:server:synced", "gtrolleytaken")
	Citizen.Wait(1800)
	DeleteObject(bag)
    ----SetPedComponentVariation(ped, 5, 45, 0, 0)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
    SetModelAsNoLongerNeeded(`hei_p_m_bag_var22_arm_s`)
    SetModelAsNoLongerNeeded(`prop_gold_trolly`)
    TriggerServerEvent("estrp-casinoheist:server:rewardItemtrolley")
    TriggerServerEvent('estrp-casinoheist:server:setGTrolleyState', 'isBusy', k, false)
    TriggerServerEvent('estrp-casinoheist:server:setGTrolleyState', 'isTaken', k, true)
    disableinput = false
    grabbing = false
end

function GrabCash(k)
    -- Check if the player is already drilling or grabbing to avoid conflicts
    if drilling or grabbing then
       Notifi({ title = Config.title, text = Text('busy'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
       return
   end
   TriggerServerEvent('estrp-casinoheist:server:setCTrolleyState', 'isBusy', true, k)
   -- Set the player to a grabbing state and disable input
   grabbing = true
   disableinput = true
   startdstcheck = true

   local ped = PlayerPedId()
   local pedCo = GetEntityCoords(ped)
   local model = "hei_prop_heist_cash_pile"

   Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, 412463629, false, false, false)
  
   -- Ensure the object is networked
   if not NetworkGetEntityIsNetworked(Trolley) then
       NetworkRegisterEntityAsNetworked(Trolley)
   end

   local netId = NetworkGetNetworkIdFromEntity(Trolley)
   NetworkRequestControlOfEntity(Trolley)
   Wait(100)

   if not NetworkHasControlOfEntity(Trolley) then
       return
   end
   local CashAppear = function()
       local pedCoords = GetEntityCoords(ped)
       local grabmodel = GetHashKey(model)

       RequestModel(grabmodel)
       while not HasModelLoaded(grabmodel) do
           Citizen.Wait(100)
       end
       local grabobj = CreateObject(grabmodel, pedCoords, true)

       --FreezeEntityPosition(grabobj, true)
       SetEntityInvincible(grabobj, true)
       SetEntityNoCollisionEntity(grabobj, ped)
       SetEntityVisible(grabobj, false, false)
       AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
       local startedGrabbing = GetGameTimer()

       Citizen.CreateThread(function()
           while GetGameTimer() - startedGrabbing < 37000 do
               Citizen.Wait(1)
               DisableControlAction(0, 73, true)
               if HasAnimEventFired(ped, `CASH_APPEAR`) then
                   if not IsEntityVisible(grabobj) then
                       SetEntityVisible(grabobj, true, false)
                   end
               end
               if HasAnimEventFired(ped, `RELEASE_CASH_DESTROY`) then
                   if IsEntityVisible(grabobj) then
                       SetEntityVisible(grabobj, false, false)
                   end
               end
           end
           DeleteObject(grabobj)
       end)
   end
   local trollyobj = Trolley

   if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
       return
   end
   local baghash =`hei_p_m_bag_var22_arm_s`

   RequestAnimDict("anim@heists@ornate_bank@grab_cash")
   RequestModel(baghash)
   RequestModel(emptyobj)
   while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
       Citizen.Wait(100)
   end
   while not NetworkHasControlOfEntity(trollyobj) do
       Citizen.Wait(1)
       NetworkRequestControlOfEntity(trollyobj)
   end
   local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, GetEntityCoords(PlayerPedId()), true, false, false)
   local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

   NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
   NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
   SetPedComponentVariation(ped, 5, 0, 0, 0)
   NetworkStartSynchronisedScene(scene1)
   Citizen.Wait(1500)
   CashAppear()
   local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

   NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
   NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
   NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
   NetworkStartSynchronisedScene(scene2)
   Citizen.Wait(37000)
   local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

   NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
   NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
   NetworkStartSynchronisedScene(scene3)
   
  -- Get the coordinates of the Gold trolley
  CTrolleyCoords = GetEntityCoords(Trolley)
    
  -- Find the closest object to the Gold trolley coordinates (within a range)
   closestCTrolleyObj = GetClosestObjectOfType(CTrolleyCoords, 1.0, GetHashKey("ch_prop_ch_cash_trolly_01c"), false, false, false)

   TriggerServerEvent("estrp-casinoheist:server:synced", "ctrolleytaken")
   Citizen.Wait(1800)
   DeleteObject(bag)
   ----SetPedComponentVariation(ped, 5, 45, 0, 0)
   RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
   SetModelAsNoLongerNeeded(`hei_p_m_bag_var22_arm_s`)
   SetModelAsNoLongerNeeded(`hei_prop_hei_cash_trolly_03`)
   -- Trigger the server event to reward the player with cash
   TriggerServerEvent("estrp-casinoheist:rewardCash")
   TriggerServerEvent('estrp-casinoheist:server:setCTrolleyState', 'isBusy', k, false)
   TriggerServerEvent('estrp-casinoheist:server:setCTrolleyState', 'isTaken', k, true)
   disableinput = false
   grabbing = false
end

local elevatorLocations = {
    { pos = vector4(958.4239, 39.2174, 72.8679, 329.8304), destination = vector4(955.8705, 13.0239, 78.8445, 58.0340) }, -- Location A to B
    { pos = vector4(955.8705, 13.0239, 78.8445, 58.0340), destination = vector4(958.4239, 39.2174, 72.8679, 329.8304) }, -- Location B to A
}

local distanceThreshold = 3.0 -- Distance to show the text UI
local textShown = false

-- Main thread for detecting proximity and handling the elevator
CreateThread(function()
    while true do
        local sleep = 500 -- Default sleep time when the player is far from elevators
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local isDriver = vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed -- Check if player is in the driver seat
        local isNearElevator = false

        for _, elevator in ipairs(elevatorLocations) do
            local dist = #(playerCoords - elevator.pos.xyz)

            if dist <= distanceThreshold then
                isNearElevator = true
                sleep = 10 -- Reduce sleep time for responsive interaction

                -- Show TextUI if the player is either the driver or not in a vehicle
                if not textShown and (vehicle == 0 or isDriver) then
                    textShown = true
                    lib.showTextUI(Text("useelevator"), {
                        position = 'right-center',
                        icon = 'fa-solid fa-elevator',
                    })
                end

                -- If 'E' is pressed, teleport the player or vehicle
                if IsControlJustPressed(0, 38) and (vehicle == 0 or isDriver) then
                    TeleportPlayerOrVehicle(elevator.destination)
                end
                break
            end
        end

        -- Hide TextUI if not near any elevator or player doesn't meet the conditions
        if (not isNearElevator or (vehicle ~= 0 and not isDriver)) and textShown then
            textShown = false
            lib.hideTextUI()
        end

        Wait(sleep) -- Dynamically adjust sleep time
    end
end)

-- Function to teleport the player or the vehicle
function TeleportPlayerOrVehicle(destination)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    -- Start fade-out effect
    DoScreenFadeOut(500)
    Wait(500) -- Wait for the fade-out effect to complete

    if vehicle ~= 0 then
        -- Player is in a vehicle, teleport the vehicle
        SetEntityCoords(vehicle, destination.x, destination.y, destination.z, false, false, false, true)
        SetEntityHeading(vehicle, destination.w)
    else
        -- Player is not in a vehicle, teleport the player
        SetEntityCoords(playerPed, destination.x, destination.y, destination.z, false, false, false, true)
        SetEntityHeading(playerPed, destination.w)
    end

    Wait(500) -- Wait a bit before fading in
    -- Start fade-in effect
    DoScreenFadeIn(500)
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

RegisterNetEvent('estrp-casinoheist:client:synced')
AddEventHandler('estrp-casinoheist:client:synced', function(syncevent, paintingID, index, index2)
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
if syncevent == 'mainvaultopen' then
    local CasinoVaultCoords = vector3(956.1699, 30.18544, 73.39164)
    casinomainvaultopen = true
    startdstcheckcasino = true
    initiatorcasino = true
    Notifi({ title = Config.title, text = Text('toopencell'), icon = 'fa-solid fa-door-open', color = '#32a852' })
        -- Handle bank vault door
        local CasinoVaultObj = GetClosestObjectOfType(CasinoVaultCoords, 15.0, -127348208, false, false, false)
        if bankVaultDoorObj ~= 0 then
            local openheading = 163.9  -- Use the bank's door heading
            Citizen.CreateThread(function()
                while true do
                    local closedheading = GetEntityHeading(CasinoVaultObj)

                    -- If the door is not at the desired heading, adjust it
                if math.abs(closedheading - openheading) > 0.5 then
                    -- Smoothly adjust the heading
                    SetEntityHeading(CasinoVaultObj, closedheading + 0.5)
                else
                    -- Freeze the door in the open state
                    FreezeEntityPosition(CasinoVaultObj, true)
                    break
                end

                    Citizen.Wait(10) -- Smooth transition with a delay
                 end
            end)
        end
    elseif syncevent == 'openmain' then
        Casinoheiststarted = true
        singleentranceopen = true
    elseif syncevent == 'bossroom' then
        innderdoubleopen = true
    elseif syncevent == 'openstaircasedoor' then
        innerdouble2open = true
    elseif syncevent == 'guardofficeback' then
        lowersingleopen = true
    elseif syncevent == 'elevator' then
        elevatoropen = true
    elseif syncevent == 'garagesliders' then
        garageslidersopen = true
    elseif syncevent == 'garage' then
        Casinoheiststarted = true
        garageopen = true
    elseif syncevent == 'tostaircase' then
        guardtovaultopen = true
    elseif syncevent == 'togarage' then
        garagetoguardopen = true
    elseif syncevent == 'tobackrooms' then
        Casinoheiststarted = true
        casinotostairsopen = true
    elseif syncevent == 'vaultglassdoors' then
        vaultdoubleglassopen = true
    elseif syncevent == 'smallvaultopen' then
        local SmallvaultCoords = vector3(971.5598, 23.28996, 73.10324)
        smallvaultopen = true
        startdstcheckcasino = true
        initiatorcasino = true
    
            -- Handle bank vault door
            local SmallVaultDoorObj = GetClosestObjectOfType(SmallvaultCoords, 15.0, 1405979971, false, false, false)
            if bankVaultDoorObj ~= 0 then
                local openheading = 121.73  -- Use the bank's door heading
                Citizen.CreateThread(function()
                    while true do
                        local closedheading = GetEntityHeading(SmallVaultDoorObj)
    
                        -- If the door is not at the desired heading, adjust it
                    if math.abs(closedheading - openheading) > 1.5 then
                        -- Smoothly adjust the heading
                        SetEntityHeading(SmallVaultDoorObj, closedheading - 0.5)
                    else
                        -- Freeze the door in the open state
                        FreezeEntityPosition(SmallVaultDoorObj, true)
                        break
                    end
    
                        Citizen.Wait(10) -- Smooth transition with a delay
                     end
                end)
            end
    elseif syncevent == 'vaultcellopen' then
        local CsnoVaultCellCoords = vector3(957.629, 30.407, 73.157)
        vaultcellopen = true
        startdstcheckcasino = true
        initiatorcasino = true
    
            -- Handle bank vault door
            local CsnVaultCellObj = GetClosestObjectOfType(CsnoVaultCellCoords, 15.0, 1671627351, false, false, false)
            if bankVaultCellDoorObj ~= 0 then
                local openheading = 133.65 -- Use the bank's door heading
                Citizen.CreateThread(function()
                    while true do
                        local closedheading = GetEntityHeading(CsnVaultCellObj)
    
                        -- If the door is not at the desired heading, adjust it
                    if math.abs(closedheading - openheading) > 1.5 then
                        -- Smoothly adjust the heading
                        SetEntityHeading(CsnVaultCellObj, closedheading - 0.5)
                    else
                        -- Freeze the door in the open state
                        FreezeEntityPosition(CsnVaultCellObj, true)
                        break
                    end
    
                        Citizen.Wait(10) -- Smooth transition with a delay
                     end
                end)
            end
    elseif syncevent == 'openminisafe' then
            local MinisafeCoords = vector3(930.615, 7.900, 80.867)
            bossminisafeopen = true
            startdstcheckcasino = true
            initiatorcasino = true
        
                -- Handle bank vault door
                local MinisafeObj = GetClosestObjectOfType(MinisafeCoords, 16.0, -1992154984, false, false, false)
                if bankSafeObj ~= 0 then
                    local openheading = 277.74  -- Use the bank's door heading
                    Citizen.CreateThread(function()
                        while true do
                            local closedheading = GetEntityHeading(MinisafeObj)
        
                            -- If the door is not at the desired heading, adjust it
                        if math.abs(closedheading - openheading) > 0.5 then
                            -- Smoothly adjust the heading
                            SetEntityHeading(MinisafeObj, closedheading + 0.5)
                        else
                            -- Freeze the door in the open state
                            FreezeEntityPosition(MinisafeObj, true)
                            break
                        end
        
                            Citizen.Wait(10) -- Smooth transition with a delay
                         end
                    end)
                end
    elseif syncevent == 'removepainting' then
    -- Delete the closest object
    if closestPaintingObj then
        SetEntityCoords(closestPaintingObj, 0.0, 0.0, 0.0, false, false, false, true)
        DeleteObject(closestPaintingObj)
    end
    elseif syncevent == 'gtrolleytaken' then
    if closestGTrolleyObj then
        SetEntityCoords(closestGTrolleyObj, 0.0, 0.0, 0.0, false, false, false, true)
        DeleteObject(closestGTrolleyObj)
    end
    elseif syncevent == 'ctrolleytaken' then
    if closestCTrolleyObj then
        SetEntityCoords(closestCTrolleyObj, 0.0, 0.0, 0.0, false, false, false, true)
        DeleteObject(closestCTrolleyObj)
    end
    elseif syncevent == 'removevitrine' then
    if closestVitrineObj then
        SetEntityCoords(closestVitrineObj, 0.0, 0.0, 0.0, false, false, false, true)
        DeleteObject(closestVitrineObj)
    end
    elseif syncevent == 'removediamond' then
    if closestDiamondObj then
        SetEntityCoords(closestDiamondObj, 0.0, 0.0, 0.0, false, false, false, true)
        DeleteObject(closestDiamondObj)
    end
    elseif syncevent == 'finishheist' then
        Casinoheiststarted = false
        startdstcheckcasino = false
        initiatorcasino = false
        singleentranceopen = false
        innderdoubleopen = false
        innerdouble2open = false
        lowersingleopen = false
        elevatoropen = false
        garageopen = false
        guardtovaultopen = false
        garagetoguardopen = false
        garageslidersopen = false
        casinotostairsopen = false
        casinomainvaultopen = false
        vaultdoubleglassopen = false
        smallvaultopen = false
        vaultcellopen = false
        bossminisafeopen = false    
    local interiorId = GetInteriorAtCoords(956.5297, 21.5303, 72.8073)
    RefreshInterior(interiorId)
    print("refreshed")
    end
end)

-- Client-Side Script to Handle Reset
RegisterNetEvent("estrp-casinoheist:resetRobberyClient")
AddEventHandler("estrp-casinoheist:resetRobberyClient", function()
    Casinoheiststarted = false
    startdstcheckcasino = false
    initiatorcasino = false
    singleentranceopen = false
    innderdoubleopen = false
    innerdouble2open = false
    lowersingleopen = false
    elevatoropen = false
    garageopen = false
    guardtovaultopen = false
    garagetoguardopen = false
    garageslidersopen = false
    casinotostairsopen = false
    casinomainvaultopen = false
    vaultdoubleglassopen = false
    smallvaultopen = false
    vaultcellopen = false
    bossminisafeopen = false
    TriggerServerEvent("estrp-casinoheist:server:synced", "finishheist")
    local interiorId = GetInteriorAtCoords(956.5297, 21.5303, 72.8073)
    RefreshInterior(interiorId)
    print("refreshed")
    TriggerServerEvent("estrp-casinoheist:cleanUp")
    TriggerServerEvent("estrp-casinoheist:resetrobbery")
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    Casinoheiststarted = false
    startdstcheckcasino = false
    initiatorcasino = false
    singleentranceopen = false
    innderdoubleopen = false
    innerdouble2open = false
    lowersingleopen = false
    elevatoropen = false
    garageopen = false
    guardtovaultopen = false
    garagetoguardopen = false
    garageslidersopen = false
    casinotostairsopen = false
    casinomainvaultopen = false
    vaultdoubleglassopen = false
    smallvaultopen = false
    vaultcellopen = false
    bossminisafeopen = false
    DeleteEntity(newObj)
    DeleteStacks()
    local interiorId = GetInteriorAtCoords(956.5297, 21.5303, 72.8073)
    RefreshInterior(interiorId)
    if DoesEntityExist(CasinoFuseBox) then
    DeleteEntity(CasinoFuseBox)
    end
    TriggerServerEvent("estrp-casinoheist:cleanUp")
    TriggerServerEvent("estrp-casinoheist:resetrobbery")
end)
