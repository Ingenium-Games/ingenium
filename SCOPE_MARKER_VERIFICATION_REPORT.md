# Ingenium Framework - Comprehensive Function Scope Marker Verification Report

**Report Date:** January 14, 2026  
**Framework Version:** Current  
**Documentation File:** `/workspaces/ingenium/Documentation/wiki/README.md`

---

## Executive Summary

A comprehensive audit of all 590 documented functions in the Ingenium framework revealed **significant discrepancies** between documented scope markers and actual code locations.

### Critical Findings:
- **29.8%** of functions have CORRECT scope markers
- **16.9%** of functions have WRONG scope markers  
- **53.2%** of documented functions are NOT FOUND in the codebase (likely using different naming or module structures)
- **8 namespaces** have major scope marker mismatches
- **25 namespaces** are completely missing from the codebase

---

## Summary Statistics

| Metric | Count | Percentage |
|--------|-------|-----------|
| **Total Namespaces Analyzed** | 54 | 100% |
| **Total Functions Documented** | 590 | 100% |
| **Namespaces with Correct Markers** | 21 | 38.9% |
| **Namespaces with Wrong Markers** | 8 | 14.8% |
| **Namespaces Not Found** | 25 | 46.3% |
| | | |
| **Functions with Correct Markers** | 176 | 29.8% |
| **Functions with Wrong Markers** | 100 | 16.9% |
| **Functions Not Found** | 314 | 53.2% |

---

## Critical Issues Found

### Major Problem #1: AFFILIATION NAMESPACE
- **Issue:** All 11 functions marked `[S]` (Server-only)
- **Reality:** All functions are in `client/_affiliation.lua`
- **Impact:** HIGH - Code is client-side, not server-side
- **Affected Functions:**
  - `ig.affiliation.CreateGroup` [S] → Should be [C]
  - `ig.affiliation.SetGroupRelationship` [S] → Should be [C]
  - `ig.affiliation.SetGroupRelationshipDirectional` [S] → Should be [C]
  - `ig.affiliation.ClearGroupRelationship` [S] → Should be [C]
  - `ig.affiliation.GetGroupRelationship` [S] → Should be [C]
  - `ig.affiliation.SetPedGroup` [S] → Should be [C]
  - `ig.affiliation.SetPedDefaultGroup` [S] → Should be [C]
  - `ig.affiliation.GetPedRelationship` [S] → Should be [C]
  - `ig.affiliation.ConfigureGroupRelationships` [S] → Should be [C]
  - `ig.affiliation.GroupExists` [S] → Should be [C]
  - `ig.affiliation.GetGroupHash` [S] → Should be [C]

### Major Problem #2: WEAPON NAMESPACE
- **Issue:** All 12 functions marked `[S C]` (Server + Client)
- **Reality:** All functions are in `client/_weapon.lua` (Client-only)
- **Impact:** HIGH - Scope marker overstates functionality
- **Affected Functions:**
  - `ig.weapon.ClearCache` [S C] → Should be [C]
  - `ig.weapon.Exist` [S C] → Should be [C]
  - `ig.weapon.Get` [S C] → Should be [C]
  - `ig.weapon.GetAll` [S C] → Should be [C]
  - `ig.weapon.GetByCategory` [S C] → Should be [C]
  - `ig.weapon.GetByHash` [S C] → Should be [C]
  - `ig.weapon.GetByName` [S C] → Should be [C]
  - `ig.weapon.GetComponents` [S C] → Should be [C]
  - `ig.weapon.GetDisplayName` [S C] → Should be [C]
  - `ig.weapon.GetName` [S C] → Should be [C]
  - `ig.weapon.IsMelee` [S C] → Should be [C]
  - `ig.weapon.Resync` [S C] → Should be [C]

