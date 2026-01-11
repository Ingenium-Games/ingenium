# ig.weapon.GetDisplayName

## Description

Retrieves and returns displayname data

## Signature

```lua
function ig.weapon.GetDisplayName(hash)
```

## Parameters

- **`hash`**: string

## Example

```lua
-- Get displayname data
local result = ig.weapon.GetDisplayName("hash")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/[Data]/_game_data_helpers.lua`
