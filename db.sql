-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               12.0.2-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.14.0.7165
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for db
CREATE DATABASE IF NOT EXISTS `db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `db`;

-- Dumping structure for table db.banking_accounts
CREATE TABLE IF NOT EXISTS `banking_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) DEFAULT NULL,
  `Account_Number` varchar(8) DEFAULT NULL,
  `Bank_Name` varchar(15) DEFAULT 'Maze',
  `Balance` decimal(10,2) DEFAULT NULL,
  `Iban` varchar(9) DEFAULT NULL,
  `Pin` varchar(12) NOT NULL DEFAULT '0000',
  `Loan` decimal(10,2) DEFAULT NULL,
  `Duration` int(3) DEFAULT NULL,
  `Active` tinyint(1) NOT NULL DEFAULT 0,
  `Banking_Favorites` longtext NOT NULL DEFAULT '[]',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Character_ID` (`Character_ID`),
  UNIQUE KEY `Account_Number` (`Account_Number`),
  KEY `Duration` (`Duration`),
  KEY `Active` (`Active`),
  KEY `Balance` (`Bank_Name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table db.banking_job_accounts
CREATE TABLE IF NOT EXISTS `banking_job_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Job` varchar(255) DEFAULT NULL,
  `Description` varchar(1500) DEFAULT NULL,
  `Boss` varchar(50) DEFAULT NULL,
  `Permitted` longtext DEFAULT NULL,
  `Balance` longtext DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY `Job` (`Job`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table db.banking_transactions
CREATE TABLE IF NOT EXISTS `banking_transactions` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) NOT NULL,
  `Type` varchar(50) NOT NULL COMMENT 'Transaction type: Transfer In/Out, Withdrawal, Deposit',
  `Description` varchar(255) DEFAULT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `Date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID`),
  KEY `Character_ID` (`Character_ID`),
  KEY `Date` (`Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Banking transaction history';

-- Data exporting was unselected.

-- Dumping structure for table db.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `Primary_ID` varchar(50) DEFAULT NULL COMMENT 'The Character Owner\\',
  `Character_ID` varchar(50) DEFAULT NULL COMMENT 'The Character ID to be called as reference, C00:Unique_ID/C01:Unique_ID/C02:Unique_ID etig...',
  `Created` varchar(50) DEFAULT NULL,
  `Last_Seen` varchar(50) DEFAULT NULL,
  `City_ID` varchar(10) DEFAULT NULL COMMENT 'City ID / License to be used for Government Actions',
  `First_Name` varchar(25) DEFAULT NULL,
  `Last_Name` varchar(25) DEFAULT NULL,
  `Iban` varchar(9) DEFAULT NULL,
  `Job` varchar(255) NOT NULL DEFAULT '{"Name":"none","Grade":"Unemployed"}',
  `Photo` longtext NOT NULL DEFAULT 'img/icons8-pogchamp-96.png',
  `Appearance` longtext NOT NULL DEFAULT '{"sex":0}',
  `Inventory` longtext NOT NULL DEFAULT '{}',
  `Licenses` longtext NOT NULL DEFAULT '{}',
  `Skills` longtext NOT NULL DEFAULT '[]',
  `Ammo` longtext NOT NULL DEFAULT '{"9mm":0,"5.56mm":0,"7.62mm":0,"20g":0,".223":0,".308":0}',
  `Accounts` longtext NOT NULL DEFAULT '{}',
  `Modifiers` longtext NOT NULL DEFAULT '{}',
  `Traits` longtext NOT NULL DEFAULT '{}',
  `Health` int(3) NOT NULL DEFAULT 400,
  `Armour` int(3) NOT NULL DEFAULT 0,
  `Hunger` int(3) NOT NULL DEFAULT 100,
  `Thirst` int(3) NOT NULL DEFAULT 100,
  `Stress` int(3) NOT NULL DEFAULT 0,
  `Instance` int(2) NOT NULL DEFAULT 0,
  `Coords` varchar(255) NOT NULL DEFAULT '{"x":-1050.30, "y":-2740.95, "z":14.6}' COMMENT 'Last Position Saved...',
  `Weight` int(3) NOT NULL DEFAULT 0,
  `Is_Jailed` tinyint(1) NOT NULL DEFAULT 0,
  `Jail_Time` int(5) NOT NULL DEFAULT 0,
  `Is_Dead` tinyint(1) NOT NULL DEFAULT 0,
  `Dead_Time` varchar(50) DEFAULT NULL,
  `Dead_Data` longtext DEFAULT NULL,
  `Wanted` tinyint(1) NOT NULL DEFAULT 0,
  `Active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY `Character_ID` (`Character_ID`) USING BTREE,
  KEY `City_ID` (`City_ID`) USING BTREE,
  KEY `Wanted` (`Wanted`) USING BTREE,
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Character Table';

-- Data exporting was unselected.

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Logisitics Company';

-- Data exporting was unselected.

-- Dumping structure for table db.objects
CREATE TABLE IF NOT EXISTS `objects` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `UUID` varchar(36) DEFAULT NULL,
  `Model` varchar(50) DEFAULT NULL COMMENT 'Hash ID',
  `Coords` varchar(355) NOT NULL DEFAULT '{"x":0.00,"y":0.00,"z":0.00,"h":0.00}',
  `Meta` longtext NOT NULL DEFAULT '[]',
  `States` longtext DEFAULT NULL,
  `Inventory` longtext DEFAULT NULL,
  `Created` varchar(50) DEFAULT NULL,
  `Updated` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UUID` (`UUID`),
  KEY `Created` (`Created`),
  KEY `Updated` (`Updated`),
  KEY `Model` (`Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Data exporting was unselected.

-- Dumping structure for table db.phones
CREATE TABLE IF NOT EXISTS `phones` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IMEI` varchar(36) NOT NULL COMMENT 'Unique device identifier (UUID)',
  `Phone_Number` varchar(7) NOT NULL COMMENT 'Device phone number (6-7 digits)',
  `Character_ID` varchar(50) NOT NULL COMMENT 'Current owner character ID',
  `Contacts` longtext DEFAULT '[]' COMMENT 'JSON array of contacts',
  `Settings` longtext DEFAULT '{"planeMode":false,"emergencyAlerts":true,"provider":"Warstock"}' COMMENT 'JSON object of phone settings',
  `Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Phone device creation timestamp',
  `Last_Used` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Last time phone was opened',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `unique_imei` (`IMEI`),
  UNIQUE KEY `unique_phone_number` (`Phone_Number`),
  KEY `idx_character` (`Character_ID`),
  KEY `idx_last_used` (`Last_Used`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Device-tied phone records';

-- Data exporting was unselected.

-- Dumping structure for table db.phone_email_accounts
CREATE TABLE IF NOT EXISTS `phone_email_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) NOT NULL COMMENT 'Owner character ID',
  `Email_Address` varchar(100) NOT NULL COMMENT 'Email address (e.g., user@domain.com)',
  `Password_Hash` varchar(255) NOT NULL COMMENT 'Hashed password',
  `Created_At` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Account creation timestamp',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `unique_email` (`Email_Address`),
  KEY `idx_character` (`Character_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Phone email accounts';

-- Data exporting was unselected.

-- Dumping structure for table db.phone_emails
CREATE TABLE IF NOT EXISTS `phone_emails` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Sender` varchar(100) NOT NULL COMMENT 'Sender email address',
  `Recipient` varchar(100) NOT NULL COMMENT 'Recipient email address',
  `Subject` varchar(200) DEFAULT NULL COMMENT 'Email subject',
  `Message` longtext NOT NULL COMMENT 'Email message body',
  `Sent_At` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Email send timestamp',
  `Read_Status` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Whether email has been read (0=unread, 1=read)',
  PRIMARY KEY (`ID`),
  KEY `idx_sender` (`Sender`),
  KEY `idx_recipient` (`Recipient`),
  KEY `idx_sent_at` (`Sent_At`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Phone emails';

-- Data exporting was unselected.

-- Dumping structure for table db.users
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `Username` varchar(255) DEFAULT NULL,
  `License_ID` varchar(50) DEFAULT NULL COMMENT 'Unique ID assigned by FiveM (The License)',
  `FiveM_ID` varchar(50) DEFAULT NULL,
  `Steam_ID` varchar(50) DEFAULT NULL COMMENT 'Unique ID assigned by Steam',
  `Discord_ID` varchar(50) DEFAULT NULL COMMENT 'Unique ID assigned by Discord',
  `Locale` varchar(4) DEFAULT NULL COMMENT 'Language Preferance as Key',
  `Ace` varchar(10) DEFAULT 'public' COMMENT 'All users are Public, Moderators are Mods and Admins are Admins. No Higher Roler than Admin.',
  `Join_Date` varchar(50) DEFAULT NULL,
  `Last_Login` varchar(50) DEFAULT NULL,
  `IP_Address` varchar(18) DEFAULT NULL COMMENT 'Last Connected IP Address',
  `Slots` int(11) NOT NULL DEFAULT 1,
  `Supporter` tinyint(1) NOT NULL DEFAULT 0,
  `Ban` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 is Not Banned. 1 is Banned.',
  `Ban_Reason` longtext DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY `License_ID` (`License_ID`) USING BTREE,
  KEY `Language_Key` (`Locale`) USING BTREE,
  KEY `Ban_Status` (`Ban`) USING BTREE,
  KEY `Supporter_Status` (`Supporter`) USING BTREE,
  KEY `Ace` (`Ace`),
  KEY `Slots` (`Slots`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Users Table';

-- Data exporting was unselected.

-- Dumping structure for table db.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) DEFAULT NULL,
  `Model` varchar(50) DEFAULT NULL COMMENT 'Hash ID',
  `Plate` varchar(8) DEFAULT NULL,
  `Coords` varchar(355) NOT NULL DEFAULT '{"x":0.00,"y":0.00,"z":0.00,"h":0.00}',
  `Keys` longtext NOT NULL DEFAULT '[]',
  `Condition` longtext NOT NULL DEFAULT '[]',
  `Inventory` longtext NOT NULL DEFAULT '[]',
  `Modifications` longtext NOT NULL DEFAULT '[]',
  `Fuel` int(3) DEFAULT 100,
  `Mileage` int(11) NOT NULL DEFAULT 0,
  `Parked` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'In = True / Out = False',
  `Impound` tinyint(1) NOT NULL DEFAULT 0,
  `Wanted` tinyint(1) NOT NULL DEFAULT 0,
  `Spawned` tinyint(1) DEFAULT 0,
  `Updated` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Plate` (`Plate`),
  KEY `Character_ID` (`Character_ID`),
  KEY `Impound` (`Impound`),
  KEY `Wanted` (`Wanted`),
  KEY `State` (`Parked`) USING BTREE,
  KEY `Mileage` (`Mileage`),
  KEY `Spawned` (`Spawned`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
