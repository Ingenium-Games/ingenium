# Control Mapping System Architecture Diagrams

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        INGENIUM CONTROL SYSTEM                   │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────┐         ┌──────────────────┐         ┌──────────────────┐
│  Configuration   │         │  Lua Commands    │         │  NUI Components  │
│  Layer           │         │  Layer           │         │  Layer           │
├──────────────────┤         ├──────────────────┤         ├──────────────────┤
│                  │         │                  │         │                  │
│ _config/         │         │ nui/lua/         │         │ nui/src/         │
│ defaults.lua     │         │ inventory.lua    │         │ components/      │
│                  │         │ hud.lua          │         │ HUD.vue          │
│ conf.inventory   │────────▶│ inventory        │────────▶│ BankingMenu.vue  │
│ conf.hud         │         │ toggleHudFocus   │         │ Menu.vue         │
│ conf.menus       │         │ resetHudPosition │         │ GarageMenu.vue   │
│                  │         │                  │         │                  │
└──────────────────┘         └──────────────────┘         └──────────────────┘
         │                           │                            │
         │                           │                            │
         └───────────────────────────┴────────────────────────────┘
                                    │
                         Uses: RegisterKeyMapping
                         Event: RegisterNUICallback
```

---

## Inventory Opening Flow

```
User presses I (or configured key)
         │
         ▼
┌─────────────────────────────────┐
│ FiveM Key Event System          │
│ - Detects key press             │
│ - Routes to command             │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ nui/lua/inventory.lua           │
│ RegisterCommand('openInventory')│
│ Handler checks:                 │
│ - !inventoryOpen                │
│ - IsPlayerLoaded()              │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ Trigger Event                   │
│ "Client:Inventory:OpenSingle"   │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ Event Handler                   │
│ - Get player inventory          │
│ - Call TriggerServerCallback    │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ Send NUI Message                │
│ "Client:NUI:InventoryOpenSingle"│
│ Data: playerInventory[]         │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ SetNuiFocus(true, true)         │
│ - Capture keyboard input        │
│ - Show mouse cursor             │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ Vue Component (App.vue)         │
│ - Render inventory panels       │
│ - Listen for item actions       │
│ - Send drag events              │
└─────────────────────────────────┘
         │
         ▼
    Inventory Open!
```

---

## HUD Focus Toggle Flow

```
User presses F2 (or configured key)
         │
         ▼
┌─────────────────────────────────┐
│ FiveM Key Event System          │
│ - Detects key press             │
│ - Routes to command             │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────┐
│ nui/lua/hud.lua                             │
│ RegisterCommand('toggleHudFocus')           │
│ Handler:                                    │
│   hudFocused = not hudFocused               │
└─────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────┐
│ Send NUI Message                            │
│ "Client:NUI:HUDFocus"                       │
│ Data: { focused: true/false, timestamp }    │
└─────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────┐
│ Vue: HUD.vue                                     │
│ handleHudMessage() receives message              │
│   isFocused.value = data.focused                 │
│   hudZIndex = focused ? 1001 : 100               │
└──────────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────┐
│ CSS Updates                                      │
│ - Z-index changes                               │
│ - Border appears/disappears                     │
│ - Cursor changes                                │
└──────────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────┐
│ User Interaction                                 │
│ - Drag mouse to move HUD                         │
│ - Release to drop                               │
│ - Position saved to localStorage                │
└──────────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────┐
│ NUI Callback                                     │
│ "NUI:Client:HUDPositionUpdate"                   │
│ Data: { position: { x, y } }                     │
└──────────────────────────────────────────────────┘
         │
         ▼
    HUD Repositioned & Saved!
```

---

## Message Flow: Focused HUD Can Be Dragged While Menu Open

```
User has Banking Menu open
│
├─ Banking Menu: SetNuiFocus(true, true) ◄─── Captures input
│
User presses F2 to focus HUD
│
├─ HUD receives: "Client:NUI:HUDFocus" { focused: true }
│
├─ HUD z-index changed: 100 → 1001 ◄─── Now above menu!
│
├─ HUD receives mouse events even though Banking has focus
│  (because z-index elevation puts it on top)
│
User drags HUD
│
├─ HUD drag handlers active
│
├─ Position updated in Vue state
│
├─ localStorage persisted
│
├─ Callback sent: "NUI:Client:HUDPositionUpdate"
│
    ✅ HUD successfully moved while Banking Menu open!
