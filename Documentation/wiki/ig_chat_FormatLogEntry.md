# ig.chat.FormatLogEntry

## Description

Formats a chat log entry with timestamp, player information, and optional metadata such as coordinates and identifiers. This function is used internally by the chat logging system to create consistent log entries.

## Signature

```lua
function ig.chat.FormatLogEntry(source, playerName, message, isCommand)
```

## Parameters

- **`source`**: any
- **`playerName`**: any
- **`message`**: string
- **`isCommand`**: any

## Example

```lua
-- Example usage
local result = ig.chat.FormatLogEntry(value, value, "message", value)
```

## Source

Defined in: `server/_chat.lua`
