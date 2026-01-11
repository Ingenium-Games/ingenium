# ig.sql.char.Delete

## Description

Get - The entire ROW of data from Characters table where the Character_ID is the character id.

## Signature

```lua
function ig.sql.char.Delete(character_id, cb)
```

## Parameters

- **`character_id`**: any
- **`cb`**: function

## Example

```lua
-- Example usage
local result = ig.sql.char.Delete(value, function() end)
```

## Source

Defined in: `server/[SQL]/_character.lua`
