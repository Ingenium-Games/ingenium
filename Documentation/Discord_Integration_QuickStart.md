# Discord Integration - Quick Start Guide

This guide will get you up and running with Discord role-based authentication and queue priority in 5 minutes.

## Prerequisites

- A Discord server
- Admin access to your Discord server
- Admin access to your FiveM server

## Step 1: Create a Discord Bot (5 minutes)

### 1.1 Create Application
1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Click "New Application"
3. Give it a name (e.g., "MyServer Bot")
4. Click "Create"

### 1.2 Create Bot User
1. In your application, go to the "Bot" section (left sidebar)
2. Click "Add Bot"
3. Click "Yes, do it!"

### 1.3 Configure Bot
1. Under "Privileged Gateway Intents", enable:
   - ✅ **SERVER MEMBERS INTENT** (required)
2. Under "Token", click "Reset Token"
3. Click "Copy" to copy your bot token
4. **Save this token securely** - you'll need it in Step 3

### 1.4 Invite Bot to Server
1. Go to "OAuth2" > "URL Generator" (left sidebar)
2. Under "Scopes", select:
   - ✅ `bot`
3. Under "Bot Permissions", select:
   - ✅ View Channels
4. Copy the generated URL at the bottom
5. Open the URL in your browser
6. Select your Discord server
7. Click "Authorize"

## Step 2: Get Discord IDs (2 minutes)

### 2.1 Enable Developer Mode
1. In Discord, go to Settings > Advanced
2. Enable "Developer Mode"

### 2.2 Get Server ID
1. Right-click your server icon
2. Click "Copy ID"
3. Save this - it's your `guild_id`

### 2.3 Get Role IDs
1. In Discord, go to Server Settings > Roles
2. Right-click each role you want to use
3. Click "Copy ID"
4. Save these IDs

**Example roles to copy**:
- Member/Whitelist role - Required to join
- VIP role - High priority in queue
- Supporter role - Medium priority in queue

## Step 3: Configure Ingenium (2 minutes)

### 3.1 Edit `_config/discord.lua`

Open `_config/discord.lua` and configure:

```lua
-- Your Discord server and bot information
conf.discord.guild_id = "YOUR_SERVER_ID_FROM_STEP_2.2"
conf.discord.bot_token = "YOUR_BOT_TOKEN_FROM_STEP_1.3"

-- Whitelist configuration
conf.discord.member_role_enabled = true  -- true = whitelist enabled
conf.discord.member_role = "YOUR_MEMBER_ROLE_ID_FROM_STEP_2.3"

-- Priority queue configuration
conf.discord.priority_enabled = true  -- true = priority enabled
conf.discord.priority_roles = {
    {id = "YOUR_VIP_ROLE_ID", power = 100},      -- VIP gets priority 100
    {id = "YOUR_SUPPORTER_ROLE_ID", power = 50}, -- Supporter gets priority 50
}
```

### 3.2 Restart Server
1. Save the file
2. Restart your FiveM server
3. Check console for: `[Discord] Internal Discord module loaded`

## Step 4: Test (1 minute)

### 4.1 Test Whitelist
1. Try connecting without the member role
   - **Expected**: Connection denied with "No Discord role" message
2. Get the member role in Discord
3. Try connecting again
   - **Expected**: Allowed to connect

### 4.2 Test Priority
1. Have multiple people connect at the same time
2. Users with VIP role should be placed ahead in queue
3. Users with Supporter role should be ahead of regular users

## Common Issues

### "Discord guild ID not configured"
- Make sure you set `conf.discord.guild_id` in `_config/discord.lua`
- The ID should be numbers only, in quotes

### "Discord bot token not configured"
- Make sure you set `conf.discord.bot_token` in `_config/discord.lua`
- The token should look like: `[REDACTED]`

### "Discord API request failed with status 401"
- Your bot token is incorrect or expired
- Generate a new token in Discord Developer Portal

### "Discord API request failed with status 403"
- Your bot doesn't have "Server Members Intent" enabled
- Go to Discord Developer Portal > Your App > Bot > Enable "SERVER MEMBERS INTENT"

### Priority not working
- Make sure `conf.discord.priority_enabled = true`
- Check that role IDs are correct
- Verify users actually have those roles in Discord

### Bot not in server
- Follow Step 1.4 to invite the bot
- Verify bot appears in your server member list

## Configuration Presets

### Public Server (No Whitelist)
```lua
conf.discord.member_role_enabled = false  -- Anyone can join
conf.discord.priority_enabled = true
conf.discord.priority_roles = {
    {id = "VIP_ROLE_ID", power = 50},
}
```

### Private Server (Whitelist Only)
```lua
conf.discord.member_role_enabled = true   -- Only members can join
conf.discord.member_role = "MEMBER_ROLE_ID"
conf.discord.priority_enabled = false     -- No priority
```

### Private Server (Whitelist + Priority)
```lua
conf.discord.member_role_enabled = true
conf.discord.member_role = "MEMBER_ROLE_ID"
conf.discord.priority_enabled = true
conf.discord.priority_roles = {
    {id = "VIP_ROLE_ID", power = 100},
    {id = "SUPPORTER_ROLE_ID", power = 50},
}
```

## Security Tips

1. **Never share your bot token** - treat it like a password
2. **Don't commit tokens to GitHub** - use environment variables for production
3. **Rotate tokens regularly** - if compromised, regenerate in Discord Developer Portal
4. **Limit bot permissions** - only give what's needed (View Channels)

## Need More Help?

- **Full Documentation**: `Documentation/Discord_Integration.md`
- **Example Configs**: `_config/discord.example.lua`
- **Implementation Details**: `Implementations/Discord_Integration_Summary.md`

## Next Steps

Once you have basic setup working:
1. Read the full documentation for advanced features
2. Adjust cache timeout if needed (default: 5 minutes)
3. Set up environment variables for production
4. Monitor server console for any Discord API errors

---

**Setup Time**: ~8 minutes
**Difficulty**: Easy
**Support**: See full documentation for troubleshooting
