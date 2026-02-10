-- Cocaine Lab IPL Configuration and Management

-- Animation Scenes Configuration
animationScenes = {}

-- Scene 1: Coke Cut (Left Table)
animationScenes[1] = {
    dict = "anim@amb@business@coc@coc_unpack_cut_left@",
    coords = vector4(1095.3832, -3194.9211, -38.9935, 181.4124),
    offset = vector4(1.75, 0.3, 0.625, 180.0),
    employees = "low",
    peds = {
        { model = 1456705429, clip = "coke_cut_coccutter" }
    },
    props = {
        { model = 852117134, clip = "coke_cut_bakingsoda" },
        { model = -875075437, clip = "coke_cut_creditcard" },
        { model = -875075437, clip = "coke_cut_creditcard^1" }
    }
}

-- Scene 2: Coke Cut (Left Table - High Employees)
animationScenes[2] = {
    dict = "anim@amb@business@coc@coc_unpack_cut_left@",
    coords = vector4(1092.9109, -3194.9326, -38.9935, 179.4144),
    offset = vector4(1.75, 0.3, 0.625, 180.0),
    employees = "high",
    peds = {
        { model = 1264941816, clip = "coke_cut_coccutter" }
    },
    props = {
        { model = 852117134, clip = "coke_cut_bakingsoda" },
        { model = -875075437, clip = "coke_cut_creditcard" },
        { model = -875075437, clip = "coke_cut_creditcard^1" }
    }
}

-- Scene 3: Coke Cut (Left Table - Station 3)
animationScenes[3] = {
    dict = "anim@amb@business@coc@coc_unpack_cut_left@",
    coords = vector4(1090.1129, -3194.9148, -38.9935, 181.2742),
    offset = vector4(1.75, 0.4, 0.625, 180.0),
    peds = {
        { model = 1456705429, clip = "coke_cut_coccutter" }
    },
    props = {
        { model = 852117134, clip = "coke_cut_bakingsoda" },
        { model = -875075437, clip = "coke_cut_creditcard" },
        { model = -875075437, clip = "coke_cut_creditcard^1" }
    }
}

-- Scene 4: Coke Cut (Left Table - Station 4)
animationScenes[4] = {
    dict = "anim@amb@business@coc@coc_unpack_cut_left@",
    coords = vector4(1093.0842, -3196.5747, -38.9935, 359.4447),
    offset = vector4(-1.75, -0.3, 0.625, 180.0),
    peds = {
        { model = 1456705429, clip = "coke_cut_coccutter" }
    },
    props = {
        { model = 852117134, clip = "coke_cut_bakingsoda" },
        { model = -875075437, clip = "coke_cut_creditcard" },
        { model = -875075437, clip = "coke_cut_creditcard^1" }
    }
}

-- Scene 5: Coke Cut (Left Table - Station 5, High Employees)
animationScenes[5] = {
    dict = "anim@amb@business@coc@coc_unpack_cut_left@",
    coords = vector4(1095.4288, -3196.5513, -38.9935, 4.5184),
    offset = vector4(-1.75, -0.4, 0.625, 180.0),
    employees = "high",
    peds = {
        { model = 1264941816, clip = "coke_cut_coccutter" }
    },
    props = {
        { model = 852117134, clip = "coke_cut_bakingsoda" },
        { model = -875075437, clip = "coke_cut_creditcard" },
        { model = -875075437, clip = "coke_cut_creditcard^1" }
    }
}

-- Scene 6: Coke Cut (Right Area - High Equipment/Employees)
animationScenes[6] = {
    dict = "anim@amb@business@coc@coc_unpack_cut_left@",
    coords = vector4(1099.5955, -3194.2493, -38.9935, 88.0388),
    offset = vector4(0.3, -1.75, 0.625, 180.0),
    equipment = "high",
    employees = "high",
    peds = {
        { model = 1456705429, clip = "coke_cut_coccutter" }
    },
    props = {
        { model = 852117134, clip = "coke_cut_bakingsoda" },
        { model = -875075437, clip = "coke_cut_creditcard" },
        { model = -875075437, clip = "coke_cut_creditcard^1" }
    }
}

