-- ============================================================
-- UNDERGROUND HEIST - FINAL SALE CUTSCENE SYSTEM (ISOLATED)
-- ============================================================
-- This file contains all functions and events related to the
-- final sale/delivery cutscene animation of the heist

-- ============================================================
-- CLIENT-SIDE FUNCTIONS (client.lua - Lines 907-1055)
-- ============================================================

-- MAIN FUNCTION: Triggers the final sale sequence
-- Called when player is in the finishHeist zone
function Outside()
    if robber then
        robber = false
        ShowNotification(Strings['deliver_to_buyer'])
        
        -- Load buyer vehicle model
        loadModel('baller')
        
        -- Remove old blip and add buyer destination blip
        RemoveBlip(undergroundBlip)
        buyerBlip = addBlip(Config['UndergroundHeist']['finishHeist']['buyerPos'], 500, 0, Strings['buyer_blip'])
        
        -- Create buyer vehicle at finish location
        buyerVehicle = CreateVehicle(GetHashKey('baller'), Config['UndergroundHeist']['finishHeist']['buyerPos'].xy + 3.0, Config['UndergroundHeist']['finishHeist']['buyerPos'].z, 269.4, 0, 0)
        
        -- Loop: Wait for player to reach buyer location
        while true do
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local dist = #(pedCo - Config['UndergroundHeist']['finishHeist']['buyerPos'])

            if dist <= 15.0 then
                -- ⭐ TRIGGER CUTSCENE HERE
                PlayCutscene('hs3f_all_drp2', Config['UndergroundHeist']['finishHeist']['buyerPos'])
                
                -- Cleanup
                DeleteVehicle(buyerVehicle)
                RemoveBlip(buyerBlip)
                
                -- Trigger server event to process the sale
                TriggerServerEvent('undergroundheist:server:sellRewardItems')
                break
            end
            Wait(1)
        end
    end
end

-- CUTSCENE PLAYBACK: Main cutscene loader function
-- @param cut = Cutscene name (e.g., 'hs3f_all_drp2')
-- @param coords = Coordinates to play cutscene at
function PlayCutscene(cut, coords)
    -- Load cutscene into memory
    while not HasThisCutsceneLoaded(cut) do 
        RequestCutscene(cut, 8)
        Wait(0) 
    end
    
    -- Create cutscene with cloned players
    CreateCutscene(false, coords)
    
    -- Wait for cutscene to finish with fade effects
    Finish(coords)
    
    -- Remove cutscene from memory
    RemoveCutscene()
    DoScreenFadeIn(500)
end

-- CUTSCENE SETUP: Creates the cutscene with NPC clones
-- @param change = Boolean to swap player positions
-- @param coords = Coordinates where cutscene plays
function CreateCutscene(change, coords)
    local ped = PlayerPedId()
        
    -- Clone the player 5 times (for MP_1 through MP_5)
    local clone = ClonePedEx(ped, 0.0, false, true, 1)
    local clone2 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone3 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone4 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone5 = ClonePedEx(ped, 0.0, false, true, 1)

    -- Setup clone properties (invisible, invincible)
    SetBlockingOfNonTemporaryEvents(clone, true)
    SetEntityVisible(clone, false, false)
    SetEntityInvincible(clone, true)
    SetEntityCollision(clone, false, false)
    FreezeEntityPosition(clone, true)
    SetPedHelmet(clone, false)
    RemovePedHelmet(clone, true)
    
    -- Register entities for cutscene playback
    if change then
        SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
        RegisterEntityForCutscene(ped, 'MP_2', 0, GetEntityModel(ped), 64)
        
        SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
        RegisterEntityForCutscene(clone2, 'MP_1', 0, GetEntityModel(clone2), 64)
    else
        SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
        RegisterEntityForCutscene(ped, 'MP_1', 0, GetEntityModel(ped), 64)

        SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
        RegisterEntityForCutscene(clone2, 'MP_2', 0, GetEntityModel(clone2), 64)
    end

    SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
    RegisterEntityForCutscene(clone3, 'MP_3', 0, GetEntityModel(clone3), 64)
    
    SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
    RegisterEntityForCutscene(clone4, 'MP_4', 0, GetEntityModel(clone4), 64)
    
    SetCutsceneEntityStreamingFlags('MP_5', 0, 1)
    RegisterEntityForCutscene(clone5, 'MP_5', 0, GetEntityModel(clone5), 64)
    
    Wait(10)
    
    -- Start the cutscene at specific coordinates
    if coords then
        StartCutsceneAtCoords(coords, 0)
    else
        StartCutscene(0)
    end
    
    Wait(10)
    
    -- Teleport clone to player position and cleanup
    ClonePedToTarget(clone, ped)
    Wait(10)
    DeleteEntity(clone)
    DeleteEntity(clone2)
    DeleteEntity(clone3)
    DeleteEntity(clone4)
    DeleteEntity(clone5)
    Wait(50)
    DoScreenFadeIn(250)
end

