# Vue 3 NUI System - Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         FiveM Client                        │
│                                                             │
│  ┌───────────────────┐         ┌──────────────────────┐   │
│  │   Lua Scripts     │────────▶│   NUI (Browser)      │   │
│  │                   │         │                      │   │
│  │  • ui.lua         │         │  ┌────────────────┐ │   │
│  │  • examples.lua   │         │  │   Vue 3 App    │ │   │
│  │  • _c.lua         │         │  │                │ │   │
│  │                   │         │  │  • App.vue     │ │   │
│  │  Exports:         │         │  │  • Components  │ │   │
│  │  - ShowMenu()     │         │  │  • Stores      │ │   │
│  │  - ShowInput()    │◀────────│  │  • Utils       │ │   │
│  │  - Notify()       │ Callbacks│  │                │ │   │
│  │  - UpdateHUD()    │         │  └────────────────┘ │   │
│  └───────────────────┘         └──────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### 1. Notification Flow
```
Lua Resource
    │
    ├─▶ TriggerEvent("Client:Notify", ...)
    │   OR
    └─▶ exports['ig.core']:Notify(...)
            │
            ▼
        SendNUIMessage
            │
            ▼
    Vue: nui.js listener
            │
            ▼
    notificationStore.addNotification()
            │
            ▼
    NotificationContainer.vue
            │
            ▼
    Display on screen
```

### 2. Menu Flow
```
Lua Resource
    │
    └─▶ exports['ig.core']:ShowMenu({...})
            │
            ▼
        SendNUIMessage("menu:show")
            │
            ▼
    Vue: nui.js listener
            │
            ▼
    uiStore.openMenu(data)
            │
            ▼
    Menu.vue displays
            │
            ▼
    User clicks item
            │
            ▼
    sendNuiMessage("menu:select")
            │
            ▼
    Lua: RegisterNUICallback
            │
            ▼
    TriggerEvent("Client:Menu:Select")
            │
            ▼
    Resource handles selection
```

## Component Hierarchy

```
App.vue
├── NotificationContainer.vue
│   └── Displays multiple notifications
├── CharacterSelect.vue (conditional)
│   ├── Character list
│   ├── Character info
│   └── Creation form
├── HUD.vue (conditional)
│   ├── Health/Armor bars
│   ├── Hunger/Thirst bars
│   └── Money/Job info
├── Menu.vue (conditional)
│   └── Dynamic menu items
├── InputDialog.vue (conditional)
│   └── Text input form
└── ContextMenu.vue (conditional)
    └── Context menu items
```

## State Management (Pinia)

### UI Store
```javascript
{
  showHUD: boolean,
  showCharacterSelect: boolean,
  showMenu: boolean,
  showInput: boolean,
  showContextMenu: boolean,
  hudData: {...},
  menuData: {...},
  inputData: {...},
  contextMenuData: {...}
}
```

### Notification Store
```javascript
{
  notifications: [
    { id, text, color, fade, visible }
  ]
}
```

### Character Store
```javascript
{
  characters: [...],
  selectedCharacter: {...},
  isCreatingCharacter: boolean
}
```

## Build Process

```
Source Files (src/)
    │
    ├─▶ Vite processes:
    │   • Vue SFC compilation
    │   • TailwindCSS processing
    │   • JavaScript bundling
    │   • Minification
    │
    ▼
Output (dist/)
    ├── index.html
    └── assets/
        ├── index-vue.js (85KB → 33KB gzipped)
        └── index-vue.css (17KB → 4KB gzipped)
```

## File Organization

