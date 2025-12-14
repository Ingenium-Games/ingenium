# Vue Inventory System - Testing Guide

## Overview
This guide provides test cases for validating the Vue-based inventory system with enhanced security validation.

## Prerequisites
- FiveM server with ig.core resource installed
- At least one test player account
- Access to server console for logs
- Items in player inventory for testing

---

## Test Plan

### Phase 1: Basic Functionality

#### Test 1.1: Open Single Inventory
**Steps:**
1. Connect to server as a player with loaded character
2. Press 'I' key (or trigger: `TriggerEvent("Client:Inventory:OpenSingle")`)
3. Verify inventory UI appears
4. Verify player items are displayed
5. Press ESC to close
6. Verify inventory closes and NUI focus is released

**Expected Result:** Inventory opens and closes properly, items display correctly

---

#### Test 1.2: Open Dual Inventory
**Steps:**
1. Approach a vehicle/storage container
2. Trigger dual inventory: `TriggerEvent("Client:Inventory:OpenDual", netId, "Vehicle Trunk")`
3. Verify both panels appear (left: external, right: player)
4. Verify both inventories show correct items
5. Close inventory

**Expected Result:** Both inventories display correctly with proper titles

---

### Phase 2: Drag and Drop

#### Test 2.1: Drag Within Same Inventory
**Steps:**
1. Open single inventory
2. Drag an item from slot 1 to slot 5
3. Close inventory
4. Reopen inventory
5. Verify item is still in slot 5

**Expected Result:** Item position is saved via localStorage and persists

---

#### Test 2.2: Drag Between Inventories
**Steps:**
1. Open dual inventory with vehicle/storage
2. Drag item from player inventory to external storage
3. Close inventory
4. Reopen dual inventory
5. Verify item moved to external storage

**Expected Result:** Item successfully transferred, server validates and saves

---

#### Test 2.3: Visual Feedback
**Steps:**
1. Open any inventory
2. Hover over an item
3. Verify hover effect appears
4. Start dragging an item
5. Verify ghost element appears
6. Drop item

**Expected Result:** Smooth animations, visual feedback works properly

---

### Phase 3: Item Actions

#### Test 3.1: Use Item
**Steps:**
1. Open inventory
2. Right-click on consumable item (e.g., food, water)
3. Click "Use" in context menu
4. Verify item is consumed (quantity decreases or item removed)
5. Verify appropriate effect triggers

**Expected Result:** Item consumed, server validates, effects applied

---

#### Test 3.2: Give Item
**Steps:**
1. Open inventory with another player nearby
2. Right-click on an item
3. Click "Give"
4. Select target player
5. Verify item transfers

**Expected Result:** Item transferred to other player (implementation dependent)

---

#### Test 3.3: Drop Item
**Steps:**
1. Open inventory
2. Right-click on an item
3. Click "Drop"
4. Close inventory
5. Verify item appears on ground

**Expected Result:** Item removed from inventory and spawned in world

---

### Phase 4: Security Validation

#### Test 4.1: Normal Operations (Should Pass)
**Steps:**
1. Open dual inventory
2. Move 5 items from player to external storage
3. Move 3 items from external to player
4. Reorder items in both inventories
5. Close inventory

**Expected Result:** All operations successful, no kicks, server logs show validation passed

---

#### Test 4.2: Item Duplication Attempt (Should Fail)
**Requires modified client or network interception**

**Simulated Test:**
```lua
-- Attempt to duplicate items by modifying client data
-- This should be blocked by server validation
```

**Expected Result:** Player kicked with message: "Inventory manipulation detected: Item duplication detected: [ItemName] quantity increased from X to Y"

Console log should show: `[INVENTORY EXPLOIT] Player: PlayerName (CharID) | Reason: Item duplication...`

---

#### Test 4.3: Item Injection Attempt (Should Fail)
**Simulated Test:**
Attempt to add items not present in original inventories

**Expected Result:** Player kicked with message: "Inventory manipulation detected: Item injection detected: [ItemName] was not present before operation"

---

#### Test 4.4: Invalid Quantity (Should Fail)
**Simulated Test:**
Attempt to set item quantity to negative or overflow value

**Expected Result:** Player kicked with appropriate message about invalid quantity

---

#### Test 4.5: Weapon Stacking Prevention (Should Fail)
**Simulated Test:**
Attempt to stack weapons (quantity > 1)

**Expected Result:** Player kicked with message about weapon stacking violation

---

### Phase 5: Edge Cases

#### Test 5.1: Empty Inventory
**Steps:**
1. Remove all items from player inventory
2. Open inventory
3. Verify empty slots display correctly
4. Close inventory

