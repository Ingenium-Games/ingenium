# Unused Files Analysis and Deletion Plan

## Purpose
This document identifies files and directories that are not referenced in the codebase and are marked for potential deletion, as requested in the issue.

## Analysis Date
2026-01-01

## Methodology
1. Reviewed `fxmanifest.lua` to identify loaded files
2. Searched codebase for references to suspected unused files
3. Verified data loading mechanisms
4. Confirmed server-side data handling vs client-side requirements

---

## Category 1: Unused Data Loaders (shared/data/)

### Status: ✅ CONFIRMED UNUSED - SAFE TO DELETE

These files were intended as an alternative data loading system but were never integrated:

- **`shared/data/_loader.lua`**
  - Purpose: Would load game data files (tattoos, weapons, vehicles, modkits, items)
  - Status: NOT in fxmanifest.lua, never loaded
  - Evidence: Documentation explicitly states it's unused (READ_ONLY_PROTECTION.md:86)
  - Replacement: `server/_data.lua` handles all data loading

- **`shared/data/_helpers.lua`**
  - Purpose: Helper functions for accessing game data
  - Status: NOT in fxmanifest.lua, never loaded
  - Issues: References `ig.data.tattoos` but actual data is in `ig.tattoos`
  - Evidence: Functions defined here are never called in the codebase
  - Replacement: Helper functions exist in:
    - `server/[Data - No Save Needed]/_tattoo.lua`
    - `server/[Data - No Save Needed]/_weapons.lua`
    - `server/[Data - No Save Needed]/_vehicle.lua`
    - `server/[Data - No Save Needed]/_modkit.lua`
    - `client/[Data]/_game_data_helpers.lua`

- **`shared/data/README.md`**
  - Purpose: Documentation for the unused shared/data system
  - Status: Documents a system that was never implemented
  - Evidence: Refers to loading files from `shared/data/` directory which doesn't happen

### Impact of Deletion
- ✅ No impact - files are not loaded or referenced
- ✅ Server-side data loading through `server/_data.lua` remains unchanged
- ✅ Client receives data from server via callbacks (proper architecture)

---

## Category 2: Example Files (Not Integrated)

### Status: ✅ CONFIRMED UNUSED - SAFE TO DELETE (IF NOT NEEDED AS REFERENCE)

These appear to be example/reference files never integrated into the system:

#### Directory: `[Example Items]/`
- **`[Example Items]/_items.lua`** (211KB)
  - Purpose: Example item definitions in Lua format
  - Status: NOT in fxmanifest.lua, never loaded
  - Evidence: Structure differs from actual `data/Items.json`
  - Note: Actual items loaded from `data/Items.json` via `server/_data.lua`

#### Directory: `[Example Doors]/`
Contains example door configurations for various map MLOs:
- `Gabz_FireDept_Doors.lua`
- `Gabz_Gang_Doors.lua`
- `Gabz_LostMC_Doors.lua`
- `Gabz_MRPD_Doors.lua`
- `Gabz_Mechanic_Doors.lua`
- `Gabz_Motel_Doors.lua`
- `Gabz_Pillbox_Doors.lua`
- `Gabz_Prison_Doors.lua`
- `Gabz_Unowned_Doors.lua`

**Status:** NOT in fxmanifest.lua, never loaded
**Note:** Actual doors loaded from `data/Doors.json` via `server/_data.lua`

### Recommendation
Keep these if they serve as reference/documentation for server admins to create their own items/doors. Otherwise, safe to delete.

---

## Category 3: Native Stubs

### Status: ⚠️ UNKNOWN - NEEDS VERIFICATION

#### Directory: `[Stubs]/`
Contains auto-generated FiveM native function stubs:
- `natives_client.lua` (93KB)
- `natives_server.lua` (59KB)
- `natives_shared.lua` (346KB)

**Status:** NOT in fxmanifest.lua, never loaded
**Purpose:** Likely IDE autocomplete/documentation files

### Recommendation
These are typically used for IDE support (autocomplete, type hints). If developers use an IDE with FiveM support, these might be useful to keep. Otherwise, safe to delete.

---

## Category 4: Missing Data Files

### Status: ⚠️ DATA FILE MISSING

The unused `shared/data/_loader.lua` references a file that doesn't exist:

- **`shared/data/modkits.json`** - Referenced but never created
  - Would need to be in `shared/data/` directory
  - Actual modkits loaded from `data/` directory (if it exists there)

**Note:** This is only relevant if keeping the shared/data system, which is NOT recommended.

---

## Summary of Actual Data Loading (Current System)

