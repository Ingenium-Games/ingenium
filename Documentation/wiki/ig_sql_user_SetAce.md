# ig.sql.user.SetAce

## Description

Set - Prefered locale or `Locale` for the users License_ID

## Signature

```lua
function ig.sql.user.SetAce(ace, license_id, cb)
```

## Parameters

- **`ace`**: string
- **`license_id`**: any
- **`cb`**: function

## Example

```lua
-- Set ace
ig.sql.user.SetAce("ace", value, function() end)
```

## Source

Defined in: `server/[SQL]/_users.lua`
