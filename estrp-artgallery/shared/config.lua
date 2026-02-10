Config = Config or {}


--#### Minigame difficulties can be changed in client/functions_open.lua

------ / Police Required To Start Robbery
Config.CopsNeeded = 0

Config.PoliceJobs =  {
    'police',
    'sheriff',
 }

Config.Target = "ox" --- ox/qtarget/qb
Config.inventory = "ox" --"ox"/"other"
Config.Lang = 'EN' --- Can be added more from shared/locales.lua
Config.Notifications = 'ox_lib' -- ox_lib or custom

 ---- Cooldown between robberies
 Config.cooldown = 3600 -- 3600 (seconds) = 60 minutes.
 Config.Galleryclean = 55 --- minutes (plus - minus one minute for despawning), set this less than cooldown
 -- untill heist/robbery will be fully resetted
  

 ---## Webhook info
Config.URL = "YOUR-DISCORD-WEBHOOK-URL-HERE"

 Config.durationhacking = 25000 --- Office PC hacking progressbar time
 Config.DrillVitrine = 40000 --- Vault vitrine drilling progressbar time


---## REWARDS ## --- 

------- / Weapons with what you can break the vitrine glass, you can add more if needed

Config.WhitelistedWeapons = {
    [GetHashKey('weapon_assaultrifle')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_carbinerifle')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_pumpshotgun')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_sawnoffshotgun')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_compactrifle')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_microsmg')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_autoshotgun')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_pistol')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_pistol_mk2')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_combatpistol')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_appistol')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_pistol50')] = {
       ["timeOut"] = 10000
   },
    [GetHashKey('weapon_crowbar')] = {
       ["timeOut"] = 10000
   },
}

Config.Fuseboxes = {
    [1] = {
        ['coords'] = vector3(7.25, 135.78, 88.01),
        ['size'] = vector2(0.4, 1.0),
        ['heading'] = 342,
        ['minZ'] = 88.00,
        ['maxZ'] = 90.0,
        ['ScenPosition'] = vector3(-1329.5728759766, -500.74673461914, 32.294807434082),
        artgallery = 1
    }, 
}
Config.Panels = {
    [1] = {
        ['coords'] = vector3(20.43, 153.03, 93.79),
        ['size'] = vector2(0.25, 0.05),
        ['heading'] = 340,
        ['minZ'] = 93.0,
        ['maxZ'] = 93.8,
        artgallery = 1
    },
}

