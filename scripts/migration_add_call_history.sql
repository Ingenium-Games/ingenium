-- ====================================================================================--
-- Add CallHistory Column to Phones Table
-- ====================================================================================--
-- 
-- Migration script to add the CallHistory column for phone call tracking.
-- This is required for the phone calls feature.
--
-- ====================================================================================--

-- Add CallHistory column if it doesn't exist
ALTER TABLE `phones` 
ADD COLUMN IF NOT EXISTS `CallHistory` LONGTEXT DEFAULT '[]' COMMENT 'JSON array of call history' 
AFTER `Contacts`;

-- ====================================================================================--
-- Notes:
-- ====================================================================================--
-- - CallHistory stores an array of call objects with: id, number, type, duration, timestamp
-- - Default value is empty array '[]'
-- - This migration is safe to run multiple times (IF NOT EXISTS)
-- ====================================================================================--
