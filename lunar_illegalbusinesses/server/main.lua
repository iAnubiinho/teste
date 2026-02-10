-- Server Main - Business Management Core

-- Initialize random seed
math.randomseed(os.time())

-- Player inside business tracking
playerInsideBusiness = {}

-- Player count per business
businessPlayerCount = {}

-- Player identity cache (identifier -> name)
playerIdentityCache = {}

-- Returns which business a player is inside
function GetInside(playerId)
    return playerInsideBusiness[playerId]
end

-- Callback: Get businesses the player has access to
lib.callback.register("lunar_illegalbusiness:getBusinessesAccess", function(playerId)
    local player = Framework.getPlayerFromId(playerId)
    if not player then
        return
    end
    
    -- Wait for businesses to be ready
    while not Businesses.ready do
        Wait(0)
    end
    
    local businessList = Businesses.data()
    local accessList = {}
    local playerIdentifier = player:getIdentifier()
    
    for businessName, business in pairs(businessList) do
        if business:hasAccess(playerIdentifier) then
            accessList[businessName] = (business.identifier == playerIdentifier)
        end
    end
    
    return accessList
end)

-- Load player identities from database on server start
MySQL.ready(function()
    if Framework.name == "es_extended" then
        local users = MySQL.query.await("SELECT identifier, firstname, lastname FROM users")
        for _, user in ipairs(users) do
            local name = (user.firstname and user.firstname .. " " .. user.lastname) or "IDENTITY_NOT_WORKING"
            playerIdentityCache[user.identifier] = name
        end
    elseif Framework.name == "qb-core" then
        local players = MySQL.query.await("SELECT citizenid, charinfo FROM players")
        for _, player in ipairs(players) do
            local charInfo = json.decode(player.charinfo)
            playerIdentityCache[player.citizenid] = charInfo.firstname .. " " .. charInfo.lastname
        end
    end
end)

-- Handle ESX player loaded
AddEventHandler("esx:playerLoaded", function(playerId, xPlayer)
    local name = (xPlayer.get("firstName") and xPlayer.get("firstName") .. " " .. xPlayer.get("lastName")) or "IDENTITY_NOT_WORKING"
    playerIdentityCache[xPlayer.identifier] = name
end)

-- Handle QBCore player loaded
AddEventHandler("QBCore:Server:PlayerLoaded", function(player)
    local citizenId = player.PlayerData.citizenid
    local charInfo = player.PlayerData.charinfo
    playerIdentityCache[citizenId] = charInfo.firstname .. " " .. charInfo.lastname
end)

-- Clean up when player disconnects
AddEventHandler("playerDropped", function()
    local playerId = source
    local businessName = playerInsideBusiness[playerId]
    
    if businessName then
        businessPlayerCount[businessName] = businessPlayerCount[businessName] - 1
    end
end)

-- Callback: Get business keys for UI
lib.callback.register("lunar_illegalbusiness:getBusinessKeys", function(playerId)
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    if not player or not business then
        return
    end
    
    if not business:hasAccess(player:getIdentifier()) then
        return
    end
    
    local keyHolders = {}
    for identifier, _ in pairs(business.keys) do
        keyHolders[#keyHolders + 1] = {
            identifier = identifier,
            name = playerIdentityCache[identifier]
        }
    end
    
    return keyHolders
end)

-- Business routing buckets (isolated instances)
businessRoutingBuckets = {}
local bucketId = 7000
for businessName, _ in pairs(Config.locations) do
    businessRoutingBuckets[businessName] = bucketId
    SetRoutingBucketPopulationEnabled(bucketId, false)
    bucketId = bucketId + 1
end