```
nui/
├── 📁 src/                    # Vue 3 source code
│   ├── 📁 components/         # UI components (6 files)
│   │   ├── CharacterSelect.vue
│   │   ├── ContextMenu.vue
│   │   ├── HUD.vue
│   │   ├── InputDialog.vue
│   │   ├── Menu.vue
│   │   └── NotificationContainer.vue
│   ├── 📁 stores/             # Pinia stores (3 files)
│   │   ├── character.js
│   │   ├── notifications.js
│   │   └── ui.js
│   ├── 📁 utils/              # Utilities (1 file)
│   │   └── nui.js
│   ├── App.vue                # Root component
│   ├── main.js                # App entry point
│   └── style.css              # Global styles
│
├── 📁 lua/                    # Lua integration
│   ├── ui.lua                 # Export API
│   ├── examples.lua           # Test commands
│   ├── _c.lua                 # Core NUI handler
│   ├── notification.lua       # Old notification
│   └── character-select.lua   # Old char select
│
├── 📁 dist/                   # Built files (gitignored)
│   ├── index.html
│   └── assets/
│
├── 📁 scripts/                # Build scripts
│   └── rename-html.js
│
├── 📁 css/                    # Old CSS (backward compat)
├── 📁 js/                     # Old JS (backward compat)
├── 📁 libs/                   # Old libs (backward compat)
├── 📁 img/                    # Images
│
├── 📄 package.json            # Dependencies
├── 📄 vite.config.js          # Build config
├── 📄 tailwind.config.js      # Tailwind config
├── 📄 postcss.config.js       # PostCSS config
├── 📄 index-vue.html          # Vue entry HTML
├── 📄 index.html              # Old HTML
│
└── 📚 Documentation
    ├── README.md              # Main documentation
    ├── QUICKSTART.md          # Quick start guide
    ├── TESTING.md             # Testing procedures
    └── MIGRATION.md           # Migration guide
```

## Technology Stack

### Frontend
- **Vue 3** (3.4.15) - Progressive JavaScript framework
- **Pinia** (2.1.7) - State management
- **TailwindCSS** (3.4.1) - Utility-first CSS

### Build Tools
- **Vite** (5.0.12) - Next-generation build tool
- **PostCSS** (8.4.33) - CSS processing
- **Autoprefixer** (10.4.17) - CSS vendor prefixes

### Development
- **Hot Module Replacement** - Instant updates
- **Source Maps** - Easy debugging
- **Code Splitting** - Optimized loading

## API Reference (Quick)

### Lua Exports
```lua
-- Notifications
exports['ig.core']:Notify(text, color, fade)

-- Menus
exports['ig.core']:ShowMenu({title, items})
exports['ig.core']:HideMenu()

-- Input
exports['ig.core']:ShowInput({title, placeholder, maxLength})
exports['ig.core']:HideInput()

-- Context Menu
exports['ig.core']:ShowContextMenu({title, items, position})
exports['ig.core']:HideContextMenu()

-- HUD
exports['ig.core']:ShowHUD()
exports['ig.core']:HideHUD()
exports['ig.core']:UpdateHUD(data)
```

### Events
```lua
-- Listen for interactions
RegisterNetEvent("Client:Menu:Select")
RegisterNetEvent("Client:Input:Submit")
RegisterNetEvent("Client:Context:Select")
RegisterNetEvent("Client:Character:Play")
RegisterNetEvent("Client:Character:Create")
RegisterNetEvent("Client:Character:Delete")
```

## Performance

### Bundle Sizes
- **JavaScript**: 85.54 KB (33.05 KB gzipped)
- **CSS**: 16.77 KB (3.86 KB gzipped)
- **HTML**: 0.36 KB (0.25 KB gzipped)
- **Total**: ~102 KB uncompressed, ~37 KB gzipped

### Runtime Performance
- Single NUI instance (low memory footprint)
- Virtual DOM for efficient updates
- Reactive state management
- CSS animations (GPU accelerated)

## Browser Compatibility
- CEF (Chromium Embedded Framework) in FiveM
- Modern JavaScript features (ES6+)
- CSS Grid and Flexbox
- No polyfills needed

## Security
✅ CodeQL security scan passed (0 alerts)
✅ Input validation on all user inputs
✅ Proper error handling
✅ No eval() or dangerous patterns
✅ XSS protection via Vue's reactivity

## Next Steps

1. **In-Game Testing**: Use commands in examples.lua
2. **Integration**: Add exports to your resources
3. **Customization**: Modify components in src/
4. **Extension**: Add new components as needed
5. **Documentation**: Update docs as you add features

## Support & Resources

- 📖 [README.md](README.md) - Full documentation
- 🚀 [QUICKSTART.md](QUICKSTART.md) - 5-minute guide
- 🧪 [TESTING.md](TESTING.md) - Testing procedures
- 🔄 [MIGRATION.md](MIGRATION.md) - Migration guide
- 💡 [examples.lua](lua/examples.lua) - Code examples
