# ig.phone.GetContacts

## Description

Retrieves the contact list for a phone.

## Signature

```lua
function ig.phone.GetContacts(imei)
```

## Parameters

- **`imei`**: string - The phone's IMEI identifier

## Returns

- **`table`** - Array of contact entries

## Example

```lua
-- Get contacts
local contacts = ig.phone.GetContacts("123456789")
for _, contact in ipairs(contacts) do
    print("Contact:", contact.name, contact.number)
end
```

## Source

Defined in: `server/[Data - No Save Needed]/_phone.lua`
