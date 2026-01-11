# ig.sql.user.SetPriority

## Description

Get/Set - `Ban` = bool from the users License_ID identifier

## Signature

```lua
function ig.sql.user.SetPriority(fivem_id, bool, cb)
```

## Parameters

- **`fivem_id`**: any
- **`bool`**: string
- **`cb`**: function

## Example

```lua
-- Set priority
ig.sql.user.SetPriority(value, "bool", function() end)
```

## Source

Defined in: `server/[SQL]/_users.lua`
