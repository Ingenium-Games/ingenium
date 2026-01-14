# Export: TriggerServerCallback(args)

**Parameters**: 
- `args` (table) - Callback configuration
  - `args.eventName` (string) - Server event to trigger
  - `args.args` (table) - Arguments to send
  - `args.callback` (function) - Response handler
  - `args.source` (number) - Player source ID (optional)

**Returns**: `void` (calls callback with response)  
**Security**: ✅ Public (rate-limited, ticket-validated)  
**Side**: [C]

## Description

Make request-response calls to the server with automatic validation and rate limiting.

## Usage

```lua
TriggerServerCallback({
    eventName = "Server:Bank:GetBalance",
    args = {characterId},
    source = GetPlayerServerId(PlayerId()),
    callback = function(balance)
        print("Your balance: $" .. balance)
    end
})
```

## Parameters

### args (table)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| eventName | string | Yes | Server callback event name |
| args | table | Yes | Arguments to send to server |
| callback | function | Yes | Function to call with response |
| source | number | No | Player source ID |

## Examples

```lua
-- Get player balance
TriggerServerCallback({
    eventName = "Server:Bank:GetBalance",
    args = {characterId},
    callback = function(balance)
        exports["ingenium"]:Notify("Balance: $" .. balance, "green", 3000)
    end
})

-- Deposit money
TriggerServerCallback({
    eventName = "Server:Bank:Deposit",
    args = {amount, characterId},
    callback = function(success, message)
        if success then
            exports["ingenium"]:Notify("Deposited: $" .. amount, "green", 3000)
        else
            exports["ingenium"]:Notify(message, "red", 3000)
        end
    end
})

-- Get inventory
TriggerServerCallback({
    eventName = "Server:Inventory:GetInventory",
    args = {},
    callback = function(inventory)
        print("Inventory weight: " .. inventory.weight)
    end
})
```

## Server Implementation

Register a callback handler on server:

```lua
ig.callback.RegisterServer("Server:MyCallback", function(source, args)
    local playerId = source
    local arg1 = args[1]
    local arg2 = args[2]
    
    -- Do work
    local result = processData(arg1, arg2)
    
    -- Return response
    return result
end)
```

## See Also

- [Notify](ig_export_Notify.md) - Send notification
- Server callbacks documentation in EVENTS_REFERENCE.md
