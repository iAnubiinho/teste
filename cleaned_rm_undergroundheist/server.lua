local lastrob = 0
local start = true
ESX, QBCore = nil
Citizen.CreateThread(function()
    if Config['UndergroundHeist']['framework']['name'] == 'ESX' then
        pcall(function() ESX = exports[Config['UndergroundHeist']['framework']['scriptName']]:getSharedObject() end)
        if not ESX then
            TriggerEvent(Config['UndergroundHeist']['framework']['eventName'], function(library) 
                ESX = library 
            end)
        end
        ESX.RegisterServerCallback('undergroundheist:server:checkPoliceCount', function(source, cb)
            local src = source
            local players = ESX.GetPlayers()
            local policeCount = 0
        
            for i = 1, #players do
                local player = ESX.GetPlayerFromId(players[i])
                for k, v in pairs(Config['UndergroundHeist']['dispatchJobs']) do
                    if player['job']['name'] == v then
                        policeCount = policeCount + 1
                    end
                end
            end
        
            if policeCount >= Config['UndergroundHeist']['requiredPoliceCount'] then
                cb({status = true})
            else
                cb({status = false})
                TriggerClientEvent('undergroundheist:client:showNotification', src, Strings['need_police'])
            end
        end)
        ESX.RegisterServerCallback('undergroundheist:server:checkTime', function(source, cb)
            local src = source
            local player = ESX.GetPlayerFromId(src)
            
            if (os.time() - lastrob) < Config['UndergroundHeist']['nextRob'] and lastrob ~= 0 then
                local seconds = Config['UndergroundHeist']['nextRob'] - (os.time() - lastrob)
                TriggerClientEvent('undergroundheist:client:showNotification', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
                cb({status = false})
            else
                lastrob = os.time()
                start = true
                discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' started the Underground Heist!')
                cb({status = true})
            end
        end)
        ESX.RegisterServerCallback('undergroundheist:server:hasItem', function(source, cb, data)
            local src = source
            local player = ESX.GetPlayerFromId(src)
            local playerItem = player.getInventoryItem(data.itemName)
        
            if player and playerItem ~= nil then
                if playerItem.count >= 1 then
                    cb({status = true, label = playerItem.label})
                else
                    cb({status = false, label = playerItem.label})
                end
            else
                print('[rm_undergroundheist] you need add required items to server database')
            end
        end)
    elseif Config['UndergroundHeist']['framework']['name'] == 'QB' then
        while not QBCore do
            pcall(function() QBCore =  exports[Config['UndergroundHeist']['framework']['scriptName']]:GetCoreObject() end)
            if not QBCore then
                pcall(function() QBCore =  exports[Config['UndergroundHeist']['framework']['scriptName']]:GetSharedObject() end)
            end
            if not QBCore then
                TriggerEvent(Config['UndergroundHeist']['framework']['eventName'], function(obj) QBCore = obj end)
            end
            Citizen.Wait(1)
        end
        QBCore.Functions.CreateCallback('undergroundheist:server:checkPoliceCount', function(source, cb)
            local src = source
            local players = QBCore.Functions.GetPlayers()
            local policeCount = 0
        
            for i = 1, #players do
                local player = QBCore.Functions.GetPlayer(players[i])
                if player then
                    for k, v in pairs(Config['UndergroundHeist']['dispatchJobs']) do
                        if player.PlayerData.job.name == v then
                            policeCount = policeCount + 1
                        end
                    end
                end
            end
        
            if policeCount >= Config['UndergroundHeist']['requiredPoliceCount'] then
                cb({status = true})
            else
                cb({status = false})
                TriggerClientEvent('undergroundheist:client:showNotification', src, Strings['need_police'])
            end
        end)
        QBCore.Functions.CreateCallback('undergroundheist:server:checkTime', function(source, cb)
            local src = source
            local player = QBCore.Functions.GetPlayer(src)
            
            if (os.time() - lastrob) < Config['UndergroundHeist']['nextRob'] and lastrob ~= 0 then
                local seconds = Config['UndergroundHeist']['nextRob'] - (os.time() - lastrob)
                TriggerClientEvent('undergroundheist:client:showNotification', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
                cb({status = false})
            else
                lastrob = os.time()
                start = true
                discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' started the Underground Heist!')
                cb({status = true})
            end
        end)
        QBCore.Functions.CreateCallback('undergroundheist:server:hasItem', function(source, cb, data)
            local src = source
            local player = QBCore.Functions.GetPlayer(src)
            local playerItem = player.Functions.GetItemByName(data.itemName)
        
            if player then 
                if playerItem ~= nil then
                    if playerItem.amount >= 1 then
                        cb({status = true, label = data.itemName})
                    end
                else
                    cb({status = false, label = data.itemName})
                end
            end
        end)
    end
end)

