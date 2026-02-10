--RAINMAD SCRIPTS - discord.gg/rccvdkmA5X - rainmad.com
Config = {}

Config['BettaHeist'] = {
    ['framework'] = {
        name = 'ESX', -- Only ESX or QB.
        scriptName = 'es_extended', -- Framework script name work framework exports. (Example: qb-core or es_extended)
        eventName = 'esx:getSharedObject', -- If your framework using trigger event for shared object, you can set in here.
        targetScript = 'ox_target' -- Target script name (qtarget or qb-target or ox_target)
    },
    ['bagClothesID'] = 45,
    ['buyerFinishScene'] = true,
    ["dispatch"] = "default", -- cd_dispatch | qs-dispatch | ps-dispatch | rcore_dispatch | default
    ['requiredPoliceCount'] = 0, -- required police count for start heist
    ['dispatchJobs'] = {'police', 'sheriff'},
    ['nextRob'] = 3600, -- Seconds for next heist
    ['startHeist'] ={ -- Heist start coords
        pos = vector3(-1419.7, -676.23, 26.7605),
        peds = {
            {pos = vector3(-1419.7, -676.23, 26.7605), heading = 78.4, ped = 's_m_m_highsec_01'},
            {pos = vector3(-1420.3, -675.34, 26.7246), heading = 168.78, ped = 's_m_m_highsec_02'},
            {pos = vector3(-1420.5, -676.88, 26.7605), heading = 356.42, ped = 's_m_m_fiboffice_02'}
        }
    },
    ['requiredItems'] = { -- Add this items to database or shared. Don't change the order, you can change the item names.
        'bag',
        'drill',
        'big_drill',
        'thermite',
        'bolt_cutter'
    },
    ['rewardItems'] = { -- Add this items to database or shared. Don't change the order, you can change the item names. You can add more items for lockboxes.
        {itemName = 'gold', count = 1, sellPrice = 100}, -- For lockboxes.
        {itemName = 'diamond', count = 1, sellPrice = 100}, -- For lockboxes.
    },
    ['rewardMoneys'] = {
        ['stacks'] = function()
            return math.random(50000, 100000) -- Per grab in stacks.
        end,
    },
    ['rewardLockbox'] = function()
        local random = math.random(#Config['BettaHeist']['rewardItems'])
        local lockboxBag = {
            item = Config['BettaHeist']['rewardItems'][random]['itemName'],
            count = math.random(1, 5), -- For lockbox reward items count
        }
        return lockboxBag
    end,
    ['drillTime'] = 30, --Seconds for second door big drill wait time
    ['moneyItem'] = { -- If your server have money item, you can set it here.
        status = false,
        itemName = 'cash'
    },
    ['black_money'] = false, -- If change true, all moneys will convert to black.
    ['finishHeist'] = { -- Heist finish coords.
        buyerPos = vector3(1104.28, -2287.5, 29.1784)
    },
}

Config['BettaSetup'] = {
    ['main'] = vector3(-1220.7, -341.21, 37.7323),
    ['trollys'] = {
        {coords = vector3(-1221.6, -343.99, 36.7322), heading = 343.0, type = 'diamond'},
        {coords = vector3(-1219.5, -342.73, 36.7322), heading = 118.0, type = 'gold'},
    },
    ['actions'] = {
        ['lockbox_1']      =  {coords  = vector3(-1220.7, -341.21, 37.7323), heading = 27.0, length = 1.8,  width = 0.5, debugPoly = false, minZ = 37.2160, maxZ = 38.960, options = {{type = "client", event = "bettaheist:client:actions", icon = "fa-solid fa-hand", label = "Drill lockbox", scene = 'lockbox_1',      job = "all", canInteract = function() return not HeistSync['lockbox_1'] end}},     distance = 1.5},
        ['lockbox_2']      =  {coords  = vector3(-1222.3, -341.22, 37.7403), heading = 117.0, length = 1.8, width = 0.5, debugPoly = false, minZ = 37.2160, maxZ = 38.960, options = {{type = "client", event = "bettaheist:client:actions", icon = "fa-solid fa-hand", label = "Drill lockbox", scene = 'lockbox_2',      job = "all", canInteract = function() return not HeistSync['lockbox_2'] end}},     distance = 1.5},
        ['trolly_1']       =  {coords  = vector3(-1221.6, -343.99, 36.7322), heading = 77.0, length = 1.0,  width = 0.5, debugPoly = false, minZ = 37.2160, maxZ = 38.960, options = {{type = "client", event = "bettaheist:client:actions", icon = "fa-solid fa-hand", label = "Grab trolly",   scene = 'trolly_1',       job = "all", canInteract = function() return not HeistSync['trolly_1'] end}},      distance = 1.5},
        ['trolly_2']       =  {coords  = vector3(-1219.5, -342.73, 36.7322), heading = 27.0, length = 1.0,  width = 0.5, debugPoly = false, minZ = 37.2160, maxZ = 38.960, options = {{type = "client", event = "bettaheist:client:actions", icon = "fa-solid fa-hand", label = "Grab trolly",   scene = 'trolly_2',       job = "all", canInteract = function() return not HeistSync['trolly_2'] end}},      distance = 1.5},
        ['stack']          =  {coords  = vector3(-1218.7, -345.93, 37.7322), heading = 27.0, length = 1.0,  width = 1.0, debugPoly = false, minZ = 37.5160, maxZ = 37.960, options = {{type = "client", event = "bettaheist:client:actions", icon = "fa-solid fa-hand", label = "Grab stack",    scene = 'stack',          job = "all", canInteract = function() return not HeistSync['stack'] end}},         distance = 1.5},
        ['bolt_cutter']    =  {coords  = vector3(-1220.2, -343.99, 37.7322), heading = 27.0, length = 0.2,  width = 0.2, debugPoly = false, minZ = 37.5160, maxZ = 38.160, options = {{type = "client", event = "bettaheist:client:actions", icon = "fa-solid fa-hand", label = "Cut lock",      scene = 'bolt_cutter',    job = "all", canInteract = function() return not HeistSync['bolt_cutter'] end}},   distance = 1.5},
        ['vault_drill']    =  {coords  = vector3(-1223.7, -343.42, 37.7322), heading = 27.0, length = 1.5,  width = 1.0, debugPoly = false, minZ = 36.5160, maxZ = 38.960, options = {{type = "client", event = "bettaheist:client:actions", icon = "fa-solid fa-hand", label = "Place drill",   scene = 'vault_drill',    job = "all", canInteract = function() return not HeistSync['vault_drill'] end}},   distance = 1.5},
        ['enter_thermite'] =  {coords  = vector3(-1230.1, -337.27, 37.6160), heading = 27.0, length = 0.5,  width = 2.0, debugPoly = false, minZ = 36.5160, maxZ = 38.960, options = {{type = "client", event = "bettaheist:client:actions", icon = "fa-solid fa-hand", label = "Plant thermite",scene = 'enter_thermite', job = "all", canInteract = function() return not HeistSync['enter_thermite'] end}},distance = 1.5},
    }
}

policeAlert = function(coords)
    if Config['BettaHeist']["dispatch"] == "default" then
        TriggerServerEvent('bettaheist:server:policeAlert', coords)
    elseif Config['BettaHeist']["dispatch"] == "cd_dispatch" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config["BettaHeist"]['dispatchJobs'], 
            coords = coords,
            title = 'Betta Robbery',
            message = 'A '..data.sex..' robbing a Betta at '..data.street, 
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 431, 
                scale = 1.2, 
                colour = 3,
                flashes = false, 
                text = '911 - Betta Robbery',
                time = 5,
                radius = 0,
            }
        })
    elseif Config['BettaHeist']["dispatch"] == "qs-dispatch" then
        local playerData = exports['qs-dispatch']:GetPlayerInfo()
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = Config["BettaHeist"]['dispatchJobs'],
            callLocation = coords,
            message = " street_1: ".. playerData.street_1.. " street_2: ".. playerData.street_2.. " sex: ".. playerData.sex,
            flashes = false,
            image = image or nil,
            blip = {
                sprite = 431,
                scale = 1.2,
                colour = 3,
                flashes = false,
                text = 'Betta Robbery',
                time = (20 * 1000),     --20 secs
            }
        })
    elseif Config['BettaHeist']["dispatch"] == "ps-dispatch" then
        local dispatchData = {
            message = "Betta Robbery",
            codeName = 'betta',
            code = '10-90',
            icon = 'fas fa-store',
            priority = 2,
            coords = coords,
            gender = IsPedMale(PlayerPedId()) and 'Male' or 'Female',
            street = "Betta",
            camId = nil,
            jobs = Config["BettaHeist"]['dispatchJobs'],
        }
        TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
    elseif Config['BettaHeist']["dispatch"] == "rcore_dispatch" then
        local data = {
            code = '10-64', -- string -> The alert code, can be for example '10-64' or a little bit longer sentence like '10-64 - Shop robbery'
            default_priority = 'high', -- 'low' | 'medium' | 'high' -> The alert priority
            coords = coords, -- vector3 -> The coords of the alert
            job = Config["BettaHeist"]['dispatchJobs'], -- string | table -> The job, for example 'police' or a table {'police', 'ambulance'}
            text = 'Betta Robbery', -- string -> The alert text
            type = 'alerts', -- alerts | shop_robbery | car_robbery | bank_robbery -> The alert type to track stats
            blip_time = 5, -- number (optional) -> The time until the blip fades
            blip = { -- Blip table (optional)
                sprite = 431, -- number -> The blip sprite: Find them here (https://docs.fivem.net/docs/game-references/blips/#blips)
                colour = 3, -- number -> The blip colour: Find them here (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                scale = 1.2, -- number -> The blip scale
                text = 'Betta Robbery', -- number (optional) -> The blip text
                flashes = false, -- boolean (optional) -> Make the blip flash
                radius = 0, -- number (optional) -> Create a radius blip instead of a normal one
            }
        }
        TriggerServerEvent('rcore_dispatch:server:sendAlert', data)
    end
end

Strings = {
    ['betta_blip'] = 'Betta Bank',
    ['heist_info'] = 'Go to the location marked on the GPS.',
    ['heist_info2'] = 'Required things for heist: A lots of bag, drills, thermite and bolt cutter.',
    ['drill_bar'] = 'DRILLING',
    ['wait_nextrob'] = 'You have to wait this long to undress again',
    ['minute'] = 'minute.',
    ['need_this'] = 'You need this: ',
    ['need_police'] = 'Not enough police in the city.',
    ['total_money'] = 'You got this: ',
    ['police_alert'] = 'Betta bank robbery alert! Check your gps.',
    ['not_cop'] = 'You are not cop!',
    ['buyer_blip'] = 'Buyer',
    ['deliver_to_buyer'] = 'Deliver the loot to the buyer. Check gps.',

    ['t_heist'] = 'Betta Bank Heist'
}