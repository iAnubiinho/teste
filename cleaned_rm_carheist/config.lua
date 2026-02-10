--RAINMAD SCRIPTS - discord.gg/rccvdkmA5X - rainmad.tebex.io
Config = {}

Config['CarHeist'] = {
    ['framework'] = {
        name = 'ESX', -- Only ESX or QB.
        scriptName = 'es_extended', -- Framework script name work framework exports. (Example: qb-core or es_extended)
        eventName = 'esx:getSharedObject', -- If your framework using trigger event for shared object, you can set in here.
    },
    ['bagClothesID'] = 45,
    ["dispatch"] = "default", -- cd_dispatch | qs-dispatch | ps-dispatch | rcore_dispatch | default
    ['requiredPoliceCount'] = 0, -- required police count for start heist
    ['dispatchJobs'] = {'police', 'sheriff'},
    ['nextRob'] = 7200, -- Seconds for next heist.
    ['requiredItems'] = { -- Add this items to database or shared. Don't change the order, you can change the item names.
        'bag',
        'laptop_h'
    },
    ['removeLaptopItem'] = false, -- If you change to true, item deleted after every minigame
    ['rewardItems'] = { -- Add this items to database or shared. Don't change the order, you can change the item names.
        {itemName = 'gold',       count = 25, sellPrice = 100}, -- For stacks.
        {itemName = 'coke_pooch', count = 25, sellPrice = 100}, -- For stacks.
        {itemName = 'weed_pooch', count = 25, sellPrice = 100}, -- For stacks.
    },
    ['rewardMoneys'] = {
        ['stacks'] = function()
            return math.random(250000, 350000) -- Per money stacks
        end,
    },
    ['moneyItem'] = { -- If your server have money item, you can set it here.
        status = false,
        itemName = 'cash'
    },
    ['black_money'] = false,  -- If change true, all moneys will convert to black.
    ['startHeist'] ={ -- Heist start coords
        pos = vector3(-1435.9, -868.28, 10.9307),
        peds = {
            {pos = vector3(-1436.8, -867.72, 10.9302), heading = 198.22, ped = 's_m_m_highsec_01'},
            {pos = vector3(-1435.9, -868.28, 10.9307), heading = 119.78, ped = 's_m_m_highsec_02'},
            {pos = vector3(-1436.2, -869.03, 10.9306), heading = 27.42,  ped = 's_m_m_highsec_02'}
        }
    },
    ['finishHeist'] = { -- Heist finish coords.
        buyerPos = vector3(2356.88, 3136.20, 47.2087)
    },
}

