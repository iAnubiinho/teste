-- Raiding System - Police Raid Management

-- Active raid interaction points
activeRaidPoints = {}

-- Seizes a business (police action after raid)
function SeizeBusiness(businessName)
    local success, errorMessage = lib.callback.await("lunar_illegalbusiness:seizeBusiness", false, businessName)
    
    if not success then
        if errorMessage then
            LR.notify(errorMessage, "error")
        end
        return
    end
    
    LR.progressBar(locale("seizing_business"), 5000, false, {
        dict = "missheistfbisetup1",
        clip = "unlock_loop_janitor"
    })
    
    LR.notify(locale("seized_business"), "success")
end

-- Initiates lockpicking on a business door
function LockpickBusiness(businessName)
    TaskStartScenarioInPlace(cache.ped, "PROP_HUMAN_BUM_BIN", 0, true)
    
    local success = Editable.lockpickMinigame(Config.raiding.minigame)
    if success then
        TriggerServerEvent("lunar_illegalbusiness:unlockedBusiness", businessName)
    end
    
    ClearPedTasks(cache.ped)
end

-- Creates interaction points for a raid
function CreateRaidInteractionPoint(businessName, isUnlocked)
    local locationConfig = Config.locations[businessName]
    local businessTypeConfig = Config.businessTypes[locationConfig.type]
    
    if not isUnlocked then
        -- Create locked business interaction (lockpick only)
        activeRaidPoints[businessName] = Utils.createInteractionPoint({
            coords = locationConfig.target,
            radius = 1.0,
            options = {
                {
                    label = locale("lockpick"),
                    icon = "lock",
                    onSelect = LockpickBusiness,
                    args = businessName,
                    canInteract = function()
                        return Utils.isPolice()
                    end
                }
            }
        })
    else
        -- Notify owner if they have access
        if HasAccess(businessName) then
            LR.notify(locale("raided"), "warning")
            
            local raidBlip = Utils.createBlip(locationConfig.coords, {
                name = locale("raid"),
                sprite = 161,
                size = 2.0,
                color = 0
            })
            
            SetTimeout(300000, function()
                raidBlip.remove()
            end)
        end
        
        -- Create unlocked business interaction (enter + seize)
        activeRaidPoints[businessName] = Utils.createInteractionPoint({
            coords = locationConfig.target,
            radius = 1.0,
            options = {
                {
                    label = locale("enter_business"),
                    icon = businessTypeConfig.icon,
                    onSelect = function()
                        Interior.enter(businessName, true)
                    end,
                    canInteract = function()
                        return Utils.isPolice()
                    end
                },
                {
                    label = locale("seize_business"),
                    icon = "gavel",
                    onSelect = SeizeBusiness,
                    args = businessName,
                    canInteract = function()
                        return Utils.isPolice()
                    end
                }
            }
        })
    end
end

-- Event: Add a new raid
RegisterNetEvent("lunar_illegalbusiness:addRaid", CreateRaidInteractionPoint)

-- Event: Remove an active raid
RegisterNetEvent("lunar_illegalbusiness:removeRaid", function(businessName)
    if activeRaidPoints[businessName] then
        activeRaidPoints[businessName].remove()
    end
end)

-- Event: Business has been unlocked during raid
RegisterNetEvent("lunar_illegalbusiness:unlockedBusiness", function(businessName)
    if activeRaidPoints[businessName] then
        activeRaidPoints[businessName].remove()
    end
    CreateRaidInteractionPoint(businessName, true)
end)

-- Load existing raids when player joins
lib.callback("lunar_illegalbusiness:getRaids", false, function(raids)
    for businessName, raidData in pairs(raids) do
        CreateRaidInteractionPoint(businessName, raidData.open)
    end
end)

