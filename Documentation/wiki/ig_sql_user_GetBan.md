# ig.sql.user.GetBan

## Description

Get - `Ace` from the users License_ID identifier

## Signature

```lua
function ig.sql.user.GetBan(license_id, cb)
```

## Parameters

- **`license_id`**: any
- **`cb`**: function

## Example

```lua
-- Get ban data
local result = ig.sql.user.GetBan(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_users.lua`
