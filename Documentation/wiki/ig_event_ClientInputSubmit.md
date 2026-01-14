# Public Event: Client:Input:Submit

**Triggered when**: User submits input dialog  
**Security**: ✅ Public (can trigger from any resource)  
**Side**: [C]

## Description

Fires when a player submits text via an input dialog displayed via `ShowInput()`.

## Parameters

- `value` (string) - The input value entered by the player

## Usage

```lua
-- Listen for input submission on client
RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(value)
    print("Player entered:", value)
    exports["ingenium"]:Notify("You entered: " .. value, "green", 3000)
end)
```

## Server-Side Trigger

```lua
-- Send from server to client
TriggerClientEvent("Client:Input:Submit", playerId, userInput)
```

## Examples

```lua
-- Client: Show input dialog
exports["ingenium"]:ShowInput({
    title = "Deposit Amount",
    placeholder = "0",
    max = 10
})

-- Client: Listen for submission
RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(amount)
    local amountNum = tonumber(amount)
    if amountNum and amountNum > 0 then
        TriggerServerCallback({
            eventName = "Server:Bank:Deposit",
            args = {amountNum},
            callback = function(success, message)
                local color = success and "green" or "red"
                exports["ingenium"]:Notify(message, color, 3000)
            end
        })
    end
end)
```

## See Also

- [ShowInput](ig_export_ShowInput.md) - Display input dialog
- [Client:Menu:Select](ig_event_ClientMenuSelect.md) - Menu selection
- [Client:Context:Select](ig_event_ClientContextSelect.md) - Context menu selection
