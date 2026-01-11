# ig.ped.GetDisplayName

## Description

Retrieves and returns displayname data

## Signature

```lua
function ig.ped.GetDisplayName(hash)
```

## Parameters

- **`hash`**: number

## Example

```lua
-- Get displayname data
local result = ig.ped.GetDisplayName(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_peds.lua`
