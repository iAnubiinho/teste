ESX = nil
CasinoHeist = {
    ['start'] = false,
    ['lastHeist'] = 0,
    ['heistFriends'] = {},
    ['npcSpawned'] = false,
    ['finishedFriends'] = 0,
}

Citizen.CreateThread(function()
	while not ESX do
        pcall(function() ESX = exports['es_extended']:getSharedObject() end)
        if not ESX then
            TriggerEvent('esx:getSharedObject', function(library) 
                ESX = library 
            end)
        end
        Citizen.Wait(1)
    end
    ESX.RegisterServerCallback('casinoheist:server:checkPoliceCount', function(source, cb)
        local src = source
        local players = ESX.GetPlayers()
        local policeCount = 0
    
        for i = 1, #players do
            local player = ESX.GetPlayerFromId(players[i])
            for k, v in pairs(Config['CasinoHeist']['dispatchJobs']) do
                if player['job']['name'] == v then
                    policeCount = policeCount + 1
                end
            end
        end
    
        if policeCount >= Config['CasinoHeist']['requiredPoliceCount'] then
            cb(true)
        else
            cb(false)
            TriggerClientEvent('casinoheist:client:showNotification', src, Strings['need_police'])
        end
    end)
    
    ESX.RegisterServerCallback('casinoheist:server:checkTime', function(source, cb)
        local src = source
        local player = ESX.GetPlayerFromId(src)
        
        if (os.time() - CasinoHeist['lastHeist']) < Config['CasinoHeist']['nextHeist'] and CasinoHeist['lastHeist'] ~= 0 then
            local seconds = Config['CasinoHeist']['nextHeist'] - (os.time() - CasinoHeist['lastHeist'])
            player.showNotification(Strings['wait_nextheist'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
            cb(false)
        else
            CasinoHeist['lastHeist'] = os.time()
            cb(true)
        end
    end)
    
    ESX.RegisterServerCallback('casinoheist:server:hasItem', function(source, cb, item)
        local src = source
        local player = ESX.GetPlayerFromId(src)
        local playerItem = player.getInventoryItem(item)
    
        if player and playerItem ~= nil then
            if playerItem.count >= 1 then
                cb(true, playerItem.label)
            else
                cb(false, playerItem.label)
            end
        end
    end)
end)

AddEventHandler('playerDropped', function (reason)
    local src = source
    for k, v in pairs(CasinoHeist['heistFriends']) do
        if tonumber(v) == src then
            table.remove(CasinoHeist['heistFriends'], k)
        end
    end
    if CasinoHeist['finishedFriends'] == #CasinoHeist['heistFriends'] then
        CasinoHeist['start'] = false
        CasinoHeist['npcSpawned'] = false
        CasinoHeist['heistFriends'] = {}
        CasinoHeist['finishedFriends'] = 0
    end
end)

RegisterNetEvent('casinoheist:server:policeAlert')
AddEventHandler('casinoheist:server:policeAlert', function(coords)
    local players = ESX.GetPlayers()
    
    for i = 1, #players do
        local player = ESX.GetPlayerFromId(players[i])
        for k, v in pairs(Config['CasinoHeist']['dispatchJobs']) do
            if player['job']['name'] == v then
                TriggerClientEvent('casinoheist:client:policeAlert', players[i], coords)
            end
        end
    end
end)

RegisterServerEvent('casinoheist:server:startHeist')
AddEventHandler('casinoheist:server:startHeist', function(coords)
    local players = ESX.GetPlayers()
    CasinoHeist['start'] = true
    CasinoHeist['npcSpawned'] = false
    CasinoHeist['heistFriends'] = {}
    CasinoHeist['finishedFriends'] = 0
    
    for i = 1, #players do
        local ped = GetPlayerPed(players[i])
        local pedCo = GetEntityCoords(ped)
        local dist = #(pedCo - coords)
        if dist <= 7.0 then
            CasinoHeist['heistFriends'][i] = players[i]
            TriggerClientEvent('casinoheist:client:startHeist', players[i])
        end
    end
end)

RegisterServerEvent('casinoheist:server:rappelBusy')
AddEventHandler('casinoheist:server:rappelBusy', function(index)
    for k, v in pairs(CasinoHeist['heistFriends']) do
        TriggerClientEvent('casinoheist:client:rappelBusy', v, index)
    end
end)

RegisterServerEvent('casinoheist:server:rewardItem')
AddEventHandler('casinoheist:server:rewardItem', function(reward)
    local src = source
    local player = ESX.GetPlayerFromId(src)

    if player then
        if CasinoHeist['start'] then
            if reward.item ~= nil then
                player.addInventoryItem(reward.item, reward.count)
            else
                if Config['CasinoHeist']["blackMoney"] then
                    player.addAccountMoney("black_money", reward.count)
                else
                    player.addMoney(reward.count)
                end
            end
        end
    end
end)

RegisterServerEvent('casinoheist:server:sellRewardItems')
AddEventHandler('casinoheist:server:sellRewardItems', function()
    local src = source
    local player = ESX.GetPlayerFromId(src)

    if player then
        local rewardItems = Config['CasinoHeist']['rewardItems']
        local diamondCount = player.getInventoryItem(rewardItems['diamondTrolly']['item']).count
        local goldCount = player.getInventoryItem(rewardItems['goldTrolly']['item']).count
        local cokeCount = player.getInventoryItem(rewardItems['cokeTrolly']['item']).count

        if diamondCount > 0 then
            player.removeInventoryItem(rewardItems['diamondTrolly']['item'], diamondCount)
            if Config['CasinoHeist']["blackMoney"] then
                player.addAccountMoney("black_money", rewardItems['diamondTrolly']['sellPrice'] * diamondCount)
            else
                player.addMoney(rewardItems['diamondTrolly']['sellPrice'] * diamondCount)
            end
        end
        if goldCount > 0 then
            player.removeInventoryItem(rewardItems['goldTrolly']['item'], goldCount)
            if Config['CasinoHeist']["blackMoney"] then
                player.addAccountMoney("black_money", rewardItems['goldTrolly']['sellPrice'] * goldCount)
            else
                player.addMoney(rewardItems['goldTrolly']['sellPrice'] * goldCount)
            end
        end
        if cokeCount > 0 then
            player.removeInventoryItem(rewardItems['cokeTrolly']['item'], cokeCount)
            if Config['CasinoHeist']["blackMoney"] then
                player.addAccountMoney("black_money", rewardItems['cokeTrolly']['sellPrice'] * cokeCount)
            else
                player.addMoney(rewardItems['cokeTrolly']['sellPrice'] * cokeCount)
            end
        end

        CasinoHeist['finishedFriends'] = CasinoHeist['finishedFriends'] + 1
        if CasinoHeist['finishedFriends'] == #CasinoHeist['heistFriends'] then
            CasinoHeist['start'] = false
            CasinoHeist['npcSpawned'] = false
            CasinoHeist['heistFriends'] = {}
            CasinoHeist['finishedFriends'] = 0
        end
    end
end)

RegisterServerEvent('casinoheist:server:nightVision')
AddEventHandler('casinoheist:server:nightVision', function()
    for k, v in pairs(CasinoHeist['heistFriends']) do
        TriggerClientEvent('casinoheist:client:nightVision', v)
    end
end)

RegisterServerEvent('casinoheist:server:syncDoor')
AddEventHandler('casinoheist:server:syncDoor', function(index)
    for k, v in pairs(CasinoHeist['heistFriends']) do
        TriggerClientEvent('casinoheist:client:syncDoor', v, index)
    end
end)

RegisterServerEvent('casinoheist:server:vaultSync')
AddEventHandler('casinoheist:server:vaultSync', function()
    for k, v in pairs(CasinoHeist['heistFriends']) do
        TriggerClientEvent('casinoheist:client:vaultSync', v)
    end
end)

RegisterServerEvent('casinoheist:server:drillSync')
AddEventHandler('casinoheist:server:drillSync', function()
    for k, v in pairs(CasinoHeist['heistFriends']) do
        TriggerClientEvent('casinoheist:client:drillSync', v)
    end
end)

RegisterServerEvent('casinoheist:server:lockboxSync')
AddEventHandler('casinoheist:server:lockboxSync', function()
    for k, v in pairs(CasinoHeist['heistFriends']) do
        TriggerClientEvent('casinoheist:client:lockboxSync', v)
    end
end)

RegisterServerEvent('casinoheist:server:deleteLockbox')
AddEventHandler('casinoheist:server:deleteLockbox', function(index)
    for k, v in pairs(CasinoHeist['heistFriends']) do
        TriggerClientEvent('casinoheist:client:deleteLockbox', v, index)
    end
end)

RegisterServerEvent('casinoheist:server:lootSync')
AddEventHandler('casinoheist:server:lootSync', function(index)
    for k, v in pairs(CasinoHeist['heistFriends']) do
        TriggerClientEvent('casinoheist:client:lootSync', v, index)
    end
end)

RegisterServerEvent('casinoheist:server:vaultKeypadsSync')
AddEventHandler('casinoheist:server:vaultKeypadsSync', function(index)
    for k, v in pairs(CasinoHeist['heistFriends']) do
        TriggerClientEvent('casinoheist:client:vaultKeypadsSync', v, index)
    end
end)

RegisterServerEvent('casinoheist:server:npcSync')
AddEventHandler('casinoheist:server:npcSync', function()
    local src = source
    if CasinoHeist['npcSpawned'] then return end
    CasinoHeist['npcSpawned'] = true
    TriggerClientEvent('casinoheist:client:npcSync', src)
end)
