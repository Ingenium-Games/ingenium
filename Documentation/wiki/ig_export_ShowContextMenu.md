# Export: ShowContextMenu(data)

**Parameters**: 
- `data` (table) - Context menu configuration
  - `data.actions` (table[]) - Array of {label, action} items

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [C]

## Description

Display a context menu (right-click style menu) with action options.

## Usage

```lua
exports["ingenium"]:ShowContextMenu({
    actions = {
        {label = "Take", action = "take"},
        {label = "Examine", action = "examine"},
        {label = "Cancel", action = "cancel"}
    }
})

-- Listen for selection
RegisterNetEvent("Client:Context:Select")
AddEventHandler("Client:Context:Select", function(action)
    if action == "take" then
        print("Player took the item")
    end
end)
```

## Parameters

### data (table)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| actions | table[] | Yes | Array of action options |

### actions[] (table)

Each action should have:
- `label` (string) - Display text
- `action` (string) - Action identifier

## Examples

```lua
-- Frisk a player
exports["ingenium"]:ShowContextMenu({
    actions = {
        {label = "Frisk", action = "frisk"},
        {label = "Talk", action = "talk"},
        {label = "Cancel", action = "cancel"}
    }
})

-- Listen for choice
RegisterNetEvent("Client:Context:Select")
AddEventHandler("Client:Context:Select", function(action)
    if action == "frisk" then
        -- Frisk logic
    elseif action == "talk" then
        -- Talk logic
    end
end)

-- Search a vehicle
exports["ingenium"]:ShowContextMenu({
    actions = {
        {label = "Search", action = "search_vehicle"},
        {label = "Close", action = "close"}
    }
})
```

## See Also

- [HideContextMenu](ig_export_HideContextMenu.md) - Close context menu
- [ShowMenu](ig_export_ShowMenu.md) - Main menu
- [ShowInput](ig_export_ShowInput.md) - Input dialog
