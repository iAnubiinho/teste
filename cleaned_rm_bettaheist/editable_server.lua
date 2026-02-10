RegisterServerEvent('bettaheist:server:policeAlert')
AddEventHandler('bettaheist:server:policeAlert', function(coords)
    if Config['BettaHeist']['framework']['name'] == 'ESX' then
        local players = ESX.GetPlayers()
        for i = 1, #players do
            local player = ESX.GetPlayerFromId(players[i])
            for k, v in pairs(Config['BettaHeist']['dispatchJobs']) do
                if player['job']['name'] == v then
                    TriggerClientEvent('bettaheist:client:policeAlert', players[i], coords)
                end
            end
        end
    elseif Config['BettaHeist']['framework']['name'] == 'QB' then
        local players = QBCore.Functions.GetPlayers()
        for i = 1, #players do
            local player = QBCore.Functions.GetPlayer(players[i])
            if player then
                for k, v in pairs(Config['BettaHeist']['dispatchJobs']) do
                    if player.PlayerData.job.name == v then
                        TriggerClientEvent('bettaheist:client:policeAlert', players[i], coords)
                    end
                end
            end
        end
    end
end)

discord = {
    ['webhook'] = 'WEBHOOK_HERE',
    ['name'] = 'rm_bettaheist',
    ['image'] = 'https://cdn.discordapp.com/avatars/869260464775921675/dff6a13a5361bc520ef126991405caae.png?size=1024'
}

function discordLog(name, message)
    local data = {
        {
            ["color"] = '3553600',
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end