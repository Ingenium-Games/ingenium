# Forced Animation System

## Overview

The Forced Animation System is a secure, server-authenticated, **data-driven** mechanism for triggering animations on players based on in-game mechanics. The primary use case is forcing players to put their hands up when they are unarmed and being aimed at by another player with a weapon.

### Data-Driven Architecture

Instead of hardcoding weapon hashes, the system uses the `weapons.json` data file's `Category` field to determine which weapons are considered "unarmed" or "melee". This makes the system:
- **Future-proof** - New weapons automatically categorized
- **Maintainable** - No code changes needed for new weapons
- **Centralized** - Single source of truth (weapons.json)

## Architecture

### Security Model

All forced animations are:
1. **Client-initiated** - Detection happens on the client for performance
2. **Server-validated** - All requests are authenticated through server callbacks
3. **Distance-checked** - Server validates players are within configured range
4. **Cooldown-protected** - Prevents spam and abuse
5. **Logged** - All forced animation events are logged for audit

### Components

#### Server-Side
- **`server/[Callbacks]/_animations_forced.lua`** - Server callback handlers with validation
- **`_config/forced_animations.lua`** - Configuration for distance, cooldowns, permissions

#### Client-Side
- **`client/[Callbacks]/_animations_forced.lua`** - Animation playback handlers
- **`client/[Threads]/_forced_animations.lua`** - Detection thread for forced mechanics

## Configuration

Edit `_config/forced_animations.lua`:

```lua
-- Maximum distance for forced animations
conf.forcedAnimations.maxDistance = 15.0

-- Cooldown between triggers (seconds)
conf.forcedAnimations.cooldown = 2.0

-- Require target to be unarmed for hands up
conf.forcedAnimations.requireUnarmedForHandsUp = true

-- Require line of sight
conf.forcedAnimations.requireLineOfSight = true

-- Enable/disable the aiming mechanic
conf.forcedAnimations.enableAimingMechanic = true

-- Enable logging
conf.forcedAnimations.enableLogging = true

-- Weapon categories considered "unarmed" (from weapons.json)
conf.forcedAnimations.allowedWeaponCategories = {
    "GROUP_UNARMED",    -- Fists/unarmed
    "GROUP_MELEE",      -- Knives, bats, etc.
}
```

### Data-Driven Weapon Categories

The system automatically loads all weapons from `data/weapons.json` that match the configured categories. For example:
- `GROUP_UNARMED` includes `WEAPON_UNARMED`
- `GROUP_MELEE` includes `WEAPON_KNIFE`, `WEAPON_BAT`, `WEAPON_NIGHTSTICK`, etc.

When new weapons are added to the game and included in `weapons.json` with appropriate categories, they automatically work with the forced animation system - no code changes required!

## Available Animations

All animations can be triggered via server callbacks:

1. **ForceAnimation:ArmsCrossed** - Arms crossed stance
2. **ForceAnimation:HandsUp** - Hands up (surrender)
3. **ForceAnimation:HoldArm** - Hold arm stance
4. **ForceAnimation:Mugging** - Mugging/handoff animation
5. **ForceAnimation:PickUp** - Pickup/putdown animation
6. **ForceAnimation:Escorting** - Escorting animation (for escorts)
7. **ForceAnimation:Escorted** - Escorted animation (being escorted)
8. **ForceAnimation:Nod** - Nod gesture
9. **ForceAnimation:Lockpick** - Lockpicking animation
10. **ForceAnimation:Repair** - Repair animation
11. **ForceAnimation:PhoneCall** - Phone call animation
12. **ForceAnimation:FacePalm** - Face palm gesture

## Usage

### Automatic Hands Up (Built-in)

The system automatically detects when:
- A player is aiming at another player
- The target player is unarmed
- The target player can see the aimer
- Players are within configured distance (default 15m)

When all conditions are met, the target player is forced into hands up animation.

### Manual Triggering

From another resource or script:

```lua
-- Force a player to put hands up
local success = ig.callback.Await('ForceAnimation:HandsUp', targetPlayerId, true)

-- Stop the animation
ig.callback.Await('ForceAnimation:HandsUp', targetPlayerId, false)
```

### Server-Side Usage

```lua
-- Trigger via server callback
TriggerServerCallback({
    eventName = "ForceAnimation:HandsUp",
    args = {targetId, true}  -- targetId, shouldPlay
})
```

## Validation & Security

Each forced animation request is validated for:

1. **Player Existence** - Both source and target must be valid players
2. **Distance** - Players must be within `maxDistance` (default 15m)
3. **Cooldown** - Respects configured cooldown period (default 2s)
4. **Permissions** - (Optional) Job-based permissions can be enforced
5. **Weapon State** - For HandsUp, validates target is unarmed (if configured)

