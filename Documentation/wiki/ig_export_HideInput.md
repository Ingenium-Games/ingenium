# Export: HideInput()

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [C]

## Description

Close the input dialog.

## Usage

```lua
exports["ingenium"]:HideInput()
```

## Examples

```lua
-- Open input
exports["ingenium"]:ShowInput({
    title = "Enter name",
    placeholder = "Enter here",
    max = 50
})

-- Close it
exports["ingenium"]:HideInput()
```

## See Also

- [ShowInput](ig_export_ShowInput.md) - Display input dialog
