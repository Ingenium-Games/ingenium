# Public Event: Client:Menu:Select

**Triggered when**: User selects a menu option  
**Security**: ✅ Public (can trigger from any resource)  
**Side**: [C]

## Description

Fires when a player selects an option from a menu displayed via `ShowMenu()`.

## Parameters

- `action` (string) - The action string from the selected option

## Usage

```lua
-- Listen for menu selection on client
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action)
    if action == "buy_item" then
        print("Player wants to buy item")
    elseif action == "sell_item" then
        print("Player wants to sell item")
    end
end)
```

## Server-Side Trigger

```lua
-- Send from server to client
TriggerClientEvent("Client:Menu:Select", playerId, "buy_item")
```

## Examples

```lua
-- Client: Display menu
exports["ingenium"]:ShowMenu({
    title = "Vendor Menu",
    options = {
        {label = "Buy Item", action = "buy_item"},
        {label = "Sell Item", action = "sell_item"},
        {label = "Leave", action = "leave"}
    }
})

-- Client: Listen for selection
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action)
    if action == "buy_item" then
        exports["ingenium"]:Notify("Opening shop...", "green", 2000)
    elseif action == "sell_item" then
        exports["ingenium"]:Notify("Opening sell menu...", "green", 2000)
    end
end)
```

## See Also

- [ShowMenu](ig_export_ShowMenu.md) - Display menu
- [Client:Input:Submit](ig_event_ClientInputSubmit.md) - Input submission
- [Client:Context:Select](ig_event_ClientContextSelect.md) - Context menu selection
