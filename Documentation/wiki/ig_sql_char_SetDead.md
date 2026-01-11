# ig.sql.char.SetDead

## Description

Get - The `Active` = TRUE `Character_ID` from the Primary_ID identifier

## Signature

```lua
function ig.sql.char.SetDead(character_id, bool, data, cb)
```

## Parameters

- **`character_id`**: any
- **`bool`**: any
- **`data`**: table
- **`cb`**: function

## Example

```lua
-- Set dead
ig.sql.char.SetDead(value, value, {}, function() end)
```

## Source

Defined in: `server/[SQL]/_character.lua`
