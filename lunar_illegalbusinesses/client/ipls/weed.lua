-- Weed Farm IPL Configuration and Management

-- Animation Scenes Configuration
animationScenes = {}

-- Scene 1: High Dry Inspection
animationScenes[1] = {
    dict = "anim@amb@business@weed@weed_inspecting_high_dry@",
    coords = vector4(1041.2373, -3207.1633, -38.1615, 186.2111),
    offset = vector4(0.0, 0.0, 0.0, 0.0),
    peds = {
        {
            model = -1853959079,
            disableRandomize = true,
            clip = "weed_inspecting_high_base_inspector",
            altCoords = vector4(1065.1421, -3188.397, -39.1614, 91.2176)
        }
    },
    props = {
        { model = -297480469, clip = "weed_inspecting_high_base_clipboard" },
        { model = -1814932629, clip = "weed_inspecting_high_base_pen" },
        { model = 214384272, clip = "weed_inspecting_high_base_ladder" }
    }
}

-- Scene 2: Spray Bottle Crouch
animationScenes[2] = {
    dict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
    coords = vector4(1060.5239, -3195.0085, -39.1613, 272.4551),
    offset = vector4(-0.75, 0.0, 1.0, 90.0),
    peds = {
        {
            model = -1853959079,
            disableRandomize = true,
            clip = "weed_spraybottle_crouch_base_inspector",
            altCoords = vector4(1038.8164, -3198.759, -38.1696, 272.7039)
        }
    },
    props = {
        { model = -1599313277, clip = "weed_spraybottle_crouch_base_spraybottle" }
    }
}

-- Scene 3: Spray Bottle Crouch (Female Inspector)
animationScenes[3] = {
    dict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
    coords = vector4(1053.5665, -3192.5337, -39.1613, 92.5709),
    offset = vector4(0.75, 0.0, 1.0, 90.0),
    employees = "high",
    peds = {
        {
            model = -1301974109,
            disableRandomize = true,
            clip = "weed_spraybottle_crouch_base_inspectorfemale",
            altCoords = vector4(1048.7935, -3190.1865, -39.1533, 276.642)
        }
    },
    props = {
        { model = -1599313277, clip = "weed_spraybottle_crouch_base_spraybottle" }
    }
}

-- Scene 4: Spray Bottle Crouch Spraying
animationScenes[4] = {
    dict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
    coords = vector4(1052.9613, -3204.8994, -39.1315, 180.7126),
    offset = vector4(0.0, 0.75, 1.0, 90.0),
    employees = "high",
    peds = {
        {
            model = -1853959079,
            disableRandomize = true,
            clip = "weed_spraybottle_crouch_spraying_01_inspector",
            altCoords = vector4(1041.0828, -3208.4111, -38.1614, 3.6897)
        }
    },
    props = {
        { model = -1599313277, clip = "weed_spraybottle_crouch_spraying_01_spraybottle" }
    }
}

-- Scene 5: Sorting Seated (Left)
animationScenes[5] = {
    dict = "anim@amb@business@weed@weed_sorting_seated@",
    coords = vector4(1037.6144, -3205.897, -38.1699, 266.8642),
    offset = vector4(-0.8, 0.0, 0.925, 180.0),
    peds = {
        {
            model = -1301974109,
            disableRandomize = true,
            clip = "sorter_left_sort_v1_sorter01",
            altCoords = vector4(1037.1337, -3208.3584, -38.1703, 3.3639)
        },
        {
            model = -1853959079,
            disableRandomize = true,
            clip = "sorter_right_sort_v1_sorter02",
            altCoords = vector4(1036.0917, -3203.7258, -38.1739, 179.991)
        }
    },
    props = {
        { model = -1987898602, clip = "sorter_left_sort_v1_bucket01a" },
        { model = -1987898602, clip = "sorter_left_sort_v1_bucket01a^1" },
        { model = -1281587804, clip = "sorter_left_sort_v1_chair01" },
        { model = -1281587804, clip = "sorter_left_sort_v1_chair02" },
        { model = 1463746489, clip = "sorter_left_sort_v1_weedbag01a" },
        { model = -1218018752, clip = "sorter_left_sort_v1_weedbagpile01a" },
        { model = 1859251157, clip = "sorter_left_sort_v1_weedbud02a" },
        { model = 1859251157, clip = "sorter_left_sort_v1_weedbud02a^1" },
        { model = 1859251157, clip = "sorter_left_sort_v1_weedbud02a^2" },
        { model = 1859251157, clip = "sorter_left_sort_v1_weedbud02b" },
        { model = 1859251157, clip = "sorter_left_sort_v1_weedbud02b^1" },
        { model = 1859251157, clip = "sorter_left_sort_v1_weedbud02b^2" },
        { model = 1859251157, clip = "sorter_left_sort_v1_weedbud02b^3" },
        { model = 1859251157, clip = "sorter_left_sort_v1_weedbud02b^4" },
        { model = 1859251157, clip = "sorter_left_sort_v1_weedbud02b^5" },
        { model = 1859251157, clip = "sorter_right_sort_v1_weedbud02a" },
        { model = 1859251157, clip = "sorter_right_sort_v1_weedbud02a^1" },
        { model = 1859251157, clip = "sorter_right_sort_v1_weedbud02a^2" },
        { model = 1859251157, clip = "sorter_right_sort_v1_weedbud02b" },
        { model = 1859251157, clip = "sorter_right_sort_v1_weedbud02b^1" },
        { model = 1859251157, clip = "sorter_right_sort_v1_weedbud02b^2" },
        { model = 1859251157, clip = "sorter_right_sort_v1_weedbud02b^3" },
        { model = 1859251157, clip = "sorter_right_sort_v1_weedbud02b^4" },
        { model = 1859251157, clip = "sorter_right_sort_v1_weedbud02b^5" },
        { model = -859493159, clip = "sorter_left_sort_v1_weeddry01a" },
        { model = -859493159, clip = "sorter_left_sort_v1_weeddry01a^1" },
        { model = -2068855676, clip = "sorter_left_sort_v1_weedleaf01a" },
        { model = -2068855676, clip = "sorter_left_sort_v1_weedleaf01a^1" }
    }
}