-- Scene 7: Coke Cut (Right Area - Station 2, High Equipment/Employees)
animationScenes[7] = {
    dict = "anim@amb@business@coc@coc_unpack_cut_left@",
    coords = vector4(1102.0044, -3193.6741, -38.9935, 5.0744),
    offset = vector4(-1.75, -0.4, 0.625, 180.0),
    equipment = "high",
    employees = "high",
    peds = {
        { model = 1264941816, clip = "coke_cut_coccutter" }
    },
    props = {
        { model = 852117134, clip = "coke_cut_bakingsoda" },
        { model = -875075437, clip = "coke_cut_creditcard" },
        { model = -875075437, clip = "coke_cut_creditcard^1" }
    }
}

-- Scene 8: Packing (Low Equipment)
animationScenes[8] = {
    dict = "anim@amb@business@coc@coc_packing@",
    coords = vector4(1100.713, -3198.7686, -38.9934, 178.3735),
    offset = vector4(-1.4, -0.08, 0.53, 180.0),
    equipment = "low",
    peds = {
        { model = 1456705429, clip = "full_cycle_basicmould_v1_pressoperator" }
    },
    props = {
        { model = -303457828, clip = "full_cycle_basicmould_v1_cocblock" },
        { model = -437148257, clip = "full_cycle_basicmould_v1_cocbowl" },
        { model = 1149677738, clip = "full_cycle_basicmould_v1_cocpress" },
        { model = 1131780764, clip = "full_cycle_basicmould_v1_cocmold" },
        { model = 358843520, clip = "full_cycle_basicmould_v1_scoop" }
    }
}

-- Scene 9: Packing (High Equipment)
animationScenes[9] = {
    dict = "anim@amb@business@coc@coc_packing_hi@",
    coords = vector4(1100.713, -3198.7686, -38.9934, 178.3735),
    offset = vector4(7.0, -2.25, 1.0, 180.0),
    equipment = "high",
    peds = {
        { model = 1456705429, clip = "full_cycle_v1_pressoperator" }
    },
    props = {
        { model = -2122380018, clip = "full_cycle_v1_boxeddoll" },
        { model = -437148257, clip = "full_cycle_v1_cocbowl" },
        { model = 286149026, clip = "full_cycle_v1_cocdoll" },
        { model = -180879779, clip = "full_cycle_v1_dollcast" },
        { model = -180879779, clip = "full_cycle_v1_dollcast^1" },
        { model = -180879779, clip = "full_cycle_v1_dollcast^2" },
        { model = -180879779, clip = "full_cycle_v1_dollcast^3" },
        { model = 1545859325, clip = "full_cycle_v1_dollmould" },
        { model = 2116540373, clip = "full_cycle_v1_cokepress" },
        { model = -370114164, clip = "full_cycle_v1_foldedbox" },
        { model = -370114164, clip = "full_cycle_v1_foldedbox^1" },
        { model = -370114164, clip = "full_cycle_v1_foldedbox^2" },
        { model = 358843520, clip = "full_cycle_v1_scoop" }
    }
}

-- Scene 10: Inspector (High Employees)
animationScenes[10] = {
    dict = "anim@amb@business@bgen@bgen_inspecting@",
    coords = vector4(1088.5391, -3194.426, -38.9934, 229.6766),
    offset = vector4(0.0, 0.0, 0.0, 0.0),
    employees = "high",
    peds = {
        {
            model = 1456705429,
            variant = 2,
            disableRandomize = true,
            clip = "inspecting_high_idle_01_inspector",
            altCoords = vector4(1092.7565, -3192.481, -38.9935, 180.065)
        }
    },
    props = {
        { model = -297480469, clip = "inspecting_high_idle_01_clipboard" },
        { model = 463086472, clip = "inspecting_high_idle_01_pencil" }
    }
}

