-- ====================================================================================--
-- Phones Table Creation
-- ====================================================================================--
-- 
-- Creates the phones table for device-tied phone number system.
-- Phone numbers are now tied to device (IMEI) rather than character.
--
-- ====================================================================================--

CREATE TABLE IF NOT EXISTS `phones` (
    `ID` INT(11) NOT NULL AUTO_INCREMENT,
    `IMEI` VARCHAR(36) NOT NULL COMMENT 'Unique device identifier (UUID)',
    `Phone_Number` VARCHAR(7) NOT NULL COMMENT 'Device phone number (6-7 digits)',
    `Character_ID` VARCHAR(50) NOT NULL COMMENT 'Current owner character ID',
    `Contacts` LONGTEXT DEFAULT '[]' COMMENT 'JSON array of contacts',
    `Settings` LONGTEXT DEFAULT '{"planeMode":false,"emergencyAlerts":true,"provider":"Warstock"}' COMMENT 'JSON object of phone settings',
    `Created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Phone device creation timestamp',
    `Last_Used` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last time phone was opened',
    
    PRIMARY KEY (`ID`),
    UNIQUE KEY `unique_imei` (`IMEI`),
    UNIQUE KEY `unique_phone_number` (`Phone_Number`),
    KEY `idx_character` (`Character_ID`),
    KEY `idx_last_used` (`Last_Used`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Device-tied phone records';

-- ====================================================================================--
-- Indexes Explanation:
-- ====================================================================================--
-- UNIQUE KEY `unique_imei`: Ensures each device has a unique IMEI
-- UNIQUE KEY `unique_phone_number`: Ensures no duplicate phone numbers
-- KEY `idx_character`: Fast lookup of phones by character owner
-- KEY `idx_last_used`: Optimize queries for phone cleanup/maintenance
-- ====================================================================================--
