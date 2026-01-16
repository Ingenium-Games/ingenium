-- ====================================================================================--
-- Screenshot System - Server Side
-- ====================================================================================--

-- Function to validate webhook URL
function ig.screenshot.ValidateWebhook(webhook)
    if not webhook or webhook == "" then
        return false
    end
    
    -- Basic Discord webhook validation
    if string.match(webhook, "^https://discord%.com/api/webhooks/%d+/[%w_-]+$") or 
       string.match(webhook, "^https://discordapp%.com/api/webhooks/%d+/[%w_-]+$") then
        return true
    end
    
    return false
end

-- Process screenshot data from client
RegisterNetEvent('ig:screenshot:process')
AddEventHandler('ig:screenshot:process', function(data)
    local source = source
    local imageUrl = data.imageUrl
    local metadata = data.metadata or {}
    
    -- Get player identifiers
    local identifiers = ig.func.GetPlayerIdentifiers(source)
    
    -- Add server-side metadata
    metadata.serverId = source
    metadata.playerIdentifiers = identifiers
    metadata.serverTime = os.date('%Y-%m-%d %H:%M:%S')
    
    ig.log.Info('Screenshot', 'Processing screenshot from player %d (%s) - Reason: %s', 
        source, 
        GetPlayerName(source), 
        metadata.reason or 'unknown'
    )
    
    -- Handle different output methods
    if conf.screenshot.outputs.discord.enabled then
        ig.screenshot.SendToDiscord(imageUrl, metadata)
    end
    
    if conf.screenshot.outputs.imageHost.enabled then
        ig.screenshot.SendToImageHost(imageUrl, metadata)
    end
    
    if conf.screenshot.outputs.discourse.enabled then
        ig.screenshot.SendToDiscourse(imageUrl, metadata)
    end
    
    -- Log to database if logging is enabled
    if conf.screenshot.logToDatabase then
        ig.screenshot.LogToDatabase(imageUrl, metadata)
    end
end)

