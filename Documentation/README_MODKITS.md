# Missing modkits.json File

## Status
The `modkits.json` file is referenced in the code but does not exist in the //data/ directory.

## Impact
- The system handles this gracefully by using an empty table: `ig.modkits = {}`
- An error message is logged on startup: `[ERROR] Failed to load data/modkits.json`
- Vehicle modification features will not be available until this file is added

## How to Add modkits.json

If you need vehicle modification (mod kit) functionality:

1. Visit the [gta-v-data-dumps](https://github.com/DurtyFree/gta-v-data-dumps) repository
2. Download or generate the modkits data for GTA V vehicles
3. Format the data according to the structure expected by `server/[Data - No Save Needed]/_modkit.lua`
4. Place the file as `data/modkits.json`
5. Restart the resource

## Expected Structure

The modkits data should map vehicle hashes to their available modification options. See `server/[Data - No Save Needed]/_modkit.lua` for the expected data structure and helper functions.

## Current Behavior

Without this file:
- `ig.modkits` table exists but is empty: `{}`
- `ig.modkit.GetForVehicle(hash)` returns `nil` for all vehicles
- No errors occur during gameplay, modkits are just unavailable
- Vehicle customization features relying on this data won't work
