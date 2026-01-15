# Ingenium AI Coding Agent Instructions

## Project Overview

**Ingenium** is a FiveM framework built on a **class-based entity system** with **Vue 3 Single-App NUI architecture**. The server maintains all entity state (Players, Vehicles, NPCs, Objects, Jobs), automatically syncs to clients via StateBags, and persists to MySQL2 database at scheduled intervals for key data and uses file based saving for data that is hevily dynamic

**Key Constraint:** OneSync Infinity is mandatory for StateBag replication.

---

## Core Architecture Patterns

### 1. Class-Based Entity System (Server Authority)

All entities use a **dual-update pattern** where setters automatically sync to both internal state AND StateBags:

```lua
-- server/[Classes]/_player.lua
self.SetHealth = function(v)
    local n = ig.check.Number(v, 0, 100)
    if self.Health ~= n then
        self.Health = n              -- Update server state
        self.State.Health = n         -- Replicate to clients
        self.IsDirty = true           -- Mark for database save
    end
end
```

**Critical Rules:**
- Use getters/setters (`xPlayer.SetHealth()`, NOT `xPlayer.State.Health = 100`)
- Never trust client data; always validate via `ig.check.*` module
- Mark changes as dirty (`self.IsDirty = true`) for async database persistence
- Clients read StateBags, never write critical keys

### 2. Centralized Vue 3 NUI System

All UI components render through a single Vue 3 application (`nui/dist/index.html`). State is managed by **Pinia stores** (character, notifications, ui).

**Data Flow:**
```
Lua: exports['ingenium']:ShowMenu({...})
  ↓
SendNUIMessage("menu:show")
  ↓
Vue: nui/src/utils/nui.js listener
  ↓
uiStore.openMenu(data)
  ↓
Menu.vue displays, user selects
  ↓
sendNuiMessage("menu:select") back to Lua
  ↓
Lua: RegisterNUICallback(..., cb)
```

**When adding UI:** Always create Vue components in `nui/src/components/`, store state in Pinia (`nui/src/stores/`), use TailwindCSS only.

### 3. Data Persistence: Hybrid Database + File-Based Model

Ingenium uses a **dual persistence strategy**:
- **Database**: Player, Vehicle, Job data persisted via dirty flags on configurable intervals
- **File-Based**: Highly dynamic data (drops, pickups, scenes, notes, GSR) persisted to JSON

**Dirty Flag System** (server/[SQL]/_saves.lua):
```lua
-- Entity changes trigger dirty flag (automatic via setters)
xPlayer.AddCash(100)  -- Sets IsDirty = true

-- Saves run on intervals via ConsolidatedSaveLoop (minimal threads):
conf.serversync     = 90000  -- Players: 90 seconds
conf.vehiclesync    = 300000 -- Vehicles: 5 minutes
conf.jobsync        = 600000 -- Jobs: 10 minutes
conf.objectsync     = 300000 -- Objects: 5 minutes

-- Only dirty entities are saved (ig.sql.save.Users(), etc.)
-- Check GetIsDirty() before saving to database
```

**File-Based Data** (server/_save_routine.lua):
```lua
-- Dynamic data saved to JSON files on interval (5 min default)
ig.json.Write('drops', ig.drop.MergeDropsForSave())
ig.json.Write('pickups', ig.picks)
ig.json.Write('scenes', ig.scenes)

-- Loaded at startup via ig.data.LoadJSONData()
```

**Key Pattern:** Data comes from **two sources** on startup:
- JSON files (for heavily dynamic data)
- Database (for persistent entity state)
- Review [server/_data.lua](../server/_data.lua) and [server/[SQL]/_saves.lua](../server/[SQL]/_saves.lua) for loading/saving patterns

---

## Directory Structure & Patterns

### Server
- `server/[Classes]/*` — Entity class definitions (Player, Vehicle, NPC, Object, Job)
- `server/[SQL]/*` — MySQL2 integration (pool, queries, transactions)
- `server/[Validation]/*` — Centralized validation via `ig.validation.Name(arg, rules)`
- `server/[Events]/*` — Event handlers, particularly character load/unload
- `server/_data.lua` — Entity index management (`ig.pdex`, `ig.vdex`, `ig.ndex`, `ig.odex`)
- `server/_save_routine.lua` — Dirty flag checking and async database saves

### Client
- `client/[Target]/*` — Interaction system (zones + target menu)
- `client/[Zones]/*` — PolyZone wrapper (`ig.zone.Add()`, `ig.zone.Check()`)
- `client/[Garage]/*` — Vehicle management example
- `client/_vehicle.lua` — Client-side vehicle reading from StateBags

### NUI
- `nui/src/components/` — Vue 3 components (CharacterSelect, Menu, HUD, etc.)
- `nui/src/stores/` — Pinia state (character.js, notifications.js, ui.js)
- `nui/src/utils/nui.js` — SendNUIMessage/NUI callback handler
- `nui/lua/ui.lua` — Export API (`exports['ingenium']:ShowMenu()`, `exports['ingenium']:Notify()`)

---

## Developer Workflows

### Adding a New Feature

1. **Create Entity Method** (if needed): Add setter in `server/[Classes]/_entity.lua`
   - Use `ig.check.Type()` validation
   - Update both `self.Property` and `self.State.Property`
   - Set `self.IsDirty = true` and `self.DirtyFields.fieldName = true`

