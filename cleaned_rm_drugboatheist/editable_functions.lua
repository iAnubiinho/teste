function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, 50)
end

function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0, 1)
end

RegisterNetEvent('drugboatheist:client:showNotification')
AddEventHandler('drugboatheist:client:showNotification', function(str)
    ShowNotification(str)
end)

--This event send to all police players
RegisterNetEvent('drugboatheist:client:policeAlert')
AddEventHandler('drugboatheist:client:policeAlert', function(targetCoords)
    ShowNotification(Strings['police_alert'])
    local alpha = 250
    local drugBoatBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)

    SetBlipHighDetail(drugBoatBlip, true)
    SetBlipColour(drugBoatBlip, 1)
    SetBlipAlpha(drugBoatBlip, alpha)
    SetBlipAsShortRange(drugBoatBlip, true)

    while alpha ~= 0 do
        Citizen.Wait(500)
        alpha = alpha - 1
        SetBlipAlpha(drugBoatBlip, alpha)

        if alpha == 0 then
            RemoveBlip(drugBoatBlip)
            return
        end
    end
end)
