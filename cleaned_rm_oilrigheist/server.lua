local lastrob = 0
ESX, QBCore = nil
Citizen.CreateThread(function()
    if Config['OilRigHeist']['framework']['name'] == 'ESX' then
        pcall(function() ESX = exports[Config['OilRigHeist']['framework']['scriptName']]:getSharedObject() end)
        if not ESX then
            TriggerEvent(Config['OilRigHeist']['framework']['eventName'], function(library) 
                ESX = library 
            end)
        end
        ESX.RegisterServerCallback('oilrig:server:checkPoliceCount', function(source, cb)
            local src = source
            local players = GetPlayers()
            local policeCount = 0
        
            for i = 1, #players do
                local player = ESX.GetPlayerFromId(players[i])
                for k, v in pairs(Config['OilRigHeist']['dispatchJobs']) do
                    if player['job']['name'] == v then
                        policeCount = policeCount + 1
                    end
                end
            end
        
            if policeCount >= Config['OilRigHeist']['requiredPoliceCount'] then
                cb({status = true})
            else
                cb({status = false})
                TriggerClientEvent('oilrig:client:showNotification', src, Strings['need_police'])
            end
        end)
        ESX.RegisterServerCallback('oilrig:server:checkTime', function(source, cb, index)
            local src = source
            local player = ESX.GetPlayerFromId(src)

            if (os.time() - lastrob) < Config['OilRigHeist']['nextRob'] and lastrob ~= 0 then
                local seconds = Config['OilRigHeist']['nextRob'] - (os.time() - lastrob)
                TriggerClientEvent('oilrig:client:showNotification', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
                cb({status = false})
            else
                lastrob = os.time()
                discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' started the Oil Rig Heist!')
                cb({status = true})
            end
        end)
        ESX.RegisterServerCallback('oilrig:server:hasItem', function(source, cb, data)
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
                print('[rm_oilrigheist] you need add required items to server database')
            end
        end)
        ESX.RegisterServerCallback('oilrig:server:checkPlayersInArea', function(source, cb, data)
            local src = source
            local sourcePed = GetPlayerPed(src)
            local sourceCoords = GetEntityCoords(sourcePed)
            local players = GetPlayers()
            local playersInArea = 0

            for i = 1, #players do
                local areaPlayer = GetPlayerPed(players[i])
                local areaCoords = GetEntityCoords(areaPlayer)
                local dist = #(sourceCoords - areaCoords)
                if dist <= 5.0 then playersInArea = playersInArea + 1 end
            end

            if playersInArea >= Config['OilRigHeist']['requiredPlayersForHeist'] then
                cb({status = true})
            else
                TriggerClientEvent('oilrig:client:showNotification', src, Strings['need_people'] .. playersInArea .. '/' .. Config['OilRigHeist']['requiredPlayersForHeist'])
                cb({status = false})
            end
        end)
    elseif Config['OilRigHeist']['framework']['name'] == 'QB' then
        while not QBCore do
            pcall(function() QBCore =  exports[Config['OilRigHeist']['framework']['scriptName']]:GetCoreObject() end)
            if not QBCore then
                pcall(function() QBCore =  exports[Config['OilRigHeist']['framework']['scriptName']]:GetSharedObject() end)
            end
            if not QBCore then
                TriggerEvent(Config['OilRigHeist']['framework']['eventName'], function(obj) QBCore = obj end)
            end
            Citizen.Wait(1)
        end
        QBCore.Functions.CreateCallback('oilrig:server:checkPoliceCount', function(source, cb)
            local src = source
            local players = QBCore.Functions.GetPlayers()
            local policeCount = 0
        
            for i = 1, #players do
                local player = QBCore.Functions.GetPlayer(players[i])
                if player then
                    for k, v in pairs(Config['OilRigHeist']['dispatchJobs']) do
                        if player.PlayerData.job.name == v then
                            policeCount = policeCount + 1
                        end
                    end
                end
            end
        
            if policeCount >= Config['OilRigHeist']['requiredPoliceCount'] then
                cb({status = true})
            else
                cb({status = false})
                TriggerClientEvent('oilrig:client:showNotification', src, Strings['need_police'])
            end
        end)
        QBCore.Functions.CreateCallback('oilrig:server:checkTime', function(source, cb, index)
            local src = source
            local player = QBCore.Functions.GetPlayer(src)

            if (os.time() - lastrob) < Config['OilRigHeist']['nextRob'] and lastrob ~= 0 then
                local seconds = Config['OilRigHeist']['nextRob'] - (os.time() - lastrob)
                TriggerClientEvent('oilrig:client:showNotification', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
                cb({status = false})
            else
                lastrob = os.time()
                discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' started the Oil Rig Heist!')
                cb({status = true})
            end
        end)
        QBCore.Functions.CreateCallback('oilrig:server:hasItem', function(source, cb, data)
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
        QBCore.Functions.CreateCallback('oilrig:server:checkPlayersInArea', function(source, cb, data)
            local src = source
            local sourcePed = GetPlayerPed(src)
            local sourceCoords = GetEntityCoords(sourcePed)
            local players = GetPlayers()
            local playersInArea = 0

            for i = 1, #players do
                local areaPlayer = GetPlayerPed(players[i])
                local areaCoords = GetEntityCoords(areaPlayer)
                local dist = #(sourceCoords - areaCoords)
                if dist <= 5.0 then playersInArea = playersInArea + 1 end
            end

            if playersInArea >= Config['OilRigHeist']['requiredPlayersForHeist'] then
                cb({status = true})
            else
                TriggerClientEvent('oilrig:client:showNotification', src, Strings['need_people'] .. playersInArea .. '/' .. Config['OilRigHeist']['requiredPlayersForHeist'])
                cb({status = false})
            end
        end)
    end
end)

RegisterServerEvent('oilrig:server:rewardItem')
AddEventHandler('oilrig:server:rewardItem', function(data)
    local src = source

    if Config['OilRigHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)

        if player then
            local sourcePed = GetPlayerPed(src)
            local sourceCoords = GetEntityCoords(sourcePed)
            local dist = #(sourceCoords - Config['OilRigSetup']['middleArea'])
            if dist > 100.0 then return print('[rm_oilrigheist] add item exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src)) end
            for k, v in pairs(Config['OilRigHeist']['crateSettings']['crateItems']) do
                local chance = math.random(1, 100)

                if chance <= v['chance'] then
                    rewardItem = {name = v['itemName'], count = v['itemCount']()}
                    player.addInventoryItem(rewardItem.name, rewardItem.count)
                    discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain ' .. rewardItem.name .. ' x' .. rewardItem.count .. ' on Oil Rig Heist Crate!')
                end
            end
        end
    elseif Config['OilRigHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)

        if player then
            local sourcePed = GetPlayerPed(src)
            local sourceCoords = GetEntityCoords(sourcePed)
            local dist = #(sourceCoords - Config['OilRigSetup']['middleArea'])
            if dist > 100.0 then return print('[rm_oilrigheist] add item exploit playerID: '.. src .. ' name: ' .. GetPlayerName(src)) end
            for k, v in pairs(Config['OilRigHeist']['crateSettings']['crateItems']) do
                local chance = math.random(1, 100)

                if chance <= v['chance'] then
                    rewardItem = {name = v['itemName'], count = v['itemCount']()}
                    player.Functions.AddItem(rewardItem.name, rewardItem.count)
                    discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain ' .. rewardItem.name .. ' x' .. rewardItem.count .. ' on Oil Rig Heist Crate!')
                end
            end
        end
    end
end)

RegisterCommand('pdoilrig', function(source, args)
    local src = source

    if Config['OilRigHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        
        if player then
            for k, v in pairs(Config['OilRigHeist']['dispatchJobs']) do
                if player['job']['name'] == v then
                    return TriggerClientEvent('oilrig:client:sync', -1, 'resetCrates')
                end
            end

            TriggerClientEvent('oilrig:client:showNotification', src, Strings['not_cop'])
        end
    elseif Config['OilRigHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
    
        if player then
            for k, v in pairs(Config['OilRigHeist']['dispatchJobs']) do
                if player.PlayerData.job.name == v then
                    return TriggerClientEvent('oilrig:client:sync', -1, 'resetCrates')
                end
            end
            TriggerClientEvent('oilrig:client:showNotification', src, Strings['not_cop'])
        end
    end
end)

RegisterServerEvent('oilrig:server:sync')
AddEventHandler('oilrig:server:sync', function(type, args)
    TriggerClientEvent('oilrig:client:sync', -1, type, args)
end)