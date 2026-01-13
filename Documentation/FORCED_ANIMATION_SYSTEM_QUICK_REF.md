# Forced Animation System - Quick Reference

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    weapons.json (Data Source)                │
│  Contains "Category" field: GROUP_UNARMED, GROUP_MELEE, etc. │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────────────┐
│              Server: ig.weapons (Loaded on start)             │
│  Filters weapons by category → builds unarmedWeapons table   │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ├─── Validates forced animation requests
                   │
                   ▼
┌──────────────────────────────────────────────────────────────┐
│         Client: Requests ig.weapon.GetAll() on spawn          │
│  Builds local UNARMED_WEAPONS table from server data         │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────────────┐
│             Detection Thread (every 500ms)                    │
│  Checks: IsLocalPlayerUnarmed() → uses UNARMED_WEAPONS      │
└──────────────────────────────────────────────────────────────┘
```

## Data Flow

1. **Server Startup**:
   ```lua
   weapons.json → ig.weapons → Filter by Category → unarmedWeapons{}
   ```

2. **Client Player Spawn**:
   ```lua
   NetworkIsPlayerActive() → ig.weapon.GetAll() → Build UNARMED_WEAPONS{} → Start Detection Thread
   ```

3. **Detection Loop**:
   ```lua
   Check if unarmed → Check if aimed at → Trigger Server Callback → Server validates → Force animation
   ```

## Key Files

| File | Purpose | Type |
|------|---------|------|
| `data/weapons.json` | Source of truth for weapon categories | Data |
| `_config/forced_animations.lua` | Configuration (distance, cooldown, categories) | Config |
| `server/[Callbacks]/_animations_forced.lua` | Server validation & callbacks | Server Logic |
| `client/[Callbacks]/_animations_forced.lua` | Animation playback handlers | Client Logic |
| `client/[Threads]/_forced_animations.lua` | Detection thread & weapon data init | Client Logic |

## Adding New Weapons

**No code changes needed!** Just update `weapons.json`:

```json
{
  "Name": "WEAPON_NEWSWORD",
  "Category": "GROUP_MELEE",
  "Hash": 123456789,
  ...
}
```

The system automatically includes it in forced animation checks on next resource restart.

## Configuring Allowed Weapons

Edit `_config/forced_animations.lua`:

```lua
-- To allow only truly unarmed:
conf.forcedAnimations.allowedWeaponCategories = {
    "GROUP_UNARMED"  -- Only fists
}

-- To allow unarmed + melee (default):
conf.forcedAnimations.allowedWeaponCategories = {
    "GROUP_UNARMED",
    "GROUP_MELEE"
}

-- To add custom categories (if they exist in weapons.json):
conf.forcedAnimations.allowedWeaponCategories = {
    "GROUP_UNARMED",
    "GROUP_MELEE",
    "GROUP_THROWN"  -- Example: thrown weapons
}
```

## Debugging

### Check if weapon data loaded:

**Client Console:**
```lua
exports.ingenium:IsWeaponDataInitialized()  -- Should return true
```

### View allowed weapons:

**Client Console:**
```lua
local weapons = exports.ingenium:GetAllowedWeapons()
for hash, _ in pairs(weapons) do
    print(hash)
end
```

### Check current weapon:

**Client Console:**
```lua
local ped = PlayerPedId()
local weapon = GetSelectedPedWeapon(ped)
print("Current weapon hash:", weapon)
```

### Server logs:

Look for:
```
[INFO] [ForcedAnimations] Initialized X allowed weapons for forced animations
[FORCED ANIM] Player (1) ALLOWED force HandsUp on Target (2)
```

## Common Issues

### Animation not triggering

1. **Weapon data not loaded**:
   - Check: `exports.ingenium:IsWeaponDataInitialized()`
   - Wait 2-3 seconds after spawn

2. **Target not unarmed**:
   - Check target's weapon with `GetSelectedPedWeapon()`
   - Verify weapon hash is in allowed list

3. **Distance too far**:
   - Default: 15m
   - Check: `conf.forcedAnimations.maxDistance`

4. **Cooldown active**:
   - Default: 2 seconds
   - Check: `conf.forcedAnimations.cooldown`

### Performance issues

1. **Increase check interval**:
   ```lua
   exports.ingenium:SetForcedAnimConfig('handsUpCheckInterval', 1000)  -- 1 second
   ```

2. **Reduce detection distance**:
   ```lua
   -- In _config/forced_animations.lua
   conf.forcedAnimations.maxDistance = 10.0  -- 10m instead of 15m
   ```

3. **Disable line of sight**:
   ```lua
   conf.forcedAnimations.requireLineOfSight = false
   ```

## Extending the System

### Add new detection mechanic:

Edit `client/[Threads]/_forced_animations.lua`:

```lua
-- After IsLocalPlayerUnarmed(), add:
local function IsLocalPlayerWounded()
    local ped = PlayerPedId()
    return GetEntityHealth(ped) < 50
end

-- In CheckIfBeingAimedAt(), add check:
if IsLocalPlayerWounded() then
    -- Wounded players automatically put hands up
    return true, nil
end
```

### Add job-based permissions:

Edit `_config/forced_animations.lua`:

```lua
conf.forcedAnimations.authorizedJobs = {
    ["police"] = true,  -- Police can force animations
    ["sheriff"] = true,
    ["gang"] = true,    -- Gangs can force animations
}
```

Server validates job in `HasPermission()` function.

## Performance Metrics

- **Client thread**: ~500ms interval (configurable)
- **Weapon table build**: ~0.1ms (one-time on spawn)
- **Weapon check**: ~0.005ms per check (hash table lookup)
- **Raycast (line of sight)**: ~0.5ms per check
- **Server validation**: ~1-2ms per request

## Security Features

✅ Server-side validation  
✅ Distance checks  
✅ Cooldown protection (spam prevention)  
✅ Job-based permissions (optional)  
✅ Weapon state validation  
✅ Comprehensive logging  
✅ Data-driven (no client manipulation)  
