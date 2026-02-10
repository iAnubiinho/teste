QBCore = exports['qb-core']:GetCoreObject()

----- TARGETS ---------------
if Config.Target == "ox" or Config.Target == "qtarget" then
    exports.qtarget:AddBoxZone("placedrillcasino", vector3(957.02, 31.38, 71.81), 3.4, 0.4, {
        name = "placedrillcasino",
        heading = 328,
        debugPoly = false,
        minZ = 71.0,
        maxZ = 73.0
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local thermald = exports.ox_inventory:Search(2, 'thermaldrill')
                        if thermald > 0 then
                            CasinoVaultDrill()
                        else
                            Notifi({ title = Config.title, text = Text('nothermaldrill'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-casinoheist:getthermal', function(thermald)
                            if thermald > 0 then
                                CasinoVaultDrill()
                            else
                                Notifi({ title = Config.title, text = Text('nothermaldrill'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'thermaldrill')
                    end
                end,
                icon = "fa-solid fa-explosion",
                label = Text("placedrill"),
            },
        },
        job = {"all"},
        distance = 3.0
    })
for k, v in pairs(Config.Panels) do
        exports.qtarget:AddBoxZone("CasinoPanels"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
            name = "CasinoPanels"..k,
            heading = v.heading,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    action = function()
                        if Config.inventory == 'ox' then
                            local usb = exports.ox_inventory:Search(2, 'hack_usb')
                            if usb > 0 then
                                CasinoPanelsMinigame(k, success)
                            else
                                Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        elseif Config.inventory == 'other' then
                            QBCore.Functions.TriggerCallback('estrp-casinoheist:getusb', function(usbamount)
                                if usbamount > 0 then
                                    CasinoPanelsMinigame(k, success)
                                else
                                    Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                                end
                            end, 'hack_usb')
                        end
                    end,
                    icon = "fa-brands fa-nfc-directional",
                    label = Text("hackpanel"),
                },
            },
            distance = 3.5,
        })
    end
for k, v in pairs(Config.PCS) do
    exports.qtarget:AddBoxZone("CasinoPC"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoPC"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local usb = exports.ox_inventory:Search(2, 'hack_usb')
                        if usb and usb > 0 then
                            CasinoPCHack(k)
                        else
                            Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-casinoheist:getusb', function(usb)
                            if usb and usb > 0 then
                                CasinoPCHack(k)
                            else
                                Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'hack_usb')
                    end
                end,
                icon = "fa-solid fa-laptop-code",
                label = Text("hackpac"),
                canInteract = function()
                    if v["isHacked"] or v["isBusy"] then 
                        return false
                    end
                    return true
                end,
            },
        },
        job = {"all"},
        distance = 3.0
    })    
end
for k, v in pairs(Config.C4placements) do
    exports.qtarget:AddBoxZone("CasinoC4Placements"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoC4Placements"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ
    }, {
        options = { 
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local c4stick = exports.ox_inventory:Search(2, 'c4_stick')
                        if c4stick and c4stick > 0 then
                            PlantC4(k)
                        else
                            Notifi({ title = Config.title, text = Text('noc4'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-casinoheist:getc4', function(c4stick)
                            if c4stick and c4stick > 0 then
                                PlantC4(k)
                            else
                                Notifi({ title = Config.title, text = Text('noc4'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'c4_stick')
                    end
                end,
                icon = 'fa-solid fa-bomb', 
                label = Text("plantc4"), 
                canInteract = function()
                if v["isBlown"] or v["isBusy"] then 
                    return false
                end
                return true
            end,
            },
        },
        job = {"all"}, 
        distance = 1.5, 
    })
end


for k, v in pairs(Config.Fuseboxes) do
    exports.qtarget:AddBoxZone("CasinoFuseBoxZone"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoFuseBoxZone"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
    options = {
        {
            action = function()
            CasinoFuseBoxBreakMinigame(k, success)
            end,
            icon = "fa-solid fa-plug-circle-xmark",
            label = Text("open"),
            canInteract = function()
                if Casinoheiststarted then
                    return false
                end
                return true
            end,
        },
    },
    distance = 3.5,
})
end

for k, v in pairs(Config.Minisafes) do
    exports.qtarget:AddBoxZone("CasinoMiniSafe"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoMiniSafe"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                    CasinoSafeCrackMinigame(k)
                end,
                icon = "fa-brands fa-nfc-directional",
                label = Text("openminisafe"),
                canInteract = function()
                    if v["isTaken"] or v["Busy"] then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })
end

for k, v in pairs(Config.GoldTrolleys) do
    exports.qtarget:AddBoxZone("GoldTrolleys"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "GoldTrolleys"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                    GrabGold(k)
                end,
                icon = "fa-solid fa-box",
                label = Text("grab"),
                canInteract = function()
                    if v["IsTaken"] or v["isBusy"] then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })
end

for k, v in pairs(Config.CashTrolleys) do
    exports.qtarget:AddBoxZone("CashTrolleys"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CashTrolleys"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                    GrabCash(k)
                end,
                icon = "fa-solid fa-box",
                label = Text("grab"),
                canInteract = function()
                    if v["IsTaken"] or v["isBusy"] then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })
end

for k, v in pairs(Config.Paintings) do
    exports.qtarget:AddBoxZone("CasinoPainting"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoPainting"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                if Config.inventory == 'ox' then
                    local knife = exports.ox_inventory:Search(2, 'WEAPON_SWITCHBLADE')
                        if knife > 0 then
                            Stealpainting(k)  
                        else
                            Notifi({ title = Config.title, text = Text('noknife'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                    QBCore.Functions.TriggerCallback('estrp-casinoheist:getknife', function(knife)
                        if knife > 0 then
                            Stealpainting(k)
                        else
                            Notifi({ title = Config.title, text = Text('noknife'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    end, 'WEAPON_SWITCHBLADE')
                end
            end,
                icon = "fa-solid fa-image",
                label = Text("takepainting"),
                canInteract = function()
                    if v["IsTaken"] or v["isBusy"] then 
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })
end

for k, v in pairs(Config.DrillTargets) do
    exports.qtarget:AddBoxZone("CasinoBoxes"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoBoxes"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local drill = exports.ox_inventory:Search(2, 'large_drill')
                            if drill > 0 then
                                Drill(v.box or 1, k)  
                            else
                                Notifi({ title = Config.title, text = Text('nodrill'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-casinoheist:getdrillamount', function(drill)
                            if drill > 0 then
                                Drill(v.box or 1, k) 
                            else
                                Notifi({ title = Config.title, text = Text('nodrill'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'large_drill')
                    end
                end,
                icon = "fa-solid fa-lock",
                label = Text("drill"),
                canInteract = function()
                    if v.isOpened or v.isBusy then
                        return false
                    end
                    return true
                end,
            },
        },
        job = {"all"},
        distance = 1.5,
    })
end

exports.qtarget:AddBoxZone("CasinoVitrine", vector3(974.65, 20.37, 71.81), 1, 1, {
    name = "CasinoVitrine",
    heading = 330,
    debugPoly = false,
    minZ = 71.0,
    maxZ = 73.0,
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local cutter = exports.ox_inventory:Search(2, 'cutter')
                        if cutter > 0 then
                      GlassCuttingScene()
                        else
                            Notifi({ title = Config.title, text = Text('nocutter'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-casinoheist:getcutter', function(cutter)
                            if cutter > 0 then
                            GlassCuttingScene()
                        else
                            Notifi({ title = Config.title, text = Text('nocutter'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                       end, 'cutter')
                    end
                end,
                icon = "fa-regular fa-gem",
                label = Text("cutglass"),
            },
        },
    job = {"all"},
    distance = 1.5,
})

for k, v in pairs(Config.SceneStacks) do
    exports.qtarget:AddBoxZone("CasinoStacks"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoStacks"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                    GrabbingScene(k)
                end,
                icon = "fa-solid fa-box",
                label = Text("grab"),
                canInteract = function()
                    if v.IsTaken or v.isBusy then
                        return false
                    end
                    return true
                end,
            },
        },
        job = {"all"},
        distance = 1.5,
    })
end
elseif Config.Target == "qb" then
    exports['qb-target']:AddBoxZone("placedrillcasino", vector3(957.02, 31.38, 71.81), 3.4, 0.4, {
        name = "placedrillcasino",
        heading = 328,
        debugPoly = false,
        minZ = 71.0,
        maxZ = 73.0
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local thermalDrillCount = exports.ox_inventory:Search(2, 'thermaldrill') -- Search for thermal drill
                        if thermalDrillCount and thermalDrillCount > 0 then
                            CasinoVaultDrill() -- Trigger the drill function
                        else
                            Notifi({
                                title = Config.title,
                                text = Text('nothermaldrill'), -- No thermal drill message
                                icon = 'fa-solid fa-toolbox',
                                color = '#ff0000'
                            })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-casinoheist:getthermal', function(thermalDrillCount)
                            if thermalDrillCount and thermalDrillCount > 0 then
                                CasinoVaultDrill() -- Trigger the drill function
                            else
                                Notifi({
                                    title = Config.title,
                                    text = Text('nothermaldrill'), -- No thermal drill message
                                    icon = 'fa-solid fa-toolbox',
                                    color = '#ff0000'
                                })
                            end
                        end, 'thermaldrill')
                    end
                end,
                icon = "fa-solid fa-explosion",
                label = Text("placedrill"), -- Label for the interaction
            },
        },
        job = {"all"}, -- Accessible to all jobs
        distance = 3.0 -- Interaction distance
    })
for k, v in pairs(Config.Panels) do
    exports['qb-target']:AddBoxZone("CasinoPanels"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
            name = "CasinoPanels"..k,
            heading = v.heading,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ,
        }, {
            options = {
                {
                    action = function()
                        if Config.inventory == 'ox' then
                            local usb = exports.ox_inventory:Search(2, 'hack_usb')
                            if usb > 0 then
                                CasinoPanelsMinigame(k, success)
                            else
                                Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        elseif Config.inventory == 'other' then
                            QBCore.Functions.TriggerCallback('estrp-casinoheist:getusb', function(usbamount)
                                if usbamount > 0 then
                                    CasinoPanelsMinigame(k, success)
                                else
                                    Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                                end
                            end, 'hack_usb')
                        end
                    end,
                    icon = "fa-brands fa-nfc-directional",
                    label = Text("hackpanel"),
                },
            },
            distance = 3.5,
        })
    end
for k, v in pairs(Config.PCS) do
    exports['qb-target']:AddBoxZone("CasinoPC"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoPC"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local usb = exports.ox_inventory:Search(2, 'hack_usb')
                        if usb and usb > 0 then
                            CasinoPCHack(k)
                        else
                            Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-casinoheist:getusb', function(usb)
                            if usb and usb > 0 then
                                CasinoPCHack(k)
                            else
                                Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'hack_usb')
                    end
                end,
                icon = "fa-solid fa-laptop-code",
                label = Text("hackpac"),
                canInteract = function()
                    if v["isHacked"] or v["isBusy"] then 
                        return false
                    end
                    return true
                end,
            },
        },
        job = {"all"},
        distance = 3.0
    })    