Config['CarSetup'] = {
    ['main'] = vector3(-1109.446, -3081.029, 5.3891), -- Main heist coords for some checks.
    ['cars'] = { -- You can add new car.
        {coords = vector3(-1069.7, -3096.2, 13.9444),  heading = 293.29, model = 'osiris',   sellPrice = 120},
        {coords = vector3(-1071.8, -3093.5, 13.9444),  heading = 289.92, model = 'zentorno', sellPrice = 120},
        {coords = vector3(-1073.5, -3090.8, 13.9444),  heading = 287.2,  model = 't20',      sellPrice = 120},
        {coords = vector3(-1074.9, -3088.1, 13.9444),  heading = 285.45, model = 'casco',    sellPrice = 120},

        --Dont change those and order. If you want add new car, add it top.
        {coords = vector3(-1038.50, -3081.543, 14.1635),  heading = 329.9,   model = 'tr2'},
        {coords = vector3(-1034.804, -3074.843, 14.1635), heading = 329.9,   model = 'hauler'},
        {coords = vector3(-1109.446, -3081.029, 5.3891),  heading = 60.1143, model = 'cargoplane'},
    },
    ['tables'] = { -- You can add new table with money/gold stacks.
        {coords = vector3(-1124.5, -3070.5, 15.3375), heading = 60.0, type = 'gold'},
        {coords = vector3(-1122.2, -3075.4, 15.3375), heading = 60.0, type = 'coke'},
        {coords = vector3(-1128.0, -3072.3, 15.3375), heading = 60.0, type = 'weed'},
        {coords = vector3(-1118.1, -3074.0, 15.3375), heading = 60.0, type = 'money'},
    },
    ['moneyStacks'] = { -- You can add new money stacks.
        {scenePos = vector3(-1124.6, -3074.2, 15.3375), sceneRot = vector3(0.0, 0.0, 60.0)},
        {scenePos = vector3(-1126.1, -3073.3, 15.3375), sceneRot = vector3(0.0, 0.0, 60.0)},
        {scenePos = vector3(-1121.1, -3072.4, 15.3375), sceneRot = vector3(0.0, 0.0, 60.0)},
        {scenePos = vector3(-1122.5, -3071.5, 15.3375), sceneRot = vector3(0.0, 0.0, 60.0)},
        {scenePos = vector3(-1119.8, -3076.7, 15.3375), sceneRot = vector3(0.0, 0.0, 60.0)},
    },
    ['guards'] = { 
        ['peds'] = {-- These coords are for guard peds, you can add new guard peds.
            {coords = vector3(-1104.2, -3056.0, 14.7165),  heading = 270.87, model = 's_m_m_highsec_02'},
            {coords = vector3(-1084.5, -3067.2, 14.7166),  heading = 354.93, model = 'ig_fbisuit_01'},
            {coords = vector3(-1084.6, -3091.6, 13.9444),  heading = 268.28, model = 's_m_m_highsec_02'},
            {coords = vector3(-1094.9, -3102.7, 13.9444),  heading = 268.3,  model = 's_m_m_highsec_02'},
            {coords = vector3(-1115.2, -3097.9, 13.9444),  heading = 359.44, model = 'ig_fbisuit_01'},
            {coords = vector3(-1099.8, -3024.3, 13.9449),  heading = 174.77, model = 's_m_m_highsec_02'},
            {coords = vector3(-1087.6, -3020.2, 13.9453),  heading = 180.79, model = 'ig_fbisuit_01'},
            {coords = vector3(-1067.8, -3034.7, 13.9457),  heading = 180.79, model = 'ig_fbisuit_01'},
            {coords = vector3(-1059.2, -3060.8, 13.9845),  heading = 180.79, model = 's_m_m_highsec_02'},
            {coords = vector3(-1051.6, -3081.5, 13.9376),  heading = 180.79, model = 'ig_fbisuit_01'},
            {coords = vector3(-1042.1, -3094.3, 13.9450),  heading = 180.79, model = 's_m_m_highsec_02'},
            {coords = vector3(-1043.0, -3109.2, 13.9444),  heading = 180.79, model = 'ig_fbisuit_01'},
            {coords = vector3(-1050.7, -3107.4, 13.9444),  heading = 180.79, model = 's_m_m_highsec_02'},
        },
        ['weapon'] = 'WEAPON_PISTOL', -- You can change this
    },
    ['dealerScene'] = { -- Dealer scene for heist.
        ['start'] = {coords = vector3(2330.81, 3137.90, 48.1683), heading = 259.0},
        ['cam'] = {coords = vector3(2339.76, 3139.47, 49.6085), rotation = vector3(-20.0, 0.0, 170.0)},
        ['finish'] = vector3(2350.62, 3134.56, 47.6018),
    }
}

