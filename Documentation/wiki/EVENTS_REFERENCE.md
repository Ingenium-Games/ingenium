# Events Reference

Complete documentation of all network events and local events available in the Ingenium framework.

---

## Overview

| Event Type | Count | Status | Usage |
|------------|-------|--------|-------|
| Public Events | 11+ | ✅ Safe | Can trigger from any resource |
| Protected Events | 14+ | 🔒 Blocked | Framework-internal only |
| Server Callbacks | 50+ | ✅ Safe | Via TriggerServerCallback |
| Local Events | 20+ | ✅ Safe | Client/Server local triggers |

---

## Public Events (Can trigger from any resource)

### Client Events

These events can be triggered from any resource and will be executed on the client:

#### `Client:Menu:Select`

**Triggered when**: User selects a menu option

**Parameters**:
- `action` (string) - The action string from selected option

**Usage**:
```lua
-- Send from server to client
TriggerClientEvent("Client:Menu:Select", playerId, "buy_item")

-- Listen on client
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action)
    print("User selected:", action)
end)
```

---

#### `Client:Input:Submit`

**Triggered when**: User submits input dialog

**Parameters**:
- `value` (string) - The input value

**Usage**:
```lua
-- Send from server to client
TriggerClientEvent("Client:Input:Submit", playerId, userInput)

-- Listen on client
RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(value)
    print("User submitted:", value)
end)
```

---

#### `Client:Context:Select`

**Triggered when**: User selects context menu action

**Parameters**:
- `action` (string) - The selected action

**Usage**:
```lua
TriggerClientEvent("Client:Context:Select", playerId, "frisk")

RegisterNetEvent("Client:Context:Select")
AddEventHandler("Client:Context:Select", function(action)
    print("Context action:", action)
end)
```

---

#### `Client:Banking:OpenMenu`

**Triggered to**: Open banking menu on client

**Parameters**:
- `data` (table) - Banking data
  - `data.characterId` (number) - Character ID
  - `data.iban` (string) - IBAN account number
  - `data.balance` (number) - Current balance

**Usage**:
```lua
TriggerClientEvent("Client:Banking:OpenMenu", playerId, {
    characterId = charId,
    iban = playerIban,
    balance = playerBalance
})
```

---

### Server Events (Via Callbacks)

Use `TriggerServerCallback` for these server events instead of direct triggering:

```lua
TriggerServerCallback({
    eventName = "Server:Bank:Deposit",
    args = {amount, characterId},
    callback = function(success, message)
        if success then
            print("Deposited:", amount)
        else
            print("Error:", message)
        end
    end
})
```

**Available Server Callbacks**:
- `Server:Bank:GetBalance` - Get account balance
- `Server:Bank:Deposit` - Deposit money
- `Server:Bank:Withdraw` - Withdraw money
- `Server:Inventory:GetInventory` - Get inventory contents
- `Server:Vehicle:GetVehicles` - Get player vehicles
- And 50+ more...

---

## Protected Events (Internal Framework Only)

⚠️ **WARNING**: These events have `GetInvokingResource()` checks and will be **blocked** if triggered from external resources.

### Character Events

#### `Client:Character:Play`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Play selected character  
**Parameters**: `(characterId)`

```lua
-- ❌ This will be blocked:
TriggerClientEvent("Client:Character:Play", playerId, charId)

-- ✅ Only Ingenium framework can trigger this
```

---

#### `Client:Character:Create`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Create new character  
**Parameters**: `(firstName, lastName)`

```lua
-- ❌ This will be blocked from external resources
```

---

#### `Client:Character:Delete`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Delete character  
**Parameters**: `(characterId)`

```lua
-- ❌ This will be blocked from external resources
```

---

#### `Client:Character:OpeningMenu`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Open character selection menu  
**Parameters**: None

---

#### `Client:Character:NewSpawn`
**Security**: Protected  
**Purpose**: New character spawn  
**Parameters**: `(spawnData)`

---

#### `Client:Character:LoadSkin`
**Security**: Protected  
**Purpose**: Load character appearance  
**Parameters**: `(appearanceData)`

---

#### `Client:Character:SaveSkin`
**Security**: Protected  
**Purpose**: Save character appearance  
**Parameters**: `(appearanceData)`

---

#### `Client:Character:Loaded`
**Security**: Protected  
**Purpose**: Character loaded notification  
**Parameters**: None

---

#### `Client:Character:Ready`
**Security**: Protected  
**Purpose**: Character ready for play  
**Parameters**: None

---

#### `Client:Character:Pre-Switch`
**Security**: Protected  
**Purpose**: Before character switch  
**Parameters**: None

---

#### `Client:Character:Switch`
**Security**: Protected  
**Purpose**: Character switched  
**Parameters**: None

