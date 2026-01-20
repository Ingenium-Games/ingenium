# NUI Vue 3 Architecture

## Overview

Ingenium uses a **centralized Vue 3 Single-App NUI system** where all UI components render through a single application. State is managed by Pinia stores, and communication with Lua occurs via SendNUIMessage and RegisterNUICallback patterns.

## Application Structure

### Entry Point

```
nui/src/main.js → Initializes Vue 3 + Pinia → Mounts to #app
```

### Root Component

`nui/src/App.vue` conditionally renders all UI modules:

```vue
<template>
  <div id="app">
    <NotificationContainer />
    <Chat v-if="chatStore.visible" />
    <HUD v-if="uiStore.hudVisible" />
    <Menu v-if="uiStore.menuVisible" />
    <Phone v-if="phoneStore.visible" />
    <CharacterSelect v-if="characterStore.showSelector" />
    <!-- ... other components -->
  </div>
</template>
```

### Directory Structure

```
nui/
├── src/
│   ├── main.js                      # Vue app initialization
│   ├── App.vue                      # Root component
│   ├── components/
│   │   ├── Chat.vue
│   │   ├── HUD.vue
│   │   ├── Menu.vue
│   │   ├── Phone.vue
│   │   ├── CharacterSelect.vue
│   │   ├── InputDialog.vue
│   │   ├── ContextMenu.vue
│   │   ├── BankingMenu.vue
│   │   ├── GarageMenu.vue
│   │   ├── NotificationContainer.vue
│   │   ├── appearance/              # 8 sub-components
│   │   ├── job/                     # 6 sub-components
│   │   ├── phone/apps/              # Phone apps
│   │   └── target/                  # Target menu
│   ├── stores/                      # Pinia state stores
│   ├── utils/
│   │   └── nui.js                   # NUI communication
│   └── style.css
├── lua/
│   ├── ui.lua                       # Export API
│   └── NUI-Client/                  # Callback handlers
├── vite.config.js
└── package.json
```

## Pinia State Stores

### Store Architecture

| Store | State Managed |
|-------|---------------|
| **ui** | HUD (health, armor, hunger, thirst, stress, cash), Menu, Input dialog, Context menu |
| **character** | Character list, selected character, creation mode, character slots |
| **notifications** | Notification queue with auto-fade/removal |
| **chat** | Messages (100 limit), input, suggestions, visibility |
| **appearance** | Appearance data, models, tattoos, pricing, camera mode |
| **banking** | Balance, transactions, favorites, active tab, forms |
| **job** | Job data, employees, financials, memos, prices, locations |
| **phone** | Visibility, contacts, call history, active call, app state |

### Example Store (ui.js)

```javascript
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useUiStore = defineStore('ui', () => {
  // HUD state
  const health = ref(100)
  const armor = ref(0)
  const hunger = ref(100)
  const thirst = ref(100)
  const stress = ref(0)
  
  // Menu state
  const menuVisible = ref(false)
  const menuData = ref(null)
  
  // Actions
  function updateHUD(data) {
    health.value = data.health
    armor.value = data.armor
    hunger.value = data.hunger
    thirst.value = data.thirst
    stress.value = data.stress
  }
  
  function openMenu(data) {
    menuData.value = data
    menuVisible.value = true
  }
  
  function closeMenu() {
    menuVisible.value = false
    menuData.value = null
  }
  
  return {
    health, armor, hunger, thirst, stress,
    menuVisible, menuData,
    updateHUD, openMenu, closeMenu
  }
})
```

## NUI Communication Flow

### Lua → Vue (Broadcast)

**Method:** `SendNUIMessage()`

```lua
-- Client Lua
SendNUIMessage({
    message = "Client:NUI:MenuShow",
    data = {
        title = "Vehicle Menu",
        items = {
            {label = "Lock", action = "lock"},
            {label = "Unlock", action = "unlock"}
        }
    }
})
```

**Handler:** `nui.js` sets up listeners

```javascript
// nui/src/utils/nui.js
export function setupNuiHandlers() {
  window.addEventListener('message', (event) => {
    const { message, data } = event.data
    
    switch(message) {
      case 'Client:NUI:MenuShow':
        uiStore.openMenu(data)
        break
      case 'Client:NUI:ChatAddMessage':
        chatStore.addMessage(data)
        break
      // ... more handlers
    }
  })
}
```

### Vue → Lua (Callback)

**Method:** `sendNuiMessage()` or `callClientCallback()`