-- Callback: Enter a business interior
lib.callback.register("lunar_illegalbusiness:enter", function(playerId, businessName)
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(businessName)
    local raid = GetRaid(businessName)
    
    -- Check access
    local hasAccess = player and business and business:hasAccess(player:getIdentifier())
    local isRaidOpen = raid and raid.open
    
    if not hasAccess and not isRaidOpen then
        return
    end
    
    -- Mark business as entered
    SetTimeout(0, function()
        business.entered = true
        if business.seizedIntervals == 0 then
            business.seizedIntervals = -1
        end
    end)
    
    -- Track player inside business
    playerInsideBusiness[playerId] = businessName
    
    -- Update player count
    if not businessPlayerCount[businessName] then
        businessPlayerCount[businessName] = 0
    end
    businessPlayerCount[businessName] = businessPlayerCount[businessName] + 1
    
    -- Move player to business routing bucket
    SetPlayerRoutingBucket(playerId, businessRoutingBuckets[businessName])
    
    return business, (raid and raid.open)
end)

-- Event: Exit a business interior
RegisterNetEvent("lunar_illegalbusiness:exit", function()
    local playerId = source
    local businessName = playerInsideBusiness[playerId]
    
    if not businessName then
        return
    end
    
    playerInsideBusiness[playerId] = nil
    businessPlayerCount[businessName] = businessPlayerCount[businessName] - 1
    SetPlayerRoutingBucket(playerId, 0)
    
    -- If player was driving a vehicle, force exit other players
    if businessPlayerCount[businessName] > 0 then
        for otherPlayerId, otherBusiness in pairs(playerInsideBusiness) do
            if otherBusiness == businessName then
                local playerPed = GetPlayerPed(otherPlayerId)
                local attachedTo = GetEntityAttachedTo(playerPed)
                if attachedTo ~= 0 then
                    TriggerClientEvent("lunar_illegalbusiness:forceExit", otherPlayerId)
                    break
                end
            end
        end
    end
end)

-- Callback: Buy supplies
lib.callback.register("lunar_illegalbusiness:buySupplies", function(playerId)
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    if not player or not business or business.supplies == 100 then
        return
    end
    
    local accountBalance = player:getAccountMoney(Config.supplies.account)
    local price = Config.supplies.price
    
    if accountBalance >= price then
        player:removeAccountMoney(Config.supplies.account, price)
        
        local addAmount = Config.supplies.add or 100
        business.supplies = math.min(business.supplies + addAmount, 100)
        business:update(true)
        
        LogToDiscord(player, string.format([[
Bought supplies for the business.
Business name: %s]], business.name))
        
        return true
    end
    
    return false
end)

-- Callback: Upgrade equipment
lib.callback.register("lunar_illegalbusiness:upgradeEquipment", function(playerId)
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    if not player or not business or business.equipment ~= "low" then
        return
    end
    
    local accountBalance = player:getAccountMoney(Config.equipment.account)
    local price = Config.equipment.upgradePrice
    
    if accountBalance >= price then
        player:removeAccountMoney(Config.equipment.account, price)
        business.equipment = "high"
        business:update(true)
        
        LogToDiscord(player, string.format([[
Purchased the equipment upgrade.
Business name: %s]], business.name))
        
        return true
    end
    
    return false
end)

-- Callback: Upgrade employees
lib.callback.register("lunar_illegalbusiness:upgradeEmployees", function(playerId)
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    if not player or not business or business.employees ~= "low" then
        return
    end
    
    local accountBalance = player:getAccountMoney(Config.employees.account)
    local price = Config.employees.upgradePrice
    
    if accountBalance >= price then
        player:removeAccountMoney(Config.employees.account, price)
        business.employees = "high"
        business:update(true)
        
        LogToDiscord(player, string.format([[
Purchased the employees upgrade.
Business name: %s]], business.name))
        
        return true
    end
    
    return false
end)

