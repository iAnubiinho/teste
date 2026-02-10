RegisterServerEvent('estrp-casinoheist:robberyinprogress')
AddEventHandler('estrp-casinoheist:robberyinprogress', function(playerCoords,currentStreetName)
TriggerClientEvent('estrp-casinoheist:robberyinprogress', -1, playerCoords,currentStreetName)
end)