```javascript
// nui/src/utils/nui.js
export function sendNuiMessage(callback, data) {
  const resourceName = GetParentResourceName()
  
  fetch(`https://${resourceName}/${callback}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  })
}

export function callClientCallback(callback, ...args) {
  return sendNuiMessage(callback, args)
}
```

**Usage in Vue:**

```javascript
// Component
import { callClientCallback } from '@/utils/nui'

function selectMenuItem(item) {
  callClientCallback('NUI:Client:MenuSelect', item.action)
  uiStore.closeMenu()
}
```

**Lua Registration:**

```lua
-- client/[NUI]/NUI-Client/_menu.lua
RegisterNUICallback('NUI:Client:MenuSelect', function(data, cb)
    local action = data[1]
    
    if action == 'lock' then
        TriggerEvent('Client:Vehicle:Lock')
    end
    
    cb({ok = true})
end)
```

### Message Flow Diagram

```
┌─────────────┐   SendNUIMessage    ┌─────────────┐
│   Lua       │────────────────────→│   Vue/NUI   │
│  Client     │   {message, data}   │  Browser    │
└─────────────┘                     └─────────────┘
      ↑                                    │
      │                                    │
      │      RegisterNUICallback           │
      │      POST https://resource/cb      │
      └────────────────────────────────────┘
```

## Vue Components

### Top-Level Components

#### Chat Component

```vue
<template>
  <div class="chat-container">
    <div class="messages">
      <div v-for="msg in messages" :key="msg.id" class="message">
        {{ msg.text }}
      </div>
    </div>
    <input v-model="input" @keyup.enter="sendMessage" />
  </div>
</template>
```

Features:
- Message history (100 limit)
- Command suggestions
- Auto-fade after 10 seconds
- `/` prefix for commands

#### HUD Component

```vue
<template>
  <div class="hud">
    <div class="stat-bar health" :style="{width: health + '%'}"></div>
    <div class="stat-bar armor" :style="{width: armor + '%'}"></div>
    <div class="stat-bar hunger" :style="{width: hunger + '%'}"></div>
    <div class="stat-bar thirst" :style="{width: thirst + '%'}"></div>
    <div class="stat-bar stress" :style="{width: stress + '%'}"></div>
  </div>
</template>
```

Features:
- Draggable positioning
- Real-time stat updates
- Color-coded bars
- Cash/Bank display

#### Menu Component

Generic menu system for all interactions:

```javascript
{
  title: "Vehicle Menu",
  items: [
    {label: "Lock", description: "Lock doors", action: "lock"},
    {label: "Engine", description: "Toggle engine", action: "engine"}
  ]
}
```

#### Phone Component

Mobile UI with apps:
- **Contacts** - Manage contacts
- **Calls** - Call history, active calls
- **Settings** - Phone settings

### Appearance Sub-Components

8 specialized editors:

| Component | Purpose |
|-----------|---------|
| ModelSelector | Male/Female ped selection |
| HeritageEditor | Parents, resemblance |
| FaceFeaturesEditor | Nose, chin, jaw, etc. |
| HairEditor | Style, color, highlights |
| OverlayEditor | Makeup, blemishes, aging |
| ClothingEditor | Tops, pants, shoes |
| AccessoriesEditor | Glasses, hats, watches |
| TattooEditor | Tattoo browser by zone |

### Job Sub-Components

6 management tabs:

| Component | Purpose |
|-----------|---------|
| OverviewTab | Job info, balance, stats |
| EmployeeList | Members, grades, actions |
| LocationManager | Sales, deliveries, safes |
| PriceEditor | Product pricing |
| FinancialReport | Income/expense analytics |
| MemoManager | Job-wide announcements |

## Build System

### Vite Configuration

```javascript
// vite.config.js
export default {
  base: './',
  build: {
    outDir: 'dist',
    rollupOptions: {
      input: 'index-vue.html'
    }
  },
  server: {
    port: 3000,
    strictPort: true
  },
  plugins: [vue()]
}
```

### NPM Scripts

```bash
# Development server (HMR)
npm run dev

# Production build (REQUIRED before committing)
npm run build

# Watch mode (continuous rebuild)
npm run watch

