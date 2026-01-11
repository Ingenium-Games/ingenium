# ig.game.GetGameModeSettings

## Description

Retrieves and returns gamemodesettings data

## Signature

```lua
function ig.game.GetGameModeSettings(mode)
```

## Parameters

- **`mode`**: number

## Example

```lua
-- Get gamemodesettings data
local result = ig.game.GetGameModeSettings(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `shared/[Tools]/_gamemode.lua`