Config.Paintings = {
    [1] = {
        ['coords'] = vector3(23.79, 149.91, 94.19),
        ['size'] = vector2(0.4, 0.85),
        ['heading'] = 340,
        ['minZ'] = 92.6,
        ['maxZ'] = 93.6,
        ['objectname'] = "ch_prop_vault_painting_01i",
        ['objectpos'] = vector3(23.738887786865, 149.79348754883, 94.282035827637),
        ['objectheading'] = vector3(0.0, 0.0, -20.20),
        ["PaintingID"] = "set_painting_1",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    }, 
    [2] = {
        ['coords'] = vector3(23.92, 150.29, 94.19),
        ['size'] = vector2(0.2, 0.85),
        ['heading'] = 340,
        ['minZ'] = 92.6,
        ['maxZ'] = 93.6,
        ['objectname'] = "ch_prop_vault_painting_01f",
        ['objectpos'] = vector3(23.895, 150.237, 94.286),
        ['objectheading'] = vector3(0.0, 0.0, 159.49),
        ["PaintingID"] = "set_painting_2",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [3] = {
        ['coords'] = vector3(21.97, 151.06, 94.19),
        ['size'] = vector2(0.2, 0.85),
        ['heading'] = 340,
        ['minZ'] = 92.6,
        ['maxZ'] = 93.6,
        ['objectname'] = "ch_prop_vault_painting_01a",
        ['objectpos'] = vector3(21.924, 150.954, 93.782),
        ['objectheading'] = vector3(0.0, 0.0, 160.0),
        ["PaintingID"] = "set_painting_3",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [4] = {
        ['coords'] = vector3(20.09, 139.83, 94.19),
        ['size'] = vector2(0.2, 0.85),
        ['heading'] = 340,
        ['minZ'] = 92.6,
        ['maxZ'] = 93.6,
        ['objectname'] = "ch_prop_vault_painting_01j",
        ['objectpos'] = vector3(20.080, 139.846, 94.281),
        ['objectheading'] = vector3(0.0, 0.0, -20.20),
        ["PaintingID"] = "set_painting_4",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [5] = {
        ['coords'] = vector3(37.46, 133.93, 94.19),
        ['size'] = vector2(0.2, 0.85),
        ['heading'] = 340,
        ['minZ'] = 92.6,
        ['maxZ'] = 93.6,
        ['objectname'] = "ch_prop_vault_painting_01b",
        ['objectpos'] = vector3(37.472, 133.943, 94.275),
        ['objectheading'] = vector3(0.0, 0.0, 159.49),
        ["PaintingID"] = "set_painting_5",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [6] = {
        ['coords'] = vector3(41.16, 143.95, 94.19),
        ['size'] = vector2(0.2, 0.85),
        ['heading'] = 340,
        ['minZ'] = 92.6,
        ['maxZ'] = 93.6,
        ['objectname'] = "ch_prop_vault_painting_01d",
        ['objectpos'] = vector3(41.122, 143.886, 94.273),
        ['objectheading'] = vector3(0.0, 0.0, 160.0),
        ["PaintingID"] = "set_painting_6",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [7] = {
        ['coords'] = vector3(18.29, 141.04, 94.19),
        ['size'] = vector2(0.2, 0.85),
        ['heading'] = 340,
        ['minZ'] = 92.6,
        ['maxZ'] = 93.6,
        ['objectname'] = "ch_prop_vault_painting_01g",
        ['objectpos'] = vector3(18.274, 141.017, 94.288),
        ['objectheading'] = vector3(0.0, 0.0, 160.0),
        ["PaintingID"] = "set_painting_7",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [8] = {
        ['coords'] = vector3(39.46, 133.3, 94.19),
        ['size'] = vector2(0.2, 0.85),
        ['heading'] = 340,
        ['minZ'] = 92.6,
        ['maxZ'] = 93.6,
        ['objectname'] = "ch_prop_vault_painting_01c",
        ['objectpos'] = vector3(39.440, 133.221, 94.275),
        ['objectheading'] = vector3(0.0, 0.0, 160.0),
        ["PaintingID"] = "set_painting_8",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [9] = {
        ['coords'] = vector3(39.26, 132.7, 94.19),
        ['size'] = vector2(0.2, 0.85),
        ['heading'] = 340,
        ['minZ'] = 92.6,
        ['maxZ'] = 93.6,
        ['objectname'] = "ch_prop_vault_painting_01h",
        ['objectpos'] = vector3(39.279, 132.785, 94.273),
        ['objectheading'] = vector3(0.0, 0.0, -20.20),
        ["PaintingID"] = "set_painting_9",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [10] = {
        ['coords'] = vector3(40.92, 143.36, 94.19),
        ['size'] = vector2(0.2, 0.85),
        ['heading'] = 340,
        ['minZ'] = 92.6,
        ['maxZ'] = 93.6,
        ['objectname'] = "ch_prop_vault_painting_01h",
        ['objectpos'] = vector3(40.964, 143.454, 94.273),
        ['objectheading'] = vector3(0.0, 0.0, -20.20),
        ["PaintingID"] = "set_painting_10",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
}


Config.VitrineRewards = {
    [1] = {
        ['item'] = 'rolex',
        ['amount'] = {
            ['min'] = 4,
            ['max'] = 7
        },
    },
    [2] = {
        ['item'] = 'ring',
        ['amount'] = {
            ['min'] = 4,
            ['max'] = 7
        },
    },
    [3] = {
        ['item'] = 'necklace',
        ['amount'] = {
            ['min'] = 4,
            ['max'] = 7
        },
    },
    [4] = {
        ['item'] = 'goldbull',
        ['amount'] = {
            ['min'] = 4,
            ['max'] = 7
        },
    },
    [5] = {
    ['item'] = 'rolex',
    ['amount'] = {
        ['min'] = 4,
        ['max'] = 7
},
},
}

------ / Set Location Of Each Vitrine Case

Config.Locations = {
    [1] = {
        ['coords'] = vector3(34.77, 130.68, 92.79),
        ['heading'] = 339.0,
        ['size'] = vector2(0.6, 1.3),
        ["SceneLoc"] = vector3(34.9862, 131.1948, 92.8358),
        ["SceneRot"] = vector3(0.0, 0.0, 157.9415),       
        ['isOpened'] = false,
        ['isBusy'] = false,
    }, 
    [2] = {
        ['coords'] = vector3(36.0, 130.19, 92.79),
        ['heading'] = 339.0,
        ['size'] = vector2(0.6, 1.3),
        ["SceneLoc"] = vector3(36.0995, 130.7617, 92.8358),
        ["SceneRot"] = vector3(0.0, 0.0, 156.1415),         
        ['isOpened'] = false,
        ['isBusy'] = false, 
    },
    [3] = {
        ['coords'] = vector3(35.72, 129.54, 92.79),
        ['heading'] = 339.0,
        ['size'] = vector2(0.6, 1.3),
        ["SceneLoc"] = vector3(35.5163, 128.7556, 92.8358),
        ["SceneRot"] = vector3(0.0, 0.0, 337.5886),       
        ['isOpened'] = false,
        ['isBusy'] = false, 
    },
    [4] = {
        ['coords'] = vector3(34.52, 129.99, 92.79),
        ['heading'] = 339.0,
        ['size'] = vector2(0.6, 1.3),
        ["SceneLoc"] = vector3(34.1889, 129.0864, 92.8358),
        ["SceneRot"] = vector3(0.0, 0.0, 337.1579),       
        ['isOpened'] = false,
        ['isBusy'] = false, 
    },
    [5] = {
        ['coords'] = vector3(41.14, 147.6, 92.79),
        ['heading'] = 340.0,
        ['size'] = vector2(0.6, 1.3),
        ["SceneLoc"] = vector3(40.8866, 147.0817, 92.8305),
        ["SceneRot"] = vector3(0.0, 0.0, 340.5483),       
        ['isOpened'] = false,
        ['isBusy'] = false, 
    },
    [6] = {
        ['coords'] = vector3(42.35, 147.17, 92.79),
        ['heading'] = 340.0,
        ['size'] = vector2(0.6, 1.3),
        ["SceneLoc"] = vector3(42.1677, 146.6835, 92.8305),
        ["SceneRot"] = vector3(0.0, 0.0, 334.4335),       
        ['isOpened'] = false,
        ['isBusy'] = false, 
    },
    [7] = {
        ['coords'] = vector3(42.64, 147.94, 92.79),
        ['heading'] = 340.0,
        ['size'] = vector2(0.6, 1.3),
        ["SceneLoc"] = vector3(42.9707, 148.7317, 92.8305), -- 
        ["SceneRot"] = vector3(0.0, 0.0, 160.8590),       
        ['isOpened'] = false,
        ['isBusy'] = false, 
    },
    [8] = {
        ['coords'] = vector3(41.4, 148.4, 92.79),
        ['heading'] = 340.0,
        ['size'] = vector2(0.6, 1.3),
        ["SceneLoc"] = vector3(41.7831, 149.1397, 92.8305),
        ["SceneRot"] = vector3(0.0, 0.0, 160.8590),       
        ['isOpened'] = false,
        ['isBusy'] = false, 
    },
}

--- Thermal charge planting
Config.ArtThermite = {
    Planting = {
        ['items'] = {
            'hei_p_m_bag_var22_arm_s'
        },
        ['anims'] = {
            {'thermal_charge', 'bag_thermal_charge'}
        },
        ['scenecoords'] = {
        [1] = {
            scene = {pos = vector3(32.733, 135.499, 93.910), 
            rot = vector3(0.0, 0.0, 156.3), 
            ptfx = vector3(32.733, 136.499, 93.910)},
         },
         [2] = {
            scene = {pos = vector3(36.345, 145.328, 93.872), 
            rot = vector3(0.0, 0.0, 338.11), 
            ptfx = vector3(36.345, 146.328, 93.872)},
         },
    },
        ['scenes'] = {},
        ['sceneitems'] = {}
    },
    }
---------------- NOTIFY SECTION CLIENT SIDE ----------------------------------------------
   ---Notifications
   function Notifi(data)
    if Config.Notifications == 'ox_lib' then
        lib.defaultNotify({
            title = Config.title,
            description = data.text or data,
            duration = data.duration or 6000,
            style = {
                backgroundColor = '#292929',
                color = '#c2c2c2',
                ['.description'] = {
                    color = '#cccccc'
                }
            },
            icon = data.icon or 'car',
            iconColor = data.color or '#d46363'
        })
    elseif Config.Notifications == 'custom' then

    end
end

function NotifiServ(src, data)
    if Config.Notifications == 'ox_lib' then
        TriggerClientEvent('ox_lib:notify', src, {
            title = " " or Config.title,
            description = data.text or data,
            duration = 6000,
            style = {
                backgroundColor = '#292929',
                color = '#c2c2c2',
                ['.description'] = {
                    color = '#cccccc'
                }
            },
            icon = data.icon or "car",
            iconColor = data.color or '#d46363'
        })
    elseif Config.Notifications == 'custom' then
    end
end
