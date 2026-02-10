--RAINMAD SCRIPTS - discord.gg/rccvdkmA5X - rainmad.tebex.io
Config = {}

Config['UndergroundHeist'] = {
    ['framework'] = {
        name = 'ESX', -- Only ESX or QB.
        scriptName = 'es_extended', -- Framework script name work framework exports. (Example: qb-core or es_extended)
        eventName = 'esx:getSharedObject', -- If your framework using trigger event for shared object, you can set in here.
    },
    ['bagClothesID'] = 45,
    ['buyerFinishScene'] = true,
    ["dispatch"] = "default", -- cd_dispatch | qs-dispatch | ps-dispatch | rcore_dispatch | default
    ['requiredPoliceCount'] = 2, -- required police count for start heist
    ['dispatchJobs'] = {'police', 'sheriff'},
    ['nextRob'] = 7200, -- Seconds for next heist
    ['requiredItems'] = { -- Add this items to database or shared. Don't change the order, you can change the item names
        'drill',
        'bag',
        'c4_bomb',
        'big_bomb',
        'hack_usb'
    },
    ['rewardItems'] = { -- Add this items to database or shared. Don't change the order, you can change the item names. Also dont forget glass cutting and painting item names.(in bottom)
        {itemName = 'weed_pooch', count = 25, sellPrice = 100}, -- for drugs grab
        {itemName = 'coke_pooch', count = 25, sellPrice = 100}, -- for drugs grab
        {itemName = 'virus',      count = 1,  sellPrice = 100}, -- for virus grab
        {itemName = 'gold',       count = 50, sellPrice = 100}, -- for vault stack
        {itemName = 'chest_gold', count = 25, sellPrice = 100}, -- for chests
        {itemName = 'cashbon',    count = 2,  sellPrice = 100}, -- for safecrack
    },
    ['moneyStacksReward'] = 250000, -- Reward from each money stacks
    ['black_money'] = false,  -- If change true, all moneys will convert to black. QBCore users can change itemName
    ['startHeist'] ={ -- Heist start coords
        pos = vector3(497.254, -545.41, 24.7511),
        peds = {
            {pos = vector3(497.377, -544.49, 24.7511), heading = 136.22, ped = 's_m_m_highsec_01'},
            {pos = vector3(497.254, -545.41, 24.7511), heading = 100.78, ped = 's_m_m_highsec_02'},
            {pos = vector3(496.416, -544.71, 24.7511), heading = 180.42, ped = 's_m_m_fiboffice_02'}
        }
    },
    ['finishHeist'] = { -- Heist finish coords
        buyerPos = vector3(729.451, -555.40, 25.5128)
    }
}

Config['UndergroundSetup'] = { -- I just write changeable things, dont change others cuzz fixed with map.
    ['bomb'] = vector3(918.698, -96.274, 25.8521),
    ['drugs'] = {
        { pos = vector3(910.180, -69.386, 25.3859), type = 'coke' },
        { pos = vector3(908.182, -70.970, 25.3859), type = 'weed' },
        { pos = vector3(906.054, -68.993, 25.3859), type = 'coke' },
        { pos = vector3(904.802, -66.561, 25.3859), type = 'weed' },
        { pos = vector3(907.195, -64.926, 25.3859), type = 'coke' },
    },
    ['virus'] = vector3(913.368, -51.289, 25.7015),
    ['safecrack'] = vector3(951.777, -57.657, 25.6324),
    ['plantCell'] = vector3(918.850, -84.848, 25.8908),
    ['vault'] = vector3(942.598, -97.969, 26.2259),
    ['vaultGold'] = vector3(946.140, -93.903, 25.574),
    ['extendedDoors'] = {vector3(946.174, -109.52, 25.7993), vector3(948.547, -107.77, 25.7977)},
    ['moneyStacks'] = { -- You can add new money stacks.
        {scenePos = vector3(968.731, -136.68, 24.82538), sceneRot = vector3(0.0, 0.0, 0.0)},
        {scenePos = vector3(978.096, -130.54, 24.82538), sceneRot = vector3(0.0, 0.0, 40.0)},
        {scenePos = vector3(965.026, -115.81, 24.82538), sceneRot = vector3(0.0, 0.0, 230.0)},
        {scenePos = vector3(997.874, -116.01, 24.82538), sceneRot = vector3(0.0, 0.0, 45.0)},
        {scenePos = vector3(981.545, -90.324, 24.82538), sceneRot = vector3(0.0, 0.0, 220.0)},
        {scenePos = vector3(983.099, -100.18, 24.82538), sceneRot = vector3(0.0, 0.0, 225.0)},
        {scenePos = vector3(984.596, -126.39, 24.82538), sceneRot = vector3(0.0, 0.0, 40.0)},
        {scenePos = vector3(980.140, -117.61, 24.82538), sceneRot = vector3(0.0, 0.0, 40.0)},
    },
    ['chests'] = { -- You can add new chests.
        {scenePos = vector3(989.419, -94.756, 24.8192), sceneRot = vector3(0.0, 0.0, 350.0)},
        {scenePos = vector3(1001.86, -106.92, 24.8192), sceneRot = vector3(0.0, 0.0, 315.0)},
        {scenePos = vector3(996.431, -110.46, 24.8192), sceneRot = vector3(0.0, 0.0, 260.0)},
        {scenePos = vector3(967.358, -113.07, 24.8192), sceneRot = vector3(0.0, 0.0, 20.0)},
        {scenePos = vector3(966.748, -95.998, 24.8192), sceneRot = vector3(0.0, 0.0, 40.0)},
        {scenePos = vector3(982.978, -95.709, 24.8192), sceneRot = vector3(0.0, 0.0, 225.0)},
        {scenePos = vector3(963.860, -122.88, 24.8192), sceneRot = vector3(0.0, 0.0, 2.0)},
    }
}

