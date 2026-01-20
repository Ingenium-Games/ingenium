# ig.phone.EmergencyAlertsEnabled

## Description

Checks if emergency alerts are enabled in the phone's settings.

## Signature

```lua
function ig.phone.EmergencyAlertsEnabled(imei)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier

## Returns

- **`boolean`** - `true` if emergency alerts are enabled, `false` otherwise

## Example

```lua
-- Check if emergency alerts are enabled
local alertsEnabled = ig.phone.EmergencyAlertsEnabled("123456789")
if alertsEnabled then
    -- Send emergency notification
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
