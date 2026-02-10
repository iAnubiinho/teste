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

RegisterNetEvent('paletoheist:client:showNotification')
AddEventHandler('paletoheist:client:showNotification', function(str)
    ShowNotification(str)
end)

--This event send to all police players
RegisterNetEvent('paletoheist:client:policeAlert')
AddEventHandler('paletoheist:client:policeAlert', function(targetCoords)
    ShowNotification(Strings['police_alert'])
    local alpha = 250
    local paletoBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)

    SetBlipHighDetail(paletoBlip, true)
    SetBlipColour(paletoBlip, 1)
    SetBlipAlpha(paletoBlip, alpha)
    SetBlipAsShortRange(paletoBlip, true)

    while alpha ~= 0 do
        Citizen.Wait(500)
        alpha = alpha - 1
        SetBlipAlpha(paletoBlip, alpha)

        if alpha == 0 then
            RemoveBlip(paletoBlip)
            return
        end
    end
end)
