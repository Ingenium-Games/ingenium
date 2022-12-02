-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.7.3-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for db
CREATE DATABASE IF NOT EXISTS `db` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `db`;

-- Dumping structure for table db.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `Primary_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The Character Owner\\',
  `Character_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The Character ID to be called as reference, C00:Unique_ID/C01:Unique_ID/C02:Unique_ID etc...',
  `Created` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Last_Seen` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `City_ID` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'City ID / License to be used for Government Actions',
  `First_Name` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Last_Name` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Birth_Date` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The Characters DOB in DD/MM/YYYY format.',
  `Height` int(3) DEFAULT NULL COMMENT 'The Characters height in CM.',
  `Phone` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Iban` varchar(9) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Job` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"Name":"none","Grade":1}',
  `Photo` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'img/icons8-team-100.png',
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

-- Dumping data for table db.characters: ~6 rows (approximately)
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- Dumping structure for table db.character_accounts
CREATE TABLE IF NOT EXISTS `character_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Account_Number` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Bank_Name` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT 'Maze',
  `Bank` int(11) DEFAULT NULL,
  `Pin` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0000',
  `Loan` int(11) DEFAULT NULL,
  `Duration` int(3) DEFAULT NULL,
  `Active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Character_ID` (`Character_ID`),
  UNIQUE KEY `Account_Number` (`Account_Number`),
  KEY `Duration` (`Duration`),
  KEY `Active` (`Active`),
  KEY `Bank` (`Bank_Name`) USING BTREE,
  CONSTRAINT `FK_character_accounts_characters` FOREIGN KEY (`Character_ID`) REFERENCES `characters` (`Character_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db.character_accounts: ~6 rows (approximately)
/*!40000 ALTER TABLE `character_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_accounts` ENABLE KEYS */;

-- Dumping structure for table db.character_outfits
CREATE TABLE IF NOT EXISTS `character_outfits` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) DEFAULT NULL,
  `Number` int(11) DEFAULT NULL,
  `Appearance` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Character_ID` (`Character_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table db.character_outfits: ~0 rows (approximately)
/*!40000 ALTER TABLE `character_outfits` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_outfits` ENABLE KEYS */;

-- Dumping structure for table db.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Grade` int(11) NOT NULL DEFAULT 1,
  `Grade_Label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Grade_Salary` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `Name` (`Name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db.jobs: ~39 rows (approximately)
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` (`ID`, `Name`, `Label`, `Grade`, `Grade_Label`, `Grade_Salary`) VALUES
	(1, 'none', 'Unemployed', 1, 'Unemployed', 8),
	(2, 'police', 'Police Department', 1, 'Cadet', 17),
	(3, 'police', '', 2, 'Junior Officer', 22),
	(4, 'police', '', 3, 'Officer', 26),
	(5, 'police', '', 4, 'Senior Officer', 29),
	(6, 'medic', 'Emergancy Medical Services', 1, 'Trainee', 19),
	(7, 'medic', NULL, 2, 'Paramedic', 24),
	(8, 'medic', NULL, 3, 'Doctor', 29),
	(9, 'pdm', 'Premium Motor Sport', 1, 'Pre-Delivery', 13),
	(10, 'pdm', NULL, 2, 'Floor Sales', 18),
	(11, 'pdm', NULL, 3, 'Sales Expert', 23),
	(12, 'pdm', NULL, 4, 'Operations Director', 27),
	(13, 'medic', NULL, 4, 'Cheif Medical Officer', 33),
	(14, 'police', NULL, 5, 'Cheif of Police', 33),
	(15, 'mechanic', 'Benny\'s Original Motorworks', 1, 'Apprentice', 12),
	(16, 'mechanic', NULL, 2, 'Mechanic', 22),
	(17, 'mechanic', NULL, 3, 'Import Logistics', 26),
	(18, 'mechanic', NULL, 4, 'Boss Man', 30),
	(19, 'news', 'Wezeal News', 1, 'Intern', 10),
	(20, 'news', NULL, 2, 'Camera Crew', 16),
	(21, 'news', NULL, 3, 'Reporter', 21),
	(22, 'news', NULL, 4, 'DJ Mixer', 25),
	(23, 'news', NULL, 5, 'News Anchor', 29),
	(24, 'garbage', 'Desperado\'s Waste Services', 1, 'Waste Colector', 15),
	(25, 'garbage', NULL, 2, 'Heavy Colections', 22),
	(26, 'garbage', NULL, 3, 'Renew Technition', 25),
	(27, 'garbage', NULL, 4, 'Service Logistic Manager', 28),
	(28, 'vargos', 'Vargos', 1, 'Repin Yellow', 5),
	(29, 'ballers', 'Ballers', 1, 'Repin Purple', 5),
	(30, 'famillies', 'Famillies', 1, 'Repin Green', 5),
	(31, 'aztecas', 'Aztecas', 1, 'Repin Red', 5),
	(32, 'pepe', 'Pepe\'s Pizzaria', 1, 'Delivery Driver', 10),
	(33, 'pepe', NULL, 2, 'Pizza Chef', 18),
	(34, 'pepe', NULL, 3, 'Franchisee', 24),
	(35, 'postal', 'Go Postal', 1, 'Delivery Driver', 13),
	(36, 'mining', 'Caveat Cutters Union', 1, 'Miner', 13),
	(37, 'lumber', 'Chippy Chop\'ns Wood Shop\'n', 1, 'Wood Cutter', 13),
	(38, 'chicken', 'Cluckin\' Bell', 1, 'Chicken Packer', 13),
	(39, 'bank', 'Fleeca', 1, 'Associate', 21),
	(40, 'city', 'State Department', 1, 'Major', 37),
	(41, 'logistics', 'OP Logistics', 1, 'Driver', 9),
	(42, 'altruists', 'Altruists', 1, 'Repin Nude', 5),
	(43, 'lostsc', 'Lost SC', 1, 'Repin Bikes', 5),
	(44, 'marabunta', 'Marabuntas', 1, 'Repin Things', 5),
	(45, 'triads', 'Triads', 1, 'Repin Golden Dragons', 5),
	(46, 'lostmc', 'Lost MC', 1, 'Repin Bikes', 5),
	(47, 'taxi', 'Taxi Service', 1, 'Driver', 6);
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;

-- Dumping structure for table db.job_accounts
CREATE TABLE IF NOT EXISTS `job_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Description` varchar(1500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Boss` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Members` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Accounts` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Stock` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]',
  `Inventory` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[]',
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `Name` (`Name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db.job_accounts: ~25 rows (approximately)
/*!40000 ALTER TABLE `job_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_accounts` ENABLE KEYS */;

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
/*!40000 ALTER TABLE `objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `objects` ENABLE KEYS */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Users Table';

-- Dumping data for table db.users: ~5 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

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

-- Dumping data for table db.vehicles: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