-- CUTSCENE FINISHING: Waits for cutscene to complete and applies screen fades
-- @param coords = Coordinates (used to determine if cutscene has location)
function Finish(coords)
    if coords then
        local tripped = false
        repeat
            Wait(0)
            -- When cutscene is about to end (250ms remaining), fade out screen
            if (GetCutsceneTotalDuration() - GetCutsceneTime() <= 250) then
                DoScreenFadeOut(250)
                tripped = true
            end
        until not IsCutscenePlaying()
        if (not tripped) then
            DoScreenFadeOut(100)
            Wait(150)
        end
        return
    else
        Wait(18500)
        StopCutsceneImmediately()
    end
end

-- ============================================================
-- SERVER-SIDE EVENT HANDLER (server.lua - Lines 225-278)
-- ============================================================

RegisterServerEvent('undergroundheist:server:sellRewardItems')
AddEventHandler('undergroundheist:server:sellRewardItems', function()
    local src = source

    -- ESX FRAMEWORK
    if Config['UndergroundHeist']['framework']['name'] == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        local totalMoney = 0

        if player then
            -- Loop through all reward items defined in config
            for k, v in pairs(Config['UndergroundHeist']['rewardItems']) do
                local playerItem = player.getInventoryItem(v['itemName'])
                
                if playerItem.count >= 1 then
                    -- Remove item from player inventory
                    player.removeInventoryItem(v['itemName'], playerItem.count)
                    
                    -- Add money (black money or regular)
                    if Config['UndergroundHeist']['black_money'] then
                        player.addAccountMoney('black_money', playerItem.count * v['sellPrice'])
                    else
                        player.addMoney(playerItem.count * v['sellPrice'])
                    end
                    
                    totalMoney = totalMoney + (playerItem.count * v['sellPrice'])
                end
            end

            -- Log to Discord
            discordLog(player.getName() ..  ' - ' .. player.getIdentifier(), ' Gain $' .. math.floor(totalMoney) .. ' on the Underground Heist Buyer!')
            
            -- Notify player
            TriggerClientEvent('undergroundheist:client:showNotification', src, Strings['total_money'] .. ' $' .. math.floor(totalMoney))
        end
        
    -- QB-CORE FRAMEWORK
    elseif Config['UndergroundHeist']['framework']['name'] == 'QB' then
        local player = QBCore.Functions.GetPlayer(src)
        local totalMoney = 0

        if player then
            -- Loop through all reward items defined in config
            for k, v in pairs(Config['UndergroundHeist']['rewardItems']) do
                local playerItem = player.Functions.GetItemByName(v['itemName'])
                
                if playerItem ~= nil and playerItem.amount > 0 then
                    -- Remove item from player inventory
                    player.Functions.RemoveItem(v['itemName'], playerItem.amount)
                    
                    -- Add money (marked bills or cash)
                    if Config['UndergroundHeist']['black_money'] then
                        local info = {
                            worth = playerItem.amount * v['sellPrice']
                        }
                        player.Functions.AddItem('markedbills', 1, false, info)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add") 
                    else
                        player.Functions.AddMoney('cash', playerItem.amount * v['sellPrice'])
                    end
                    
                    totalMoney = totalMoney + (playerItem.amount * v['sellPrice'])
                end
            end

            -- Log to Discord
            discordLog(player.PlayerData.name ..  ' - ' .. player.PlayerData.license, ' Gain $' .. math.floor(totalMoney) .. ' on the Underground Heist Buyer!')
            
            -- Notify player
            TriggerClientEvent('undergroundheist:client:showNotification', src, Strings['total_money'] .. ' $' .. math.floor(totalMoney))
        end
    end
end)

-- ============================================================
-- CONFIGURATION (config.lua - Lines 41-43)
-- ============================================================

-- Final heist location where cutscene is triggered and buyer is located
Config['UndergroundHeist']['finishHeist'] = {
    buyerPos = vector3(729.451, -555.40, 25.5128)  -- Buyer's location coordinates
    -- This location also triggers the Outside() function when player enters zone
}

-- Reward items configuration (used in sell event)
-- Each item is removed from player inventory and converted to money
Config['UndergroundHeist']['rewardItems'] = {
    {itemName = 'weed_pooch', count = 25, sellPrice = 100},    -- for drugs grab
    {itemName = 'coke_pooch', count = 25, sellPrice = 100},    -- for drugs grab
    {itemName = 'virus',      count = 1,  sellPrice = 100},    -- for virus grab
    {itemName = 'gold',       count = 50, sellPrice = 100},    -- for vault stack
    {itemName = 'chest_gold', count = 25, sellPrice = 100},    -- for chests
    {itemName = 'cashbon',    count = 2,  sellPrice = 100},    -- for safecrack
}

-- ============================================================
-- FLOW SUMMARY
-- ============================================================
-- 1. Player completes heist and heads to buyer location
-- 2. When dist <= 15.0 from buyerPos → Outside() function triggers
-- 3. PlayCutscene() loads 'hs3f_all_drp2' cutscene
-- 4. CreateCutscene() creates player clones for animation
-- 5. Finish() waits for cutscene to complete with screen fades
-- 6. Server event 'undergroundheist:server:sellRewardItems' processes the sale
-- 7. Items are removed, money is added, player is notified

-- ============================================================
-- CUTSCENE NAME: 'hs3f_all_drp2' (GTA V Heist Series 3 Cutscene)
-- VEHICLE: baller (Black vehicle at buyer location)
-- ============================================================
