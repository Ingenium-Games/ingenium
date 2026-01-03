# Callback System Fix - Deployment Checklist

**Date:** 2026-01-03  
**Issue Reference:** ISSUE_CALLBACK_AWAIT.md  
**Implementation Reference:** IMPLEMENTATION_SUMMARY_CALLBACK_FIX.md

---

## Pre-Deployment Verification

### Code Review
- [x] Wrapper implementation reviewed (`client/_callback.lua`)
- [x] All incorrect patterns fixed (`client/[Data]/_game_data_helpers.lua`)
- [x] Load order verified in `fxmanifest.lua`
- [x] No remaining incorrect usage patterns in codebase
- [x] Documentation complete and accurate

### File Integrity
- [x] `client/_callback.lua` - 224 lines, implements full wrapper
- [x] `fxmanifest.lua` - Callback wrapper in correct load position
- [x] `client/[Data]/_game_data_helpers.lua` - 7 functions fixed
- [x] `ISSUE_CALLBACK_AWAIT.md` - Issue documentation
- [x] `IMPLEMENTATION_SUMMARY_CALLBACK_FIX.md` - Implementation summary
- [x] `Documentation/Callback_Wrapper_Guide.md` - User guide
- [x] `Documentation/Callbacks.md` - Updated main docs

---

## Deployment Steps

### 1. Backup Current State
```powershell
# Backup current fxmanifest.lua
Copy-Item fxmanifest.lua fxmanifest.lua.backup

# Backup game data helpers
Copy-Item client/[Data]/_game_data_helpers.lua client/[Data]/_game_data_helpers.lua.backup
```

### 2. Deploy Files
All files are already in place. Verify:
```powershell
# Check new files exist
Test-Path client/_callback.lua
Test-Path ISSUE_CALLBACK_AWAIT.md
Test-Path IMPLEMENTATION_SUMMARY_CALLBACK_FIX.md
Test-Path Documentation/Callback_Wrapper_Guide.md
```

### 3. Restart Resource
```
# In FiveM console
restart ingenium
```

---

## Post-Deployment Testing

### Critical Path Tests

#### Test 1: Appearance System Initialization
**File:** `client/_appearance.lua`
```lua
-- Should load without errors
/testappearance
```
**Expected:** Appearance constants loaded successfully message

#### Test 2: Tattoo Data Fetch (Async Pattern)
**File:** `client/[Data]/_game_data_helpers.lua`
```lua
ig.tattoo.GetAll(function(tattoos)
    print(json.encode(tattoos))
end)
```
**Expected:** Tattoo data printed without errors

#### Test 3: Weapon Data Fetch (Async Pattern)
```lua
ig.weapon.GetAll(function(weapons)
    print('Weapons loaded:', #weapons)
end)
```
**Expected:** Weapon count printed

#### Test 4: Appearance UI Open
**File:** `client/[Callbacks]/_appearance.lua`
```lua
-- Open appearance customization
TriggerEvent("Client:Appearance:Open", {})
```
**Expected:** UI opens with peds, tattoos, pricing data

#### Test 5: Console Error Check
```
# Check for any Lua errors in console
# Should see NO errors related to:
# - "attempt to call a nil value (field 'Await')"
# - "attempt to index nil with 'callback'"
```

---

## Validation Checklist

### Runtime Validation
- [ ] No Lua errors on resource start
- [ ] Appearance system initializes successfully
- [ ] Tattoo system loads data correctly
- [ ] Weapon system loads data correctly
- [ ] Vehicle system loads data correctly
- [ ] Modkit system loads data correctly
- [ ] Appearance UI opens without errors
- [ ] All appearance customization features work

### Console Checks
- [ ] "Callback wrapper initialized" message appears
- [ ] "Appearance module loaded" message appears
- [ ] "Game Data Client-side helpers loaded" message appears
- [ ] No errors about undefined `ig.callback`

### Performance Checks
- [ ] Resource start time unchanged (±5%)
- [ ] No memory leaks introduced
- [ ] Callback response times normal

---

## Rollback Procedure

If critical issues are found:

### Quick Rollback
```powershell
# Restore backups
Copy-Item fxmanifest.lua.backup fxmanifest.lua -Force
Copy-Item client/[Data]/_game_data_helpers.lua.backup client/[Data]/_game_data_helpers.lua -Force

# Remove new file
Remove-Item client/_callback.lua

# Restart resource
# In FiveM console: restart ingenium
```

### Full Rollback
```powershell
# Revert to previous commit
git checkout HEAD~1 -- client/_callback.lua
git checkout HEAD~1 -- fxmanifest.lua
git checkout HEAD~1 -- client/[Data]/_game_data_helpers.lua
git checkout HEAD~1 -- Documentation/Callbacks.md

# Remove issue/implementation docs (optional)
Remove-Item ISSUE_CALLBACK_AWAIT.md
Remove-Item IMPLEMENTATION_SUMMARY_CALLBACK_FIX.md
Remove-Item Documentation/Callback_Wrapper_Guide.md
```

---

## Known Issues / Limitations

### None Expected
This is a wrapper implementation with no breaking changes. If issues occur:

1. **Check load order** - Ensure `client/_callback.lua` loads before other client scripts
2. **Check server callbacks** - Verify server-side callbacks are registered
3. **Check event names** - Ensure event names match between client and server

---

## Success Metrics

### Primary Metrics
- ✅ Zero runtime errors related to `ig.callback`
- ✅ All appearance system features functional
- ✅ All game data helpers operational

### Secondary Metrics
- ✅ Code consistency improved (all callbacks use `ig` namespace)
- ✅ Documentation comprehensive and accessible
- ✅ Future maintainability enhanced

---

## Communication

### Developer Notification
```markdown
## Callback System Update

We've added a convenient wrapper for the callback system:

**New API:**
- `ig.callback.Await(eventName, ...)` - Synchronous server callbacks
- `ig.callback.Async(eventName, callback, ...)` - Asynchronous callbacks

**Documentation:** See `Documentation/Callback_Wrapper_Guide.md`

**Breaking Changes:** None - this is additive only

**Action Required:** None - existing code continues to work
```

---

## Support Resources

### Documentation
- **Quick Reference:** `Documentation/Callback_Wrapper_Guide.md`
- **Core System:** `Documentation/Callbacks.md`
- **Issue Details:** `ISSUE_CALLBACK_AWAIT.md`
- **Implementation:** `IMPLEMENTATION_SUMMARY_CALLBACK_FIX.md`

### Code Examples
- **Synchronous:** `client/_appearance.lua` line 21
- **Asynchronous:** `client/[Data]/_game_data_helpers.lua` lines 23, 34, 55, etc.
- **Registration:** `client/_callback.lua` lines 152-193

---

## Sign-Off

### Pre-Deployment
- [ ] Code reviewed by: _______________
- [ ] Tests passed by: _______________
- [ ] Documentation reviewed by: _______________

### Post-Deployment
- [ ] Deployed successfully by: _______________
- [ ] Testing completed by: _______________
- [ ] Issues resolved: _______________

### Final Approval
- [ ] Approved for production: _______________
- [ ] Date: _______________

---

**Status:** Ready for Deployment  
**Risk Level:** Low  
**Estimated Downtime:** None (hot-reload compatible)  
**Rollback Time:** < 2 minutes
