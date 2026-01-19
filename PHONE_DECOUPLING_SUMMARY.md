# Phone Number Decoupling - Implementation Summary

## Executive Summary

This implementation decouples phone numbers from character records, making the `phones` database table the canonical source of truth for phone numbers. Previously, phone numbers were seeded from the character's `Phone` field when a phone item was first used. Now, each physical phone device generates its own unique phone number, enabling true SIM card behavior where phones can be traded or transferred with their associated numbers.

## Technical Changes

### 1. Phone Number Generation (`ig.phone.GeneratePhoneNumber()`)

**Location:** `server/[Data - No Save Needed]/_phone.lua`

**Implementation:**
```lua
function ig.phone.GeneratePhoneNumber()
    local maxAttempts = 10
    local attempts = 0
    
    repeat
        attempts = attempts + 1
        local length = math.random(6, 7)
        local phoneNumber = ig.rng.nums(length)
        
        local existing = ig.sql.phone.GetByNumber(phoneNumber)
        if not existing then
            return phoneNumber
        end
        
        ig.log.Debug("Phone", "Phone number collision, retrying...")
    until attempts >= maxAttempts
    
    ig.log.Error("Phone", "Failed to generate unique phone number")
    return nil
end
```

**Key Features:**
- Generates 6-7 digit phone numbers using `ig.rng.nums()`
- Verifies uniqueness against existing phones via `ig.sql.phone.GetByNumber()`
- Retry logic with max 10 attempts to handle collisions
- Returns `nil` on failure (gracefully handled by caller)

### 2. Phone Creation (`ig.phone.GetOrCreate()`)

**Changes:**
- **Before:** Used `xPlayer.Phone` to seed new phone records
  ```lua
  local success, imei = ig.sql.phone.Create({
      Phone_Number = xPlayer.Phone,  -- ❌ Character-tied
      Character_ID = xPlayer.Character_ID
  })
  ```

- **After:** Uses generated phone numbers
  ```lua
  local phoneNumber = ig.phone.GeneratePhoneNumber()
  if not phoneNumber then
      ig.log.Error("Phone", "Failed to generate phone number")
      return nil
  end
  
  local success, imei = ig.sql.phone.Create({
      Phone_Number = phoneNumber,  -- ✅ Device-tied
      Character_ID = xPlayer.Character_ID
  })
  ```

**Behavior:**
- Existing phones with IMEI: Lookup and update timestamp (unchanged)
- New phones: Generate unique number and create database record
- Failed generation: Error logged, player notified, no partial records

### 3. Phone Usage (`ig.phone.Use()`)

**Changes:**
- **Before:** Fallback to character phone number
  ```lua
  TriggerClientEvent("Client:Phone:Use", source, {
      phoneNumber = phoneData.Phone_Number or xPlayer.Phone,  -- ❌ Fallback
  })
  ```

- **After:** Always use database phone number
  ```lua
  TriggerClientEvent("Client:Phone:Use", source, {
      phoneNumber = phoneData.Phone_Number,  -- ✅ Device-tied only
  })
  ```

**Benefit:** Client always receives the device's phone number, no ambiguity

### 4. Statebag Handler (`server/[Onesync]/_sbch.lua`)

**Change:** Added migration guidance comment
```lua
-- Note: The Phone statebag is maintained for backward compatibility with existing systems.
-- As of the phone device decoupling implementation, phone numbers are now tied to physical
-- phone devices (stored in phones.Phone_Number) rather than characters. Consider migrating
-- systems that rely on character phone numbers to use device-based phone lookups instead.
```

**Purpose:** Inform developers of the transition while maintaining compatibility

## Documentation Updates

### 1. Implementation Guide (`Implementations/PHONE_SYSTEM.md`)

**Changes:**
- Replaced "No SIM Swap - Phone number is tied to character" with "Device-Tied Phone Numbers"
- Added "Phone Number Generation" section explaining the process
- Updated usage instructions to mention device-tied behavior

### 2. API Reference (`Documentation/PHONE_API.md`)

