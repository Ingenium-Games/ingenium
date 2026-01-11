# Vue Chat System

The Ingenium framework includes a modern Vue-based chat system that replaces the default FiveM chat UI while maintaining full compatibility with existing chat resources and scripts.

## Features

- **Vue 3 Integration**: Built with Vue 3 and Pinia state management
- **Modern UI**: Clean, animated chat interface with fade-in/out effects
- **Command Suggestions**: Autocomplete for commands based on player permissions
- **Backwards Compatible**: Works with existing chat scripts and resources
- **Configurable**: Auto-hide messages after 10 seconds
- **Keyboard Controls**: T to open chat, ESC to close, Enter to send
- **Chat Logging**: Comprehensive logging to daily files and txAdmin

## Architecture

The chat system consists of:

1. **Vue Component** (`nui/src/components/Chat.vue`)
   - Handles UI rendering and user interactions
   - Manages message display and input

2. **Pinia Store** (`nui/src/stores/chat.js`)
   - Manages chat state (visibility, messages, suggestions)
   - Provides reactive data for the UI

3. **Lua Integration** (`nui/lua/chat.lua`)
   - Bridges FiveM events with the Vue UI
   - Handles NUI callbacks and command execution

4. **Server-Side Logging** (`server/_chat.lua`)
   - Logs chat messages to daily files
   - Integrates with txAdmin logging
   - Configurable logging options

## Chat Logging

The chat system includes comprehensive logging capabilities that can log to both daily files and txAdmin.

### Configuration

Configure chat logging in `_config/chat.lua`:

```lua
conf.chat = {
    logging = {
        enabled = true,
        
        -- Log to daily chat history files
        logToFile = true,
        logDirectory = "logs/chat",
        
        -- Log to txAdmin
        logToTxAdmin = true,
        
        -- What to log
        logMessages = true,  -- Regular chat messages
        logCommands = true,  -- Commands (starting with /)
        
        -- Include metadata in logs
        includeCoordinates = false,
        includeIdentifiers = false,
        
        -- Maximum days to keep chat logs (0 = keep forever)
        maxLogDays = 30
    }
}
```

### Log Format

Chat logs are stored in daily files with the format:
```
logs/chat/chat_YYYY-MM-DD.log
```

Example log entries:
```
[2024-01-11 14:30:45] [MESSAGE] PlayerName (ID: 1): Hello everyone!
[2024-01-11 14:31:02] [COMMAND] AdminName (ID: 5): /heal
[2024-01-11 14:31:15] [MESSAGE] PlayerName (ID: 3) [steam:110000123456789] @(123.4, 456.7, 28.5): At the bank
```

### txAdmin Integration

When `logToTxAdmin` is enabled, chat messages are sent to txAdmin's built-in logging system using the `txaLogger:ChatMessage` event. This allows you to:
- View chat history in txAdmin's web panel
- Search and filter chat messages
- Monitor chat activity in real-time
- Export chat logs from txAdmin

### Usage Examples

```lua
-- Log a specific chat message from a script
exports['ingenium']:LogChatMessage(
    source,           -- Player server ID
    playerName,       -- Player name
    "Hello world!",   -- Message
    false            -- Is command? (false for regular message)
)

-- Enable/disable logging dynamically
conf.chat.logging.enabled = false  -- Disable logging
conf.chat.logging.enabled = true   -- Re-enable logging

-- Configure via convars (in server.cfg)
set ig_chat_logging "true"
set ig_chat_log_to_file "true"
set ig_chat_log_to_txadmin "true"
```

### Privacy Considerations

- **Identifiers**: By default, player identifiers are NOT logged. Enable `includeIdentifiers` only if required by your privacy policy.
- **Coordinates**: Player coordinates are NOT logged by default. Enable `includeCoordinates` if needed.
- **Log Retention**: Configure `maxLogDays` to automatically clean up old logs and comply with data retention policies.
- **Access Control**: Ensure log files have appropriate file permissions to prevent unauthorized access.

## Usage

### Sending Messages to Chat

#### From Client-Side

```lua
-- Using the export
exports['ingenium']:AddChatMessage('System', 'Hello World!', {255, 255, 255})

-- Using the event (compatible with default chat)
TriggerEvent('chat:addMessage', {
    author = 'System',
    message = 'Hello World!',
    color = {255, 255, 255}
})

-- Legacy format also supported
TriggerEvent('chat:addMessage', 'System', 'Hello World!', {255, 255, 255})
```

#### From Server-Side

