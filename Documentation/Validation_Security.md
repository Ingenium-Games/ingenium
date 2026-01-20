# Validation & Security System

## Overview

Ingenium implements **defense-in-depth security** with server-authoritative validation, StateBag protection, rate limiting, and exploit detection. All client data is validated before processing.

## Validation Module (ig.check)

### Type Validation

Located in `server/[Validation]/_check.lua`, provides type-safe value validation:

#### Boolean Validation

```lua
ig.check.Boolean(value)
```

Returns validated boolean:

```lua
local active = ig.check.Boolean(data.active)  -- true/false
local enabled = ig.check.Boolean(nil)  -- false (default)
```

#### Number Validation

```lua
ig.check.Number(value, min, max)
```

Returns clamped number within range:

```lua
local health = ig.check.Number(data.health, 0, 100)  -- Clamps to 0-100
local cash = ig.check.Number(data.cash, 0, 999999)  -- Max 999,999
local age = ig.check.Number(data.age, 18, 120)  -- Age range
```

**Invalid input returns min value:**
```lua
local health = ig.check.Number("invalid", 0, 100)  -- Returns 0
```

#### String Validation

```lua
ig.check.String(value, minLength, maxLength)
```

Returns validated string within length constraints:

```lua
local name = ig.check.String(data.name, 1, 50)  -- 1-50 chars
local message = ig.check.String(data.msg, 0, 500)  -- 0-500 chars
```

**Trims whitespace and validates:**
```lua
local name = ig.check.String("  John  ", 1, 50)  -- Returns "John"
local empty = ig.check.String("", 1, 50)  -- Returns "" (or raises error)
```

#### Table Validation

```lua
ig.check.Table(value)
```

Returns validated table or empty table:

```lua
local items = ig.check.Table(data.items)  -- Returns table or {}
```

## Inventory Validation (ig.validation)

### Validation Functions

Located in `server/[Validation]/_validator.lua`:

#### GetItemQuantities

```lua
ig.validation.GetItemQuantities(inventory)
```

Aggregates item quantities from inventory array:

```lua
local quantities = ig.validation.GetItemQuantities(inventory)
-- Returns: {item_name = total_quantity, ...}
```

#### IsValidItem

```lua
ig.validation.IsValidItem(itemName)
```

Checks if item exists in database:

```lua
if ig.validation.IsValidItem('bread') then
    -- Item exists in ig.items
end
```

#### ValidateSlot

```lua
ig.validation.ValidateSlot(slot, index)
```

Comprehensive per-slot validation:

- **Valid item** - Item exists in database
- **Quantity** - Type number, range 1-999,999
- **Quality** - Range 0-100
- **Weapon flag** - Weapons cannot stack (qty must be 1)

```lua
local valid, error = ig.validation.ValidateSlot({
    name = 'bread',
    quantity = 5,
    quality = 100
}, 1)

if not valid then
    print('Slot validation failed:', error)
end
```

#### ValidateInventory

```lua
ig.validation.ValidateInventory(inventory)
```

Validates entire inventory array:

```lua
local valid, error = ig.validation.ValidateInventory(playerInventory)

if not valid then
    ig.log.Error("Inventory invalid: %s", error)
end
```

#### ValidateInventoryIntegrity

```lua
ig.validation.ValidateInventoryIntegrity(beforeInv1, beforeInv2, afterInv1, afterInv2)
```

**Duplication/injection detection** comparing before/after states:

```lua
-- Prevent item injection
for item, _ in pairs(afterTotal) do
    if not beforeTotal[item] then
        return false, "Item injection detected"
    end
end

-- Prevent duplication
if afterQty > beforeQty then
    return false, "Item duplication detected"
end
```

Example usage:

```lua
local serverInv = xPlayer.GetInventory()
local valid, error = ig.validation.ValidateInventoryIntegrity(
    serverInv,  -- Before state
    nil,        -- No second inventory
    clientInv,  -- After state
    nil
)

if not valid then
    ig.validation.LogAndBanExploiter(source, error)
end
```

#### ValidateAndUnpack

```lua
ig.validation.ValidateAndUnpack(inventory)
```

Unified validation + processing with quality cleanup:

```lua
local valid, result = ig.validation.ValidateAndUnpack(inventory)

if valid then
    -- Items with quality < 0 are removed
    xPlayer.SetInventory(result)
else
    ig.log.Error("Invalid inventory: %s", result)
end
```

### Exploit Logging

```lua
ig.validation.LogAndBanExploiter(source, reason)
```

Logs exploit attempts and triggers ban:

```lua
-- Sanitizes reason (removes newlines)
-- Logs to txaLogger:SecurityAlert
-- Triggers ban event
```

## StateBag Protection

### Security Model

Dual-list system located in `server/[Security]/_statebag_protection.lua`:

#### Whitelist (Client Can Write)

```lua
local ALLOWED_CLIENT_KEYS = {
    -- Animation
    'Animation', 'Emote', 'WalkStyle',
    
    -- Movement
    'IsJumping', 'IsSwimming', 'IsDiving', 'IsRagdoll',
    
    -- Voice
    'InVoice', 'CallActive', 'VoiceMode', 'RadioFrequency'
}
```

