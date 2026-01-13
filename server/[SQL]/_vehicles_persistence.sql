-- Vehicle Persistence System Migration
-- Extends vehicles table to support persistent NPC/world vehicle tracking
-- Owner vehicles remain in vehicles table (Character_ID present)
-- Persistent tracked vehicles loaded at startup, managed in Lua + JSON, synced to DB

-- Extend existing vehicles table with persistence tracking fields
-- NOTE: Owned vehicles = Character_ID present (in DB always)
--       Persistent tracked vehicles = Character_ID NULL, tracked in Lua + JSON file
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `Persistent_Type` ENUM('owned', 'npc', 'world') DEFAULT 'owned' COMMENT 'Vehicle classification';
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `NPC_Owner` VARCHAR(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'NPC identifier if not player-owned';
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `Is_Persistent` TINYINT(1) DEFAULT 0 COMMENT 'Registered as persistent (player interacted)?';
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `Last_Position` VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Last known coords JSON';
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `Last_Condition` LONGTEXT COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Last known damage state JSON';
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `Statebag_Data` LONGTEXT COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'xVehicle and custom properties JSON';
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `Last_Interaction` TIMESTAMP DEFAULT NULL COMMENT 'When player last interacted';
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `Interaction_Count` INT(11) DEFAULT 0 COMMENT 'Number of player interactions';

-- Add indexes for persistence queries
ALTER TABLE `vehicles` ADD KEY IF NOT EXISTS `Persistent_Type` (`Persistent_Type`);
ALTER TABLE `vehicles` ADD KEY IF NOT EXISTS `NPC_Owner` (`NPC_Owner`);
ALTER TABLE `vehicles` ADD KEY IF NOT EXISTS `Is_Persistent` (`Is_Persistent`);
ALTER TABLE `vehicles` ADD KEY IF NOT EXISTS `Last_Interaction` (`Last_Interaction`);

-- NOTE: vehicle_persistence_state and vehicle_interactions tables removed
-- Runtime state tracking handled internally in Lua via xVehicle properties
-- Persistent vehicle data cached in data/persistent_vehicles.json at startup