### ✅ Server-Side Data Loading (WORKING)
Location: `server/_data.lua` → `ig.data.LoadJSONData()`

**Loads from `data/` directory:**
- Dynamic/Runtime Data (Modified during gameplay):
  - `Items.json` → `ig.items`
  - `Drops.json` → `ig.drops`
  - `Pickups.json` → `ig.picks`
  - `Scenes.json` → `ig.scenes`
  - `Notes.json` → `ig.notes`
  - `GSR.json` → `ig.gsrs`
  - `Jobs.json` → `ig.jobs`
  - `Doors.json` → `ig.doors`
  - `Objects.json` → `ig.objects`
  - `Names.json` → `ig.names`

- Static/Reference Data (Read-only, protected):
  - `tattoos.json` → `ig.tattoos` (protected)
  - `weapons.json` → `ig.weapons` (protected)
  - `vehicles.json` → `ig.vehicles` (protected)
  - `modkits.json` → `ig.modkits` (protected) ⚠️ File may not exist
  - `peds.json` → `ig.peds` (protected)
  - `appearance-constants.json` → `ig.appearance_constants` (protected)

### ✅ Client Data Access (WORKING)
Clients request data from server via callbacks in `server/[Callbacks]/_data.lua`:
- `ig:GameData:GetTattoos`
- `ig:GameData:GetWeapons`
- `ig:GameData:GetVehicles`
- `ig:GameData:GetModkits`
- etc.

**This is the correct architecture: Server is the authority, client requests data when needed.**

---

## Recommended Actions

### 1. DELETE - Safe to Remove (No Code References)
- `shared/data/_loader.lua`
- `shared/data/_helpers.lua`
- `shared/data/README.md`

### 2. CONSIDER DELETION - Not Integrated (Server Admin Decision)
- `[Example Items]/_items.lua` (unless used as reference documentation)
- `[Example Doors]/*.lua` (unless used as reference documentation)

### 3. OPTIONAL DELETION - Development Tools
- `[Stubs]/natives_*.lua` (unless developers need IDE support)

### 4. VERIFY - Data File Check
- Confirm if `data/modkits.json` exists or is needed
- If doesn't exist, may cause errors during data loading

---

## Verification Checklist

Before deletion, verify:
- [x] Files are NOT in fxmanifest.lua
- [x] No `require()` statements reference these files
- [x] No grep matches in active code (excluding documentation)
- [x] Working data loading system exists (server/_data.lua)
- [x] Server-side helpers exist for game data
- [x] Client-side helpers exist and use callbacks
- [ ] Run server and verify no errors after deletion
- [ ] Test data loading (tattoos, weapons, vehicles, modkits, items)
- [ ] Test client data requests via callbacks

---

## Issue Requirements Verification

✅ **"Review codebase, file by file, to check if the contents will be called in other files"**
   - Analysis completed for all suspected unused files

✅ **"If Not, mark them for possible deletion"**
   - Files marked in Categories 1-3 above

✅ **"If yes, continue to see if the same data is also within other files"**
   - Confirmed: shared/data/ has equivalent functionality in server/[Data - No Save Needed]/

✅ **"If it is, review to keep one and mark the others for deletion"**
   - Keep: server/[Data - No Save Needed]/ (working, integrated)
   - Delete: shared/data/ (unused, not integrated, wrong data structure)

✅ **"confirming the location of stored information makes logical sense"**
   - Server-side storage in `ig.*` tables: ✅ Correct
   - Server loads from `data/` directory: ✅ Correct
   - Static data protected from modification: ✅ Correct

✅ **"again confirming all data is generated on server side, and if and when required, is passed to the client when needing only"**
   - All data loaded server-side: ✅ Confirmed
   - Clients request via callbacks: ✅ Confirmed
   - No direct client data loading: ✅ Verified

---

## Additional Notes

### Comment from @Twiitchter
> "possible unused sections as noted in prior copilot sessions shared/data as data is loaded server side then passed to client upon connection or when requested."

✅ **Analysis confirms:** 
- The shared/data/ directory is indeed unused
- All data IS loaded server-side (via server/_data.lua, not shared/data/_loader.lua)
- Data IS passed to client only when requested (via callbacks)
- Architecture is correct as-is

### Documentation Evidence
From `Documentation/READ_ONLY_PROTECTION.md` line 86:
> "Note: The `shared/data/` directory contains unused data loaders that are not integrated into the manifest. All actual data loading and protection happens in `server/_data.lua`."

This confirms the shared/data/ directory was identified as unused in prior documentation.
