# ig.phone.IsPlaneMode

## Description

Checks if plane mode is enabled in the phone's settings.

## Signature

```lua
function ig.phone.IsPlaneMode(imei)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier

## Returns

- **`boolean`** - `true` if plane mode is enabled, `false` otherwise

## Example

```lua
-- Check if plane mode is enabled
local isPlane = ig.phone.IsPlaneMode("123456789")
if isPlane then
    print("Phone is in plane mode, cannot receive calls")
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