#### Blacklist (Client Cannot Write)

```lua
local BLOCKED_CLIENT_KEYS = {
    -- Financial
    'Cash', 'Bank', 'Inventory',
    
    -- Identity
    'Character_ID', 'License_ID', 'Job', 'Grade',
    
    -- Stats
    'Health', 'Armour',
    
    -- Permissions
    'Ace', 'InAdminCall',
    
    -- Keys
    'Keys'
}
```

### Protection Mechanism

```lua
AddStateBagChangeHandler(nil, nil, function(bagName, key, value, reserved, replicated)
    if reserved then return end  -- Skip server-side changes
    
    local source = GetPlayerFromStateBagName(bagName)
    if source == 0 then return end
    
    -- Check blacklist FIRST (critical keys)
    if BLOCKED_CLIENT_KEYS[key] then
        TriggerEvent('txaLogger:SecurityAlert', {
            source = source,
            type = 'statebag_blocked',
            key = key,
            value = value
        })
        return
    end
    
    -- Then check whitelist
    if not ALLOWED_CLIENT_KEYS[key] then
        TriggerEvent('txaLogger:SecurityAlert', {
            source = source,
            type = 'statebag_unauth',
            key = key,
            value = value
        })
        return
    end
end)
```

### Dynamic Key Management

```lua
-- Add allowed key
ig.security.AddAllowedStateBagKey(keyName)

-- Remove allowed key
ig.security.RemoveAllowedStateBagKey(keyName)

-- Add blocked key
ig.security.AddBlockedStateBagKey(keyName)

-- Remove blocked key
ig.security.RemoveBlockedStateBagKey(keyName)

-- Get lists
local allowed = ig.security.GetAllowedStateBagKeys()
local blocked = ig.security.GetBlockedStateBagKeys()
```

## Rate Limiting

### Transaction Rate Limiting

Located in `server/[Security]/_transaction_security.lua`:

#### Rate Limit Check

```lua
ig.security.CheckRateLimit(playerId, transactionType)
```

Enforces 1-second cooldown between transactions:

```lua
if not ig.security.CheckRateLimit(source, 'cash_add') then
    print('Rate limit exceeded')
    return
end

-- Process transaction
xPlayer.AddCash(100)
```

**Cooldown format:** `playerId_transactionType`

#### Transaction Rate Limit

```lua
ig.security.CheckTransactionRateLimit(playerId)
```

Detects fraud patterns (>20 transactions in 60 seconds):

```lua
if not ig.security.CheckTransactionRateLimit(source) then
    TriggerEvent('txaLogger:FraudAlert', {
        player = source,
        transactions = history
    })
    return
end
```

### Logging

```lua
ig.security.LogTransaction(playerId, type, amount, reason)
ig.security.LogPlayerTransaction(playerId, type, amount, reason, beforeCash, beforeBank)
```

Tracks all financial transactions:

```lua
ig.security.LogPlayerTransaction(
    source,
    'cash_add',
    100,
    'Job payment',
    xPlayer.GetCash(),
    xPlayer.GetBank()
)
```

### Suspicious Activity Detection

```lua
ig.security.DetectSuspiciousActivity(playerId)
```

Analyzes transaction patterns for anomalies.

## Inventory Security

### Organize Inventory (Single)

```lua
RegisterServerCallback('Server:Inventory:OrganizeInventory', function(source, inv1, cb)
    local xPlayer = ig.data.GetPlayer(source)
    
    -- 1. Capture server state
    local beforeInventory = xPlayer.GetInventory()
    
    -- 2. Validate integrity
    local valid, error = ig.validation.ValidateInventoryIntegrity(
        beforeInventory, nil, inv1, nil
    )
    
    if not valid then
        ig.validation.LogAndBanExploiter(source, error)
        return cb({ok = false, error = error})
    end
    
    -- 3. Unpack and set
    xPlayer.UnpackInventory(inv1)
    cb({ok = true})
end)
```

### Organize Inventories (Transfer)

```lua
RegisterServerCallback('Server:Inventory:OrganizeInventories', function(source, inv1, inv2, cb)
    local xPlayer = ig.data.GetPlayer(source)
    
    -- 1. Get CURRENT server state (not cached)
    local serverInv = xPlayer.GetInventory()
    
    -- 2. Detect concurrent access
    local diff = math.abs(#serverInv - #inv1)
    if diff > 10 then
        ig.validation.LogAndBanExploiter(source, "Major inventory desync")
        return cb({ok = false})
    end
    
    -- 3. Auto-adjust for minor differences
    if diff > 0 then
        -- Remove excess items
    end
    
    -- 4. Item injection check
    for _, item in ipairs(inv1) do
        if not ig.validation.IsValidItem(item.name) then
            ig.validation.LogAndBanExploiter(source, "Item injection")
            return cb({ok = false})
        end
    end
    
    -- 5. Validate quantities didn't increase
    local valid = ig.validation.ValidateInventoryIntegrity(
        serverInv, targetInv, inv1, inv2
    )
    
    if not valid then
        ig.validation.LogAndBanExploiter(source, "Duplication detected")
        return cb({ok = false})
    end
    
    -- 6. Apply changes
    xPlayer.UnpackInventory(inv1)
    target.UnpackInventory(inv2)
    
    cb({ok = true})
end)
```

