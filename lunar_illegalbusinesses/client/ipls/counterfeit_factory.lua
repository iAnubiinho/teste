-- Counterfeit Factory IPL Configuration and Management

-- Animation Scenes Configuration
animationScenes = {}

-- Scene 1: Note Counting
animationScenes[1] = {
    dict = "anim@amb@business@cfm@cfm_counting_notes@",
    coords = vector4(1116.7051, -3195.3613, -40.4024, 88.6657),
    offset = vector4(0.95, -0.2, 0.6, 0.0),
    peds = {
        {
            model = -1215761931,
            disableRandomize = true,
            clip = "note_counting_v2_counter",
            altCoords = vector4(1123.0856, -3194.3879, -40.398, 186.7629)
        }
    },
    props = {
        { model = 52281862, clip = "note_counting_v2_binmoney" },
        { model = -118346868, clip = "note_counting_v2_moneybin" },
        { model = 1083820116, clip = "note_counting_v2_moneyunsorted" },
        { model = 1083820116, clip = "note_counting_v2_moneyunsorted^1" },
        { model = 1282927707, clip = "note_counting_v2_moneywrap" },
        { model = 1282927707, clip = "note_counting_v2_moneywrap^1" }
    }
}

-- Scene 2: Note Counting (High Employees)
animationScenes[2] = {
    dict = "anim@amb@business@cfm@cfm_counting_notes@",
    coords = vector4(1116.7051, -3196.6913, -40.4024, 88.6657),
    offset = vector4(0.95, -0.2, 0.6, 0.0),
    employees = "high",
    peds = {
        {
            model = -1739208332,
            disableRandomize = true,
            clip = "note_counting_v2_counter"
        }
    },
    props = {
        { model = 52281862, clip = "note_counting_v2_binmoney" },
        { model = -118346868, clip = "note_counting_v2_moneybin" },
        { model = 1083820116, clip = "note_counting_v2_moneyunsorted" },
        { model = 1083820116, clip = "note_counting_v2_moneyunsorted^1" },
        { model = 1282927707, clip = "note_counting_v2_moneywrap" },
        { model = 1282927707, clip = "note_counting_v2_moneywrap^1" }
    }
}

-- Scene 3: Cut Sheets
animationScenes[3] = {
    dict = "anim@amb@business@cfm@cfm_cut_sheets@",
    coords = vector4(1122.6201, -3197.7908, -40.3934, 180.0),
    offset = vector4(2.45, 0.75, 0.6, 0.0),
    peds = {
        {
            model = -1739208332,
            disableRandomize = true,
            clip = "extended_load_tune_cut_billcutter",
            altCoords = vector4(1121.0485, -3193.6152, -40.3933, 189.2067)
        }
    },
    props = {
        { model = 1731949568, clip = "extended_load_tune_cut_papercutter" },
        { model = 885753672, clip = "extended_load_tune_cut_singlemoneypage" },
        { model = 885753672, clip = "extended_load_tune_cut_singlemoneypage^1" },
        { model = 885753672, clip = "extended_load_tune_cut_singlemoneypage^2" },
        { model = -296547884, clip = "extended_load_tune_cut_table" },
        { model = -375371546, clip = "extended_load_tune_cut_moneystack" },
        { model = 483949139, clip = "extended_load_tune_cut_singlemoneystrip" },
        { model = 483949139, clip = "extended_load_tune_cut_singlemoneystrip^1" },
        { model = 483949139, clip = "extended_load_tune_cut_singlemoneystrip^2" },
        { model = 483949139, clip = "extended_load_tune_cut_singlemoneystrip^3" },
        { model = 483949139, clip = "extended_load_tune_cut_singlemoneystrip^4" },
        { model = -1344409422, clip = "extended_load_tune_cut_singlestack" }
    }
}

