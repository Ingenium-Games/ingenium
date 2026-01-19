-- --------------------------------------------------------
-- Host:                         192.168.1.20
-- Server version:               10.7.3-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;


-- Dumping database structure for db
CREATE DATABASE IF NOT EXISTS `db` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `db`;

-- Dumping structure for table db.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `Primary_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The Character Owner\\',
  `Character_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The Character ID to be called as reference, C00:Unique_ID/C01:Unique_ID/C02:Unique_ID etig...',
  `Created` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Last_Seen` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `City_ID` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'City ID / License to be used for Government Actions',
  `First_Name` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Last_Name` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Phone` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Iban` varchar(9) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Job` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"Name":"none","Grade":1}',
  `Photo` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'img/icons8-pogchamp-96.png',
  `Appearance` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"sex":0}',
  `Inventory` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{}',
  `Licenses` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{}',
  `Skills` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]',
  `Ammo` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"9mm":0,"5.56mm":0,"7.62mm":0,"20g":0,".223":0,".308":0}',
  `Accounts` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{}',
  `Modifiers` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{}',
  `Traits` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{}',
  `Health` int(3) NOT NULL DEFAULT 400,
  `Armour` int(3) NOT NULL DEFAULT 0,
  `Hunger` int(3) NOT NULL DEFAULT 100,
  `Thirst` int(3) NOT NULL DEFAULT 100,
  `Stress` int(3) NOT NULL DEFAULT 0,
  `Instance` int(2) NOT NULL DEFAULT 0,
  `Coords` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"x":-1050.30, "y":-2740.95, "z":14.6}' COMMENT 'Last Position Saved...',
  `Weight` int(3) NOT NULL DEFAULT 0,
  `Is_Jailed` tinyint(1) NOT NULL DEFAULT 0,
  `Jail_Time` int(5) NOT NULL DEFAULT 0,
  `Is_Dead` tinyint(1) NOT NULL DEFAULT 0,
  `Dead_Time` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Dead_Data` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Wanted` tinyint(1) NOT NULL DEFAULT 0,
  `Active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY `Character_ID` (`Character_ID`) USING BTREE,
  KEY `City_ID` (`City_ID`) USING BTREE,
  KEY `Wanted` (`Wanted`) USING BTREE,
  KEY `Phone` (`Phone`) USING BTREE,
  KEY `Primary_ID` (`Primary_ID`) USING BTREE,
  KEY `Status` (`Hunger`) USING BTREE,
  KEY `Thirst` (`Thirst`),
  KEY `Health` (`Health`),
  KEY `Armour` (`Armour`),
  KEY `Is_Dead` (`Is_Dead`),
  KEY `Weight` (`Weight`),
  KEY `Active` (`Active`),
  KEY `Stress` (`Stress`),
  KEY `Is_Jailed` (`Is_Jailed`),
  KEY `Instance` (`Instance`),
  KEY `IBAN` (`Iban`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Character Table';

-- Dumping data for table db.characters: ~0 rows (approximately)

-- Dumping structure for table db.banking_accounts
CREATE TABLE IF NOT EXISTS `banking_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Account_Number` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Bank_Name` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT 'Maze',
  `Bank` decimal(10,2) DEFAULT NULL,
  `Iban` varchar(9) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Pin` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0000',
  `Loan` decimal(10,2) DEFAULT NULL,
  `Duration` int(3) DEFAULT NULL,
  `Active` tinyint(1) NOT NULL DEFAULT 0,
  `Banking_Favorites` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Character_ID` (`Character_ID`),
  UNIQUE KEY `Account_Number` (`Account_Number`),
  KEY `Duration` (`Duration`),
  KEY `Active` (`Active`),
  KEY `Bank` (`Bank_Name`) USING BTREE,
  CONSTRAINT `Remove_Character_ID_On_Character_Delete` FOREIGN KEY (`Character_ID`) REFERENCES `characters` (`Character_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping structure for table db.banking_job_accounts
CREATE TABLE IF NOT EXISTS `banking_job_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Job` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Description` varchar(1500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Boss` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL, -- Character ID of owner / boss of account
  `Members` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Accounts` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY `Job` (`Job`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- Dumping data for table db.banking_job_accounts: ~25 rows (approximately)
INSERT INTO `banking_job_accounts` (`ID`, `Job`, `Description`, `Boss`, `Members`, `Accounts`) VALUES
	(1, 'pepe', 'Pepe\'s Pizzaria : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(2, 'taxi', 'Taxi Service : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(3, 'chicken', 'Cluckin\' Bell : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(4, 'pdm', 'Premium Motor Sport : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(5, 'lostmc', 'Lost MC : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(6, 'city', 'State Department : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(7, 'triads', 'Triads : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(8, 'marabunta', 'Marabuntas : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(9, 'aztecas', 'Aztecas : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(10, 'lostsc', 'Lost SC : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(11, 'altruists', 'Altruists : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(12, 'vargos', 'Vargos : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(13, 'garbage', 'Desperado\'s Waste Services : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(14, 'none', 'Unemployed : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(15, 'logistics', 'OP Logistics : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(16, 'bank', 'Fleeca : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(17, 'news', 'Wezeal News : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(18, 'lumber', 'Chippy Chop\'ns Wood Shop\'n : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(19, 'mining', 'Caveat Cutters Union : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(20, 'police', 'Police Department : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(21, 'postal', 'Go Postal : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(22, 'famillies', 'Famillies : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(23, 'medic', 'Emergancy Medical Services : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(24, 'mechanic', 'Benny\'s Original Motorworks : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}'),
	(25, 'ballers', 'Ballers : Description for role here.', 'Not Owned', '[]', '{"Safe":0.0,"Bank":5000.0}');

-- Dumping structure for table db.logistics
CREATE TABLE IF NOT EXISTS `logistics` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Origin` varchar(50) DEFAULT NULL,
  `Contact` varchar(7) DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Store` tinyint(1) NOT NULL DEFAULT 0,
  `Type` int(1) DEFAULT NULL,
  `Driver` varchar(50) DEFAULT NULL,
  `Content` longtext NOT NULL DEFAULT '[]',
  `Insured` tinyint(1) NOT NULL DEFAULT 0,
  `New` tinyint(1) NOT NULL DEFAULT 0,
  `Out` tinyint(1) NOT NULL DEFAULT 0,
  `Delivered` tinyint(1) NOT NULL DEFAULT 0,
  `Stolen` tinyint(1) NOT NULL DEFAULT 0,
  `Missing` tinyint(1) NOT NULL DEFAULT 0,
  `Updated` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Insured` (`Insured`),
  KEY `New` (`New`),
  KEY `Delivered` (`Delivered`),
  KEY `Stolen` (`Stolen`),
  KEY `Missing` (`Missing`),
  KEY `Origin` (`Origin`),
  KEY `Type` (`Type`),
  KEY `Contact` (`Contact`),
  KEY `Out` (`Out`),
  KEY `Driver` (`Driver`),
  KEY `Store` (`Store`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Logisitics Company';

-- Dumping data for table db.logistics: ~0 rows (approximately)

-- Dumping structure for table db.objects
CREATE TABLE IF NOT EXISTS `objects` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `UUID` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Model` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Hash ID',
  `Coords` varchar(355) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"x":0.00,"y":0.00,"z":0.00,"h":0.00}',
  `Meta` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]',
  `States` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Inventory` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Created` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Updated` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UUID` (`UUID`),
  KEY `Created` (`Created`),
  KEY `Updated` (`Updated`),
  KEY `Model` (`Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table db.objects: ~0 rows (approximately)

-- Dumping structure for table db.users
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `Username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `License_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique ID assigned by FiveM (The License)',
  `FiveM_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Steam_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique ID assigned by Steam',
  `Discord_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique ID assigned by Discord',
  `Locale` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Language Preferance as Key',
  `Ace` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'public' COMMENT 'All users are Public, Moderators are Mods and Admins are Admins. No Higher Roler than Admin.',
  `Join_Date` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Last_Login` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_Address` varchar(18) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Last Connected IP Address',
  `Slots` int(11) NOT NULL DEFAULT 1,
  `Supporter` tinyint(1) NOT NULL DEFAULT 0,
  `Ban` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 is Not Banned. 1 is Banned.',
  `Ban_Reason` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY `License_ID` (`License_ID`) USING BTREE,
  KEY `Language_Key` (`Locale`) USING BTREE,
  KEY `Ban_Status` (`Ban`) USING BTREE,
  KEY `Supporter_Status` (`Supporter`) USING BTREE,
  KEY `Ace` (`Ace`),
  KEY `Slots` (`Slots`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Users Table';

-- Dumping structure for table db.phones
CREATE TABLE IF NOT EXISTS `phones` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IMEI` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Unique phone identifier (UUID)',
  `Phone_Number` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Phone number from characters table',
  `Character_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Current owner',
  `Contacts` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]' COMMENT 'Contact list JSON',
  `Settings` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"planeMode":false,"emergencyAlerts":true,"provider":"Warstock"}' COMMENT 'Phone settings JSON',
  `Created` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Last_Used` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IMEI` (`IMEI`),
  KEY `Phone_Number` (`Phone_Number`),
  KEY `Character_ID` (`Character_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Phone data storage table';

-- Dumping structure for table db.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Model` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Hash ID',
  `Plate` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Coords` varchar(355) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"x":0.00,"y":0.00,"z":0.00,"h":0.00}',
  `Keys` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]',
  `Condition` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]',
  `Inventory` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]',
  `Modifications` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]',
  `Fuel` int(3) DEFAULT 100,
  `Mileage` int(11) NOT NULL DEFAULT 0,
  `Parked` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'In = True / Out = False',
  `Impound` tinyint(1) NOT NULL DEFAULT 0,
  `Wanted` tinyint(1) NOT NULL DEFAULT 0,
  `Spawned` tinyint(1) DEFAULT 0,
  `Updated` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Plate` (`Plate`),
  KEY `Character_ID` (`Character_ID`),
  KEY `Impound` (`Impound`),
  KEY `Wanted` (`Wanted`),
  KEY `State` (`Parked`) USING BTREE,
  KEY `Mileage` (`Mileage`),
  KEY `Spawned` (`Spawned`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET NOTE_VERBOSITY=IFNULL(@OLD_NOTE_VERBOSITY, 1) */;
