# Job Vehicle System - Integration Test Plan

## Test Environment Setup

### Prerequisites
1. FiveM server with ingenium resource installed
2. QBCore or ESX framework (or custom framework with adapted `getPlayerJobInfo`)
3. At least 2 test accounts with different jobs and grades

### Configuration
Add test configuration to `_config/job_vehicles.lua`:

```lua
conf.garage.job_vehicles = {
  -- Test job 1: Police with grade restrictions
  police = {
    vehicles = {
      { model = "police", label = "Test Cruiser Grade 0", minGrade = 0 },
      { model = "police2", label = "Test Cruiser Grade 2", minGrade = 2 },
      { model = "police3", label = "Test Cruiser Grade 5", minGrade = 5 }
    }
  },
  
  -- Test job 2: Simple job without restrictions
  ambulance = {
    vehicles = {
      { model = "ambulance", label = "Test Ambulance", minGrade = 0 }
    }
  },
  
  -- Test job 3: Non-existent job (should never show vehicles)
  nonexistent = {
    vehicles = {
      { model = "taxi", label = "Should Not Appear" }
    }
  }
}
```

## Test Cases

### Test 1: Framework Detection
**Objective**: Verify framework is properly detected

**Steps**:
1. Start the server
2. Check server console for framework detection message

**Expected Result**:
- Console shows: `[ingenium|job-vehicles] QBCore framework detected` OR
- Console shows: `[ingenium|job-vehicles] ESX framework detected` OR
- Console shows: `[ingenium|job-vehicles] WARNING: No QBCore or ESX detected...`

**Status**: [ ] PASS [ ] FAIL

---

### Test 2: Job Vehicles Appear for Authorized Player
**Objective**: Verify job vehicles show in garage UI for player with job

**Setup**:
- Test Account: Police job, Grade 0

**Steps**:
1. Log in as test account
2. Approach parking machine
3. Interact with parking machine to open garage
4. Look for "Job Vehicles" section

**Expected Result**:
- "Job Vehicles" section appears below owned vehicles
- "Test Cruiser Grade 0" appears in list
- "Test Cruiser Grade 2" does NOT appear (grade too low)
- "Test Cruiser Grade 5" does NOT appear (grade too low)

**Status**: [ ] PASS [ ] FAIL

---

### Test 3: No Job Vehicles for Player Without Job
**Objective**: Verify empty state shown when player has no configured job

**Setup**:
- Test Account: Civilian or unconfigured job

**Steps**:
1. Log in as test account
2. Open garage menu

**Expected Result**:
- "Job Vehicles" section appears
- Shows message: "No job vehicles available for your current position."

**Status**: [ ] PASS [ ] FAIL

---

### Test 4: Grade Restrictions Enforced
**Objective**: Verify vehicles are filtered by grade

**Setup**:
- Test Account: Police job, Grade 5

**Steps**:
1. Log in as test account
2. Open garage menu

**Expected Result**:
- All three test vehicles appear (grades 0, 2, 5)

**Status**: [ ] PASS [ ] FAIL

---

### Test 5: Authorized Vehicle Spawn
**Objective**: Verify authorized vehicle spawns successfully

**Setup**:
- Test Account: Police job, Grade 0
- Clear area near parking spots

**Steps**:
1. Log in and open garage
2. Click "Spawn" on "Test Cruiser Grade 0"
3. Wait for spawn

**Expected Result**:
- Vehicle spawns at nearest parking spot
- Player receives notification: "Job vehicle spawned successfully."
- Vehicle is drivable
- No money charged

**Status**: [ ] PASS [ ] FAIL

---

### Test 6: Unauthorized Spawn Attempt (Client Manipulation)
**Objective**: Verify server blocks unauthorized spawn requests

**Setup**:
- Test Account: Police job, Grade 0

**Steps**:
1. Open F8 console
2. Execute: `emitNet('ingenium:spawnJobVehicle', {model = 'police3'})`
3. Check server console

**Expected Result**:
- Server logs: "Denied spawn request: player X attempted to spawn police3 (not authorized)"
- Vehicle does NOT spawn
- No notification sent to player

**Status**: [ ] PASS [ ] FAIL

---

### Test 7: Invalid Model Protection
**Objective**: Verify server validates vehicle models

**Setup**:
- Test Account: Any

**Steps**:
1. Open F8 console
2. Execute: `emitNet('ingenium:spawnJobVehicle', {model = 'invalid_model_xyz'})`
3. Check server console

**Expected Result**:
- Server logs denial
- Vehicle does NOT spawn

**Status**: [ ] PASS [ ] FAIL

---

### Test 8: Coordinate Validation
**Objective**: Verify server validates spawn coordinates

**Setup**:
- Test Account: Police job, Grade 0

**Steps**:
1. Open F8 console
2. Execute: `emitNet('ingenium:spawnJobVehicle', {model = 'police', spawnCoords = {x = 999999, y = 999999, z = 999999}})`
3. Check server console

