# Testing Guide for Vue 3 NUI System

This guide provides instructions for testing all features of the new Vue 3 NUI system.

## Prerequisites

1. Build the NUI system:
```bash
cd nui
npm install
npm run build
```

2. Ensure the resource is running in FiveM
3. Connect to your FiveM server

## Test Commands

All test commands are available in the `nui/lua/examples.lua` file. To enable them, add this line to your `fxmanifest.lua`:

```lua
client_scripts {
    -- ... existing scripts ...
    "nui/lua/examples.lua"  -- Add this for testing
}
```

Then restart the resource: `/restart ingenium`

## Feature Tests

### 1. Notification System

#### Test: Basic Notification
```
/test-notify
```

**Expected Results:**
- Two notifications should appear in the top-right corner
- One green notification: "This is a test notification!"
- One blue notification: "This is another notification!"
- Both should fade out after ~5 seconds

#### Test: Different Colors
Run the following in console:
```lua
TriggerEvent("Client:Notify", "Black notification", "black", 5000)
TriggerEvent("Client:Notify", "Blue notification", "blue", 5000)
TriggerEvent("Client:Notify", "Orange notification", "orange", 5000)
TriggerEvent("Client:Notify", "Red notification", "red", 5000)
TriggerEvent("Client:Notify", "Green notification", "green", 5000)
TriggerEvent("Client:Notify", "Pink notification", "pink", 5000)
TriggerEvent("Client:Notify", "Purple notification", "purple", 5000)
TriggerEvent("Client:Notify", "Yellow notification", "yellow", 5000)
```

**Expected Results:**
- 8 notifications with different background colors
- All should stack vertically
- Should fade in and out smoothly

### 2. Menu System

#### Test: Show Menu
```
/test-menu
```

**Expected Results:**
- A menu should appear in the center of the screen
- Title: "Test Menu"
- 3 menu items should be visible:
  - "Option 1" with description
  - "Option 2" with description
  - "Disabled Option" (grayed out)

#### Test: Menu Interaction
1. Run `/test-menu`
2. Click on "Option 1"

**Expected Results:**
- Menu should close
- Green notification: "You selected Option 1!"

3. Run `/test-menu` again
4. Click on "Option 2"

**Expected Results:**
- Menu should close
- Blue notification: "You selected Option 2!"

#### Test: Menu Close
1. Run `/test-menu`
2. Press ESC key

**Expected Results:**
- Menu should close without triggering any selection

### 3. Input Dialog

#### Test: Show Input
```
/test-input
```

**Expected Results:**
- Input dialog appears in center of screen
- Title: "Enter Your Name"
- Placeholder text: "John Doe"
- Input field should be focused and ready to type

#### Test: Input Submission
1. Run `/test-input`
2. Type "John Smith"
3. Click "Submit" or press Enter

**Expected Results:**
- Dialog closes
- Green notification: "You entered: John Smith"
- F8 console shows: "User entered: John Smith"

#### Test: Input Cancel
1. Run `/test-input`
2. Type something
3. Press ESC or click "Cancel"

**Expected Results:**
- Dialog closes without submitting

### 4. Context Menu

#### Test: Show Context Menu
```
/test-context
```

**Expected Results:**
- Context menu appears at position (500, 300)
- Title: "Actions"
- 3 items with icons:
  - 🔧 Repair Vehicle
  - 🔒 Lock Vehicle
  - 🗑️ Delete Vehicle

#### Test: Context Menu Selection
1. Run `/test-context`
2. Click on "Repair Vehicle"

**Expected Results:**
- Context menu closes
- Purple notification: "Action: repair"
- F8 console shows: "Context menu selection: repair"

#### Test: Context Menu Close
1. Run `/test-context`
2. Press ESC

**Expected Results:**
- Context menu closes without selecting anything

### 5. HUD System

#### Test: Show HUD
```
/test-hud-show
```

**Expected Results:**
- HUD appears in bottom-left corner
- Displays:
  - Health bar (red, 100%)
  - Armor bar (blue, 50%)
  - Hunger bar (orange, 75%)
  - Thirst bar (cyan, 80%)
  - Cash: $5,000 (green)
  - Bank: $25,000 (blue)
  - Job: Police - Officer

#### Test: Hide HUD
```
/test-hud-hide
```

**Expected Results:**
- HUD disappears from screen

#### Test: Update HUD
```
/test-hud-update
```

**Expected Results:**
- HUD updates with current player health and armor
- Blue notification: "HUD updated with current stats"

