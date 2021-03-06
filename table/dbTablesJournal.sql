-- Datenbank Tabellen Vorlage für die Journal Datenbank
-- 

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `recipient`
--

CREATE TABLE `recipient` (
  `recipientID` INT(11) NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(64) NOT NULL,
  `active` ENUM('Y','N') NOT NULL DEFAULT 'Y',
  `customerNumber` VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY (`recipientID`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COMMENT = 'Empfaenger';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `journal`
--

CREATE TABLE `journal` (
  `entryID` INT(11) NOT NULL AUTO_INCREMENT,
  `created` DATETIME NOT NULL DEFAULT current_timestamp(),
  `date` DATE DEFAULT NULL,
  `recipient` INT(11) DEFAULT NULL,
  `invoiceNo` VARCHAR(64) DEFAULT NULL,
  `entryText` TEXT DEFAULT NULL,
  `grandTotal` DECIMAL(15,3) NOT NULL DEFAULT 0.000,
  `debitAccount` VARCHAR(5) DEFAULT NULL,
  `creditAccount` VARCHAR(5) DEFAULT NULL,
  `period` INT(11) DEFAULT NULL,
  `classification1` INT(11) DEFAULT NULL,
  `classification2` INT(11) DEFAULT NULL,
  `classification3` INT(11) DEFAULT NULL,
  `entryReference` INT(11) DEFAULT NULL,
  `reconcilation` ENUM('Y','N') NOT NULL DEFAULT 'N',
  PRIMARY KEY (`entryID`),
  KEY `recipient` (`recipient`),
  KEY `debitAccount` (`debitAccount`),
  KEY `creditAccount` (`creditAccount`),
  KEY `period` (`period`),
  KEY `classification1` (`classification1`),
  KEY `classification2` (`classification2`),
  KEY `classification3` (`classification3`),
  KEY `entryReference` (`entryReference`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COMMENT = 'Journal';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `classification`
--

CREATE TABLE `classification` (
  `classificationID` INT(11) NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(64) NOT NULL,
  `active` ENUM('Y','N') NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`classificationID`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COMMENT = 'Klassifikation';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `account`
--

CREATE TABLE `account` (
  `accountID` VARCHAR(5) NOT NULL,
  `label` VARCHAR(32) NOT NULL,
  `category` VARCHAR(3) NOT NULL,
  `accountNo` VARCHAR(2) NOT NULL,
  `active` ENUM('Y','N') NOT NULL DEFAULT 'Y',
  `reconcilationAllow` ENUM('Y','N') NOT NULL DEFAULT 'N',
  PRIMARY KEY (`accountID`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COMMENT = 'Konto';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `accountCategory`
--

CREATE TABLE `accountCategory` (
  `categoryID` VARCHAR(3) NOT NULL,
  `label` VARCHAR(32),
  `class` VARCHAR(1) NOT NULL,
  `categoryNo` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`categoryID`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COMMENT = 'Konto-Kategorie';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `accountClass`
--

CREATE TABLE `accountClass` (
  `classID` VARCHAR(1) NOT NULL,
  `label` VARCHAR(32),
  `sign` TINYINT NOT NULL,
  PRIMARY KEY (`classID`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COMMENT = 'Konto-Klasse';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `period`
--

CREATE TABLE `period` (
  `periodID` INT(11) NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(32) NOT NULL,
  `active` ENUM('Y','N') NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`periodID`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COMMENT = 'Periode';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `template`
--

CREATE TABLE `template` (
  `templateID` INT(11) NOT NULL AUTO_INCREMENT,
  `created` DATETIME NOT NULL DEFAULT current_timestamp(),
  `label` VARCHAR(32) NOT NULL,
  `recipient` INT(11) DEFAULT NULL,
  `invoiceNo` VARCHAR(64) DEFAULT NULL,
  `entryText` TEXT DEFAULT NULL,
  `grandTotal` DECIMAL(15,3) NOT NULL DEFAULT 0.000,
  `debitAccount` VARCHAR(5) DEFAULT NULL,
  `creditAccount` VARCHAR(5) DEFAULT NULL,
  `period` INT(11) DEFAULT NULL,
  `classification1` INT(11) DEFAULT NULL,
  `classification2` INT(11) DEFAULT NULL,
  `classification3` INT(11) DEFAULT NULL,
  PRIMARY KEY (`templateID`),
  KEY `recipient` (`recipient`),
  KEY `debitAccount` (`debitAccount`),
  KEY `creditAccount` (`creditAccount`),
  KEY `period` (`period`),
  KEY `classification1` (`classification1`),
  KEY `classification2` (`classification2`),
  KEY `classification3` (`classification3`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COMMENT = 'Vorlage';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `standingOrder`
--

CREATE TABLE `standingOrder` (
  `standingOrderID` INT(11) NOT NULL AUTO_INCREMENT,
  `template` INT(11) NOT NULL,
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `label` VARCHAR(32) DEFAULT NULL,
  `validFromType` INT(11) NOT NULL,
  `validFromValue` DATE NOT NULL,
  `periodicityType` INT(11) NOT NULL,
  `periodicityValue` INT(11) NOT NULL,
  `validToType` INT(11) NOT NULL,
  `validToValue` DATE DEFAULT NULL,
  `initialEvents` INT(11) NULL DEFAULT NULL,
  `handledEvents` INT(11) NOT NULL DEFAULT 0,
  `remainingEvents` INT(11) NULL DEFAULT NULL,
  `nextExecutionDate` DATE NULL DEFAULT NULL,
  `closed` ENUM('Y','N') NOT NULL DEFAULT 'N',
  PRIMARY KEY (`standingOrderID`),
  INDEX (`nextExecutionDate`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COMMENT = 'Dauerauftrag';

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `version`
--

CREATE TABLE `version` (
    `versionID` INT(11) NOT NULL AUTO_INCREMENT,
    `major` INT(11) NOT NULL,
    `minor` INT(11) NOT NULL,
    `patch` INT(11) NOT NULL,
    `identifier` VARCHAR(16) NULL DEFAULT NULL,
    `versionString` VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY(`versionID`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COMMENT = 'Version';

-- --------------------------------------------------------

--
-- Constraints der Tabelle `journal`
--

ALTER TABLE `journal`
  ADD CONSTRAINT `journal_ibfk_1` FOREIGN KEY (`recipient`) REFERENCES `recipient` (`recipientID`),
  ADD CONSTRAINT `journal_ibfk_2` FOREIGN KEY (`debitAccount`) REFERENCES `account` (`accountID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `journal_ibfk_3` FOREIGN KEY (`creditAccount`) REFERENCES `account` (`accountID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `journal_ibfk_4` FOREIGN KEY (`period`) REFERENCES `period` (`periodID`),
  ADD CONSTRAINT `journal_ibfk_5` FOREIGN KEY (`classification1`) REFERENCES `classification` (`classificationID`),
  ADD CONSTRAINT `journal_ibfk_6` FOREIGN KEY (`classification2`) REFERENCES `classification` (`classificationID`),
  ADD CONSTRAINT `journal_ibfk_7` FOREIGN KEY (`classification3`) REFERENCES `classification` (`classificationID`),
  ADD CONSTRAINT `journal_ibfk_8` FOREIGN KEY (`entryReference`) REFERENCES `journal` (`entryID`);

-- --------------------------------------------------------

--
-- Constraints der Tabelle `accountCategory`
--

ALTER TABLE `accountCategory`
  ADD CONSTRAINT `accountCategory_ibfk_1` FOREIGN KEY (`class`) REFERENCES `accountClass` (`classID`) ON UPDATE CASCADE;

-- --------------------------------------------------------

--
-- Constraints der Tabelle `account`
--

ALTER TABLE `account`
  ADD CONSTRAINT `account_ibfk_1` FOREIGN KEY (`category`) REFERENCES `accountCategory` (`categoryID`) ON UPDATE CASCADE;

-- --------------------------------------------------------

--
-- Constraints der Tabelle `template`
--

ALTER TABLE `template`
  ADD CONSTRAINT `template_ibfk_1` FOREIGN KEY (`recipient`) REFERENCES `recipient`(`recipientID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `template_ibfk_2` FOREIGN KEY (`debitAccount`) REFERENCES `account`(`accountID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `template_ibfk_3` FOREIGN KEY (`creditAccount`) REFERENCES `account`(`accountID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `template_ibfk_4` FOREIGN KEY (`period`) REFERENCES `period`(`periodID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `template_ibfk_5` FOREIGN KEY (`classification1`) REFERENCES `classification`(`classificationID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `template_ibfk_6` FOREIGN KEY (`classification2`) REFERENCES `classification`(`classificationID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `template_ibfk_7` FOREIGN KEY (`classification3`) REFERENCES `classification`(`classificationID`) ON UPDATE CASCADE;

-- --------------------------------------------------------

--
-- Constraints der Tabelle `standingOrder`
--

ALTER TABLE `standingOrder`
  ADD CONSTRAINT `standingOrder_ibfk_1` FOREIGN KEY (`template`) REFERENCES `template` (`templateID`) ON DELETE CASCADE ON UPDATE CASCADE;

-- --------------------------------------------------------

--
-- Trigger der Tabelle `accountClass`
--

CREATE TRIGGER `update_child_accountCategory` AFTER UPDATE
ON
  `accountClass` FOR EACH ROW
UPDATE
  accountCategory
SET
  accountCategory.categoryID = CONCAT(accountCategory.class,accountCategory.categoryNo)
WHERE
  accountCategory.class = NEW.classID;

-- --------------------------------------------------------

--
-- Trigger der Tabelle `accountCategory`
--

-- generate_categoryID_insert
CREATE TRIGGER `generate_categoryID_insert` BEFORE INSERT
ON
  `accountCategory` FOR EACH ROW
SET
  NEW.categoryID = CONCAT(NEW.class, NEW.categoryNo);

-- generate_categoryID_update
CREATE TRIGGER `generate_categoryID_update` BEFORE UPDATE
ON
  `accountCategory` FOR EACH ROW
SET
  NEW.categoryID = CONCAT(NEW.class, NEW.categoryNo);

-- update_child_account
CREATE TRIGGER `update_child_account` AFTER UPDATE
ON
  `accountCategory` FOR EACH ROW
UPDATE
  account
SET
  account.accountID = CONCAT(account.category,account.accountNo)
WHERE
  account.category = NEW.categoryID;

-- --------------------------------------------------------

--
-- Trigger der Tabelle `account`
--

-- generate_accountID_insert
CREATE TRIGGER `generate_accountID_insert` BEFORE INSERT
ON
  `account` FOR EACH ROW
SET
  NEW.accountID = CONCAT(NEW.category, NEW.accountNo);

-- generate_accountID_update
CREATE TRIGGER `generate_accountID_update` BEFORE UPDATE
ON
  `account` FOR EACH ROW
SET
  NEW.accountID = CONCAT(NEW.category, NEW.accountNo);

-- --------------------------------------------------------

--
-- Trigger der Tabelle `version`
--

-- generate_versionString_insert
CREATE TRIGGER `generate_versionString_insert` BEFORE INSERT
ON
	`version` FOR EACH ROW
SET
	NEW.versionString = CONCAT('v', NEW.major, '.', NEW.minor, '.', NEW.patch, IF(ISNULL(NEW.identifier), '', '-'), IFNULL(NEW.identifier, ''));

-- generate_versionString_update
CREATE TRIGGER `generate_versionString_update` BEFORE UPDATE
ON
	`version` FOR EACH ROW
SET
	NEW.versionString = CONCAT('v', NEW.major, '.', NEW.minor, '.', NEW.patch, IF(ISNULL(NEW.identifier), '', '-'), IFNULL(NEW.identifier, ''));

-- --------------------------------------------------------

--
-- Versionsinformationen einfügen
--

INSERT INTO `version` (`versionID`, `major`, `minor`, `patch`, `identifier`, `versionString`) VALUES (NULL, 1, 10, 0, NULL, NULL);
