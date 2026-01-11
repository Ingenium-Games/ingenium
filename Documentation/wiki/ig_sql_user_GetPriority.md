# ig.sql.user.GetPriority

## Description

Get - `Ban` from the users License_ID identifier

## Signature

```lua
function ig.sql.user.GetPriority(license_id, cb)
```

## Parameters

- **`license_id`**: any
- **`cb`**: function

## Example

```lua
-- Get priority data
local result = ig.sql.user.GetPriority(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_users.lua`