-- Scene 4: Drying Notes Loading
animationScenes[4] = {
    dict = "anim@amb@business@cfm@cfm_drying_notes@",
    coords = vector4(1122.3519, -3194.405, -40.3981, 358.754),
    offset = vector4(-0.2, 0.0, 0.0, -90.0),
    peds = {
        {
            model = -1739208332,
            disableRandomize = true,
            clip = "loading_v2_worker",
            altCoords = vector4(1123.4175, -3197.7866, -40.3935, 1.71)
        }
    },
    props = {
        { model = 1405511860, clip = "loading_v2_bucket" },
        { model = 1083820116, clip = "loading_v2_money01" },
        { model = 1083820116, clip = "loading_v2_money01^1" }
    }
}

-- Scene 5: Drying Notes Loading (High Employees)
animationScenes[5] = {
    dict = "anim@amb@business@cfm@cfm_drying_notes@",
    coords = vector4(1125.4801, -3194.2327, -40.397, 4.5139),
    offset = vector4(-0.2, 0.0, 0.0, -90.0),
    employees = "high",
    peds = {
        {
            model = -1215761931,
            disableRandomize = true,
            clip = "loading_v2_worker",
            altCoords = vector4(1121.0221, -3197.8447, -40.3933, 0.4157)
        }
    },
    props = {
        { model = 1405511860, clip = "loading_v2_bucket" },
        { model = 1083820116, clip = "loading_v2_money01" },
        { model = 1083820116, clip = "loading_v2_money01^1" }
    }
}

-- Scene 6: Inspector (High Employees)
animationScenes[6] = {
    dict = "anim@amb@business@bgen@bgen_inspecting@",
    coords = vector4(1117.2291, -3194.2756, -40.3973, 120.4237),
    offset = vector4(0.0, 0.0, 0.0, 0.0),
    employees = "high",
    peds = {
        {
            model = -1739208332,
            variant = 1,
            disableRandomize = true,
            clip = "inspecting_high_idle_01_inspector"
        }
    },
    props = {
        { model = -297480469, clip = "inspecting_high_idle_01_clipboard" },
        { model = 463086472, clip = "inspecting_high_idle_01_pencil" }
    }
}

-- Scene 7: Machine Oversee
animationScenes[7] = {
    dict = "anim@amb@business@cfm@cfm_machine_oversee@",
    coords = vector4(1128.4572, -3197.386, -39.3989, 174.6806),
    offset = vector4(-0.9, 1.0, 1.275, 0.0),
    peds = {
        {
            model = -1739208332,
            disableRandomize = true,
            clip = "button_press_operator",
            altCoords = vector4(1133.5903, -3197.2705, -39.6657, 0.0836)
        }
    },
    props = {
        { model = 937910157, clip = "button_press_scrunchedmoney" },
        { model = 937910157, clip = "button_press_scrunchedmoney^1" },
        { model = 937910157, clip = "button_press_scrunchedmoney^2" },
        { model = 937910157, clip = "button_press_scrunchedmoney^3" },
        { model = 937910157, clip = "button_press_scrunchedmoney^4" },
        { model = 937910157, clip = "button_press_scrunchedmoney^5" }
    }
}

-- Scene 8: Machine Oversee (High Employees)
animationScenes[8] = {
    dict = "anim@amb@business@cfm@cfm_machine_oversee@",
    coords = vector4(1132.9867, -3197.286, -39.3989, 182.0007),
    offset = vector4(-0.9, 1.0, 1.275, 0.0),
    employees = "high",
    peds = {
        {
            model = -1739208332,
            disableRandomize = true,
            clip = "button_press_operator",
            altCoords = vector4(1129.2527, -3197.2734, -39.6657, 1.5941)
        }
    },
    props = {
        { model = 937910157, clip = "button_press_scrunchedmoney" },
        { model = 937910157, clip = "button_press_scrunchedmoney^1" },
        { model = 937910157, clip = "button_press_scrunchedmoney^2" },
        { model = 937910157, clip = "button_press_scrunchedmoney^3" }
    }
}

