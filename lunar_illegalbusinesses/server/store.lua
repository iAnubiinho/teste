-- Business Data Store - Database Operations and Business Management

Businesses = {}
Businesses.ready = false

-- In-memory business data storage
businessData = {}

-- Business class metatable
BusinessClass = {}
BusinessClass.__index = BusinessClass

-- Syncs business data to all clients
function BusinessClass:update(reloadIPL)
    TriggerClientEvent("lunar_illegalbusiness:syncBusiness", -1, self, reloadIPL)
end

-- Checks if a player has access to the business
function BusinessClass:hasAccess(identifier)
    return self.identifier == identifier
end

-- Grants access (keys) to another player
function BusinessClass:grantAccess(player)
    local identifier = player:getIdentifier()
    self.keys[identifier] = true
    TriggerClientEvent("lunar_illegalbusiness:addAccess", player.source, self.name, false)
end

-- Removes access from a player
function BusinessClass:removeAccess(identifier)
    self.keys[identifier] = nil
    
    local player = Framework.getPlayerFromIdentifier(identifier)
    if player then
        TriggerClientEvent("lunar_illegalbusiness:removeAccess", player.source, self.name)
    end
end

-- Calculates sell price based on product amount
function BusinessClass:getSellPrice(productAmount)
    local businessType = Config.locations[self.name].type
    local typeConfig = Config.businessTypes[businessType]
    
    local price = productAmount * math.random(typeConfig.product.price.min, typeConfig.product.price.max)
    
    if self.equipment == "high" then
        price = price * Config.product.multipliers.equipmentUpgrade
    end
    
    return math.floor(price)
end

-- Deletes the business from database
function BusinessClass:delete()
    businessData[self.name] = nil
    TriggerClientEvent("lunar_illegalbusiness:removeAccess", -1, self.name)
    MySQL.update.await("DELETE FROM lunar_illegalbusiness WHERE name = ?", { self.name })
end

-- Transfers ownership to another player
function BusinessClass:transfer(newOwner)
    self.identifier = newOwner:getIdentifier()
    self.keys = {}
    
    TriggerClientEvent("lunar_illegalbusiness:removeAccess", -1, self.name)
    TriggerClientEvent("lunar_illegalbusiness:addAccess", newOwner.source, self.name, true)
    
    MySQL.update.await("UPDATE lunar_illegalbusiness SET identifier = ? WHERE name = ?", {
        self.identifier,
        self.name
    })
end

-- Returns all business data
function Businesses.data()
    return businessData
end

-- Gets a specific business by name
function Businesses.get(businessName)
    if businessName then
        return businessData[businessName]
    end
    return nil
end

-- Creates a new business
function Businesses.create(businessName, owner)
    local business = {
        name = businessName,
        identifier = owner:getIdentifier(),
        keys = {},
        supplies = 0.0,
        products = 0.0,
        equipment = "none",
        employees = "none",
        security = false,
        entered = false,
        growthPhase = 1,
        stash = string.format("%s_%s", businessName, math.random(1, 9999999999)),
        seizedIntervals = -1
    }
    
    businessData[businessName] = setmetatable(business, BusinessClass)
    
    TriggerClientEvent("lunar_illegalbusiness:addAccess", owner.source, businessName, true)
    
    MySQL.insert.await("INSERT INTO lunar_illegalbusiness (identifier, name, data) VALUES(?, ?, ?)", {
        business.identifier,
        businessName,
        json.encode(business)
    })
    
    -- Register stash
    local locationConfig = Config.locations[businessName]
    local stashConfig = Config.businessTypes[locationConfig.type].interior.stash
    Editable.registerStash(stashConfig, business.stash)
end

-- Updates all businesses (product/supply processing)
function ProcessBusinesses()
    for _, business in pairs(businessData) do
        local addAmount = Config.product.add
        local removeAmount = Config.product.remove
        
        -- Apply employee upgrade multiplier
        if business.employees == "high" then
            addAmount = addAmount * Config.product.multipliers.employeeUpgrade
            
            if Config.product.multipliers.applyOnRemove then
                removeAmount = removeAmount * Config.product.multipliers.employeeUpgrade
            end
        end
        
        -- Process production
        if business.supplies > 0 and business.products < 100.0 and business.seizedIntervals <= 0 then
            business.supplies = business.supplies - removeAmount
            business.products = business.products + addAmount
            business.growthPhase = business.growthPhase + 10
            
            if business.growthPhase == 100 then
                business.growthPhase = 0
            end
        end
        
        -- Decrement seized intervals
        if business.seizedIntervals > 0 then
            business.seizedIntervals = business.seizedIntervals - 1
        end
        
        -- Clamp values
        business.supplies = math.max(0, math.min(100, business.supplies))
        business.products = math.max(0, math.min(100, business.products))
        
        business:update(false)
    end
end

-- Saves all businesses to database
function SaveAllBusinesses()
    local saveData = {}
    local count = 0
    
    for businessName, business in pairs(businessData) do
        count = count + 1
        saveData[count] = { json.encode(business), business.identifier, businessName }
    end
    
    if count > 0 then
        print(string.format("Saving %s business/es.", count))
        MySQL.prepare.await("UPDATE lunar_illegalbusiness SET data = ? WHERE identifier = ? AND name = ?", saveData)
    end
end

-- Scheduled tasks
lib.cron.new("*/10 * * * *", SaveAllBusinesses)
lib.cron.new(Config.product.updateCron, ProcessBusinesses)

-- Save on server shutdown
AddEventHandler("txAdmin:events:serverShuttingDown", SaveAllBusinesses)

AddEventHandler("txAdmin:events:scheduledRestart", function(data)
    if data.secondsRemaining == 60 then
        SaveAllBusinesses()
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == cache.resource then
        SaveAllBusinesses()
    end
end)

-- Load businesses from database on start
MySQL.ready(function()
    Wait(1000)
    
    local rows = MySQL.query.await("SELECT * FROM lunar_illegalbusiness")
    
    for _, row in ipairs(rows) do
        local business = setmetatable(json.decode(row.data), BusinessClass)
        business.name = row.name
        businessData[row.name] = business
        
        -- Register stash if location exists
        local locationConfig = Config.locations[row.name]
        if locationConfig then
            local stashConfig = Config.businessTypes[locationConfig.type].interior.stash
            Editable.registerStash(stashConfig, business.stash)
        end
    end
    
    Businesses.ready = true
end)