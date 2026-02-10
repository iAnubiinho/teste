-- Scene Animation System - Synchronized ped and prop animations

Scenes = {}

-- Active scene entities (peds and props)
activeSceneEntities = {}

-- Checks if all synchronized scenes are currently running
function AreScenesRunning(sceneIds)
    for i = 1, #sceneIds do
        if not IsSynchronizedSceneRunning(sceneIds[i]) then
            return false
        end
    end
    return true
end

-- Available idle scenarios for peds when not working
IDLE_SCENARIOS = {
    "WORLD_HUMAN_DRINKING_FACILITY",
    "WORLD_HUMAN_STAND_MOBILE_FACILITY",
    "WORLD_HUMAN_STAND_MOBILE_UPRIGHT_CLUBHOUSE",
    "WORLD_HUMAN_HANG_OUT_STREET"
}

-- Idle animations for peds when business is not productive
IDLE_ANIMATIONS = {
    { dict = "random@homelandsecurity", clip = "knees_loop_girl" },
    { dict = "anim@heists@ornate_bank@hostages@hit", clip = "hit_loop_ped_b" },
    { dict = "anim@heists@ornate_bank@hostages@hit", clip = "hit_loop_ped_c" },
    { dict = "anim@heists@ornate_bank@hostages@hit", clip = "hit_loop_ped_d" },
    { dict = "anim@heists@ornate_bank@hostages@hit", clip = "hit_loop_ped_e" }
}

-- Applies random ped component variations
function ApplyPedVariation(ped, pedConfig)
    -- Apply base variations
    for component = 0, 11 do
        local variant = pedConfig.variant or 0
        SetPedComponentVariation(ped, component, variant, 0, math.random(0, 3))
    end
    
    -- Apply random skin variations for male peds
    if IsPedMale(ped) and not pedConfig.disableRandomize then
        local skinVariant = math.random(0, 2)
        SetPedComponentVariation(ped, 0, skinVariant, 0, 0)
        SetPedComponentVariation(ped, 1, pedConfig.variant or 0, skinVariant, 0)
        SetPedComponentVariation(ped, 3, pedConfig.variant or 0, skinVariant, 0)
        SetPedComponentVariation(ped, 4, pedConfig.variant or 0, skinVariant, 0)
        SetPedComponentVariation(ped, 6, pedConfig.variant or 0, skinVariant, 0)
        SetPedComponentVariation(ped, 11, pedConfig.variant or 0, skinVariant, 0)
    end
end

-- Creates a ped with basic configuration
function CreateScenePed(pedConfig, spawnCoords)
    lib.requestModel(pedConfig.model)
    
    local coords = pedConfig.altCoords or spawnCoords
    local ped = CreatePed(4, pedConfig.model, coords.x, coords.y, coords.z - 1.0, 0.0, false, true)
    
    SetEntityHeading(ped, coords.w)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanBeTargetted(ped, false)
    
    ApplyPedVariation(ped, pedConfig)
    
    return ped
end

-- Plays an idle animation on a ped and monitors it
function PlayIdleAnimation(ped, animation)
    lib.requestAnimDict(animation.dict)
    TaskPlayAnim(ped, animation.dict, animation.clip, 8.0, 8.0, -1, 1, 1.0, false, false, false)
    FreezeEntityPosition(ped, true)
    SetModelAsNoLongerNeeded(ped)
    
    -- Monitor and restart animation if it stops
    CreateThread(function()
        while DoesEntityExist(ped) do
            if not IsEntityPlayingAnim(ped, animation.dict, animation.clip, 3) then
                TaskPlayAnim(ped, animation.dict, animation.clip, 8.0, 8.0, -1, 1, 1.0, false, false, false)
            end
            Wait(1000)
        end
    end)
    
    table.insert(activeSceneEntities, ped)
end

