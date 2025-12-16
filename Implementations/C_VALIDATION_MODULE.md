# c.validation Module - Unified Validation Architecture

## Overview

Per user request, all inventory validation has been merged into a single `c.validation` global table structure with a unified validation function as the single point of failure for easier debugging.

## Architecture

### Module Structure

```lua
c.validation = {
    -- Core Functions
    GetItemQuantities(inventory)              -- Calculate item totals
    IsValidItem(itemName)                     -- Check item exists in database
    ValidateSlot(slot, index)                 -- Comprehensive slot validation
    ValidateInventory(inventory)              -- Validate all slots
    ValidateInventoryIntegrity(...)           -- Prevent duplication/injection
    LogAndBanExploiter(source, reason)        -- Security action
    
    -- SINGLE POINT OF FAILURE
    ValidateAndUnpack(source, inventory)      -- Unified validation & processing
    
    -- Backward Compatibility
    HandleExploit                             -- Alias for LogAndBanExploiter
}
```

## Single Point of Failure

**Function**: `c.validation.ValidateAndUnpack(source, inventory)`

All class `UnpackInventory` functions now call this single function, providing:

- **One debugging point**: Set breakpoint here to catch all validation
- **Consistent behavior**: All entities use identical validation logic
- **Centralized logging**: All exploits logged from one location
- **Easy maintenance**: Update validation logic in one place

### Usage in Classes

Before (duplicate validation in each class):
```lua
self.UnpackInventory = function(inv)
    local inv = inv or {}
    self.Inventory = {}
    for i = 1, #inv do
        -- 30+ lines of validation code
        -- Type checking
        -- Weapon validation
        -- Quality checks
    end
    self.State.Inventory = self.Inventory
end
```

After (unified validation):
```lua
self.UnpackInventory = function(inv)
    local processed, valid, error = c.validation.ValidateAndUnpack(self.ID, inv)
    
    if not valid then
        c.func.Debug_1("Error unpacking inventory: " .. (error or "unknown"))
        self.Inventory = {}
        self.State.Inventory = self.Inventory
        return
    end
    
    self.Inventory = processed
    self.State.Inventory = self.Inventory
end
```

## Files Modified

### Core Module
- `server/[Validation]/_inventory_validator.lua` - Centralized validation module

### Classes Updated
All now use `c.validation.ValidateAndUnpack()`:
- `server/[Classes]/_player.lua` (2 functions)
- `server/[Classes]/_vehicle.lua` (2 functions)
- `server/[Classes]/_npc.lua` (1 function)
- `server/[Classes]/_job.lua` (1 function)

### Callbacks Updated
Use `c.validation.ValidateInventoryIntegrity()`:
- `server/[Callbacks]/_inventory.lua` - OrganizeInventory, OrganizeInventories

## Validation Flow

```
Client sends inventory
    ↓
Callback receives data
    ↓
c.validation.ValidateInventoryIntegrity()
    ├─ Check item duplication
    ├─ Check item injection  
    └─ Track quantity changes
    ↓ If exploit detected
    c.validation.LogAndBanExploiter()
    ↓ If valid
Class.UnpackInventory(inv)
    ↓
c.validation.ValidateAndUnpack(source, inv)
    ├─ c.validation.ValidateInventory()
    │   └─ c.validation.ValidateSlot() for each slot
    │       ├─ c.validation.IsValidItem()
    │       ├─ Type checks
    │       ├─ Quantity limits
    │       ├─ Quality range
    │       └─ Weapon validation
    ├─ Process inventory
    └─ Clean (remove quality <= 0)
    ↓
Inventory saved to entity
```

## Debugging

### To debug all validation:

```lua
-- In server/[Validation]/_inventory_validator.lua

function c.validation.ValidateAndUnpack(source, inventory)
    local inv = inventory or {}
    local processed = {}
    
    -- ADD BREAKPOINT OR LOGGING HERE
    print("^3[VALIDATION] Validating inventory for source:", source, "items:", #inv)
    
    -- Validate entire inventory first
    local valid, error = c.validation.ValidateInventory(inv)
    if not valid then
        print("^1[VALIDATION] FAILED:", error)
        if source then
            c.validation.LogAndBanExploiter(source, error)
        end
        return nil, false, error
    end
    
    -- ... rest of function
end
```

### To debug specific validation types:

```lua
-- Item existence
function c.validation.IsValidItem(itemName)
    print("^3[VALIDATION] Checking item:", itemName)
    -- ...
end

-- Slot validation
function c.validation.ValidateSlot(slot, index)
    print("^3[VALIDATION] Validating slot", index, ":", slot.Item)
    -- ...
end

-- Integrity (duplication/injection)
function c.validation.ValidateInventoryIntegrity(...)
    print("^3[VALIDATION] Checking inventory integrity")
    -- ...
end
```

## Benefits

1. **Single Point of Failure**
   - One function handles all validation
   - Easy to add debug logging
   - Simple breakpoint placement

2. **Global Access**
   - Available anywhere via `c.validation`
   - Consistent API across codebase
   - Can be called from any server script

3. **Code Reduction**
   - Removed ~180 lines of duplicate code
   - Added ~260 lines of unified validation
   - Net result: More features, cleaner code

4. **Maintainability**
   - Update validation logic in one place
   - Changes apply to all entity types
   - Reduced chance of inconsistencies

5. **Easier Testing**
   - Test one function instead of many
   - Consistent behavior across entities
   - Predictable error messages

## Security Features

All integrated into single validation flow:

- ✅ Item duplication prevention (quantity tracking)
- ✅ Item injection prevention (type tracking)
- ✅ Item existence validation (database check)
- ✅ Quantity overflow protection (max 999,999)
- ✅ Quality range validation (0-100)
- ✅ Type validation (numbers, strings)
- ✅ Weapon stacking prevention
- ✅ Log injection prevention (sanitized output)
- ✅ Automatic kick/ban on exploits

## Example: Adding New Validation

To add a new validation rule that applies to all inventories:

```lua
-- In c.validation.ValidateSlot()

function c.validation.ValidateSlot(slot, index)
    -- ... existing validation ...
    
    -- NEW VALIDATION: Example - check custom item flag
    if slot.CustomFlag then
        if not c.items[slot.Item].AllowsCustomFlag then
            return false, ("Slot %d: Custom flag not allowed for %s"):format(idx, slot.Item)
        end
    end
    
    return true, nil
end
```

This single change will apply to:
- All player inventories (online & offline)
- All vehicle inventories (spawned & owned)
- All NPC inventories
- All job inventories

## Migration from Old System

Old system had validation in two places:
1. Each class's UnpackInventory (type checks, weapon checks, quality cleanup)
2. Callbacks (array length check)

New system has validation in one place:
1. `c.validation` module (all validation)
2. Classes call `c.validation.ValidateAndUnpack()`
3. Callbacks call `c.validation.ValidateInventoryIntegrity()`

**Result**: Single point of failure for maximum debuggability.

---

**Version**: 1.0.0
**Last Updated**: December 2024
**Status**: Production Ready
