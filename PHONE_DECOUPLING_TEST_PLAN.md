# Phone Number Decoupling - Testing Guide

## Overview
This document provides a comprehensive testing plan for verifying the phone number decoupling implementation. Phone numbers are now device-tied (stored in `phones.Phone_Number`) rather than character-tied (seeded from `xPlayer.Phone`).

## Pre-Testing Setup

### Database Verification
1. Ensure `phones` table exists with the following structure:
   ```sql
   SELECT * FROM phones LIMIT 1;
   ```
   Expected columns: `ID`, `IMEI`, `Phone_Number`, `Character_ID`, `Contacts`, `Settings`, `Created`, `Last_Used`

2. Note any existing phone records for comparison:
   ```sql
   SELECT IMEI, Phone_Number, Character_ID FROM phones;
   ```

### Server Verification
1. Start the server and check console for:
   ```
   [INFO] [Phone] Phone management module loaded
   [INFO] [Phone] Phone server event handlers loaded
   [INFO] [SQL] Phone SQL module loaded
   ```

2. Verify no startup errors related to phone system

## Test Cases

### Test 1: First-Time Phone Initialization
**Objective:** Verify that a new phone item generates a unique phone number

**Steps:**
1. Give a test character a Phone item (if not already in inventory):
   ```lua
   /giveitem [playerid] Phone 1
   ```
2. Use the Phone item from inventory
3. Check server console for log:
   ```
   [INFO] [Phone] Created phone device with number [6-7 digits] for character [char_id]
   ```
4. Verify database entry:
   ```sql
   SELECT * FROM phones WHERE Character_ID = '[char_id]' ORDER BY Created DESC LIMIT 1;
   ```
   - `Phone_Number` should be 6-7 digits
   - `IMEI` should be a UUID
   - `Character_ID` should match the character

5. Check inventory item Meta contains IMEI:
   - Use `/inventory` or inventory debug command
   - Verify the Phone item has `Meta.IMEI` and `Meta.About` fields

**Expected Results:**
- Phone number is 6-7 digits
- Phone number is different from character's Phone field (if character has one)
- IMEI is generated and stored
- Phone opens successfully on client
- Database record created with generated phone number

---

### Test 2: Phone Number Uniqueness
**Objective:** Verify that generated phone numbers are unique

**Steps:**
1. Give multiple test characters Phone items
2. Have each character use their phone for the first time
3. Check database for unique phone numbers:
   ```sql
   SELECT Phone_Number, COUNT(*) as count 
   FROM phones 
   GROUP BY Phone_Number 
   HAVING count > 1;
   ```

**Expected Results:**
- Query returns no results (all phone numbers are unique)
- No "Phone number collision" warnings repeated 10+ times in console
- Each phone has a different number

---

### Test 3: Existing Phone Re-use (IMEI Lookup)
**Objective:** Verify that phones with existing IMEI are looked up correctly

**Steps:**
1. Use a phone that was already initialized (from Test 1)
2. Close and reopen the phone
3. Check server console for:
   ```
   [DEBUG] [Phone] Phone used by [player] (IMEI: [uuid], Number: [number])
   ```
4. Verify no new database entry was created
5. Verify `Last_Used` timestamp updated in database

**Expected Results:**
- No new phone record created
- `Last_Used` field updated
- Same phone number displayed as before
- Phone opens successfully

---

### Test 4: Client Receives Device Phone Number
**Objective:** Verify client always receives `phoneData.Phone_Number` from DB

**Steps:**
1. Use a phone item
2. Check client NUI receives correct data (enable client debug mode)
3. Verify phone number displayed in Settings app matches database
4. Compare with character's Phone field (if different):
   ```lua
   /sqlquery SELECT Phone FROM characters WHERE Character_ID = '[char_id]'
   ```

**Expected Results:**
- Client receives `phoneNumber` field in payload
- Phone number displayed matches `phones.Phone_Number` from database
- Phone number is NOT the character's Phone field (unless coincidentally same)

---

### Test 5: Character Phone Field Independence
**Objective:** Verify character Phone field is not modified by phone initialization

**Steps:**
1. Query character's Phone field before using phone:
   ```sql
   SELECT Phone FROM characters WHERE Character_ID = '[char_id]';
   ```
2. Use a new phone item (first time)
3. Query character's Phone field again
4. Verify character Phone field unchanged

**Expected Results:**
- Character Phone field remains unchanged
- Device phone number and character phone number are independent
- Phone system uses device phone number exclusively

---

### Test 6: Phone Number Generation Failure Handling
**Objective:** Verify graceful handling if phone number generation fails

**Steps:**
1. Temporarily modify `ig.phone.GeneratePhoneNumber()` to always return `nil` (for testing):
   ```lua
   function ig.phone.GeneratePhoneNumber()
       return nil
   end
   ```
2. Attempt to use a new phone item
3. Check server console for error:
   ```
   [ERROR] [Phone] Failed to generate phone number
   ```
4. Verify player receives notification: "Failed to initialize phone"
5. Verify no database entry created
6. Restore original function

**Expected Results:**
- Error logged appropriately
- Player notified of failure
- No partial/invalid database entries
- System handles failure gracefully

---

### Test 7: Database Record Reconstruction
**Objective:** Verify phone with IMEI but no DB record is recreated

**Steps:**
1. Create a phone with IMEI but delete its database record:
   ```sql
   DELETE FROM phones WHERE IMEI = '[test-imei]';
   ```