**Expected Result**:
- Server logs: "Invalid X coordinate from player X"
- Vehicle does NOT spawn

**Status**: [ ] PASS [ ] FAIL

---

### Test 9: Multiple Jobs
**Objective**: Verify switching jobs updates available vehicles

**Setup**:
- Test Account: Start with Police, switch to Ambulance

**Steps**:
1. Log in as Police
2. Open garage, note available vehicles
3. Switch to Ambulance job (admin command or job menu)
4. Re-open garage

**Expected Result**:
- Police vehicles no longer appear
- Ambulance vehicles appear

**Status**: [ ] PASS [ ] FAIL

---

### Test 10: Export Function
**Objective**: Verify GetJobVehiclesForPlayer export works

**Setup**:
- Test Account: Police job, Grade 2

**Steps**:
1. Create test script:
```lua
RegisterCommand('testexport', function(source)
  local vehicles = exports['ingenium']:GetJobVehiclesForPlayer(source)
  print(json.encode(vehicles, {indent=true}))
end, false)
```
2. Execute `/testexport` in-game

**Expected Result**:
- Console prints JSON array of vehicles
- Shows police and police2 (grades 0 and 2)
- Does NOT show police3 (grade 5)

**Status**: [ ] PASS [ ] FAIL

---

### Test 11: UI Loading State
**Objective**: Verify loading state appears while fetching vehicles

**Setup**:
- Any test account

**Steps**:
1. Open garage menu
2. Observe Job Vehicles section immediately

**Expected Result**:
- "Loading job vehicles..." appears briefly
- Spinner animation visible
- Then transitions to vehicle list or empty state

**Status**: [ ] PASS [ ] FAIL

---

### Test 12: Parking Spot Selection
**Objective**: Verify vehicle spawns at appropriate parking spot

**Setup**:
- Test Account: Police job, Grade 0
- Block some parking spots with other vehicles

**Steps**:
1. Park vehicles to block nearest parking spots
2. Open garage and spawn job vehicle
3. Note spawn location

**Expected Result**:
- Vehicle spawns at nearest AVAILABLE spot (not blocked)
- Does not spawn on top of other vehicles

**Status**: [ ] PASS [ ] FAIL

---

## Performance Tests

### Test P1: Multiple Concurrent Requests
**Objective**: Verify system handles multiple players requesting simultaneously

**Setup**:
- 5+ test accounts with police job

**Steps**:
1. All players open garage at same time
2. All players click spawn simultaneously

**Expected Result**:
- All requests processed
- No server errors
- Each vehicle spawns correctly

**Status**: [ ] PASS [ ] FAIL

---

### Test P2: Request Response Time
**Objective**: Verify reasonable response time

**Steps**:
1. Open garage
2. Measure time from open to vehicles displayed

**Expected Result**:
- Vehicles appear within 500ms
- No noticeable delay

**Status**: [ ] PASS [ ] FAIL

---

## Security Tests

### Test S1: SQL Injection Attempt
**Objective**: Verify no SQL injection vulnerability

**Steps**:
1. Attempt spawn with malicious model name:
```lua
emitNet('ingenium:spawnJobVehicle', {model = "'; DROP TABLE vehicles; --"})
```

**Expected Result**:
- Server safely rejects request
- No database operations performed
- Server logs invalid request

**Status**: [ ] PASS [ ] FAIL

---

### Test S2: Excessive Coordinate Values
**Objective**: Verify coordinate bounds checking

**Steps**:
1. Test various out-of-bounds coordinates:
   - X: 50000, Y: 50000, Z: 50000
   - X: -50000, Y: -50000, Z: -50000

**Expected Result**:
- All requests rejected
- Server logs invalid coordinate messages

**Status**: [ ] PASS [ ] FAIL

---

## Regression Tests

### Test R1: Owned Vehicles Still Work
**Objective**: Verify job vehicles don't break owned vehicle spawning

**Setup**:
- Account with owned vehicles in garage

**Steps**:
1. Open garage
2. Spawn owned vehicle (not job vehicle)

**Expected Result**:
- Owned vehicle spawns normally
- Parking fee charged as usual
- No errors

**Status**: [ ] PASS [ ] FAIL

---

### Test R2: Garage Close Functionality
**Objective**: Verify ESC key still closes garage

**Steps**:
1. Open garage
2. Press ESC key

**Expected Result**:
- Garage closes
- NUI focus removed
- No errors

**Status**: [ ] PASS [ ] FAIL

---

## Test Summary

| Category | Total | Passed | Failed |
|----------|-------|--------|--------|
| Functional | 12 | | |
| Performance | 2 | | |
| Security | 2 | | |
| Regression | 2 | | |
| **TOTAL** | **18** | | |

## Notes

Record any issues, observations, or additional findings here:

---

## Sign-off

- **Tester Name**: ___________________
- **Date**: ___________________
- **Server Version**: ___________________
- **Resource Version**: ___________________
- **Framework**: [ ] QBCore [ ] ESX [ ] Custom
