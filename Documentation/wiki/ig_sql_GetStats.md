# ig.sql.GetStats

## Description

Retrieves and returns stats data

## Signature

```lua
function ig.sql.GetStats()
```

## Parameters

*No parameters*

## Example

```lua
-- Get stats data
local result = ig.sql.GetStats()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_handler.lua`
