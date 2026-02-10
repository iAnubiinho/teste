QBCore = exports['qb-core']:GetCoreObject()
----- TARGETS ---------------
if Config.Target == "ox" or Config.Target == "qtarget" then
   exports.qtarget:AddBoxZone("ArtCellDoorR", vector3(33.22, 135.36, 92.79), 0.2, 1.4, {
        name = "ArtCellDoorR",
        heading = 340,
        debugPoly = false,
        minZ = 92.0,
        maxZ = 94.0
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local thermite = exports.ox_inventory:Search(2, 'thermite')
                        if thermite and thermite > 0 then
                            ArtThermiteMinigame()
                        else
                            Notifi({
                                title = Config.title,
                                text = Text('nothermite'),
                                icon = 'fa-solid fa-toolbox',
                                color = '#ff0000'
                            })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getthermite', function(thermite)
                            if thermite and thermite > 0 then
                                ArtThermiteMinigame()
                            else
                                Notifi({
                                    title = Config.title,
                                    text = Text('nothermite'),
                                    icon = 'fa-solid fa-toolbox',
                                    color = '#ff0000'
                                })
                            end
                        end, 'thermite')
                    end
                end,
                icon = "fa-solid fa-bomb",
                label = Text("plantthermite"),
                canInteract = function()
                    if garageblown then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })

    exports.qtarget:AddBoxZone("ArtCellDoorL", vector3(36.89, 145.29, 92.79), 0.4, 1.4, {
        name = "ArtCellDoorL",
        heading = 340,
        debugPoly = false,
        minZ = 92.0,
        maxZ = 94.0
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local thermite = exports.ox_inventory:Search(2, 'thermite')
                        if thermite and thermite > 0 then
                            ArtThermiteMinigame()
                        else
                            Notifi({
                                title = Config.title,
                                text = Text('nothermite'),
                                icon = 'fa-solid fa-toolbox',
                                color = '#ff0000'
                            })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getthermite', function(thermite)
                            if thermite and thermite > 0 then
                                ArtThermiteMinigame()
                            else
                                Notifi({
                                    title = Config.title,
                                    text = Text('nothermite'),
                                    icon = 'fa-solid fa-toolbox',
                                    color = '#ff0000'
                                })
                            end
                        end, 'thermite')
                    end
                end,
                icon = "fa-solid fa-bomb",
                label = Text("plantthermite"),
                canInteract = function()
                    if garageblown then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })

    exports.qtarget:AddBoxZone("ArtMaindoor", vector3(11.42, 148.95, 93.24), 2.6, 0.4, {
        name = "ArtMaindoor",
        heading = 340,
        debugPoly = false,
        minZ = 93.5,
        maxZ = 95.0
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local lockpick = exports.ox_inventory:Search(2, 'lockpick')
                        if lockpick > 0 then
                            ArtDoorlockMinigame()
                        else
                            Notifi({ title = Config.title, text = Text('nolockpick'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getlockpick', function(thermite)
                            if lockpick > 0 then
                                ArtDoorlockMinigame()
                            else
                                Notifi({ title = Config.title, text = Text('nolockpick'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'lockpick')
                    end
                end,
                icon = "fa-solid fa-key",
                label = Text("lockpick")
            },
        },
        distance = 3.0,
        job = {"all"}
    })   

    exports.qtarget:AddBoxZone("ArtOfficePC", vector3(16.36, 158.59, 92.79), 0.6, 1.0, {
        name = "ArtOfficePC",
        heading = 327,
        debugPoly = false,
        minZ = 92.0,
        maxZ = 94.0
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local usb = exports.ox_inventory:Search(2, 'hack_usb')
                        if usb and usb > 0 then
                            ArtPCHack()
                        else
                            Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getusb', function(usb)
                            if usb and usb > 0 then
                                ArtPCHack()
                            else
                                Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'hack_usb')
                    end
                end,
                icon = "fa-solid fa-laptop-code",
                label = Text("hackpac"),
            },
        },
        job = {"all"},
        distance = 3.0
    })    
    exports.qtarget:AddBoxZone("ArtVaultPanel", vector3(15.48, 140.23, 93.79), 0.45, 0.65, {
        name = "ArtVaultPanel",
        heading = 338,
        debugPoly = false,
        minZ = 93.5,
        maxZ = 94.3
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local usb = exports.ox_inventory:Search(2, 'hack_usb')
                        if usb and usb > 0 then
                            VaultPanelAction()
                        else
                            Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getusb', function(usb)
                            if usb and usb > 0 then
                                VaultPanelAction()
                            else
                                Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'hack_usb')
                    end
                end,
                icon = "fa-solid fa-laptop-code",
                label = Text("hackpanel"),
            },
        },
        job = {"all"},
        distance = 3.0
    })    
    exports.qtarget:AddBoxZone("GalleryShutters", vector3(17.25, 144.87, 93.79), 0.3, 0.3, {
        name = "GalleryShutters",
        heading = 340,
        debugPoly = false,
        minZ = 93.4,
        maxZ = 94.3
    }, {
        options = {
            {
                action = function()
                OpenShutters()
                end,
                icon = "fa-solid fa-toggle-off",
                label = Text("openshutters"),
                canInteract = function()
                    if not sliderinteraction then
                        return false
                    end
                    return true
                end,
            },
        },
        job = {"all"},
        distance = 3.0
    })    
