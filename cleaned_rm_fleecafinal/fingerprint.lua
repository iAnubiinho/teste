math.randomseed(GetGameTimer())
local randomPrint = math.random(1, 8)
local selected = 1
local slices = {}
local minigameLoop = false
local RemainingTime = 200
local RemainingHearths = 3
local timeIsUp = false
local successCount = 0

function DrawRetroSprite(textureDict, textureName, nums, color, slice)
    if selected == slice then
        color = {255, 255, 255}
    end
    RequestStreamedTextureDict(textureDict)
    DrawSprite(textureDict, textureName, nums[1], nums[2], nums[3], nums[4], nums[5], color[1], color[2], color[3], 1.0)
end

function GetDrawList()
    drawTable = {
        {"mpfclone_retro_background", "fingerprint_hacking_minigame_background", {0.5, 0.5, 1.0, 1.0, 0.0}, {124, 252, 0}, nil},
        {"mpfclone_retro_printfull"..randomPrint, "fingerprint_hacking_minigame_fingerprints_0"..randomPrint, {0.63, 0.6, 0.25, 0.5, 0.0}, {124, 252, 0}, nil},
        {"mpfclone_retro_printfull"..randomPrint, "fingerprint_hacking_minigame_fingerprints_0"..randomPrint.."_slice_0"..slices[1], {0.326, 0.358, 0.24, 0.07, 0.0}, {124, 255, 0}, 1},
        {"mpfclone_retro_printfull"..randomPrint, "fingerprint_hacking_minigame_fingerprints_0"..randomPrint.."_slice_0"..slices[2], {0.326, 0.428, 0.24, 0.07, 0.0}, {124, 255, 0}, 2},
        {"mpfclone_retro_printfull"..randomPrint, "fingerprint_hacking_minigame_fingerprints_0"..randomPrint.."_slice_0"..slices[3], {0.326, 0.498, 0.24, 0.07, 0.0}, {124, 255, 0}, 3},
        {"mpfclone_retro_printfull"..randomPrint, "fingerprint_hacking_minigame_fingerprints_0"..randomPrint.."_slice_0"..slices[4], {0.326, 0.568, 0.24, 0.07, 0.0}, {124, 255, 0}, 4},
        {"mpfclone_retro_printfull"..randomPrint, "fingerprint_hacking_minigame_fingerprints_0"..randomPrint.."_slice_0"..slices[5], {0.326, 0.638, 0.24, 0.07, 0.0}, {124, 255, 0}, 5},
        {"mpfclone_retro_printfull"..randomPrint, "fingerprint_hacking_minigame_fingerprints_0"..randomPrint.."_slice_0"..slices[6], {0.326, 0.708, 0.24, 0.07, 0.0}, {124, 255, 0}, 6},
        {"mpfclone_retro_printfull"..randomPrint, "fingerprint_hacking_minigame_fingerprints_0"..randomPrint.."_slice_0"..slices[7], {0.326, 0.778, 0.24, 0.07, 0.0}, {124, 255, 0}, 7},
        {"mpfclone_retro_printfull"..randomPrint, "fingerprint_hacking_minigame_fingerprints_0"..randomPrint.."_slice_0"..slices[8], {0.326, 0.848, 0.24, 0.07, 0.0}, {124, 255, 0}, 8},
    }
end

DrawScreenText = function(text, scale, posX, posY, color)
	SetTextFont(0)
	SetTextScale(scale, scale)
    SetTextDropShadow(0, 0, 0, 0, 0)
	SetTextColour(color[1], color[2], color[3], 255)
	BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(posX, posY)
end

SecondsToClock = function(seconds)
	seconds = tonumber(seconds)
	if seconds <= 0 then
		return "00:00"
	else
		local mins = string.format("%02.f", math.floor(seconds / 60))
		local secs = string.format("%02.f", math.floor(seconds - mins * 60))
		return string.format("%s:%s", mins, secs)
	end
end

ShowRemaining = function()
    DrawScreenText(SecondsToClock(RemainingTime), 0.7, 0.3, 0.115, {255, 255, 255})
    DrawScreenText(RemainingHearths, 0.5, 0.32, 0.219, {255, 255, 255})
end

Timer = function()
    Citizen.CreateThread(function()
        while minigameLoop do
            if RemainingTime <= 0 then
                timeIsUp = true
            end
            RemainingTime = RemainingTime - 1
            Citizen.Wait(1000)
        end
    end)
end

