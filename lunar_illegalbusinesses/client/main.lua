-- Main Client Entry Point - Business Access and Interaction Management

-- Business access tracking
businessAccess = {}
interactionPoints = {}
businessBlips = {}

-- Returns all businesses the player has access to
function GetBusinesses()
    return businessAccess
end

-- Checks if player is the owner of a specific business
function IsOwner(businessName)
    return businessAccess[businessName] == true
end

-- Checks if player has any access to a specific business
function HasAccess(businessName)
    return businessAccess[businessName] ~= nil
end

-- Refreshes all interaction points and blips based on current access
function RefreshBusinessInteractions(newAccess)
    businessAccess = newAccess or businessAccess
    
    -- Clean up existing interaction points
    for _, point in ipairs(interactionPoints) do
        point.remove()
    end
    table.wipe(interactionPoints)
    
    -- Clean up existing blips
    for _, blip in ipairs(businessBlips) do
        blip.remove()
    end
    table.wipe(businessBlips)
    
    -- Create new interaction points and blips for accessible businesses
    for businessName, accessLevel in pairs(businessAccess) do
        if accessLevel ~= nil then
            local locationConfig = Config.locations[businessName]
            local businessTypeConfig = Config.businessTypes[locationConfig.type]
            
            -- Create interaction point
            local interactionPoint = Utils.createInteractionPoint({
                coords = locationConfig.target,
                radius = 1.0,
                options = {
                    {
                        label = locale("enter_business"),
                        icon = businessTypeConfig.icon,
                        onSelect = function()
                            Interior.enter(businessName, true)
                        end,
                        canInteract = function()
                            return not IsTeleporting()
                        end
                    }
                }
            })
            interactionPoints[#interactionPoints + 1] = interactionPoint
            
            -- Create map blip
            local blip = Utils.createBlip(locationConfig.coords, businessTypeConfig.blip)
            SetBlipPriority(blip.value, 9)
            businessBlips[#businessBlips + 1] = blip
        end
    end
end

-- Spawn security cameras for business locations
CreateThread(function()
    for _, locationConfig in pairs(Config.locations) do
        if locationConfig.spawnCamera then
            Utils.createProp(locationConfig.camera, {
                model = 548760764,
                rotation = vector3(0.0, 0.0, 180.0)
            })
        end
    end
end)

-- Load player's business access when they join
Framework.onPlayerLoaded(function()
    lib.callback("lunar_illegalbusiness:getBusinessesAccess", 2000, RefreshBusinessInteractions)
end)

-- Handle adding access to a business
RegisterNetEvent("lunar_illegalbusiness:addAccess", function(businessName, accessLevel)
    businessAccess[businessName] = accessLevel
    RefreshBusinessInteractions()
end)

-- Handle removing access from a business
RegisterNetEvent("lunar_illegalbusiness:removeAccess", function(businessName)
    businessAccess[businessName] = nil
    RefreshBusinessInteractions()
end)