QBCore = exports['qb-core']:GetCoreObject()

local timeOut = false
local Cooldown = false
local nextrob = 0
local start = false
local lastrob = 0
local itemdelete = false

RegisterNetEvent('estrp-casinoheist:server:casinorefresh', function()
    print("triggeredcooldown")
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if itemdelete == false then
    itemdelete = true 
        timer = Config.Bankclear * 60000
        while timer > 0 do
            Wait(1000)
            timer = timer - 1000
            if timer == 0 then
                TriggerEvent('estrp-casinoheist:server:reset')
                itemdelete = false 
                guardsspawned = false
            end 
        end
    end
end)

RegisterNetEvent('estrp-casinoheist:server:reset', function()
    TriggerClientEvent('estrp-casinoheist:resetRobberyClient', -1)
end)



RegisterNetEvent('estrp-casinoheist:server:rewardItem')
AddEventHandler('estrp-casinoheist:server:rewardItem', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local citizenID = xPlayer.PlayerData.citizenid  -- Assuming citizenid is stored here
    local characterName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname


    -- Check if the player is valid
    if not xPlayer then
        return
    end

    local itemIndex = math.random(1, #Config.BoxRewards)
    local rewardItem = Config.BoxRewards[itemIndex]["item"]
    local minAmount = Config.BoxRewards[itemIndex]["amount"]["min"]
    local maxAmount = Config.BoxRewards[itemIndex]["amount"]["max"]
    local amount = math.random(minAmount, maxAmount)
    local discordColor = 762640
    local message = Text("Citizenid") .. ": " .. citizenID .. "\n" ..
                    Text("Name") .. ": " .. characterName .. "\n" ..
                    Text("safetydepositbox") .. "\n" .. rewardItem .. " x" .. amount



    if Config.inventory == 'ox' then
        if exports.ox_inventory:CanCarryItem(src, rewardItem, amount) then
            exports.ox_inventory:AddItem(src, rewardItem, amount) -- Fixed to include src parameter
            sendToDiscord(message, discordColor)
        else
            NotifiServ(src, { text = Text("cantcarry"), icon = 'fa-solid fa-x', color = '#ff0000' })
        end
    elseif Config.inventory == 'qs' or Config.inventory == 'other' or Config.inventory == 'qb' then
        xPlayer.Functions.AddItem(rewardItem, amount)
        sendToDiscord(message, discordColor)
    else
    end
end)

RegisterServerEvent("estrp-casinoheist:StackReward")
AddEventHandler("estrp-casinoheist:StackReward", function(k, reward, amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if not xPlayer then return end

    local goldamount = math.random(Config.GoldStackMin, Config.GoldStackMax)
    local reward = math.random(Config.MoneyStackMin, Config.MoneyStackMax)
    local citizenID = xPlayer.PlayerData.citizenid
    local characterName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
    local markedreward = {worth = math.random(Config.MoneyStackMin, Config.MoneyStackMax)}
    
    local messagedirty = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                         Text("Name") .. ": " .. characterName .. "\n" .. 
                         Text("dirtymoney") .. "\n" .. reward .. "$"
                         
    local messagemarked = Text("Citizenid") .. ": " .. citizenID .. "\n" ..
                          Text("Name") .. ": " .. characterName .. "\n" ..
                          Text("markedmoney") .. "\n" .. markedreward.worth .. "$"

    local messageclean = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                         Text("Name") .. ": " .. characterName .. "\n" .. 
                         Text("cleanmoney") .. "\n" .. reward .. "$"

    local messagegold = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                         Text("Name") .. ": " .. characterName .. "\n" .. 
                         Text("goldstack") .. "\n" .. goldamount .. "$"                    

    local X = math.random(1, 8) -- Assuming X needs to be a random number between 1 and 8

    if k == 1 or k == 2 or k == 3 then
        xPlayer.Functions.AddItem("gold_bar", goldamount)
        sendToDiscord(messagegold, discordColor)
    else
        if Config.inventory == 'ox' then
            if Config.Marked then
                xPlayer.Functions.AddItem('markedbills', 1, false, markedreward)
                local discordColor = 16711680
                sendToDiscord(messagemarked, discordColor)
            elseif Config.dirty then
                if Config.Blackmoneytoitem then
                    xPlayer.Functions.AddItem(Config.Moneyitem, reward)
                else
                    xPlayer.Functions.AddMoney("black_money", reward)
                end
                local discordColor = 16711680
                sendToDiscord(messagedirty, discordColor)
            elseif Config.clean then
                xPlayer.Functions.AddMoney("cash", reward)
                local discordColor = 16711680
                sendToDiscord(messageclean, discordColor)
            end
        elseif Config.inventory == 'qs' or Config.inventory == 'other' then
            if Config.Marked then
                xPlayer.Functions.AddItem('markedbills', 1, false, markedreward)
                local discordColor = 16711680
                sendToDiscord(messagemarked, discordColor)
            elseif Config.dirty then
                if Config.Blackmoneytoitem then
                    xPlayer.Functions.AddItem(Config.Moneyitem, reward)
                else
                    xPlayer.Functions.AddMoney("black_money", reward)
                end
                local discordColor = 16711680
                sendToDiscord(messagedirty, discordColor)
            elseif Config.clean then
                xPlayer.Functions.AddMoney("cash", reward)
                local discordColor = 16711680
                sendToDiscord(messageclean, discordColor)
            end
        end
    end
end)

RegisterNetEvent('estrp-casinoheist:rewardCash')
AddEventHandler('estrp-casinoheist:rewardCash', function()
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)

    local reward
    local markedreward
    
    if Config.Marked then
        markedreward = {worth = math.random(Config.Trollymin, Config.Trollymax)}
        reward = math.random(Config.Trollymin, Config.Trollymax)
    else
        reward = math.random(Config.Trollymin, Config.Trollymax)
    end

    local X = math.random(1, 8)

    local citizenID = xPlayer.PlayerData.citizenid  -- Assuming citizenid is stored here
    local characterName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname

    local messagedirty = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                         Text("Name") .. ": " .. characterName .. "\n" .. 
                         Text("dirtymoney") .. "\n" .. reward .. "$"
                        

    local messageclean = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                         Text("Name") .. ": " .. characterName .. "\n" .. 
                         Text("cleanmoney") .. "\n" .. reward .. "$"

    if Config.inventory == 'ox' then
        if Config.dirty then
             if Config.Marked then
                xPlayer.Functions.AddItem('markedbills', 1, false, markedreward)
                    local messagemarked = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                    Text("Name") .. ": " .. characterName .. "\n" .. 
                    Text("dirtymoney") .. "\n" .. markedreward.worth .. "$"
                    sendToDiscord(messagemarked, discordColor)
            else
                if Config.Blackmoneytoitem then
                    xPlayer.Functions.AddItem(Config.Moneyitem, reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirty, discordColor)
                else
                    xPlayer.Functions.AddMoney("black_money", reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirty, discordColor)
                end
            end
        elseif Config.clean then
            xPlayer.Functions.AddMoney("cash", reward)
            local discordColor = 16711680
            sendToDiscord(messageclean, discordColor)
        end
    elseif Config.inventory == 'qb' then
        if Config.dirty then
             if Config.Marked then
                xPlayer.Functions.AddItem('markedbills', 1, false, markedreward)
                    local messagemarked = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                    Text("Name") .. ": " .. characterName .. "\n" .. 
                    Text("dirtymoney") .. "\n" .. markedreward.worth .. "$"
                    sendToDiscord(messagemarked, discordColor)
            else
                if Config.Blackmoneytoitem then
                    xPlayer.Functions.AddItem(Config.Moneyitem, reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirty, discordColor)
                else
                    xPlayer.Functions.AddMoney("black_money", reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirty, discordColor)
                end
            end
        elseif Config.clean then
            xPlayer.Functions.AddMoney("cash", reward)
            local discordColor = 16711680
            sendToDiscord(messageclean, discordColor)
        end
    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
        if Config.dirty then
             if Config.Marked then
                xPlayer.Functions.AddItem('markedbills', 1, false, markedreward)
                    local messagemarked = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                    Text("Name") .. ": " .. characterName .. "\n" .. 
                    Text("dirtymoney") .. "\n" .. markedreward.worth .. "$"
                    sendToDiscord(messagemarked, discordColor)
            else
                if Config.Blackmoneytoitem then
                    xPlayer.Functions.AddItem(Config.Moneyitem, reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirty, discordColor)
                else
                    xPlayer.Functions.AddMoney("black_money", reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirty, discordColor)
                end
            end
        elseif Config.clean then
            xPlayer.Functions.AddMoney("cash", reward)
            local discordColor = 16711680
            sendToDiscord(messageclean, discordColor)
        end
    end
end)

RegisterNetEvent('estrp-casinoheist:rewardCashMinisafe')
AddEventHandler('estrp-casinoheist:rewardCashMinisafe', function()
   local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)

    local reward
    local markedreward
    if Config.Marked then
        markedreward = {worth = math.random(Config.MiniSafeMin, Config.MiniSafeMax)}
        reward = math.random(Config.MiniSafeMin, Config.MiniSafeMax)
    else
        reward = math.random(Config.MiniSafeMin, Config.MiniSafeMax)
    end

    local X = math.random(1, 8)

    local citizenID = xPlayer.PlayerData.citizenid  -- Assuming citizenid is stored here
    local characterName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname

    local messagedirtymini = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                         Text("Name") .. ": " .. characterName .. "\n" .. 
                         Text("dirtymoneyminisafe") .. "\n" .. reward .. "$"
                        
    local messagecleanmini = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                         Text("Name") .. ": " .. characterName .. "\n" .. 
                         Text("cleanmoneyminisafe") .. "\n" .. reward .. "$"

    if Config.inventory == 'ox' then
        if Config.dirty then
             if Config.Marked then
                xPlayer.Functions.AddItem('markedbills', 1, false, markedreward)
                    local messagemarked = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                    Text("Name") .. ": " .. characterName .. "\n" .. 
                    Text("dirtymoney") .. "\n" .. markedreward.worth .. "$"
                    sendToDiscord(messagemarked, discordColor)
            else
                if Config.Blackmoneytoitem then
                    xPlayer.Functions.AddItem(Config.Moneyitem, reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirtymini, discordColor)
                else
                    xPlayer.Functions.AddMoney("black_money", reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirtymini, discordColor)
                end
            end
        elseif Config.clean then
            xPlayer.Functions.AddMoney("cash", reward)
            local discordColor = 16711680
            sendToDiscord(messagecleanmini, discordColor)
        end
    elseif Config.inventory == 'qb' then
        if Config.dirty then
             if Config.Marked then
                xPlayer.Functions.AddItem('markedbills', 1, false, markedreward)
                    local messagemarked = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                    Text("Name") .. ": " .. characterName .. "\n" .. 
                    Text("dirtymoney") .. "\n" .. markedreward.worth .. "$"
                    sendToDiscord(messagemarked, discordColor)
            else
                if Config.Blackmoneytoitem then
                    xPlayer.Functions.AddItem(Config.Moneyitem, reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirtymini, discordColor)
                else
                    xPlayer.Functions.AddMoney("black_money", reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirtymini, discordColor)
                end
            end
        elseif Config.clean then
            xPlayer.Functions.AddMoney("cash", reward)
            local discordColor = 16711680
            sendToDiscord(messagecleanmini, discordColor)
        end
    elseif Config.inventory == 'qs' or Config.inventory == 'other' then
        if Config.dirty then
             if Config.Marked then
                xPlayer.Functions.AddItem('markedbills', 1, false, markedreward)
                    local messagemarked = Text("Citizenid") .. ": " .. citizenID .. "\n" .. 
                    Text("Name") .. ": " .. characterName .. "\n" .. 
                    Text("dirtymoney") .. "\n" .. markedreward.worth .. "$"
                    sendToDiscord(messagemarked, discordColor)
            else
                if Config.Blackmoneytoitem then
                    xPlayer.Functions.AddItem(Config.Moneyitem, reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirtymini, discordColor)
                else
                    xPlayer.Functions.AddMoney("black_money", reward)
                    local discordColor = 16711680
                    sendToDiscord(messagedirtymini, discordColor)
                end
            end
        elseif Config.clean then
            xPlayer.Functions.AddMoney("cash", reward)
            local discordColor = 16711680
            sendToDiscord(messagecleanmini, discordColor)
        end
    end
end)