end
for k, v in pairs(Config.C4placements) do
    exports['qb-target']:AddBoxZone("CasinoC4Placements"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoC4Placements"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ
    }, {
        options = { 
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local c4stick = exports.ox_inventory:Search(2, 'c4_stick')
                        if c4stick and c4stick > 0 then
                            PlantC4(k)
                        else
                            Notifi({ title = Config.title, text = Text('noc4'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-casinoheist:getc4', function(c4stick)
                            if c4stick and c4stick > 0 then
                                PlantC4(k)
                            else
                                Notifi({ title = Config.title, text = Text('noc4'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'c4_stick')
                    end
                end,
                icon = 'fa-solid fa-bomb', 
                label = Text("plantc4"), 
                canInteract = function()
                if v["isBlown"] or v["isBusy"] then 
                    return false
                end
                return true
            end,
            },
        },
        job = {"all"}, 
        distance = 1.5, 
    })
end


for k, v in pairs(Config.Fuseboxes) do
    exports['qb-target']:AddBoxZone("CasinoFuseBoxZone"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoFuseBoxZone"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
    options = {
        {
            action = function()
            CasinoFuseBoxBreakMinigame(k, success)
            end,
            icon = "fa-solid fa-plug-circle-xmark",
            label = Text("open"),
            canInteract = function()
                if Casinoheiststarted then
                    return false
                end
                return true
            end,
        },
    },
    distance = 3.5,
})
end

for k, v in pairs(Config.Minisafes) do
    exports['qb-target']:AddBoxZone("CasinoMiniSafe"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoMiniSafe"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                    CasinoSafeCrackMinigame(k)
                end,
                icon = "fa-brands fa-nfc-directional",
                label = Text("openminisafe"),
                canInteract = function()
                    if v["isTaken"] or v["Busy"] then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })
end

for k, v in pairs(Config.GoldTrolleys) do
    exports['qb-target']:AddBoxZone("GoldTrolleys"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "GoldTrolleys"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                    GrabGold(k)
                end,
                icon = "fa-solid fa-box",
                label = Text("grab"),
                canInteract = function()
                    if v["IsTaken"] or v["isBusy"] then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })
