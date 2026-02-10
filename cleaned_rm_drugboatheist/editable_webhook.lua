RegisterServerEvent('drugboatheist:server:policeAlert')
AddEventHandler('drugboatheist:server:policeAlert', function(coords)
    if Config['DrugBoatHeist']['framework']['name'] == 'ESX' then
        local players = ESX.GetPlayers()
        
        for i = 1, #players do
            local player = ESX.GetPlayerFromId(players[i])
            for k, v in pairs(Config['BettaHeist']['dispatchJobs']) do
                if player['job']['name'] == v then
                    TriggerClientEvent('drugboatheist:client:policeAlert', players[i], coords)
                end
            end
        end
    elseif Config['DrugBoatHeist']['framework']['name'] == 'QB' then
        local players = QBCore.Functions.GetPlayers()
        for i = 1, #players do
            local player = QBCore.Functions.GetPlayer(players[i])
            for k, v in pairs(Config['BettaHeist']['dispatchJobs']) do
                if player.PlayerData.job.name == v then
                    TriggerClientEvent('drugboatheist:client:policeAlert', players[i], coords)
                end
            end
        end
    end
end)

discord = {
    ['webhook'] = '',
    ['name'] = 'rm_drugboatheist',
    ['image'] = ''
}

function discordLog(name, message)
    if discord['webhook'] == '' then return end
    local data = {
        {
            ["color"] = '3553600',
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end
