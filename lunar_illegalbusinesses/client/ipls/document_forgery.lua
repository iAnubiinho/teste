-- Document Forgery IPL Configuration and Management

-- Random model list for photo session
PHOTO_MODEL_OPTIONS = { -1054459573, 1146800212, -1106743555, 664399832, 826475330 }

-- Function to generate animation scenes (uses random elements)
function GenerateAnimationScenes()
    local scenes = {}
    
    -- Scene 1: Photography
    scenes[1] = {
        dict = "anim@amb@business@cfid@cfid_photograph@",
        coords = vector4(1164.9745, -3191.8633, -39.008, 92.6376),
        offset = vector4(0.0, 4.5, 1.0, 90.0),
        peds = {
            {
                model = 1631482011,
                clip = "photograph_v1_photographer",
                altCoords = vector4(1161.2698, -3190.7891, -39.008, 182.3082)
            },
            {
                model = Utils.randomFromTable(PHOTO_MODEL_OPTIONS),
                disableRandomize = true,
                clip = "photograph_v1_model",
                altCoords = vector4(1164.9576, -3194.989, -29.3903, 98.6523)
            }
        },
        props = {
            { model = -1286783315, clip = "photograph_v1_camera" }
        }
    }
    
    -- Scene 2: Desk Docs (Passport Inspection)
    scenes[2] = {
        dict = "anim@amb@business@cfid@cfid_desk_docs@",
        coords = vector4(1170.0813, -3196.3418, -39.008, 91.4274),
        offset = vector4(0.85, -0.8, 0.2, 0.0),
        peds = {
            {
                model = 2014985464,
                variant = math.random(0, 3),
                disableRandomize = true,
                clip = "doc_inspection_idartistfemale",
                altCoords = vector4(1166.2373, -3199.1602, -39.008, 358.4065)
            }
        },
        props = {
            { model = 1786673017, clip = "doc_inspection_bundlepassport" },
            { model = 475561894, clip = "doc_inspection_chair" },
            { model = 1228763551, clip = "doc_inspection_magnifyingglass" },
            { model = 333669458, clip = "doc_inspection_openpassport" },
            { model = 333669458, clip = "doc_inspection_openpassport1" },
            { model = 333669458, clip = "doc_inspection_openpassport2" },
            { model = -1216160641, clip = "doc_inspection_singlepassport" }
        }
    }
    
    -- Scene 3: Desk Docs Opposite (High Employees)
    scenes[3] = {
        dict = "anim@amb@business@cfid@cfid_desk_docs@",
        coords = vector4(1162.769, -3197.0945, -39.008, 267.9508),
        offset = vector4(-0.85, 0.8, 0.2, 0.0),
        employees = "high",
        peds = {
            {
                model = 2014985464,
                variant = math.random(0, 3),
                disableRandomize = true,
                clip = "doc_inspection_idartistfemale",
                altCoords = vector4(1161.2683, -3193.7988, -39.008, 189.6888)
            }
        },
        props = {
            { model = 1786673017, clip = "doc_inspection_bundlepassport" },
            { model = 475561894, clip = "doc_inspection_chair" },
            { model = 1228763551, clip = "doc_inspection_magnifyingglass" },
            { model = 333669458, clip = "doc_inspection_openpassport" },
            { model = 333669458, clip = "doc_inspection_openpassport1" },
            { model = 333669458, clip = "doc_inspection_openpassport2" },
            { model = -1216160641, clip = "doc_inspection_singlepassport" }
        }
    }
    
    -- Scene 4: Desk Docs Side (High Employees)
    scenes[4] = {
        dict = "anim@amb@business@cfid@cfid_desk_docs@",
        coords = vector4(1160.848, -3198.4232, -39.0079, 90.0),
        offset = vector4(0.85, -0.8, 0.2, 0.0),
        employees = "high",
        peds = {
            {
                model = 2014985464,
                variant = math.random(0, 3),
                disableRandomize = true,
                clip = "doc_inspection_idartistfemale"
            }
        },
        props = {
            { model = 1786673017, clip = "doc_inspection_bundlepassport" },
            { model = 475561894, clip = "doc_inspection_chair" },
            { model = 1228763551, clip = "doc_inspection_magnifyingglass" },
            { model = 333669458, clip = "doc_inspection_openpassport" },
            { model = 333669458, clip = "doc_inspection_openpassport1" },
            { model = 333669458, clip = "doc_inspection_openpassport2" },
            { model = -1216160641, clip = "doc_inspection_singlepassport" }
        }
    }
    
    -- Scene 5: Desk ID (Light Investigation)
    scenes[5] = {
        dict = "anim@amb@business@cfid@cfid_desk_id@",
        coords = vector4(1167.2249, -3196.4753, -39.008, 270.4223),
        offset = vector4(-1.3, 0.2, 0.19, 0.0),
        peds = {
            {
                model = 1631482011,
                clip = "light_investigation_idcounterfiter",
                altCoords = vector4(1158.2177, -3191.2065, -39.008, 223.1571)
            }
        },
        props = {
            { model = 475561894, clip = "light_investigation_chair" },
            { model = 1494881840, clip = "light_investigation_ruler" },
            { model = -338809521, clip = "light_investigation_scalpel" },
            { model = -343072768, clip = "light_investigation_driverslicense" },
            { model = -343072768, clip = "light_investigation_driverslicense^1" },
            { model = -343072768, clip = "light_investigation_driverslicense^2" },
            { model = -343072768, clip = "light_investigation_driverslicense^3" }
        }
    }
    
    -- Scene 6: Desk ID (Stamped ID)
    scenes[6] = {
        dict = "anim@amb@business@cfid@cfid_desk_id@",
        coords = vector4(1165.6158, -3196.8816, -39.008, 91.9441),
        offset = vector4(1.3, 0.0, 0.19, 0.0),
        peds = {
            {
                model = 1631482011,
                clip = "stamped_id_idcounterfiter"
            }
        },
        props = {
            { model = -1791106398, clip = "stamped_id_embosser" },
            { model = 475561894, clip = "stamped_id_chair" },
            { model = 1494881840, clip = "stamped_id_ruler" },
            { model = -338809521, clip = "stamped_id_scalpel" },
            { model = -343072768, clip = "stamped_id_driverslicense" },
            { model = -343072768, clip = "stamped_id_driverslicense^1" },
            { model = -343072768, clip = "stamped_id_driverslicense^2" },
            { model = -343072768, clip = "stamped_id_driverslicense^3" }
        }
    }
    
    -- Scene 7: Desk ID (Light Investigation, High Employees)
    scenes[7] = {
        dict = "anim@amb@business@cfid@cfid_desk_id@",
        coords = vector4(1159.0168, -3195.8665, -39.008, 180.0),
        offset = vector4(0.2, 1.3, 0.19, 0.0),
        employees = "high",
        peds = {
            {
                model = 1631482011,
                clip = "light_investigation_idcounterfiter",
                altCoords = vector4(1156.5452, -3196.5544, -39.008, 267.9069)
            }
        },
        props = {
            { model = 475561894, clip = "light_investigation_chair" },
            { model = 1494881840, clip = "light_investigation_ruler" },
            { model = -338809521, clip = "light_investigation_scalpel" },
            { model = -343072768, clip = "light_investigation_driverslicense" },
            { model = -343072768, clip = "light_investigation_driverslicense^1" },
            { model = -343072768, clip = "light_investigation_driverslicense^2" },
            { model = -343072768, clip = "light_investigation_driverslicense^3" }
        }
    }
    
    -- Scene 8: Desk ID (Stamped ID, High Employees)
    scenes[8] = {
        dict = "anim@amb@business@cfid@cfid_desk_id@",
        coords = vector4(1157.9961, -3198.5002, -39.008, 272.1219),
        offset = vector4(-1.3, 0.0, 0.19, 0.0),
        employees = "high",
        peds = {
            {
                model = 1631482011,
                clip = "stamped_id_idcounterfiter"
            }
        },
        props = {
            { model = -1791106398, clip = "stamped_id_embosser" },
            { model = 475561894, clip = "stamped_id_chair" },
            { model = 1494881840, clip = "stamped_id_ruler" },
            { model = -338809521, clip = "stamped_id_scalpel" },
            { model = -343072768, clip = "stamped_id_driverslicense" },
            { model = -343072768, clip = "stamped_id_driverslicense^1" },
            { model = -343072768, clip = "stamped_id_driverslicense^2" },
            { model = -343072768, clip = "stamped_id_driverslicense^3" }
        }
    }
    
    return scenes