-- Scene 6: Sorting Seated (Version 2)
animationScenes[6] = {
    dict = "anim@amb@business@weed@weed_sorting_seated@",
    coords = vector4(1033.0348, -3206.1887, -38.18, 272.6792),
    offset = vector4(-0.8, 0.0, 0.925, 180.0),
    employees = "high",
    peds = {
        {
            model = -1853959079,
            disableRandomize = true,
            clip = "sorter_left_sort_v2_sorter01",
            altCoords = vector4(1033.7289, -3203.7146, -38.1792, 182.1384)
        },
        {
            model = -1301974109,
            disableRandomize = true,
            clip = "sorter_right_sort_v2_sorter02"
        }
    },
    props = {
        { model = -1987898602, clip = "sorter_left_sort_v2_bucket01a" },
        { model = -1987898602, clip = "sorter_left_sort_v2_bucket01a^1" },
        { model = -1281587804, clip = "sorter_left_sort_v2_chair01" },
        { model = -1281587804, clip = "sorter_left_sort_v2_chair02" },
        { model = 1463746489, clip = "sorter_left_sort_v2_weedbag01a" },
        { model = -1218018752, clip = "sorter_left_sort_v2_weedbagpile01a" },
        { model = 1859251157, clip = "sorter_left_sort_v2_weedbud02a" },
        { model = 1859251157, clip = "sorter_left_sort_v2_weedbud02a^1" },
        { model = 1859251157, clip = "sorter_left_sort_v2_weedbud02a^2" },
        { model = 1859251157, clip = "sorter_left_sort_v2_weedbud02b" },
        { model = 1859251157, clip = "sorter_left_sort_v2_weedbud02b^1" },
        { model = 1859251157, clip = "sorter_left_sort_v2_weedbud02b^2" },
        { model = 1859251157, clip = "sorter_left_sort_v2_weedbud02b^3" },
        { model = 1859251157, clip = "sorter_left_sort_v2_weedbud02b^4" },
        { model = 1859251157, clip = "sorter_left_sort_v2_weedbud02b^5" },
        { model = 1859251157, clip = "sorter_right_sort_v2_weedbud02a" },
        { model = 1859251157, clip = "sorter_right_sort_v2_weedbud02a^1" },
        { model = 1859251157, clip = "sorter_right_sort_v2_weedbud02a^2" },
        { model = 1859251157, clip = "sorter_right_sort_v2_weedbud02b" },
        { model = 1859251157, clip = "sorter_right_sort_v2_weedbud02b^1" },
        { model = 1859251157, clip = "sorter_right_sort_v2_weedbud02b^2" },
        { model = 1859251157, clip = "sorter_right_sort_v2_weedbud02b^3" },
        { model = 1859251157, clip = "sorter_right_sort_v2_weedbud02b^4" },
        { model = 1859251157, clip = "sorter_right_sort_v2_weedbud02b^5" },
        { model = -859493159, clip = "sorter_left_sort_v2_weeddry01a" },
        { model = -859493159, clip = "sorter_left_sort_v2_weeddry01a^1" },
        { model = -2068855676, clip = "sorter_left_sort_v2_weedleaf01a" },
        { model = -2068855676, clip = "sorter_left_sort_v2_weedleaf01a^1" }
    }
}

-- Debug Commands
RegisterCommand("playweed", function()
    Scenes.play(animationScenes)
end)

RegisterCommand("stopweed", function()
    Scenes.stop()
    ClearPedTasksImmediately(cache.ped)
end)

