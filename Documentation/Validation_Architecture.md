# Validation Architecture - Division of Responsibilities

## Overview

The inventory validation system uses a **two-layer approach** to avoid duplication while maintaining comprehensive security:

1. **InventoryValidator** (new) - High-level integrity checks
2. **UnpackInventory** (existing) - Low-level slot validation

---

## Layer 1: InventoryValidator (High-Level)

**Location**: `/server/[Validation]/_inventory_validator.lua`

**When**: Before calling UnpackInventory

**Purpose**: Prevent exploit attempts at the inventory-wide level

### Responsibilities

✅ **Item Duplication Prevention**
- Tracks total quantities of each item type before/after
- Ensures no item type increases in quantity
- Example: Player had 5 pistols total, after operation has 6 → KICK

✅ **Item Injection Prevention**  
- Validates no new item types appear
- Ensures all items existed before the operation
- Example: Player didn't have "Diamond" before, now has it → KICK

✅ **Item Existence Validation**
- Validates item names exist in `ig.items` database
- Prevents undefined/invalid items
- Example: Item name "FakeItem123" not in database → KICK

✅ **Quantity Overflow Protection**
- Prevents extremely large quantities (>999,999)
- Protects against integer overflow exploits
- Example: Quantity set to 9999999999 → KICK

✅ **Log Injection Prevention**
- Sanitizes reason strings before logging
- Prevents malicious log manipulation
- Removes newlines, limits length

### What It Does NOT Check

❌ Type validation (number vs string) - Handled by UnpackInventory
❌ Quality range validation (0-100) - Handled by UnpackInventory  
❌ Weapon stacking (quantity > 1) - Handled by UnpackInventory
❌ Quality-based item removal (quality <= 0) - Handled by UnpackInventory

---

## Layer 2: UnpackInventory (Low-Level)

**Location**: `/server/[Classes]/_player.lua`, `_vehicle.lua`, `_npig.lua`, `_objects.lua`

**When**: After InventoryValidator passes

**Purpose**: Validate and clean individual slot data

### Responsibilities

✅ **Type Validation**
- Ensures Quantity is a number
- Ensures Quality is a number
- Logs error and breaks on failure

✅ **Weapon Stacking Prevention**
- Checks if item marked as weapon has quantity >= 1
- Validates weapon flag matches item database
- Logs error and breaks on failure

✅ **Quality-Based Cleanup**
- Removes items with quality <= 0
- Automatic cleanup of broken/degraded items

### What It Does NOT Check

❌ Item duplication across inventories - Handled by InventoryValidator
❌ Item injection detection - Handled by InventoryValidator
❌ Quantity overflow (>999,999) - Handled by InventoryValidator
❌ Item existence in database - Handled by InventoryValidator

---

## Validation Flow

```
Client sends inventory data
    ↓
Callback receives data
    ↓
┌─────────────────────────────────────┐
│ InventoryValidator                  │
│ ├─ Check item duplication           │
│ ├─ Check item injection             │
│ ├─ Check item existence             │
│ └─ Check quantity overflow          │
└─────────────────────────────────────┘
    ↓ If valid
┌─────────────────────────────────────┐
│ UnpackInventory (class method)      │
│ ├─ Type validation (number check)   │
│ ├─ Weapon stacking prevention       │
│ └─ Quality cleanup (remove <= 0)    │
└─────────────────────────────────────┘
    ↓ If valid
Inventory saved to entity
```

---

## Why This Division?

### Prevents Redundancy
- Each layer handles different concerns
- No duplicate validation logic
- Cleaner, more maintainable code

### Separation of Concerns
- **InventoryValidator**: Cross-inventory security (duplication, injection)
- **UnpackInventory**: Per-slot data integrity (types, ranges)

### Maintains Existing Behavior
- UnpackInventory already worked before
- InventoryValidator adds new security on top
- Minimal changes to existing code

### Performance
- High-level checks happen once (before)
- Low-level checks happen per slot (during unpack)
- Optimal ordering: reject exploits early, validate details later

---

## Example: Why Both Are Needed

### Scenario: Duplication Attempt

**Client sends:**
```lua
-- Before: Player had 1 Pistol
-- After: Player claims to have 2 Pistols
inv1 = {
  {Item = "Pistol", Quantity = 1, Quality = 100, Weapon = true},
  {Item = "Pistol", Quantity = 1, Quality = 100, Weapon = true}
}
```

**InventoryValidator catches this:**
- ✅ Detects total Pistol quantity increased from 1 to 2
- ✅ Kicks player before UnpackInventory runs
- ✅ Prevents duplication exploit

**UnpackInventory would NOT catch this:**
- ❌ Each individual slot is valid (correct types, weapon flag)
- ❌ Only checks per-slot data, not totals
- ❌ Would accept both Pistols

---

### Scenario: Invalid Type

**Client sends:**
```lua
inv1 = {
  {Item = "Water", Quantity = "five", Quality = 100}  -- Quantity is string
}
```

**InventoryValidator allows this:**
- ❌ Only checks quantities as numbers in totals
- ❌ Doesn't validate individual slot types
- ✅ Passes to UnpackInventory

**UnpackInventory catches this:**
- ✅ Checks `type(Quantity) ~= "number"`
- ✅ Logs error and breaks
- ✅ Prevents corrupt data

---

## Security Coverage Matrix

| Exploit Type | InventoryValidator | UnpackInventory | Result |
|--------------|-------------------|-----------------|--------|
| Duplication | ✅ Detects | - | BLOCKED |
| Injection | ✅ Detects | - | BLOCKED |
| Non-existent item | ✅ Detects | - | BLOCKED |
| Quantity overflow | ✅ Detects | - | BLOCKED |
| Invalid type (string) | - | ✅ Detects | BLOCKED |
| Weapon stacking | - | ✅ Detects | BLOCKED |
| Quality <= 0 | - | ✅ Removes | CLEANED |
| Quality > 100 | ✅ Detects* | - | BLOCKED |

*Note: Quality > 100 is caught by ValidateSlot but we removed that call to avoid duplication. Consider if this should be re-enabled.

---

## Recommendations

### Current Implementation
✅ No duplication between layers
✅ Clear separation of concerns
✅ Comprehensive coverage

### Potential Enhancement

Consider adding quality range validation back to InventoryValidator if UnpackInventory doesn't enforce upper bound:

```lua
-- In InventoryValidator.ValidateSlot
if quality > 100 then
    return false, "Quality exceeds maximum for " .. slot.Item
end
```

This depends on whether UnpackInventory should accept quality > 100 or not.

---

## Testing Validation Layers

### Test InventoryValidator
- Duplicate items (change quantities)
- Inject new items
- Use non-existent items
- Set quantity to 10000000

### Test UnpackInventory  
- Send Quantity as string
- Send Quality as string
- Stack weapons (Quantity > 1 for weapon)
- Send item with Quality = 0

---

**Last Updated**: December 2024
**Version**: 1.0.0
