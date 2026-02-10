Config = Config or {}


--#### Minigame difficulties can be changed in client/functions_open.lua

------ / Police Required To Start Robbery
Config.CopsNeeded = 0

Config.PoliceJobs =  {
    'police',
    'sheriff',
 }

Config.inventory = "ox" --"ox"/"other"
Config.Target = "ox" -- "ox"/"qtarget"/"qb"
Config.Lang = 'EN' --- Can be added more from shared/locales.lua
Config.Notifications = 'ox_lib' -- ox_lib or esx

 ---- Cooldown between robberies
 Config.cooldown = 3600 -- 3600 (seconds) = 60 minutes.
 Config.Bankclear = 55 --- minutes (plus - minus one minute for despawning), set this less than cooldown
 -- untill heist/robbery will be fully resetted

---### Money types ONLY 1 type  can be active at once ###----
Config.dirty = true --- If turned to true, you will recieve only dirty money
Config.clean = false --- If turned to true you will recieve only clean money


---## Webhook info'

Config.URL = "YOUR-DISCORD-WEBHOOK-URL-HERE"

 --#########OX/QS/QB/OTHER####################################
 Config.Blackmoneytoitem = true --- if set to to false it triggers event (xPlayer.Functions.AddMoney("black_money", reward))
 -- if true  then: (xPlayer.Functions.AddItem(Config.Moneyitem, reward))
 Config.Marked = false -- set this to true only when using 'markedbills'
 Config.Moneyitem = "black_money" --- example item to give, can be changed
 --############################################################

 Config.Trollymin = 13000 --- Minimum amount of cash from Trolley
Config.Trollymax = 20000 --- Maximum amount of cash from Trolley

Config.GoldTrolley = { --- Gold trolleys
    [1] = {
        ['item'] = 'gold_bar',
        ['amount'] = {
            ['min'] = 20,
            ['max'] = 30
        },
},
}

Config.GoldStackMin = 15 --- Minimum amount of cash from Gold Stack
Config.GoldStackMax = 22 --- Maximum amount of cash from Gold Stack

Config.MoneyStackMin = 6000 --- Minimum amount of cash from Money Stack
Config.MoneyStackMax = 9000 --- Maximum amount of cash from Money Stack

Config.MiniSafeMin = 5000 --- Minimum amount of cash from Minisafe
Config.MiniSafeMax = 6000 --- Maximum amount of cash from Minisafe

Config.durationhacking = 25000 --- Office PC hacking progressbar time
Config.DrillVault = 45000 --- Time of drilling big round vault door (MS)


---## REWARDS ## --- 

Config.Fuseboxes = {
    [1] = {
        ['coords'] = vector3(896.81, -0.35, 77.89),
        ['size'] = vector2(0.4, 0.95),
        ['heading'] = 325,
        ['minZ'] = 77.0,
        ['maxZ'] = 79.0,
    }, 
}

Config.Minisafes = {
    [1] = {
        ['coords'] = vector3(930.79, 7.79, 81.12),
        ['size'] = vector2(0.2, 0.6),
        ['heading'] = 328,
        ['minZ'] = 80.9,
        ['maxZ'] = 81.2,
        ['isTaken'] = false,
        ['isBusy'] = false,
    }, 
}

Config.PCS = {
    [1] = {
        ['coords'] = vector3(931.75, 12.08, 80.12),
        ['size'] = vector2(1, 0.6),
        ['heading'] = 328,
        ['minZ'] = 80.9,
        ['maxZ'] = 82.2,
        ['isHacked'] = false,
        ['isBusy'] = false,
    }, 
    [2] = {
        ['coords'] = vector3(948.84, 36.92, 71.81),
        ['size'] = vector2(0.4, 1),
        ['heading'] = 328,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['isHacked'] = false,
        ['isBusy'] = false,
    }, 
    [3] = {
        ['coords'] = vector3(938.65, 24.96, 77.8),
        ['size'] = vector2(1.0, 0.6),
        ['heading'] = 328,
        ['minZ'] = 77.0,
        ['maxZ'] = 79.0,
        ['isHacked'] = false,
        ['isBusy'] = false,
    }, 
    [4] = {
        ['coords'] = vector3(941.2, 22.14, 77.79),
        ['size'] = vector2(1.0, 0.6),
        ['heading'] = 326,
        ['minZ'] = 77.0,
        ['maxZ'] = 79.0,
        ['isHacked'] = false,
        ['isBusy'] = false,
    }, 
}

