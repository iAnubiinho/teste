RegisterServerEvent('estrp-artheist:robberyinprogress')
AddEventHandler('estrp-artheist:robberyinprogress', function(playerCoords,currentStreetName)
TriggerClientEvent('estrp-artheist:robberyinprogress', -1, playerCoords,currentStreetName)
end)