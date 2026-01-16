# Character Join & Load Flow Documentation

## Overview

The character lifecycle manages player progression from initial connection through full game readiness. This document outlines the complete flow, key decision points, and where each operation occurs.

---

## Flow Diagram

```
┌─────────────────────────────────────┐
│  Player Connects to Server          │
│  (Network Event: playerConnecting)  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Server: Check License Identifier   │
│  server.lua → RegisterServerCallback │
│  Validates: License_ID exists       │
└──────────────┬──────────────────────┘
               │
               ├─ If exists: UPDATE user record
               └─ If new: CREATE user record
               │
               ▼
┌─────────────────────────────────────┐
│  Player Added to Index              │
│  ig.data.AddPlayer(src)             │
│  Player placed in isolated instance │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Client: Open Character Menu        │
│  Client calls ServerCallback:       │
│  Server:Character:List              │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Server: Fetch Character List       │
│  [Events]/_character_lifecycle.lua  │
│  Returns: {Characters, Slots}       │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Client NUI: Display Menu           │
│  Player selects existing character  │
│  or clicks "NEW"                    │
└──────────────┬──────────────────────┘
               │
     ┌─────────┴──────────┐
     │                    │
     ▼ (Existing)         ▼ (New)
┌──────────────────┐  ┌──────────────────┐
│ Character:Join   │  │ Character:Create │
│ (Select existing)│  │ (Creation NUI)   │
└────────┬─────────┘  └────────┬─────────┘
         │                     │
         ▼                     │
    ┌────────────┐            │
    │ LoadPlayer │            │
    │ from DB    │            │
    └────────┬───┘            │
             │                │
             ▼                │
    ┌──────────────────────┐  │
    │ ig.data.LoadPlayer() │  │
    │ Creates xPlayer obj  │  │
    │ Loads from database  │  │
    └────────┬─────────────┘  │
             │                │
             ▼                │
    ┌──────────────────────┐  │
    │Client:Character:     │  │
    │ReSpawn(Coords)       │  │
    │ Spawn ped at coords  │  │
    └────────┬─────────────┘  │
             │                │
             └────────┬───────┘
                      │
                      ▼
         ┌──────────────────────┐
         │Character:Register    │
         │ (Only for new)       │
         │ Generate IDs/Bank    │
         │ ig.sql.char.Add()    │
         │ ig.sql.bank.Add()    │
         │ LoadPlayer()         │
         └────────┬─────────────┘
                  │
                  ▼
         ┌──────────────────────┐
         │Character:Spawn       │
         │ Send ReSpawn event   │
         │ (New & Registered)   │
         └────────┬─────────────┘
                  │
                  ▼
         ┌──────────────────────┐
         │ Client Spawns        │
         │ Loads appearance     │
         │ Hides character menu │
         │ Shows loading screen │
         └────────┬─────────────┘
                  │
                  ▼
         ┌──────────────────────┐
         │Character:Loaded      │
         │ Sets ped config      │
         │ Flags                │
         └────────┬─────────────┘
                  │
                  ▼
         ┌──────────────────────┐
         │ Client: Initialize   │
         │ HUD, inventory, etc. │
         │ Ready to play        │
         └────────┬─────────────┘
                  │
                  ▼
         ┌──────────────────────┐
         │Character:Ready       │
         │ Sets instance        │
         │ Applies job ACL      │
         │ Syncs state (cash)   │
         └────────┬─────────────┘
                  │
                  ▼
         ┌──────────────────────┐
         │   FULLY LOADED       │
         │   Player Can Play    │
         └──────────────────────┘
```

---

## Detailed Stage Breakdown

### **Stage 0: Initial Connection**

**File:** `server/server.lua`  
**Event:** `playerConnecting` (FXServer callback)

**Purpose:** Validate player license and create/update user record

**Logic:**
1. Check if player has valid License identifier
2. Lookup user in database by License_ID
   - If exists: UPDATE connection info (IP, Discord, Steam, FiveM)
   - If new: CREATE user record with all identifiers
3. Add player to `ig.pdex` (player index)
4. Place player in isolated instance (bucket)

**Security:** License verification prevents unauthorized access

**Output:** Player in game but invisible/isolated, ready for character selection

---

### **Stage 1: Character List Request**

**File:** `server/[Events]/_character_lifecycle.lua`  
**Event:** `Server:Character:List` (ServerCallback)

**Triggered by:** `Client:Character:OpeningMenu` (client-side)

**Purpose:** Fetch all characters this player owns

**Logic:**
1. Get player's Primary_ID via license identifier
2. Fetch available character slots
3. Query all characters permitted for this player
4. Return both to client

**Database Queries:**
- `ig.sql.user.GetSlots(Primary_ID)` → How many character slots this player has
- `ig.sql.char.GetAllPermited(Primary_ID, Slots)` → Characters in owned slots

**Output:** Character list displayed in NUI menu

**Player can now:**
- Select an existing character
- Click "NEW" to create character
- Click "DELETE" to delete character

---

### **Stage 2A: Load Existing Character**

**File:** `server/[Events]/_character_lifecycle.lua`  
**Event:** `Server:Character:Join`

**Triggered by:** Client NUI when player selects a character

**Purpose:** Load selected character into memory and spawn player

**Logic:**
1. Validate event came from legitimate resource (security check)
2. Check if Character_ID is valid
3. Fetch spawn coordinates from database
4. Call `ig.data.LoadPlayer(src, Character_ID)`
   - Creates xPlayer object
   - Loads character data from database
   - Sets up all player properties
   - Registers xPlayer in `ig.pdex[src]`
5. Send `Client:Character:ReSpawn` with coordinates
6. Client spawns ped at coordinates

