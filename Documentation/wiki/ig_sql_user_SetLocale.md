# ig.sql.user.SetLocale

## Description

Get - `Locale` from the users License_ID

## Signature

```lua
function ig.sql.user.SetLocale(locale, license_id, cb)
```

## Parameters

- **`locale`**: string
- **`license_id`**: any
- **`cb`**: function

## Example

```lua
-- Set locale
ig.sql.user.SetLocale("locale", value, function() end)
```

## Source

Defined in: `server/[SQL]/_users.lua`