2. **Add Server Logic**: Events in `server/[Events]/` or commands in `server/[Commands]/`
   - Retrieve entity via `ig.data.GetEntity()` helpers
   - Validate permissions (statebag + role checks)

3. **Add Client UI (if needed)**: Vue component in `nui/src/components/`
   - Create store in `nui/src/stores/` if managing state
   - Use TailwindCSS for styling (no raw CSS)
   - Register NUICallback in `nui/lua/ui.lua` for Lua triggers

4. **Update Documentation**: 
   - Create `/Documentation/FEATURE_NAME.md` for user docs
   - Create `/Implementations/FEATURE_NAME.md` for technical details
   - Update `/Documentation/README.md` with links

### Building NUI

```bash
cd nui
npm install
npm run build  # Creates nui/dist/index.html
```

The dev server is NOT used in production; always commit built files.

### Testing Changes

- **Server**: Load resource, check console for `ig.debug_1` logs
- **Client**: Use `ig.debug` commands in chat; read from StateBags with `Entity(ped).state.Property`
- **Database**: Verify dirty flags saved via `ig.sql` events or direct query

---

## Threading & Performance Guidelines

**Thread Usage Must Be Minimal:**
- Avoid creating new threads (`CreateThread`) for recurring tasks
- Use **SetTimeout chains** instead for repeating intervals (see ConsolidatedSaveLoop pattern)
- One master loop handles multiple save operations at different intervals (vs. 4 separate threads)
- Exception: Only create threads for long-running blocking operations (SQL queries that must not freeze)

**Data Loading Patterns:**
When implementing data loading, follow the hybrid model:

1. **Load JSON files first** (immediately available, no DB lag):
   ```lua
   ig.data.LoadJSONData(callback)  -- Loads drops, pickups, scenes, notes, GSR
   ```

2. **Load database data on-demand** (for entities accessed by player):
   ```lua
   -- Player data: loaded when player joins (from database)
   function ig.data.LoadPlayer(source, Character_ID)
       local xPlayer = ig.class.Player(source, Character_ID)  -- Fetches from DB
       ig.data.SetPlayer(source, xPlayer)
   end
   ```

3. **Job data: loaded at startup** (static, cached in memory):
   ```lua
   function ig.data.CreateJobObjects()
       local jobs = ig.job.GetJobs()  -- From database
       for k, v in pairs(jobs) do
           ig.jdex[k] = ig.class.Job(v)
       end
       ig.json.Write(conf.file.jobs, ig.jobs)  -- Sync to JSON
   end
   ```

---

## Code Style & Conventions

### Lua
- **Variables:** `camelCase` (local playerName)
- **Constants:** `UPPER_SNAKE_CASE` (local MAX_HEALTH = 100)
- **Functions:** `PascalCase` (function GlobalFunc), `camelCase` (local function helper)
- **Indentation:** 4 spaces (no tabs)
- **Comments:** Single `--`, documentation `---@param name type description`

### JavaScript (NUI)
- **Const/Let:** No `var`
- **Arrow functions:** For callbacks
- **Async/Await:** Use for promises, no `.then()`

---

## Security & Validation

**Always validate client-provided data:**

```lua
-- ❌ Bad: Direct client data
xPlayer.AddCash(data.amount)

-- ✅ Good: Validate then use
local amount = ig.check.Number(data.amount, 0, 1000000)
xPlayer.AddCash(amount)
```

**StateBag Protection:** Clients cannot modify critical keys (logged as exploit attempts). Use `ig.validation` for cross-resource trust boundaries.

---

## Key Files to Understand

- [Documentation/Class_System_Architecture.md](../Documentation/Class%20System%20Architecture.md) — Entity lifecycle & patterns
- [Documentation/SQL_Architecture.md](../Documentation/SQL_Architecture.md) — Database layer design
- [Documentation/Validation_Architecture.md](../Documentation/Validation_Architecture.md) — Input validation strategy
- [nui/ARCHITECTURE.md](../nui/ARCHITECTURE.md) — NUI component hierarchy & data flow
- [CONTRIBUTING.md](../CONTRIBUTING.md) — Code standards & documentation requirements

---

## Common Pitfalls

1. **Setting State Directly:** Use entity setters, not `self.State.X = value`
2. **Client Authority:** Never trust client data without validation
3. **Missing Dirty Flags:** Forget `self.IsDirty = true` → data won't persist to database
4. **Creating Too Many Threads:** Use SetTimeout chains instead for repeating tasks; reduces overhead
5. **Ignoring Hybrid Data Loading:** Don't load everything from database at startup; use JSON files for dynamic data (drops, scenes, notes, GSR)
6. **UI in Old HTML:** Add Vue components to `nui/src/components/`, not separate HTML files
7. **Skipping Validation:** `ig.check` module prevents type/range exploits
8. **Manual SQL Persistence:** Don't manually call SQL save functions; rely on dirty flags + ConsolidatedSaveLoop intervals

---

## Resources

- **[Ingenium README](../README.md)** — High-level overview
- **[Documentation Hub](../Documentation/README.md)** — All system documentation
- **[NUI Quick Start](../nui/README.md)** — Vue 3 setup and components