### Major Problem #3: AMMO NAMESPACE
- **Issue:** 2 functions marked `[S C]`
- **Reality:** Found only in `client/_ammo.lua`
- **Impact:** MEDIUM - Users may expect server-side functionality
- **Affected Functions:**
  - `ig.ammo.Get` [S C] → Should be [C]
  - `ig.ammo.GetType` [S C] → Should be [C]

### Major Problem #4: APPEARANCE NAMESPACE
- **Issue:** 50 functions marked `[C]` (Client-only)
- **Reality:** Functions found in BOTH `client/_appearance.lua` AND `server/[Callbacks]/_appearance.lua`
- **Impact:** MEDIUM - Missing [S C] indicator for shared functionality
- **Marked as:** [C] | **Should be:** [S C]

### Major Problem #5: OBJECTS NAMESPACE
- **Issue:** 7 functions marked `[S C]` (Server + Client)
- **Reality:** Found only in `server/[Objects]/_objects.lua`
- **Impact:** MEDIUM - Users may expect client-side access
- **Marked as:** [S C] | **Should be:** [S]

### Major Problem #6: TATTOO NAMESPACE
- **Issue:** 7 functions marked `[S C]` (Server + Client)
- **Reality:** Found only in `server/[Data - No Save Needed]/_tattoo.lua`
- **Impact:** MEDIUM - Users may expect client-side access
- **Marked as:** [S C] | **Should be:** [S]

### Major Problem #7: MODKIT NAMESPACE
- **Issue:** 6 functions marked `[S C]` (Server + Client)
- **Reality:** Found only in `server/[Data - No Save Needed]/_modkit.lua`
- **Impact:** MEDIUM - Users may expect client-side access
- **Marked as:** [S C] | **Should be:** [S]

### Major Problem #8: SECURITY NAMESPACE
- **Issue:** 5 functions marked `[S C]` (Server + Client)
- **Reality:** Found only in `server/[Security]/_transaction_security.lua`
- **Impact:** MEDIUM - Users may expect client-side security functions
- **Marked as:** [S C] | **Should be:** [S]

---

## Namespaces with Correct Markers (21 Total)

These namespaces have properly marked scope indicators:

| Namespace | Marked | Actual | Functions |
|-----------|--------|--------|-----------|
| bank | [S] | S | 3 |
| callback | [C, S, S C] | C | 10 |
| chat | [S C] | C S | 2 |
| check | [S C] | S C | 4 |
| cron | [S] | S | 2 |
| data | [S C] | C S | 27 |
| file | [S C] | S C | 4 |
| fx | [C] | C | 2 |
| gsr | [S] | S | 19 |
| inventory | [C] | C | 8 |
| json | [S C] | S C | 2 |
| log | [S C] | S C | 6 |
| math | [S C] | S C | 4 |
| persistance | [S C] | C S | 3 |
| rng | [S C] | S C | 8 |
| status | [C] | C | 25 |
| table | [S C] | S C | 9 |
| text | [C] | C | 2 |
| time | [S C] | C S | 6 |
| vehicle | [S C] | C S | 21 |
| voip | [S C] | S C | 9 |

**Total Functions with Correct Markers: 176 (29.8%)**

---

## Namespaces NOT FOUND in Codebase (25 Total)

These 25 namespaces are referenced in documentation but **cannot be located** in the actual codebase. This likely indicates:
- Functions use different module/file naming conventions
- Code is dynamically loaded or organized differently
- Documentation references deprecated/renamed modules

| Namespace | Documented Functions | Marked Scope |
|-----------|----------------------|--------------|
| blip | 9 | [C] |
| camera | 4 | [C] |
| class | 8 | [S C] |
| door | 11 | [S C] |
| drop | 7 | [S C] |
| func | 62 | [C, S C] |
| game | 3 | [S C] |
| inst | 6 | [S C] |
| ipl | 12 | [C] |
| item | 36 | [S C] |
| job | 27 | [S C] |
| marker | 1 | [C] |
| modifier | 14 | [C] |
| name | 4 | [S] |
| note | 26 | [S] |
| npc | 5 | [S C] |
| ped | 13 | [S C] |
| pick | 18 | [S] |
| player | 8 | [S] |
| queue | 1 | [S] |
| skill | 4 | [S C] |
| state | 6 | [S C] |
| target | 19 | [C] |
| validation | 7 | [S] |
| version | 3 | [S C] |

