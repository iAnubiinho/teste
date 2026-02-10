-- Discord Logging Utility

-- Logs a message to Discord webhook
function LogToDiscord(player, message)
    local webhook = SvConfig.Webhook
    
    if not webhook or webhook == "WEBHOOK_HERE" then
        return
    end
    
    Utils.logToDiscord(player.source, webhook, message)
end