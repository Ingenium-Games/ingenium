# ig.security.RemoveBlockedStateBagKey

## Description

Remove a key from the blocked client keys blacklist. This allows the key to be processed by the normal whitelist system instead of being explicitly blocked. Use with caution, as this reduces defense-in-depth protection.

## Signature

```lua
function ig.security.RemoveBlockedStateBagKey(key)
```

## Parameters

- **`key`**: string The state bag key to remove from blocked list

## Returns

- **`success`**: boolean True if the key was removed successfully, false otherwise

## Example

```lua
-- Remove a key from the blocked list
local success = ig.security.RemoveBlockedStateBagKey("CustomCurrency")

if success then
    print("Key unblocked successfully")
end

-- Remove multiple keys
local keysToUnblock = {"TempBlockedKey1", "TempBlockedKey2"}
for _, key in ipairs(keysToUnblock) do
    ig.security.RemoveBlockedStateBagKey(key)
end
```

## Warning

⚠️ Removing a key from the blocked list does NOT automatically allow client modifications. The key must also be added to the allowed list via `ig.security.AddAllowedStateBagKey()`.

## Related Functions

- [ig.security.AddBlockedStateBagKey](ig_security_AddBlockedStateBagKey.md)
- [ig.security.AddAllowedStateBagKey](ig_security_AddAllowedStateBagKey.md)
- [ig.security.RemoveAllowedStateBagKey](ig_security_RemoveAllowedStateBagKey.md)
- [ig.security.GetAllowedStateBagKeys](ig_security_GetAllowedStateBagKeys.md)
- [ig.security.GetBlockedStateBagKeys](ig_security_GetBlockedStateBagKeys.md)

## Source

Defined in: `server/[Security]/_statebag_protection.lua`
