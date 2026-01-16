# Phase 5: Testing & Validation - Quick Start Guide

**Status:** Ready to Begin  
**Expected Duration:** 1-2 hours  
**Resource Requirements:** Running FiveM server instance  

---

## 🚀 Quick Start

### Step 1: Prepare Test Environment
```powershell
# Start your FiveM server with the Ingenium resource
# Ensure OneSync Infinity is enabled
# Monitor server console for startup messages
```

### Step 2: Run Basic Load Test
When resource starts, check console for:
```
✅ NUI-Client handlers loaded successfully
✅ Client-NUI-Wrappers loaded successfully
✅ ig.nui namespace populated
```

### Step 3: Test Wrapper Functions
In game console, test each system:
```
# Character system
/testchar

# Menu system
/testmenu

# Chat system
/testchat
```

### Step 4: Check for Errors
Review server and client console for:
- ❌ Syntax errors
- ❌ Missing files
- ❌ Duplicate callbacks
- ❌ Load order issues

---

## 📋 Testing Checklist

### Load Order Tests (5 min)
- [ ] Resource starts without errors
- [ ] Console shows "All NUI systems loaded"
- [ ] No Lua syntax errors reported
- [ ] No missing file warnings
- [ ] All 22 files loaded in order

### Wrapper Function Tests (15 min)
Test each system's wrapper functions:

**Character System (5 functions)**
- [ ] ShowSelect() displays correctly
- [ ] HideSelect() closes correctly
- [ ] ShowCreate() opens create menu
- [ ] ShowCustomize() opens appearance editor
- [ ] HideAppearance() closes editor

**Menu System (2 functions)**
- [ ] Show() displays menu
- [ ] Hide() closes menu

**Chat System (4 functions)**
- [ ] Show() opens chat
- [ ] Hide() closes chat
- [ ] AddMessage() adds message
- [ ] Clear() clears messages

**All Others (17 functions)**
- [ ] Input: Show, Hide
- [ ] Context: Show, Hide
- [ ] Banking: Show, Hide
- [ ] Inventory: Show, Hide, Update
- [ ] Garage: Show, Hide
- [ ] Target: Show, Hide
- [ ] HUD: Show, Hide, Update, UpdateElement
- [ ] Notify: Show, Hide

### Callback Tests (15 min)
Verify all 38 callbacks register:

**Character (5)**
- [ ] CharacterList registers
- [ ] CharacterPlay registers
- [ ] CharacterCreate registers
- [ ] CharacterDelete registers
- [ ] AppearanceComplete registers

**Menu (2)**
- [ ] MenuClose registers
- [ ] MenuSelect registers

**Chat (2)**
- [ ] ChatSubmit registers
- [ ] ChatClose registers

**All Others (29 callbacks)**
- [ ] Banking: 4 callbacks
- [ ] Inventory: 4 callbacks
- [ ] Garage: 4 callbacks
- [ ] Input: 2 callbacks
- [ ] Context: 2 callbacks
- [ ] Target: 2 callbacks
- [ ] HUD: 3 callbacks
- [ ] Notification: 2 callbacks

### Focus Management Tests (10 min)
- [ ] Focus gains when UI opens (SetNuiFocus(true, true))
- [ ] Focus releases when UI closes (SetNuiFocus(false, false))
- [ ] Can't move when focused
- [ ] Can move when unfocused
- [ ] Mouse works when focused
- [ ] Mouse ignored when unfocused

### Integration Tests (10 min)
- [ ] Character select → Create → Load works
- [ ] Menu opens from code → Player selects → Closes
- [ ] Chat opens → Player types → Sends → Closes
- [ ] Banking opens → Player transactions → Closes
- [ ] Inventory opens → Player manages → Closes
- [ ] Garage opens → Player selects vehicle → Closes
- [ ] All transitions smooth without errors

### Error Handling Tests (5 min)
- [ ] Missing data handled gracefully
- [ ] Invalid data rejected safely
- [ ] Errors logged to console
- [ ] No crashes on error
- [ ] User feedback provided

---

## 🔧 Test Commands

Add these to `client/[Commands]/_test.lua`:

```lua
-- Test Character System
TriggerEvent('chat:addMessage', {
    author = "Test",
    args = {"Type /testchar to test character system"}
})

-- Test Menu System
TriggerEvent('chat:addMessage', {
    author = "Test",
    args = {"Type /testmenu to test menu system"}
})

-- Test All Systems
TriggerEvent('chat:addMessage', {
    author = "Test",
    args = {"Type /testnui to test all NUI systems"}
})
```

---

## 🐛 Debugging Guide

### Enable Verbose Logging
Add to `client/_var.lua`:
```lua
DEBUG_NUI = true  -- Enable detailed NUI logging
DEBUG_CALLBACKS = true  -- Enable callback logging
DEBUG_FOCUS = true  -- Enable focus management logging
```

