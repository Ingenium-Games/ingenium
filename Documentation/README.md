# Ingenium Framework Documentation

## Overview

Ingenium is a **proprietary FiveM framework** built on a class-based entity system with Vue 3 Single-App NUI architecture. The server maintains all entity state, automatically syncs to clients via StateBags, and persists to MySQL2 database with dirty flag optimization.

**Key Constraint:** OneSync Infinity is mandatory for StateBag replication.

**Important:** This is closed-source proprietary software. Only authorized personnel should use this codebase.

## Core Architecture

### Entity System

Ingenium uses **server-authoritative entities** where all game state flows through class instances:

- **Dual-Update Pattern** - Setters update both internal state AND StateBags automatically
- **Dirty Flag Optimization** - Only changed entities saved to database
- **StateBag Replication** - Clients receive real-time updates via StateBags
- **Validation Layer** - All client data validated before processing

**Entities:** Player, OwnedVehicle, Vehicle, Job, NPC, BlankObject, ExistingObject, OfflinePlayer (8 types total)

### Phone System
- **[Phone Apps: Calculator & Email](./PHONE_APPS_CALCULATOR_EMAIL.md)** - Calculator and Email applications for the in-game phone

### SQL & Database
- **[SQL Architecture](./SQL_Architecture.md)** - Overview of the integrated MySQL2 SQL system
- **[SQL API Reference](./SQL_API_Reference.md)** - Complete API documentation for SQL operations
- **[SQL Migration Guide](./SQL_Migration_Guide.md)** - Step-by-step migration from mysql-async
- **[SQL Events & Exports](./SQL_Events_Exports.md)** - Server events, exports, and commands
- **[SQL Performance](./SQL_Performance.md)** - Performance optimization and monitoring
- **[SQL Compatibility](./SQL_Compatibility.md)** - Legacy MySQL.Async compatibility layer

[Learn more: Class System →](Class_System.md)

### Data Persistence

**Hybrid Model** combining SQL and JSON:

- **SQL Database** - Player data, vehicles, banking, jobs
- **JSON Files** - Drops, pickups, scenes, notes, GSR
- **ConsolidatedSaveLoop** - Single-threaded scheduler with interval-based saves
- **Reference Data** - Protected read-only static data

Save intervals:
- Players: 90 seconds
- Vehicles: 5 minutes
- Jobs: 10 minutes
- Objects: 5 minutes

[Learn more: Data Persistence →](Data_Persistence.md)

### SQL Database Layer

Integrated **MySQL2 system** with:

- Connection pooling (configurable limit)
- Prepared statements for frequent queries
- Transaction support (ACID compliance)
- Performance monitoring & slow query detection
- Batch operations
- Exponential backoff connection ready check

[Learn more: SQL System →](SQL_System.md)

### Security & Validation

**Defense-in-depth approach:**

- **ig.check module** - Type validation (Number, String, Boolean, Table)
- **ig.validation module** - Inventory integrity checks (duplication/injection detection)
- **StateBag Protection** - Whitelist + Blacklist dual-layer security
- **Rate Limiting** - Per-player, per-type transaction cooldowns
- **Exploit Logging** - Automatic ban on detected violations

All client data validated before processing. Server is always authority.

[Learn more: Validation & Security →](Validation_Security.md)

## User Interface

### NUI Vue 3 Architecture

**Centralized Single-App System:**

- All UI components render through one Vue 3 application
- Pinia stores manage state (ui, character, notifications, chat, etc.)
- SendNUIMessage for Lua → Vue broadcasts
- RegisterNUICallback for Vue → Lua requests
- TailwindCSS for styling
- Vite build system with HMR

**Components:** Chat, HUD, Menu, Phone, CharacterSelect, Banking, Job Management, Appearance Editor

**Critical:** Always run `npm run build` before committing UI changes.

[Learn more: NUI Architecture →](NUI_Architecture.md)

### Callback System

**Bidirectional communication:**

- Promise-based async/await patterns
- Security tickets (one-time use, 30s expiration)
- Timeout handling with automatic cleanup
- Rate limiting to prevent spam
- Duplicate request prevention

**Patterns:** Await (blocking), Async (non-blocking), AsyncWithTimeout

[Learn more: Callback System →](Callback_System.md)

## System Documentation

### Core Systems

| System | Description |
|--------|-------------|
| [Class System](Class_System.md) | Entity lifecycle, dirty flags, StateBag sync |
| [SQL System](SQL_System.md) | Database layer, queries, prepared statements |
| [Data Persistence](Data_Persistence.md) | Hybrid SQL+JSON, save loops, indexes |
| [Validation & Security](Validation_Security.md) | Input validation, exploit detection, rate limiting |
| [NUI Architecture](NUI_Architecture.md) | Vue 3 UI, Pinia stores, component system |
| [Callback System](Callback_System.md) | Client-server communication, promises, events |

