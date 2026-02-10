--RAINMAD SCRIPTS - discord.gg/rccvdkmA5X - rainmad.com
Config = {}

Config['OilRigHeist'] = {
    ['framework'] = {
        name = 'QB', -- Only ESX or QB.
        scriptName = 'qb-core', -- Framework script name work framework exports. (Example: qb-core or es_extended)
        eventName = 'esx:getSharedObject', -- If your framework using trigger event for shared object, you can set in here.
        targetScript = 'qb-target' -- Target script name (qtarget or qb-target or ox_target)
    },
    ["dispatch"] = "default", -- cd_dispatch | qs-dispatch | ps-dispatch | rcore_dispatch | default
    ['requiredPoliceCount'] = 0, -- required police count for start heist
    ['dispatchJobs'] = {'police', 'sheriff'},
    ['requiredItems'] = { -- Add this items to database or shared. Don't change the order, you can change the item names.
        'hack_usb',
    },
    ['nextRob'] = 7200, -- Seconds for next heist
    ['startHeist'] ={ -- Heist start coords
        pos = vector3(346.798, 3405.46, 36.8516),
        peds = {
            {pos = vector3(346.798, 3405.46, 36.8516), heading = 21.85, ped = 's_m_m_highsec_01'},
            {pos = vector3(347.701, 3406.21, 36.4559), heading = 111.78, ped = 's_m_m_highsec_02'},
            {pos = vector3(345.771, 3405.33, 36.4573), heading = 292.42, ped = 's_m_m_fiboffice_02'}
        }
    },
    ['requiredPlayersForHeist'] = 1, -- Required players for start heist.
    ['crateSettings'] = {
        ['crateCount'] = 3, -- Crate with items count for every heist. (Max 10)
        ['crateItems'] = { -- Items for every crate.
            {itemName = 'scrap',   itemCount = function() return math.random(1, 5) end, chance = 90},
            {itemName = 'scrap2',  itemCount = function() return math.random(1, 5) end, chance = 80},
            {itemName = 'scrap3',  itemCount = function() return math.random(1, 5) end, chance = 70},
        },
        ['lootTime'] = 5, -- Seconds
    }
}

Config['OilRigSetup'] = {
    ['middleArea'] = vector3(-2736.2, 6597.84, 29.1568),
    ['guards'] = { 
        ['peds'] = {-- These coords are for guard peds, you can add new guard peds.
            {coords = vector3(-2740.9, 6598.14, 29.6310),  heading = 270.87, model = 'hc_driver'},
            {coords = vector3(-2736.3, 6592.37, 29.6306),  heading = 177.93, model = 'csb_janitor'},
            {coords = vector3(-2729.8, 6597.79, 29.6301),  heading = 354.93, model = 'hc_gunman'},
            {coords = vector3(-2736.7, 6604.00, 29.4214),  heading = 177.88, model = 'hc_driver'},
            {coords = vector3(-2740.2, 6598.62, 25.0534),  heading = 268.28, model = 'csb_janitor'},
            {coords = vector3(-2735.0, 6592.12, 25.0534),  heading = 268.3,  model = 'hc_gunman'},
            {coords = vector3(-2730.2, 6596.66, 25.0534),  heading = 359.44, model = 'csb_janitor'},
            {coords = vector3(-2733.3, 6589.02, 21.5044),  heading = 265.05, model = 'hc_gunman'},
            {coords = vector3(-2727.4, 6596.52, 21.5044),  heading = 174.77, model = 'hc_driver'},
            {coords = vector3(-2727.6, 6606.27, 21.5044),  heading = 180.79, model = 'csb_janitor'},
            {coords = vector3(-2729.6, 6611.07, 15.2254),  heading = 180.79, model = 'csb_janitor'},
            {coords = vector3(-2742.7, 6599.25, 15.2254),  heading = 180.79, model = 'hc_gunman'},
            {coords = vector3(-2744.3, 6586.42, 15.2254),  heading = 180.79, model = 'csb_janitor'},
            {coords = vector3(-2730.9, 6587.61, 15.2254),  heading = 180.79, model = 'csb_janitor'},
            {coords = vector3(-2730.1, 6598.66, 12.2224),  heading = 180.79, model = 'hc_gunman'},
            {coords = vector3(-2731.2, 6618.20, 25.8724),  heading = 180.79, model = 'hc_driver'},
            {coords = vector3(-2736.8, 6617.62, 25.8724),  heading = 180.79, model = 'csb_janitor'},
            {coords = vector3(-2716.8, 6578.35, 29.1484),  heading = 180.79, model = 'hc_gunman'},
            {coords = vector3(-2718.0, 6584.74, 29.1484),  heading = 180.79, model = 'csb_janitor'},
        },
        ['weapons'] = {'WEAPON_PISTOL', 'WEAPON_ASSAULTSMG', 'WEAPON_ASSAULTRIFLE'} -- You can change this.
    },
    ['crates'] = {
        {coords = vector3(-2739.6, 6608.67, 15.0348), heading = 59.0},
        {coords = vector3(-2717.7, 6610.90, 21.7323), heading = 0.0},
        {coords = vector3(-2722.3, 6611.42, 21.7416), heading = 90.0},
        {coords = vector3(-2723.6, 6614.66, 21.7416), heading = 90.0},
        {coords = vector3(-2728.0, 6599.0,  21.7416), heading = 0.0},
        {coords = vector3(-2724.9, 6595.0,  21.7416), heading = 0.0},
        {coords = vector3(-2724.9, 6590.67, 21.9416), heading = 90.0},
        {coords = vector3(-2739.1, 6609.55, 21.7416), heading = 90.0},
        {coords = vector3(-2730.4, 6615.08, 25.9878), heading = 0.0},
        {coords = vector3(-2728.3, 6615.11, 25.9878), heading = 0.0},
    },
    ['laptop'] = {coords = vector3(-2732.5, 6621.41, 25.4206), heading = 0.0}
}

