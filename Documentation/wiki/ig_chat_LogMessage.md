# ig.chat.LogMessage

## Description

Logs a chat message to configured outputs (file and/or txAdmin). Respects the configuration settings for whether to log messages, commands, and what metadata to include.

## Signature

```lua
function ig.chat.LogMessage(source, playerName, message, isCommand)
```

## Parameters

- **`source`**: number - The player's server ID
- **`playerName`**: string - The player's display name
- **`message`**: string - The chat message or command text
- **`isCommand`**: boolean - Whether the message is a command (starts with /)

## Returns

- None (void)

## Example

```lua
-- Example usage of ig.chat.LogMessage
ig.chat.LogMessage(1, "PlayerName", "Hello everyone!", false)

-- Log a command
ig.chat.LogMessage(5, "AdminName", "/heal", true)

-- Via export
exports['ingenium']:LogChatMessage(source, playerName, message, false)
```

## Important Notes

> ℹ️ **Configuration**: This function checks `conf.chat.logging.enabled`, `conf.chat.logging.logMessages`, and `conf.chat.logging.logCommands` before logging.

> ⚠️ **Server-Side Only**: This function should only be called on the server side.

> 📝 **Logging Outputs**: Messages can be logged to daily files and/or txAdmin based on configuration.

## Related Functions

- [ig.chat.FormatLogEntry](ig_chat_FormatLogEntry.md)
- [ig.chat.AddSuggestions](ig_chat_AddSuggestions.md)
- [ig.chat.SetPermissions](ig_chat_SetPermissions.md)

## Source

Defined in: `server/_chat.lua`
