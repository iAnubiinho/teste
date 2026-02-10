Config = {}

Config['TrainHeist'] = {
    ['blackMoney'] = false,
    ["dispatch"] = "default", -- cd_dispatch | qs-dispatch | ps-dispatch | rcore_dispatch | default
    ['requiredPoliceCount'] = 0, -- required police count for start heist
    ['dispatchJobs'] = {'police', 'sheriff'},
    ['nextRob'] = 3600, -- seconds for next heist
    ['requiredItems'] = { -- add those to database or shared
        'cutter',
        'bag'
    },
    ['reward'] = {
        itemName = 'gold', -- gold item name
        grabCount = 25, -- gold grab count
        sellPrice = 150 -- buyer sell price
    },
    ['startHeist'] ={ -- heist start coords
        pos = vector3(-687.82, -2417.1, 13.9445),
        peds = {
            {pos = vector3(-686.43, -2417.5, 13.8945), heading = 23.22, ped = 's_m_m_highsec_01'},
            {pos = vector3(-687.82, -2417.1, 13.8945), heading = 320.78, ped = 's_m_m_highsec_02'},
            {pos = vector3(-688.89, -2416.3, 13.8945), heading = 291.42, ped = 's_m_m_fiboffice_02'}
        }
    },
    ['guardPeds'] = { -- guard ped list (you can add new)
            { coords = vector3(2850.67, 4535.49, 45.3924), heading = 270.87, model = 's_m_y_blackops_01'},
            { coords = vector3(2856.28, 4544.12, 45.3354), heading = 177.93, model = 's_m_y_blackops_01'},
            { coords = vector3(2869.90, 4530.26, 47.7877), heading = 354.93, model = 's_m_y_blackops_01'},
            { coords = vector3(2859.08, 4519.85, 47.9145), heading = 177.88, model = 's_m_y_blackops_01'},
            { coords = vector3(2843.78, 4521.66, 47.4138), heading = 268.28, model = 's_m_y_blackops_01'},
            { coords = vector3(2856.90, 4526.85, 48.6552), heading = 268.3, model = 's_m_y_blackops_01'},
            { coords = vector3(2878.67, 4556.77, 48.4119), heading = 359.44, model = 's_m_y_blackops_01'},
            { coords = vector3(2886.69, 4556.21, 48.4262), heading = 265.05, model = 's_m_y_blackops_01'},
    },
    ['finishHeist'] = { -- finish heist coords
        buyerPos = vector3(-1690.6, -916.19, 6.78323)
    },
    ['setupTrain'] = { -- train and containers coords
        pos = vector3(2872.028, 4544.253, 47.758),
        part = vector3(2883.305, 4557.646, 47.758),
        heading = 140.0,
        ['containers'] = {
            {
                pos = vector3(2885.97, 4560.83, 48.0551), 
                heading = 320.0, 
                lock = {pos = vector3(2884.76, 4559.38, 49.22561), taken = false},
                table = vector3(2886.55, 4561.53, 48.23),
                golds = {
                    {pos = vector3(2886.05, 4561.93, 49.14), taken = false},
                    {pos = vector3(2887.05, 4561.13, 49.14), taken = false},
                } 
            },
            {
                pos = vector3(2880.97, 4554.83, 48.0551), 
                heading = 140.0, 
                lock = {pos = vector3(2882.15, 4556.26, 49.22561), taken = false},
                table = vector3(2880.45, 4554.23, 48.23),
                golds = {
                    {pos = vector3(2881.05, 4553.93, 49.14), taken = false},
                    {pos = vector3(2880.25, 4554.63, 49.14), taken = false},
                } 
            }
        }
    }
}

policeAlert = function(coords)
    if Config['TrainHeist']["dispatch"] == "default" then
        TriggerServerEvent('trainheist:server:policeAlert', coords)
    elseif Config['TrainHeist']["dispatch"] == "cd_dispatch" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config["TrainHeist"]['dispatchJobs'], 
            coords = coords,
            title = 'Train Robbery',
            message = 'A '..data.sex..' robbing a Train at '..data.street, 
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 431, 
                scale = 1.2, 
                colour = 3,
                flashes = false, 
                text = '911 - Train Robbery',
                time = 5,
                radius = 0,
            }
        })
    elseif Config['TrainHeist']["dispatch"] == "qs-dispatch" then
        exports['qs-dispatch']:TrainRobbery()
    elseif Config['TrainHeist']["dispatch"] == "ps-dispatch" then
        exports['ps-dispatch']:TrainRobbery()
    elseif Config['TrainHeist']["dispatch"] == "rcore_dispatch" then
        local data = {
            code = '10-64', -- string -> The alert code, can be for example '10-64' or a little bit longer sentence like '10-64 - Shop robbery'
            default_priority = 'high', -- 'low' | 'medium' | 'high' -> The alert priority
            coords = coords, -- vector3 -> The coords of the alert
            job = Config["TrainHeist"]['dispatchJobs'], -- string | table -> The job, for example 'police' or a table {'police', 'ambulance'}
            text = 'Train Robbery', -- string -> The alert text
            type = 'alerts', -- alerts | shop_robbery | car_robbery | bank_robbery -> The alert type to track stats
            blip_time = 5, -- number (optional) -> The time until the blip fades
            blip = { -- Blip table (optional)
                sprite = 431, -- number -> The blip sprite: Find them here (https://docs.fivem.net/docs/game-references/blips/#blips)
                colour = 3, -- number -> The blip colour: Find them here (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                scale = 1.2, -- number -> The blip scale
                text = 'Train Robbery', -- number (optional) -> The blip text
                flashes = false, -- boolean (optional) -> Make the blip flash
                radius = 0, -- number (optional) -> Create a radius blip instead of a normal one
            }
        }
        TriggerServerEvent('rcore_dispatch:server:sendAlert', data)
    end
end

Strings = {
    ['start_heist'] = 'Press ~INPUT_CONTEXT~ to Start Train Heist',
    ['cutting'] = 'Press ~INPUT_CONTEXT~ to cutting',
    ['grab'] = 'Press ~INPUT_CONTEXT~ to grab',
    ['start_heist'] = 'Press ~INPUT_CONTEXT~ to Start Train Heist',
    ['goto_ambush'] = 'Go to ambush point in GPS. Kill the guards, search Merryweather containers and steal golds.',
    ['wait_nextrob'] = 'You have to wait this long to undress again',
    ['minute'] = 'minute.',
    ['ambush_blip'] = 'Amubsh Point',
    ['need_this'] = 'You need this: ',
    ['deliver_to_buyer'] = 'Deliver the loot to the buyer. Check gps.',
    ['buyer_blip'] = 'Buyer',
    ['need_police'] = 'Not enough police in the city.',
    ['total_money'] = 'You got this: ',
    ['police_alert'] = 'Train robbery alert! Check your gps.',
}

--Dont change. Main and required things.
TrainAnimation = {
    ['objects'] = {
        'tr_prop_tr_grinder_01a',
        'ch_p_m_bag_var02_arm_s'
    },
    ['animations'] = {
        {'action', 'action_container', 'action_lock', 'action_angle_grinder', 'action_bag'}
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}

GrabGold = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s'
    },
    ['animations'] = {
        {'enter', 'enter_bag'},
        {'grab', 'grab_bag', 'grab_gold'},
        {'grab_idle', 'grab_idle_bag'},
        {'exit', 'exit_bag'},
    },
    ['scenes'] = {},
    ['scenesObjects'] = {}
}