# ig.sql.user.GetAce

## Description

Get - `Locale` from the users License_ID

## Signature

```lua
function ig.sql.user.GetAce(license_id, cb)
```

## Parameters

- **`license_id`**: any
- **`cb`**: function

## Example

```lua
-- Get ace data
local result = ig.sql.user.GetAce(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_users.lua`