end

-- Debug Commands
RegisterCommand("playfg", function()
    Scenes.play(GenerateAnimationScenes())
end)

RegisterCommand("stopfg", function()
    Scenes.stop()
    ClearPedTasksImmediately(cache.ped)
end)

-- Product Spawn Positions (shelf positions for forged documents)
productSpawnPositions = {
    vector4(1158.9651, -3190.1504, -38.923, 180.0),
    vector4(1159.5651, -3190.1504, -38.923, 180.0),
    vector4(1160.1651, -3190.1504, -38.923, 180.0),
    vector4(1160.7651, -3190.1504, -38.923, 180.0),
    vector4(1158.9651, -3190.1504, -38.283, 180.0),
    vector4(1159.5651, -3190.1504, -38.283, 180.0),
    vector4(1160.1651, -3190.1504, -38.283, 180.0),
    vector4(1160.7651, -3190.1504, -38.283, 180.0),
    vector4(1158.9651, -3190.1504, -37.703, 180.0),
    vector4(1159.5651, -3190.1504, -37.703, 180.0),
    vector4(1160.1651, -3190.1504, -37.703, 180.0),
    vector4(1160.7651, -3190.1504, -37.703, 180.0),
    vector4(1161.9651, -3190.1504, -38.923, 180.0),
    vector4(1162.5651, -3190.1504, -38.923, 180.0),
    vector4(1163.1651, -3190.1504, -38.923, 180.0),
    vector4(1163.7651, -3190.1504, -38.923, 180.0),
    vector4(1161.9651, -3190.1504, -38.283, 180.0),
    vector4(1162.5651, -3190.1504, -38.283, 180.0),
    vector4(1163.1651, -3190.1504, -38.283, 180.0),
    vector4(1163.7651, -3190.1504, -38.283, 180.0),
    vector4(1161.9651, -3190.1504, -37.703, 180.0),
    vector4(1162.5651, -3190.1504, -37.703, 180.0),
    vector4(1163.1651, -3190.1504, -37.703, 180.0),
    vector4(1163.7651, -3190.1504, -37.703, 180.0)
}

