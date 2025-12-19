# Security Hardening - Testing Guide

This document provides step-by-step instructions for testing the security hardening features implemented in this PR.

## Prerequisites

1. Server running ingenium with this PR applied
2. Client connected to the server
3. Admin/console access
4. F8 console access on client

---

## Test 1: StateBag Protection

### Objective
Verify that clients cannot modify protected StateBag keys.

### Steps

1. **Connect to server** as a player
2. **Open client console** (F8)
3. **Attempt to modify Cash** (should be blocked):
   ```lua
   Entity(PlayerPedId()).state.Cash = 999999
   ```
4. **Attempt to modify Bank** (should be blocked):
   ```lua
   Entity(PlayerPedId()).state.Bank = 999999
   ```
5. **Attempt to modify Keys** (should be blocked):
   ```lua
   Entity(PlayerPedId()).state.Keys = {"all_vehicles"}
   ```
6. **Set allowed key** (should work):
   ```lua
   Entity(PlayerPedId()).state.Animation = "test"
   ```

### Expected Results

- Server console shows: `[SECURITY CRITICAL] Player X attempted to modify BLOCKED key: Cash`
- Server console shows: `[SECURITY CRITICAL] Player X attempted to modify BLOCKED key: Bank`
- Server console shows: `[SECURITY CRITICAL] Player X attempted to modify BLOCKED key: Keys`
- Animation key change works without warnings
- txaLogger:SecurityAlert events triggered for blocked attempts

---

## Test 2: Transaction Rate Limiting

### Objective
Verify that rapid transactions are rate-limited.

### Steps

1. **From server console**, get a player object:
   ```lua
   local xPlayer = ig.data.GetPlayer(1) -- Replace 1 with actual player ID
   ```

2. **Spam AddCash** rapidly:
   ```lua
   for i = 1, 10 do
       xPlayer.AddCash(100)
   end
   ```

3. **Check player notifications** - should see "Transaction too fast. Please wait."

4. **Wait 2 seconds** and try again:
   ```lua
   Wait(2000)
   xPlayer.AddCash(100)
   ```

5. **Test other transaction types**:
   ```lua
   for i = 1, 10 do xPlayer.SetBank(1000) end
   for i = 1, 10 do xPlayer.RemoveCash(10) end
   ```

### Expected Results

- First transaction in each loop succeeds
- Subsequent rapid transactions blocked with "Transaction too fast" message
- After 1 second cooldown, transactions work again
- Console shows rate limit debug messages

---

## Test 3: Transaction Logging

### Objective
Verify that all financial transactions are logged.

### Steps

1. **Set up event listener** (in another resource or console):
   ```lua
   AddEventHandler("txaLogger:LogTransaction", function(log)
       print("Transaction logged:", json.encode(log))
   end)
   ```

2. **Perform various transactions**:
   ```lua
   local xPlayer = ig.data.GetPlayer(1)
   xPlayer.AddCash(500)
   xPlayer.RemoveCash(100)
   xPlayer.SetBank(1000)
   xPlayer.AddBank(250)
   xPlayer.RemoveBank(50)
   ```

3. **Check console output**

### Expected Results

- Each transaction triggers txaLogger:LogTransaction event
- Logs contain:
  - timestamp
  - player_id
  - source
  - type (add_cash, remove_cash, set_bank, etig.)
  - amount
  - reason
  - before_cash or before_bank values

---

## Test 4: Fraud Detection

### Objective
Verify that suspicious transaction patterns are detected.

### Steps

1. **Set up fraud alert listener**:
   ```lua
   AddEventHandler("txaLogger:FraudAlert", function(alert)
       print("FRAUD ALERT:", json.encode(alert))
   end)
   ```

2. **Trigger fraud detection** with >20 transactions in 60s:
   ```lua
   local xPlayer = ig.data.GetPlayer(1)
   for i = 1, 25 do
       xPlayer.AddCash(1)
       Wait(100) -- Small delay to avoid rate limit
   end
   ```

3. **Check console**

### Expected Results

- After 20th transaction, fraud alert triggered
- Console shows: `[SECURITY] Suspicious transaction pattern detected for player X (25 transactions in 60s)`
- txaLogger:FraudAlert event fired with details
- Alert contains player ID, transaction count, and action list

---

## Test 5: Range Clamping

### Objective
Verify that numeric values are clamped to valid ranges.

### Steps

1. **Test Fuel clamping**:
   ```lua
   local veh = ig.data.GetVehicle(netId) -- Replace with actual vehicle net ID
   veh.SetFuel(150) -- Should clamp to 100
   print("Fuel after 150:", veh.GetFuel()) -- Should print 100
   
   veh.SetFuel(-50) -- Should clamp to 0
   print("Fuel after -50:", veh.GetFuel()) -- Should print 0
   ```

2. **Test Player stats clamping**:
   ```lua
   local xPlayer = ig.data.GetPlayer(1)
   xPlayer.SetHealth(9999) -- Should clamp to conf.defaulthealth
   xPlayer.SetArmour(9999) -- Should clamp to conf.defaultarmour
   xPlayer.SetHunger(150) -- Should clamp to 100
   xPlayer.SetThirst(-50) -- Should clamp to 0
   xPlayer.SetStress(200) -- Should clamp to 100
   ```

3. **Verify values** are within expected ranges

### Expected Results

- All values automatically clamped to valid ranges
- No errors or warnings
- Fuel: 0-100
- Health: 0-conf.defaulthealth
- Armour: 0-conf.defaultarmour
- Hunger/Thirst/Stress: 0-100

