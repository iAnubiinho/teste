Cracking = false
gStatus = false

RegisterNetEvent("fleeca:safecracking:loop")
AddEventHandler("fleeca:safecracking:loop", function(difficulty, functionName)
	loadSafeTexture()
	loadSafeAudio()
	difficultySetting = {}
	for z = 1, difficulty do
		difficultySetting[z] = 1
	end
	curLock = 1
	factor = difficulty
	i = 0.0
	safelock = 0
	desirednum = math.floor(math.random(99))
	if desirednum == 0 then desirednum = 1 end
	openString = "lock_open"
	closedString = "lock_closed"
	Cracking = true
	mybasepos = GetEntityCoords(PlayerPedId())
	dicks = 1
    busy = true
	local pinfall = false
	while Cracking do
        ShowHelpNotification(Strings['saferack'])
		DisableControlAction(38, 0, true)
		DisableControlAction(44, 0, true)
		DisableControlAction(74, 0, true)
		DisableControlAction(191, 0, true)
		if IsControlPressed(0, 189) then
            pressed = true
			if dicks > 1 then
				i = i + 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );
				dicks = 0
			end
        else
            pressed = false
		end
		if IsControlPressed(0, 190) then
            pressed = true
			if dicks > 1 then
				i = i - 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );
				dicks = 0
			end
        else
            pressed = false
		end
		dicks = dicks + 0.2
		if i < 0.0 then i = 360.0 end
		if i > 360.0 then i = 0.0 end
		safelock = math.floor(100-(i / 3.6))
		if #(mybasepos - GetEntityCoords(PlayerPedId())) > 2 then
			Cracking = false
			SafeCrackCallback(false)
		end
		if curLock > difficulty then
			Cracking = false
			SafeCrackCallback(true)
            gStatus = true
		end
		if IsControlJustPressed(0, 202) then
			Cracking = false
			SafeCrackCallback('Escaped')
            RenderScriptCams(false, true, 1500, true, false)
            DestroyCam(cam, false)
            DeleteObject(bag)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('fleeca:server:sync', 'action', {'keycard', index})
            busy = false
            sceneSetup = false
        end
		if safelock == desirednum then
			if not pinfall then
				PlaySoundFrontend( 0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", true );
				pinfall = true
			end
			if IsDisabledControlJustPressed(0, 191) and not pressed then
				pinfall = false
				PlaySoundFrontend( 0, "TUMBLER_RESET", "SAFE_CRACK_SOUNDSET", true );
				factor = factor / 2
				i = 0.0
				safelock = 0
				desirednum = math.floor(math.random(99))
				if desirednum == 0 then desirednum = 1 end
				difficultySetting[curLock] = 0
				curLock = curLock + 1
			end
		else
			pinfall = false
		end
		DrawSprite( "MPSafeCracking", "Dial_BG", 0.65, 0.5, 0.3, GetAspectRatio() * 0.3, 0, 255, 255, 255, 255, 255 )
		DrawSprite( "MPSafeCracking", "Dial", 0.65, 0.5, 0.3 * 0.5, GetAspectRatio() * 0.3 * 0.5, i, 255, 255, 255, 255 )
		addition = 0.70
		xaddition = 0.58
		for x = 1, difficulty do
			if difficultySetting[x] ~= 1 then
				DrawSprite( "MPSafeCracking", openString, xaddition, addition, 0.03, GetAspectRatio() * 0.03, 0, 255, 255, 255, 255)
			else
				DrawSprite( "MPSafeCracking", closedString, xaddition, addition, 0.03, GetAspectRatio() * 0.03, 0, 255, 255, 255, 255)
			end
			xaddition = xaddition + 0.05
			if x == 10 or x == 20 or x == 30 then
				addition = 0.25
				xaddition = xaddition + 0.05
			end
		end
        Wait(1)
	end
end)

function StartSafeCrack(Difficulty, CallBack)
	SafeCrackCallback = CallBack
	TriggerEvent("fleeca:safecracking:loop", Difficulty)
end

function loadSafeTexture()
	RequestStreamedTextureDict( "MPSafeCracking", false );
	while not HasStreamedTextureDictLoaded( "MPSafeCracking" ) do
		Citizen.Wait(0)
	end
end

function loadSafeAudio()
	RequestAmbientAudioBank( "SAFE_CRACK", false )
end

function SafeCrackStart()
    Citizen.CreateThread(function()
        StartSafeCrack(4, function(status)
        end)
        Cracking = true
        while Cracking do
            Wait(1)
        end
        if gStatus then
            gStatus = false
            SafeCrackSuccess()
        end
    end)
end

function SafeCrackSuccess()
    keycard = true
    busy = false
    Cracking = false
    gStatus = nil
    robber = true
end