Config.SceneStacks = {
    [1] = {
        ['coords'] = vector3(965.6, 25.94, 71.81),
        ['size'] = vector2(0.6, 0.6),
        ['heading'] = 45,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['objectname'] = "h4_prop_h4_gold_stack_01a",
        ['objectpos'] = vector3(965.606, 25.961, 72.712),
        ['objectheading'] = 39.847,
        ['IsTaken'] = false,
        ['isBusy'] = false,
        stack = 1
    }, 
    [2] = {
        ['coords'] = vector3(965.64, 27.23, 71.81),
        ['size'] = vector2(0.6, 0.6),
        ['heading'] = 28,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['objectname'] = "h4_prop_h4_gold_stack_01a",
        ['objectpos'] = vector3(965.630, 27.212, 72.712),
        ['objectheading'] = 118.009,
        ['IsTaken'] = false,
        ['isBusy'] = false,
        stack = 2
    }, 
    [3] = {
        ['coords'] = vector3(964.85, 27.7, 71.81),
        ['size'] = vector2(0.6, 0.6),
        ['heading'] = 10,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['objectname'] = "h4_prop_h4_gold_stack_01a",
        ['objectpos'] = vector3(964.781, 27.666, 72.712),
        ['objectheading'] = -172.668,
        ['IsTaken'] = false,
        ['isBusy'] = false,
        stack = 3
    }, 
    [4] = {
        ['coords'] = vector3(963.75, 26.2, 71.81),
        ['size'] = vector2(1.0, 0.6),
        ['heading'] = 21,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['objectname'] = "h4_prop_h4_cash_stack_01a",
        ['objectpos'] = vector3(963.739, 26.152, 72.713),
        ['objectheading'] = -77.15,
        ['IsTaken'] = false,
        ['isBusy'] = false,
        stack = 4
    },
    [5] = {
        ['coords'] = vector3(964.47, 21.91, 80.01),
        ['size'] = vector2(0.6, 1.0),
        ['heading'] = 329,
        ['minZ'] = 80.0,
        ['maxZ'] = 82.0,
        ['objectname'] = "h4_prop_h4_cash_stack_01a",
        ['objectpos'] = vector3(964.480, 21.917, 80.808),
        ['objectheading'] = 148.726,
        ['IsTaken'] = false,
        ['isBusy'] = false,
        stack = 5
    },
    [6] = {
        ['coords'] = vector3(929.55, 18.28, 80.11),
        ['size'] = vector2(0.65, 1),
        ['heading'] = 329,
        ['minZ'] = 80.0,
        ['maxZ'] = 82.0,
        ['objectname'] = "h4_prop_h4_cash_stack_01a",
        ['objectpos'] = vector3(929.553, 18.257, 81.109),
        ['objectheading'] = -31.729,
        ['IsTaken'] = false,
        ['isBusy'] = false,
        stack = 6
    },
}

