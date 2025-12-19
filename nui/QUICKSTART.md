# Quick Start Guide - Vue 3 NUI System

Get started with the new ingenium Vue 3 NUI system in 5 minutes.

## For Developers (Building the NUI)

### 1. Install Dependencies
```bash
cd nui
npm install
```

### 2. Build for Production
```bash
npm run build
```

This creates the `dist/` folder with optimized assets.

### 3. Start FiveM
The resource is now ready to use! Just start your FiveM server:
```bash
/restart ingenium
```

### 4. Optional: Development Mode
For live-reload during development:
```bash
npm run dev
```

Or use watch mode for auto-rebuild:
```bash
npm run watch
```

## For Users (Using the NUI)

### Test the System

Run these commands in-game (F8 console):

```lua
-- Test notification
TriggerEvent("Client:Notify", "Hello World!", "green", 5000)

-- Test menu (if examples.lua is loaded)
/test-menu

-- Test input
/test-input

-- Test HUD
/test-hud-show
```

### Use in Your Resources

```lua
-- Show a notification
exports['ingenium']:Notify("Success!", "green", 3000)

-- Show a menu
exports['ingenium']:ShowMenu({
    title = "My Menu",
    items = {
        { label = "Option 1", action = "opt1" },
        { label = "Option 2", action = "opt2" }
    }
})

-- Listen for menu selection
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action, data)
    print("Selected:", action)
end)
```

## Quick Commands Reference

| Command | Description |
|---------|-------------|
| `npm install` | Install dependencies |
| `npm run dev` | Start dev server with HMR |
| `npm run build` | Build for production |
| `npm run watch` | Auto-rebuild on changes |
| `/restart ingenium` | Restart resource in FiveM |

## Directory Structure

```
nui/
├── src/              # Vue 3 source code
│   ├── components/   # Vue components
│   ├── stores/       # Pinia stores
│   └── utils/        # Utilities
├── dist/             # Built files (auto-generated)
├── lua/              # Lua integration
│   ├── ui.lua        # Export API
│   └── examples.lua  # Test commands
├── package.json      # Dependencies
└── vite.config.js    # Build config
```

## Available Exports

| Export | Description |
|--------|-------------|
| `Notify(text, color, fade)` | Show notification |
| `ShowMenu(data)` | Show menu |
| `ShowInput(data)` | Show input dialog |
| `ShowContextMenu(data)` | Show context menu |
| `ShowHUD()` | Show HUD |
| `HideHUD()` | Hide HUD |
| `UpdateHUD(data)` | Update HUD data |

## Need Help?

- **API Documentation**: See [README.md](README.md)
- **Testing Guide**: See [TESTING.md](TESTING.md)
- **Migration Guide**: See [MIGRATION.md](MIGRATION.md)
- **Examples**: See [lua/examples.lua](lua/examples.lua)

## Common Issues

**Build fails?**
- Run `npm install` first
- Check Node.js version (18+)

**NUI not loading?**
- Verify `dist/index.html` exists
- Restart ingenium: `/restart ingenium`

**Changes not showing?**
- Run `npm run build`
- Clear FiveM cache
- Restart resource

## What's New?

✨ **Vue 3** - Modern reactive framework
✨ **Pinia** - State management
✨ **TailwindCSS** - Utility-first styling
✨ **Vite** - Lightning-fast builds
✨ **TypeScript Ready** - Add types easily
✨ **Component-based** - Reusable UI components
✨ **Export API** - Clean Lua integration
✨ **Backwards Compatible** - Old code still works

## Next Steps

1. Read the [README.md](README.md) for full documentation
2. Try the examples: `/test-notify`, `/test-menu`, etig.
3. Explore the source code in `src/`
4. Build your own components!

Happy coding! 🚀