### 6. Character Select

#### Test: Show Character Select
```
/test-character-select
```

**Expected Results:**
- Full-screen character selection interface
- Shows 2 existing characters:
  - John Doe (with details)
  - Jane Smith (with details)
- "New" button to create character
- Character list at bottom

#### Test: Character Selection
1. Run `/test-character-select`
2. Click on "John Doe"

**Expected Results:**
- Character info appears on left side showing:
  - Name
  - Created date
  - Last played date
  - City ID
  - Phone number
- Two action buttons appear (Enter, Delete)

#### Test: Play Character
1. Run `/test-character-select`
2. Click on "John Doe"
3. Click "Enter" button

**Expected Results:**
- Character select screen closes
- Green notification: "Loading character..."
- F8 console shows: "Playing character: 1"

#### Test: Create Character
1. Run `/test-character-select`
2. Click "New" button
3. Fill in first name: "Test"
4. Fill in last name: "User"
5. Click "Create"

**Expected Results:**
- Form submits
- Green notification: "Creating character: Test User"
- F8 console shows: "Creating character: Test User"

## Visual Tests

### Test: Responsive Design
1. Resize your game window
2. Check that all UI elements scale appropriately

**Expected Results:**
- Notifications stay in top-right
- Menus/dialogs stay centered
- HUD stays in bottom-left
- No overlapping or cut-off elements

### Test: Multiple Notifications
Run this in F8 console:
```lua
for i = 1, 5 do
    TriggerEvent("Client:Notify", "Notification " .. i, "blue", 10000)
end
```

**Expected Results:**
- 5 notifications stack vertically
- No overlapping
- All are readable
- They fade out in order

### Test: Animations
Observe animations for:
- Notification fade in/out (smooth transitions)
- Menu open/close
- Dialog open/close
- HUD bar changes

**Expected Results:**
- All animations are smooth (no jank)
- Transitions use appropriate timing
- No flashing or abrupt changes

## Performance Tests

### Test: Memory Usage
1. Open F8 console
2. Run `/test-notify` 100 times rapidly
3. Monitor memory usage

**Expected Results:**
- Memory should stabilize after notifications clear
- No memory leaks
- Smooth performance throughout

### Test: FPS Impact
1. Check FPS before showing HUD
2. Run `/test-hud-show`
3. Check FPS after

**Expected Results:**
- Minimal FPS impact (< 5 FPS drop)
- Smooth rendering

## Browser Console Tests

1. Press F8 in game
2. Type `NUI.OpenDevTools()`
3. Check browser console for errors

**Expected Results:**
- No JavaScript errors
- No Vue warnings
- Clean console output

## Edge Cases

### Test: Rapid Menu Opening
1. Run `/test-menu`
2. Press ESC immediately
3. Run `/test-menu` again
4. Repeat 5 times rapidly

**Expected Results:**
- Menu opens and closes cleanly each time
- No stuck states
- No duplicate menus

### Test: Multiple Dialogs
Try opening menu, input, and context menu in quick succession

**Expected Results:**
- Only one dialog should be open at a time
- ESC should close the active dialog
- No overlapping dialogs

### Test: Long Text
```lua
TriggerEvent("Client:Notify", string.rep("This is a very long notification message. ", 10), "green", 10000)
```

**Expected Results:**
- Notification wraps text properly
- Still readable
- Doesn't extend off screen

## Common Issues

### Issue: Notifications not showing
**Solutions:**
- Check F8 console for errors
- Verify build completed: `ls nui/dist/`
- Restart resource: `/restart ingenium`

### Issue: Menu not appearing
**Solutions:**
- Check that NUI focus is working
- Verify no JavaScript errors in browser console
- Check that message is being sent from Lua

### Issue: Styles look wrong
**Solutions:**
- Rebuild: `cd nui && npm run build`
- Clear FiveM cache
- Restart FiveM

## Success Criteria

✅ All notifications display correctly with proper colors
✅ Menu system opens, selects items, and closes properly
✅ Input dialog captures and submits text
✅ Context menu appears at correct position
✅ HUD displays and updates correctly
✅ Character select shows characters and handles creation
✅ No JavaScript errors in console
✅ No memory leaks
✅ Smooth animations and transitions
✅ ESC key closes dialogs properly
✅ All Lua exports work as documented

## Reporting Issues

When reporting issues, include:
1. Which test failed
2. Expected vs actual behavior
3. F8 console output
4. Browser console output (NUI DevTools)
5. Steps to reproduce
