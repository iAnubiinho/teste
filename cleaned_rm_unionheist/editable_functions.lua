RegisterNetEvent('unionheist:client:giveVehicleKey')
AddEventHandler('unionheist:client:giveVehicleKey', function(vehiclePlate)
    local plate = string.gsub(vehiclePlate, '^%s*(.-)%s*$', '%1')
    --Write your give vehicle key event for cutter
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

RegisterNetEvent('unionheist:client:showNotification')
AddEventHandler('unionheist:client:showNotification', function(str)
    ShowNotification(str)
end)

--This event send to all police players
RegisterNetEvent('unionheist:client:policeAlert')
AddEventHandler('unionheist:client:policeAlert', function(targetCoords)
    ShowNotification(Strings['police_alert'])
    local alpha = 250
    local unionBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)

    SetBlipHighDetail(unionBlip, true)
    SetBlipColour(unionBlip, 1)
    SetBlipAlpha(unionBlip, alpha)
    SetBlipAsShortRange(unionBlip, true)

    while alpha ~= 0 do
        Citizen.Wait(500)
        alpha = alpha - 1
        SetBlipAlpha(unionBlip, alpha)

        if alpha == 0 then
            RemoveBlip(unionBlip)
            return
        end
    end
end)
