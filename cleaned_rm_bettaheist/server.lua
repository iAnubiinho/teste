local lastrob = 0
ESX, QBCore = nil
Citizen.CreateThread(function()
    if Config['BettaHeist']['framework']['name'] == 'ESX' then
        pcall(function() ESX = exports[Config['BettaHeist']['framework']['scriptName']]:getSharedObject() end)
        if not ESX then
            TriggerEvent(Config['BettaHeist']['framework']['eventName'], function(library) 
                ESX = library 
            end)
        end
        ESX.RegisterServerCallback('bettaheist:server:checkPoliceCount', function(source, cb)
            local src = source
            local players = ESX.GetPlayers()
            local policeCount = 0
        
            for i = 1, #players do
                local player = ESX.GetPlayerFromId(players[i])
                for k, v in pairs(Config['BettaHeist']['dispatchJobs']) do
                    if player['job']['name'] == v then
                        policeCount = policeCount + 1
                    end
                end
            end
        
            if policeCount >= Config['BettaHeist']['requiredPoliceCount'] then
                cb({status = true})
            else
                cb({status = false})
                TriggerClientEvent('bettaheist:client:showNotification', src, Strings['need_police'])
            end
        end)
        ESX.RegisterServerCallback('bettaheist:server:checkTime', function(source, cb, index)
            local src = source
            local player = ESX.GetPlayerFromId(src)

            if (os.time() - lastrob) < Config['BettaHeist']['nextRob'] and lastrob ~= 0 then
                local seconds = Config['BettaHeist']['nextRob'] - (os.time() - lastrob)
                TriggerClientEvent('bettaheist:client:showNotification', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
                cb({status = false})
            else
                lastrob = os.time()
                discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' started the Betta Heist!')
                cb({status = true})
            end
        end)
        ESX.RegisterServerCallback('bettaheist:server:hasItem', function(source, cb, data)
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
                print('[rm_bettaheist] you need add required items to server database')
            end
        end)
    elseif Config['BettaHeist']['framework']['name'] == 'QB' then
        while not QBCore do
            pcall(function() QBCore =  exports[Config['BettaHeist']['framework']['scriptName']]:GetCoreObject() end)
            if not QBCore then
                pcall(function() QBCore =  exports[Config['BettaHeist']['framework']['scriptName']]:GetSharedObject() end)
            end
            if not QBCore then
                TriggerEvent(Config['BettaHeist']['framework']['eventName'], function(obj) QBCore = obj end)
            end
            Citizen.Wait(1)
        end
        QBCore.Functions.CreateCallback('bettaheist:server:checkPoliceCount', function(source, cb)
            local src = source
            local players = QBCore.Functions.GetPlayers()
            local policeCount = 0
        
            for i = 1, #players do
                local player = QBCore.Functions.GetPlayer(players[i])
                for k, v in pairs(Config['BettaHeist']['dispatchJobs']) do
                    if player.PlayerData.job.name == v then
                        policeCount = policeCount + 1
                    end
                end
            end
        
            if policeCount >= Config['BettaHeist']['requiredPoliceCount'] then
                cb({status = true})
            else
                cb({status = false})
                TriggerClientEvent('bettaheist:client:showNotification', src, Strings['need_police'])
            end
        end)
        QBCore.Functions.CreateCallback('bettaheist:server:checkTime', function(source, cb, index)
            local src = source
            local player = QBCore.Functions.GetPlayer(src)

            if (os.time() - lastrob) < Config['BettaHeist']['nextRob'] and lastrob ~= 0 then
                local seconds = Config['BettaHeist']['nextRob'] - (os.time() - lastrob)
                TriggerClientEvent('bettaheist:client:showNotification', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
                cb({status = false})
            else
                lastrob = os.time()
                discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' started the Betta Heist!')
                cb({status = true})
            end
        end)
        QBCore.Functions.CreateCallback('bettaheist:server:hasItem', function(source, cb, data)
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

RegisterServerEvent('bettaheist:server:removeItem')
AddEventHandler('bettaheist:server:removeItem', function(item)
    local src = source
    if Config['BettaHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        if player then
            player.removeInventoryItem(item, 1)
        end
    elseif Config['BettaHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
        if player then
            player.Functions.RemoveItem(item, 1)
        end 
    end
end)

RegisterServerEvent('bettaheist:server:rewardItem')
AddEventHandler('bettaheist:server:rewardItem', function(item, count, type, index)
    local src = source

    if Config['BettaHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        local whitelistItems = {}

        if player then
            if type == 'money' then
                local sourcePed = GetPlayerPed(src)
                local sourceCoords = GetEntityCoords(sourcePed)
                local dist = #(sourceCoords - Config['BettaSetup']['main'])
                if dist > 100.0 then
                    print('[rm_bettaheist] add money exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                else
                    if Config['BettaHeist']['black_money'] then
                        player.addAccountMoney('black_money', count)
                        discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain ' .. count .. '$ on Betta Heist')
                    else
                        player.addMoney(count)
                        discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain ' .. count .. '$ on Betta Heist')
                    end
                end
            else
                for k, v in pairs(Config['BettaHeist']['rewardItems']) do
                    whitelistItems[v['itemName']] = true
                end

                if whitelistItems[item] then
                    if count then 
                        player.addInventoryItem(item, count)
                        discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain ' .. item .. ' x' .. count .. ' on Betta Heist')
                    else
                        player.addInventoryItem(item, 1)
                        discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain ' .. item .. ' x' .. 1 .. ' on Betta Heist')
                    end
                else
                    print('[rm_bettaheist] add item exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                end
            end
        end
    elseif Config['BettaHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
        local whitelistItems = {}

        if player then
            if type == 'money' then
                local sourcePed = GetPlayerPed(src)
                local sourceCoords = GetEntityCoords(sourcePed)
                local dist = #(sourceCoords - Config['BettaSetup']['main'])
                if dist > 100.0 then
                    print('[rm_bettaheist] add money exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                else
                    if Config['BettaHeist']['black_money'] then
                        local info = {
                            worth = count
                        }
                        player.Functions.AddItem('markedbills', 1, false, info)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add") 
                        discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain ' .. count .. '$ on Betta Heist')
                    else
                        player.Functions.AddMoney('cash', count)
                        discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain ' .. count .. '$ on Betta Heist')
                    end
                end
            else
                for k, v in pairs(Config['BettaHeist']['rewardItems']) do
                    whitelistItems[v['itemName']] = true
                end

                if whitelistItems[item] then
                    if count then 
                        player.Functions.AddItem(item, count)
                        discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain ' .. item .. ' x' .. count .. ' on Betta Heist')
                    else
                        player.Functions.AddItem(item, 1)
                        discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain ' .. item .. ' x' .. 1 .. ' on Betta Heist')
                    end
                else
                    print('[rm_bettaheist] add item exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                end
            end
        end
    end
end)

RegisterServerEvent('bettaheist:server:sellRewardItems')
AddEventHandler('bettaheist:server:sellRewardItems', function()
    local src = source

    if Config['BettaHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        local totalMoney = 0

        if player then
            for k, v in pairs(Config['BettaHeist']['rewardItems']) do
                local playerItem = player.getInventoryItem(v['itemName'])
                if playerItem.count >= 1 then
                    player.removeInventoryItem(v['itemName'], playerItem.count)
                    if Config['BettaHeist']['black_money'] then
                        player.addAccountMoney('black_money', playerItem.count * v['sellPrice'])
                    else
                        if Config['BettaHeist']['moneyItem']['status'] then
                            player.addInventoryItem(Config['BettaHeist']['moneyItem']['itemName'], playerItem.count * v['sellPrice'])
                        else
                            player.addMoney(playerItem.count * v['sellPrice'])
                        end
                    end
                    totalMoney = totalMoney + (playerItem.count * v['sellPrice'])
                end
            end

            discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain $' .. math.floor(totalMoney) .. ' on the Betta Heist Buyer!')
            TriggerClientEvent('bettaheist:client:showNotification', src, Strings['total_money'] .. ' $' .. math.floor(totalMoney))
        end
    elseif Config['BettaHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
        local totalMoney = 0

        if player then
            for k, v in pairs(Config['BettaHeist']['rewardItems']) do
                local playerItem = player.Functions.GetItemByName(v['itemName'])
                if playerItem ~= nil and playerItem.amount > 0 then
                    player.Functions.RemoveItem(v['itemName'], playerItem.amount)
                    if Config['BettaHeist']['black_money'] then
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

            discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain $' .. math.floor(totalMoney) .. ' on the Betta Heist Buyer!')
            TriggerClientEvent('bettaheist:client:showNotification', src, Strings['total_money'] .. ' $' .. math.floor(totalMoney))
        end
    end
end)

RegisterCommand('pdbetta', function(source, args)
    local src = source

    if Config['BettaHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        
        if player then
            for k, v in pairs(Config['BettaHeist']['dispatchJobs']) do
                if player['job']['name'] == v then
                    return TriggerClientEvent('bettaheist:client:sync', -1, 'resetHeist')
                end
            end
            TriggerClientEvent('bettaheist:client:showNotification', src, Strings['not_cop'])
        end
    elseif Config['BettaHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
    
        if player then
            for k, v in pairs(Config['BettaHeist']['dispatchJobs']) do
                if player.PlayerData.job.name == v then
                    return TriggerClientEvent('bettaheist:client:sync', -1, 'resetHeist')
                end
            end

            TriggerClientEvent('bettaheist:client:showNotification', src, Strings['not_cop'])
        end
    end
end)

RegisterServerEvent('bettaheist:server:sync')
AddEventHandler('bettaheist:server:sync', function(type, args)
    TriggerClientEvent('bettaheist:client:sync', -1, type, args)
end)

RegisterServerEvent('bettaheist:server:sceneSync')
AddEventHandler('bettaheist:server:sceneSync', function(model, animDict, animName, pos, rotation)
    TriggerClientEvent('bettaheist:client:sceneSync', -1, model, animDict, animName, pos, rotation)
end)