-- Debug Commands
RegisterCommand("playcf", function()
    Scenes.play(animationScenes)
end)

RegisterCommand("stopcf", function()
    Scenes.stop()
    ClearPedTasksImmediately(cache.ped)
end)

-- Product Spawn Positions (shelf positions for counterfeit money)
productSpawnPositions = {
    vector4(1117.0159, -3193.4155, -40.2, 180.0),
    vector4(1117.0159, -3193.4155, -40.125, 180.0),
    vector4(1117.0159, -3193.4155, -40.05, 180.0),
    vector4(1117.0159, -3193.4155, -39.975, 180.0),
    vector4(1118.0159, -3193.4155, -40.2, 180.0),
    vector4(1118.0159, -3193.4155, -40.125, 180.0),
    vector4(1118.0159, -3193.4155, -40.05, 180.0),
    vector4(1118.0159, -3193.4155, -39.975, 180.0),
    vector4(1119.0159, -3193.4155, -40.2, 180.0),
    vector4(1119.0159, -3193.4155, -40.125, 180.0),
    vector4(1119.0159, -3193.4155, -40.05, 180.0),
    vector4(1119.0159, -3193.4155, -39.975, 180.0),
    vector4(1120.0159, -3193.4155, -40.2, 180.0),
    vector4(1120.0159, -3193.4155, -40.125, 180.0),
    vector4(1120.0159, -3193.4155, -40.05, 180.0),
    vector4(1120.0159, -3193.4155, -39.975, 180.0)
}

-- Pallet spawn positions
palletSpawnPositions = {
    vector4(1117.0159, -3193.4155, -40.392, 180.0),
    vector4(1118.0159, -3193.4155, -40.392, 180.0),
    vector4(1119.0159, -3193.4155, -40.392, 180.0),
    vector4(1120.0159, -3193.4155, -40.392, 180.0)
}

-- Active Props Storage
activeProps = {}
activePallets = {}

-- Product prop model for counterfeit products
PRODUCT_PROP_MODEL = 238227343
PALLET_PROP_MODEL = 1360148151

-- Debug command to create counterfeit products
RegisterCommand("createcf", function()
    -- Clear existing product props
    for i = 1, #activeProps do
        activeProps[i].remove()
    end
    for i = 1, #activePallets do
        activePallets[i].remove()
    end
    table.wipe(activeProps)
    table.wipe(activePallets)
    
    -- Create pallets
    for _, position in pairs(palletSpawnPositions) do
        activePallets[#activePallets + 1] = Utils.createProp(position, {
            model = PALLET_PROP_MODEL,
            offset = vector3(0.0, 0.0, -1.0)
        })
    end
    
    -- Create products
    for i = 1, #productSpawnPositions do
        local position = productSpawnPositions[i]
        activeProps[#activeProps + 1] = Utils.createProp(position, {
            model = PRODUCT_PROP_MODEL,
            offset = vector3(0.0, 0.0, -1.0)
        })
        Wait(300)
    end
end)

-- Creates product props based on percentage
function CreateProductProps(productPercentage)
    local propCount = math.floor(#productSpawnPositions * productPercentage / 100)
    
    for i = 1, propCount do
        local position = productSpawnPositions[i]
        activeProps[#activeProps + 1] = Utils.createProp(position, {
            model = PRODUCT_PROP_MODEL,
            offset = vector3(0.0, 0.0, -1.0)
        })
    end
end

-- Creates pallet props
function CreatePalletProps()
    for _, position in pairs(palletSpawnPositions) do
        activePallets[#activePallets + 1] = Utils.createProp(position, {
            model = PALLET_PROP_MODEL,
            offset = vector3(0.0, 0.0, -1.0)
        })
    end
end

-- Clears all active props
function ClearActiveProps()
    for i = 1, #activeProps do
        activeProps[i].remove()
    end
    for i = 1, #activePallets do
        activePallets[i].remove()
    end
    table.wipe(activeProps)
    table.wipe(activePallets)
end