ButtonMessage = function(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

Button = function(ControlButton)
    PushScaleformMovieMethodParameterButtonName(ControlButton)
end

setupScaleform = function(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
	
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, 191, true))
    ButtonMessage(Strings['confirm'])
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, 172, true))
    Button(GetControlInstructionalButton(2, 173, true))
    ButtonMessage(Strings['change'])
    PopScaleformMovieFunctionVoid()


    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, 175, true))
    Button(GetControlInstructionalButton(2, 174, true))
    ButtonMessage(Strings['change_slice'])
    PopScaleformMovieFunctionVoid()
	
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, 194, true))
    ButtonMessage(Strings['exit'])
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end


CreateScale = function()
	scaleType = setupScaleform("instructional_buttons")
end

function StartFingerprint(cb)
    for i = 1, 8 do
        slices[i] = math.random(1, 8)
    end
    GetDrawList()
    minigameLoop = true
    SendNUIMessage({
        type = 'intro'
    })
    Wait(3500)
    Citizen.CreateThread(function()
        Citizen.Wait(500)
        Timer()
    end)
    while minigameLoop do
        GetDrawList()
        for i = 1, #drawTable do
            DrawRetroSprite(drawTable[i][1], drawTable[i][2], drawTable[i][3], drawTable[i][4], drawTable[i][5])
        end
        ShowRemaining()
        CreateScale()
        DrawScaleformMovieFullscreen(scaleType, 255, 255, 255, 255, 0)
        if RemainingHearths <= 0 then
            SendNUIMessage({
                type = 'fail'
            })
            cb(false)
            minigameLoop = false
            timeIsUp = false
        end
        if IsControlJustPressed(0, 172) or IsDisabledControlJustPressed(0, 172) then
            PlaySoundFrontend(-1, "Cursor_Move", "DLC_H3_Cas_Finger_Minigame_Sounds", true)
            if (selected - 1) < 1 then
                selected = 8
            else
                selected = selected - 1
            end
        elseif IsControlJustPressed(0, 173) or IsDisabledControlJustPressed(0, 173) then
            PlaySoundFrontend(-1, "Cursor_Move", "DLC_H3_Cas_Finger_Minigame_Sounds", true)
            if (selected + 1) > 8 then 
                selected = 1
            else
                selected = selected + 1
            end
        elseif IsControlJustPressed(0, 174) or IsDisabledControlJustPressed(0, 174) then
            PlaySoundFrontend(-1, "Select_Print_Tile", "DLC_H3_Cas_Finger_Minigame_Sounds", true)
            if (slices[selected] - 1) < 1 then
                slices[selected] = 8
            else
                slices[selected] = slices[selected] - 1
            end
        elseif IsControlJustPressed(0, 175) or IsDisabledControlJustPressed(0, 175) then
            PlaySoundFrontend(-1, "Deselect_Print_Tile", "DLC_H3_Cas_Finger_Minigame_Sounds", true)
            if (slices[selected] + 1) > 8 then
                slices[selected] = 1
            else
                slices[selected] = slices[selected] + 1
            end
        end
        if IsControlJustPressed(0, 194) or IsDisabledControlJustPressed(0, 194) then
            cb(false)
            SendNUIMessage({
                type = 'fail'
            })
            minigameLoop = false
        end
        if IsControlJustPressed(0, 191) or IsDisabledControlJustPressed(0, 191) then
            if slices[1] == 1 and slices[2] == 2 and slices[3] == 3 and slices[4] == 4 and slices[5] == 5 and slices[6] == 6 and slices[7] == 7 and slices[8] == 8 then
                PlaySoundFrontend(-1, "Target_Match", "DLC_H3_Cas_Finger_Minigame_Sounds", true)
                successCount = successCount + 1
                if successCount ~= 3 then
                    oldPrint = randomPrint
                    repeat
                        randomPrint = math.random(1, 8)
                    until oldPrint ~= randomPrint
                    for i = 1, 8 do
                        slices[i] = math.random(1, 8)
                    end
                else
                    SendNUIMessage({
                        type = 'success'
                    })
                    cb(true)
                    minigameLoop = false
                end
            else
                PlaySoundFrontend(-1, "No_Match", "DLC_H3_Cas_Finger_Minigame_Sounds", true)
                RemainingHearths = RemainingHearths - 1
            end
        end
        if timeIsUp then
            SendNUIMessage({
                type = 'fail'
            })
            cb(false)
            minigameLoop = false
            timeIsUp = false
        end
        Citizen.Wait(1)
    end
    reset_minigame()
end

function reset_minigame()
    minigameLoop = false
    timeIsUp = false
    successCount = 0
    RemainingHearths = 3
    RemainingTime = 200
    slices = {}
    selected = 1
    randomPrint = math.random(1, 8)
end