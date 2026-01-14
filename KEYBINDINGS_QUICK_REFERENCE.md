# Ingenium Keybindings - Quick Reference

## Default Keys

| Action | Default Key | Configurable |
|--------|-------------|--------------|
| Open Inventory | `I` | ✅ Yes |
| Toggle HUD Drag Mode | `F2` | ✅ Yes |
| Open Chat | `T` | ❌ No |
| Cycle Voice Range | `F6` | ✅ Yes |

---

## How to Customize Keys

### Step 1: Open FiveM Settings
- Press `ESC` in-game
- Click **Settings**

### Step 2: Go to Keybinds
- Look for the **Keybinds** or **Controls** tab

### Step 3: Find Ingenium Commands
Search for these commands:
- **Open Inventory** - Change the key to open your inventory
- **Toggle HUD Drag Mode** - Change the key to enable HUD repositioning
- **Cycle Voice Range** - Change the key to switch voice distance

### Step 4: Customize
- Click on a keybind
- Press your desired key
- Confirm with checkmark

---

## HUD Positioning Guide

### Enable Drag Mode
1. Press `F2` (or your custom key)
2. HUD will show a **green border** = ready to drag

### Drag the HUD
1. Click and hold on the HUD bars
2. Move your mouse to new position
3. Release to place

### Disable Drag Mode
- Press `F2` again to lock the position
- Green border disappears

### Reset Position
- Type in console: `/resetHudPosition`
- HUD returns to bottom-left corner

---

## Inventory Hotkey

### Open Inventory
- Press `I` (or your custom key)
- Shows your player inventory

### Close Inventory
- Press `ESC` or click the **X** button

### Drag Items
- Click and drag items between panels
- Drop outside to drop on ground

---

## Troubleshooting

### Key isn't working?
1. Check if you're typing in a text field (won't trigger)
2. Verify the key is bound in FiveM Settings → Keybinds
3. Check for conflicts with other scripts

### HUD won't move?
1. Press `F2` to enable drag mode (should show green border)
2. Close any open menus (Banking, Inventory, etc.)
3. Try clicking directly on the HUD bars

### Position resets every session?
- This is normal unless `conf.hud.persistPosition` is enabled
- Contact server admin to enable position saving

---

## Advanced: Console Commands

Server admins or experienced users can use these commands:

```
/openInventory          Open your inventory
/toggleHudFocus         Toggle HUD drag mode on/off
/resetHudPosition       Reset HUD to default bottom-left corner
```

---

## Server Customization

Ask your server admin about these customizable settings:

**Inventory Options**:
- Change default open key (currently `I`)
- Disable inventory hotkey entirely

**HUD Options**:
- Change drag mode toggle key (currently `F2`)
- Disable HUD dragging
- Enable/disable position saving between sessions

**Menu Options**:
- Allow/disallow dragging of Banking, Menu, and Garage menus
- Enable/disable menu position saving

---

## Questions?

If keys aren't working or you need help:
1. Check the [Control Mapping Implementation Guide](CONTROL_MAPPING_IMPLEMENTATION.md)
2. Ask server admin to verify settings
3. Report issues to server support