-- Gets printer style based on equipment level and supplies
function GetPrinterStyle(equipmentLevel, hasNoSupplies)
    if equipmentLevel == "none" then
        return "empty"
    elseif equipmentLevel == "low" then
        return hasNoSupplies and "basic" or "basicProd"
    elseif equipmentLevel == "high" then
        return hasNoSupplies and "upgrade" or "upgradeProd"
    end
    return "empty"
end

-- IPL Functions Table
IPLs.counterfeit_factory = {}

function IPLs.counterfeit_factory.load(businessData, additionalData)
    local counterfeitFactory = exports.bob74_ipl:GetBikerCounterfeitObject()
    local hasNoSupplies = businessData.supplies == 0
    local printerStyle = GetPrinterStyle(businessData.equipment, hasNoSupplies)
    
    -- Set printer style
    counterfeitFactory.Printer.Set(counterfeitFactory.Printer[printerStyle])
    
    -- Configure dryers
    local dryer1State = hasNoSupplies and counterfeitFactory.Dryer1.off or counterfeitFactory.Dryer1.open
    counterfeitFactory.Dryer1.Set(dryer1State)
    
    local dryer2State = hasNoSupplies and counterfeitFactory.Dryer2.off or counterfeitFactory.Dryer2.on
    counterfeitFactory.Dryer2.Set(dryer2State)
    
    local dryer3State = counterfeitFactory.Dryer3.on
    if businessData.employees == "high" and counterfeitFactory.Dryer3.open then
        dryer3State = counterfeitFactory.Dryer3.open
    end
    if hasNoSupplies then
        dryer3State = counterfeitFactory.Dryer3.off
    end
    counterfeitFactory.Dryer3.Set(dryer3State)
    
    local dryer4State = hasNoSupplies and counterfeitFactory.Dryer4.off or counterfeitFactory.Dryer4.on
    counterfeitFactory.Dryer4.Set(dryer4State)
    
    -- Set security level
    local securityLevel = counterfeitFactory.Security.basic
    if businessData.security and counterfeitFactory.Security.upgrade then
        securityLevel = counterfeitFactory.Security.upgrade
    end
    counterfeitFactory.Security.Set(securityLevel)
    
    -- Configure interior details
    counterfeitFactory.Details.Enable(counterfeitFactory.Details.chairs, true)
    counterfeitFactory.Details.Enable(counterfeitFactory.Details.cutter, hasNoSupplies)
    counterfeitFactory.Details.Enable(counterfeitFactory.Details.furnitures, true)
    counterfeitFactory.Details.Enable(counterfeitFactory.Details.Cash100, not hasNoSupplies)
    
    RefreshInterior(counterfeitFactory.interiorId)
    
    -- Create pallet props
    CreatePalletProps()
    
    -- Create product props based on stored products
    CreateProductProps(businessData.products)
    
    -- Play employee animation scenes
    if businessData.employees ~= "none" then
        Scenes.play(animationScenes, businessData, additionalData)
    end
end

function IPLs.counterfeit_factory.unload()
    local counterfeitFactory = exports.bob74_ipl:GetBikerCounterfeitObject()
    
    -- Load default configuration
    counterfeitFactory.LoadDefault()
    
    RefreshInterior(counterfeitFactory.interiorId)
    
    -- Clear all active props
    ClearActiveProps()
    
    -- Stop animation scenes
    Scenes.stop()
end

function IPLs.counterfeit_factory.softReload(businessData)
    if not businessData then return end
    
    -- Clear existing product props only (keep pallets)
    for i = 1, #activeProps do
        activeProps[i].remove()
    end
    table.wipe(activeProps)
    
    -- Create new props based on current product level
    for i = 1, #productSpawnPositions do
        local position = productSpawnPositions[i]
        activeProps[#activeProps + 1] = Utils.createProp(position, {
            model = PRODUCT_PROP_MODEL,
            offset = vector3(0.0, 0.0, -1.0)
        })
    end
end