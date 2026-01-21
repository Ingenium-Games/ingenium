# ig.phone.RemoveContact

## Description

Removes a contact from the phone's contact list.

## Signature

```lua
function ig.phone.RemoveContact(imei, contactId)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier
- **`contactId`**: string - The ID of the contact to remove

## Returns

None

## Example

```lua
-- Remove a contact
ig.phone.RemoveContact("123456789", "contact-uuid-123")
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
