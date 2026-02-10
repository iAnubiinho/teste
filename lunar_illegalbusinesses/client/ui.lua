-- UI Management Module

UI = {}

-- Opens a UI panel with the specified name and arguments
function UI.open(panelName, args, enableCursor)
    SendNUIMessage({
        action = "open",
        data = {
            name = panelName,
            args = args
        }
    })
    
    if enableCursor then
        SetNuiFocus(true, true)
    end
end

-- Updates an existing UI panel with new data
function UI.update(panelName, args, enableCursor)
    SendNUIMessage({
        action = "update",
        data = {
            name = panelName,
            args = args
        }
    })
    
    if enableCursor then
        SetNuiFocus(true, true)
    end
end

-- Hides all UI panels and releases focus
function UI.hide()
    SendNUIMessage({
        action = "setVisible",
        data = false
    })
    SetNuiFocus(false, false)
end

-- NUI Callback: Hide UI from web interface
RegisterNUICallback("hideUI", function(data, cb)
    SetNuiFocus(false, false)
    cb({})
    Wait(200)
    TriggerEvent("lunar_illegalbusiness:hideUI")
end)

-- NUI Callback: Get application settings for web interface
RegisterNUICallback("getSettings", function(data, cb)
    local equipmentMultiplier = (Config.product.multipliers.equipmentUpgrade - 1.0) * 100
    local employeesMultiplier = (Config.product.multipliers.employeeUpgrade - 1.0) * 100
    local overlayPosition = Config.overlayPosition or "bottom: 2.5rem; right: 2.5rem;"
    local currency = Config.currency or { symbol = "$", icon = "dollar-sign" }
    
    cb({
        locales = lib.getLocales(),
        constants = {
            equipment = Config.equipment.upgradePrice,
            employees = Config.employees.upgradePrice,
            security = Config.security.price,
            supplies = Config.supplies.price,
            sellDivisor = Config.ped.sell.divisor,
            equipmentMultiplier = equipmentMultiplier,
            employeesMultiplier = employeesMultiplier,
            overlayPosition = overlayPosition,
            currency = currency
        }
    })
end)