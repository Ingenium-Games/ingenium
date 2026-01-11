# ig.sql.user.Add

## Description

Adds  to the system

## Signature

```lua
function ig.sql.user.Add(usermame, license_id, fivem_id, steam_id, discord_id, ip, cb)
```

## Parameters

- **`usermame`**: any
- **`license_id`**: any
- **`fivem_id`**: any
- **`steam_id`**: any
- **`discord_id`**: any
- **`ip`**: any
- **`cb`**: function

## Example

```lua
-- Example usage
local result = ig.sql.user.Add(value, value, value, value, value, value, function() end)
```

## Source

Defined in: `server/[SQL]/_users.lua`
