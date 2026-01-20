# ig.discord.HasMemberRole

## Description

Checks if a player has the configured member role from the Discord settings.

## Signature

```lua
function ig.discord.HasMemberRole(src, callback)
```

## Parameters

- **`src`**: number - The player source ID
- **`callback`**: function - Callback function called with `(hasMemberRole)` boolean parameter

## Returns

None (result provided via callback)

## Example

```lua
-- Check if player has member role
ig.discord.HasMemberRole(source, function(hasMember)
    if hasMember then
        print("Player is a verified member")
    else
        print("Player is not a verified member")
    end
end)
```

## Source

Defined in: `server/[Third Party]/_discord.lua`
