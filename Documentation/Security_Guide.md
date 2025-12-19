# Security Best Practices - ingenium

This document outlines the security measures implemented in ingenium to protect against common FiveM exploits.

## Table of Contents
1. [StateBag Protection](#statebag-protection)
2. [Transaction Security](#transaction-security)
3. [Authorization Best Practices](#authorization-best-practices)
4. [Input Validation](#input-validation)

---

## StateBag Protection

### Overview
FiveM's Entity StateBags are writable by clients by default. This creates a critical vulnerability where malicious actors can modify sensitive data like `Cash`, `Bank`, `Keys`, and `Inventory` unless proper protections are in place.

### Implementation
**File**: `server/[Security]/_statebag_protection.lua`

A global StateBag change handler monitors all state modifications and blocks unauthorized changes:

```lua
AddStateBagChangeHandler(nil, nil, function(bagName, key, value, reserved, replicated)
    if not reserved then
        -- Check if key is whitelisted for client modification
        if not ALLOWED_CLIENT_KEYS[key] then
            -- Log exploit attempt and optionally kick player
        end
    end
end)
```

### Whitelisted Keys
Only benign animation and state keys are allowed to be modified by clients:
- `Animation`
- `IsSwimming`
- `IsDiving`
- `IsJumping`
- `IsFalling`
- `IsClimbing`
- `IsRagdoll`

### Adding New Whitelisted Keys
Edit the `ALLOWED_CLIENT_KEYS` table in `_statebag_protection.lua`:

```lua
local ALLOWED_CLIENT_KEYS = {
    ["Animation"] = true,
    ["YourNewKey"] = true,
}
```

⚠️ **Warning**: Only whitelist keys that are purely cosmetic or non-sensitive. Never whitelist financial, inventory, or authorization keys.

---

## Transaction Security

### Overview
Financial transactions (cash/bank operations) are protected with:
1. **Rate Limiting**: Prevents rapid transaction spam
2. **Transaction Logging**: Creates audit trail for all financial operations
3. **Fraud Detection**: Monitors for suspicious transaction patterns

### Implementation
**File**: `server/[Security]/_transaction_security.lua`

### Rate Limiting
Each transaction type has a 1-second cooldown per player:

```lua
if ig.security.CheckRateLimit(self.ID, "add_cash") then
    self.Notify("Transaction too fast. Please wait.")
    return
end
```

Protected functions:
- `SetCash`, `AddCash`, `RemoveCash`
- `SetBank`, `AddBank`, `RemoveBank`

### Transaction Logging
All financial transactions are logged with:
- Timestamp
- Player ID and Character ID
- Transaction type
- Amount
- Reason
- Before/After balances

Logs are sent to the `txaLogger:LogTransaction` event for external logging systems.

### Fraud Detection
The system monitors for suspicious patterns:
- **Threshold**: More than 20 transactions in 60 seconds
- **Action**: Triggers `txaLogger:FraudAlert` event

Customize thresholds in `_transaction_security.lua`:

```lua
-- Change detection threshold
if #history.actions > 20 then  -- Modify this value
    -- Alert triggered
end
```

### Integrating with Your Logging System
Add event handlers to process security events:

```lua
-- In your logging resource
AddEventHandler("txaLogger:LogTransaction", function(log)
    -- Store log to database
    MySQL.Async.execute("INSERT INTO transaction_logs (...) VALUES (...)", {
        timestamp = log.timestamp,
        player_id = log.player_id,
        type = log.type,
        amount = log.amount
    })
end)

AddEventHandler("txaLogger:SecurityAlert", function(alert)
    -- Send Discord notification or ban player
    if alert.type == "statebag_exploit" then
        DropPlayer(alert.player, "Security violation detected")
    end
end)

AddEventHandler("txaLogger:FraudAlert", function(alert)
    -- Notify admins of suspicious activity
    print(("^1[FRAUD] Player %s: %d transactions in 60s^7"):format(
        alert.player, alert.count
    ))
end)
```

---

## Authorization Best Practices

### Never Trust Client State for Authorization

❌ **WRONG**:
```lua
-- BAD: Uses state bag which can be modified by client
self.CheckKeys = function(id)
    for k, v in pairs(self.State.Keys) do  -- DON'T DO THIS
        if v == id then return true end
    end
    return false
end
```

✅ **CORRECT**:
```lua
-- GOOD: Uses server-side memory
self.CheckKeys = function(id)
    for k, v in pairs(self.Keys) do  -- Server-side data only
        if v == id then return true end
    end
    return false
end
```

### Guidelines
1. **Always use `self.Property`** for authorization checks
2. **Only use `self.State.Property`** for syncing data to clients for display purposes
3. **Never trust `Entity(...).state` values** from client events
4. **Validate all inputs** from client events before processing

### Display vs. Source of Truth
| Property Type | Purpose | Client Access |
|--------------|---------|---------------|
| `self.Property` | Server source of truth | ❌ No |
| `self.State.Property` | Display only | ✅ Read-only |

---

## Input Validation

### Range Clamping
All bounded numeric properties are automatically clamped to their valid ranges using `ig.check.Number(value, min, max)`.

**File**: `shared/[Tools]/_check.lua`

The function now uses explicit clamping instead of returning 0 for out-of-range values:

```lua
function ig.check.Number(num, min, max)
    if min and max then
        -- Explicit clamping: ensure value is within min-max range
        return math.max(min, math.min(max, num))
    end
    return num
end
```

### Protected Properties
The following properties are automatically clamped:

**Player**:
- `Health`: 0 to `conf.defaulthealth`
- `Armour`: 0 to `conf.defaultarmour`
- `Hunger`: 0 to 100
- `Thirst`: 0 to 100
- `Stress`: 0 to 100

**Vehicle**:
- `Fuel`: 0 to 100

### Adding New Bounded Properties
Use `ig.check.Number` with min/max parameters:

```lua
self.SetCustomStat = function(v)
    local num = ig.check.Number(v, 0, 100)  -- Automatically clamped to 0-100
    self.CustomStat = num
    self.State.CustomStat = num
end
```

---

## Testing Your Implementation

### StateBag Protection Test
From client console:
```lua
-- Should trigger security alert
Entity(PlayerPedId()).state.Cash = 999999
Entity(PlayerPedId()).state.Keys = {"all_keys"}
```

Expected result: Console shows `[SECURITY] Player X attempted to modify protected state bag key`

### Rate Limiting Test
Execute rapidly:
```lua
-- Server side
for i = 1, 25 do
    xPlayer.AddCash(100)
end
```

Expected result: After 1 second, rate limit triggers

### Range Validation Test
```lua
-- Server side
xPlayer.SetFuel(150)   -- Should clamp to 100
xPlayer.SetFuel(-50)   -- Should clamp to 0
xPlayer.SetHealth(9999) -- Should clamp to conf.defaulthealth
```

---

## Maintenance

### Regular Security Audits
1. Review transaction logs weekly for anomalies
2. Monitor fraud alerts
3. Update whitelisted StateBag keys as needed
4. Review and adjust rate limit thresholds based on legitimate usage patterns

### Version Updates
When updating ingenium:
1. Check if new state bag keys are added
2. Verify new numeric properties use `ig.check.Number` with appropriate bounds
3. Add transaction logging to any new financial operations
4. Update this documentation

---

## Common Vulnerabilities and Mitigations

| Vulnerability | Risk | Mitigation |
|--------------|------|------------|
| StateBag modification | 🔴 Critical | Global handler with whitelist |
| Unauthorized vehicle access | 🟠 Medium | Server-side key checks |
| Cash/Bank manipulation | 🟠 Medium | Negative checks + rate limiting |
| Transaction flooding | 🟠 Medium | Rate limiting + fraud detection |
| Out-of-range values | 🟡 Low | Explicit clamping |

---

## Support

For security concerns or questions:
1. Review this documentation
2. Check the implementation in `server/[Security]/*.lua`
3. Test using the provided test cases
4. Report security issues privately to the development team

---

**Last Updated**: 2025-12-14  
**Version**: 0.9.0  
**Author**: ingenium Security Team
