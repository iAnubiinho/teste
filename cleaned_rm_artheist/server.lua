local lastrob = 0
ESX = nil
Citizen.CreateThread(function()
    pcall(function() ESX = exports['es_extended']:getSharedObject() end)
    if not ESX then
        TriggerEvent('esx:getSharedObject', function(library) 
            ESX = library 
        end)
    end
    ESX.RegisterServerCallback('artheist:server:checkPoliceCount', function(source, cb)
        local src = source
        local players = GetPlayers()
        local policeCount = 0
    
        for i = 1, #players do
            local player = ESX.GetPlayerFromId(players[i])
            if player then
                for k, v in pairs(Config['ArtHeist']['dispatchJobs']) do
                    if player['job']['name'] == v then
                        policeCount = policeCount + 1
                    end
                end
            end
        end
    
        if policeCount >= Config['ArtHeist']['requiredPoliceCount'] then
            cb(true)
        else
            cb(false)
            TriggerClientEvent('artheist:client:showNotification', src, Strings['need_police'])
        end
    end)
    
    ESX.RegisterServerCallback('artheist:server:checkRobTime', function(source, cb)
        local src = source
        local player = ESX.GetPlayerFromId(src)
        
        if (os.time() - lastrob) < Config['ArtHeist']['nextRob'] and lastrob ~= 0 then
            local seconds = Config['ArtHeist']['nextRob'] - (os.time() - lastrob)
            player.showNotification(Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
            cb(false)
        else
            lastrob = os.time()
            cb(true)
        end
    end)
end)

RegisterNetEvent('artheist:server:policeAlert')
AddEventHandler('artheist:server:policeAlert', function(coords)
    local players = ESX.GetPlayers()
    
    for i = 1, #players do
        local player = ESX.GetPlayerFromId(players[i])
        for k, v in pairs(Config['ArtHeist']['dispatchJobs']) do
            if player['job']['name'] == v then
                TriggerClientEvent('artheist:client:policeAlert', players[i], coords)
            end
        end
    end
end)

RegisterServerEvent('artheist:server:syncHeistStart')
AddEventHandler('artheist:server:syncHeistStart', function()
    TriggerClientEvent('artheist:client:syncHeistStart', -1)
end)

RegisterServerEvent('artheist:server:syncPainting')
AddEventHandler('artheist:server:syncPainting', function(x)
    TriggerClientEvent('artheist:client:syncPainting', -1, x)
end)

RegisterServerEvent('artheist:server:syncAllPainting')
AddEventHandler('artheist:server:syncAllPainting', function()
    TriggerClientEvent('artheist:client:syncAllPainting', -1)
end)

RegisterServerEvent('artheist:server:rewardItem')
AddEventHandler('artheist:server:rewardItem', function(sceneId)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    
    if player and sceneId then
        local scene = Config['ArtHeist']['painting'][sceneId]
        if scene then
            local item = scene['rewardItem']
            if item then
                player.addInventoryItem(item, 1)
            end
        else
            print(('[^1WARNING^7] Player ID %s tried to spawn an invalid item via event (ArtHeist)'):format(src))
        end
    end
end)

RegisterServerEvent('artheist:server:finishHeist')
AddEventHandler('artheist:server:finishHeist', function()
    local src = source
    local player = ESX.GetPlayerFromId(src)

    if player then
        for k, v in pairs(Config['ArtHeist']['painting']) do
            local count = player.getInventoryItem(v['rewardItem']).count
            if count > 0 then
                player.removeInventoryItem(v['rewardItem'], 1)
                if Config['ArtHeist']["blackMoney"] then
                    player.addAccountMoney("black_money", v['paintingPrice'])
                else
                    player.addMoney(v['paintingPrice'])
                end
            end
        end
    end
end)