policeAlert = function(coords)
    if Config['CarHeist']["dispatch"] == "default" then
        TriggerServerEvent('carheist:server:policeAlert', coords)
    elseif Config['CarHeist']["dispatch"] == "cd_dispatch" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config["CarHeist"]['dispatchJobs'], 
            coords = coords,
            title = 'Vehicle Robbery',
            message = 'A '..data.sex..' robbing a Vehicle at '..data.street, 
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 431, 
                scale = 1.2, 
                colour = 3,
                flashes = false, 
                text = '911 - Vehicle Robbery',
                time = 5,
                radius = 0,
            }
        })
    elseif Config['CarHeist']["dispatch"] == "qs-dispatch" then
        local playerData = exports['qs-dispatch']:GetPlayerInfo()
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = Config["CarHeist"]['dispatchJobs'],
            callLocation = coords,
            message = " street_1: ".. playerData.street_1.. " street_2: ".. playerData.street_2.. " sex: ".. playerData.sex,
            flashes = false,
            image = image or nil,
            blip = {
                sprite = 431,
                scale = 1.2,
                colour = 3,
                flashes = false,
                text = 'Vehicle Robbery',
                time = (20 * 1000),     --20 secs
            }
        })
    elseif Config['CarHeist']["dispatch"] == "ps-dispatch" then
        local dispatchData = {
            message = "Vehicle Robbery",
            codeName = 'vehicle',
            code = '10-90',
            icon = 'fas fa-store',
            priority = 2,
            coords = coords,
            gender = IsPedMale(PlayerPedId()) and 'Male' or 'Female',
            street = "Vehicle",
            camId = nil,
            jobs = Config["CarHeist"]['dispatchJobs'],
        }
        TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
    elseif Config['CarHeist']["dispatch"] == "rcore_dispatch" then
        local data = {
            code = '10-64', -- string -> The alert code, can be for example '10-64' or a little bit longer sentence like '10-64 - Shop robbery'
            default_priority = 'high', -- 'low' | 'medium' | 'high' -> The alert priority
            coords = coords, -- vector3 -> The coords of the alert
            job = Config["CarHeist"]['dispatchJobs'], -- string | table -> The job, for example 'police' or a table {'police', 'ambulance'}
            text = 'Vehicle Robbery', -- string -> The alert text
            type = 'alerts', -- alerts | shop_robbery | car_robbery | bank_robbery -> The alert type to track stats
            blip_time = 5, -- number (optional) -> The time until the blip fades
            blip = { -- Blip table (optional)
                sprite = 431, -- number -> The blip sprite: Find them here (https://docs.fivem.net/docs/game-references/blips/#blips)
                colour = 3, -- number -> The blip colour: Find them here (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                scale = 1.2, -- number -> The blip scale
                text = 'Vehicle Robbery', -- number (optional) -> The blip text
                flashes = false, -- boolean (optional) -> Make the blip flash
                radius = 0, -- number (optional) -> Create a radius blip instead of a normal one
            }
        }
        TriggerServerEvent('rcore_dispatch:server:sendAlert', data)
    end
end

Strings = {
    ['e_start'] = 'Press ~INPUT_CONTEXT~ to Start Deluxe Car Heist',
    ['start_heist'] = 'Go to Airport. Check your gps!',
    ['start_heist2'] = 'Required things for robbery: A lots of guns, bags and laptop.',
    ['airport_blip'] = 'Airport',
    ['hack_car'] = 'Press ~INPUT_CONTEXT~ to hack the ',
    ['grab_stack'] = 'Press ~INPUT_CONTEXT~ to grab stack',
    ['grab_money'] = 'Press ~INPUT_CONTEXT~ to grab money stacks',
    ['wait_nextrob'] = 'You have to wait this long to undress again',
    ['minute'] = 'minute.',
    ['need_this'] = 'You need this: ',
    ['need_police'] = 'Not enough police in the city.',
    ['total_money'] = 'You got this: ',
    ['police_alert'] = 'Car robbery alert! Check your gps.',
    ['not_cop'] = 'You are not cop!',
    ['buyer_blip'] = 'Buyer',
    ['deliver_to_buyer_with_car'] = 'Deliver the loot to the buyer with car. Check gps.',
    ['deliver_to_buyer'] = 'Deliver the loot to the buyer. Check gps.',

    --Minigame
    ['change'] = 'Change horizontal',
    ['change2'] = 'Change vertical',
    ['exit'] = 'Exit'
}