## Client Detection Logic

The detection thread (`client/[Threads]/_forced_animations.lua`):

1. **Initialization Phase**:
   - Waits for player to be fully loaded (`NetworkIsPlayerActive`)
   - Requests weapon data from server via `ig.weapon.GetAll()`
   - Builds local table of allowed weapons based on categories
   - Only starts detection after data is successfully loaded

2. **Detection Phase** (runs every 500ms):
   - Checks if local player is unarmed (using data-driven weapon table)
   - Scans all nearby players (within 15m)
   - Detects if any player is aiming at local player
   - Validates line of sight (using raycasts)
   - Triggers server callback when conditions are met
   - Automatically stops animation when no longer being aimed at

### Initialization Sequence

```
Player Spawns → Wait for NetworkIsPlayerActive → Request Weapon Data from Server
→ Build Allowed Weapon Table → Start Detection Thread
```

This ensures the system has all necessary data before checking player states.

## Exports

### Get Current Configuration

```lua
local config = exports['ingenium']:GetForcedAnimConfig()
```

### Modify Configuration at Runtime

```lua
exports['ingenium']:SetForcedAnimConfig('handsUpDistance', 20.0)
exports['ingenium']:SetForcedAnimConfig('handsUpCheckInterval', 300)
```

### Debug Exports

```lua
-- Get table of allowed weapon hashes
local allowedWeapons = exports['ingenium']:GetAllowedWeapons()

-- Check if weapon data is initialized
local isReady = exports['ingenium']:IsWeaponDataInitialized()
```

## Logging

When `conf.forcedAnimations.enableLogging = true`, all forced animation events are logged:

```
[FORCED ANIM] John Doe (1) ALLOWED force HandsUp on Jane Smith (2)
[FORCED ANIM] John Doe (1) DENIED force HandsUp on Jane Smith (2)
```

Optional Discord webhook logging can be configured via `conf.forcedAnimations.discordWebhook`.

## Performance Considerations

- Detection thread runs at 500ms intervals (configurable)
- Line of sight checks use native raycasts (optimized)
- Server-side validation uses cached player data
- Cooldowns prevent spam and reduce server load

## Extending the System

### Adding New Forced Animations

1. **Add client callback handler** in `client/[Callbacks]/_animations_forced.lua`:

```lua
RegisterClientCallback({
    eventName = "Client:Animation:YourAnimation",
    eventCallback = function(bool, ped)
        local ped = ped or GetPlayerPed(-1)
        -- Your animation code here
    end
})
```

2. **Add server validation callback** in `server/[Callbacks]/_animations_forced.lua`:

```lua
RegisterServerCallback({
    eventName = "ForceAnimation:YourAnimation",
    eventCallback = function(source, targetId, shouldPlay)
        -- Validation logic
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:YourAnimation",
            args = {shouldPlay}
        })
        return true
    end
})
```

### Adding New Detection Mechanics

Modify `client/[Threads]/_forced_animations.lua` to add new detection logic for different scenarios (e.g., proximity-based animations, context-based triggers).

## Troubleshooting

### Animations Not Triggering

1. Check `conf.forcedAnimations.enableAimingMechanic` is `true`
2. Verify target player is unarmed (if `requireUnarmedForHandsUp` is `true`)
3. Check distance is within `maxDistance`
4. Ensure line of sight is clear (if `requireLineOfSight` is `true`)
5. Check server console for denied logs

### Performance Issues

1. Increase `handsUpCheckInterval` (default 500ms)
2. Reduce `handsUpDistance` to scan fewer players
3. Disable `requireLineOfSight` to skip raycast checks

## Migration from Old System

The old system used `RegisterNetEvent` with manual security checks and **hardcoded weapon lists**. The new system:

- Uses `RegisterClientCallback` for client handlers
- Uses `RegisterServerCallback` for server validation
- **Data-driven weapon categorization** from weapons.json
- Removes need for `GetInvokingResource()` checks
- Adds built-in distance validation, cooldowns, and logging
- Centralizes configuration
- **Waits for player initialization before starting**
- **Automatically updates when weapons.json is updated**

No changes needed to animation playback logic - only the registration method and weapon detection changed.

### Benefits of Data-Driven Approach

1. **No Hardcoding**: Weapon hashes not embedded in code
2. **Single Source of Truth**: weapons.json defines weapon categories
3. **Automatic Updates**: New weapons work immediately when added to weapons.json
4. **Easy Customization**: Change `allowedWeaponCategories` in config instead of modifying code
5. **Better Performance**: Table lookup vs multiple OR conditions (for large lists)
6. **Maintainability**: No code changes needed for weapon additions/removals
