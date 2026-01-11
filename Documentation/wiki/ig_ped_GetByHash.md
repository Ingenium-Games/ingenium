# ig.ped.GetByHash

## Description

Retrieves and returns byhash data

## Signature

```lua
function ig.ped.GetByHash(hash)
```

## Parameters

- **`hash`**: string

## Example

```lua
-- Get byhash data
local result = ig.ped.GetByHash("hash")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_peds.lua`