**Changes:**
- Added `ig.phone.GeneratePhoneNumber()` to API documentation
- Clarified that `Phone_Number` is auto-generated if not provided
- Updated phone data structure to note "device-tied" numbers
- Added note about automatic generation in inventory system

## Testing & Migration

### Testing Guide (`PHONE_DECOUPLING_TEST_PLAN.md`)

**Contents:**
- 10 comprehensive test cases
- Performance testing guidelines
- Regression testing checklist
- Troubleshooting guide
- Success criteria

### Migration Script (`scripts/migration_phone_numbers.sql`)

**Purpose:** Optional script for existing deployments to preserve character phone numbers

**Features:**
- Seeds `phones` table with entries using existing character phone numbers
- Includes verification queries
- Optional cleanup steps
- Safe with rollback capability

## Backward Compatibility

### What's Maintained
1. **Character Phone Field:** Still exists and can be read/written
2. **Phone Statebag Handler:** Still functional for legacy systems
3. **Existing Phone API:** All existing functions work as before

### What's Changed
1. **Phone Creation:** No longer seeds from character Phone field
2. **Phone Usage:** No longer falls back to character Phone field
3. **Data Source:** Device phone number is always from `phones.Phone_Number`

## Migration Strategies

### Strategy 1: Preserve Existing Numbers (Recommended)
1. Run `scripts/migration_phone_numbers.sql` before deployment
2. Existing characters' phone numbers become device-tied
3. New phones generate fresh numbers
4. Smooth transition with no user impact

### Strategy 2: Fresh Start
1. Deploy without migration
2. All phones generate new numbers on first use
3. Character phone numbers remain in database but unused
4. Simpler deployment, may confuse existing users

## Benefits

1. **True SIM Card Behavior:** Phones can be traded/sold with their numbers
2. **Reduced Coupling:** Phone system independent of character system
3. **Better Data Model:** Phone number belongs to device, not person
4. **Flexibility:** Character can have multiple phones with different numbers
5. **Consistency:** One source of truth for phone numbers (database)

## Potential Concerns & Solutions

### Concern 1: "What about existing systems that use character phone numbers?"
**Solution:** Character Phone field and statebag are maintained for backward compatibility. Systems can be gradually migrated at their own pace.

### Concern 2: "What if phone number generation fails?"
**Solution:** Graceful error handling with user notification. No partial/corrupt database records created. System can be retried safely.

### Concern 3: "What about number exhaustion?"
**Solution:** With 6-7 digit numbers, there are 9-10 million possible combinations. For typical server populations (<10k players), collision risk is minimal. Max retry attempts (10) ensure robustness.

### Concern 4: "How do we preserve existing phone numbers?"
**Solution:** Optional migration script provided in `scripts/migration_phone_numbers.sql`. Can be run before deployment to seed devices with character phone numbers.

## Testing Recommendations

### Before Deployment
1. Run migration script (if preserving numbers)
2. Test on staging environment with test data
3. Verify phone generation works
4. Verify existing phones still function
5. Test phone trading/transfer scenarios

### After Deployment
1. Monitor server logs for generation failures
2. Verify new phones get unique numbers
3. Check for collision retry patterns
4. Validate database integrity (no duplicates)
5. Confirm user feedback is positive

## Success Metrics

- ✅ All new phones receive unique device-tied numbers
- ✅ No character Phone field dependencies in phone system
- ✅ Client always receives database phone number
- ✅ Existing functionality (settings, contacts) unchanged
- ✅ Backward compatibility maintained
- ✅ Documentation accurately reflects implementation
- ✅ Migration path provided for existing deployments

## Future Enhancements

1. **SIM Card Items:** Separate SIM card items that can be inserted/removed from phones
2. **Phone Number Porting:** Transfer numbers between devices
3. **Number Directory:** Phone number lookup service
4. **Carrier Assignment:** Different carriers with different number ranges
5. **Call History:** Per-device call logs tied to phone number

## Conclusion

This implementation successfully decouples phone numbers from character records, establishing the phones database as the single source of truth. The change is minimal, surgical, and maintains backward compatibility while enabling future phone-related features. With comprehensive testing and migration support, the transition should be smooth for existing deployments.
