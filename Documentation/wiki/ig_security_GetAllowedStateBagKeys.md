# ig.security.GetAllowedStateBagKeys

## Description

Get all allowed StateBag keys. Returns a table containing all keys that clients are permitted to modify. Useful for debugging, auditing, or displaying current security configuration.

## Signature

```lua
function ig.security.GetAllowedStateBagKeys()
```

## Parameters

None

## Returns

- **`allowedKeys`**: table Table of allowed keys in key = true format

## Example

```lua
-- Get all allowed keys
local allowed = ig.security.GetAllowedStateBagKeys()

-- Print all allowed keys
for key, _ in pairs(allowed) do
    print("Allowed key:", key)
end

-- Check if a specific key is allowed
if allowed["Animation"] then
    print("Animation is allowed")
end

-- Count allowed keys
local count = 0
for _ in pairs(allowed) do
    count = count + 1
end
print("Total allowed keys:", count)
```

## Related Functions

- [ig.security.GetBlockedStateBagKeys](ig_security_GetBlockedStateBagKeys.md)
- [ig.security.AddAllowedStateBagKey](ig_security_AddAllowedStateBagKey.md)
- [ig.security.RemoveAllowedStateBagKey](ig_security_RemoveAllowedStateBagKey.md)
- [ig.security.AddBlockedStateBagKey](ig_security_AddBlockedStateBagKey.md)
- [ig.security.RemoveBlockedStateBagKey](ig_security_RemoveBlockedStateBagKey.md)

## Source

Defined in: `server/[Security]/_statebag_protection.lua`