### Transfer Inventory Item

```lua
RegisterServerCallback('Server:Inventory:TransferInventoryItem', function(source, data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    
    -- 1. Validate source item exists
    local sourceItem = xPlayer.GetItemFromPosition(data.fromSlot)
    if not sourceItem then
        return cb({ok = false, error = 'Item not found'})
    end
    
    -- 2. Validate quantity
    local qty = ig.check.Number(data.quantity, 1, sourceItem.quantity)
    
    -- 3. Validate item matches
    if sourceItem.name ~= data.itemName then
        ig.validation.LogAndBanExploiter(source, "Item mismatch")
        return cb({ok = false})
    end
    
    -- 4. Execute transfer
    xPlayer.RemoveItem(data.fromSlot, qty)
    target.AddItem(data.toSlot, data.itemName, qty, sourceItem.quality)
    
    -- 5. Notify nearby players
    local coords = GetEntityCoords(GetPlayerPed(source))
    local players = ig.func.GetPlayersInArea(coords, 10.0)
    
    for _, player in ipairs(players) do
        TriggerClientEvent('Client:Inventory:Refresh', player)
    end
    
    cb({ok = true})
end)
```

## Security Patterns

### Attack Vectors & Defenses

| Attack Vector | Defense |
|---------------|---------|
| Item Duplication | Integrity check compares before/after totals |
| Item Injection | ValidateSlot checks items exist in database |
| Quantity Overflow | Caps at 999,999, validates as number type |
| Concurrent Access | Gets CURRENT server state, auto-adjusts |
| StateBag Hijacking | Whitelist + blacklist with dual-layer checks |
| Rate Limit Bypass | Per-type cooldowns with fraud pattern detection |
| Log Injection | Sanitizes reason strings (`[\r\n]` filtered) |
| Weapon Stacking | Validates weapons have quantity = 1 |
| Quality Exploit | Clamps quality 0-100, removes <0 items |

### Server Authority

All validation is **server-authoritative**:

```lua
-- ❌ Bad: Trust client data
xPlayer.SetCash(clientData.cash)

-- ✅ Good: Validate then apply
local cash = ig.check.Number(clientData.cash, 0, 999999)
xPlayer.AddCash(amount)  -- Uses AddCash, not SetCash
```

### Client Data Never Trusted

```lua
-- Always validate
local itemName = ig.check.String(data.item, 1, 50)
local quantity = ig.check.Number(data.qty, 1, 999)
local slot = ig.check.Number(data.slot, 1, 50)

-- Verify item exists
if not ig.validation.IsValidItem(itemName) then
    return
end

-- Check player has item
local hasItem = xPlayer.HasItem(itemName, quantity)
if not hasItem then
    return
end

-- Then process
xPlayer.RemoveItem(slot, quantity)
```

## Configuration

### Rate Limit Settings

```lua
-- _config/config.lua
conf.security = {
    transactionCooldown = 1000,     -- 1 second between transactions
    fraudWindow = 60000,            -- 60 second rolling window
    fraudThreshold = 20,            -- Max 20 transactions per window
    cooldownCleanup = 120000        -- Clean stale cooldowns after 2 min
}
```

### StateBag Settings

```lua
conf.statebag = {
    protectionEnabled = true,
    logUnauthorized = true,
    logBlocked = true
}
```

## Best Practices

1. **Always validate client data** - Use `ig.check.*` on all inputs
2. **Check before, compare after** - Inventory integrity validation
3. **Server is authority** - Never trust client state
4. **Validate existence** - Check items exist in database
5. **Clamp ranges** - Use min/max bounds on numbers
6. **Rate limit operations** - Prevent spam/abuse
7. **Log exploits** - Track and ban violators
8. **Sanitize logs** - Remove newlines from user input
9. **Protect StateBags** - Whitelist + blacklist approach
10. **Current state validation** - Use GetInventory(), not cached data

## Event Logging

### Security Events

```lua
-- StateBag violation
TriggerEvent('txaLogger:SecurityAlert', {
    source = source,
    type = 'statebag_blocked',
    key = key,
    value = value
})

-- Fraud detection
TriggerEvent('txaLogger:FraudAlert', {
    player = source,
    transactions = history
})

-- Exploit attempt
TriggerEvent('txaLogger:ExploitAttempt', {
    player = source,
    type = 'duplication',
    reason = 'Item quantity increased'
})
```

## Related Documentation

- [Class System](Class_System.md) - Entity setters with validation
- [Data Persistence](Data_Persistence.md) - Concurrent access protection
- [Callback System](Callback_System.md) - Rate limiting in callbacks