---

#### `Client:Character:OffDuty`
**Security**: Protected  
**Purpose**: Go off duty  
**Parameters**: None

---

#### `Client:Character:OnDuty`
**Security**: Protected  
**Purpose**: Go on duty  
**Parameters**: None

---

#### `Client:Character:SetJob`
**Security**: Protected  
**Purpose**: Set character job  
**Parameters**: `(jobId, gradeId)`

---

#### `Client:Character:Death`
**Security**: Protected  
**Purpose**: Character death  
**Parameters**: `(deathData)`

---

### Inventory Events

#### `Client:Inventory:OpenDual`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Open dual inventory view  
**Parameters**: `(externalNetId, externalTitle)`

---

#### `Client:Inventory:OpenSingle`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Open player inventory  
**Parameters**: None

---

#### `Client:Inventory:Update`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Update inventory live  
**Parameters**: `(playerInventory, externalInventory)`

---

#### `Client:Inventory:Close`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Close inventory  
**Parameters**: None

---

### Notification Event

#### `Client:Notify`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Send notification to player  
**Parameters**: `(text, colour, fade)`

**Code Example** (from [nui/lua/notification.lua#L25](../../../nui/lua/notification.lua#L25)):
```lua
RegisterNetEvent("Client:Notify")
AddEventHandler("Client:Notify", function(text, colour, fade)
    local inv = GetInvokingResource()
    if inv ~= nil and inv ~= conf.resourcename then
        CancelEvent()  -- Block external calls
        return
    end
    sendNotification(text, colour, fade)
end)
```

✅ **Use instead**: `exports["ingenium"]:Notify(text, colour, fade)`

---

### Drop System Events

#### `Client:Drop:Notify`
**Security**: Protected  
**Purpose**: Drop notification  
**Parameters**: `(dropData)`

---

#### `Client:Drop:AccessDenied`
**Security**: Protected  
**Purpose**: Access denied notification  
**Parameters**: `(accessData)`

---

#### `Client:Drop:Removed`
**Security**: Protected  
**Purpose**: Drop removed  
**Parameters**: `(uuid)`

---

#### `Client:Inventory:UpdateLive`
**Security**: Protected  
**Purpose**: Live inventory update  
**Parameters**: `(fromNetId, toNetId)`

---

#### `Client:Drop:InventoryUpdated`
**Security**: Protected  
**Purpose**: Drop inventory updated  
**Parameters**: `(netId, inventory)`

---

### RunChecks Events (State Monitoring)

These fire when StateBag values change:

#### `Client:RunChecks:IsWanted`
**Security**: Protected  
**Purpose**: Wanted status changed  
**Parameters**: None

---

#### `Client:RunChecks:IsSupporter`
**Security**: Protected  
**Purpose**: Supporter status changed  
**Parameters**: None

---

#### `Client:RunChecks:IsDead`
**Security**: Protected  
**Purpose**: Death status changed  
**Parameters**: None

---

#### `Client:RunChecks:IsCuffed`
**Security**: Protected  
**Purpose**: Cuffed status changed  
**Parameters**: None

---

#### `Client:RunChecks:IsEscorting`
**Security**: Protected  
**Purpose**: Escorting status changed  
**Parameters**: None

---

#### `Client:RunChecks:IsEscorted`
**Security**: Protected  
**Purpose**: Escorted status changed  
**Parameters**: None

---

#### `Client:RunChecks:IsSwimming`
**Security**: Protected  
**Purpose**: Swimming status changed  
**Parameters**: None

---

### Door System Events

#### `Client:Doors:Sync`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Synchronize door state  
**Parameters**: `(doorHash, doorState)`

---

### Vehicle Persistence Events

#### `Client:Vehicle:PersistenceRegistered`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Vehicle registered for persistence  
**Parameters**: `(vehicleData)`

---

#### `Client:Vehicle:Spawned`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Persistent vehicle spawned  
**Parameters**: `(vehicleData)`

---

#### `Client:Vehicle:Despawned`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Persistent vehicle despawned  
**Parameters**: `(vehicleData)`

---

### Locate Vehicles Event

#### `Client:Vehicle:CreateLocateBlips`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Create locate blips for vehicles  
**Parameters**: `(vehicleBlips)`

---

### Screenshot Events

#### `ig:screenshot:takeOnReport`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Take screenshot on report  
**Parameters**: `(reportData)`

---

#### `ig:screenshot:takeOnError`
**Security**: Protected with GetInvokingResource() check  
**Purpose**: Take screenshot on error  
**Parameters**: `(errorData)`

---

## Local Events (Per-Client)

These fire locally on client/server and are not synced across network:

### Client Local Events

```lua
-- Listen for local events
RegisterLocalEvent("Client:SomeEvent")
AddEventHandler("Client:SomeEvent", function(data)
    -- Handle event
end)

-- Trigger locally
TriggerEvent("Client:SomeEvent", data)
```

### Server Local Events

```lua
-- Listen for server-side local events
RegisterLocalEvent("Server:SomeEvent")
AddEventHandler("Server:SomeEvent", function(source, data)
    -- Handle event
end)

-- Trigger locally on server
TriggerEvent("Server:SomeEvent", data)
```

---

## Event Security Patterns

### Protected Event Pattern

```lua
RegisterNetEvent("Client:ProtectedEvent")
AddEventHandler("Client:ProtectedEvent", function(data)
    -- Security check - only Ingenium can call this
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    
    -- Safe to proceed - only framework triggered this
    processData(data)
end)
```

### Public Event Pattern

```lua
RegisterNetEvent("Client:PublicEvent")
AddEventHandler("Client:PublicEvent", function(data)
    -- No security check - external resources allowed
    processData(data)
end)
```

---

## Event Communication Best Practices

### ✅ DO Use

```lua
-- Use callbacks for server communication
TriggerServerCallback({
    eventName = "Server:Action",
    args = {arg1, arg2},
    callback = function(result) end
})

-- Use public events when documented
TriggerClientEvent("Client:Menu:Select", playerId, action)

-- Use exports for direct function calls
local result = exports["ingenium"]:GetIngenium()
```

### ❌ DON'T Use

```lua
-- Don't trigger protected events
TriggerClientEvent("Client:Character:Play", playerId, charId)  -- BLOCKED

-- Don't bypass GetInvokingResource checks
-- They will fail and event will be cancelled

-- Don't directly trigger server-internal events
TriggerEvent("Server:InternalEvent", data)
```

---

## Event Listening Examples

### Listen for Public Events

```lua
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action)
    if action == "buy_item" then
        -- Handle purchase
    end
end)
```

### Listen for Status Changes

```lua
RegisterNetEvent("Client:RunChecks:IsDead")
AddEventHandler("Client:RunChecks:IsDead", function()
    local isDead = LocalPlayer.state.IsDead
    if isDead then
        print("Player died")
    else
        print("Player revived")
    end
end)
```

### Server Callback Listener

```lua
-- Server side
ig.callback.RegisterServer("Server:MyAction", function(source, args)
    local playerId = source
    local arg1 = args[1]
    
    -- Do action
    local result = doSomething(arg1)
    
    -- Send response back to client
    return result
end)

-- Client side
TriggerServerCallback({
    eventName = "Server:MyAction",
    args = {myArg},
    callback = function(result)
        print("Server response:", result)
    end
})
```

---

## Event Statistics

| Category | Count | Notes |
|----------|-------|-------|
| Public Client Events | 4 | Menu, Input, Context, Banking |
| Protected Client Events | 27+ | Character, Inventory, etc. |
| Server Callbacks | 50+ | Via TriggerServerCallback |
| Local Events | 20+ | Per-client triggers |
| **Total Events** | **100+** | **Complete event system** |

---

## Troubleshooting Events

### Event Not Firing?

Check if:
1. ✅ Event is public (not protected)
2. ✅ Spelling matches exactly
3. ✅ Parameters match documentation
4. ✅ Client/server is listening
5. ✅ GetInvokingResource() not blocking

### Getting "CancelEvent" in Console?

This means:
- ❌ You triggered a protected event from external resource
- ✅ Use the documented alternative (exports or callbacks)

### Event Handlers Not Calling?

Debug with:
```lua
-- Listen for specific event
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action)
    print("EVENT FIRED! Action:", action)
end)

-- Server: Send test event
TriggerClientEvent("Client:Menu:Select", 1, "test_action")
```

---

## Quick Reference

| Need | Solution | Security |
|------|----------|----------|
| Send notification | `exports["ingenium"]:Notify()` or `Client:Notify` event | 🔒 Protected event |
| Open menu | Use `ShowMenu` export | ✅ Public |
| Get server data | `TriggerServerCallback` | ✅ Validated |
| Trigger character action | Can't - protected internally | 🔒 Blocked |
| Listen for status change | `Client:RunChecks:*` events | 🔒 Protected |

---

## Documentation Links

- [PUBLIC_API.md](PUBLIC_API.md) - Public API overview
- [EXPORTS_GUIDE.md](EXPORTS_GUIDE.md) - Complete exports reference
- [../../CODE_REVIEW_STAGE_3A_EXPORTS.md](../../CODE_REVIEW_STAGE_3A_EXPORTS.md) - Detailed analysis

---

**Last Updated**: 2024  
**Total Events**: 100+  
**Public Events**: 11+  
**Protected Events**: 14+  
**Status**: ✅ Current
