# ig.discord.HasAnyRole

## Description

Checks if a player has any of the specified Discord roles.

## Signature

```lua
function ig.discord.HasAnyRole(src, roles, callback)
```

## Parameters

- **`src`**: number - The player source ID
- **`roles`**: table - Array of Discord role IDs to check
- **`callback`**: function - Callback function called with `(hasAnyRole, matchedRoles)` parameters

## Returns

None (result provided via callback)

## Example

```lua
-- Check if player has any admin roles
local adminRoles = {"123456789", "987654321"}
ig.discord.HasAnyRole(source, adminRoles, function(hasRole, matched)
    if hasRole then
        print("Player has admin role:", matched[1])
    else
        print("Player does not have any admin roles")
    end
end)
```

## Source

Defined in: `server/[Third Party]/_discord.lua`
