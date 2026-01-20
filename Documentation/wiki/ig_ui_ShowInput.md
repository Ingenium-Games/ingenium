# ig.ui.ShowInput

## Description

Displays an input dialog with the provided configuration.

## Signature

```lua
function ig.ui.ShowInput(data)
```

## Parameters

- **`data`**: table - Input dialog configuration object

## Returns

None

## Example

```lua
-- Show an input dialog
ig.ui.ShowInput({
    title = "Enter Name",
    placeholder = "Your name here...",
    maxLength = 50
})
```

## Source

Defined in: `client/_ui.lua`
