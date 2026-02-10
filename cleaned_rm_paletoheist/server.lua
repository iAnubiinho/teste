local lastRob = 0
ESX, QBCore = nil
Citizen.CreateThread(function()
    if Config['PaletoHeist']['framework']['name'] == 'ESX' then
        pcall(function() ESX = exports[Config['PaletoHeist']['framework']['scriptName']]:getSharedObject() end)
        if not ESX then
            TriggerEvent(Config['PaletoHeist']['framework']['eventName'], function(library) 
                ESX = library 
            end)
        end
        ESX.RegisterServerCallback('paletoheist:server:checkPoliceCount', function(source, cb)
            local src = source
            local players = ESX.GetPlayers()
            local policeCount = 0
        
            for i = 1, #players do
                local player = ESX.GetPlayerFromId(players[i])
                for k, v in pairs(Config['PaletoHeist']['dispatchJobs']) do
                    if player['job']['name'] == v then
                        policeCount = policeCount + 1
                    end
                end
            end
        
            if policeCount >= Config['PaletoHeist']['requiredPoliceCount'] then
                cb({status = true})
            else
                cb({status = false})
                TriggerClientEvent('paletoheist:client:showNotification', src, Strings['need_police'])
            end
        end)
        ESX.RegisterServerCallback('paletoheist:server:checkTime', function(source, cb, index)
            local src = source
            local player = ESX.GetPlayerFromId(src)
            
            if (os.time() - lastRob) < Config['PaletoHeist']['nextRob'] and lastRob ~= 0 then
                local seconds = Config['PaletoHeist']['nextRob'] - (os.time() - lastRob)
                TriggerClientEvent('paletoheist:client:showNotification', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
                cb({status = false})
            else
                lastRob = os.time()
                discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' started the Paleto Heist!')
                cb({status = true})
            end
        end)
        ESX.RegisterServerCallback('paletoheist:server:hasItem', function(source, cb, data)
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
                print('[rm_paletoheist] you need add required items to server database')
            end
        end)
    elseif Config['PaletoHeist']['framework']['name'] == 'QB' then
        while not QBCore do
            pcall(function() QBCore =  exports[Config['PaletoHeist']['framework']['scriptName']]:GetCoreObject() end)
            if not QBCore then
                pcall(function() QBCore =  exports[Config['PaletoHeist']['framework']['scriptName']]:GetSharedObject() end)
            end
            if not QBCore then
                TriggerEvent(Config['PaletoHeist']['framework']['eventName'], function(obj) QBCore = obj end)
            end
            Citizen.Wait(1)
        end
        QBCore.Functions.CreateCallback('paletoheist:server:checkPoliceCount', function(source, cb)
            local src = source
            local players = QBCore.Functions.GetPlayers()
            local policeCount = 0
        
            for i = 1, #players do
                local player = QBCore.Functions.GetPlayer(players[i])
                if player then
                    for k, v in pairs(Config['PaletoHeist']['dispatchJobs']) do
                        if player.PlayerData.job.name == v then
                            policeCount = policeCount + 1
                        end
                    end
                end
            end
        
            if policeCount >= Config['PaletoHeist']['requiredPoliceCount'] then
                cb({status = true})
            else
                cb({status = false})
                TriggerClientEvent('paletoheist:client:showNotification', src, Strings['need_police'])
            end
        end)
        QBCore.Functions.CreateCallback('paletoheist:server:checkTime', function(source, cb, index)
            local src = source
            local player = QBCore.Functions.GetPlayer(src)

            if (os.time() - lastRob) < Config['PaletoHeist']['nextRob'] and lastRob ~= 0 then
                local seconds = Config['PaletoHeist']['nextRob'] - (os.time() - lastRob)
                TriggerClientEvent('paletoheist:client:showNotification', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
                cb({status = false})
            else
                lastRob = os.time()
                discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' started the Paleto Heist!')
                cb({status = true})
            end
        end)
        QBCore.Functions.CreateCallback('paletoheist:server:hasItem', function(source, cb, data)
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

RegisterServerEvent('paletoheist:server:removeItem')
AddEventHandler('paletoheist:server:removeItem', function(item)
    local src = source
    if Config['PaletoHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        if player then
            player.removeInventoryItem(item, 1)
        end
    elseif Config['PaletoHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
        if player then
            player.Functions.RemoveItem(item, 1)
        end 
    end
end)

RegisterServerEvent('paletoheist:server:rewardItem')
AddEventHandler('paletoheist:server:rewardItem', function(item, count, type)
    local src = source

    if Config['PaletoHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        local whitelistItems = {}

        if player then
            if type == 'money' then
                local sourcePed = GetPlayerPed(src)
                local sourceCoords = GetEntityCoords(sourcePed)
                local dist = #(sourceCoords - vector3(-103.84, 6471.73, 31.6267))
                if dist > 100.0 then
                    print('[rm_paletoheist] add money exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                else
                    if Config['PaletoHeist']['black_money'] then
                        player.addAccountMoney('black_money', count)
                        discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain ' .. count .. '$ on Paleto Heist!')
                    else
                        player.addMoney(count)
                        discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain ' .. count .. '$ on Paleto Heist!')
                    end
                end
            else
                for k, v in pairs(Config['PaletoHeist']['rewardItems']) do
                    whitelistItems[v['itemName']] = true
                end

                if whitelistItems[item] then
                    if count then 
                        player.addInventoryItem(item, count)
                        discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain ' .. item .. ' x' .. count .. ' on Paleto Heist!')
                    else
                        player.addInventoryItem(item, 1)
                        discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain ' .. item .. ' x' .. 1 .. ' on Paleto Heist!')
                    end
                else
                    print('[rm_paletoheist] add item exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                end
            end
        end
    elseif Config['PaletoHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
        local whitelistItems = {}

        if player then
            if type == 'money' then
                local sourcePed = GetPlayerPed(src)
                local sourceCoords = GetEntityCoords(sourcePed)
                local dist = #(sourceCoords - vector3(-103.84, 6471.73, 31.6267))
                if dist > 100.0 then
                    print('[rm_paletoheist] add money exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                else
                    if Config['PaletoHeist']['black_money'] then
                        local info = {
                            worth = count
                        }
                        player.Functions.AddItem('markedbills', 1, false, info)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add") 
                        discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain ' .. count .. '$ on Paleto Heist!')
                    else
                        player.Functions.AddMoney('cash', count)
                        discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain ' .. count .. '$ on Paleto Heist!')
                    end
                end
            else
                for k, v in pairs(Config['PaletoHeist']['rewardItems']) do
                    whitelistItems[v['itemName']] = true
                end

                if whitelistItems[item] then
                    if count then 
                        player.Functions.AddItem(item, count)
                        discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain ' .. item .. ' x' .. count .. ' on Paleto Heist!')
                    else
                        player.Functions.AddItem(item, 1)
                        discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain ' .. item .. ' x' .. 1 .. ' on Paleto Heist!')
                    end
                else
                    print('[rm_paletoheist] add item exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src))
                end
            end
        end
    end
end)

RegisterServerEvent('paletoheist:server:sellRewardItems')
AddEventHandler('paletoheist:server:sellRewardItems', function()
    local src = source

    if Config['PaletoHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        local totalMoney = 0

        if player then
            for k, v in pairs(Config['PaletoHeist']['rewardItems']) do
                local playerItem = player.getInventoryItem(v['itemName'])
                if playerItem.count >= 1 then
                    player.removeInventoryItem(v['itemName'], playerItem.count)
                    if Config['PaletoHeist']['black_money'] then
                        player.addAccountMoney('black_money', playerItem.count * v['sellPrice'])
                    else
                        if Config['PaletoHeist']['moneyItem']['status'] then
                            player.addInventoryItem(Config['PaletoHeist']['moneyItem']['itemName'], playerItem.count * v['sellPrice'])
                        else
                            player.addMoney(playerItem.count * v['sellPrice'])
                        end
                    end
                    totalMoney = totalMoney + (playerItem.count * v['sellPrice'])
                end
            end

            discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain $' .. math.floor(totalMoney) .. ' on the Union Heist Buyer!')
            TriggerClientEvent('paletoheist:client:showNotification', src, Strings['total_money'] .. ' $' .. math.floor(totalMoney))
        end
    elseif Config['PaletoHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
        local totalMoney = 0

        if player then
            for k, v in pairs(Config['PaletoHeist']['rewardItems']) do
                local playerItem = player.Functions.GetItemByName(v['itemName'])
                if playerItem ~= nil and playerItem.amount > 0 then
                    player.Functions.RemoveItem(v['itemName'], playerItem.amount)
                    if Config['PaletoHeist']['black_money'] then
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

            discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain $' .. math.floor(totalMoney) .. ' on the Union Heist Buyer!')
            TriggerClientEvent('paletoheist:client:showNotification', src, Strings['total_money'] .. ' $' .. math.floor(totalMoney))
        end
    end
end)

RegisterCommand('pdpaleto', function(source, args)
    local src = source

    if Config['PaletoHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        
        if player then
            for k, v in pairs(Config['PaletoHeist']['dispatchJobs']) do
                if player['job']['name'] == v then
                    return TriggerClientEvent('paletoheist:client:resetHeist', -1)
                end
            end
            
            TriggerClientEvent('paletoheist:client:showNotification', src, Strings['not_cop'])
        end
    elseif Config['PaletoHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
    
        if player then
            for k, v in pairs(Config['PaletoHeist']['dispatchJobs']) do
                if player.PlayerData.job.name == v then
                    return TriggerClientEvent('paletoheist:client:resetHeist', -1)
                end
            end

            TriggerClientEvent('paletoheist:client:showNotification', src, Strings['not_cop'])
        end
    end
end)

RegisterServerEvent('paletoheist:server:sync')
AddEventHandler('paletoheist:server:sync', function(type, args)
    TriggerClientEvent('paletoheist:client:sync', -1, type, args)
end)

RegisterServerEvent('paletoheist:server:sceneSync')
AddEventHandler('paletoheist:server:sceneSync', function(model, animDict, animName, pos, rotation)
    TriggerClientEvent('paletoheist:client:sceneSync', -1, model, animDict, animName, pos, rotation)
end)