# ig.discord.HasRole

## Description

Checks if a player has a specific Discord role.

## Signature

```lua
function ig.discord.HasRole(src, roleId, callback)
```

## Parameters

- **`src`**: number - The player source ID
- **`roleId`**: string - The Discord role ID to check
- **`callback`**: function - Callback function called with `(hasRole, roles)` parameters

## Returns

None (result provided via callback)

## Example

```lua
-- Check if player has a specific role
ig.discord.HasRole(source, "123456789", function(hasRole, allRoles)
    if hasRole then
        print("Player has the specified role")
    else
        print("Player does not have the role")
    end
end)
```

## Source

Defined in: `server/[Third Party]/_discord.lua`