**Expected Result:** Empty inventory displays properly, no errors

---

#### Test 5.2: Full Inventory
**Steps:**
1. Fill all 50 slots with items
2. Open dual inventory
3. Attempt to move item from external to player
4. Verify appropriate handling

**Expected Result:** System handles full inventory gracefully

---

#### Test 5.3: Quality Degradation Display
**Steps:**
1. Find item with quality < 100
2. Open inventory
3. Verify quality bar displays correctly
4. Verify color changes based on quality percentage:
   - Green: 75-100%
   - Yellow: 50-74%
   - Orange: 25-49%
   - Red: 0-24%

**Expected Result:** Quality visualization accurate

---

#### Test 5.4: Large Quantities
**Steps:**
1. Get item with quantity > 1000
2. Open inventory
3. Verify quantity displays correctly
4. Move item around
5. Close inventory

**Expected Result:** Large quantities handled properly

---

#### Test 5.5: Missing Item Images
**Steps:**
1. Add item to inventory without corresponding image file
2. Open inventory
3. Verify system handles missing image gracefully

**Expected Result:** Broken image icon or fallback displayed, no errors

---

### Phase 6: Performance

#### Test 6.1: Many Items
**Steps:**
1. Fill inventory with 50 different items
2. Open inventory
3. Verify UI renders smoothly
4. Drag items around
5. Verify no lag or stuttering

**Expected Result:** Smooth performance even with full inventory

---

#### Test 6.2: Rapid Open/Close
**Steps:**
1. Rapidly press I key to open/close inventory 10 times
2. Verify no errors or stuck states

**Expected Result:** System handles rapid toggling without issues

---

### Phase 7: Integration

#### Test 7.1: Character Selection Compatibility
**Steps:**
1. Disconnect from server
2. Reconnect
3. Go through character selection
4. Load character
5. Open inventory

**Expected Result:** No conflicts with character selection NUI

---

#### Test 7.2: Notification Compatibility
**Steps:**
1. Open inventory
2. Trigger a notification
3. Verify notification appears
4. Close inventory

**Expected Result:** Both NUI elements coexist without issues

---

#### Test 7.3: Focus Management
**Steps:**
1. Open inventory
2. Verify mouse cursor appears and NUI has focus
3. Close inventory
4. Verify cursor disappears and game controls work

**Expected Result:** Focus properly managed, no stuck cursor

---

## Security Testing Checklist

- [ ] Normal drag-and-drop operations work
- [ ] Item duplication attempts are blocked and logged
- [ ] Item injection attempts are blocked and logged
- [ ] Invalid quantities are rejected
- [ ] Weapon stacking is prevented
- [ ] Overflow values (>999,999) are rejected
- [ ] Log injection attempts are sanitized
- [ ] All exploit attempts result in kick/ban
- [ ] All exploits are logged with player info

---

## Logging Verification

After each security test, verify server console shows:
```
[INVENTORY EXPLOIT] Player: [Name] ([CharID]) | Reason: [Detailed reason]
```

Verify txaLogger receives the event (if available).

---

## Performance Benchmarks

Record and document:
- Time to open inventory: < 100ms
- Time to close inventory: < 100ms
- Drag-and-drop latency: < 50ms
- Full inventory render time: < 200ms

---

## Known Limitations

1. Development dependencies (esbuild/vite) have moderate severity vulnerabilities
   - **Impact:** Development server only, not production
   - **Mitigation:** Only use npm run build output, never run dev server in production

2. Item images must exist in `/nui/img/` directory
   - **Impact:** Missing images won't display
   - **Mitigation:** Ensure all item images are present or add fallback

3. Inventory positions stored in browser localStorage
   - **Impact:** Clearing browser data resets positions
   - **Mitigation:** This is by design for client-side customization

---

## Debugging Tips

### Client-Side
1. Press F8 to open console
2. Check for Vue errors or warnings
3. Check network tab for failed fetch requests

### Server-Side
1. Monitor server console for Lua errors
2. Check for validation failure messages
3. Verify callback responses

### Common Issues
- **Inventory won't open**: Check `c.data.IsPlayerLoaded()` returns true
- **Items not showing**: Verify inventory data structure matches expected format
- **Drag not working**: Check browser console for Vue/JavaScript errors
- **Kicked unexpectedly**: Check server logs for specific validation failure

---

## Reporting Issues

When reporting issues, include:
1. Test case number
2. Expected result
3. Actual result
4. Client console logs (F8)
5. Server console logs
6. Steps to reproduce

---

**Version:** 1.0.0
**Last Updated:** December 2024