---

## Test 6: NaN Handling

### Objective
Verify that NaN values are handled properly.

### Steps

1. **Test NaN input**:
   ```lua
   local xPlayer = ig.data.GetPlayer(1)
   local nan = 0/0 -- Creates NaN
   print("NaN value:", nan, "equals itself?", nan == nan) -- Should print false
   
   xPlayer.SetHealth(nan) -- Should return 0 (default)
   print("Health after NaN:", xPlayer.GetHealth()) -- Should be 0
   ```

2. **Test with vehicle**:
   ```lua
   local veh = ig.data.GetVehicle(netId)
   veh.SetFuel(0/0) -- NaN
   print("Fuel after NaN:", veh.GetFuel()) -- Should be 0
   ```

### Expected Results

- NaN values rejected and replaced with default (0)
- No crashes or errors
- No infinite loops or unexpected behavior

---

## Test 7: Authorization Security

### Objective
Verify that authorization checks use server-side data, not client state.

### Steps

1. **Create vehicle without giving keys**:
   ```lua
   -- Spawn a vehicle for player
   local coords = GetEntityCoords(GetPlayerPed(1))
   local veh = CreateVehicle(GetHashKey("adder"), coords.x, coords.y, coords.z, 0.0, true, true)
   local netId = NetworkGetNetworkIdFromEntity(veh)
   local vehicle = ig.data.AddVehicle(netId)
   -- Don't add keys for player
   ```

2. **Try to modify state from client** (won't work due to StateBag protection, but test the principle):
   ```lua
   -- Even if client could modify Keys in state, server checks self.Keys
   -- Server-side verification:
   local xPlayer = ig.data.GetPlayer(1)
   local hasKeys = vehicle.CheckKeys(xPlayer.GetCharacter_ID())
   print("Has keys (should be false):", hasKeys)
   ```

3. **Add keys properly** (server-side):
   ```lua
   vehicle.AddKey(xPlayer.GetCharacter_ID())
   local hasKeys = vehicle.CheckKeys(xPlayer.GetCharacter_ID())
   print("Has keys (should be true):", hasKeys)
   ```

### Expected Results

- CheckKeys returns false before adding key
- CheckKeys returns true after adding key via server method
- Authorization always based on server-side self.Keys, never self.State.Keys

---

## Test 8: Integration with External Logging

### Objective
Verify that security events can be captured by external systems.

### Steps

1. **Create test logging resource** or add to existing:
   ```lua
   -- In your logging resource
   AddEventHandler("txaLogger:SecurityAlert", function(alert)
       -- Send to Discord webhook, database, etig.
       print(json.encode(alert, {indent = true}))
   end)
   
   AddEventHandler("txaLogger:LogTransaction", function(log)
       -- Store to database
       MySQL.Async.execute("INSERT INTO transaction_log (...) VALUES (...)", log)
   end)
   
   AddEventHandler("txaLogger:FraudAlert", function(alert)
       -- Send urgent notification
       -- TriggerEvent("discord:send", "Fraud detected: " .. json.encode(alert))
   end)
   ```

2. **Trigger various security events** (see tests above)

3. **Verify events received**

### Expected Results

- All security events properly received by external handlers
- Data structure matches documentation
- Integration works seamlessly

---

## Regression Testing

### Objective
Verify that existing functionality still works.

### Tests

1. **Normal cash transactions** still work:
   - Players can buy items
   - Jobs can pay players
   - ATM withdrawals work

2. **Vehicle spawning** still works:
   - Owned vehicles spawn correctly
   - Keys are properly assigned
   - Fuel levels persist

3. **Character stats** still work:
   - Health updates correctly
   - Hunger/thirst/stress systems work
   - Armour functions properly

4. **Job descriptions** can still be set (with corrected limit)

### Expected Results

- All existing features work as before
- No breaking changes
- Only additions and hardening applied

---

## Performance Testing

### Objective
Verify that security features don't impact performance.

### Steps

1. **Monitor server performance** before and after:
   ```
   resmon
   ```

2. **Check tick times** for security scripts

3. **Test with multiple players** performing transactions

4. **Monitor memory usage** over time

### Expected Results

- Minimal performance impact (<1% CPU)
- No memory leaks
- Clean shutdown of cleanup threads
- Scales well with player count

---

## Summary Checklist

- [ ] StateBag protection blocks critical keys
- [ ] StateBag protection allows whitelisted keys
- [ ] Rate limiting prevents transaction spam
- [ ] Transaction logging captures all events
- [ ] Fraud detection triggers on suspicious patterns
- [ ] Range clamping works for all bounded properties
- [ ] NaN values handled gracefully
- [ ] Authorization uses server-side data only
- [ ] External logging integration works
- [ ] No regression in existing features
- [ ] Performance impact acceptable

---

## Troubleshooting

### Issue: StateBag events not firing
- Ensure security files loaded before class files (check fxmanifest.lua)
- Restart resource completely

### Issue: Rate limiting too aggressive
- Adjust cooldown in `_transaction_security.lua` (currently 1 second)
- Consider implementing token bucket for legitimate rapid transactions

### Issue: Missing logs
- Check that txaLogger events are registered
- Verify security files loaded correctly
- Check console for errors

### Issue: Performance problems
- Review fraud detection threshold (currently >20 tx/60s)
- Adjust cleanup interval (currently 5 minutes)
- Consider database storage instead of memory for logs

---

**Last Updated**: 2025-12-14  
**Version**: 0.9.0  
**Testing Status**: Ready for QA
