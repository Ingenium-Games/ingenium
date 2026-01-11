# ig.tattoo.GetByHash

## Description

Retrieves and returns byhash data

## Signature

```lua
function ig.tattoo.GetByHash(hash)
```

## Parameters

- **`hash`**: string

## Example

```lua
-- Get byhash data
local result = ig.tattoo.GetByHash("hash")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_tattoo.lua`
