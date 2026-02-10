-- NPC Ped Business Buy/Sell System

-- Cache of buyable businesses (nil until first request)
buyableBusinessesCache = nil

-- Callback: Get buyable businesses and player account balances
lib.callback.register("lunar_illegalbusiness:getBuyable", function(playerId)
    local player = Framework.getPlayerFromId(playerId)
    
    if not player then
        return
    end
    
    -- Check if player has a prohibited job
    local playerJob = player:getJob()
    local prohibitedJobs = Config.ped.prohibitedJobs
    
    if prohibitedJobs and prohibitedJobs[playerJob] then
        return
    end
    
    -- Wait for businesses to be loaded
    while not Businesses.ready do
        Wait(0)
    end
    
    -- Build buyable businesses cache if needed
    if not buyableBusinessesCache then
        buyableBusinessesCache = {}
        
        for businessName, _ in pairs(Config.locations) do
            if not Businesses.get(businessName) then
                buyableBusinessesCache[businessName] = true
            end
        end
    end
    
    -- Get player account balances
    local accountBalances = {}
    
    for i = 1, #Config.ped.accounts do
        local accountName = Config.ped.accounts[i].name
        accountBalances[i] = player:getAccountMoney(accountName)
    end
    
    return buyableBusinessesCache, accountBalances
end)

-- Validates that the payment account is valid
function IsValidPaymentAccount(accountName)
    for i = 1, #Config.ped.accounts do
        if Config.ped.accounts[i].name == accountName then
            return true
        end
    end
    return false
end

-- Callback: Buy a business
lib.callback.register("lunar_illegalbusiness:buyBusiness", function(playerId, businessName, paymentAccount)
    local player = Framework.getPlayerFromId(playerId)
    
    if not player or not IsValidPaymentAccount(paymentAccount) then
        return
    end
    
    -- Check prohibited jobs
    local playerJob = player:getJob()
    local prohibitedJobs = Config.ped.prohibitedJobs
    
    if prohibitedJobs and prohibitedJobs[playerJob] then
        return
    end
    
    -- Check max businesses limit
    if not CanPlayerBuy(player) then
        return false, locale("max_businesses")
    end
    
    -- Check funds and process purchase
    local price = Config.locations[businessName].price
    local playerBalance = player:getAccountMoney(paymentAccount)
    
    if playerBalance >= price then
        player:removeAccountMoney(paymentAccount, price)
        Businesses.create(businessName, player)
        buyableBusinessesCache[businessName] = nil
        
        LogToDiscord(player, string.format([[
Bought a business from the NPC.
Business name: %s
Price: %s$
Payment method: %s]], businessName, price, paymentAccount))
        
        return true, locale("bought_business")
    end
    
    return false, locale("not_enough_" .. paymentAccount)
end)

-- Event: Sell a business
RegisterNetEvent("lunar_illegalbusiness:sellBusiness", function(businessName)
    local playerId = source
    local player = Framework.getPlayerFromId(playerId)
    
    if not player then
        return
    end
    
    -- Check prohibited jobs
    local playerJob = player:getJob()
    local prohibitedJobs = Config.ped.prohibitedJobs
    
    if prohibitedJobs and prohibitedJobs[playerJob] then
        return
    end
    
    local business = Businesses.get(businessName)
    local sellPrice = math.floor(Config.locations[businessName].price / Config.ped.sell.divisor)
    
    -- Verify ownership
    if business and business.identifier == player:getIdentifier() then
        business:delete()
        buyableBusinessesCache[businessName] = true
        
        -- Add money after delay
        SetTimeout(3000, function()
            player:addAccountMoney(Config.ped.sell.account, sellPrice)
        end)
        
        LogToDiscord(player, string.format([[
Sold a business to the NPC.
Business name: %s
Price: %s]], businessName, sellPrice))
    end
end)