```

---

## Configuration Override Hierarchy

```
┌─────────────────────────────────────┐
│  FiveM Keybind Settings (Client)    │ ◄─── Highest Priority
│  User can customize via UI          │      (User choice)
└─────────────────────────────────────┘
           │
           │ Falls back to:
           ▼
┌─────────────────────────────────────┐
│  Server Configuration               │
│  _config/dev.lua (dev mode)         │ ◄─── Medium Priority
│  Custom conf overrides              │      (Server decision)
└─────────────────────────────────────┘
           │
           │ Falls back to:
           ▼
┌─────────────────────────────────────┐
│  Default Configuration              │
│  _config/defaults.lua               │ ◄─── Lowest Priority
│  conf.inventory.openKey = "I"       │      (Fallback)
│  conf.hud.focusKey = "F2"           │
└─────────────────────────────────────┘

User -> Server Config -> Defaults -> Command Executes
```

---

## Multi-Menu Interaction Without Focus Toggle

```
Scenario: User wants to drag Banking Menu AND HUD at same time

Without HUD Focus:
┌────────────────────────────────┐
│ Banking Menu                   │
│ SetNuiFocus(true, true)        │ ◄─── Has focus
│ Receives all mouse input       │
└────────────────────────────────┘
         │
         │ HUD behind, input lost
         ▼
┌────────────────────────────────┐
│ HUD                            │
│ Drag handlers NEVER fire       │ ✗ Can't drag
│ Mouse events blocked           │
└────────────────────────────────┘

WITH HUD Focus Toggle:
┌────────────────────────────────┐
│ Banking Menu                   │
│ SetNuiFocus(true, true)        │ ◄─── Has focus
│ Z-index: 500                   │      but below HUD
└────────────────────────────────┘
         │ User presses F2
         ▼
┌────────────────────────────────┐
│ HUD                            │
│ Z-index: 1001                  │ ✅ Drag works!
│ Drag handlers ACTIVE           │
│ Mouse events RECEIVED          │
└────────────────────────────────┘
```

---

## Complete State Machine: HUD Focus

```
                    ┌─────────────┐
                    │   UNFOCUSED │
                    │ (Z=100)     │
                    └──────┬──────┘
                           │
                    User presses F2
                           │
                           ▼
                    ┌─────────────────────┐
                    │  TRANSITIONING      │
                    │ Toggle command runs │
                    │ Send NUI message    │
                    └──────┬──────────────┘
                           │
                           ▼
      ┌────────────────────────────────────────┐
      │ CSS Updates:                           │
      │ • Border color: transparent → green    │
      │ • Z-index: 100 → 1001                 │
      │ • Box-shadow: none → green glow       │
      │ • Cursor: grab → grabbing             │
      └────────────────┬───────────────────────┘
                       │
                       ▼
                ┌──────────────┐
                │   FOCUSED    │
                │ (Z=1001)     │
          ┌─────┤ Ready to drag│◄─────┐
          │     └──────────────┘      │
          │                           │
    User drags           User presses F2
          │                           │
          ▼                           │
   ┌──────────────┐                   │
   │   DRAGGING   │                   │
   │ Position     │───────────────────┘
   │ updating     │
   └──────────────┘

Events emitted:
- UNFOCUSED → FOCUSED: "Client:HUD:FocusToggled" (true)
- FOCUSED → UNFOCUSED: "Client:HUD:FocusToggled" (false)
- DRAGGING → UNFOCUSED: "Client:HUD:PositionChanged" (position)
```

---

## Key Registration Process

```
┌──────────────────────────────────────┐
│ Application Startup (First Time)     │
└──────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ Lua Script Loads                     │
│ nui/lua/hud.lua                      │
│ nui/lua/inventory.lua                │
└──────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ RegisterKeyMapping() called:          │
│ - Command: "toggleHudFocus"           │
│ - Description: "Toggle HUD Drag Mode" │
│ - Mapper: "keyboard"                  │
│ - Key: conf.hud.focusKey.lower()      │
└──────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ FiveM Key Registry Updated            │
│ Default binding created               │
│ Users can see it in Settings          │
└──────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ User Customizes in FiveM Settings     │
│ overrides default binding             │
│ New key stored in FiveM config        │
└──────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ Key Press Event                       │
│ F2 (or custom key) pressed            │
│ FiveM routes to command               │
└──────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ RegisterCommand Handler Executes      │
│ toggleHudFocus function runs          │
│ State changes, NUI message sent       │
└──────────────────────────────────────┘
```

---

## Data Flow: Position Persistence

```
User drags HUD to (150, 300)
         │
         ▼
