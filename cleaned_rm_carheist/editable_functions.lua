RegisterNetEvent('carheist:client:giveVehicleKey')
AddEventHandler('carheist:client:giveVehicleKey', function(vehiclePlate)
    local plate = string.gsub(vehiclePlate, '^%s*(.-)%s*$', '%1')
    --Write your give vehicle key event for cars
    --Example: TriggerEvent('vehiclekeys:client:SetOwner', plate)
end)

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

RegisterNetEvent('carheist:client:showNotification')
AddEventHandler('carheist:client:showNotification', function(str)
    ShowNotification(str)
end)

--This event send to all police players
RegisterNetEvent('carheist:client:policeAlert')
AddEventHandler('carheist:client:policeAlert', function(targetCoords)
    ShowNotification(Strings['police_alert'])
    local alpha = 250
    local carsBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)

    SetBlipHighDetail(carsBlip, true)
    SetBlipColour(carsBlip, 1)
    SetBlipAlpha(carsBlip, alpha)
    SetBlipAsShortRange(carsBlip, true)

    while alpha ~= 0 do
        Citizen.Wait(500)
        alpha = alpha - 1
        SetBlipAlpha(carsBlip, alpha)

        if alpha == 0 then
            RemoveBlip(carsBlip)
            return
        end
    end
end)
