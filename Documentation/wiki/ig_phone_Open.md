# ig.phone.Open

## Description

Opens the phone UI and displays the phone prop in the player's hand with animation.

## Signature

```lua
function ig.phone.Open(phoneData)
```

## Parameters

- **`phoneData`**: table - Phone data object containing phone information

## Returns

None

## Example

```lua
-- Open the phone UI
ig.phone.Open({
    phoneNumber = "555-1234",
    imei = "123456789",
    contacts = {},
    settings = {}
})
```

## Source

Defined in: `client/_phone.lua`