Config.Panels = {
    [1] = { --- siseuks
        ['coords'] = vector3(929.87, 33.78, 81.3),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 60,
        ['minZ'] = 80.8,
        ['maxZ'] = 81.2,
        ['prop'] = "ch_prop_fingerprint_scanner_01a",
    },
    [2] = { -- uks bossi kabinetti
        ['coords'] = vector3(922.99, 19.76, 81.3),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 60,
        ['minZ'] = 80.8,
        ['maxZ'] = 81.2,
        ['prop'] = "ch_prop_fingerprint_scanner_01a",
    },
    [3] = { --- uks valvuri kabinetti
        ['coords'] = vector3(938.99, 27.31, 78.8),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 330,
        ['minZ'] = 78.0,
        ['maxZ'] = 78.8,
        ['prop'] = "ch_prop_fingerprint_scanner_01b",
    },
    [4] = {
        ['coords'] = vector3(946.22, 11.23, 78.79),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 60,
        ['minZ'] = 78.0,
        ['maxZ'] = 78.8,
        ['prop'] = "ch_prop_fingerprint_scanner_01a",
    },
    [5] = {
        ['coords'] = vector3(944.14, 25.06, 78.8),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 330,
        ['minZ'] = 78.0,
        ['maxZ'] = 78.8,
        ['prop'] = "ch_prop_fingerprint_scanner_01b",
    },
    [6] = {
        ['coords'] = vector3(957.45, 26.04, 81.3),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 60,
        ['minZ'] = 80.9,
        ['maxZ'] = 81.2,
        ['prop'] = "ch_prop_fingerprint_scanner_01a",
    },
    [7] = {
        ['coords'] = vector3(952.56, 37.13, 72.81),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 60,
        ['minZ'] = 72.2,
        ['maxZ'] = 72.9,
        ['prop'] = "ch_prop_fingerprint_scanner_01b",
    },
    [8] = {
        ['coords'] = vector3(948.17, 30.2, 72.81),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 60,
        ['minZ'] = 72.2,
        ['maxZ'] = 72.9,
        ['prop'] = "ch_prop_fingerprint_scanner_01b",
    },
    [9] = {
        ['coords'] = vector3(953.88, 36.27, 72.81),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 60,
        ['minZ'] = 72.2,
        ['maxZ'] = 72.9,
        ['prop'] = "ch_prop_fingerprint_scanner_01c",
    },
    [10] = {
        ['coords'] = vector3(950.7, 12.97, 78.79),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 330,
        ['minZ'] = 78.0,
        ['maxZ'] = 78.8,
        ['prop'] = "ch_prop_fingerprint_scanner_01c",
    },
    [11] = {
        ['coords'] = vector3(970.13, 21.43, 72.81),
        ['size'] = vector2(0.25, 0.07),
        ['heading'] = 330,
        ['minZ'] = 72.2,
        ['maxZ'] = 72.9,
        ['prop'] = "ch_prop_fingerprint_scanner_01d",
    },
}

Config.GoldTrolleys = {
    [1] = {
        ['coords'] = vector3(953.88, 18.66, 71.81),
        ['size'] = vector2(0.6, 1.0),
        ['heading'] = 300,
        ['minZ'] = 72.0,
        ['maxZ'] = 74.0,
        ['isTaken'] = false,
        ['isBusy'] = false, 
    },
    [2] = {
        ['coords'] = vector3(953.22, 19.9, 71.81),
        ['size'] = vector2(0.6, 1.0),
        ['heading'] = 300,
        ['minZ'] = 72.0,
        ['maxZ'] = 74.0,
        ['isTaken'] = false,
        ['isBusy'] = false, 
    },
    [3] = {
        ['coords'] = vector3(952.57, 21.14, 71.81),
        ['size'] = vector2(0.6, 1.0),
        ['heading'] = 300,
        ['minZ'] = 72.0,
        ['maxZ'] = 74.0,
        ['isTaken'] = false,
        ['isBusy'] = false, 
    },
    [4] = {
        ['coords'] = vector3(951.92, 22.35, 71.81),
        ['size'] = vector2(0.6, 1.0),
        ['heading'] = 300,
        ['minZ'] = 72.0,
        ['maxZ'] = 74.0,
        ['isTaken'] = false,
        ['isBusy'] = false, 
    },
}

Config.CashTrolleys = {
    [1] = {
        ['coords'] = vector3(963.07, 39.94, 71.81),
        ['size'] = vector2(0.6, 1.0),
        ['heading'] = 358,
        ['minZ'] = 72.0,
        ['maxZ'] = 74.0,
        ['isTaken'] = false,
        ['isBusy'] = false, 
    },
    [2] = {
        ['coords'] = vector3(964.42, 39.92, 71.81),
        ['size'] = vector2(0.6, 1.0),
        ['heading'] = 358,
        ['minZ'] = 72.0,
        ['maxZ'] = 74.0,
        ['isTaken'] = false,
        ['isBusy'] = false, 
    },
    [3] = {
        ['coords'] = vector3(965.84, 39.89, 71.81),
        ['size'] = vector2(0.6, 1.0),
        ['heading'] = 358,
        ['minZ'] = 72.0,
        ['maxZ'] = 74.0,
        ['isTaken'] = false,
        ['isBusy'] = false, 
    },
    [4] = {
        ['coords'] = vector3(967.22, 39.83, 71.81),
        ['size'] = vector2(0.6, 1.0),
        ['heading'] = 358,
        ['minZ'] = 72.0,
        ['maxZ'] = 74.0,
        ['isTaken'] = false,
        ['isBusy'] = false, 
    },
}