-- Product Spawn Positions (shelf positions for weed products)
productSpawnPositions = {
    vector4(1040.9967, -3192.9691, -37.9052, 268.8167),
    vector4(1041.7567, -3192.9691, -37.9052, 268.8167),
    vector4(1040.9967, -3192.3691, -37.9052, 268.8167),
    vector4(1041.7567, -3192.3691, -37.9052, 268.8167),
    vector4(1040.9967, -3192.9691, -37.6152, 268.8167),
    vector4(1041.7567, -3192.9691, -37.6152, 268.8167),
    vector4(1040.9967, -3192.3691, -37.6152, 268.8167),
    vector4(1041.7567, -3192.3691, -37.6152, 268.8167),
    vector4(1040.9967, -3192.9691, -37.3252, 268.8167),
    vector4(1041.7567, -3192.9691, -37.3252, 268.8167),
    vector4(1040.9967, -3192.3691, -37.3252, 268.8167),
    vector4(1041.7567, -3192.3691, -37.3252, 268.8167),
    vector4(1042.7275, -3192.9691, -37.9052, 268.8167),
    vector4(1043.5567, -3192.9691, -37.9052, 268.8167),
    vector4(1042.7275, -3192.3691, -37.9052, 268.8167),
    vector4(1043.5567, -3192.3691, -37.9052, 268.8167),
    vector4(1042.7275, -3192.9691, -37.6152, 268.8167),
    vector4(1043.5567, -3192.9691, -37.6152, 268.8167),
    vector4(1042.7275, -3192.3691, -37.6152, 268.8167),
    vector4(1043.5567, -3192.3691, -37.6152, 268.8167),
    vector4(1042.7275, -3192.9691, -37.3252, 268.8167),
    vector4(1043.5567, -3192.9691, -37.3252, 268.8167),
    vector4(1042.7275, -3192.3691, -37.3252, 268.8167),
    vector4(1043.5567, -3192.3691, -37.3252, 268.8167)
}

-- Active Props Storage
activeProps = {}

-- Debug command to create weed products
RegisterCommand("createweed", function()
    for i = 1, #activeProps do
        activeProps[i].remove()
    end
    table.wipe(activeProps)
    
    for i = 1, #productSpawnPositions do
        local position = productSpawnPositions[i]
        activeProps[#activeProps + 1] = Utils.createProp(position, {
            model = Config.businessTypes.weed.product.prop.model,
            offset = vector3(0.0, 0.0, -1.0)
        })
        Wait(300)
    end
end)

-- Gets product prop model from config
function GetProductPropModel()
    return Config.businessTypes.weed.product.prop.model
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

-- Gets plant growth stage name based on percentage
function GetPlantGrowthStage(growthPhase)
    if growthPhase > 66 then
        return "full"
    elseif growthPhase > 33 then
        return "medium"
    else
        return "small"
    end
end

-- IPL Functions Table
IPLs.weed = {}

function IPLs.weed.load(businessData, additionalData)
    local weedFarm = exports.bob74_ipl:GetBikerWeedFarmObject()
    local hasNoSupplies = businessData.supplies == 0
    local iplStyle = GetIPLStyleFromEquipment(businessData.equipment)
    
    -- Set interior style
    weedFarm.Style.Set(weedFarm.Style[iplStyle])
    
    -- Set security level
    local securityLevel = weedFarm.Security.basic
    if businessData.security and weedFarm.Security.upgrade then
        securityLevel = weedFarm.Security.upgrade
    end
    weedFarm.Security.Set(securityLevel)
    
    -- Configure interior details
    weedFarm.Details.Enable(weedFarm.Details.production, false)
    weedFarm.Details.Enable(weedFarm.Details.drying, not hasNoSupplies)
    weedFarm.Details.Enable(weedFarm.Details.chairs, false)
    
    -- Set plant growth stages
    local growthStage = GetPlantGrowthStage(businessData.growthPhase)
    
    for plantIndex = 1, 9 do
        local plant = weedFarm["Plant" .. plantIndex]
        local lightType = weedFarm["Plant" .. plantIndex].Light.upgrade
        
        if businessData.equipment == "low" and plant.Light.basic then
            lightType = plant.Light.basic
        end
        
        plant.Set(plant.Stage[growthStage], lightType)
        plant.Hose.Enable(true)
        
        if hasNoSupplies then
            plant.Clear()
        end
    end
    
    RefreshInterior(weedFarm.interiorId)
    
    -- Create product props based on stored products
    if businessData then
        CreateProductProps(businessData.products)
    end
    
    -- Play employee animation scenes
    if businessData.employees ~= "none" then
        Scenes.play(animationScenes, businessData, additionalData)
    end
end

function IPLs.weed.unload()
    local weedFarm = exports.bob74_ipl:GetBikerWeedFarmObject()
    
    -- Set to upgraded style
    weedFarm.Style.Set(weedFarm.Style.upgrade)
    weedFarm.Security.Set(weedFarm.Security.upgrade)
    weedFarm.Details.Enable(weedFarm.Details.production, true)
    
    RefreshInterior(weedFarm.interiorId)
    
    -- Clear all active props
    ClearActiveProps()
    
    -- Stop animation scenes
    Scenes.stop()
end

function IPLs.weed.softReload(businessData)
    if not businessData then return end
    
    -- Clear existing props
    ClearActiveProps()
    
    -- Create new props based on current product level
    CreateProductProps(businessData.products)
end