policeAlert = function(coords)
    if Config['UndergroundHeist']["dispatch"] == "default" then
        TriggerServerEvent('undergroundheist:server:policeAlert', coords)
    elseif Config['UndergroundHeist']["dispatch"] == "cd_dispatch" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config["UndergroundHeist"]['dispatchJobs'], 
            coords = coords,
            title = 'Underground Robbery',
            message = 'A '..data.sex..' robbing a Underground at '..data.street, 
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 431, 
                scale = 1.2, 
                colour = 3,
                flashes = false, 
                text = '911 - Underground Robbery',
                time = 5,
                radius = 0,
            }
        })
    elseif Config['UndergroundHeist']["dispatch"] == "qs-dispatch" then
        exports['qs-dispatch']:UndergroundRobbery()
    elseif Config['UndergroundHeist']["dispatch"] == "ps-dispatch" then
        exports['ps-dispatch']:UndergroundRobbery()
    elseif Config['UndergroundHeist']["dispatch"] == "rcore_dispatch" then
        local data = {
            code = '10-64', -- string -> The alert code, can be for example '10-64' or a little bit longer sentence like '10-64 - Shop robbery'
            default_priority = 'high', -- 'low' | 'medium' | 'high' -> The alert priority
            coords = coords, -- vector3 -> The coords of the alert
            job = Config["UndergroundHeist"]['dispatchJobs'], -- string | table -> The job, for example 'police' or a table {'police', 'ambulance'}
            text = 'Underground Robbery', -- string -> The alert text
            type = 'alerts', -- alerts | shop_robbery | car_robbery | bank_robbery -> The alert type to track stats
            blip_time = 5, -- number (optional) -> The time until the blip fades
            blip = { -- Blip table (optional)
                sprite = 431, -- number -> The blip sprite: Find them here (https://docs.fivem.net/docs/game-references/blips/#blips)
                colour = 3, -- number -> The blip colour: Find them here (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                scale = 1.2, -- number -> The blip scale
                text = 'Underground Robbery', -- number (optional) -> The blip text
                flashes = false, -- boolean (optional) -> Make the blip flash
                radius = 0, -- number (optional) -> Create a radius blip instead of a normal one
            }
        }
        TriggerServerEvent('rcore_dispatch:server:sendAlert', data)
    end
end

Strings = {
    ['e_start'] = 'Press ~INPUT_CONTEXT~ to Start Underground Heist',
    ['start_heist'] = 'Go to Underground Tunnel. Check your gps!',
    ['start_heist2'] = 'Required things for robbery: Hack USB, C4 & Big Bomb, Bag, Drill',
    ['plant_bomb'] = 'Press ~INPUT_CONTEXT~ to plant C4',
    ['plant_bbomb'] = 'Press ~INPUT_CONTEXT~ to plant big bomb',
    ['detonate_bombs'] = 'Press ~INPUT_CONTEXT~ to detonate bombs',
    ['grab1'] = 'Press ~INPUT_CONTEXT~ to grab golds',
    ['grab2'] = 'Press ~INPUT_CONTEXT~ to grab virus',
    ['grab3'] = 'Press ~INPUT_CONTEXT~ to grab drugs',
    ['grab4'] = 'Press ~INPUT_CONTEXT~ to grab moneys',
    ['chests'] = 'Press ~INPUT_CONTEXT~ to open chest',
    ['safecrack'] = 'Press ~INPUT_CONTEXT~ to start safecrack',
    ['hacking'] = 'Press ~INPUT_CONTEXT~ to use hack usb',
    ['drill'] = 'Press ~INPUT_CONTEXT~ to use drill',
    ['wait_nextrob'] = 'You have to wait this long to undress again',
    ['minute'] = 'minute.',
    ['need_this'] = 'You need this: ',
    ['deliver_to_buyer'] = 'Deliver the loot to the buyer. Check gps.',
    ['underground_blip'] = 'Underground Tunnel',
    ['buyer_blip'] = 'Buyer',
    ['need_police'] = 'Not enough police in the city.',
    ['total_money'] = 'You got this: ',
    ['police_alert'] = 'Underground robbery alert! Check your gps.',
    ['not_cop'] = 'You are not cop!',
}