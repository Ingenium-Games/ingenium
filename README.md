# Ingenium

**Proprietary Game Framework**

© 2021-2026 Ingenium Games. All rights reserved.

**This is closed-source proprietary software. ** Unauthorized copying, distribution, modification, or use is strictly prohibited.

---

## ⚠️ Legal Notice

This software is the exclusive property of Ingenium Games and is protected by copyright law. 

**All Rights Reserved. ** This codebase is **NOT** licensed under open-source terms. Use is restricted to authorized personnel only.

### Third-Party Dependencies

This project integrates the following open-source libraries, which retain their original licenses:

- **[pmc-callbacks](https://github.com/pitermcflebor/pmc-callbacks)** by [@pitermcflebor](https://github.com/pitermcflebor) - MIT License
- **[PolyZone](https://github.com/mkafrin/PolyZone)** by [@mkafrin](https://github.com/mkafrin) - Integrated as `ig.zone` - MIT License
- **[Vue. js 3](https://github.com/vuejs/core)** - MIT License
- **[Pinia](https://github.com/vuejs/pinia)** - MIT License
- **[Vite](https://github.com/vitejs/vite)** - MIT License
- **[TailwindCSS](https://github.com/tailwindlabs/tailwindcss)** - MIT License
- **[vuedraggable](https://github.com/SortableJS/vue.draggable. next)** - MIT License

For full license texts of third-party dependencies, please refer to their respective repositories.

---

## Overview

**Ingenium** is the core framework powering the Ingenium Games FiveM server, built with a modern **single-Vue application architecture**. All UI components are developed using **Vue 3** and managed through **Pinia** state management, ensuring a cohesive, performant, and maintainable frontend experience.

### Core Philosophy

Ingenium follows a **Vue-first approach**:
- All new UI features **must** be implemented as Vue 3 components
- State management **must** use Pinia stores
- No standalone HTML/jQuery implementations should be added
- All NUI interfaces render through the centralized Vue application

---

## Architecture

### How It Works

Data tables (`xPlayer`, `xVehicle`, `xPed`, `xObject`) are stored server-side for each entity, with the entity as the key and data as the table value. 

Any update to an entity's data table on the server triggers the entity state to be updated and replicated via **StateBags**. Since StateBags are accessible by the client, there's no need to manually pass data to the client for any entity. 

From the data tables, the server asynchronously saves data to the SQL database at scheduled intervals using an integrated **MySQL2 connection pool** with prepared statements for optimal performance and security.

### Requirements

- **FiveM Server** with [OneSync Infinity](https://docs.fivem.net/docs/scripting-reference/onesync/) enabled (required)
- **MySQL 5.7+** or **MariaDB 10.3+**
- **Node.js 18+** (for NUI development)

> ⚠️ **Important:** OneSync Infinity is **mandatory**. Enable it in txAdmin or set `+onesync on` in your server configuration.

---

## 📚 Documentation

Comprehensive documentation is organized within the repository:

- **[User Documentation](./Documentation/README.md)** - API references, guides, and usage examples
- **[Implementation Documentation](./Implementations/README.md)** - Technical implementation details for contributors
- **[Contributing Guidelines](./CONTRIBUTING.md)** - Standards and procedures for development
- **[Wiki](https://github.com/Ingenium-Games/ore/wiki)** - Function references and event documentation

### Quick Links

| Topic | Location |
|-------|----------|
| **SQL Architecture** | [`Documentation/SQL_Architecture.md`](./Documentation/SQL_Architecture.md) |
| **SQL API Reference** | [`Documentation/SQL_API_Reference.md`](./Documentation/SQL_API_Reference.md) |
| **Security Guide** | [`Documentation/Security_Guide.md`](./Documentation/Security_Guide.md) |
| **Validation System** | [`Documentation/Validation_Architecture.md`](./Documentation/Validation_Architecture.md) |
| **Discord Integration** | [`Documentation/Discord_Integration_QuickStart.md`](./Documentation/Discord_Integration_QuickStart.md) |
| **Zone Management** | [`Documentation/Zone_Management.md`](./Documentation/Zone_Management.md) |
| **i18n & Debugging** | [`Documentation/I18N_AND_DEBUGGING.md`](./Documentation/I18N_AND_DEBUGGING.md) |
| **NUI/Vue System** | [`nui/README.md`](./nui/README.md) |
| **NUI Architecture** | [`nui/ARCHITECTURE.md`](./nui/ARCHITECTURE.md) |

---

## 🎨 Vue 3 Single-App Architecture

### Overview

Ingenium uses a **unified Vue 3 application** for all NUI components.  This architecture provides:

- **Single Page Application (SPA)**: All UI lives in one NUI resource
- **Pinia State Management**:  Centralized reactive state across all components
- **Component-Based Design**: Modular, reusable Vue components
- **Hot Module Replacement (HMR)**: Rapid development iteration
- **TypeScript Ready**: Full type safety support

### Technology Stack

| Technology | Purpose |
|------------|---------|
| **Vue 3** | Reactive UI framework with Composition API |
| **Pinia** | Lightweight, intuitive state management |
| **Vite** | Fast build tool with HMR |
| **TailwindCSS** | Utility-first styling framework |
| **vuedraggable** | Drag-and-drop inventory system |

### NUI Structure

```
nui/
├── src/
│   ├── components/          # Vue 3 components (notifications, menus, HUD, etc.)
│   ├── stores/              # Pinia stores (ui, character, notifications, appearance, etc.)
│   ├── utils/               # Helper functions and NUI message handlers
│   ├── App.vue              # Root application component
│   ├── main.js              # Application entry point
│   └── style.css            # Global styles (TailwindCSS)
├── inventory/               # Standalone inventory Vue app
├── dist/                    # Compiled production build
├── lua/                     # Lua export API for client-side integration
├── package.json             # Node dependencies
└── vite.config. js           # Vite build configuration
```

### Development Workflow

1. **Navigate to NUI directory**: 
   ```bash
   cd nui
   npm install
   ```

2. **Development with HMR**:
   ```bash
   npm run dev
   ```
   Starts dev server at `http://localhost:3000` with hot reload.

3. **Build for production**:
   ```bash
   npm run build
   ```
   Compiles optimized bundle to `dist/` directory.

4. **Watch mode** (auto-rebuild):
   ```bash
   npm run watch
   ```

For detailed NUI documentation, see [`nui/README.md`](./nui/README.md) and [`nui/ARCHITECTURE.md`](./nui/ARCHITECTURE. md).

---

## Code Formatting Standards

Consistency is critical for maintainability. All code **must** follow these standards:

### Lua Standards

- **Variables**: `lowercase`
  ```lua
  local myVariable = {}
  ```

- **Functions**: `UpperCamelCase`
  ```lua
  --- Retrieves player data by ID
  -- @param playerId number The player's server ID
  -- @return table Player data object
  function GetPlayerData(playerId)
      return playerDataTable[playerId]
  end
  ```

- **Documentation**: All functions **must** include: 
  - Description of purpose
  - `@param` annotations with type and description
  - `@return` annotations (if applicable)
  - Example usage in wiki pages

  **Example**:
  ```lua
  --- Applies damage to a vehicle
  -- @param vehicle number Entity ID of the vehicle
  -- @param damage number Damage amount (0-1000)
  -- @return boolean Success status
  function ApplyVehicleDamage(vehicle, damage)
      if not DoesEntityExist(vehicle) then
          return false
      end
      SetVehicleEngineHealth(vehicle, damage)
      return true
  end
  ```

### SQL Standards

- **Tables**: `lowercase`
- **Columns**: `Capitalized`

  ```sql
  INSERT INTO `job_accounts` (`Name`, `Description`, `Boss`, `Members`, `Accounts`) VALUES (?, ?, ?, ?, ?)
  ```

- **Always use parameterized queries** (positional `?` or named `@param`):

  ✅ **Correct**:
  ```lua
  local data = "xyz"
  ig.sql.Update("UPDATE `table` SET `Column1` = ? WHERE X = ?", {data, id})
  ```

  ❌ **Incorrect** (SQL injection risk):
  ```lua
  local data = "Cool Story Bro"
  ig. sql.Update("UPDATE `table` SET `Column1` = ".. data, {})
  ```

### JavaScript/Vue Standards

- **Variables**: `camelCase`
  ```javascript
  let myVariable = 42
  ```

- **Functions**: `UpperCamelCase`
  ```javascript
  /// Formats currency value
  /// @param value number The numeric value
  /// @return string Formatted currency string
  function FormatCurrency(value) {
      return `$${value.toLocaleString()}`
  }
  ```

- **Documentation**: Use JSDoc-style comments

  ```javascript
  /**
   * Sends a message to the NUI backend
   * @param {string} message - The message type
   * @param {object} data - Data payload
   */
  function SendNuiMessage(message, data) {
      // implementation
  }
  ```

### Vue Component Standards

- **Single File Components (SFC)** required for all new UI
- **Composition API** preferred over Options API
- **Pinia stores** for all stateful logic
- **`<script setup>`** syntax for cleaner code

**Example**:
```vue
<template>
  <div class="my-component">
    <h1>{{ title }}</h1>
    <button @click="HandleClick">Click Me</button>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useMyStore } from '../stores/myStore'

const myStore = useMyStore()
const title = ref('Hello World')

/**
 * Handles button click event
 */
function HandleClick() {
  myStore.incrementCounter()
}
</script>

<style scoped>
.my-component {
  padding: 20px;
}
</style>
```

---

## Wiki Guidelines

The [Wiki](https://github.com/Ingenium-Games/ore/wiki) provides function references and usage examples. 

### Requirements for Wiki Entries

1. **Function Naming**: All functions **must** follow `UpperCamelCase` convention
   - ❌ `get_player_data()`
   - ✅ `GetPlayerData()`

2. **Parameter Documentation**: Every function must document:
   - Parameter name
   - Type
   - Description

3. **Working Examples**:  Each wiki page **must** include a complete, functional code example

   **Example Wiki Entry**: 

   ```markdown
   ## GetPlayerMoney

   Retrieves the current cash amount for a player.

   ### Parameters
   - `playerId` (number): The server ID of the player

   ### Returns
   - `number`: The player's cash amount

   ### Example
   ```lua
   local playerId = source
   local cash = GetPlayerMoney(playerId)
   print("Player " .. playerId .. " has $" .. cash)
   ```
   ```

4. **Missing Information**: Some wiki pages currently lack complete examples or proper function naming.  These **must** be updated.

---

## Configuration

### Database Connection

Add **one** of the following to your `server.cfg`:

**Option 1: Connection String (Recommended)**
```bash
set mysql_connection_string "mysql://user:password@host:port/database"
set mysql_connection_limit "10"
```

**Option 2: Individual Parameters**
```bash
set mysql_host "localhost"
set mysql_port "3306"
set mysql_user "your_user"
set mysql_password "your_password"
set mysql_database "your_database"
set mysql_connection_limit "10"
```

> ⚠️ **Security Warning:** **NEVER** use the `root` database user. Create a dedicated user with minimal required privileges.

For detailed configuration, see [`Documentation/SQL_Architecture.md`](./Documentation/SQL_Architecture.md).

### Locale Configuration

Set your preferred language in `_config/config.lua`:

```lua
conf.locale = "en"  -- Options: "en", "fr", "es", "de", "pt"
```
---

## Database Optimization

### MySQL Performance

The integrated MySQL2 system includes: 
- Connection pooling with configurable limits
- Automatic query profiling
- Slow query detection (>150ms)
- Prepared statement caching
- Real-time performance statistics

**Console Command**:
```
sqlstats
```

Displays query execution metrics and performance statistics.

### Save System

The **dirty flag system** ensures efficient database writes:

- **Dirty Tracking**: Only changed data is saved (60-80% reduction in writes)
- **Optimized Intervals**:
  - Player data: **90 seconds**
  - Vehicles: **5 minutes**
  - Jobs: **10 minutes**
  - Objects: **5 minutes**
- **Prepared Statements**: Pre-compiled queries for maximum performance

For details, see [`Documentation/SQL_Performance.md`](./Documentation/SQL_Performance.md).

---

## Directory Structure

```
ingenium/
├── Documentation/          # User and API documentation
├── Implementations/        # Technical implementation details
├── [Example Doors]/        # Example door system implementation
├── [Example Items]/        # Example item definitions
├── [Stubs]/                # Development stubs and templates
├── _config/                # Configuration files
├── client/                 # Client-side Lua scripts
├── server/                 # Server-side Lua scripts
├── shared/                 # Shared Lua utilities
├── data/                   # Game data (peds, vehicles, items, etc.)
├── locale/                 # Localization files (en, fr, es, de, pt)
├── nui/                    # Vue 3 NUI system
│   ├── src/                # Vue source code
│   ├── inventory/          # Inventory Vue app
│   ├── dist/               # Compiled production build
│   └── lua/                # Lua API exports
├── db. sql                  # Database schema
├── fxmanifest.lua          # FiveM resource manifest
├── server.cfg              # Example server configuration
├── CONTRIBUTING.md         # Contribution guidelines
└── README.md               # This file
```

---

## Testing

Tested and verified on: 

- ✅ **Windows Server** (64-bit)
- ✅ **CentOS 8 Stream** (64-bit, RHEL distribution)

For NUI testing procedures, see [`nui/TESTING.md`](./nui/TESTING.md).

---

## Security

Security is a top priority.  Key features include:

- **Parameterized SQL Queries**: All database operations use prepared statements
- **StateBag Protection**: Server-side validation and access control
- **Input Validation**: Centralized validation system ([`Documentation/Validation_Architecture.md`](./Documentation/Validation_Architecture.md))
- **Rate Limiting**:  Built-in protection against abuse
- **Extensible Security API**: `ig.security` functions for custom protection

For complete security guidelines, see [`Documentation/Security_Guide.md`](./Documentation/Security_Guide.md).

---

## Development Status

Ingenium is under **active development**.  Some functions may change or break during updates. Always review release notes before updating.

> **Note**: Only use **official releases**. Cloning the `main` branch may result in unstable or incomplete features.

---

## Credits

Special thanks to:

- **[@pitermcflebor](https://github.com/pitermcflebor)** - [pmc-callbacks](https://github.com/pitermcflebor/pmc-callbacks) (MIT License)
- **[@mkafrin](https://github.com/mkafrin)** - [PolyZone](https://github.com/mkafrin/PolyZone) (MIT License), integrated as `ig.zone`

---

## Support

For authorized users: 

- **Bug Reports**: Contact internal development team
- **Documentation Issues**: Submit via internal channels
- **Feature Requests**:  Discuss with project maintainers

---

## Copyright

**© 2021-2026 Ingenium Games.  All rights reserved.**

**Twiitchter** - [https://github.com/Ingenium-Games](https://github.com/Ingenium-Games)

This software is proprietary and confidential.  Unauthorized use, reproduction, or distribution is strictly prohibited and may result in legal action.

---

*For reference to GTA V data structures, see [gta-v-data-dumps](https://github.com/DurtyFree/gta-v-data-dumps) as the authoritative source.*