for k, v in pairs(Config.Locations) do
    exports.qtarget:AddBoxZone("ArtGalleryVitrine"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "ArtGalleryVitrine"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = 92.0,
        maxZ = 94.0
    }, {
        options = { 
            {
                action = function()
                    smashVitrineArt(k)
                end,
                icon = 'fa-regular fa-gem',
                label = Text("breakglass"),
                canInteract = function()
                if v["isOpened"] or v["isBusy"] then 
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
    exports.qtarget:AddBoxZone("ArtFuseBoxZone"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "ArtFuseBoxZone"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
    options = {
        {
            icon = "fa-solid fa-plug-circle-xmark",
            label = Text("open"),
            action = function()
                ArtFuseBoxBreakMinigame(k, success)
            end,
            if not ArtHeistGallery then 
                return false
            end
            return true
        end,
        },
    },
    distance = 3.5,
})
end

for k, v in pairs(Config.Panels) do
    exports.qtarget:AddBoxZone("ArtGalleryPanel"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "ArtGalleryPanel"..k,
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
                            ArtPanelsMinigame(k, success)
                        else
                            Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getusb', function(usbamount)
                            if usbamount > 0 then
                                ArtPanelsMinigame(k, success)
                            else
                                Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'hack_usb')
                    end
                end,
                icon = "fa-brands fa-nfc-directional",
                label = Text("hackpanel"),
                canInteract = function()
                    if k == 1 then
                        return slidersopen
                    else
                        return true
                    end
                end,
            },
        },
        distance = 3.5,
    })
end