end

for k, v in pairs(Config.CashTrolleys) do
    exports['qb-target']:AddBoxZone("CashTrolleys"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CashTrolleys"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                    GrabCash(k)
                end,
                icon = "fa-solid fa-box",
                label = Text("grab"),
                canInteract = function()
                    if v["IsTaken"] or v["isBusy"] then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })
end

for k, v in pairs(Config.Paintings) do
    exports['qb-target']:AddBoxZone("CasinoPainting"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoPainting"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                if Config.inventory == 'ox' then
                    local knife = exports.ox_inventory:Search(2, 'WEAPON_SWITCHBLADE')
                        if knife > 0 then
                            Stealpainting(k)  
                        else
                            Notifi({ title = Config.title, text = Text('noknife'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                    QBCore.Functions.TriggerCallback('estrp-casinoheist:getknife', function(knife)
                        if knife > 0 then
                            Stealpainting(k)
                        else
                            Notifi({ title = Config.title, text = Text('noknife'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    end, 'WEAPON_SWITCHBLADE')
                end
            end,
                icon = "fa-solid fa-image",
                label = Text("takepainting"),
                canInteract = function()
                    if v["IsTaken"] or v["isBusy"] then 
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })
end

for k, v in pairs(Config.DrillTargets) do
    exports['qb-target']:AddBoxZone("pacificbankBox"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "pacificbankBox"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local drill = exports.ox_inventory:Search(2, 'large_drill')
                            if drill > 0 then
                                Drill(v.box or 1, k)  
                            else
                                Notifi({ title = Config.title, text = Text('nodrill'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-casinoheist:getdrillamount', function(drill)
                            if drill > 0 then
                                Drill(v.box or 1, k) 
                            else
                                Notifi({ title = Config.title, text = Text('nodrill'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'large_drill')
                    end
                end,
                icon = "fa-solid fa-lock",
                label = Text("drill"),
                canInteract = function()
                    if v.isOpened or v.isBusy then
                        return false
                    end
                    return true
                end,
            },
        },
        job = {"all"},
        distance = 1.5,
    })
end

exports['qb-target']:AddBoxZone("CasinoVitrine", vector3(974.65, 20.37, 71.81), 1, 1, {
    name = "CasinoVitrine",
    heading = 330,
    debugPoly = false,
    minZ = 71.0,
    maxZ = 73.0,
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local cutter = exports.ox_inventory:Search(2, 'cutter')
                        if cutter > 0 then
                      GlassCuttingScene()
                        else
                            Notifi({ title = Config.title, text = Text('nocutter'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-casinoheist:getcutter', function(cutter)
                            if cutter > 0 then
                            GlassCuttingScene()
                        else
                            Notifi({ title = Config.title, text = Text('nocutter'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                       end, 'cutter')
                    end
                end,
                icon = "fa-regular fa-gem",
                label = Text("cutglass"),
            },
        },
    job = {"all"},
    distance = 1.5,
})

for k, v in pairs(Config.SceneStacks) do
    exports['qb-target']:AddBoxZone("CasinoStacks"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "CasinoStacks"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                    GrabbingScene(k)
                end,
                icon = "fa-solid fa-box",
                label = Text("grab"),
                canInteract = function()
                    if v.IsTaken or v.isBusy then
                        return false
                    end
                    return true
                end,
            },
        },
        job = {"all"},
        distance = 1.5,
    })
    end
end

function CasinoSafeCrackMinigame(k)
    -- Animation dictionaries
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local animDict = 'anim_heist@arcade_property@arcade_safe_open@male@'
    loadAnimDict(animDict)
    loadAnimDict("mini@safe_cracking")
    loadAnimDict("anim@am_hold_up@male")

    TriggerServerEvent('estrp-casinoheist:server:SetSafeState', 'isBusy', true, k)

    Safe = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('ch_prop_ch_arcade_safe_door'), 0, 0, 0)
    
    if not Safe then
        print("No safe object found near player!")
        return
    end

    ScenPosition = GetOffsetFromEntityInWorldCoords(Safe, 6.15, 1.192, -2.38)
    ScenRotation = GetEntityRotation(Safe) + vector3(0.0, 0.0, 90.0)

    CrackingScene = NetworkCreateSynchronisedScene(GetOffsetFromEntityInWorldCoords(Safe, -0.8, -0.0, -0.78), ScenRotation, 2, false, true, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, CrackingScene, "mini@safe_cracking", 'dial_turn_clock_normal', 1.5, -4.0, 1, 16, 1148846080, 0)

    NetworkStartSynchronisedScene(CrackingScene)

    local locks = math.random(2, 3)
	local success = exports['minigames']:Lockpick("Lockpick", locks, 30)
        if success then
            TriggerServerEvent('estrp-casinoheist:server:SetSafeState', 'isBusy', false, k)
            TriggerServerEvent('estrp-casinoheist:server:SetSafeState', 'isTaken', true, k)
            ClearPedTasks(ped)
            OpenCasinoMinisafe(k)
        else
        TriggerServerEvent('estrp-casinoheist:server:SetSafeState', 'isBusy', false, k)
        ClearPedTasks(ped)
    end
end

function CasinoPCHack(k)
    -- Configuration table for each PC (k) with customizable minigame difficulties
    local difficultyConfig = {
        [1] = {keys = math.random(10, 20), timeLimit = 13}, -- Staircase door
        [2] = {keys = math.random(10, 20), timeLimit = 13},   -- Vault cell
        [3] = {keys = math.random(10, 20), timeLimit = 13},   -- Multiple doors
        [4] = {keys = math.random(10, 20), timeLimit = 13}    -- Elevator and garage
    }

    -- Retrieve configuration for the current PC (k)
    local config = difficultyConfig[k] or {keys = 1, timeLimit = 30} -- Default values if k is not configured
    local keys = config.keys
    local timeLimit = config.timeLimit

    if k == 1 then
        TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isBusy', true, k)
        local success = exports['minigames']:Chopping(keys, timeLimit)
        if success then
            pchacked = true
            lib.progressBar({
                duration = Config.durationhacking,
                label = Text("hacking"),
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    combat = true,
                    move = true,
                },
                anim = {
                    dict = 'anim@heists@ornate_bank@hack_heels',
                    clip = 'hack_loop'
                },
            }) 
            TriggerServerEvent("estrp-casinoheist:server:synced", "openstaircasedoor")
            TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isHacked', true, k)
            Notifi({ title = Config.title, text = Text('staircasedooropen'), icon = 'fa-solid fa-door-open', color = '#32a852' })
        end
        TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isBusy', false, k)

    elseif k == 2 then
        TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isBusy', true, k)
        local success = exports['minigames']:Chopping(keys, timeLimit)
        if success then
            pchacked = true
            lib.progressBar({
                duration = Config.durationhacking,
                label = Text("hacking"),
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    combat = true,
                    move = true,
                },
                anim = {
                    dict = 'anim@heists@ornate_bank@hack_heels',
                    clip = 'hack_loop'
                },
            }) 
            TriggerServerEvent("estrp-casinoheist:server:synced", "vaultcellopen")
            TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isHacked', true, k)
            Notifi({ title = Config.title, text = Text('vaultcellopened'), icon = 'fa-solid fa-door-open', color = '#32a852' })
        end
        TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isBusy', false, k)

    elseif k == 3 then
        TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isBusy', true, k)
        local info = lib.alertDialog({
            header = Text("infoheader"),
            content = Text("PC2"),
            centered = true,
            cancel = true
        })
        if info == 'confirm' then
            local success = exports['minigames']:Chopping(keys, timeLimit)
            if success then
                pchacked = true
                lib.progressBar({
                    duration = Config.durationhacking,
                    label = Text("hacking"),
                    useWhileDead = false,
                    canCancel = false,
                    disable = {
                        car = true,
                        combat = true,
                        move = true,
                    },
                    anim = {
                        dict = 'anim@heists@ornate_bank@hack_heels',
                        clip = 'hack_loop'
                    },
                }) 
                TriggerServerEvent("estrp-casinoheist:server:synced", "tostaircase")
                TriggerServerEvent("estrp-casinoheist:server:synced", "togarage")
                TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isHacked', true, k)
                Notifi({ title = Config.title, text = Text('doorunlocked'), icon = 'fa-solid fa-door-open', color = '#32a852' })
            end
        end
        TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isBusy', false, k)

    elseif k == 4 then
        TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isBusy', true, k)
        local info = lib.alertDialog({
            header = Text("infoheader"),
            content = Text("PC1"),
            centered = true,
            cancel = true
        })
        if info == 'confirm' then
            local success = exports['minigames']:Chopping(keys, timeLimit)
            if success then
                pchacked = true
                lib.progressBar({
                    duration = Config.durationhacking,
                    label = Text("hacking"),
                    useWhileDead = false,
                    canCancel = false,
                    disable = {
                        car = true,
                        combat = true,
                        move = true,
                    },
                    anim = {
                        dict = 'anim@heists@ornate_bank@hack_heels',
                        clip = 'hack_loop'
                    },
                }) 
                TriggerServerEvent("estrp-casinoheist:server:synced", "elevator")
                TriggerServerEvent("estrp-casinoheist:server:synced", "garagesliders")
                TriggerServerEvent("estrp-casinoheist:server:synced", "garage")
                TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isHacked', true, k)
                Notifi({ title = Config.title, text = Text('doorunlocked'), icon = 'fa-solid fa-door-open', color = '#32a852' })
            end
        end
        TriggerServerEvent('estrp-casinoheist:server:setPCState', 'isBusy', false, k)
    end
end



function CasinoPanelsMinigame(k)
    -- Configuration table for each key (k) with recalculated time limits
    local difficultyConfig = {
        [1] = {keys = math.random(18, 26), timeLimit = 15},    -- Medium-Hard
        [2] = {keys = math.random(15, 20), timeLimit = 15},    -- Medium-Hard
        [3] = {keys = math.random(15, 20), timeLimit = 15},    -- Medium-Hard
        [4] = {keys = math.random(15, 20), timeLimit = 15},    -- Medium-Hard
        [5] = {keys = math.random(15, 20), timeLimit = 15},    -- Medium-Hard
        [6] = {keys = math.random(18, 26), timeLimit = 15},    -- Medium-Hard
        [7] = {keys = math.random(15, 20), timeLimit = 15},    -- Medium-Hard
        [8] = {keys = math.random(15, 20), timeLimit = 15},    -- Medium-Hard
        [9] = {keys = math.random(15, 20), timeLimit = 15},    -- Medium-Hard
        [10] = {keys = math.random(15, 20), timeLimit = 15},   -- Medium-Hard
        [11] = {keys = math.random(15, 20), timeLimit = 15}    -- Medium-Hard
    }

    -- Perform the police count check only if k == 1 or k == 6
    if k == 1 or k == 6 then
        QBCore.Functions.TriggerCallback('estrp-casinoheist:server:checkPoliceCount', function(status)
            if status then
                QBCore.Functions.TriggerCallback('estrp-casinoheist:server:checkTime', function(time)
                    if time then
                        TriggerEvent("estrp-casinoheist:client:PanelAction", k)
                        Wait(3000)

                        -- Get the configuration for the current key (k)
                        local config = difficultyConfig[k] or difficultyConfig[1]
                        local locks = config.keys
                        local timeLimit = config.timeLimit

                        local success = exports['minigames']:Chopping(locks, timeLimit)

                        if success then
                            TriggerEvent("estrp-casinoheist:client:OpenDoor", k, success)
                            TriggerServerEvent("estrp-casinoheist:server:bankrefresh")
                        else
                            TriggerEvent("estrp-casinoheist:client:OpenDoor", k)
                            TriggerServerEvent("estrp-casinoheist:server:failedrobbery")
                        end
                    end
                end)
            end
        end)
    else
        QBCore.Functions.TriggerCallback('estrp-casinoheist:server:checkPoliceCount', function(status)
            if status then
                TriggerEvent("estrp-casinoheist:client:PanelAction", k)
                Wait(3000)

                -- Get the configuration for the current key (k)
                local config = difficultyConfig[k] or difficultyConfig[1]
                local locks = config.keys
                local timeLimit = config.timeLimit

                local success = exports['minigames']:Chopping(locks, timeLimit)

                if success then
                    TriggerEvent("estrp-casinoheist:client:OpenDoor", k, success)
                else
                    TriggerEvent("estrp-casinoheist:client:OpenDoor", k)
                end
            end
        end)
    end
end



function CasinoFuseBoxBreakMinigame(k, success)
    if k == 1 then
        QBCore.Functions.TriggerCallback('estrp-casinoheist:server:checkPoliceCount', function(status)
            if status then
                QBCore.Functions.TriggerCallback('estrp-casinoheist:server:checkTime', function(time)
                    if time then
                        TriggerEvent("estrp-casinoheist:client:OpenBox", k)
                        Wait(3000)
                        local locks = math.random(1, 4) -- Random number of locks
                        local success = exports['minigames']:Lockpick("Lockpick", locks, 30)

                        if success then
                            TriggerEvent("estrp-casinoheist:client:CloseBox", k, success)
                            TriggerServerEvent("estrp-casinoheist:server:bankrefresh")
                            local pos = vector3(896.81, -0.35, 78.89)
                            loadPtfxAsset('core')
                            UseParticleFxAssetNextCall('core')
                            local ptfx = StartParticleFxLoopedAtCoord("ent_sht_electrical_box", pos, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            Wait(10000)
                            StopParticleFxLooped(ptfx, 0)
                        else
                            TriggerEvent("estrp-casinoheist:client:CloseBox", k)
                            TriggerServerEvent("estrp-casinoheist:server:failedrobbery")
                        end
                    end
                end)
            end
        end)
    end
end


---- Animation
function playAnim(animDict, animName, duration, flag)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, -8.0, -8, duration, flag, 0, 0, 0, 0)
end




---- Police Alert

------- / Function for getting the street name on alert message.
function GetCurrentStreetName()
    local pedCoords = GetEntityCoords(PlayerPedId())

    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(pedCoords["x"], pedCoords["y"], pedCoords["z"], currentStreetHash, intersectStreetHash)
    local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

    return currentStreetName
end

------- / Robbery notification
RegisterNetEvent('estrp-casinoheist:robberyinprogress')
AddEventHandler('estrp-casinoheist:robberyinprogress',function(playerCoords,currentStreetName)
    local PlayerData = QBCore.Functions.GetPlayerData()
	if PlayerData.job.name == "police" then
        Notifi({ title = Config.title, text = Text('casinorobbery').. " " .. currentStreetName, duration = 10000, icon = 'fa-solid fa-laptop-code', color = '#ff0000' })
        RemoveBlip(blipcasinorob)
        blipcasinorob = AddBlipForCoord(playerCoords)
        SetBlipSprite(blipcasinorob , 161)
        SetBlipScale(blipcasinorob , 2.0)
        SetBlipColour(blipcasinorob, 3)
        PulseBlip(blipcasinorob)
        Wait(100000)
        RemoveBlip(blipcasinorob)
        
        end
    end)

function Policenotify()
        local playerCoords = GetEntityCoords(PlayerPedId(-1))
        local currentStreetName = GetCurrentStreetName()
        TriggerServerEvent('estrp-casinoheist:robberyinprogress', playerCoords,currentStreetName)
end