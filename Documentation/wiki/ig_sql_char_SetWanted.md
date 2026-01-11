# ig.sql.char.SetWanted

## Description

SET - The `Instance` = instance_id for the `Character_ID`

## Signature

```lua
function ig.sql.char.SetWanted(character_id, bool, cb)
```

## Parameters

- **`character_id`**: any
- **`bool`**: any
- **`cb`**: function

## Example

```lua
-- Set wanted
ig.sql.char.SetWanted(value, value, function() end)
```

## Source

Defined in: `server/[SQL]/_character.lua`