Config.C4placements = {
    [1] = {
        ['coords'] = vector3(958.18, 23.39, 71.81),
        ['size'] = vector2(4.6, 0.4),
        ['heading'] = 27,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['C4Pos'] = vector3(958.18, 23.69, 71.81),
        ['ScenHeading'] = 117.974,
        ['isBlown'] = false,
        ['isBusy'] = false, 
    }, 
    [2] = {
        ['coords'] = vector3(965.66, 19.4, 71.81),
        ['size'] = vector2(4.6, 0.4),
        ['heading'] = 97,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['C4Pos'] = vector3(965.66, 19.6, 71.81),
        ['ScenHeading'] = -167.383,
        ['isBlown'] = false,
        ['isBusy'] = false, 
    }, 
    [3] = {
        ['coords'] = vector3(971.66, 28.95, 71.81),
        ['size'] = vector2(4.6, 0.4),
        ['heading'] = 20,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['C4Pos'] = vector3(971.66, 29.4, 71.81),
        ['ScenHeading'] = -68.175,
        ['isBlown'] = false,
        ['isBusy'] = false, 
    }, 
    [4] = {
        ['coords'] = vector3(964.92, 33.89, 71.81),
        ['size'] = vector2(4.6, 0.4),
        ['heading'] = 267,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['C4Pos'] = vector3(964.92, 34.1, 71.81),
        ['ScenHeading'] = -0.899,
        ['isBlown'] = false,
        ['isBusy'] = false, 
    }, 
}

