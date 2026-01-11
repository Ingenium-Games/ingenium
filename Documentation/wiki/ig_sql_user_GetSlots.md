# ig.sql.user.GetSlots

## Description

Get - `Priority` from the users License_ID identifier

## Signature

```lua
function ig.sql.user.GetSlots(license_id, cb)
```

## Parameters

- **`license_id`**: any
- **`cb`**: function

## Example

```lua
-- Get slots data
local result = ig.sql.user.GetSlots(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_users.lua`