-- Scene 11: Full Cut Cycle (Station 1)
animationScenes[11] = {
    dict = "anim@amb@business@coc@coc_unpack_cut@",
    coords = vector4(1088.708, -3195.823, -38.9934, 272.0975),
    offset = vector4(-0.125, -0.6, 0.65, -90.0),
    peds = {
        { model = 1456705429, clip = "fullcut_cycle_cokepacker" },
        {
            model = 1264941816,
            clip = "fullcut_cycle_cokecutter",
            altCoords = vector4(1087.1763, -3199.4648, -38.9935, 318.1252)
        }
    },
    props = {
        { model = -1478175385, clip = "fullcut_cycle_cokebox" },
        { model = -1478175385, clip = "fullcut_cycle_cokebox^1" },
        { model = -1478175385, clip = "fullcut_cycle_cokebox^2" },
        { model = -1478175385, clip = "fullcut_cycle_cokebox^3" },
        { model = -437148257, clip = "fullcut_cycle_cokebowl" },
        { model = 852117134, clip = "fullcut_cycle_bakingsoda" },
        { model = 358843520, clip = "fullcut_cycle_cokescoop" },
        { model = 358843520, clip = "fullcut_cycle_cokescoop^1" },
        { model = -468943584, clip = "fullcut_cycle_cokesieve" },
        { model = -875075437, clip = "fullcut_cycle_creditcard" },
        { model = -875075437, clip = "fullcut_cycle_creditcard^1" },
        { model = -289305948, clip = "fullcut_cycle_powderedmilk" }
    }
}

-- Scene 12: Full Cut Cycle (Station 2, High Employees)
animationScenes[12] = {
    dict = "anim@amb@business@coc@coc_unpack_cut@",
    coords = vector4(1096.9856, -3195.6396, -38.9935, 92.1191),
    offset = vector4(0.125, 0.6, 0.65, -90.0),
    employees = "high",
    peds = {
        { model = 1456705429, clip = "fullcut_cycle_cokepacker" },
        {
            model = 1456705429,
            clip = "fullcut_cycle_cokecutter",
            altCoords = vector4(1096.8623, -3199.6074, -38.9935, 11.1291)
        }
    },
    props = {
        { model = -1478175385, clip = "fullcut_cycle_cokebox" },
        { model = -1478175385, clip = "fullcut_cycle_cokebox^1" },
        { model = -1478175385, clip = "fullcut_cycle_cokebox^2" },
        { model = -1478175385, clip = "fullcut_cycle_cokebox^3" },
        { model = -437148257, clip = "fullcut_cycle_cokebowl" },
        { model = 852117134, clip = "fullcut_cycle_bakingsoda" },
        { model = 358843520, clip = "fullcut_cycle_cokescoop" },
        { model = 358843520, clip = "fullcut_cycle_cokescoop^1" },
        { model = -468943584, clip = "fullcut_cycle_cokesieve" },
        { model = -875075437, clip = "fullcut_cycle_creditcard" },
        { model = -875075437, clip = "fullcut_cycle_creditcard^1" },
        { model = -289305948, clip = "fullcut_cycle_powderedmilk" }
    }
}

-- Debug Commands
RegisterCommand("playcoke", function()
    Scenes.play(animationScenes)
end)

RegisterCommand("stopcoke", function()
    Scenes.stop()
    ClearPedTasksImmediately(cache.ped)
end)

-- IPL Style Configuration
iplStyles = {
    basic = { "set_up", "equipment_basic", "production_basic", "table_equipment" },
    upgrade = { "set_up", "equipment_upgrade", "production_upgrade", "table_equipment_upgrade" }
}