# Component documentation
npm run storybook
```

### Build Process

```bash
1. npm install              # Install dependencies
2. npm run build            # Build to dist/
3. index-vue.html → index.html  # Rename for FiveM
4. Commit dist/ files       # Built files are versioned
```

**Critical:** Always run `npm run build` before committing UI changes. Dev server is for development iteration only.

## NUI Callback Mechanism

### Callback Types

#### 1. Message-based (Broadcast)

One-way from Lua to Vue:

```lua
SendNUIMessage({message = "hud:update", data = {health = 80}})
```

No response needed.

#### 2. Callback-based (Request-Response)

Two-way communication:

```lua
RegisterNUICallback('appearance:updateModel', function(data, cb)
    -- Process request
    local model = data[1]
    SetPlayerModel(model)
    
    -- Send response
    cb({ok = true, model = model})
end)
```

Vue calls via HTTP POST, receives response.

### Throttling System

```javascript
// nui.js
const THROTTLE_CONFIG = {
  camera: 200,      // Camera movements
  clothing: 50,     // Clothing changes
  default: 100      // Everything else
}

function shouldThrottle(callback) {
  const lastCall = lastCallTimes[callback]
  const delay = THROTTLE_CONFIG[callback] || THROTTLE_CONFIG.default
  
  if (Date.now() - lastCall < delay) {
    return true
  }
  
  lastCallTimes[callback] = Date.now()
  return false
}
```

Prevents spam with per-callback delays.

### Live Preview Pattern

For real-time customization:

```javascript
// Component
watch(() => appearance.hairStyle, (newStyle) => {
  callClientCallback('Client:Appearance:UpdateHair', newStyle)
})
```

```lua
-- Lua handler
RegisterNUICallback('Client:Appearance:UpdateHair', function(data, cb)
    local style = data[1]
    SetPedComponentVariation(ped, 2, style, 0, 0)
    cb({ok = true})
end)
```

## Development Workflow

### Hot Module Replacement (HMR)

Vite provides instant updates during development:

```bash
npm run dev  # Start dev server on :3000
```

Changes to Vue files reload instantly without full page refresh.

### Message Validation

```javascript
// Extensive logging for debugging
if (DEV_MODE) {
  console.log('[NUI] Message received:', message, data)
}
```

### Error Boundaries

```javascript
window.addEventListener('message', (event) => {
  try {
    handleMessage(event.data)
  } catch (error) {
    console.error('[NUI] Handler error:', error)
  }
})
```

## Lua Export API

### ShowMenu

```lua
exports['ingenium']:ShowMenu({
    title = "Vehicle Menu",
    items = {
        {label = "Lock", action = "lock"},
        {label = "Unlock", action = "unlock"}
    }
})
```

### ShowInputDialog

```lua
exports['ingenium']:ShowInputDialog({
    title = "Enter Amount",
    placeholder = "0",
    type = "number"
}, function(input)
    print('User entered:', input)
end)
```

### ShowNotification

```lua
exports['ingenium']:ShowNotification({
    message = "Vehicle locked",
    type = "success",
    duration = 3000
})
```

### UpdateHUD

```lua
exports['ingenium']:UpdateHUD({
    health = 80,
    armor = 50,
    hunger = 75,
    thirst = 60,
    stress = 20
})
```

## Best Practices

1. **Always build before committing** - `npm run build`
2. **Use Pinia stores** - Centralize state management
3. **Throttle callbacks** - Prevent spam
4. **Handle errors** - Try/catch in handlers
5. **Validate input** - Check NUI data types
6. **Use composition API** - Prefer `<script setup>`
7. **TailwindCSS only** - No raw CSS files
8. **Component isolation** - Keep components focused
9. **Emit events** - Use emit for parent communication
10. **Test in-game** - Dev server ≠ production

## Debugging

### NUI Inspector

```
F8 → resmon → Click resource → NUI → Inspect
```

Opens Chrome DevTools for NUI debugging.

### Message Logging

```javascript
// Enable verbose logging
const DEBUG_NUI = true

if (DEBUG_NUI) {
  console.log('[NUI] Sending:', callback, data)
}
```

### Common Issues

| Issue | Solution |
|-------|----------|
| UI not showing | Check SendNUIMessage format |
| Callback not working | Verify RegisterNUICallback |
| Styles not applying | Run `npm run build` |
| Duplicate handlers | Check handlersSetup flag |
| Throttle blocking | Adjust THROTTLE_CONFIG |

## Dependencies

### Core

- **Vue 3.4.15** - Framework
- **Pinia 2.1.7** - State management
- **Vite 5.0.12** - Build tool

### Styling

- **Tailwind CSS 3.4.1** - Utility CSS
- **PostCSS** - CSS processing

### Development

- **Storybook 10.1.11** - Component docs
- **Vue DevTools** - Browser extension

## Related Documentation

- [Callback System](Callback_System.md) - Lua callback architecture
- [Character System](Character_System.md) - Character selection UI
- [Job System](Job_System.md) - Job management UI