policeAlert = function(coords)
    if Config['OilRigHeist']["dispatch"] == "default" then
        TriggerServerEvent('oilrig:server:policeAlert', coords)
    elseif Config['OilRigHeist']["dispatch"] == "cd_dispatch" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config["OilRigHeist"]['dispatchJobs'], 
            coords = coords,
            title = 'Oil Rig Robbery',
            message = 'A '..data.sex..' robbing a Oil Rig at '..data.street, 
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 431, 
                scale = 1.2, 
                colour = 3,
                flashes = false, 
                text = '911 - Oil Rig Robbery',
                time = 5,
                radius = 0,
            }
        })
    elseif Config['OilRigHeist']["dispatch"] == "qs-dispatch" then
        local playerData = exports['qs-dispatch']:GetPlayerInfo()
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = Config["OilRigHeist"]['dispatchJobs'],
            callLocation = coords,
            message = " street_1: ".. playerData.street_1.. " street_2: ".. playerData.street_2.. " sex: ".. playerData.sex,
            flashes = false,
            image = image or nil,
            blip = {
                sprite = 431,
                scale = 1.2,
                colour = 3,
                flashes = false,
                text = 'Oil Rig Robbery',
                time = (20 * 1000),     --20 secs
            }
        })
    elseif Config['OilRigHeist']["dispatch"] == "ps-dispatch" then
        local dispatchData = {
            message = "Oil Rig Robbery",
            codeName = 'oilrig',
            code = '10-90',
            icon = 'fas fa-store',
            priority = 2,
            coords = coords,
            gender = IsPedMale(PlayerPedId()) and 'Male' or 'Female',
            street = "Oil Rig",
            camId = nil,
            jobs = Config["OilRigHeist"]['dispatchJobs'],
        }
        TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
    elseif Config['OilRigHeist']["dispatch"] == "rcore_dispatch" then
        local data = {
            code = '10-64', -- string -> The alert code, can be for example '10-64' or a little bit longer sentence like '10-64 - Shop robbery'
            default_priority = 'high', -- 'low' | 'medium' | 'high' -> The alert priority
            coords = coords, -- vector3 -> The coords of the alert
            job = Config["OilRigHeist"]['dispatchJobs'], -- string | table -> The job, for example 'police' or a table {'police', 'ambulance'}
            text = 'Oil Rig Robbery', -- string -> The alert text
            type = 'alerts', -- alerts | shop_robbery | car_robbery | bank_robbery -> The alert type to track stats
            blip_time = 5, -- number (optional) -> The time until the blip fades
            blip = { -- Blip table (optional)
                sprite = 431, -- number -> The blip sprite: Find them here (https://docs.fivem.net/docs/game-references/blips/#blips)
                colour = 3, -- number -> The blip colour: Find them here (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                scale = 1.2, -- number -> The blip scale
                text = 'Oil Rig Robbery', -- number (optional) -> The blip text
                flashes = false, -- boolean (optional) -> Make the blip flash
                radius = 0, -- number (optional) -> Create a radius blip instead of a normal one
            }
        }
        TriggerServerEvent('rcore_dispatch:server:sendAlert', data)
    end
end

Strings = {
    ['wait_nextrob'] = 'You have to wait this long to undress again',
    ['minute'] = 'minute.',
    ['need_this'] = 'You need this: ',
    ['need_police'] = 'Not enough police in the city.',
    ['total_money'] = 'You got this: ',
    ['police_alert'] = 'Oil rig robbery alert! Check your gps.',
    ['not_cop'] = 'You are not cop!',
    ['need_people'] = 'Count of people required for heist: ',
    ['oilrig_blip'] = 'Oil Rig',
    ['heist_info'] = 'Go to the location marked on the GPS with your crew. Take plenty of weapons and armor.',
    ['hack_info'] = 'Full boxes marked on GPS.',
    ['looting'] = 'LOOTING',

    --Target labels
    ['t_heist'] = 'Oil Rig Heist',
    ['t_search'] = 'Search Crate',
    ['t_laptop'] = 'Hack Laptop',

    --For minigame
    ['confirm'] = 'Confirm',
    ['change'] = 'Change vertical',
    ['change_slice'] = 'Change slice',
    ['exit'] = 'Exit',
}