Config.Paintings = {
    [1] = {
        ['coords'] = vector3(957.79, 19.6, 71.81),
        ['size'] = vector2(0.6, 2.0),
        ['heading'] = 27,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['PaintingObj'] = "ch_prop_vault_painting_01h",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    }, 
    [2] = {
        ['coords'] = vector3(955.68, 18.48, 71.81),
        ['size'] = vector2(0.6, 2.0),
        ['heading'] = 27,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['PaintingObj'] = "ch_prop_vault_painting_01i",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [3] = {
        ['coords'] = vector3(954.99, 24.89, 71.81),
        ['size'] = vector2(0.6, 2.0),
        ['heading'] = 27,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['PaintingObj'] = "ch_prop_vault_painting_01g",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [4] = {
        ['coords'] = vector3(953.02, 23.9, 71.81),
        ['size'] = vector2(0.6, 2.0),
        ['heading'] = 27,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['PaintingObj'] = "ch_prop_vault_painting_01e",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [5] = {
        ['coords'] = vector3(962.0, 36.16, 71.81),
        ['size'] = vector2(0.6, 2.0),
        ['heading'] = 88,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['PaintingObj'] = "ch_prop_vault_painting_01c",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [6] = {
        ['coords'] = vector3(962.09, 38.36, 71.81),
        ['size'] = vector2(0.6, 2.0),
        ['heading'] = 88,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['PaintingObj'] = "ch_prop_vault_painting_01d",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [7] = {
        ['coords'] = vector3(967.99, 36.01, 71.81),
        ['size'] = vector2(0.6, 2.0),
        ['heading'] = 88,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['PaintingObj'] = "ch_prop_vault_painting_01b",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
    [8] = {
        ['coords'] = vector3(968.05, 38.34, 71.81),
        ['size'] = vector2(0.6, 2.0),
        ['heading'] = 88,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['PaintingObj'] = "ch_prop_vault_painting_01a",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    },
}

Config.Lockboxes = {
    [1] = {
        ['coords'] = vector3(970.63, 17.9, 71.81),
        ['size'] = vector2(2.0, 1),
        ['heading'] = 27,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['PaintingObj'] = "ch_prop_ch_sec_cabinet_01a",
        ["rewards"] = {"painting_low", "painting_medium", "painting_high"}, -- chooses one randomly from them
        ['IsTaken'] = false,
        ['isBusy'] = false,
    }, 
}

----- Drilling targets --------
Config.DrillTargets = {
    [1] = {
        ['coords'] = vector3(970.63, 17.9, 71.81),
        ['size'] = vector2(2.0, 1),
        ['heading'] = 8,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(969.8813, 17.8154, 72.8073),
        ['vaultRot'] = vector3(0.0, 0.0, 277.7084),
        ['isOpened'] = false,
        ['isBusy'] = false,
        box = 1
    },
    [2] = {
        ['coords'] = vector3(970.92, 15.47, 71.81),
        ['size'] = vector2(2.0, 1),
        ['heading'] = 8,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(970.1885, 15.4415, 72.8073),
        ['vaultRot'] = vector3(0.0, 0.0, 282.9171),
        ['isOpened'] = false,
        ['isBusy'] = false, 
        box = 1
    },
    [3] = {
        ['coords'] = vector3(968.67, 13.71, 71.81),
        ['size'] = vector2(4.0, 1),
        ['heading'] = 278,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(968.5323, 14.3645, 72.8073),
        ['vaultRot'] = vector3(0.0, 0.0, 189.1752),
        ['isOpened'] = false,
        ['isBusy'] = false, 
        box = 1
    },
    [4] = {
        ['coords'] = vector3(964.21, 13.12, 71.81),
        ['size'] = vector2(4.0, 1),
        ['heading'] = 278,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(964.3112, 13.8077, 72.8073),
        ['vaultRot'] = vector3(0.0, 0.0, 191.2184),
        ['isOpened'] = false,
        ['isBusy'] = false,
        box = 1
    },
    [5] = {
        ['coords'] = vector3(961.6, 14.24, 71.81),
        ['size'] = vector2(2.0, 1),
        ['heading'] = 7,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(962.2878, 14.3993, 72.8073),
        ['vaultRot'] = vector3(0.0, 0.0, 97.120),
        ['isOpened'] = false,
        ['isBusy'] = false,
        box = 1
    },
    [6] = {
        ['coords'] = vector3(961.26, 16.71, 71.81),
        ['size'] = vector2(2.0, 1),
        ['heading'] = 7,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(961.9938, 16.6429, 72.8073),
        ['vaultRot'] = vector3(0.0, 0.0, 94.1413),
        ['isOpened'] = false,
        ['isBusy'] = false,
        box = 1
    },
    -- osaa2
    [7] = {
        ['coords'] = vector3(972.14, 33.97, 71.81),
        ['size'] = vector2(2.0, 1),
        ['heading'] = 288,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(972.2847, 33.3484, 72.8074),
        ['vaultRot'] = vector3(0.0, 0.0, 15.5099),
        ['isOpened'] = false,
        ['isBusy'] = false,
        box = 1
    },
    [8] = {
        ['coords'] = vector3(974.47, 34.83, 71.81),
        ['size'] = vector2(2.0, 1),
        ['heading'] = 288,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(974.5652, 34.0309, 72.8074),
        ['vaultRot'] = vector3(0.0, 0.0, 18.7214),
        ['isOpened'] = false,
        ['isBusy'] = false,
        box = 1
    },
    [9] = {
        ['coords'] = vector3(976.64, 32.95, 71.81),
        ['size'] = vector2(4.0, 1),
        ['heading'] = 19,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(975.9376, 32.5645, 72.8074),
        ['vaultRot'] = vector3(0.0, 0.0, 294.4795),
        ['isOpened'] = false,
        ['isBusy'] = false,
        box = 1
    },
    [10] = {
        ['coords'] = vector3(978.05, 28.73, 71.81),
        ['size'] = vector2(4.0, 1),
        ['heading'] = 19,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(977.3132, 28.4402, 72.8073),
        ['vaultRot'] = vector3(0.0, 0.0, 294.5685),
        ['isOpened'] = false,
        ['isBusy'] = false,
        box = 1
    },
    [11] = {
        ['coords'] = vector3(977.45, 25.92, 71.81),
        ['size'] = vector2(2.0, 1),
        ['heading'] = 290,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(977.1320, 26.5870, 72.8073),
        ['vaultRot'] = vector3(0.0, 0.0, 206.9132),
        ['isOpened'] = false,
        ['isBusy'] = false,
        box = 1
    },
    [12] = {
        ['coords'] = vector3(975.1, 25.17, 71.81),
        ['size'] = vector2(2.0, 1),
        ['heading'] = 290,
        ['minZ'] = 71.0,
        ['maxZ'] = 73.0,
        ['vaultpos'] = vector3(974.9550, 25.9277, 72.8073),
        ['vaultRot'] = vector3(0.0, 0.0, 207.1481),
        ['isOpened'] = false,
        ['isBusy'] = false,
        box = 1
    },
}
----- Drilling target rewards --------
Config.BoxRewards = {
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
    elseif Config.Notifications == 'esx' then
        TriggerEvent('esx:showNotification', data.text, "success", 3000)
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
    elseif Config.Notifications == 'esx' then
        TriggerClientEvent('esx:showNotification', src, data.text, "success", 3000)
    end
end