### Feature Systems

| System | Description | Documentation |
|--------|-------------|---------------|
| [Inventory System](Inventory_System.md) | Item management with multi-layer validation | ✅ Complete |
| [Zone Management](Zone_Management.md) | PolyZone integration, IPL loading | ✅ Complete |
| [Target System](Target_System_Configuration.md) | Configurable targeting icons, vehicle bone targets | ✅ Complete |
| [Vehicle HUD](Vehicle_HUD_System.md) | Speed and fuel display for drivers | ✅ Complete |
| Appearance System | Character customization with live preview | ⏳ Doc pending |
| Job Management | Job accounts, employees, payroll | ⏳ Doc pending |
| Drop/Pickup System | World items, loot spawns | ⏳ Doc pending |
| Door System | Door locks, access control | ⏳ Doc pending |
| Voice/VOIP System | Proximity voice, radio | ⏳ Doc pending |

### Supporting Systems

| System | Description | Documentation |
|--------|-------------|---------------|
| [Logging & i18n](Logging_Internationalization.md) | Multi-level logging, 5-language support | ✅ Complete |
| Threading & Performance | SetTimeout chains, consolidated loops | ⏳ Doc pending |
| Banking & Loans | Banking system with interest/overdrafts | ⏳ Doc pending |

## Function Reference (Wiki)

The **[wiki](wiki/)** directory contains 400+ function documentation files:

- **ig.appearance** - Character customization (60+ functions)
- **ig.callback** - Callback system (10 functions)
- **ig.data** - Entity data helpers (30+ functions)
- **ig.sql** - Database queries (20+ functions)
- **ig.validation** - Input validation (10 functions)
- **ig.func** - Utility functions (50+ functions)
- **ig.item** - Item system (40+ functions)
- **ig.job** - Job management (25+ functions)
- **ig.vehicle** - Vehicle system (30+ functions)

See [wiki/README.md](wiki/README.md) for complete function index.

## Quick Start

### Prerequisites

```
- FiveM Server (latest recommended)
- OneSync Infinity enabled (REQUIRED)
- MySQL 5.7+ or MariaDB 10.3+
- Node.js 16+ (for NUI development)
```

### Configuration

**Locale** (`_config/config.lua`):
```lua
conf.locale = "en"  -- Options: en, fr, es, de, pt
```

**MySQL Connection** (`server.cfg`):
```bash
# Connection string
set mysql_connection_string "mysql://user:password@host:port/database"

# OR individual parameters
set mysql_host "localhost"
set mysql_port "3306"
set mysql_user "root"
set mysql_password "password"
set mysql_database "fivem"
set mysql_connection_limit "10"
```

**Save Intervals** (`_config/config.lua`):
```lua
conf.serversync     = 90000   -- Players: 90 seconds
conf.vehiclesync    = 300000  -- Vehicles: 5 minutes
conf.jobsync        = 600000  -- Jobs: 10 minutes
conf.objectsync     = 300000  -- Objects: 5 minutes
```

### NUI Development

```bash
cd nui
npm install          # First time only
npm run build        # REQUIRED before committing
npm run watch        # Auto-rebuild on changes
npm run dev          # Dev server with HMR (NOT for production)
```

## Developer Workflows

### Adding a New Feature

1. **Create Entity Method** (if needed in `server/[Classes]/`)
   - Use `ig.check.Type()` validation
   - Update both `self.Property` and `self.State.Property`
   - Set `self.IsDirty = true` and `self.DirtyFields.fieldName = true`

2. **Add Server Logic** (events in `server/[Events]/` or callbacks)
   - Retrieve entity via `ig.data.GetEntity()` helpers
   - Validate permissions (statebag + role checks)

3. **Add Client UI** (if needed, Vue component in `nui/src/components/`)
   - Create store in `nui/src/stores/` if managing state
   - Use TailwindCSS for styling (no raw CSS)
   - Register NUICallback in `nui/lua/ui.lua`

4. **Update Documentation**
   - Create `/Documentation/FEATURE_NAME.md` for user docs
   - Update this README with links

### Testing Changes

- **Server**: Load resource, check console for `ig.log.Info()` logs
- **Client**: Use `ig.debug` commands in chat; read from StateBags
- **Database**: Verify dirty flags saved via `/sqlstats` command
- **NUI**: Build with `npm run build`, test in-game

## Directory Structure

### Server

