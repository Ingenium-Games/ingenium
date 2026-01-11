# ig.sql.char.SetInstance

## Description

Get - The `Active` = TRUE `Character_ID` from the Primary_ID identifier

## Signature

```lua
function ig.sql.char.SetInstance(character_id, instance_id, cb)
```

## Parameters

- **`character_id`**: any
- **`instance_id`**: any
- **`cb`**: function

## Example

```lua
-- Set instance
ig.sql.char.SetInstance(value, value, function() end)
```

## Source

Defined in: `server/[SQL]/_character.lua`
