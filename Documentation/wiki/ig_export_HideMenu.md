# Export: HideMenu()

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [C]

## Description

Close the currently open menu.

## Usage

```lua
exports["ingenium"]:HideMenu()
```

## Examples

```lua
-- Open a menu
exports["ingenium"]:ShowMenu({
    title = "Test Menu",
    options = {
        {label = "Option 1", action = "opt1"},
        {label = "Close", action = "close"}
    }
})

-- Close it
exports["ingenium"]:HideMenu()
```

## See Also

- [ShowMenu](ig_export_ShowMenu.md) - Display menu