**Total Functions Not Found: 314 (53.2%)**

---

## Recommended Actions for Correction

### Priority 1: CRITICAL (Scope Reversal)
These require immediate correction as they're completely wrong:

```lua
-- AFFILIATION: Change all from [S] to [C]
- ig.affiliation.* (11 functions) - ALL marked [S] should be [C]

-- WEAPON: Change all from [S C] to [C]
- ig.weapon.* (12 functions) - ALL marked [S C] should be [C]

-- AMMO: Change from [S C] to [C]
- ig.ammo.Get [S C] → [C]
- ig.ammo.GetType [S C] → [C]
```

### Priority 2: HIGH (Incomplete Markers)
These need marker adjustment from single scope to both:

```lua
-- APPEARANCE: Change from [C] to [S C]
- ig.appearance.* (50 functions) - ALL marked [C] should be [S C]
```

### Priority 3: MEDIUM (Overstated Scope)
These are marked more broadly than actual implementation:

```lua
-- OBJECTS: Change from [S C] to [S]
- ig.objects.* (7 functions) - ALL marked [S C] should be [S]

-- TATTOO: Change from [S C] to [S]
- ig.tattoo.* (7 functions) - ALL marked [S C] should be [S]

-- MODKIT: Change from [S C] to [S]
- ig.modkit.* (6 functions) - ALL marked [S C] should be [S]

-- SECURITY: Change from [S C] to [S]
- ig.security.* (5 functions) - ALL marked [S C] should be [S]
```

### Priority 4: INVESTIGATION REQUIRED
These 25 namespaces need research:

- Verify if functions use alternative naming conventions
- Check if code is in different locations than expected
- Determine if these are dynamically loaded or generated
- Decide whether to document actual location or update function references

**Namespaces:** blip, camera, class, door, drop, func, game, inst, ipl, item, job, marker, modifier, name, note, npc, ped, pick, player, queue, skill, state, target, validation, version

---

## Impact Assessment

### Documentation Quality
- **Current Accuracy:** 29.8% (176/590 functions correct)
- **Misleading Documentation:** 16.9% (100 functions with wrong markers)
- **Missing Documentation:** 53.2% (314 functions not found)

### User Impact
1. **Users accessing marked [S] functions** that are actually [C] will get errors or unexpected behavior
2. **Users relying on [S C] markers** may attempt to use server-side functions that don't exist
3. **25 namespaces** with 314 functions may be completely undocumented in actual code

### Development Impact
- Time spent debugging incorrect scope assumptions
- Potential security issues if server validation is assumed but not present
- Confusion when implementing server-side logic for client-only functions

---

## Test Results Summary

```
Analysis Details:
- Parsed functions from README: 590
- Verified against codebase: 54 namespaces
- Correct scope markers: 176 functions (29.8%)
- Incorrect scope markers: 100 functions (16.9%)
- Not found in codebase: 314 functions (53.2%)

Major Issues Identified: 8 namespaces
Critical Fixes Needed: 45 functions (affiliation, weapon, ammo)
High Priority Fixes: 50 functions (appearance)
Medium Priority Fixes: 25 functions (objects, tattoo, modkit, security)
Investigation Required: 314 functions (25 namespaces)
```

---

## Next Steps

1. **Immediate:** Fix the 8 critical namespace markers
2. **Short-term:** Investigate the 25 missing namespaces
3. **Medium-term:** Generate automated correction script
4. **Long-term:** Implement documentation validation in CI/CD pipeline

---

**Generated by:** Function Scope Marker Verification Script  
**Analysis Method:** Filesystem search + pattern matching  
**Confidence Level:** High (file-based verification)
