# ig.sql.user.GetBanReason

## Description

Retrieves and returns banreason data

## Signature

```lua
function ig.sql.user.GetBanReason(license_id, cb)
```

## Parameters

- **`license_id`**: any
- **`cb`**: function

## Example

```lua
-- Get banreason data
local result = ig.sql.user.GetBanReason(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_users.lua`
