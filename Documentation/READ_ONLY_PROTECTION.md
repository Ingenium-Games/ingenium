# Read-Only Data Protection

## Overview

The Ingenium framework now includes built-in protection for configuration and static game data tables to prevent client-side modification. This protection is implemented using Lua metatables to create read-only proxies for data tables.

## Protected Tables

### Configuration Tables
- `conf` - Main configuration table and all nested tables (shared)

### Static Game Data Tables (Client & Shared)
- `ig.tattoos` - Tattoo data
- `ig.weapons` - Weapon data  
- `ig.vehicles` - Vehicle data
- `ig.modkits` - Vehicle modification kits
- `ig.itemdata` - Item data

### Static Game Data Tables (Server Only)
- `ig.peds` - Ped/character model data
- `ig.appearance_constants` - Appearance customization constants

Note: Some tables are only protected on the server side because they're not loaded on the client side.

## How It Works

The protection is implemented in `shared/[Tools]/_table.lua` using the `ig.table.MakeReadOnly()` function:

```lua
local readOnlyTable = ig.table.MakeReadOnly(originalTable, "tableName")
```

### Features

1. **Read Access** - All read operations work normally
2. **Write Protection** - Any attempt to modify values throws an error
3. **Add Key Protection** - Any attempt to add new keys throws an error
4. **Nested Protection** - Nested tables are automatically protected recursively
5. **Iteration Support** - `pairs()` and `ipairs()` work normally on protected tables

### Example

```lua
-- Reading works fine
local vehicleData = ig.vehicles[vehicleHash]
local weaponName = ig.weapons[weaponHash].displayName

-- These will throw errors:
ig.vehicles[vehicleHash].displayName = "Hacked" -- ERROR
conf.debug_1 = false -- ERROR
conf.spawn.x = 9999 -- ERROR
```

## Error Messages

When modification is attempted, a clear error message is displayed:

```
Attempt to modify read-only conf.spawn[x]. This data is protected from modification.
```

## Security Notes

1. **Client-Side Protection** - This protection works on the client side to prevent accidental or malicious modification
2. **Not Absolute** - Determined attackers can still bypass Lua-level protections, but this adds a significant barrier
3. **Asset Escrow** - Combined with FiveM's asset escrow encryption, this provides multiple layers of protection
4. **Best Practices** - This is part of a defense-in-depth strategy

### Implementation Details

### Files Modified

1. `shared/[Tools]/_table.lua` - Added `MakeReadOnly()` function with nested table caching
2. `shared/_protect.lua` - Protects `conf` configuration table  
3. `server/_data.lua` - Protects server-side static reference data tables
4. `fxmanifest.lua` - Updated to include protection script

Note: The `shared/data/` directory contains unused data loaders that are not integrated into the manifest. All actual data loading and protection happens in `server/_data.lua`.

### Load Order

Protection is applied after all configuration and data files are loaded:
1. Config files load (`_config/*.lua`)
2. Tools load (`shared/[Tools]/*.lua`) 
3. Data loads (`shared/data/_loader.lua` and `server/_data.lua`)
4. Protection applies (`shared/_protect.lua` and within data loaders)

## Testing

To verify protection is working:

1. Check console output on startup for:
   - `[ingenium] Configuration tables protected from modification`
   - `[Data] Static reference data protected from modification`

2. Test in console:
   ```lua
   conf.debug_1 = false  -- Should error
   ig.vehicles[0x12345].name = "test"  -- Should error
   ```

## For Developers

If you need to modify data at runtime (which should be rare), you must:

1. Store modifications in a separate table
2. Use wrapper functions that check the separate table first
3. Document why runtime modification is necessary

Example:
```lua
-- Don't modify protected tables
-- ig.vehicles[hash].customField = "value"  -- BAD

-- Instead, use a separate override table
local vehicleOverrides = {}
vehicleOverrides[hash] = { customField = "value" }

-- Access with fallback
local function GetVehicleData(hash)
    return vehicleOverrides[hash] or ig.vehicles[hash]
end
```

## Future Enhancements

Potential future improvements:
1. Allow specific fields to be writable if needed
2. Add logging of protection violations
3. Extend protection to additional dynamic data tables if appropriate