RegisterServerEvent('undergroundheist:server:removeItem')
AddEventHandler('undergroundheist:server:removeItem', function(item)
    local src = source
    if Config['UndergroundHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        if player then
            player.removeInventoryItem(item, 1)
        end
    elseif Config['UndergroundHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
        if player then
            player.Functions.RemoveItem(item, 1)
        end
    end
end)

RegisterServerEvent('undergroundheist:server:rewardItem')
AddEventHandler('undergroundheist:server:rewardItem', function(item, count, type)
    local src = source

    if Config['UndergroundHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        local whitelistItems = {}

        if player then
            if type == 'money' then
                local sourcePed = GetPlayerPed(src)
                local sourceCoords = GetEntityCoords(sourcePed)
                local dist = #(sourceCoords - vector3(942.598, -97.969, 26.2259))
                if dist > 300.0 then
                    print('[rm_undergroundheist] add money exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                else
                    if Config['UndergroundHeist']['black_money'] then
                        player.addAccountMoney('black_money', count)
                    else
                        player.addMoney(count)
                    end
                end
            else
                for k, v in pairs(Config['UndergroundHeist']['rewardItems']) do
                    whitelistItems[v['itemName']] = true
                end

                if whitelistItems[item] then
                    if count then 
                        player.addInventoryItem(item, count)
                    else
                        player.addInventoryItem(item, 1)
                    end
                else
                    print('[rm_undergroundheist] add item exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                end
            end
        end
    elseif Config['UndergroundHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
        local whitelistItems = {}

        if player then
            if type == 'money' then
                local sourcePed = GetPlayerPed(src)
                local sourceCoords = GetEntityCoords(sourcePed)
                local dist = #(sourceCoords - vector3(942.598, -97.969, 26.2259))
                if dist > 300.0 then
                    print('[rm_undergroundheist] add money exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                else
                    if Config['UndergroundHeist']['black_money'] then
                        local info = {
                            worth = count
                        }
                        player.Functions.AddItem('markedbills', 1, false, info)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add") 
                    else
                        player.Functions.AddMoney('cash', count)
                    end
                end
            else
                for k, v in pairs(Config['UndergroundHeist']['rewardItems']) do
                    whitelistItems[v['itemName']] = true
                end

                if whitelistItems[item] then
                    if count then 
                        player.Functions.AddItem(item, count)
                    else
                        player.Functions.AddItem(item, 1)
                    end
                else
                    print('[rm_undergroundheist] add item exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                end
            end
        end
    end
end)

RegisterServerEvent('undergroundheist:server:sellRewardItems')
AddEventHandler('undergroundheist:server:sellRewardItems', function()
    local src = source

    if Config['UndergroundHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        local totalMoney = 0

        if player then
            for k, v in pairs(Config['UndergroundHeist']['rewardItems']) do
                local playerItem = player.getInventoryItem(v['itemName'])
                if playerItem.count >= 1 then
                    player.removeInventoryItem(v['itemName'], playerItem.count)
                    if Config['UndergroundHeist']['black_money'] then
                        player.addAccountMoney('black_money', playerItem.count * v['sellPrice'])
                    else
                        player.addMoney(playerItem.count * v['sellPrice'])
                    end
                    totalMoney = totalMoney + (playerItem.count * v['sellPrice'])
                end
            end

            discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain $' .. math.floor(totalMoney) .. ' on the Underground Heist Buyer!')
            TriggerClientEvent('undergroundheist:client:showNotification', src, Strings['total_money'] .. ' $' .. math.floor(totalMoney))
        end
    elseif Config['UndergroundHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
        local totalMoney = 0

        if player then
            for k, v in pairs(Config['UndergroundHeist']['rewardItems']) do
                local playerItem = player.Functions.GetItemByName(v['itemName'])
                if playerItem ~= nil and playerItem.amount > 0 then
                    player.Functions.RemoveItem(v['itemName'], playerItem.amount)
                    if Config['UndergroundHeist']['black_money'] then
                        local info = {
                            worth = playerItem.amount * v['sellPrice']
                        }
                        player.Functions.AddItem('markedbills', 1, false, info)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add") 
                    else
                        player.Functions.AddMoney('cash', playerItem.amount * v['sellPrice'])
                    end
                    totalMoney = totalMoney + (playerItem.amount * v['sellPrice'])
                end
            end

            discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain $' .. math.floor(totalMoney) .. ' on the Underground Heist Buyer!')
            TriggerClientEvent('undergroundheist:client:showNotification', src, Strings['total_money'] .. ' $' .. math.floor(totalMoney))
        end
    end
end)

RegisterCommand('pdunderground', function(source, args)
    local src = source

    if Config['UndergroundHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        
        if player then
            for k, v in pairs(Config['UndergroundHeist']['dispatchJobs']) do
                if player['job']['name'] == v then
                    if start then
                        TriggerClientEvent('undergroundheist:client:resetHeist', -1)
                        start = false
                        return
                    end
                end
            end

            TriggerClientEvent('undergroundheist:client:showNotification', src, Strings['not_cop'])
        end
    elseif Config['UndergroundHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
    
        if player then
            for k, v in pairs(Config['UndergroundHeist']['dispatchJobs']) do
                if player.PlayerData.job.name == v then
                    if start then
                        TriggerClientEvent('undergroundheist:client:resetHeist', -1)
                        start = false
                    end
                end
            end

            TriggerClientEvent('undergroundheist:client:showNotification', src, Strings['not_cop'])
        end
    end
end)

RegisterServerEvent('undergroundheist:server:sync')
AddEventHandler('undergroundheist:server:sync', function(type, index)
    TriggerClientEvent('undergroundheist:client:sync', -1, type, index)
end)

RegisterServerEvent('undergroundheist:server:mainLoop')
AddEventHandler('undergroundheist:server:mainLoop', function()
    TriggerClientEvent('undergroundheist:client:mainLoop', -1)
end)

RegisterServerEvent('undergroundheist:server:sceneSync')
AddEventHandler('undergroundheist:server:sceneSync', function(model, animDict, animName, pos, rotation)
    TriggerClientEvent('undergroundheist:client:sceneSync', -1, model, animDict, animName, pos, rotation)
end)