# ig.phone.UpdateSettings

## Description

Updates the settings for a phone.

## Signature

```lua
function ig.phone.UpdateSettings(imei, settings)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier
- **`settings`**: table - Settings object with configuration fields (planeMode, emergencyAlerts, etc.)

## Returns

None

## Example

```lua
-- Update phone settings
ig.phone.UpdateSettings("123456789", {
    planeMode = true,
    emergencyAlerts = false,
    ringtone = "default"
})
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