for k, v in pairs(Config.Paintings) do
    exports.qtarget:AddBoxZone("ArtGalleryPainting"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "ArtGalleryPainting"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                if Config.inventory == 'ox' then
                        local wknife = exports.ox_inventory:Search(2, 'WEAPON_SWITCHBLADE')
                        if wknife > 0 then
                        Takepainting(k)
                        else
                            Notifi({ title = Config.title, text = Text('noknife'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getknife', function(wknife)
                            if wknife > 0 then
                                Takepainting(k)
                        else
                            Notifi({ title = Config.title, text = Text('noknife'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                        end, 'WEAPON_SWITCHBLADE')
                    end
                end,
                icon = "fa-solid fa-image",
                label = Text("takepainting"),
                canInteract = function()
                    if v["IsTaken"] or v["isBusy"] or not shuttersopen then 
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })
end

exports.qtarget:AddBoxZone("ArtGalleryVaultVitrine", vector3(11.24, 139.09, 93.8), 1, 1, {
    name = "ArtGalleryVaultVitrine",
    heading = 340,
    debugPoly = false,
    minZ = 40.0,
    maxZ = 42.7,
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local ldrill = exports.ox_inventory:Search(2, 'laser_drill')
                        if ldrill > 0 then
                        VaultVitrineCuttingMinigame(success)
                        else
                            Notifi({ title = Config.title, text = Text('nodrill'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getlaserdrill', function(ldrill)
                            if ldrill > 0 then
                                VaultVitrineCuttingMinigame(success)
                        else
                            Notifi({ title = Config.title, text = Text('nodrill'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                        end, 'laser_drill')
                    end
                end,
                icon = "fa-regular fa-gem",
                label = Text("cutglass"),
                canInteract = function()
                    if eggtaken then
                        return false
                    end
                    return true
                end,
            },
        },
    job = {"all"},
    distance = 1.5,
})
elseif Config.Target == "qb" then
    exports['qb-target']:AddBoxZone("ArtCellDoorR", vector3(33.22, 135.36, 92.79), 0.2, 1.4, {
        name = "ArtCellDoorR",
        heading = 340,
        debugPoly = false,
        minZ = 92.0,
        maxZ = 94.0
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local thermite = exports.ox_inventory:Search(2, 'thermite')
                        if thermite and thermite > 0 then
                            ArtThermiteMinigame()
                        else
                            Notifi({
                                title = Config.title,
                                text = Text('nothermite'),
                                icon = 'fa-solid fa-toolbox',
                                color = '#ff0000'
                            })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getthermite', function(thermite)
                            if thermite and thermite > 0 then
                                ArtThermiteMinigame()
                            else
                                Notifi({
                                    title = Config.title,
                                    text = Text('nothermite'),
                                    icon = 'fa-solid fa-toolbox',
                                    color = '#ff0000'
                                })
                            end
                        end, 'thermite')
                    end
                end,
                icon = "fa-solid fa-bomb",
                label = Text("plantthermite"),
                canInteract = function()
                    if garageblown then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })

    exports['qb-target']:AddBoxZone("ArtCellDoorL", vector3(36.89, 145.29, 92.79), 0.4, 1.4, {
        name = "ArtCellDoorL",
        heading = 340,
        debugPoly = false,
        minZ = 92.0,
        maxZ = 94.0
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local thermite = exports.ox_inventory:Search(2, 'thermite')
                        if thermite and thermite > 0 then
                            ArtThermiteMinigame()
                        else
                            Notifi({
                                title = Config.title,
                                text = Text('nothermite'),
                                icon = 'fa-solid fa-toolbox',
                                color = '#ff0000'
                            })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getthermite', function(thermite)
                            if thermite and thermite > 0 then
                                ArtThermiteMinigame()
                            else
                                Notifi({
                                    title = Config.title,
                                    text = Text('nothermite'),
                                    icon = 'fa-solid fa-toolbox',
                                    color = '#ff0000'
                                })
                            end
                        end, 'thermite')
                    end
                end,
                icon = "fa-solid fa-bomb",
                label = Text("plantthermite"),
                canInteract = function()
                    if garageblown then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })

    exports['qb-target']:AddBoxZone("ArtMaindoor", vector3(11.42, 148.95, 93.24), 2.6, 0.4, {
        name = "ArtMaindoor",
        heading = 340,
        debugPoly = false,
        minZ = 93.5,
        maxZ = 95.0
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local lockpick = exports.ox_inventory:Search(2, 'lockpick')
                        if lockpick > 0 then
                            ArtDoorlockMinigame()
                        else
                            Notifi({ title = Config.title, text = Text('nolockpick'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getlockpick', function(thermite)
                            if lockpick > 0 then
                                ArtDoorlockMinigame()
                            else
                                Notifi({ title = Config.title, text = Text('nolockpick'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'lockpick')
                    end
                end,
                icon = "fa-solid fa-key",
                label = Text("lockpick")
            },
        },
        distance = 3.0,
        job = {"all"}
    })   

    exports['qb-target']:AddBoxZone("ArtOfficePC", vector3(16.36, 158.59, 92.79), 0.6, 1.0, {
        name = "ArtOfficePC",
        heading = 327,
        debugPoly = false,
        minZ = 92.0,
        maxZ = 94.0
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local usb = exports.ox_inventory:Search(2, 'hack_usb')
                        if usb and usb > 0 then
                            ArtPCHack()
                        else
                            Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getusb', function(usb)
                            if usb and usb > 0 then
                                ArtPCHack()
                            else
                                Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'hack_usb')
                    end
                end,
                icon = "fa-solid fa-laptop-code",
                label = Text("hackpac"),
            },
        },
        job = {"all"},
        distance = 3.0
    })    
    exports['qb-target']:AddBoxZone("ArtVaultPanel", vector3(15.48, 140.23, 93.79), 0.45, 0.65, {
        name = "ArtVaultPanel",
        heading = 338,
        debugPoly = false,
        minZ = 93.5,
        maxZ = 94.3
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local usb = exports.ox_inventory:Search(2, 'hack_usb')
                        if usb and usb > 0 then
                            VaultPanelAction()
                        else
                            Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getusb', function(usb)
                            if usb and usb > 0 then
                                VaultPanelAction()
                            else
                                Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'hack_usb')
                    end
                end,
                icon = "fa-solid fa-laptop-code",
                label = Text("hackpanel"),
            },
        },
        job = {"all"},
        distance = 3.0
    })    
    exports['qb-target']:AddBoxZone("GalleryShutters", vector3(17.25, 144.87, 93.79), 0.3, 0.3, {
        name = "GalleryShutters",
        heading = 340,
        debugPoly = false,
        minZ = 93.4,
        maxZ = 94.3
    }, {
        options = {
            {
                action = function()
                OpenShutters()
                end,
                icon = "fa-solid fa-toggle-off",
                label = Text("openshutters"),
                canInteract = function()
                    if not sliderinteraction then
                        return false
                    end
                    return true
                end,
            },
        },
        job = {"all"},
        distance = 3.0
    })    
for k, v in pairs(Config.Locations) do
    exports['qb-target']:AddBoxZone("ArtGalleryVitrine"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "ArtGalleryVitrine"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = 92.0,
        maxZ = 94.0
    }, {
        options = { 
            {
                action = function()
                    smashVitrineArt(k)
                end,
                icon = 'fa-regular fa-gem',
                label = Text("breakglass"),
                canInteract = function()
                if v["isOpened"] or v["isBusy"] then 
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
    exports['qb-target']:AddBoxZone("ArtFuseBoxZone"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "ArtFuseBoxZone"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
    options = {
        {
            icon = "fa-solid fa-plug-circle-xmark",
            label = Text("open"),
            action = function()
                ArtFuseBoxBreakMinigame(k, success)
            end,
            if not ArtHeistGallery then 
                return false
            end
            return true
        end,
        },
    },
    distance = 3.5,
})
end

for k, v in pairs(Config.Panels) do
    exports['qb-target']:AddBoxZone("ArtGalleryPanel"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "ArtGalleryPanel"..k,
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
                            ArtPanelsMinigame(k, success)
                        else
                            Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getusb', function(usbamount)
                            if usbamount > 0 then
                                ArtPanelsMinigame(k, success)
                            else
                                Notifi({ title = Config.title, text = Text('nousb'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                            end
                        end, 'hack_usb')
                    end
                end,
                icon = "fa-brands fa-nfc-directional",
                label = Text("hackpanel"),
                canInteract = function()
                    if k == 1 then
                        return slidersopen
                    else
                        return true
                    end
                end,
            },
        },
        distance = 3.5,
    })
end

for k, v in pairs(Config.Paintings) do
    exports['qb-target']:AddBoxZone("ArtGalleryPainting"..k, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
        name = "ArtGalleryPainting"..k,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minZ,
        maxZ = v.maxZ,
    }, {
        options = {
            {
                action = function()
                if Config.inventory == 'ox' then
                        local wknife = exports.ox_inventory:Search(2, 'WEAPON_SWITCHBLADE')
                        if wknife > 0 then
                        Takepainting(k)
                        else
                            Notifi({ title = Config.title, text = Text('noknife'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getknife', function(wknife)
                            if wknife > 0 then
                                Takepainting(k)
                        else
                            Notifi({ title = Config.title, text = Text('noknife'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                        end, 'WEAPON_SWITCHBLADE')
                    end
                end,
                icon = "fa-solid fa-image",
                label = Text("takepainting"),
                canInteract = function()
                    if v["IsTaken"] or v["isBusy"] or not shuttersopen then 
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 3.5,
    })
end

exports['qb-target']:AddBoxZone("ArtGalleryVaultVitrine", vector3(11.24, 139.09, 93.8), 1, 1, {
    name = "ArtGalleryVaultVitrine",
    heading = 340,
    debugPoly = false,
    minZ = 40.0,
    maxZ = 42.7,
    }, {
        options = {
            {
                action = function()
                    if Config.inventory == 'ox' then
                        local ldrill = exports.ox_inventory:Search(2, 'laser_drill')
                        if ldrill > 0 then
                        VaultVitrineCuttingMinigame(success)
                        else
                            Notifi({ title = Config.title, text = Text('nodrill'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
                        QBCore.Functions.TriggerCallback('estrp-artheist:getlaserdrill', function(ldrill)
                            if ldrill > 0 then
                                VaultVitrineCuttingMinigame(success)
                        else
                            Notifi({ title = Config.title, text = Text('nodrill'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
                        end
                        end, 'laser_drill')
                    end
                end,
                icon = "fa-regular fa-gem",
                label = Text("cutglass"),
                canInteract = function()
                    if eggtaken then
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

function ArtDoorlockMinigame()
    local playerPed = PlayerPedId()
    local locks = math.random(3, 4)
    local success = exports['minigames']:Lockpick("Lockpick", locks, 30)
    
    
    if success then
        if lib.progressCircle({
            duration = 8000,
            label = Text("lockpicking"),
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                cobat = true,
                move = true,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_player'
            },
        }) then 
            TriggerServerEvent('estrp-artheist:server:synced', 'openmain')
            Notifi({ title = Config.title, text = Text("dooropen"), icon = 'fa-solid fa-key', color = '#9eeb34' })
            ClearPedTasks(playerPed)
        end
        ClearPedTasks(playerPed)
    else
        ClearPedTasks(playerPed) 
    end
end

function ArtPanelsMinigame(k, success)
    QBCore.Functions.TriggerCallback('estrp-artheist:server:checkPoliceCount', function(status)
        if status then
            TriggerEvent("estrp-artheist:client:PanelAction")
            Wait(3000)
            
            local locks = math.random(2, 4) -- Random number of locks
            local success = exports['minigames']:Lockpick("Lockpick", locks, 30)
            
            if success then
                TriggerEvent("estrp-artheist:client:OpenDoor", k, success)
            else
                TriggerEvent("estrp-artheist:client:OpenDoor", k)
            end
        end
    end)
end

function ArtFuseBoxBreakMinigame(k, success)
    if k == 1 then
        QBCore.Functions.TriggerCallback('estrp-artheist:server:checkPoliceCount', function(status)
            if status then
                QBCore.Functions.TriggerCallback('estrp-artheist:server:checkTime', function(time)
                    if time then
                        TriggerEvent("estrp-artheist:client:OpenBox", k)
                        Wait(3000)
                        local locks = math.random(2, 4) -- Random number of locks
                        local success = exports['minigames']:Lockpick("Lockpick", locks, 30)

                        if success then
                            TriggerEvent("estrp-artheist:client:CloseBox", k, success)
                            TriggerServerEvent("estrp-artheist:server:artrefresh")
                            local pos = vector3(7.25, 135.78, 89.01)
                            loadPtfxAsset('core')
                            UseParticleFxAssetNextCall('core')
                            local ptfx = StartParticleFxLoopedAtCoord("ent_sht_electrical_box", pos, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            Wait(10000)
                            StopParticleFxLooped(ptfx, 0)
                        else
                            TriggerEvent("estrp-artheist:client:CloseBox", k)
                            TriggerServerEvent("estrp-artheist:server:failedrobbery")
                        end
                    end
                end)
            end
        end)
    end
end


------ / Laptop hacking Functions
function ArtPCHack()
    local pchacked = false
    if busy or pchacked then
        Notifi({ title = Config.title, text = Text('cantdo'), icon = 'fa-solid fa-toolbox', color = '#ff0000' })
        return
    end

    busy = true
    local keys = math.random(10, 15)
    local success = exports['minigames']:Chopping(keys, 30)
    if success then
        pchacked = true
        lib.progressBar({
            duration = Config.durationhacking,
            label = Text("hacking"),
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                cobat = true,
                move = true,
            },
            anim = {
                dict = 'anim@heists@ornate_bank@hack_heels',
                clip = 'hack_loop'
            },
        }) 
        busy = false
        pchacked = true
        TriggerServerEvent("estrp-artheist:server:removeusb")
        TriggerServerEvent('estrp-artheist:server:synced', 'disablesecurity')
        local pos = vector3(17.323617935181, 153.56764221191, 93.312423706055)
        loadPtfxAsset('core')
        UseParticleFxAssetNextCall('core')
        local ptfx = StartParticleFxLoopedAtCoord("ent_sht_electrical_box", pos, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        Wait(5000)
        StopParticleFxLooped(ptfx, 0)
    else
        pchacked = false
        busy = false
    end
end

function ArtVaultPanelHack(success)
    local locks = math.random(2, 3)
	local success = exports['minigames']:Lockpick("Lockpick", locks, 30)
		if success then
            VaultPanelActionResult(success)
        else
            VaultPanelActionResult()
        end
end

function ArtThermiteMinigame()
    ESX.TriggerServerCallback('estrp-bobcat:server:checkPoliceCount', function(status)
        if status then
            local keys = math.random(3, 5)
            local success = exports['minigames']:Chopping(keys, 10)
            if success then
                TriggerEvent("estrp-artheist:client:placethermite")
            else
            end
        end
    end)
end

function VaultVitrineCuttingMinigame(success)
    local ped = PlayerPedId()
    local targetCoords = vector3(10.1056, 139.5949, 93.7955)
    local targetHeading = 250.0

    TaskGoStraightToCoord(ped, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, targetHeading, 0.1)
    while #(GetEntityCoords(ped) - targetCoords) > 0.5 do
        Citizen.Wait(100)
    end
    local locks = math.random(1, 2)
	local success = exports['minigames']:Lockpick("Lockpick", locks, 30)
    SetEntityHeading(ped, targetHeading)
    ClearPedTasks(ped)
		if success then
            GlassCuttingScene(success)
        else
            GlassCuttingScene()
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
RegisterNetEvent('estrp-artheist:robberyinprogress')
AddEventHandler('estrp-artheist:robberyinprogress',function(playerCoords,currentStreetName)
    local PlayerData = QBCore.Functions.GetPlayerData()
	if PlayerData.job.name == "police" then
        Notifi({ title = Config.title, text = Text('galleryrobbery').. " " .. currentStreetName, duration = 10000, icon = 'fa-solid fa-laptop-code', color = '#ff0000' })
        RemoveBlip(blipbankrobbery)
        blipbankrobbery = AddBlipForCoord(playerCoords)
        SetBlipSprite(blipbankrobbery , 161)
        SetBlipScale(blipbankrobbery , 2.0)
        SetBlipColour(blipbankrobbery, 3)
        PulseBlip(blipbankrobbery)
        Wait(100000)
        RemoveBlip(blipbankrobbery)
        
        end
    end)

function Policenotify()
        local playerCoords = GetEntityCoords(PlayerPedId(-1))
        local currentStreetName = GetCurrentStreetName()
        TriggerServerEvent('estrp-artheist:robberyinprogress', playerCoords,currentStreetName)
end