local Cracking = false
local sceneSetup = false
local gStatus

RegisterNetEvent("safecracking:loop")
AddEventHandler("safecracking:loop", function(difficulty, functionName)
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
    TriggerServerEvent('undergroundheist:server:sync', 'safecrack')
	local pinfall = false
    SafeCrackAnim(1)
	while Cracking do
        ShowHelpNotification("~INPUT_FRONTEND_LEFT~ ~INPUT_FRONTEND_RIGHT~ Rotate\n~INPUT_FRONTEND_RDOWN~ Check")
		DisableControlAction(38, 0, true)
		DisableControlAction(44, 0, true)
		DisableControlAction(74, 0, true)
		DisableControlAction(191, 0, true)
		if IsControlPressed(0, 189) then
			if dicks > 1 then
				i = i + 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );
				dicks = 0
			end
		end
		if IsControlPressed(0, 190) then
			if dicks > 1 then
				i = i - 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );
				dicks = 0
			end
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
            TriggerServerEvent('undergroundheist:server:sync', 'safecrack')
            busy = false
            sceneSetup = false
        end
		if safelock == desirednum then
			if not pinfall then
				PlaySoundFrontend( 0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", true );
				pinfall = true
			end
			if IsDisabledControlPressed(0, 191) then
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

function SafeCrackAnim(anim)
    if not sceneSetup then
        sceneSetup = true
        local ped = PlayerPedId()
        local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
        animDict = 'anim@scripted@heist@ig15_safe_crack@male@'
        
        loadAnimDict(animDict)
        loadModel('hei_p_m_bag_var22_arm_s')
        loadModel('h4_prop_h4_cash_bon_01a')
        bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), pedCo, 1, 1, 0)
        cashbon = CreateObject(GetHashKey('h4_prop_h4_cash_bon_01a'), vector3(952.399, -58.222, 25.6423), 1, 1, 0)
        sceneObject = GetClosestObjectOfType(pedCo, 2.0, GetHashKey('h4_prop_h4_safe_01a'), 0, 0, 0)
        NetworkRegisterEntityAsNetworked(sceneObject)
        NetworkRequestControlOfEntity(sceneObject)
        
        scenePos = GetEntityCoords(sceneObject)
        sceneRot = GetEntityRotation(sceneObject)

        cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
        SetCamActive(cam, true)
        RenderScriptCams(true, 1, 1500, 1, 0)
        
        for i = 1, #SafeCrack['animations'] do
            SafeCrack['scenes'][i] = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, true, false, 1065353216, 0, 1.0)
            NetworkAddPedToSynchronisedScene(ped, SafeCrack['scenes'][i], animDict, SafeCrack['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
            NetworkAddEntityToSynchronisedScene(bag, SafeCrack['scenes'][i], animDict, SafeCrack['animations'][i][2], 1.0, -1.0, 1148846080)
            NetworkAddEntityToSynchronisedScene(sceneObject, SafeCrack['scenes'][i], animDict, SafeCrack['animations'][i][3], 1.0, -1.0, 1148846080)
            if i == 5 then
                NetworkAddEntityToSynchronisedScene(cashbon, SafeCrack['scenes'][i], animDict, 'door_open_cash_bond', 1.0, -1.0, 1148846080)
            elseif i == 6 then
                NetworkAddEntityToSynchronisedScene(cashbon, SafeCrack['scenes'][i], animDict, SafeCrack['animations'][i][4], 1.0, -1.0, 1148846080)
            end
        end
    end

    NetworkStartSynchronisedScene(SafeCrack['scenes'][anim])
    if anim == 1 then
        PlayCamAnim(cam, 'enter_cam', animDict, scenePos, sceneRot, 0, 2)
    elseif anim == 5 then
        PlayCamAnim(cam, 'door_open_cam', animDict, scenePos, sceneRot, 0, 2)
    elseif anim == 6 then
        PlayCamAnim(cam, 'success_with_stack_bonds_cam', animDict, scenePos, sceneRot, 0, 2)
    end
end

function StartSafeCrack(Difficulty, CallBack)
	SafeCrackCallback = CallBack
	TriggerEvent("safecracking:loop", Difficulty)
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
    SafeCrackAnim(5)
    Wait(2500)
    SafeCrackAnim(6)
    Wait(2000)
    RenderScriptCams(false, true, 1500, true, false)
    DestroyCam(cam, false)
    TriggerServerEvent('undergroundheist:server:sceneSync', 'h4_prop_h4_safe_01a', 'anim@scripted@heist@ig15_safe_crack@male@', 'door_open_safe', GetEntityCoords(sceneObject), GetEntityRotation(sceneObject))
    TriggerServerEvent('undergroundheist:server:rewardItem', Config['UndergroundHeist']['rewardItems'][6]['itemName'], Config['UndergroundHeist']['rewardItems'][6]['count'], 'item')
    SetEntityAsMissionEntity(sceneObject, 1, 1)
    DeleteObjectSync(sceneObject)
    DeleteObject(bag)
    DeleteObject(cashbon)
    ClearPedTasks(PlayerPedId())
    busy = false
    Cracking = false
    sceneSetup = false
    gStatus = nil
    robber = true
end