-- Send screenshot to Discord webhook
function ig.screenshot.SendToDiscord(imageUrl, metadata)
    local webhook = conf.screenshot.outputs.discord.webhook
    
    if not webhook or webhook == "" then
        ig.log.Warn('Screenshot', 'Discord webhook not configured')
        return
    end
    
    -- Validate Discord webhook URL format
    if not string.match(webhook, "^https://discord%.com/api/webhooks/%d+/[%w_-]+$") and
       not string.match(webhook, "^https://discordapp%.com/api/webhooks/%d+/[%w_-]+$") then
        ig.log.Error('Screenshot', 'Invalid Discord webhook URL')
        return
    end
    
    -- Build embed message
    local embed = {
        {
            title = "🖼️ Screenshot Captured",
            description = string.format("**Reason:** %s", metadata.reason or "Unknown"),
            color = 3447003, -- Blue color
            fields = {},
            image = {
                url = imageUrl
            },
            footer = {
                text = metadata.serverTime or os.date('%Y-%m-%d %H:%M:%S')
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
        }
    }
    
    -- Add player info
    if metadata.playerName then
        table.insert(embed[1].fields, {
            name = "Player",
            value = metadata.playerName,
            inline = true
        })
    end
    
    if metadata.serverId then
        table.insert(embed[1].fields, {
            name = "Server ID",
            value = tostring(metadata.serverId),
            inline = true
        })
    end
    
    -- Add coordinates
    if metadata.coordinates then
        table.insert(embed[1].fields, {
            name = "Location",
            value = string.format("X: %.2f, Y: %.2f, Z: %.2f", 
                metadata.coordinates.x, 
                metadata.coordinates.y, 
                metadata.coordinates.z
            ),
            inline = false
        })
    end
    
    -- Add game time
    if metadata.gameTime then
        table.insert(embed[1].fields, {
            name = "Game Time",
            value = string.format("%02d:%02d", metadata.gameTime.hours, metadata.gameTime.minutes),
            inline = true
        })
    end
    
    -- Add vehicle info
    if metadata.vehicle then
        table.insert(embed[1].fields, {
            name = "Vehicle",
            value = string.format("%s (%s)", metadata.vehicle.model, metadata.vehicle.plate),
            inline = true
        })
    end
    
    -- Add nearby players
    if metadata.nearbyPlayers and #metadata.nearbyPlayers > 0 then
        local playerList = {}
        for _, player in ipairs(metadata.nearbyPlayers) do
            table.insert(playerList, string.format("%s (ID: %d, Dist: %dm)", 
                player.name, 
                player.serverId, 
                player.distance
            ))
        end
        table.insert(embed[1].fields, {
            name = "Nearby Players",
            value = table.concat(playerList, "\n"),
            inline = false
        })
    end
    
    -- Add identifiers
    if metadata.playerIdentifiers then
        local identifierList = {}
        for k, v in pairs(metadata.playerIdentifiers) do
            table.insert(identifierList, string.format("%s: `%s`", k, v))
        end
        table.insert(embed[1].fields, {
            name = "Identifiers",
            value = table.concat(identifierList, "\n"),
            inline = false
        })
    end
    
    -- Send to Discord
    PerformHttpRequest(webhook, function(err, text, headers)
        if err == 200 or err == 204 then
            ig.log.Info('Screenshot', 'Successfully sent to Discord')
        else
            ig.log.Error('Screenshot', 'Failed to send to Discord: %d', err)
        end
    end, 'POST', json.encode({
        username = conf.screenshot.outputs.discord.username or "Ingenium Screenshot",
        avatar_url = conf.screenshot.outputs.discord.avatar_url,
        embeds = embed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

-- Send screenshot to custom image host
function ig.screenshot.SendToImageHost(imageUrl, metadata)
    local url = conf.screenshot.outputs.imageHost.url
    
    if not url or url == "" then
        ig.log.Warn('Screenshot', 'Image host URL not configured')
        return
    end
    
    local payload = {
        imageUrl = imageUrl,
        metadata = metadata
    }
    
    PerformHttpRequest(url, function(err, text, headers)
        if err == 200 or err == 201 then
            ig.log.Info('Screenshot', 'Successfully sent to image host')
        else
            ig.log.Error('Screenshot', 'Failed to send to image host: %d', err)
        end
    end, 'POST', json.encode(payload), conf.screenshot.outputs.imageHost.headers or {
        ['Content-Type'] = 'application/json'
    })
end

-- Send screenshot to Discourse
function ig.screenshot.SendToDiscourse(imageUrl, metadata)
    local discourseUrl = conf.screenshot.outputs.discourse.url
    local apiKey = conf.screenshot.outputs.discourse.apiKey
    local apiUsername = conf.screenshot.outputs.discourse.apiUsername
    
    if not discourseUrl or discourseUrl == "" or not apiKey or not apiUsername then
        ig.log.Warn('Screenshot', 'Discourse not configured properly')
        return
    end
    
    -- Create a post with the screenshot
    local title = string.format("Screenshot - %s - %s", metadata.playerName or "Unknown", metadata.reason or "Unknown")
    local body = string.format("![screenshot](%s)\n\n**Metadata:**\n```json\n%s\n```", 
        imageUrl, 
        json.encode(metadata, {indent = true})
    )
    
    local categoryId = conf.screenshot.outputs.discourse.categoryId
    if not categoryId then
        ig.log.Warn('Screenshot', 'Discourse categoryId not configured, using default category 1')
        categoryId = 1 -- Use a safe default (usually "Uncategorized" in Discourse)
    end
    
    local payload = {
        title = title,
        raw = body,
        category = categoryId,
    }
    
    PerformHttpRequest(discourseUrl .. '/posts.json', function(err, text, headers)
        if err == 200 or err == 201 then
            ig.log.Info('Screenshot', 'Successfully posted to Discourse')
        else
            ig.log.Error('Screenshot', 'Failed to post to Discourse: %d - %s', err, text or "")
        end
    end, 'POST', json.encode(payload), {
        ['Content-Type'] = 'application/json',
        ['Api-Key'] = apiKey,
        ['Api-Username'] = apiUsername
    })
end

-- Log screenshot to database (optional)
function ig.screenshot.LogToDatabase(imageUrl, metadata)
    -- This would integrate with your existing database system
    -- Example implementation:
    --[[
    local query = "INSERT INTO screenshots (player_id, image_url, reason, metadata, created_at) VALUES (?, ?, ?, ?, NOW())"
    exports['ingenium.sql']:Execute(query, {
        metadata.serverId,
        imageUrl,
        metadata.reason,
        json.encode(metadata)
    }, function(result)
        if result then
            ig.log.Info('Screenshot', 'Logged to database')
        end
    end)
    ]]--
end

-- Admin command to request screenshot from a player
RegisterCommand('takescreenshot', function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    
    if not playerId then
        TriggerClientEvent('Client:Notify', source, 'Usage: /takescreenshot <playerID>', 'red', 5000)
        return
    end
    
    -- Check if player exists
    local targetPlayerName = GetPlayerName(playerId)
    if not targetPlayerName or targetPlayerName == '' then
        TriggerClientEvent('Client:Notify', source, 'Player not found', 'red', 5000)
        return
    end
    
    TriggerClientEvent('ig:screenshot:takeOnReport', playerId, {
        requestedBy = source,
        requestedByName = GetPlayerName(source)
    })
    
    TriggerClientEvent('Client:Notify', source, string.format('Screenshot requested from player %d', playerId), 'green', 5000)
end, true) -- Restricted command

ig.log.Info('Screenshot', 'Screenshot system server loaded')
