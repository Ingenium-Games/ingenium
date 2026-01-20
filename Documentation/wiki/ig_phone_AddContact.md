# ig.phone.AddContact

## Description

Adds a new contact to the phone's contact list.

## Signature

```lua
function ig.phone.AddContact(imei, contact)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier
- **`contact`**: table - Contact object with fields:
  - **`name`**: string - Contact name
  - **`number`**: string - Phone number
  - **`type`**: string (optional) - Contact type
  - **`email`**: string (optional) - Email address

## Returns

None

## Example

```lua
-- Add a new contact
ig.phone.AddContact("123456789", {
    name = "John Doe",
    number = "555-1234",
    type = "friend",
    email = "john@example.com"
})
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