2. Use the phone item (which still has IMEI in Meta)
3. Check server console for:
   ```
   [WARN] [Phone] Phone has IMEI but no database record, recreating
   [INFO] [Phone] Created phone device with number [number] for character [char_id]
   ```
4. Verify new database entry created with new phone number

**Expected Results:**
- Warning logged
- New phone number generated (different from previous)
- New database entry created with same IMEI
- Phone works normally after recreation

---

### Test 8: Multiple Phones Per Character
**Objective:** Verify a character can have multiple phones with different numbers

**Steps:**
1. Give character 2 Phone items
2. Use first phone → note phone number A
3. Use second phone → note phone number B
4. Verify both entries in database:
   ```sql
   SELECT IMEI, Phone_Number FROM phones WHERE Character_ID = '[char_id]';
   ```

**Expected Results:**
- Two different phone numbers generated
- Two separate database entries
- Each phone maintains its own IMEI and number
- Both phones work independently

---

### Test 9: Settings and Contacts Persistence
**Objective:** Verify device-tied data persists correctly

**Steps:**
1. Use a phone and add a contact
2. Change a setting (e.g., enable plane mode)
3. Close and reopen the phone
4. Verify contacts and settings retained
5. Give phone to another player (trade/drop)
6. Have other player use the phone
7. Verify contacts and settings still present

**Expected Results:**
- Contacts persist with device (not character)
- Settings persist with device (not character)
- Phone number persists with device
- New owner sees previous owner's contacts/settings

---

### Test 10: Backward Compatibility - Character Phone Statebag
**Objective:** Verify character Phone statebag still functions for compatibility

**Steps:**
1. Trigger a statebag change for character Phone:
   ```lua
   Player(source).state.Phone = "1234567"
   ```
2. Verify `Client:RunChecks:Phone` event triggered
3. Verify character Phone field can still be read/written
4. Verify phone device system unaffected

**Expected Results:**
- Statebag handler still functional
- Character Phone can be updated independently
- Phone device numbers remain separate
- No conflicts between systems

---

## Performance Testing

### Load Test: Phone Number Generation
**Objective:** Verify performance with many phones

**Steps:**
1. Create 100+ phone items quickly
2. Monitor console for timing issues
3. Check for excessive collision retries
4. Verify all phones get unique numbers

**Expected Results:**
- All phones assigned unique numbers
- Minimal collision retries (<3 per phone)
- No significant performance degradation
- Database queries remain fast

---

## Regression Testing

### Existing Functionality Verification
**Checklist:**
- [ ] Phone opens with animation
- [ ] Prop attaches to player hand
- [ ] Lock screen works
- [ ] Settings app functions
- [ ] Contacts app functions
- [ ] Add/edit/delete contacts works
- [ ] Phone closes properly
- [ ] Settings persist across sessions
- [ ] Contacts persist across sessions
- [ ] Multiple players can use phones simultaneously

---

## Migration Testing (Optional)

### For Existing Deployments with Character Phone Numbers

**Steps:**
1. Backup database
2. Run migration script (if provided):
   ```sql
   -- Example migration to seed phones with character phone numbers
   INSERT INTO phones (IMEI, Phone_Number, Character_ID, Contacts, Settings, Created, Last_Used)
   SELECT 
       UUID(), 
       Phone, 
       Character_ID, 
       '[]', 
       '{"planeMode":false,"emergencyAlerts":true,"provider":"Warstock"}',
       NOW(),
       NOW()
   FROM characters 
   WHERE Phone IS NOT NULL AND Phone != ''
   AND NOT EXISTS (SELECT 1 FROM phones WHERE phones.Character_ID = characters.Character_ID);
   ```
3. Verify existing characters' phones work with their current numbers
4. Verify new phones still generate unique numbers

**Expected Results:**
- Existing characters keep their phone numbers (if migrated)
- New phones get new generated numbers
- No number collisions
- System works for both migrated and new phones

---

## Known Issues / Expected Behavior

1. **Character Phone Field**: Remains in character record for backward compatibility. Systems that rely on this field should be gradually migrated to use device-based lookups.

2. **First Use**: First use of a phone will create a new device-tied number. Existing deployments may want to run a migration script to preserve character phone numbers.

3. **Phone Trading**: When a phone is traded/dropped and picked up by another player, the phone number stays with the device (intended behavior).

4. **Number Exhaustion**: With 6-7 digit numbers, there are 9,000,000 to 9,999,999 possible numbers. Collision likelihood increases as more phones are created, but with max 10 retry attempts, generation should succeed for reasonable server populations.

---

## Troubleshooting

### Phone Number Generation Fails
- Check if database query for uniqueness is working: `ig.sql.phone.GetByNumber()`
- Verify `ig.rng.nums()` is functioning correctly
- Check for database connection issues
- Increase `maxAttempts` if needed for high-population servers

### Phone Opens with Wrong Number
- Verify database entry for that IMEI
- Check client payload in network inspector
- Verify no fallback to `xPlayer.Phone` occurring

### Phone Not Saving IMEI to Inventory
- Check `xPlayer.UpdateInventoryItem()` is called
- Verify inventory dirty flag system is working
- Check database for inventory persistence

---

## Success Criteria

All tests pass with:
- ✅ Unique phone numbers generated for all new phones
- ✅ Phone numbers stored in database, not from character
- ✅ Client always receives device phone number
- ✅ Character Phone field independent and unchanged
- ✅ Existing functionality (settings, contacts) works
- ✅ Backward compatibility maintained
- ✅ No critical errors in console
- ✅ Documentation accurately reflects implementation
