-- Meth Lab IPL Configuration and Management

-- Animation Scenes Configuration
animationScenes = {}

-- Scene 1: Smash Weight Check
animationScenes[1] = {
    coords = vector4(1008.734, -3196.646, -39.99, 1.08),
    offset = vector4(0.0, 0.0, 0.0, 0.0),
    dict = "anim@amb@business@meth@meth_smash_weight_check@",
    peds = {
        {
            model = -306958529,
            disableRandomize = true,
            clip = "break_weigh_v3_char01",
            altCoords = vector4(1012.2165, -3194.8767, -38.9931, 182.4785)
        },
        {
            model = -760054079,
            disableRandomize = true,
            clip = "break_weigh_v3_char02",
            altCoords = vector4(1014.3579, -3194.8804, -38.9931, 182.4785)
        }
    },
    props = {
        { model = 64104227, clip = "break_weigh_v3_hammer" },
        { model = 1096651036, clip = "break_weigh_v3_tray01" },
        { model = -1241955389, clip = "break_weigh_v3_tray01^1" },
        { model = -1241955389, clip = "break_weigh_v3_tray01^2" },
        { model = 1096651036, clip = "break_weigh_v3_tray01^3" },
        { model = 1096651036, clip = "break_weigh_v3_tray01^4" },
        { model = 125438837, clip = "break_weigh_v3_box01" },
        { model = -1690030145, clip = "break_weigh_v3_box01^1" },
        { model = 16180688, clip = "break_weigh_v3_methbag01" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^1" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^2" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^3" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^4" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^5" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^6" },
        { model = 1136664310, clip = "break_weigh_v3_scoop" },
        { model = -1928194470, clip = "break_weigh_v3_scale" },
        { model = -1814932629, clip = "break_weigh_v3_pen" },
        { model = -297480469, clip = "break_weigh_v3_clipboard" },
        { model = -1241955389, clip = "break_weigh_v3_tray01^5" }
    }
}

-- Scene 2: Smash Weight Check (High Employees)
animationScenes[2] = {
    coords = vector4(1016.5746, -3194.9028, -38.9931, 0.0),
    offset = vector4(5.0, 1.6, 1.0, 0.0),
    dict = "anim@amb@business@meth@meth_smash_weight_check@",
    employees = "high",
    peds = {
        {
            model = -306958529,
            disableRandomize = true,
            clip = "break_weigh_v3_char01",
            altCoords = vector4(998.697, -3198.8135, -38.9931, 249.8565)
        }
    },
    props = {
        { model = 125438837, clip = "break_weigh_v3_box01" },
        { model = -1690030145, clip = "break_weigh_v3_box01^1" },
        { model = 16180688, clip = "break_weigh_v3_methbag01" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^1" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^2" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^3" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^4" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^5" },
        { model = 16180688, clip = "break_weigh_v3_methbag01^6" },
        { model = 1136664310, clip = "break_weigh_v3_scoop" },
        { model = -1928194470, clip = "break_weigh_v3_scale" },
        { model = -1814932629, clip = "break_weigh_v3_pen" },
        { model = -297480469, clip = "break_weigh_v3_clipboard" }
    }
}

-- Scene 3: Monitoring Cooking
animationScenes[3] = {
    coords = vector4(1008.734, -3196.646, -39.99, 1.08),
    offset = vector4(-2.0, 1.7, -1.08, 0.0),
    dict = "anim@amb@business@meth@meth_monitoring_cooking@cooking@",
    peds = {
        {
            model = -306958529,
            disableRandomize = true,
            clip = "chemical_pour_long_cooker",
            altCoords = vector4(997.9585, -3200.2295, -38.9932, 276.9833)
        }
    },
    props = {
        { model = "bkr_prop_meth_ammonia", clip = "chemical_pour_long_ammonia" },
        { model = "bkr_prop_fakeid_clipboard_01a", clip = "chemical_pour_long_clipboard" },
        { model = "prop_pencil_01", clip = "chemical_pour_long_pencil" },
        { model = "bkr_prop_meth_sacid", clip = "chemical_pour_long_sacid" }
    }
}

-- Scene 4: Monitoring Button Press (High Equipment/Employees)
animationScenes[4] = {
    coords = vector4(1011.5903, -3199.7703, -38.9932, 0.1231),
    offset = vector4(0.8, -1.4, 0.0, 0.0),
    dict = "anim@amb@business@meth@meth_monitoring_cooking@monitoring@",
    employees = "high",
    equipment = "high",
    peds = {
        {
            model = -306958529,
            disableRandomize = true,
            clip = "button_press_monitor",
            altCoords = vector4(1012.6068, -3202.624, -38.9932, 1.8772)
        }
    },
    props = {
        { model = "bkr_prop_fakeid_clipboard_01a", clip = "button_press_clipboard^1" },
        { model = "prop_pencil_01", clip = "button_press_pencil^1" }
    }
}

-- Scene 5: Gauge Monitoring (High Employees)
animationScenes[5] = {
    coords = vector4(1007.8876, -3195.3267, -38.9932, 358.4245),
    offset = vector4(0.65, -1.7, 0.0, 0.0),
    dict = "anim@amb@business@meth@meth_monitoring_cooking@monitoring@",
    employees = "high",
    peds = {
        {
            model = -306958529,
            disableRandomize = true,
            clip = "base_idle_guage_monitor"
        }
    },
    props = {
        { model = "bkr_prop_fakeid_clipboard_01a", clip = "base_idle_guage_clipboard^1" },
        { model = "bkr_prop_fakeid_penclipboard", clip = "base_idle_guage_pencil^1" }
    }
}

-- Scene 6: Inspector (High Employees)
animationScenes[6] = {
    dict = "anim@amb@business@bgen@bgen_inspecting@",
    coords = vector4(1014.9441, -3195.5195, -38.9931, 11.2313),
    offset = vector4(0.0, 0.0, 0.0, 0.0),
    employees = "high",
    peds = {
        {
            model = -306958529,
            variant = 1,
            disableRandomize = true,
            clip = "inspecting_high_idle_01_inspector",
            altCoords = vector4(1014.5686, -3198.1531, -38.9931, 287.4777)
        }
    },
    props = {
        { model = -297480469, clip = "inspecting_high_idle_01_clipboard" },
        { model = 463086472, clip = "inspecting_high_idle_01_pencil" }
    }
}

-- Debug Commands
RegisterCommand("playmeth", function()
    Scenes.play(animationScenes)
end)

RegisterCommand("stopmeth", function()
    Scenes.stop()
    ClearPedTasksImmediately(cache.ped)
end)

-- Product Spawn Positions (shelf positions for meth products)
productSpawnPositions = {
    vector4(1018.0192, -3197.7791, -38.9, 270.0),
    vector4(1018.0192, -3198.7791, -38.9, 270.0),
    vector4(1018.0192, -3199.8791, -38.9, 270.0),
    vector4(1018.0192, -3200.8791, -38.9, 270.0),
    vector4(1018.0192, -3197.7791, -38.3, 270.0),
    vector4(1018.0192, -3198.7791, -38.3, 270.0),
    vector4(1018.0192, -3199.8791, -38.3, 270.0),
    vector4(1018.0192, -3200.8791, -38.3, 270.0),
    vector4(1018.0192, -3197.7791, -37.7, 270.0),
    vector4(1018.0192, -3198.7791, -37.7, 270.0),
    vector4(1018.0192, -3199.8791, -37.7, 270.0),
    vector4(1018.0192, -3200.8791, -37.7, 270.0),
    vector4(1018.0192, -3197.7791, -37.1, 270.0),
    vector4(1018.0192, -3198.7791, -37.1, 270.0),
    vector4(1018.0192, -3199.8791, -37.1, 270.0),
    vector4(1018.0192, -3200.8791, -37.1, 270.0)
}

-- Active Props Storage
activeProps = {}

-- Debug command to create meth products
RegisterCommand("createmeth", function()
    for i = 1, #activeProps do
        activeProps[i].remove()
    end
    table.wipe(activeProps)
    
    for i = 1, #productSpawnPositions do
        local position = productSpawnPositions[i]
        activeProps[#activeProps + 1] = Utils.createProp(position, {
            model = Config.businessTypes.meth.product.prop.model,
            offset = vector3(0.0, 0.0, -1.0)
        })
        Wait(300)
    end
end)