-- Plays animation scenes with synchronized scenes (normal working mode)
function Scenes.play(sceneConfigs, businessData, additionalData)
    local syncSceneIds = {}
    
    -- Check if business is idle (no supplies or full products)
    local isIdle = businessData and (businessData.supplies == 0.0 or businessData.products == 100.0)
    
    -- Handle raid mode (additionalData provided)
    if additionalData and businessData then
        Scenes.stop()
        
        for _, sceneConfig in ipairs(sceneConfigs) do
            -- Skip scenes that don't match current employee/equipment level
            if sceneConfig.employees and sceneConfig.employees ~= businessData.employees then
                goto continue
            end
            if sceneConfig.equipment and sceneConfig.equipment ~= businessData.equipment then
                goto continue
            end
            
            local spawnCoords = sceneConfig.coords
            
            for _, pedConfig in ipairs(sceneConfig.peds) do
                lib.requestModel(pedConfig.model)
                
                local coords = pedConfig.altCoords or spawnCoords
                local ped = CreatePed(4, pedConfig.model, coords.x, coords.y, coords.z - 1.0, 0.0, false, true)
                
                SetEntityHeading(ped, coords.w)
                SetBlockingOfNonTemporaryEvents(ped, true)
                ApplyPedVariation(ped, pedConfig)
                
                -- Play random idle animation
                local idleAnim = Utils.randomFromTable(IDLE_ANIMATIONS)
                lib.requestAnimDict(idleAnim.dict)
                TaskPlayAnim(ped, idleAnim.dict, idleAnim.clip, 8.0, 8.0, -1, 1, 1.0, false, false, false)
                FreezeEntityPosition(ped, true)
                SetModelAsNoLongerNeeded(pedConfig.model)
                
                -- Monitor animation
                CreateThread(function()
                    while DoesEntityExist(ped) do
                        if not IsEntityPlayingAnim(ped, idleAnim.dict, idleAnim.clip, 3) then
                            TaskPlayAnim(ped, idleAnim.dict, idleAnim.clip, 8.0, 8.0, -1, 1, 1.0, false, false, false)
                        end
                        Wait(1000)
                    end
                end)
                
                table.insert(activeSceneEntities, ped)
            end
            
            ::continue::
        end
        return
    end
    
    -- Handle idle mode (no supplies or full products)
    if isIdle then
        for _, sceneConfig in ipairs(sceneConfigs) do
            if sceneConfig.employees and sceneConfig.employees ~= businessData.employees then
                goto continue
            end
            if sceneConfig.equipment and sceneConfig.equipment ~= businessData.equipment then
                goto continue
            end
            
            local spawnCoords = sceneConfig.coords
            
            for _, pedConfig in ipairs(sceneConfig.peds) do
                local ped = CreateScenePed(pedConfig, spawnCoords)
                TaskStartScenarioInPlace(ped, Utils.randomFromTable(IDLE_SCENARIOS))
                table.insert(activeSceneEntities, ped)
            end
            
            ::continue::
        end
        return
    end
    
    -- Normal working mode - synchronized scenes
    repeat
        Scenes.stop()
        table.wipe(syncSceneIds)
        
        for _, sceneConfig in ipairs(sceneConfigs) do
            -- Filter by business data if provided
            if businessData then
                if sceneConfig.employees and sceneConfig.employees ~= businessData.employees then
                    goto continue
                end
                if sceneConfig.equipment and sceneConfig.equipment ~= businessData.equipment then
                    goto continue
                end
            end
            
            local spawnCoords = sceneConfig.coords
            lib.requestAnimDict(sceneConfig.dict)
            
            -- Calculate scene position with offset
            local sceneOffset = vector4(
                sceneConfig.offset.x,
                sceneConfig.offset.y,
                sceneConfig.offset.z,
                sceneConfig.offset.w or 0.0
            )
            local scenePosition = spawnCoords - sceneOffset
            
            -- Create synchronized scene
            local syncScene = CreateSynchronizedScene(
                scenePosition.x, scenePosition.y, scenePosition.z,
                0.0, 0.0, scenePosition.w, 2
            )
            SetSynchronizedSceneLooped(syncScene, true)
            
            -- Create and attach peds to synchronized scene
            for _, pedConfig in ipairs(sceneConfig.peds) do
                local ped = CreateScenePed(pedConfig, spawnCoords)
                
                TaskSynchronizedScene(
                    ped, syncScene, sceneConfig.dict, pedConfig.clip,
                    1.5, -4.0, 1, 16, 1148846080, 0
                )
                
                table.insert(activeSceneEntities, ped)
            end
            
            -- Create and attach props to synchronized scene
            for _, propConfig in ipairs(sceneConfig.props) do
                lib.requestModel(propConfig.model)
                
                local prop = CreateObjectNoOffset(
                    propConfig.model,
                    spawnCoords.x, spawnCoords.y, spawnCoords.z,
                    false, true, false
                )
                
                PlaySynchronizedEntityAnim(
                    prop, syncScene, propConfig.clip, sceneConfig.dict,
                    1.0, -1.0, 0, 1148846080
                )
                
                ForceEntityAiAndAnimationUpdate(prop)
                SetModelAsNoLongerNeeded(propConfig.model)
                
                table.insert(activeSceneEntities, prop)
            end
            
            -- Start scene at random phase
            SetSynchronizedScenePhase(syncScene, 0.01 * math.random(1, 100))
            DetachSynchronizedScene(syncScene)
            
            syncSceneIds[#syncSceneIds + 1] = syncScene
            
            ::continue::
        end
        
        Wait(0)
    until AreScenesRunning(syncSceneIds)
end

-- Stops all active scenes and cleans up entities
function Scenes.stop()
    for _, entity in ipairs(activeSceneEntities) do
        DeleteEntity(entity)
    end
    table.wipe(activeSceneEntities)
end