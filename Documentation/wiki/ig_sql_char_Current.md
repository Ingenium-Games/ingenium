# ig.sql.char.Current

## Description

Get - The entire ROW of data from Characters table where the Character_ID is the character id.

## Signature

```lua
function ig.sql.char.Current(primary_id, cb)
```

## Parameters

- **`primary_id`**: any
- **`cb`**: function

## Example

```lua
-- Example usage
local result = ig.sql.char.Current(value, function() end)
```

## Source

Defined in: `server/[SQL]/_character.lua`
