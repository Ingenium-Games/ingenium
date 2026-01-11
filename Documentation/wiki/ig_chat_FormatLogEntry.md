# ig.chat.FormatLogEntry

## Description

Formats a chat log entry with timestamp, player information, and optional metadata such as coordinates and identifiers. This function is used internally by the chat logging system to create consistent log entries.

## Signature

```lua
function ig.chat.FormatLogEntry(source, playerName, message, isCommand)
```

## Parameters

- **`source`**: number - The player's server ID
- **`playerName`**: string - The player's display name
- **`message`**: string - The chat message or command text
- **`isCommand`**: boolean - Whether the message is a command (starts with /)

## Returns

- **string** - Formatted log entry string

## Example

```lua
-- Example usage of ig.chat.FormatLogEntry
local logEntry = ig.chat.FormatLogEntry(1, "PlayerName", "Hello everyone!", false)
-- Output: [2026-01-11 10:30:45] [MESSAGE] PlayerName (ID: 1): Hello everyone!

local commandEntry = ig.chat.FormatLogEntry(5, "AdminName", "/heal", true)
-- Output: [2026-01-11 10:31:02] [COMMAND] AdminName (ID: 5): /heal
```

## Important Notes

> ℹ️ **Configuration**: The format of the log entry depends on `conf.chat.logging.includeCoordinates` and `conf.chat.logging.includeIdentifiers` settings.

> ⚠️ **Server-Side Only**: This function should only be called on the server side.

## Related Functions

- [ig.chat.LogMessage](ig_chat_LogMessage.md)

## Source

Defined in: `server/_chat.lua`