-- Gets product prop model from config
function GetProductPropModel()
    return Config.businessTypes.meth.product.prop.model
end

-- Creates product props based on percentage
function CreateProductProps(productPercentage)
    local propCount = math.floor(#productSpawnPositions * productPercentage / 100)
    
    for i = 1, propCount do
        local position = productSpawnPositions[i]
        activeProps[#activeProps + 1] = Utils.createProp(position, {
            model = GetProductPropModel(),
            offset = vector3(0.0, 0.0, -1.0)
        })
    end
end

-- Clears all active props
function ClearActiveProps()
    for i = 1, #activeProps do
        activeProps[i].remove()
    end
    table.wipe(activeProps)
end

-- Maps equipment level to IPL style
function GetIPLStyleFromEquipment(equipmentLevel)
    if equipmentLevel == "none" then
        return "empty"
    elseif equipmentLevel == "low" then
        return "basic"
    elseif equipmentLevel == "high" then
        return "upgrade"
    end
    return "empty"
end

-- IPL Functions Table
IPLs.meth = {}

function IPLs.meth.load(businessData, additionalData)
    local methLab = exports.bob74_ipl:GetBikerMethLabObject()
    local iplStyle = GetIPLStyleFromEquipment(businessData.equipment)
    
    -- Set interior style
    methLab.Style.Set(methLab.Style[iplStyle])
    
    -- Set security level (passing empty string as in original)
    methLab.Security.Set("")
    
    -- Enable production details
    methLab.Details.Enable(methLab.Details.production, true)
    
    RefreshInterior(methLab.interiorId)
    
    -- Create product props based on stored products
    if businessData then
        CreateProductProps(businessData.products)
    end
    
    -- Play employee animation scenes
    if businessData.employees ~= "none" then
        Scenes.play(animationScenes, businessData, additionalData)
    end
end

function IPLs.meth.unload()
    local methLab = exports.bob74_ipl:GetBikerMethLabObject()
    
    -- Set to upgraded style
    methLab.Style.Set(methLab.Style.upgrade)
    methLab.Security.Set(methLab.Security.upgrade)
    methLab.Details.Enable(methLab.Details.production, true)
    
    RefreshInterior(methLab.interiorId)
    
    -- Clear all active props
    ClearActiveProps()
    
    -- Stop animation scenes
    Scenes.stop()
end

function IPLs.meth.softReload(businessData)
    if not businessData then return end
    
    -- Clear existing props
    ClearActiveProps()
    
    -- Create new props based on current product level
    CreateProductProps(businessData.products)
end