# ig.sql.char.GetFromPhone

## Description

Should the Server crash, reset all Active Characters (for safety)

## Signature

```lua
function ig.sql.char.GetFromPhone(phone, cb)
```

## Parameters

- **`phone`**: any
- **`cb`**: function

## Example

```lua
-- Get fromphone data
local result = ig.sql.char.GetFromPhone(value, function() end)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[SQL]/_character.lua`
