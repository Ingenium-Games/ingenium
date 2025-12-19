# Migration Infrastructure Documentation

## Overview
This document describes the infrastructure added to `ingenium` to support the migration of `ig.base` and `ig.interact` resources.

## Files Added

### Configuration Files

#### `_config/conf.gamemode.lua`
- Defines game mode settings (RP, DM, TDM, KOTH, FR, GG)
- Provides helper functions to query game mode features
- Exports functions for both client and server use

#### `_config/conf.interact.bins.lua`
- Placeholder configuration for bin interactions
- Ready for full migration of ig.interact bin system

#### `_config/conf.interact.peds.lua`
- Placeholder configuration for interaction peds
- Ready for full migration of ig.interact ped system

#### `_config/conf.interact.anim.lua`
- Placeholder configuration for animations
- Ready for full migration of ig.interact animation system

### Client-Side Files

#### `client/[Events]/_vehicle.lua`
**Optimized Vehicle Tracking System**
- Replaces 50ms polling with event-driven approach
- Uses `gameEventTriggered` for `CEventNetworkPlayerEnteredVehicle` and `CEventNetworkPlayerLeftVehicle`
- Lightweight 1-second fallback thread for edge cases (teleportation, etig.)
- Provides helper functions:
  - `ig.GetCurrentVehicle()` - Returns current vehicle entity
  - `ig.GetCurrentSeat()` - Returns current seat index
  - `ig.IsInVehicle()` - Returns boolean

**Performance Improvement**: 20x reduction in vehicle state checks (1000ms vs 50ms)

#### `client/[Events]/_gamemode.lua`
**Game Mode Event Handlers**
- Conditional handlers based on `conf.gamemode`
- Separate logic for each game mode (RP, DM, TDM, KOTH, FR, GG)
- Extends core vehicle events with mode-specific behavior

#### `client/[Threads]/_rp_features.lua`
**Consolidated RP Features Thread**
- Only loads when `conf.gamemode == "RP"`
- **One-Time Setup Thread**: Disables trains, dispatch, sets audio flags
- **Per-Frame Thread**: Minimal - only HUD hiding
- **Consolidated Timed Operations**: Uses `GetGameTimer()` for:
  - Idle camera disable (5-second intervals)
  - NPC weapon drop prevention (2.5-second intervals)
- **Player State Monitoring**: 1-second interval for death/frozen states

**Performance Improvement**: Reduces ~8-12 separate threads to 4 optimized threads

### Server-Side Files

#### `server/[Events]/_vehicle.lua`
**Server Vehicle Event Handlers**
- Handles `Server:PlayerEnteredVehicle` and `Server:PlayerLeftVehicle` events
- Updates player state bags for vehicle occupancy
- Triggers server-side events for other systems to hook into

### Directory Structure

#### `client/[Interactions]/`
Created placeholder directories for ig.interact migration:
- `animations/` - Animation system
- `areas/` - Zone/area interactions
- `entities/` - Entity interactions
- `jobs/` - Job-specific interactions

Each directory contains a README.md documenting expected content.

## Integration with Existing Code

### State Management
The new vehicle tracking system integrates with existing code:
- Triggers existing `Client:EnteredVehicle` and `Client:LeftVehicle` events
- Works with existing event handlers in `client/[Events]/_vehicles.lua`
- Updates server-side player state bags for synchronization

### Configuration Loading
All config files use the existing pattern:
- Loaded via `_config/**/*.lua` in `fxmanifest.lua`
- Available to both client and server as shared scripts
- Loaded before client/server scripts execute

### Function Patterns
Follows existing ingenium conventions:
- Uses `ig.func.Debug_1/2/3()` for logging
- Uses `Citizen.CreateThread()` for threads
- Uses `LocalPlayer.state` for client state
- Uses `Player(source).state` for server state

## Performance Benefits

### Before (Separate Resources)
- 3 resources loading (ingenium, ig.base, ig.interact)
- Redundant state tables duplicating LocalPlayer.state
- Cross-resource events for every state change
- ~8-12 separate threads
- Vehicle polling every 50ms (20 checks per second)

### After (Merged)
- 1 resource (ingenium only)
- Single state source (LocalPlayer.state)
- Direct function calls (no cross-resource overhead)
- ~4-6 optimized threads
- Vehicle tracking via events + 1s fallback (1 check per second)

**Expected Improvements**:
- 20-30% reduction in client-side CPU usage
- 40-50% reduction in network events
- Faster state access (direct vs cross-resource)
- Better memory efficiency (single Lua state)

## Usage Examples

### Checking if Player is in Vehicle
```lua
-- Using helper function
if ig.IsInVehicle() then
    local vehicle = ig.GetCurrentVehicle()
    local seat = ig.GetCurrentSeat()
    print("In vehicle, seat: " .. seat)
end
```

### Hooking Vehicle Events
```lua
-- Client-side
AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, netId)
    print("Entered: " .. name)
end)

-- Server-side
AddEventHandler("Server:OnPlayerEnteredVehicle", function(source, vehicle, seat, netId)
    print("Player " .. source .. " entered vehicle")
end)
```

### Checking Game Mode Features
```lua
-- Check if feature is enabled
if IsGameModeFeatureEnabled("hideHud") then
    -- HUD hiding is enabled for this mode
end

-- Get current mode
local mode = GetGameMode() -- Returns "RP", "DM", etig.
```

## Next Steps

### Phase 2: Full ig.interact Migration
1. Copy animation system files to `client/[Interactions]/animations/`
2. Copy area system files to `client/[Interactions]/areas/`
3. Copy entity interaction files to `client/[Interactions]/entities/`
4. Copy job interaction files to `client/[Interactions]/jobs/`
5. Populate config files with actual data from ig.interact
6. Update all `exports["ingenium"]:c()` calls to direct `c` access
7. Test all interaction features

### Phase 3: Cleanup
1. Remove ig.base from server.cfg
2. Remove ig.interact from server.cfg
3. Archive old resources as backups
4. Monitor performance with `resmon`
5. Verify no console errors

## Testing Checklist
- [ ] Resource loads without errors
- [ ] Vehicle entry/exit triggers events
- [ ] LocalPlayer.state accessible
- [ ] Game mode features work correctly
- [ ] No performance degradation
- [ ] Multi-player state replication works

## Rollback Procedure
If issues arise:
1. Re-enable ig.base and ig.interact in server.cfg
2. Restart server
3. Debug issues
4. Fix and test again

## Notes
- All new code follows ingenium coding standards
- Uses FiveM native state management (LocalPlayer.state, Player().state)
- Maintains security protections (StateBag validation)
- Compatible with existing ingenium state synchronization
