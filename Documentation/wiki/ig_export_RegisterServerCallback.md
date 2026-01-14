# RegisterServerCallback

## Description

Register a handler for a server-side callback event. Handlers registered with this function can be triggered using `TriggerServerCallback` from clients.

## Signature

```lua
RegisterServerCallback({
    eventName = string,
    eventCallback = function
})
```

## Parameters

- **`eventName`** (string): The name of the callback event to register
- **`eventCallback`** (function): The handler function that will be called when the callback is triggered. Receives `source` (player ID) as the first argument, followed by any additional arguments

## Returns

- **`any`**: Event handler reference (can be used with `UnregisterServerCallback`)

## Example

```lua
-- Server-side: Register a callback to handle player requests
RegisterServerCallback({
    eventName = "Server:GetPlayerData",
    eventCallback = function(source, playerId)
        local player = GetPlayer(playerId)
        if player then
            return {
                name = player.name,
                job = player.job
            }
        end
        return nil, "Player not found"
    end
})

-- With permission checking
RegisterServerCallback({
    eventName = "Server:Admin:Ban",
    eventCallback = function(source, targetId, reason)
        if not IsPlayerAceAllowed(source, 'admin') then
            return nil, "Permission denied"
        end
        BanPlayer(targetId, reason)
        return {success = true}
    end
})

-- Store reference for later unregistering
local myCallback = RegisterServerCallback({
    eventName = "Server:Custom:Event",
    eventCallback = function(source, data)
        return processData(source, data)
    end
})
```

## Notes

- This callback is **networked** - can be triggered by clients using `TriggerServerCallback`
- The `source` parameter (player ID) is always the first argument
- Return multiple values: first is the result, second is an optional error message
- Use `RegisterClientCallback` for client-side callback handlers
- Consider adding ACL permission checks for sensitive callbacks

## Security Considerations

For sensitive operations, always validate the source player has appropriate permissions:
```lua
RegisterServerCallback({
    eventName = "Server:Transfer:Money",
    eventCallback = function(source, amount)
        if not IsPlayerAceAllowed(source, 'money.transfer') then
            return nil, "Permission denied"
        end
        -- Process transfer...
        return {success = true}
    end
})
```

## Source

Defined in: `shared/[Third Party]/_callbacks.lua` | Exported in: `shared/_ig.lua`
