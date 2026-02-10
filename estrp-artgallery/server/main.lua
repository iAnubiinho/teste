QBCore = exports['qb-core']:GetCoreObject()

local timeOut = false
local Cooldown = false
local nextrob = 0
local start = false
local lastrob = 0
local itemdelete = false

RegisterNetEvent('estrp-artheist:server:artrefresh', function()
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if itemdelete == false then
    itemdelete = true 
        timer = Config.Galleryclean * 60000
        while timer > 0 do
            Wait(1000)
            timer = timer - 1000
            if timer == 0 then
                TriggerEvent('estrp-artheist:server:reset')
                itemdelete = false 
                guardsspawned = false
            end 
        end
    end
end)

RegisterNetEvent('estrp-artheist:server:reset', function()
    TriggerClientEvent('estrp-artheist:resetRobberyClient', -1)
end)

-- Server-side event
RegisterNetEvent('estrp-artheist:server:PaintingReward')
AddEventHandler("estrp-artheist:server:PaintingReward", function(k, reward, amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local citizenID = xPlayer.PlayerData.citizenid  -- Assuming citizenid is stored here
    local characterName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname

    xPlayer.Functions.AddItem(reward, amount)
    local discordColor = 25087
    local message = Text("CitizenID") .. "" .. citizenID .. "\n" ..
    Text("Name") .. "" .. characterName .. "\n" ..
    Text("paintingtaken") .. "\n" .. reward .. " x" .. amount
    sendToDiscord(message, discordColor) 
end)

RegisterNetEvent('estrp-artheist:server:EggReward', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local citizenID = xPlayer.PlayerData.citizenid  -- Assuming citizenid is stored here
    local characterName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname

    xPlayer.Functions.AddItem("golden_egg", 1)
    local discordColor = 25087
    local message = Text("CitizenID") .. "" .. citizenID .. "\n" ..
    Text("Name") .. "" .. characterName .. "\n" ..
    Text("eggtaken") .. "\n" .. "golden egg" .. " x" .. "1"
    sendToDiscord(message, discordColor) 
end)


RegisterNetEvent('estrp-artheist:server:vitrineReward')
AddEventHandler('estrp-artheist:server:vitrineReward', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local item = math.random(1, #Config.VitrineRewards)
    local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
    local citizenID = xPlayer.PlayerData.citizenid  -- Assuming citizenid is stored here
    local characterName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname

    if Config.inventory == 'ox' then
        if exports.ox_inventory:CanCarryItem(src, Config.VitrineRewards[item]["item"], amount) then
            Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount)
            local discordColor = 25087
                    local message = Text("CitizenID") .. "" .. citizenID .. "\n" ..
                    Text("Name") .. "" .. characterName .. "\n" ..
                    Text("brokevitrine") .. "\n" .. Config.VitrineRewards[item]["item"] .. " x" .. amount
                    sendToDiscord(message, discordColor)
        end
        elseif Config.inventory == 'qs' or Config.inventory == 'other' then
        Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount)
        local discordColor = 25087
                    local message = Text("CitizenID") .. "" .. citizenID .. "\n" ..
                    Text("Name") .. "" .. characterName .. "\n" ..
                    Text("brokevitrine") .. "\n" .. Config.VitrineRewards[item]["item"] .. " x" .. amount
                    sendToDiscord(message, discordColor)
    end
end)


RegisterNetEvent('estrp-artheist:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('estrp-artheist:client:setVitrineState', -1, stateType, state, k)
end)

RegisterNetEvent('estrp-artheist:server:setPaintingState', function(stateType, state, k)
    Config.Paintings[k][stateType] = state
    TriggerClientEvent('estrp-artheist:client:setPaintingState', -1, stateType, state, k)
end)


RegisterServerEvent('estrp-artheist:resetrobbery', function(stateType, state, k)
    for k, v in pairs(Config.Locations) do
        if v["isOpened"] then  -- Only update if it's true
            Config.Locations[k]["isOpened"] = false
        TriggerClientEvent('estrp-artheist:client:setVitrineState', -1, 'isOpened', false, k)
        end
     end
     for k, v in pairs(Config.Paintings) do
        if v["IsTaken"] then  -- Only update if it's true
            Config.Paintings[k]["IsTaken"] = false
        TriggerClientEvent('estrp-artheist:client:setPaintingState', -1, 'IsTaken', false, k)
        end
     end
end)

