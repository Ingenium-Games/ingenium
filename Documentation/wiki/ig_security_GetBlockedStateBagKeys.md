# ig.security.GetBlockedStateBagKeys

## Description

Get all blocked StateBag keys. Returns a table containing all keys that are explicitly blocked from client modification. Useful for debugging, auditing, or displaying current security configuration.

## Signature

```lua
function ig.security.GetBlockedStateBagKeys()
```

## Parameters

None

## Returns

- **`blockedKeys`**: table Table of blocked keys in key = true format

## Example

```lua
-- Get all blocked keys
local blocked = ig.security.GetBlockedStateBagKeys()

-- Print all blocked keys
for key, _ in pairs(blocked) do
    print("Blocked key:", key)
end

-- Check if a specific key is blocked
if blocked["Cash"] then
    print("Cash is blocked (good!)")
end

-- Count blocked keys
local count = 0
for _ in pairs(blocked) do
    count = count + 1
end
print("Total blocked keys:", count)

-- Audit security configuration
local function auditSecurity()
    local allowed = ig.security.GetAllowedStateBagKeys()
    local blocked = ig.security.GetBlockedStateBagKeys()
    
    print("=== StateBag Security Audit ===")
    print("Allowed keys:", table.concat(ig.table.MatchKey(allowed), ", "))
    print("Blocked keys:", table.concat(ig.table.MatchKey(blocked), ", "))
end
```

## Related Functions

- [ig.security.GetAllowedStateBagKeys](ig_security_GetAllowedStateBagKeys.md)
- [ig.security.AddBlockedStateBagKey](ig_security_AddBlockedStateBagKey.md)
- [ig.security.RemoveBlockedStateBagKey](ig_security_RemoveBlockedStateBagKey.md)
- [ig.security.AddAllowedStateBagKey](ig_security_AddAllowedStateBagKey.md)
- [ig.security.RemoveAllowedStateBagKey](ig_security_RemoveAllowedStateBagKey.md)

## Source

Defined in: `server/[Security]/_statebag_protection.lua`