-- Product Spawn Positions (normal product layout - brick formation)
productSpawnPositionsNormal = {
    vector4(1103.2122, -3194.7777, -38.7444, 0.0),
    vector4(1103.2122, -3195.6777, -38.7444, 180.0),
    vector4(1103.2122, -3196.7777, -38.7444, 0.0),
    vector4(1103.2122, -3197.6777, -38.7444, 180.0),
    vector4(1103.2122, -3194.7777, -38.3444, 0.0),
    vector4(1103.2122, -3195.6777, -38.3444, 180.0),
    vector4(1103.2122, -3196.7777, -38.3444, 0.0),
    vector4(1103.2122, -3197.6777, -38.3444, 180.0),
    vector4(1103.2122, -3194.7777, -37.9444, 0.0),
    vector4(1103.2122, -3195.6777, -37.9444, 180.0),
    vector4(1103.2122, -3196.7777, -37.9444, 0.0),
    vector4(1103.2122, -3197.6777, -37.9444, 180.0)
}

-- Product Spawn Positions (upgraded product layout - doll formation)
productSpawnPositionsUpgraded = {
    vector4(1103.4122, -3194.7777, -38.6044, 90.0),
    vector4(1103.4122, -3195.6777, -38.6044, 270.0),
    vector4(1102.7122, -3196.7777, -38.6044, 90.0),
    vector4(1102.7122, -3197.6777, -38.6044, 270.0),
    vector4(1102.7122, -3194.7777, -38.6044, 90.0),
    vector4(1102.7122, -3195.6777, -38.6044, 270.0),
    vector4(1103.4122, -3196.7777, -38.6044, 90.0),
    vector4(1103.4122, -3197.6777, -38.6044, 270.0),
    vector4(1103.4122, -3194.7777, -38.3294, 90.0),
    vector4(1103.4122, -3195.6777, -38.3294, 270.0),
    vector4(1103.4122, -3196.7777, -38.3294, 90.0),
    vector4(1103.4122, -3197.6777, -38.3294, 270.0),
    vector4(1102.7122, -3194.7777, -38.3294, 90.0),
    vector4(1102.7122, -3195.6777, -38.3294, 270.0),
    vector4(1102.7122, -3196.7777, -38.3294, 90.0),
    vector4(1102.7122, -3197.6777, -38.3294, 270.0)
}

-- Active Props Storage
activeProps = {}
staticProps = {}

-- Prop models
SHELF_PROP_MODEL = -440576300  -- Shelf/rack prop

-- Shelf positions
shelfPositions = {
    vector4(1103.0991, -3197.241, -38.9935, 90.0),
    vector4(1103.0991, -3195.241, -38.9935, 90.0)
}

-- Debug command to create coke products
RegisterCommand("createcoke", function()
    -- Clear existing props
    for i = 1, #activeProps do
        activeProps[i].remove()
    end
    for i = 1, #staticProps do
        staticProps[i].remove()
    end
    table.wipe(activeProps)
    table.wipe(staticProps)
    
    -- Create shelf props
    for _, position in pairs(shelfPositions) do
        staticProps[#staticProps + 1] = Utils.createProp(position, {
            model = SHELF_PROP_MODEL,
            offset = vector3(0.0, 0.0, -1.0)
        })
    end
    
    -- Create product props (using upgraded layout for demo)
    for i = 1, #productSpawnPositionsUpgraded do
        local position = productSpawnPositionsUpgraded[i]
        activeProps[#activeProps + 1] = Utils.createProp(position, {
            model = Config.businessTypes.coke.product.prop.upgraded.model,
            offset = vector3(0.0, 0.0, -1.0)
        })
        Wait(300)
    end
end)

-- Gets the appropriate product positions based on equipment level
function GetProductPositions(equipmentLevel)
    if equipmentLevel == "high" then
        return productSpawnPositionsUpgraded
    end
    return productSpawnPositionsNormal
end

