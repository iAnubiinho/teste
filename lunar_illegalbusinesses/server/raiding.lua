-- Server-side Raiding System

-- Active raids per business
activeRaids = {}

-- Active raid guard entities per business
raidGuardEntities = {}

-- Callback: Get all active raids
lib.callback.register("lunar_illegalbusiness:getRaids", function()
    return activeRaids
end)

-- Cleans up raid guard entities
function CleanupRaidGuards(businessName)
    local guards = raidGuardEntities[businessName]
    if not guards then
        return
    end
    
    for i = 1, #guards do
        if DoesEntityExist(guards[i]) then
            DeleteEntity(guards[i])
        end
    end
end

-- Gets raid data for a specific business
function GetRaid(businessName)
    return activeRaids[businessName]
end

-- Removes an active raid
function RemoveRaid(businessName)
    activeRaids[businessName] = nil
    TriggerClientEvent("lunar_illegalbusiness:removeRaid", -1, businessName)
    TriggerClientEvent("lunar_illegalbusiness:forceRaidExit", -1, businessName)
    CleanupRaidGuards(businessName)
end

-- Guard ped models by business type
GUARD_PED_MODELS = {
    meth = -306958529,
    coke = 1456705429,
    weed = -306958529,
    counterfeit_factory = 1456705429,
    document_forgery = -306958529
}

-- Guard ped variants by business type
GUARD_PED_VARIANTS = {
    meth = 2,
    coke = 1,
    weed = 2,
    counterfeit_factory = 1,
    document_forgery = 2
}

-- Spawns security guards for a raid
function SpawnRaidGuards(businessName, routingBucket)
    activeRaids[businessName].open = true
    
    local guardEntities = {}
    local guardNetIds = {}
    
    local businessType = Config.locations[businessName].type
    local guardPositions = Config.businessTypes[businessType].interior.guards
    local guardModel = GUARD_PED_MODELS[businessType]
    local guardVariant = GUARD_PED_VARIANTS[businessType]
    
    for _, guardCoords in ipairs(guardPositions) do
        local guard = CreatePed(4, guardModel, guardCoords.x, guardCoords.y, guardCoords.z, guardCoords.w, true, true)
        
        SetEntityRoutingBucket(guard, routingBucket)
        GiveWeaponToPed(guard, Config.guards.weapon, 200, true, true)
        SetPedArmour(guard, 100)
        
        -- Apply ped variations
        for component = 0, 11 do
            SetPedComponentVariation(guard, component, guardVariant, 0, 1)
        end
        
        guardEntities[#guardEntities + 1] = guard
        guardNetIds[#guardNetIds + 1] = NetworkGetNetworkIdFromEntity(guard)
    end
    
    TriggerClientEvent("lunar_illegalbusiness:handleRaidGuards", -1, businessName, guardNetIds)
    raidGuardEntities[businessName] = guardEntities
end

-- Periodic raid check
function CheckForNewRaids()
    local chanceRoll = math.random(1, 100)
    
    if chanceRoll > Config.raiding.chance or not Config.raiding.enabled then
        return
    end
    
    -- Collect eligible businesses for raiding
    local eligibleBusinesses = {}
    
    for businessName, business in pairs(Businesses.data()) do
        -- Skip if already being raided
        if activeRaids[businessName] then
            goto continue
        end
        
        -- Skip if not set up
        if business.employees == "none" or business.equipment == "none" then
            goto continue
        end
        
        -- Check product requirement
        if Config.raiding.needsProduct and business.products <= 50 then
            goto continue
        end
        
        eligibleBusinesses[#eligibleBusinesses + 1] = businessName
        
        ::continue::
        
        -- Decrement seized intervals
        if business.seizedIntervals > 0 then
            business.seizedIntervals = business.seizedIntervals - 1
        end
    end
    
    -- Require minimum number of eligible businesses
    if #eligibleBusinesses < Config.raiding.minBought then
        return
    end
    
    -- Select random business for raid
    local targetBusiness = Utils.randomFromTable(eligibleBusinesses)
    local locationConfig = Config.locations[targetBusiness]
    
    -- Dispatch alert
    Dispatch.call(locationConfig.coords, {
        Code = Config.raiding.dispatchCode,
        Title = locale("dispatch_title"),
        Message = locale(locationConfig.type .. "_dispatch_message")
    })
    
    -- Create raid
    TriggerClientEvent("lunar_illegalbusiness:addRaid", -1, targetBusiness)
    activeRaids[targetBusiness] = {
        open = false,
        confiscated = false
    }
    
    -- Timeout to remove raid if not accepted
    SetTimeout(Config.raiding.accept, function()
        if activeRaids[targetBusiness] == "waiting" then
            TriggerClientEvent("lunar_illegalbusiness:removeRaid", -1, targetBusiness)
            RemoveRaid(targetBusiness)
            activeRaids[targetBusiness] = nil
        end
    end)
end

-- Clean up guards on resource stop
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == cache.resource then
        for businessName, _ in pairs(raidGuardEntities) do
            CleanupRaidGuards(businessName)
        end
    end
end)

-- Periodic raid check interval
SetInterval(CheckForNewRaids, Config.raiding.interval)