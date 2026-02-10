RegisterServerEvent('undergroundheist:server:policeAlert')
AddEventHandler('undergroundheist:server:policeAlert', function(coords)
    if Config['UndergroundHeist']['framework']['name'] == 'ESX' then
        local players = ESX.GetPlayers()
        for i = 1, #players do
            local player = ESX.GetPlayerFromId(players[i])
            for k, v in pairs(Config['UndergroundHeist']['dispatchJobs']) do
                if player['job']['name'] == v then
                    TriggerClientEvent('undergroundheist:client:policeAlert', players[i], coords)
                end
            end
        end
    elseif Config['UndergroundHeist']['framework']['name'] == 'QB' then
        local players = QBCore.Functions.GetPlayers()
        for i = 1, #players do
            local player = QBCore.Functions.GetPlayer(players[i])
            for k, v in pairs(Config['UndergroundHeist']['dispatchJobs']) do
                if player.PlayerData.job.name == v then
                    TriggerClientEvent('undergroundheist:client:policeAlert', players[i], coords)
                end
            end
        end
    end
end)

discord = {
    ['webhook'] = 'WEBHOOK_URL',
    ['name'] = 'rm_undergroundheist',
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