-- Callback: Buy security
lib.callback.register("lunar_illegalbusiness:buySecurity", function(playerId)
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    if not player or not business or business.security then
        return
    end
    
    local accountBalance = player:getAccountMoney(Config.security.account)
    local price = Config.security.price
    
    if accountBalance >= price then
        player:removeAccountMoney(Config.security.account, price)
        business.security = true
        business:update(true)
        
        LogToDiscord(player, string.format([[
Purchased the security upgrade.
Business name: %s]], business.name))
        
        return true
    end
    
    return false
end)

-- Event: Give keys to another player
RegisterNetEvent("lunar_illegalbusiness:giveKeys", function(targetPlayerId)
    local playerId = source
    local player = Framework.getPlayerFromId(playerId)
    local targetPlayer = Framework.getPlayerFromId(targetPlayerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    -- Check if player is the owner
    if not player or player == targetPlayer or business.identifier ~= player:getIdentifier() then
        return
    end
    
    if not targetPlayer then
        LR.notify(playerId, locale("invalid_id"), "error")
        return
    end
    
    business:grantAccess(targetPlayer)
    business:update(false)
    LR.notify(playerId, locale("gave_keys"), "success")
end)

-- Event: Transfer business ownership
RegisterNetEvent("lunar_illegalbusiness:transferOwnership", function(targetPlayerId)
    local playerId = source
    local player = Framework.getPlayerFromId(playerId)
    local targetPlayer = Framework.getPlayerFromId(targetPlayerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    -- Check if player is the owner
    if not player or player == targetPlayer or business.identifier ~= player:getIdentifier() then
        return
    end
    
    if not targetPlayer then
        LR.notify(playerId, locale("invalid_id"), "error")
        return
    end
    
    business:transfer(targetPlayer)
    LR.notify(playerId, locale("transfered_ownership"), "success")
    
    LogToDiscord(player, string.format([[
Transfered a business to a player.
Business name: %s
Target player: %s (%s)]], business.name, GetPlayerName(targetPlayerId), targetPlayer:getIdentifier()))
end)

-- Event: Remove keys from a player
RegisterNetEvent("lunar_illegalbusiness:removeKeys", function(identifier)
    local playerId = source
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    -- Check if player is the owner
    if not player or business.identifier ~= player:getIdentifier() then
        return
    end
    
    business:removeAccess(identifier)
    business:update(false)
    LR.notify(playerId, locale("removed_keys"), "success")
end)

-- Camera system tracking
cameraViewingPlayers = {}

-- Event: Player opened security camera
RegisterNetEvent("lunar_illegalbusiness:openedCamera", function(tempPedNetId)
    local playerId = source
    local businessName = playerInsideBusiness[playerId]
    
    if cameraViewingPlayers[playerId] or not businessName then
        return
    end
    
    cameraViewingPlayers[playerId] = tempPedNetId
    SetPlayerRoutingBucket(playerId, 0)
end)

-- Event: Player closed security camera
RegisterNetEvent("lunar_illegalbusiness:closedCamera", function()
    local playerId = source
    local tempPedNetId = cameraViewingPlayers[playerId]
    
    if not tempPedNetId then
        return
    end
    
    cameraViewingPlayers[playerId] = nil
    TriggerClientEvent("lunar_illegalbusiness:removeTempPed", -1, tempPedNetId)
    
    local businessName = playerInsideBusiness[playerId]
    SetPlayerRoutingBucket(playerId, businessRoutingBuckets[businessName])
end)

-- Callback: Start resupply mission
lib.callback.register("lunar_illegalbusiness:startResupplyMission", function(playerId)
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    if not player or not business then
        return
    end
    
    return StartResupplyMission(playerId, business)
end)

-- Callback: Start selling mission
lib.callback.register("lunar_illegalbusiness:startSellingMission", function(playerId)
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    if not player or not business then
        return
    end
    
    return StartSellingMission(playerId, business)
end)

-- Event: Take out products as items
RegisterNetEvent("lunar_illegalbusiness:takeOutProducts", function()
    local playerId = source
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    if not player or not business then
        return
    end
    
    -- Get product item config
    local locationType = Config.locations[business.name].type
    local productConfig = Config.businessTypes[locationType].product.item
    
    if not productConfig then
        return
    end
    
    -- Determine item name based on equipment level
    local itemName = productConfig.name
    if business.equipment == "high" and productConfig.name.upgraded then
        itemName = productConfig.name.upgraded
    elseif productConfig.name.normal then
        itemName = productConfig.name.normal
    end
    
    -- Calculate item count
    local itemCount = math.floor(business.products * productConfig.count)
    
    if itemCount <= 0 then
        LR.notify(playerId, locale("cant_take_out_products"), "error")
        return
    end
    
    -- Check if player can carry the items
    if not player:canCarryItem(itemName, itemCount) then
        return
    end
    
    -- Add items and update business
    local success = player:addItem(itemName, itemCount)
    if success ~= false then
        local productReduction = math.ceil(itemCount / productConfig.count)
        business.products = business.products - productReduction
        business:update(false)
        LR.notify(playerId, locale("products_taken_out"), "success")
    end
end)

-- Callback: Seize business (police action)
lib.callback.register("lunar_illegalbusiness:seizeBusiness", function(playerId, businessName)
    local player = Framework.getPlayerFromId(playerId)
    local raid = GetRaid(businessName)
    
    -- Validate raid state and police status
    local isPolice = player and Utils.isPolice(playerId)
    local canSeize = isPolice and raid and raid.open
    
    if not canSeize then
        return false
    end
    
    -- Check if product was confiscated
    if not raid.confiscated then
        return false, locale("product_not_confiscated")
    end
    
    -- Check if business is empty
    if businessPlayerCount[businessName] > 0 then
        return false, locale("business_not_empty")
    end
    
    -- Reset business
    local business = Businesses.get(businessName)
    business.employees = "none"
    business.equipment = "none"
    business.security = false
    business.supplies = 0
    business.products = 0
    business.seizedIntervals = Config.raiding.seizedIntervals
    business:update(true)
    
    RemoveRaid(businessName)
    
    LogToDiscord(player, string.format([[
Seized a business.
Business name: %s]], business.name))
    
    return true
end)

-- Event: Business door was unlocked during raid
RegisterNetEvent("lunar_illegalbusiness:unlockedBusiness", function(businessName)
    local playerId = source
    local player = Framework.getPlayerFromId(playerId)
    local raid = GetRaid(businessName)
    local business = Businesses.get(businessName)
    
    -- Validate raid state and police status
    local canUnlock = player and raid and not raid.open and Utils.isPolice(playerId)
    
    if not canUnlock then
        return
    end
    
    raid.open = true
    
    -- Spawn guards if security is enabled
    if business.security then
        SpawnRaidGuards(businessName, businessRoutingBuckets[businessName])
    end
    
    -- Set timeout to auto-end raid
    SetTimeout(Config.raiding.duration, function()
        if business.seizedIntervals == -1 then
            RemoveRaid(businessName)
        end
    end)
    
    TriggerClientEvent("lunar_illegalbusiness:unlockedBusiness", -1, businessName)
    
    LogToDiscord(player, string.format([[
Started raiding a business.
Business name: %s]], business.name))
end)

-- Event: Confiscate products during raid
RegisterNetEvent("lunar_illegalbusiness:confiscateProduct", function()
    local playerId = source
    local player = Framework.getPlayerFromId(playerId)
    local business = Businesses.get(playerInsideBusiness[playerId])
    
    if not business then
        return
    end
    
    local raid = GetRaid(business.name)
    
    -- Validate raid state and police status
    local canConfiscate = player and Utils.isPolice(playerId) and raid and not raid.confiscated
    
    if not canConfiscate then
        return
    end
    
    raid.confiscated = true
    business.products = 0
    business:update(false)
    
    LogToDiscord(player, string.format([[
Confiscated product during a raid.
Business name: %s]], business.name))
end)