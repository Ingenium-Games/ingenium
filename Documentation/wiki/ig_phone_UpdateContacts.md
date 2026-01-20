# ig.phone.UpdateContacts

## Description

Updates the entire contact list for a phone.

## Signature

```lua
function ig.phone.UpdateContacts(imei, contacts)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier
- **`contacts`**: table - Array of contact entries

## Returns

None

## Example

```lua
-- Update entire contact list
ig.phone.UpdateContacts("123456789", {
    { name = "John Doe", number = "555-1234" },
    { name = "Jane Smith", number = "555-5678" }
})
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