**Database Queries:**
- `ig.sql.char.GetCoords(Character_ID)` → Get last known position
- (Inside LoadPlayer) Full character data from users, characters, banks, etc.

**Output:** Player ped spawned at last location, character fully loaded in memory

---

### **Stage 2B: Create New Character**

**File:** `server/[Events]/_character_lifecycle.lua`  
**Event:** `Server:Character:Register`

**Triggered by:** Client NUI when player submits character creation form

**Purpose:** Create new character and initialize all related data

**Logic:**
1. Validate event came from legitimate resource
2. Security check: Ensure no character already loaded (prevents double-creation)
3. Generate unique IDs:
   - `Character_ID` (unique character identifier)
   - `City_ID` (city assignment)
   - `Phone_Number`
   - `IBAN` (bank account number)
   - `Bank Account Number`
4. Insert character record into database with:
   - Player info (first name, last name)
   - Default job config
   - Default modifiers
   - Default skills
   - Appearance data
   - Spawn coordinates
5. Create bank account in parallel
6. Call `ig.data.LoadPlayer()` to load the new character
7. Trigger `Server:Character:Spawn` for spawn logic
8. Give new character a Phone item

**Database Operations:**
- `ig.sql.char.Add()` → Insert character record
- `ig.sql.bank.AddAccount()` → Create bank account
- Both are awaited before proceeding (promise-based)

**Output:** New character created, loaded, and ready to spawn

---

### **Stage 3: Character Load Initialization**

**File:** `server/[Events]/_character_lifecycle.lua`  
**Event:** `Server:Character:Loaded`

**Triggered by:** Client after ped spawned and appearance loaded

**Purpose:** Set critical ped configuration flags

**Logic:**
1. Get player ped
2. Set ped config flags to ensure proper game state:
   - Flag 42: Don't influence wanted level
   - Flag 155: Can perform arrest
   - Flag 156: Can perform uncuff
   - Flag 157: Can be arrested
   - Flag 430: Ignore being on fire
   - Flag 434: Disable homing missile lockon

**Why:** Ensures consistent ped behavior across all clients

**Output:** Ped configured correctly, game mechanics ready

---

### **Stage 4: Character Ready**

**File:** `server/[Events]/_character_lifecycle.lua`  
**Event:** `Server:Character:Ready`

**Triggered by:** Client after HUD initialized and fully ready to play

**Purpose:** Finalize player state, apply job permissions, sync state

**Logic:**
1. Get xPlayer object
2. Update player's instance bucket
3. Remove player from previous job ACL group (cleanup)
4. Reassign player to current job ACL group:
   - Calls `xPlayer.SetJob(jobName, grade)`
   - This triggers ACE permission sync
   - Other resources can now check `IsPlayerAceAllowed(src, "job.policeman")`
5. Trigger state synchronization:
   - `xPlayer.GetCash()` → Sends cash to StateBag
   - `xPlayer.GetBank()` → Sends bank balance to StateBag
   - Other clients now see this player in the world

**Database:** No DB queries (state already loaded)

**Output:** Player fully in game, visible to others, job permissions active

---

## Event Security Pattern

All character events follow this pattern:

```lua
RegisterNetEvent("Server:Character:EventName")
AddEventHandler("Server:Character:EventName", function(...)
    -- 1. Validate invoking resource
    if not isValidCharacterEvent("Server:Character:EventName") then
        CancelEvent()
        return
    end
    
    -- 2. Get source and data
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    -- 3. Perform action
    ...
end)
```

**Why:** Prevents external resources from triggering character events and exploiting the system

---

## Character Switching

**File:** `server/[Events]/_character_lifecycle.lua`  
**Event:** `Server:Character:Switch`

**Purpose:** Clean up character-specific data when player switches characters

**Logic:**
1. Remove player from current job ACL group
2. Clear character-specific UI elements
3. Reset temporary player state

**Note:** Typically followed by disconnection and reconnection to new character

---

## Character Deletion

**File:** `server/[Events]/_character_lifecycle.lua`  
**Event:** `Server:Character:Delete`

**Purpose:** Permanently delete a character from database

**Logic:**
1. Call `ig.sql.char.Delete(Character_ID)`
2. Drop player with deletion confirmation message
3. Player must rejoin to create new character

---

## Key Files

| File | Purpose |
|------|---------|
| `server/server.lua` | Initial connection & license validation |
| `server/[Events]/_character_lifecycle.lua` | All character lifecycle events (consolidated) |
| `server/_data.lua` | `ig.data.LoadPlayer()` & player index management |
| `server/[Classes]/_player.lua` | xPlayer class definition |
| `server/[SQL]/_chars.lua` | Database queries for character operations |

---

## State Management Summary

### After LoadPlayer
- xPlayer object created and in memory
- All character data loaded from database
- StateBags initialized for replication to clients
- Ped spawned at last known location

### After Character:Loaded
- Ped configuration flags set
- Game mechanics ready

### After Character:Ready
- Job ACL permissions applied
- State synchronized with all clients
- Player fully visible and playable

---

## Common Pitfalls

1. **Skipping ValidateAppearance**: Always validate appearance data before saving
2. **Not awaiting LoadPlayer**: Character must be loaded before spawning
3. **Missing isValidCharacterEvent check**: Always validate resource origin
4. **Forgetting ACL re-assignment**: Job permissions must be reapplied after load
5. **State not synced**: Use GetCash()/GetBank() to trigger StateBag updates

---

## Future Improvements

1. **Unified error handling**: Catch and log errors at each stage
2. **Character loading cache**: Reduce DB queries for frequently accessed data
3. **Appearance validation on creation**: Catch invalid data earlier
4. **Character activity tracking**: Log character creation/deletion for audit
5. **Recovery from partial loads**: Handle interruptions mid-load sequence
