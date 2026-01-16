# Ingenium AI Coding Agent Instructions

## Project Overview

**Ingenium** is a proprietary FiveM framework built on a **class-based entity system** with **Vue 3 Single-App NUI architecture**. The server maintains all entity state (Players, Vehicles, NPCs, Objects, Jobs), automatically syncs to clients via StateBags, and persists to MySQL2 database at scheduled intervals for key data and uses file-based saving for heavily dynamic data.

**Key Constraint:** OneSync Infinity is mandatory for StateBag replication.

**Important:** This is closed-source proprietary software. Only authorized personnel should use this codebase.

---

## Critical Developer Workflows

### NUI Build & Deployment

**Never skip the build step.** The Vue app must be compiled to `nui/dist/index.html` for production:

```bash
cd nui
npm install          # Only on first setup or dependency changes
npm run build        # REQUIRED before committing UI changes
npm run watch        # For rapid development with auto-rebuild
npm run dev          # Dev server (HMR at localhost:3000, NOT for production)
```

**Key Pattern:** Dev server is for development iteration only. Always use `npm run build` for in-game testing. The built files are committed to git.

### Server Testing Workflow

1. **Check logs**: Console shows `ig.log.Info()` level messages during development
2. **Verify dirty flags**: Before assuming data won't save, check `GetIsDirty()` in SQL module
3. **Query stats**: Run `/sqlstats` command to see performance metrics and slow queries
4. **Validate immediately**: Use `ig.check.*` module during development to catch validation issues early

### Documentation Requirements (MANDATORY)

**Every PR that changes code must include documentation:**
- New functions → Add to `/Documentation/` API reference
- New events/exports → Add to `Documentation/SQL_Events_Exports.md`
- Architecture changes → Create/update `/Implementations/FEATURE_NAME.md`
- Update `Documentation/README.md` with new links
- **Missing documentation = PR BLOCKER**

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

### Server Structure (Detailed)

**Core Systems:**
- `server/[Classes]/*` — Entity classes: `_player.lua`, `_vehicle.lua`, `_npc.lua`, `_job.lua`, `_offline_player.lua`, `_blank_object.lua`
- `server/[SQL]/*` — Database layer: `_pool.js`, `_query.js`, `_handler.lua`, `_saves.lua`, `_character.lua`, `_jobs.lua`, `_vehicles.lua`
- `server/[Validation]/*` — Centralized validation system using `ig.check.*` module
- `server/[Events]/*` — Event handlers, particularly character lifecycle (load/unload)
- `server/[Data - Save to File]/*` — JSON-based persistence (drops, pickups, scenes)
- `server/[Data - No Save Needed]/*` — Runtime-only data structures
- `server/[Security]/*` — Anti-exploit systems and StateBag protection
- `server/[API]/*` — Public exports and API endpoints

**Key Files:**
- `server/_var.lua` — Global namespace initialization (`ig.*`)
- `server/_data.lua` — Entity index management (`ig.pdex`, `ig.vdex`, `ig.ndex`, `ig.odex`, `ig.jdex`)
- `server/_save_routine.lua` — Dirty flag checking and ConsolidatedSaveLoop
- `server/_functions.lua` — Utility functions and helpers
- `server/_payroll.lua` — Job account management

**Config System:**
- `_config/config.lua` — Master configuration with all intervals
- `_config/defaults.lua` — Default values (fallback)
- `_config/disable.lua` — Feature toggles for disabling systems

### Client Structure

- `client/[Target]/*` — Interaction system integration
- `client/[Zones]/*` — PolyZone wrapper (`ig.zone.Add()`, `ig.zone.Check()`)
- `client/[Garage]/*` — Vehicle management reference implementation
- `client/[Events]/*` — Event listeners for server-client communication
- `client/_vehicle.lua` — StateBag-based vehicle state reading
- `client/_data.lua` — Client-side data initialization and listeners

### NUI Structure

**Vue Application:**
- `nui/src/components/` — Vue 3 SFCs: CharacterSelect, Menu, HUD, ContextMenu, InputDialog, NotificationContainer
- `nui/src/stores/` — Pinia stores (ui.js, character.js, notifications.js, appearance.js)
- `nui/src/utils/nui.js` — Centralized NUI message handler (all `SendNUIMessage` → Vue router)
- `nui/src/App.vue` — Root component with conditional rendering
- `nui/lua/ui.lua` — Export API (`exports['ingenium']:ShowMenu()`, etc.)

**Build Artifacts:**
- `nui/dist/index.html` — Compiled production bundle (committed to git)
- `nui/vite.config.js` — Build configuration with HMR settings

### Shared & Data

- `shared/` — Cross-platform Lua utilities
- `data/` — JSON game data: `items.json`, `vehicles.json`, `weapons.json`, `jobs.json`, `peds.json`, `tattoos.json`
- `locale/` — Internationalization files: `en.lua`, `fr.lua`, `es.lua`, `de.lua`, `pt.lua`

---

## Recent System Updates (2026)

### Character Connection System (January 2026)
- Fixed 8 critical issues in character selection, loading, and initialization lifecycle
- Improved client-server synchronization for character state
- See `Documentation/CHARACTER_CONNECTION_FIXES.md` for technical details

### Internationalization & Debugging (2025)
- Multi-language support with locale system (`conf.locale` in `config.lua`)
- Enhanced error tracking with file paths, line numbers, and resource context
- Structured debug levels: ERROR, WARN, INFO, DEBUG, TRACE
- See `Documentation/I18N_AND_DEBUGGING.md` for implementation

### Banking & Loan System (2025)
- Integrated banking account management
- Loan system with repayment tracking
- See `Documentation/BANKING_LOAN_SYSTEM_IMPLEMENTATION.md`

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

- **Server**: Load resource, check console for `ig.log.Info()` logs 
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
- [Documentation/I18N_AND_DEBUGGING.md](../Documentation/I18N_AND_DEBUGGING.md) — Localization and debug system
- [nui/ARCHITECTURE.md](../nui/ARCHITECTURE.md) — NUI component hierarchy & data flow
- [CONTRIBUTING.md](../CONTRIBUTING.md) — Code standards & documentation requirements
- [server/_data.lua](../server/_data.lua) — Data loading patterns
- [server/[SQL]/_saves.lua](../server/[SQL]/_saves.lua) — Dirty flag save system

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
9. **Modifying Read-Only Data:** Static reference data (weapons, vehicles, tattoos, peds, appearance-constants) is protected via `MakeReadOnly()` — don't try to modify
10. **Forgetting NUI Build:** Always run `npm run build` after UI changes before committing; dev server is for development only

---

## Resources

- **[Ingenium README](../README.md)** — High-level overview
- **[Documentation Hub](../Documentation/README.md)** — All system documentation
- **[NUI Quick Start](../nui/README.md)** — Vue 3 setup and components