QBCore.Functions.CreateCallback('estrp-artheist:server:checkPoliceCount', function(source, cb) 
    if Config.CopsNeeded == 0 then
        cb(true)
        return
    end
    
        local copcount = 0
        local Players = QBCore.Functions.GetPlayers()
    
        for i = 1, #Players, 1 do
            local xPlayer = QBCore.Functions.GetPlayer(Players[i])
    
           -- Check if the player's job is in the police jobs list
           for _, policeJob in ipairs(Config.PoliceJobs) do
            if xPlayer.PlayerData.job.name == policeJob and xPlayer.PlayerData.job.onduty then
                copcount = copcount + 1
                    
                    -- If enough police are found, trigger callback and return early
                    if copcount >= Config.CopsNeeded then
                        cb(true)
                        return -- Exit the function, stopping the loop
                    end
                end
            end
        end
    
        -- If not enough police officers are found
        cb(false)
        -- Notify the player who tried to start the robbery
        NotifiServ(source, { title = Config.title, text = Text('nocops'), icon = 'fa-solid fa-building-shield', color = '#ff0000' })
end)

QBCore.Functions.CreateCallback('estrp-artheist:server:checkTime', function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if (os.time() - lastrob) < Config.cooldown and lastrob ~= 0 then
        local seconds = Config.cooldown - (os.time() - lastrob)
       NotifiServ(src, { title = Config.title, text = Text('artrobberyleft') .. " " .. math.floor(seconds / 60) .. '' .. Text('minutes'), icon = 'key', color = '#ff0000' })
       cb(false)
    else
        lastrob = os.time()
        start = true
        cb(true)
    end
end)

--- On robbery fail
RegisterServerEvent("estrp-artheist:server:failedrobbery")
AddEventHandler("estrp-artheist:server:failedrobbery", function(source)
        lastrob = 0
        start = false
end)


QBCore.Functions.CreateCallback('estrp-artheist:getlaserdrill', function(source, cb, itemNeeded)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer then
        local itemCount = xPlayer.Functions.GetItemByName("laser_drill")
        cb(itemCount and itemCount.amount or 0)
    end
end)

QBCore.Functions.CreateCallback('estrp-artheist:getknife', function(source, cb, itemNeeded)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer then
        local itemCount = xPlayer.Functions.GetItemByName("WEAPON_SWITCHBLADE")
        cb(itemCount and itemCount.amount or 0)
    end
end)


QBCore.Functions.CreateCallback('estrp-artheist:getthermite', function(source, cb, itemNeeded)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer then
        local itemCount = xPlayer.Functions.GetItemByName("thermite")
        cb(itemCount and itemCount.amount or 0)
    end
end)

QBCore.Functions.CreateCallback('estrp-artheist:getlockpick', function(source, cb, itemNeeded)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer then
        local itemCount = xPlayer.Functions.GetItemByName("lockpick")
        cb(itemCount and itemCount.amount or 0)
    end
end)

QBCore.Functions.CreateCallback('estrp-artheist:getusb', function(source, cb, itemNeeded)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer then
        local itemCount = xPlayer.Functions.GetItemByName("hack_usb")
        cb(itemCount and itemCount.amount or 0)
    end
end)

RegisterServerEvent('estrp-artheist:server:removethermite')
AddEventHandler('estrp-artheist:server:removethermite', function(item)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if player then
        player.Functions.RemoveItem("thermite", 1)
    end
end)

RegisterServerEvent('estrp-artheist:server:removeusb')
AddEventHandler('estrp-artheist:server:removeusb', function(item)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if player then
        player.Functions.RemoveItem("hack_usb", 1)
    end
end)

RegisterServerEvent('estrp-artheist:server:removelaser')
AddEventHandler('estrp-artheist:server:removelaser', function(item)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if player then
        player.Functions.RemoveItem("laser_drill", 1)
    end
end)


RegisterServerEvent('estrp-artheist:server:particleFx')
AddEventHandler('estrp-artheist:server:particleFx', function(pos)
    TriggerClientEvent('estrp-artheist:client:particleFx', -1, pos)
end)

RegisterServerEvent('estrp-artheist:server:synced')
AddEventHandler('estrp-artheist:server:synced', function(syncevent, paintingID, index, index2)
    TriggerClientEvent('estrp-artheist:client:synced', -1, syncevent, paintingID, index, index2)
end)

RegisterServerEvent("estrp-artheist:resetRobberyForAll")
AddEventHandler("estrp-artheist:resetRobberyForAll", function()
    TriggerClientEvent("estrp-artheist:resetRobberyClient", -1)
end)


AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
end)

function sendToDiscord(message, color, imageUrl)
    local webHook = Config.URL
    local embedData = {
        {
            ["title"] = "Estrp Art Gallery",
            ["footer"] = {
                ["text"] = os.date("%c"),
                ["icon_url"] = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/a5f11b3a00f23659bf0a0d8b64f1932abaff3eba.png"
            },
            ["description"] = message,
            ["color"] = color or 16711680, -- Default to red if no color is provided
        }
    }

    PerformHttpRequest(webHook, function(err, text, headers)
        if err ~= 200 then
            print("Error sending to Discord:", err)
        end
    end, 'POST', json.encode({
        username = "Estrp Art Gallery",
        embeds = embedData
    }), { ['Content-Type'] = 'application/json' })
end
