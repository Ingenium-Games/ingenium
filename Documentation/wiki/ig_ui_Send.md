# ig.ui.Send

## Description

Sends a custom message to the NUI (UI) system with optional data and focus control.

## Signature

```lua
function ig.ui.Send(message, data, focus)
```

## Parameters

- **`message`**: string - The message type identifier
- **`data`**: table|nil (optional) - Data payload to send with the message
- **`focus`**: boolean|nil (optional) - Whether to enable NUI focus (cursor)

## Returns

None

## Example

```lua
-- Send a custom UI message
ig.ui.Send("customEvent", {value = 100}, false)

-- Send a message with focus enabled
ig.ui.Send("openPanel", {panelType = "inventory"}, true)
```

## Source

Defined in: `client/_ui.lua`
