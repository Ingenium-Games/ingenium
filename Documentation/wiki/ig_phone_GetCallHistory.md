# ig.phone.GetCallHistory

## Description

Retrieves the call history for a phone.

## Signature

```lua
function ig.phone.GetCallHistory(imei)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier

## Returns

- **`table`** - Array of call history entries

## Example

```lua
-- Get call history
local history = ig.phone.GetCallHistory("123456789")
for _, call in ipairs(history) do
    print("Call:", call.number, call.type, call.duration)
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
