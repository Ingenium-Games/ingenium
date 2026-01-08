# ig.security.AddAllowedStateBagKey

## Description

Add a key to the allowed client keys whitelist. This allows clients to modify the specified StateBag key without triggering security alerts. Use this function to dynamically extend StateBag protection for custom keys that are safe for clients to modify.

## Signature

```lua
function ig.security.AddAllowedStateBagKey(key)
```

## Parameters

- **`key`**: string The state bag key to allow clients to modify

## Returns

- **`success`**: boolean True if the key was added successfully, false otherwise

## Example

```lua
-- Add a custom animation key to the allowed list
local success = ig.security.AddAllowedStateBagKey("CustomAnimation")

if success then
    print("Key added successfully")
end

-- Add multiple custom keys
local customKeys = {"PlayerEmote", "CustomState", "PlayerMood"}
for _, key in ipairs(customKeys) do
    ig.security.AddAllowedStateBagKey(key)
end
```

## Warning

⚠️ Only whitelist keys that are purely cosmetic or non-sensitive. Never whitelist financial, inventory, or authorization keys.

## Related Functions

- [ig.security.RemoveAllowedStateBagKey](ig_security_RemoveAllowedStateBagKey.md)
- [ig.security.AddBlockedStateBagKey](ig_security_AddBlockedStateBagKey.md)
- [ig.security.RemoveBlockedStateBagKey](ig_security_RemoveBlockedStateBagKey.md)
- [ig.security.GetAllowedStateBagKeys](ig_security_GetAllowedStateBagKeys.md)
- [ig.security.GetBlockedStateBagKeys](ig_security_GetBlockedStateBagKeys.md)

## Source

Defined in: `server/[Security]/_statebag_protection.lua`