```lua
-- Send to specific player
TriggerClientEvent('chat:addMessage', playerId, {
    author = 'Server',
    message = 'Hello from server!',
    color = {0, 255, 0}
})

-- Send to all players
TriggerClientEvent('chat:addMessage', -1, {
    author = 'Announcement',
    message = 'Server restart in 5 minutes',
    color = {255, 165, 0}
})
```

### Managing Chat Visibility

```lua
-- Show chat input
exports['ingenium']:ShowChatInput()

-- Hide chat
exports['ingenium']:HideChat()

-- Clear all messages
exports['ingenium']:ClearChat()
```

### Command Suggestions

Command suggestions are automatically populated based on player permissions:

```lua
-- Set custom suggestions
local suggestions = {
    {name = '/help', help = 'Show available commands'},
    {name = '/tp', help = 'Teleport to coordinates'},
    {name = '/heal', help = 'Heal yourself'}
}

exports['ingenium']:SetChatSuggestions(suggestions)
```

The chat system integrates with `ig.chat.AddSuggestions()` to automatically add commands based on the player's ACE level.

## Integration with Existing Resources

The Vue chat system is designed to work seamlessly with existing FiveM resources:

### Default Chat Resource

The system provides compatibility with the default `chat` resource:

```lua
-- These all work with the Vue chat
exports.chat:addMessage({
    args = {'System', 'Message'}
})

TriggerEvent('chat:addMessage', {
    args = {'Player', 'Hello!'}
})
```

### Custom Chat Scripts

Any script using standard chat events will automatically work:

```lua
-- In your custom script
RegisterCommand('announce', function(source, args)
    local message = table.concat(args, ' ')
    TriggerClientEvent('chat:addMessage', -1, {
        author = 'Admin',
        message = message,
        color = {255, 0, 0}
    })
end)
```

## Customization

### Styling

The chat UI can be customized by editing `nui/src/components/Chat.vue`:

- **Position**: Modify `.chat-container` CSS
- **Colors**: Update color values in styles
- **Font**: Change `font-family` in `.chat-container`
- **Message Display Time**: Adjust `visibilityTime` in the component

### Message Format

Customize message colors based on type:

```lua
-- Different colors for different message types
local colors = {
    system = {255, 255, 255},
    error = {255, 0, 0},
    success = {0, 255, 0},
    warning = {255, 165, 0},
    info = {0, 150, 255}
}

exports['ingenium']:AddChatMessage('System', 'Success!', colors.success)
```

## Key Bindings

Default key bindings:

- **T**: Open chat input
- **ESC**: Close chat without sending
- **Enter**: Send message and close chat

To change the chat key, modify the keybind in `nui/lua/chat.lua`:

```lua
RegisterKeyMapping('+chat', 'Open Chat', 'keyboard', 'Y') -- Change 'T' to 'Y'
```

## Configuration

No additional configuration is required. The chat system is automatically loaded with the Vue NUI.

To disable the Vue chat and use default chat:
1. Remove `Chat` component from `nui/src/App.vue`
2. Remove `nui/lua/chat.lua` from client scripts
3. Rebuild the NUI: `cd nui && npm run build`

## Troubleshooting

### Chat not showing

1. Verify the NUI is built: `cd nui && npm run build`
2. Check FiveM console for errors
3. Ensure `nui/dist/index.html` exists

### Commands not working

1. Check if player has appropriate ACE permissions
2. Verify `ig.chat.AddSuggestions()` is being called
3. Check console for Lua errors

### Messages not appearing

1. Verify message format is correct
2. Check if messages are being sent (console logs)
3. Ensure color values are valid RGB arrays

## Migration from Old Chat

The legacy jQuery-based chat system has been removed. All functionality is now in the Vue chat system. No changes are needed to existing scripts that use standard chat events.

## API Reference

### Client Exports

```lua
-- Add a message to chat
exports['ingenium']:AddChatMessage(author, message, color)

-- Show chat input
exports['ingenium']:ShowChatInput()

-- Hide chat
exports['ingenium']:HideChat()

-- Clear all messages
exports['ingenium']:ClearChat()

-- Set command suggestions
exports['ingenium']:SetChatSuggestions(suggestions)
```

### Events

```lua
-- Add message to chat
TriggerEvent('chat:addMessage', {
    author = 'Name',
    message = 'Text',
    color = {r, g, b}
})

-- Trigger from server
TriggerClientEvent('chat:addMessage', playerId, messageData)
```

## Performance

The Vue chat system is optimized for performance:

- Messages older than 10 seconds are hidden (but retained in memory)
- Maximum 100 messages stored
- Efficient Vue reactivity system
- Minimal DOM updates

## Future Enhancements

Planned features:
- Chat history (scroll to view old messages)
- Message filtering/search
- Custom emotes/emoji support
- Chat channels (global, local, group)
- Mentions and notifications
