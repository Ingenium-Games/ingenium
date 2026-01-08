# ig.security.RemoveAllowedStateBagKey

## Description

Remove a key from the allowed client keys whitelist. This prevents clients from modifying the specified StateBag key, causing security alerts if they attempt to do so. Use this function to dynamically revoke client access to previously allowed StateBag keys.

## Signature

```lua
function ig.security.RemoveAllowedStateBagKey(key)
```

## Parameters

- **`key`**: string The state bag key to remove from allowed list

## Returns

- **`success`**: boolean True if the key was removed successfully, false otherwise

## Example

```lua
-- Remove a custom key from the allowed list
local success = ig.security.RemoveAllowedStateBagKey("CustomAnimation")

if success then
    print("Key removed successfully")
end

-- Remove multiple keys
local keysToRemove = {"PlayerEmote", "CustomState"}
for _, key in ipairs(keysToRemove) do
    ig.security.RemoveAllowedStateBagKey(key)
end
```

## Related Functions

- [ig.security.AddAllowedStateBagKey](ig_security_AddAllowedStateBagKey.md)
- [ig.security.AddBlockedStateBagKey](ig_security_AddBlockedStateBagKey.md)
- [ig.security.RemoveBlockedStateBagKey](ig_security_RemoveBlockedStateBagKey.md)
- [ig.security.GetAllowedStateBagKeys](ig_security_GetAllowedStateBagKeys.md)
- [ig.security.GetBlockedStateBagKeys](ig_security_GetBlockedStateBagKeys.md)

## Source

Defined in: `server/[Security]/_statebag_protection.lua`
