# ig.phone.DeleteCallHistory

## Description

Deletes a specific call entry from the phone's call history.

## Signature

```lua
function ig.phone.DeleteCallHistory(imei, callId)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier
- **`callId`**: string - The ID of the call to delete

## Returns

None

## Example

```lua
-- Delete a call from history
ig.phone.DeleteCallHistory("123456789", "call-uuid-123")
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
