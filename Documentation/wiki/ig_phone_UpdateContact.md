# ig.phone.UpdateContact

## Description

Updates a specific contact in the phone's contact list.

## Signature

```lua
function ig.phone.UpdateContact(imei, contactId, updatedContact)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier
- **`contactId`**: string - The ID of the contact to update
- **`updatedContact`**: table - Updated contact object with fields (name, number, type, email)

## Returns

None

## Example

```lua
-- Update a contact
ig.phone.UpdateContact("123456789", "contact-uuid-123", {
    name = "Jane Doe",
    number = "555-9999",
    type = "family",
    email = "jane@example.com"
})
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
