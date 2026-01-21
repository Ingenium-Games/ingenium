# ig.phone.GetSettings

## Description

Retrieves the settings for a phone.

## Signature

```lua
function ig.phone.GetSettings(imei)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier

## Returns

- **`table`** - Phone settings object containing configuration like planeMode, emergencyAlerts, etc.

## Example

```lua
-- Get phone settings
local settings = ig.phone.GetSettings("123456789")
print("Plane mode:", settings.planeMode)
print("Emergency alerts:", settings.emergencyAlerts)
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
