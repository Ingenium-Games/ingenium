# Export: ShowMenu(data)

**Parameters**: 
- `data` (table) - Menu configuration
  - `data.title` (string) - Menu title
  - `data.options` (table[]) - Array of {label, action} items

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [C]

## Description

Display an interactive menu for the player to select from.

## Usage

```lua
exports["ingenium"]:ShowMenu({
    title = "Select Option",
    options = {
        {label = "Option 1", action = "action1"},
        {label = "Option 2", action = "action2"},
        {label = "Close", action = "close"}
    }
})

-- Listen for selection
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action)
    if action == "action1" then
        print("Player selected action 1")
    end
end)
```

## Parameters

### data (table)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| title | string | Yes | Menu title displayed at top |
| options | table[] | Yes | Array of menu options |

### options[] (table)

Each option should have:
- `label` (string) - Display text
- `action` (string) - Action identifier

## Examples

```lua
local ig = exports["ingenium"]:GetIngenium()

-- Simple menu
exports["ingenium"]:ShowMenu({
    title = "Main Menu",
    options = {
        {label = "Job Menu", action = "job_menu"},
        {label = "Settings", action = "settings"},
        {label = "Exit", action = "exit"}
    }
})

-- Listen for action
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action)
    if action == "job_menu" then
        -- Handle job menu
    elseif action == "settings" then
        -- Handle settings
    end
end)
```

## See Also

- [HideMenu](ig_export_HideMenu.md) - Close menu
- [ShowContextMenu](ig_export_ShowContextMenu.md) - Context menu
- [ShowInput](ig_export_ShowInput.md) - Input dialog
