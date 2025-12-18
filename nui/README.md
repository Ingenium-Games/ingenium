# IG Core NUI - Vue 3 System

Modern Vue 3 NUI system for ig.core with Pinia state management and TailwindCSS.

## Overview

This is a complete rewrite of the ig.core NUI system using modern frontend technologies:

- **Vue 3**: Modern reactive UI framework with Composition API
- **Pinia**: Lightweight state management
- **Vite**: Fast build tool with HMR (Hot Module Replacement)
- **TailwindCSS**: Utility-first CSS framework

## Architecture

### Single-Page Application

All UI components live in a single NUI resource and are shown/hidden dynamically based on Pinia store state. This provides:

- Better performance (one NUI instance)
- Centralized state management
- Easier debugging and development
- Consistent styling and behavior

### Component Structure

```
nui/
├── src/
│   ├── components/       # Vue components
│   │   ├── CharacterSelect.vue
│   │   ├── ContextMenu.vue
│   │   ├── HUD.vue
│   │   ├── InputDialog.vue
│   │   ├── Menu.vue
│   │   └── NotificationContainer.vue
│   ├── stores/          # Pinia stores
│   │   ├── character.js
│   │   ├── notifications.js
│   │   └── ui.js
│   ├── utils/           # Utility functions
│   │   └── nui.js       # NUI message handlers
│   ├── App.vue          # Root component
│   ├── main.js          # App entry point
│   └── style.css        # Global styles
├── lua/                 # Lua export API
│   └── ui.lua           # Export functions
├── package.json         # Dependencies
├── vite.config.js       # Vite configuration
├── tailwind.config.js   # TailwindCSS config
└── postcss.config.js    # PostCSS config
```

## Development

### Prerequisites

- Node.js 18+ and npm
- FiveM server for testing

### Setup

1. Navigate to the nui directory:
```bash
cd nui
```

2. Install dependencies:
```bash
npm install
```

### Development Workflow

#### Dev Server (with HMR)

For rapid development with hot-reload:

```bash
npm run dev
```

This starts a development server at `http://localhost:3000` with hot module replacement. Changes to Vue components will be reflected instantly.

**Note**: The dev server is for development only. For in-game testing, you need to build the project.

#### Build for Production

To build the optimized bundle for FiveM:

```bash
npm run build
```

This creates a `dist/` directory with the compiled assets.

#### Watch Mode

For automatic rebuilds during development:

```bash
npm run watch
```

This watches for file changes and rebuilds automatically. You'll need to refresh the NUI in-game to see changes.

### Testing In-Game

1. Build the project: `npm run build` or use watch mode
2. Restart the ig.core resource in FiveM
3. The new Vue-based NUI should load

## Lua Export API

The new system provides clean export functions for other resources to use.

### Notifications

```lua
-- Show a notification (backwards compatible)
exports['ingenium']:Notify("Hello World!", "green", 5000)

-- Or use the event (also backwards compatible)
TriggerEvent("Client:Notify", "Hello World!", "green", 5000)
```

Colors: `black`, `blue`, `orange`, `red`, `green`, `pink`, `purple`, `yellow`

### Menus

```lua
-- Show a menu
exports['ingenium']:ShowMenu({
    title = "Example Menu",
    items = {
        { 
            label = "Option 1", 
            action = "action1", 
            data = { id = 1 } 
        },
        { 
            label = "Option 2", 
            action = "action2", 
            description = "This is a description",
            disabled = false
        }
    }
})

-- Listen for menu selection
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action, data)
    print("Selected:", action, json.encode(data))
end)

-- Hide menu
exports['ingenium']:HideMenu()
```

### Input Dialogs

```lua
-- Show an input dialog
exports['ingenium']:ShowInput({
    title = "Enter your name",
    placeholder = "John Doe",
    maxLength = 50
})

-- Listen for input submission
RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(value)
    print("User entered:", value)
end)

-- Hide input dialog
exports['ingenium']:HideInput()
```

### Context Menus

```lua
-- Show a context menu
exports['ingenium']:ShowContextMenu({
    title = "Actions",
    items = {
        { label = "Repair", icon = "🔧", action = "repair" },
        { label = "Delete", icon = "🗑️", action = "delete" }
    },
    position = { x = 500, y = 300 }
})

-- Listen for context menu selection
RegisterNetEvent("Client:Context:Select")
AddEventHandler("Client:Context:Select", function(action, data)
    print("Selected:", action)
end)

-- Hide context menu
exports['ingenium']:HideContextMenu()
```

### HUD

```lua
-- Show HUD
exports['ingenium']:ShowHUD()

-- Update HUD data
exports['ingenium']:UpdateHUD({
    health = 100,
    armor = 50,
    hunger = 75,
    thirst = 80,
    cash = 5000,
    bank = 25000,
    job = "Police",
    jobGrade = "Officer"
})

-- Hide HUD
exports['ingenium']:HideHUD()
```

## NUI Messages

### Sending Messages from Lua

```lua
SendNUIMessage({
    message = "notification",
    data = {
        text = "Hello!",
        colour = "green",
        fade = 5000
    }
})
```

### Available Messages

- `notification` - Show a notification
- `character-select:show` - Show character select
- `character-select:hide` - Hide character select
- `hud:show` - Show HUD
- `hud:hide` - Hide HUD
- `hud:update` - Update HUD data
- `menu:show` - Show menu
- `menu:hide` - Hide menu
- `input:show` - Show input dialog
- `input:hide` - Hide input dialog
- `context:show` - Show context menu
- `context:hide` - Hide context menu

## Migration Guide

### Backwards Compatibility

The new system maintains backwards compatibility with the old notification system:

```lua
-- This still works!
TriggerEvent("Client:Notify", "Hello", "green", 5000)
```

### Migrating to New System

For new features, use the export API:

```lua
-- Old way (limited)
-- Manual SendNUIMessage calls with custom handling

-- New way (clean API)
exports['ingenium']:ShowMenu({ title = "Menu", items = {...} })
```

### Migrating UI Components

To migrate existing UI to Vue components:

1. Create a new `.vue` component in `src/components/`
2. Add the component to `App.vue`
3. Create a Pinia store for state management if needed
4. Add message handlers in `src/utils/nui.js`
5. Create Lua exports in `nui/lua/ui.lua`

## Troubleshooting

### NUI Not Loading

1. Check that `npm run build` completed successfully
2. Verify `nui/dist/index.html` exists
3. Check FiveM console for errors
4. Ensure `fxmanifest.lua` references the correct files

### Changes Not Showing

1. Run `npm run build` after making changes
2. Restart the ig.core resource: `/restart ig.core`
3. Or use watch mode: `npm run watch`

### Dev Server Not Working

1. Check that port 3000 is not in use
2. Run `npm install` to ensure dependencies are installed
3. Check for TypeScript/build errors in console

## Contributing

When adding new UI components:

1. Create component in `src/components/`
2. Add state management to appropriate store
3. Add message handlers in `src/utils/nui.js`
4. Create Lua exports/events in `nui/lua/ui.lua`
5. Document usage in this README
6. Test thoroughly in-game

## License

MIT License - Copyright (c) 2021 Twiitchter - https://github.com/Ingenium-Games
