-- ====================================================================================--
-- Phone Number Migration Script (OPTIONAL)
-- ====================================================================================--
-- 
-- This script is for EXISTING deployments that want to preserve character phone numbers
-- when migrating to the device-tied phone number system.
--
-- WARNING: Run this BEFORE deploying the phone decoupling changes, or existing phones
-- in inventories will generate new numbers on first use.
--
-- ====================================================================================--

-- ====================================================================================--
-- USAGE INSTRUCTIONS
-- ====================================================================================--
--[[
    1. Backup your database before running this script
    2. Review the logic below and adjust as needed for your deployment
    3. Execute this script in your MySQL client or via a migration tool
    4. Verify results before deploying the new phone system
    5. After deployment, new phones will generate device-tied numbers automatically
--]]

-- ====================================================================================--
-- Step 1: Create phones table entry for each character with a phone
-- ====================================================================================--
-- This will seed the phones table with entries using characters' existing Phone values
-- Only creates entries for characters that don't already have a phone record

INSERT INTO phones (IMEI, Phone_Number, Character_ID, Contacts, Settings, Created, Last_Used)
SELECT 
    UUID() as IMEI,                                -- Generate new IMEI
    c.Phone as Phone_Number,                       -- Use existing character phone number
    c.Character_ID,                                -- Link to character
    '[]' as Contacts,                              -- Empty contacts
    '{"planeMode":false,"emergencyAlerts":true,"provider":"Warstock"}' as Settings,
    NOW() as Created,
    NOW() as Last_Used
FROM characters c
WHERE c.Phone IS NOT NULL 
  AND c.Phone != ''
  AND LENGTH(c.Phone) >= 6
  AND NOT EXISTS (
      SELECT 1 FROM phones p WHERE p.Character_ID = c.Character_ID
  );

-- Verify the migration
SELECT COUNT(*) as migrated_phones FROM phones;

-- ====================================================================================--
-- Step 2 (OPTIONAL): Update inventory items with IMEI meta
-- ====================================================================================--
-- This step is OPTIONAL and depends on your inventory structure
-- If your inventory stores JSON meta, you may want to pre-populate IMEI for existing phones
-- This is complex and depends on your inventory schema, so this is just a reference

-- Example approach (adjust to your schema):
/*
UPDATE inventory i
JOIN characters c ON i.Character_ID = c.Character_ID
JOIN phones p ON p.Character_ID = c.Character_ID
SET i.Meta = JSON_SET(
    COALESCE(i.Meta, '{}'),
    '$.IMEI', p.IMEI,
    '$.About', CONCAT('iFruit X - IMEI: ', p.IMEI)
)
WHERE i.Item = 'Phone'
  AND (i.Meta IS NULL OR JSON_EXTRACT(i.Meta, '$.IMEI') IS NULL);
*/

-- Note: The above is a generic example. Your inventory table structure may differ.
-- If you skip this step, phones will be initialized with new IMEIs on first use,
-- but will use the migrated phone numbers from the phones table if they exist.

-- ====================================================================================--
-- Step 3: Verification Queries
-- ====================================================================================--

-- Check for duplicate phone numbers (should return 0 rows)
SELECT Phone_Number, COUNT(*) as count
FROM phones
GROUP BY Phone_Number
HAVING count > 1;

-- Check for invalid phone numbers (should return 0 rows)
SELECT IMEI, Phone_Number, Character_ID
FROM phones
WHERE LENGTH(Phone_Number) < 6 OR LENGTH(Phone_Number) > 7;

-- Check characters with phones but no phones table entry (should be 0 after migration)
SELECT Character_ID, Name, Phone
FROM characters c
WHERE Phone IS NOT NULL 
  AND Phone != ''
  AND NOT EXISTS (SELECT 1 FROM phones p WHERE p.Character_ID = c.Character_ID);

-- ====================================================================================--
-- Step 4: Post-Migration Cleanup (OPTIONAL)
-- ====================================================================================--
-- After verifying the migration is successful and the new system is working,
-- you may optionally want to clear character phone numbers to avoid confusion.
-- This is NOT required as the new system ignores character phone numbers.

-- CAUTION: Only run this after verifying the phone device system is working!
/*
UPDATE characters
SET Phone = NULL
WHERE Phone IS NOT NULL;
*/

-- ====================================================================================--
-- Notes:
-- ====================================================================================--
-- 1. This migration preserves existing character phone numbers by creating device records
-- 2. After migration, these phones will work with their existing numbers
-- 3. New phones will generate fresh device-tied numbers (6-7 digits)
-- 4. Character Phone field is maintained for backward compatibility but not used
-- 5. Players can have multiple phones, each with different numbers
-- ====================================================================================--
