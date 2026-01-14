# Export: ShowInput(data)

**Parameters**: 
- `data` (table) - Input configuration
  - `data.title` (string) - Input prompt text
  - `data.placeholder` (string) - Placeholder text
  - `data.max` (number) - Maximum characters allowed

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [C]

## Description

Display an input dialog for the player to enter text.

## Usage

```lua
exports["ingenium"]:ShowInput({
    title = "Enter Amount",
    placeholder = "0",
    max = 10
})

-- Listen for submission
RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(value)
    print("Player entered:", value)
end)
```

## Parameters

### data (table)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| title | string | Yes | Input prompt/label |
| placeholder | string | Yes | Placeholder text |
| max | number | Yes | Max characters allowed |

## Examples

```lua
-- Get player name
exports["ingenium"]:ShowInput({
    title = "Enter your name",
    placeholder = "John Doe",
    max = 50
})

-- Listen for result
RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(name)
    if name and name ~= "" then
        exports["ingenium"]:Notify("Hello " .. name, "green", 3000)
    end
end)

-- Get amount (limited to 10 characters)
exports["ingenium"]:ShowInput({
    title = "Deposit Amount",
    placeholder = "1000",
    max = 10
})
```

## See Also

- [HideInput](ig_export_HideInput.md) - Close input
- [ShowMenu](ig_export_ShowMenu.md) - Menu dialog
- [ShowContextMenu](ig_export_ShowContextMenu.md) - Context menu
