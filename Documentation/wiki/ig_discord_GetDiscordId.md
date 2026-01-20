# ig.discord.GetDiscordId

## Description

Retrieves the Discord ID for a player from their identifiers.

## Signature

```lua
function ig.discord.GetDiscordId(src)
```

## Parameters

- **`src`**: number - The player source ID

## Returns

- **`string|nil`** - Discord ID with "discord:" prefix if found, `nil` otherwise

## Example

```lua
-- Get Discord ID for a player
local discordId = ig.discord.GetDiscordId(source)
if discordId then
    print("Player's Discord ID:", discordId)
else
    print("Player does not have Discord connected")
end
```

## Source

Defined in: `server/[Third Party]/_discord.lua`