-- Active Props Storage
activeProps = {}

-- Gets product prop model from config
function GetProductPropModel()
    return Config.businessTypes.document_forgery.product.prop.model
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

-- Debug command to create forged document products
RegisterCommand("createfg", function()
    ClearActiveProps()
    
    for i = 1, #productSpawnPositions do
        local position = productSpawnPositions[i]
        activeProps[#activeProps + 1] = Utils.createProp(position, {
            model = GetProductPropModel(),
            offset = vector3(0.0, 0.0, -1.0)
        })
        Wait(300)
    end
end)

-- Maps equipment level to IPL style
function GetIPLStyleFromEquipment(equipmentLevel)
    if equipmentLevel == "none" or equipmentLevel == "low" then
        return "basic"
    elseif equipmentLevel == "high" then
        return "upgrade"
    end
    return "basic"
end

-- Gets equipment style for the equipment setting
function GetEquipmentStyle(equipmentLevel)
    if equipmentLevel == "none" then
        return "empty"
    end
    return GetIPLStyleFromEquipment(equipmentLevel)
end

-- IPL Functions Table
IPLs.document_forgery = {}

function IPLs.document_forgery.load(businessData, additionalData)
    local animationScenes = GenerateAnimationScenes()
    local documentForgery = exports.bob74_ipl:GetBikerDocumentForgeryObject()
    local iplStyle = GetIPLStyleFromEquipment(businessData.equipment)
    local equipmentStyle = GetEquipmentStyle(businessData.equipment)
    
    -- Set interior style
    documentForgery.Style.Set(documentForgery.Style[iplStyle])
    
    -- Set equipment style
    documentForgery.Equipment.Set(documentForgery.Equipment[equipmentStyle])
    
    -- Set security level
    local securityLevel = documentForgery.Security.basic
    if businessData.security and documentForgery.Security.upgrade then
        securityLevel = documentForgery.Security.upgrade
    end
    documentForgery.Security.Set(securityLevel)
    
    -- Configure interior details
    documentForgery.Details.Enable(documentForgery.Details.production, true)
    documentForgery.Details.Enable(documentForgery.Details.Chairs, false)
    documentForgery.Details.Enable(documentForgery.Details.furnitures, true)
    
    RefreshInterior(documentForgery.interiorId)
    
    -- Create product props based on stored products
    if businessData then
        CreateProductProps(businessData.products)
    end
    
    -- Play employee animation scenes
    if businessData.employees ~= "none" then
        Scenes.play(animationScenes, businessData, additionalData)
    end
end

function IPLs.document_forgery.unload()
    local documentForgery = exports.bob74_ipl:GetBikerDocumentForgeryObject()
    
    -- Load default configuration
    documentForgery.LoadDefault()
    
    RefreshInterior(documentForgery.interiorId)
    
    -- Clear all active props
    ClearActiveProps()
    
    -- Stop animation scenes
    Scenes.stop()
end

function IPLs.document_forgery.softReload()
    -- ⚠️ NOTE: Original code uses global 'data' variable here, but the function signature has no parameters
    -- This appears to be a bug in the original decompiled code. The softReload should receive businessData.
    if data then
        ClearActiveProps()
        CreateProductProps(data.products)
    end
end