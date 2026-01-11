# ig.pick.GetByEvent

## Description

Retrieves and returns byevent data

## Signature

```lua
function ig.pick.GetByEvent(eventName)
```

## Parameters

- **`eventName`**: any

## Example

```lua
-- Get byevent data
local result = ig.pick.GetByEvent(value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
