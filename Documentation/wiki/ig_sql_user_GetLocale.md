# ig.sql.user.GetLocale

## Description

Get - The entire ROW of data from Characters table where the Character_ID is the character id.

## Signature

```lua
function ig.sql.user.GetLocale(license_id, cb)
```

## Parameters

- **`license_id`**: any
- **`cb`**: function

## Example

```lua
-- Get locale data
local result = ig.sql.user.GetLocale(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_users.lua`
