# Public Event: Client:Context:Select

**Triggered when**: User selects context menu action  
**Security**: ✅ Public (can trigger from any resource)  
**Side**: [C]

## Description

Fires when a player selects an action from a context menu displayed via `ShowContextMenu()`.

## Parameters

- `action` (string) - The selected action string

## Usage

```lua
-- Listen for context menu selection on client
RegisterNetEvent("Client:Context:Select")
AddEventHandler("Client:Context:Select", function(action)
    if action == "frisk" then
        print("Player is frisking someone")
    elseif action == "talk" then
        print("Player wants to talk")
    end
end)
```

## Server-Side Trigger

```lua
-- Send from server to client
TriggerClientEvent("Client:Context:Select", playerId, "frisk")
```

## Examples

```lua
-- Client: Display context menu
exports["ingenium"]:ShowContextMenu({
    actions = {
        {label = "Frisk", action = "frisk"},
        {label = "Talk", action = "talk"},
        {label = "Search", action = "search"},
        {label = "Cancel", action = "cancel"}
    }
})

-- Client: Listen for selection
RegisterNetEvent("Client:Context:Select")
AddEventHandler("Client:Context:Select", function(action)
    if action == "frisk" then
        exports["ingenium"]:Notify("Frisking...", "blue", 2000)
        -- Perform frisk animation/logic
    elseif action == "talk" then
        exports["ingenium"]:Notify("Starting conversation...", "blue", 2000)
        -- Start dialogue
    elseif action == "search" then
        exports["ingenium"]:Notify("Searching...", "blue", 2000)
        -- Search logic
    end
end)
```

## See Also

- [ShowContextMenu](ig_export_ShowContextMenu.md) - Display context menu
- [Client:Menu:Select](ig_event_ClientMenuSelect.md) - Menu selection
- [Client:Input:Submit](ig_event_ClientInputSubmit.md) - Input submission
