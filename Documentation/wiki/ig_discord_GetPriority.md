# ig.discord.GetPriority

## Description

Calculates a player's queue priority power based on their Discord roles. Higher priority values indicate higher queue position.

## Signature

```lua
function ig.discord.GetPriority(src)
```

## Parameters

- **`src`**: number - The player source ID

## Returns

- **`number`** - Priority power value (0 if no matching roles found)

## Example

```lua
-- Get player's priority for queue management
local priority = ig.discord.GetPriority(source)
print("Player priority:", priority)
```

## Source

Defined in: `server/[Third Party]/_discord.lua`