-- Gets the product model based on equipment level
function GetProductModel(equipmentLevel)
    if equipmentLevel == "high" then
        return Config.businessTypes.coke.product.prop.upgraded.model
    end
    return Config.businessTypes.coke.product.prop.normal.model
end

-- Creates product props based on percentage and equipment level
function CreateProductProps(businessData)
    local positions = GetProductPositions(businessData.equipment)
    local propCount = math.floor(#positions * businessData.products / 100)
    local propModel = GetProductModel(businessData.equipment)
    
    for i = 1, propCount do
        local position = positions[i]
        activeProps[#activeProps + 1] = Utils.createProp(position, {
            model = propModel,
            offset = vector3(0.0, 0.0, -1.0)
        })
    end
end

-- Creates shelf props
function CreateShelfProps()
    for _, position in pairs(shelfPositions) do
        staticProps[#staticProps + 1] = Utils.createProp(position, {
            model = SHELF_PROP_MODEL,
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

-- Clears all static props (shelves)
function ClearStaticProps()
    for i = 1, #staticProps do
        staticProps[i].remove()
    end
    table.wipe(staticProps)
end

-- Maps equipment level to IPL style
function GetIPLStyleFromEquipment(equipmentLevel)
    if equipmentLevel == "none" then
        return { "equipment_basic" }
    elseif equipmentLevel == "low" then
        return "basic"
    elseif equipmentLevel == "high" then
        return "upgrade"
    end
    return "basic"
end

-- IPL Functions Table
IPLs.coke = {}

function IPLs.coke.load(businessData, additionalData)
    local cocaineLab = exports.bob74_ipl:GetBikerCocaineObject()
    local iplStyle = GetIPLStyleFromEquipment(businessData.equipment)
    
    -- Configure coke details based on equipment level
    local cokeDetails = {
        cocaineLab.Details.cokeBasic1,
        cocaineLab.Details.cokeBasic2,
        cocaineLab.Details.cokeBasic3
    }
    
    if businessData.equipment == "high" then
        cokeDetails[#cokeDetails + 1] = cocaineLab.Details.cokeUpgrade1
        cokeDetails[#cokeDetails + 1] = cocaineLab.Details.cokeUpgrade2
    end
    
    -- Set interior style (handles both table and string types)
    if type(iplStyle) == "string" and iplStyles[iplStyle] then
        cocaineLab.Style.Set(iplStyles[iplStyle])
    else
        cocaineLab.Style.Set(iplStyle)
    end
    
    -- Set security level
    cocaineLab.Security.Set("")
    
    -- Enable coke details based on equipment presence
    local hasEquipment = businessData.equipment ~= "none"
    cocaineLab.Details.Enable(cokeDetails, hasEquipment)
    
    RefreshInterior(cocaineLab.interiorId)
    
    -- Create shelf props
    CreateShelfProps()
    
    -- Create product props based on stored products
    if businessData then
        CreateProductProps(businessData)
    end
    
    -- Play employee animation scenes
    if businessData.employees ~= "none" then
        Scenes.play(animationScenes, businessData, additionalData)
    end
end

function IPLs.coke.unload()
    local cocaineLab = exports.bob74_ipl:GetBikerCocaineObject()
    
    -- Set to upgraded style
    cocaineLab.Style.Set(cocaineLab.Style.upgrade)
    cocaineLab.Security.Set(cocaineLab.Security.upgrade)
    cocaineLab.Details.Enable(cocaineLab.Details.production, true)
    
    RefreshInterior(cocaineLab.interiorId)
    
    -- Clear all props
    ClearActiveProps()
    ClearStaticProps()
    
    -- Stop animation scenes
    Scenes.stop()
end

function IPLs.coke.softReload(businessData)
    if not businessData then return end
    
    -- Clear existing product props
    ClearActiveProps()
    
    -- Create new props based on current product level and equipment
    CreateProductProps(businessData)
end