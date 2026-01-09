-- ====================================================================================--
-- Banking System Database Migration
-- ====================================================================================--

-- Add Banking_Favorites column to characters table if it doesn't exist
ALTER TABLE `characters` 
ADD COLUMN IF NOT EXISTS `Banking_Favorites` LONGTEXT DEFAULT '[]' 
COMMENT 'JSON array of favorite payees';

-- Create banking_transactions table for transaction history
CREATE TABLE IF NOT EXISTS `banking_transactions` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Type` VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Transaction type: Transfer In/Out, Withdrawal, Deposit',
  `Description` VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Amount` DECIMAL(10,2) NOT NULL,
  `Date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `Character_ID` (`Character_ID`),
  KEY `Date` (`Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Banking transaction history';

-- ====================================================================================--
-- Migration Complete
-- ====================================================================================--