-- Configures a ped as a guard with combat AI
function ConfigureGuardPed(guardPed)
    SetPedDropsWeaponsWhenDead(guardPed, false)
    SetPedCombatAbility(guardPed, Config.guards.combatAbility)
    SetPedAccuracy(guardPed, Config.guards.accuracy)
    SetPedRelationshipGroupHash(guardPed, -325466320)
    
    -- Combat attributes
    SetPedCombatAttributes(guardPed, 5, true)   -- Can fight armed peds when not armed
    SetPedCombatAttributes(guardPed, 68, false) -- Flee if target has more attackers
    SetPedCombatAttributes(guardPed, 28, true)  -- Can do drive-bys
    SetPedCombatAttributes(guardPed, 21, true)  -- Can bust player during combat
    
    SetPedCurrentWeaponVisible(guardPed, true)
    
    -- Set movement style (random chance for stationary)
    local movementStyle = 2
    if math.random(4) == 1 then
        movementStyle = 1
    end
    SetPedCombatMovement(guardPed, movementStyle)
    
    -- Equip configured weapon
    local currentWeapon = GetSelectedPedWeapon(guardPed)
    if currentWeapon ~= Config.guards.weapon then
        SetCurrentPedWeapon(guardPed, Config.guards.weapon, true)
    end
    
    SetBlockingOfNonTemporaryEvents(guardPed, true)
    
    -- Adjust position if guard is above player
    local guardCoords = GetEntityCoords(guardPed)
    local playerCoords = GetEntityCoords(cache.ped)
    local heightDiff = playerCoords.z - guardCoords.z
    
    if heightDiff > 3.0 then
        SetEntityCoords(guardPed, guardCoords.x, guardCoords.y, guardCoords.z + 2.0)
        PlaceObjectOnGroundProperly(guardPed)
    end
end

-- Updates guard behavior to attack nearest player
function UpdateGuardCombat(guardPed)
    local guardCoords = GetEntityCoords(guardPed)
    local nearbyPlayers = lib.getNearbyPlayers(guardCoords, 100.0, true)
    
    local closestTarget = nil
    local closestDistance = math.huge
    
    for i = 1, #nearbyPlayers do
        local player = nearbyPlayers[i]
        local distance = #(player.coords - guardCoords)
        
        if distance < closestDistance then
            local serverId = GetPlayerServerId(player.id)
            local hasBusinessAccess = Player(serverId).state.hasBusinessAccess
            
            if not hasBusinessAccess and not Editable.isDead(player.ped) then
                closestTarget = player
                closestDistance = distance
            end
        end
    end
    
    if closestTarget then
        if not GetIsTaskActive(guardPed, 343) then -- TASK_COMBAT_PED
            TaskCombatPed(guardPed, closestTarget.ped, 0, 16)
        end
    else
        if not GetIsTaskActive(guardPed, 357) then -- TASK_GUARD_CURRENT_POSITION
            TaskGuardCurrentPosition(guardPed, 15.0, 10.0, true)
        end
    end
end

-- Initialize guard relationship group
AddRelationshipGroup("BUSINESS_GUARD_AI")

-- Processes all guards for a raid location
function ProcessRaidGuards(guardNetIds)
    -- Set up relationship groups
    SetRelationshipBetweenGroups(0, 507087436, 507087436)  -- Guards neutral to each other
    SetRelationshipBetweenGroups(4, 507087436, 1862763509) -- Guards hate player
    SetRelationshipBetweenGroups(4, 1862763509, 507087436) -- Player hates guards
    
    for i = 1, #guardNetIds do
        local netId = guardNetIds[i]
        
        if NetworkDoesEntityExistWithNetworkId(netId) then
            local guardPed = NetworkGetEntityFromNetworkId(netId)
            local entityOwner = NetworkGetEntityOwner(guardPed)
            
            if entityOwner == cache.playerId then
                if not IsEntityDead(guardPed) then
                    ConfigureGuardPed(guardPed)
                    UpdateGuardCombat(guardPed)
                end
            end
        end
    end
end

-- Event: Continuously handle raid guards
RegisterNetEvent("lunar_illegalbusiness:handleRaidGuards", function(businessName, guardNetIds)
    while activeRaidPoints[businessName] do
        ProcessRaidGuards(guardNetIds)
        Wait(500)
    end
end)