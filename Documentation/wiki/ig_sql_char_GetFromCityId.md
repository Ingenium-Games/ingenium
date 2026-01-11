# ig.sql.char.GetFromCityId

## Description

Get - The `Character_ID` by phone number

## Signature

```lua
function ig.sql.char.GetFromCityId(city_id, cb)
```

## Parameters

- **`city_id`**: any
- **`cb`**: function

## Example

```lua
-- Get fromcityid data
local result = ig.sql.char.GetFromCityId(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