```
server/
├── [Classes]/           # Entity classes (Player, Vehicle, Job, etc.)
├── [SQL]/               # Database layer (queries, saves, handlers)
├── [Validation]/        # Input validation (ig.check, ig.validation)
├── [Security]/          # StateBag protection, rate limiting
├── [Events]/            # Event handlers (character, vehicle, etc.)
├── [Callbacks]/         # Callback handlers (banking, inventory, etc.)
├── [Data - Save to File]/   # JSON-based persistence
├── [Data - No Save Needed]/ # Runtime-only data
├── [API]/               # Public exports
├── [Commands]/          # Chat commands
├── _data.lua            # Entity indexes, load/save routines
├── _var.lua             # Global namespace (ig.*)
├── _functions.lua       # Utility functions
└── _save_routine.lua    # Periodic save loops
```

### Client

```
client/
├── [Callbacks]/         # Client-side callback handlers
├── [Events]/            # Client event listeners
├── [Target]/            # ox_target integration
├── [Zones]/             # PolyZone wrapper
├── [Garage]/            # Vehicle management
├── [Voice]/             # VOIP system
├── _data.lua            # Client data initialization
└── _vehicle.lua         # StateBag-based vehicle state reading
```

### NUI

```
nui/
├── src/
│   ├── main.js          # Vue app initialization
│   ├── App.vue          # Root component
│   ├── components/      # Vue 3 SFCs (20+ components)
│   ├── stores/          # Pinia stores (8 stores)
│   └── utils/nui.js     # NUI message handler
├── lua/
│   ├── ui.lua           # Export API
│   └── NUI-Client/      # Callback handlers
├── dist/                # Built production files (committed)
├── vite.config.js       # Build configuration
└── package.json
```

### Shared & Data

```
shared/               # Cross-platform Lua utilities
data/                 # JSON game data (items, vehicles, weapons, jobs, etc.)
locale/               # Internationalization (en, fr, es, de, pt)
_config/              # Configuration files
```

## Code Style Conventions

### Lua

- **Variables:** camelCase (`local playerName`)
- **Constants:** UPPER_SNAKE_CASE (`local MAX_HEALTH = 100`)
- **Functions:** PascalCase (global), camelCase (local)
- **Indentation:** 4 spaces (no tabs)

### JavaScript (NUI)

- **Const/Let:** No `var`
- **Arrow functions:** For callbacks
- **Async/Await:** Use for promises, no `.then()`

## Common Pitfalls

1. **Setting State Directly** - Use entity setters, not `self.State.X = value`
2. **Client Authority** - Never trust client data without validation
3. **Missing Dirty Flags** - Forget `self.IsDirty = true` → data won't persist
4. **Creating Too Many Threads** - Use SetTimeout chains instead
5. **Ignoring Hybrid Data Loading** - Use JSON files for dynamic data
6. **UI in Old HTML** - Add Vue components to `nui/src/components/`
7. **Skipping Validation** - `ig.check` module prevents exploits
8. **Manual SQL Persistence** - Rely on dirty flags + ConsolidatedSaveLoop
9. **Modifying Read-Only Data** - Static data protected via `MakeReadOnly()`
10. **Forgetting NUI Build** - Always `npm run build` before committing

## Performance Optimization

### Threading Guidelines

- **Avoid CreateThread** for recurring tasks
- **Use SetTimeout chains** for repeating intervals
- **One master loop** handles multiple save operations
- **Only create threads** for long-running blocking operations

### Data Loading Patterns

1. **Load JSON files first** (immediate availability)
2. **Load database data on-demand** (for entities accessed by player)
3. **Job data at startup** (static, cached in memory)

### Save Optimization

- **Dirty flags** - Only save changed entities
- **Batch writes** - Group related updates
- **Prepared statements** - Pre-compile frequent queries
- **Deferred saves** - Write on intervals, not per-change
- **Consolidated loop** - Single scheduler thread

## Security Best Practices

1. **Always validate client data** - Use `ig.check.*` on all inputs
2. **Server is authority** - Never trust client state
3. **Validate existence** - Check items exist in database
4. **Clamp ranges** - Use min/max bounds on numbers
5. **Rate limit operations** - Prevent spam/abuse
6. **Log exploits** - Track and ban violators
7. **Sanitize logs** - Remove newlines from user input
8. **Protect StateBags** - Whitelist + blacklist approach
9. **Current state validation** - Use GetInventory(), not cached data
10. **One-time tickets** - Callbacks use expiring security tokens

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for:
- Code style and standards
- Documentation requirements
- Pull request process
- Testing requirements

## Support & Resources

- **Report Issues:** GitHub Issues
- **Implementation Details:** [Implementations](../Implementations/) folder
- **Function Reference:** [wiki](wiki/) directory (400+ functions)
- **Contributing:** [CONTRIBUTING.md](../CONTRIBUTING.md)

---

**Last Updated:** 2026-01-20

**Documentation Status:** Core systems documented, feature systems in progress.
