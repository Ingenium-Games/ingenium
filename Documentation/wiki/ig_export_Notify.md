# Export: Notify(text, colour, fade)

**Parameters**: 
- `text` (string) - Message to display
- `colour` (string) - Color name (red, green, blue, orange, yellow, etc.)
- `fade` (number) - Duration in milliseconds

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [C]

## Description

Send a notification to the player's screen with auto-fade.

## Usage

```lua
exports["ingenium"]:Notify("Transaction successful!", "green", 3000)
exports["ingenium"]:Notify("Insufficient funds", "red", 2000)
exports["ingenium"]:Notify("Warning", "orange", 4000)
```

## Parameters

### text (string)
The message to display in the notification.

### colour (string)
Color name. Valid values: `red`, `green`, `blue`, `orange`, `yellow`, `purple`, `cyan`, `white`, `black`

### fade (number)
Time in milliseconds before the notification fades away automatically.

## Examples

```lua
local ig = exports["ingenium"]:GetIngenium()

-- Success notification
exports["ingenium"]:Notify("Saved!", "green", 2500)

-- Error notification
exports["ingenium"]:Notify("Error occurred", "red", 3000)

-- Info notification
exports["ingenium"]:Notify("Processing...", "blue", 1500)

-- Via framework object
ig.func.Notify("Hello World", "cyan", 3000)
```

## See Also

- [ShowMenu](ig_export_ShowMenu.md) - Display menu
- [ShowInput](ig_export_ShowInput.md) - Get user input
- [AddChatMessage](ig_export_AddChatMessage.md) - Add chat message