-- Server-side event
RegisterNetEvent('estrp-casinoheist:server:PaintingReward')
AddEventHandler("estrp-casinoheist:server:PaintingReward", function(k, reward, amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local citizenID = xPlayer.PlayerData.citizenid  -- Assuming citizenid is stored here
    local characterName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
    
    xPlayer.Functions.AddItem(reward, amount)
    local message = Text("Citizenid") .. "" .. citizenID .. "\n" ..
    Text("Name") .. "" .. characterName .. "\n" ..
    Text("paintingtaken") .. "\n" .. reward .. " x" .. amount
    sendToDiscord(message, discordColor) 
end)

RegisterNetEvent('estrp-casinoheist:server:DiamondReward', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)

    local citizenID = xPlayer.PlayerData.citizenid  -- Assuming citizenid is stored here
    local characterName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
    

    xPlayer.Functions.AddItem("yellow_diamond", 1)
    xPlayer.Functions.RemoveItem('cutter', 1)
    local message = Text("Citizenid") .. "" .. citizenID .. "\n" ..
    Text("Name") .. "" .. characterName .. "\n" ..
    Text("diamondtaken") .. "\n" .. "Yellow Diamond" .. " x" .. 1
    sendToDiscord(message, discordColor) 
end)

RegisterNetEvent('estrp-casinoheist:server:rewardItemtrolley')
AddEventHandler('estrp-casinoheist:server:rewardItemtrolley', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
             
        local citizenID = xPlayer.PlayerData.citizenid  -- Assuming citizenid is stored here
        local characterName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
    
         
             -- Check if the player is valid
             if not xPlayer then
                 return
             end
         
             local itemIndex = math.random(1, #Config.GoldTrolley)
             local rewardItem = Config.GoldTrolley[itemIndex]["item"]
             local minAmount = Config.GoldTrolley[itemIndex]["amount"]["min"]
             local maxAmount = Config.GoldTrolley[itemIndex]["amount"]["max"]
             local amount = math.random(minAmount, maxAmount)
             local discordColor = 762640
             local message = Text("Citizenid") .. ": " .. citizenID .. "\n" ..
             Text("Name") .. ": " .. characterName .. "\n" ..
             Text("goldtrolly") .. "\n" .. rewardItem .. " x" .. amount
         
         
         
             if Config.inventory == 'ox' then
                 if exports.ox_inventory:CanCarryItem(src, rewardItem, amount) then
                     exports.ox_inventory:AddItem(src, rewardItem, amount) -- Fixed to include src parameter
                     sendToDiscord(message, discordColor)
                    else
                     NotifiServ(src, { text = Text("cantcarry"), icon = 'fa-solid fa-x', color = '#ff0000' })
                 end
             elseif Config.inventory == 'qs' or Config.inventory == 'other' or Config.inventory == 'qb' then
                 xPlayer.Functions.AddItem(rewardItem, amount)
                 sendToDiscord(message, discordColor)
             else
             end
         end)


RegisterNetEvent('estrp-casinoheist:server:setPCState', function(stateType, state, k)
    Config.PCS[k][stateType] = state
    TriggerClientEvent('estrp-casinoheist:client:setPCState', -1, stateType, state, k)
end)

RegisterNetEvent('estrp-casinoheist:server:setC4State', function(stateType, state, k)
    Config.C4placements[k][stateType] = state
    TriggerClientEvent('estrp-casinoheist:client:setC4State', -1, stateType, state, k)
end)

RegisterNetEvent('estrp-casinoheist:server:setGTrolleyState', function(stateType, state, k)
    Config.GoldTrolleys[k][stateType] = state
    TriggerClientEvent('estrp-casinoheist:client:setGTrolleyState', -1, stateType, state, k)
end)

RegisterNetEvent('estrp-casinoheist:server:setCTrolleyState', function(stateType, state, k)
    Config.CashTrolleys[k][stateType] = state
    TriggerClientEvent('estrp-casinoheist:client:setCTrolleyState', -1, stateType, state, k)
end)

RegisterNetEvent('estrp-casinoheist:server:setPaintingState', function(stateType, state, k)
    Config.Paintings[k][stateType] = state
    TriggerClientEvent('estrp-casinoheist:client:setPaintingState', -1, stateType, state, k)
end)

RegisterNetEvent('estrp-casinoheist:server:setDrillState', function(stateType, state, k)
    Config.DrillTargets[k][stateType] = state
    TriggerClientEvent('estrp-casinoheist:client:setDrillState', -1, stateType, state, k)
end)

RegisterNetEvent('estrp-casinoheist:server:SetSafeState', function(stateType, state, k)
    Config.Minisafes[k][stateType] = state
    TriggerClientEvent('estrp-casinoheist:client:SetSafeState', -1, stateType, state, k)
end)

RegisterNetEvent('estrp-casinoheist:server:SetStackState', function(stateType, state, k)
    Config.SceneStacks[k][stateType] = state
    TriggerClientEvent('estrp-casinoheist:client:SetStackState', -1, stateType, state, k)
end)




RegisterServerEvent('estrp-casinoheist:resetrobbery', function(stateType, state, k)
    for k, v in pairs(Config.PCS) do
        if v["isHacked"] then  -- Only update if it's true
            Config.PCS[k]["isHacked"] = false
        TriggerClientEvent('estrp-casinoheist:client:setPCState', -1, 'isHacked', false, k)
        end
     end 
    for k, v in pairs(Config.C4placements) do
        if v["isBlown"] then  -- Only update if it's true
            Config.C4placements[k]["isBlown"] = false
        TriggerClientEvent('estrp-casinoheist:client:setC4State', -1, 'isBlown', false, k)
        end
     end
     for k, v in pairs(Config.GoldTrolleys) do
        if v["isTaken"] then  -- Only update if it's true
            Config.GoldTrolleys[k]["isTaken"] = false
        TriggerClientEvent('estrp-casinoheist:client:setGTrolleyState', -1, 'isTaken', false, k)
        end
     end
     for k, v in pairs(Config.CashTrolleys) do
        if v["isTaken"] then  -- Only update if it's true
            Config.CashTrolleys[k]["isTaken"] = false
        TriggerClientEvent('estrp-casinoheist:client:setCTrolleyState', -1, 'isTaken', false, k)
        end
     end
     for k, v in pairs(Config.Paintings) do
        if v["isTaken"] then  -- Only update if it's true
            Config.Paintings[k]["isTaken"] = false
        TriggerClientEvent('estrp-casinoheist:client:setPaintingState', -1, 'isTaken', false, k)
        end
     end
     for k, v in pairs(Config.DrillTargets) do
        if v["isOpened"] then  -- Only update if it's true
            Config.DrillTargets[k]["isOpened"] = false
        TriggerClientEvent('estrp-casinoheist:client:setDrillState', -1, 'isOpened', false, k)
        end
     end
     for k, v in pairs(Config.SceneStacks) do
        if v["IsTaken"] then  -- Only update if it's true
            Config.SceneStacks[k]["IsTaken"] = false
        TriggerClientEvent('estrp-casinoheist:client:SetStackState', -1, 'IsTaken', false, k)
        end
     end
     for k, v in pairs(Config.Minisafes) do
        if v["IsTaken"] then  -- Only update if it's true
            Config.Minisafes[k]["IsTaken"] = false
        TriggerClientEvent('estrp-casinoheist:client:SetSafeState', -1, 'IsTaken', false, k)
        end
     end
end)

QBCore.Functions.CreateCallback('estrp-casinoheist:server:checkPoliceCount', function(source, cb) 
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

QBCore.Functions.CreateCallback('estrp-casinoheist:server:checkTime', function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if (os.time() - lastrob) < Config.cooldown and lastrob ~= 0 then
        local seconds = Config.cooldown - (os.time() - lastrob)
       NotifiServ(src, { title = Config.title, text = Text('casinoleft') .. " " .. math.floor(seconds / 60) .. '' .. Text('minutes'), icon = 'key', color = '#ff0000' })
        cb(false)
    else
        lastrob = os.time()
        start = true
        cb(true)
    end
end)

--- On robbery fail
RegisterServerEvent("estrp-casinoheist:server:failedrobbery")
AddEventHandler("estrp-casinoheist:server:failedrobbery", function(source)
        lastrob = 0
        start = false
end)


QBCore.Functions.CreateCallback('estrp-casinoheist:getcutter', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local item = Player.Functions.GetItemByName("cutter")
        local itemCount = item and item.amount or 0
        cb(itemCount)
    else
        cb(0)
    end
end)

QBCore.Functions.CreateCallback('estrp-casinoheist:getcutter', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local item = Player.Functions.GetItemByName("cutter")
        local itemCount = item and item.amount or 0
        cb(itemCount)
    else
        cb(0)
    end
end)

QBCore.Functions.CreateCallback('estrp-casinoheist:getdrillamount', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local item = Player.Functions.GetItemByName("large_drill")
        local itemCount = item and item.amount or 0
        cb(itemCount)
    else
        cb(0)
    end
end)

QBCore.Functions.CreateCallback('estrp-casinoheist:getc4', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local item = Player.Functions.GetItemByName("c4_stick")
        local itemCount = item and item.amount or 0
        cb(itemCount)
    else
        cb(0)
    end
end)

QBCore.Functions.CreateCallback('estrp-casinoheist:getusb', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local item = Player.Functions.GetItemByName("hack_usb")
        local itemCount = item and item.amount or 0
        cb(itemCount)
    else
        cb(0)
    end
end)

QBCore.Functions.CreateCallback('estrp-casinoheist:getthermal', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local item = Player.Functions.GetItemByName("thermaldrill")
        local itemCount = item and item.amount or 0
        cb(itemCount)
    else
        cb(0)
    end
end)

QBCore.Functions.CreateCallback('estrp-casinoheist:getknife', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local item = Player.Functions.GetItemByName("WEAPON_SWITCHBLADE")
        local itemCount = item and item.amount or 0
        cb(itemCount)
    else
        cb(0)
    end
end)


RegisterServerEvent("estrp-casinoheist:removec4")
AddEventHandler("estrp-casinoheist:removec4", function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        xPlayer.Functions.RemoveItem('c4_stick', 1)
    end
end)

RegisterServerEvent('estrp-casinoheist:server:removethermal')
AddEventHandler('estrp-casinoheist:server:removethermal', function(item)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if player then
        player.Functions.RemoveItem("thermaldrill", 1)
    end
end)


RegisterServerEvent('estrp-casinoheist:server:particleFx')
AddEventHandler('estrp-casinoheist:server:particleFx', function(pos)
    TriggerClientEvent('estrp-casinoheist:client:particleFx', -1, pos)
end)

RegisterServerEvent('estrp-casinoheist:server:synced')
AddEventHandler('estrp-casinoheist:server:synced', function(syncevent, paintingID, index, index2)
    TriggerClientEvent('estrp-casinoheist:client:synced', -1, syncevent, paintingID, index, index2)
end)

RegisterServerEvent("estrp-casinoheist:resetRobberyForAll")
AddEventHandler("estrp-casinoheist:resetRobberyForAll", function()
    TriggerClientEvent("estrp-casinoheist:resetRobberyClient", -1)
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
