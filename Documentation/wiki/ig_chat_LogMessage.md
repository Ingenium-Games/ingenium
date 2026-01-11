# ig.chat.LogMessage

## Description

Logs a chat message to configured outputs (file and/or txAdmin). Respects the configuration settings for whether to log messages, commands, and what metadata to include.

## Signature

```lua
function ig.chat.LogMessage(source, playerName, message, isCommand)
```

## Parameters

- **`source`**: any
- **`playerName`**: any
- **`message`**: string
- **`isCommand`**: any

## Example

```lua
-- Example usage
local result = ig.chat.LogMessage(value, value, "message", value)
```

## Source

Defined in: `server/_chat.lua`