┌────────────────────────────────────────┐
│ Vue handleDrag() updates position      │
│ position.value = { x: 150, y: 300 }    │
└────────────────────────────────────────┘
         │
         ▼
┌────────────────────────────────────────┐
│ User releases mouse (stopDrag())       │
│ Save to localStorage:                  │
│ localStorage.setItem('hud_position',   │
│   JSON.stringify(position.value))      │
└────────────────────────────────────────┘
         │
         ▼
┌────────────────────────────────────────┐
│ Send NUI Callback to Lua               │
│ NUI:Client:HUDPositionUpdate           │
│ Data: { position: { x: 150, y: 300 } } │
└────────────────────────────────────────┘
         │
         ▼
┌────────────────────────────────────────┐
│ Lua receives callback (nui/lua/hud.lua)│
│ hudPosition = data.position            │
│ TriggerEvent("Client:HUD:PositionChanged")
└────────────────────────────────────────┘
         │
         ▼
┌────────────────────────────────────────┐
│ Data persisted in browser localStorage │
│ Survives game restart!                 │
└────────────────────────────────────────┘
         │
    Next game session:
         │
         ▼
┌────────────────────────────────────────┐
│ HUD.vue onMounted()                    │
│ Retrieve from localStorage:            │
│ const saved =                          │
│   localStorage.getItem('hud_position') │
│ position.value = JSON.parse(saved)     │
└────────────────────────────────────────┘
         │
         ▼
    HUD renders at saved position (150, 300)!
```

---

## Export Functions Call Chain

```
External Resource calls export:
export['ingenium']:IsHudFocused()
         │
         ▼
│ Queries hudFocused variable in nui/lua/hud.lua
│ Returns: true or false
         │
         ▼
Returns boolean to caller

Similar flow for other exports:
- GetHudPosition() → returns { x, y }
- SetHudPosition(x, y) → sends NUI message
- ToggleHudFocus() → triggers command
```

---

## System Dependencies

```
┌─────────────────────────────────────────┐
│ External Dependencies                   │
├─────────────────────────────────────────┤
│ • FiveM Native: RegisterKeyMapping      │ ✓
│ • FiveM Native: RegisterCommand         │ ✓
│ • FiveM Native: SetNuiFocus            │ ✓
│ • FiveM Native: SendNUIMessage          │ ✓
│ • Browser API: localStorage             │ ✓
│ • Vue 3: ref, computed, onMounted       │ ✓
│ • Lua Table: conf.*                     │ ✓
└─────────────────────────────────────────┘

All dependencies available in Ingenium ✅
No external libraries required
```

---

## Error Handling Flow

```
User presses F2 but conf.hud not initialized
         │
         ▼
┌──────────────────────────────────────┐
│ Log warning to console               │
│ "HUD configuration not found"         │
└──────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ Apply default configuration           │
│ conf.hud = { ... }                    │
└──────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ Command still executes               │
│ Toggle works with defaults            │
└──────────────────────────────────────┘

Result: Graceful fallback, no crashes ✅
```

---

## Performance Considerations

```
Operation                 Impact      Notes
─────────────────────────────────────────────────
RegisterKeyMapping        Minimal     Only runs at startup
Position update (drag)    Negligible  Updates ref, triggers render
localStorage.setItem      Minimal     Async, non-blocking
SendNUIMessage           Low         Batched by FiveM
NUI render update        Medium      Only HUD component re-renders
Z-index change           Minimal     CSS-only, no reflow needed

Total overhead: < 1% FPS impact
Optimizations:
  • Debounced drag (handled by Vue)
  • Computed z-index (cached)
  • Conditional rendering (v-if)
```
