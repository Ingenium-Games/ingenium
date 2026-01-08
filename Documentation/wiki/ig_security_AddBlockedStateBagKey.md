# ig.security.AddBlockedStateBagKey

## Description

Add a key to the blocked client keys blacklist. This explicitly prevents clients from modifying the specified StateBag key and triggers critical security alerts if they attempt to do so. Blocked keys provide defense-in-depth protection for sensitive data.

## Signature

```lua
function ig.security.AddBlockedStateBagKey(key)
```

## Parameters

- **`key`**: string The state bag key to block clients from modifying

## Returns

- **`success`**: boolean True if the key was added successfully, false otherwise

## Example

```lua
-- Add a sensitive custom key to the blocked list
local success = ig.security.AddBlockedStateBagKey("CustomCurrency")

if success then
    print("Key blocked successfully")
end

-- Block multiple sensitive keys
local sensitiveKeys = {"AdminLevel", "Permissions", "CustomInventory"}
for _, key in ipairs(sensitiveKeys) do
    ig.security.AddBlockedStateBagKey(key)
end
```

## Warning

⚠️ Keys in the blocked list trigger CRITICAL security alerts. Only block keys that should NEVER be modified by clients under any circumstances.

## Related Functions

- [ig.security.RemoveBlockedStateBagKey](ig_security_RemoveBlockedStateBagKey.md)
- [ig.security.AddAllowedStateBagKey](ig_security_AddAllowedStateBagKey.md)
- [ig.security.RemoveAllowedStateBagKey](ig_security_RemoveAllowedStateBagKey.md)
- [ig.security.GetAllowedStateBagKeys](ig_security_GetAllowedStateBagKeys.md)
- [ig.security.GetBlockedStateBagKeys](ig_security_GetBlockedStateBagKeys.md)

## Source

Defined in: `server/[Security]/_statebag_protection.lua`