### Check Wrapper Function Availability
In client console:
```lua
print("ig.nui.menu.Show:", type(ig.nui.menu.Show))
print("ig.nui.chat.Show:", type(ig.nui.chat.Show))
print("ig.nui.inventory.Show:", type(ig.nui.inventory.Show))
```

Expected: `function` for all

### Monitor Callback Registration
Check server console for:
```
[NUI-Client/_menu.lua] Registering MenuClose callback...
[NUI-Client/_menu.lua] MenuClose callback registered ✓
[NUI-Client/_menu.lua] Registering MenuSelect callback...
[NUI-Client/_menu.lua] MenuSelect callback registered ✓
```

### Test Focus Management
```lua
-- In client console
SetNuiFocus(true, true)  -- Gain focus
print("Focus gained")

SetNuiFocus(false, false)  -- Release focus
print("Focus released")
```

---

## 📊 Expected Test Results

### Load Test Results
```
✅ Resource started successfully (0 errors)
✅ 22 NUI files loaded in correct order
✅ 11 wrapper functions populated
✅ 11 callback handlers registered
✅ 0 duplicate callbacks
✅ 0 syntax errors
```

### Wrapper Function Results
```
✅ All 28 wrapper functions available
✅ All functions send correct NUI messages
✅ All functions support focus parameter
✅ All functions have error handling
✅ All functions log correctly
```

### Callback Results
```
✅ All 38 callbacks registered
✅ All callbacks receive messages correctly
✅ All callbacks process data without errors
✅ All callbacks release focus correctly
✅ All callbacks log activity
```

### Focus Management Results
```
✅ Focus gained on UI open (visible & interactive)
✅ Focus released on UI close (hidden & non-interactive)
✅ Player can't move with focus
✅ Player can move without focus
✅ Smooth transitions between states
```

---

## ⚠️ Common Issues & Fixes

### Issue: "ig.nui.* is nil"
**Cause:** Client-NUI-Wrappers didn't load  
**Fix:** Check fxmanifest.lua load order - wrappers must load after _var.lua

### Issue: Callbacks not registering
**Cause:** NUI-Client files didn't load  
**Fix:** Check fxmanifest.lua - handlers must load before client.lua

### Issue: Focus not working
**Cause:** SetNuiFocus called incorrectly  
**Fix:** Use SetNuiFocus(true, true) to gain, SetNuiFocus(false, false) to release

### Issue: Duplicate callbacks
**Cause:** Old callback files still loaded  
**Fix:** Remove old client/[Callbacks]/*.lua entries from fxmanifest.lua

### Issue: Messages not reaching NUI
**Cause:** ig.ui.Send not working  
**Fix:** Verify legacy nui/lua/ui.lua loads at end of client_scripts

---

## 📈 Performance Checklist

- [ ] Resource loads in < 5 seconds
- [ ] No memory leaks when UI opens/closes repeatedly
- [ ] No UI lag when interacting
- [ ] No server lag from callbacks
- [ ] Focus management instant (< 50ms)
- [ ] Message sending instant (< 100ms)

---

## 📝 Test Report Template

```markdown
# Phase 5 Test Report
**Date:** [Date]
**Tester:** [Name]
**Duration:** [Time]

## Load Order Tests
- Load Test: ✅ PASS / ❌ FAIL
- File Count: 22 / 22
- Errors: 0

## Wrapper Function Tests
- Character: ✅ PASS / ❌ FAIL (5/5 functions)
- Menu: ✅ PASS / ❌ FAIL (2/2 functions)
- Chat: ✅ PASS / ❌ FAIL (4/4 functions)
- [Other systems...]

## Callback Tests
- Character: ✅ PASS / ❌ FAIL (5/5 callbacks)
- Menu: ✅ PASS / ❌ FAIL (2/2 callbacks)
- [Other systems...]

## Focus Management
- Open/Close: ✅ PASS / ❌ FAIL
- Player Control: ✅ PASS / ❌ FAIL
- Smooth Transitions: ✅ PASS / ❌ FAIL

## Issues Found
[List any issues]

## Recommendations
[Any improvements or fixes needed]

## Overall Status
✅ PASS / ❌ FAIL - Ready for production: YES / NO
```

---

## 🎓 Phase 5 Success Criteria

**All of the following must be true:**

✅ All 22 NUI files load without errors  
✅ All 28 wrapper functions available at runtime  
✅ All 38 callbacks register successfully  
✅ No duplicate callback registrations  
✅ Focus management works correctly  
✅ Error handling graceful  
✅ All systems integrate seamlessly  
✅ Zero crashes during testing  
✅ Documentation accurate  
✅ Code follows established patterns  

**If all criteria met: Phase 5 = ✅ PASS**

---

## 🚀 Ready to Test?

1. **Start server** with Ingenium resource
2. **Monitor console** for load messages
3. **Run test checklist** above
4. **Document results** using template
5. **Report any issues** for Phase 6 (Fixes)

---

**Phase 5 Status:** Ready to Begin  
**Expected Outcome:** All tests pass, architecture validated  
**Next Step:** Execute testing when ready

Good luck! 🎯
