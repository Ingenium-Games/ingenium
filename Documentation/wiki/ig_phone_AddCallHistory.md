# ig.phone.AddCallHistory

## Description

Adds a new call entry to the phone's call history.

## Signature

```lua
function ig.phone.AddCallHistory(imei, call)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier
- **`call`**: table - Call entry object with fields:
  - **`id`**: string - Unique call ID
  - **`number`**: string - Phone number
  - **`type`**: string - Call type ("incoming", "outgoing", "missed")
  - **`duration`**: number - Call duration in seconds
  - **`timestamp`**: number - Unix timestamp of the call

## Returns

None

## Example

```lua
-- Add a call to history
ig.phone.AddCallHistory("123456789", {
    id = ig.rng.UUID(),
    number = "555-1234",
    type = "outgoing",
    duration = 120,
    timestamp = os.time()
})
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
