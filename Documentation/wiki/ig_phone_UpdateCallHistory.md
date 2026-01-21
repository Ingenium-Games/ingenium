# ig.phone.UpdateCallHistory

## Description

Updates the entire call history for a phone.

## Signature

```lua
function ig.phone.UpdateCallHistory(imei, callHistory)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier
- **`callHistory`**: table - Array of call history entries

## Returns

None

## Example

```lua
-- Update call history
ig.phone.UpdateCallHistory("123456789", {
    { id = "1", number = "555-1234", type = "incoming", duration = 60 },
    { id = "2", number = "555-5678", type = "outgoing", duration = 120 }
})
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
