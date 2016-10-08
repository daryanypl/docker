SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `recap`;
USE `recap` ;

DROP TABLE IF EXISTS `recap`.`BIBLIOGRAPHIC_T`;
-- -----------------------------------------------------
-- Table `recap`.`BIBLIOGRAPHIC_T`
CREATE TABLE IF NOT EXISTS `recap`.`BIBLIOGRAPHIC_T` (
  `BIBLIOGRAPHIC_ID`   INT         NOT NULL AUTO_INCREMENT,
  `CONTENT`            LONGBLOB    NOT NULL,
  `OWNING_INST_ID`     INT         NOT NULL,
  `CREATED_DATE`       DATETIME    NOT NULL,
  `CREATED_BY`         VARCHAR(45) NOT NULL,
  `LAST_UPDATED_DATE`  DATETIME    NOT NULL,
  `LAST_UPDATED_BY`    VARCHAR(45) NOT NULL,
  `OWNING_INST_BIB_ID` VARCHAR(45) NOT NULL,
  `IS_DELETED`         TINYINT(1)  NOT NULL DEFAULT 0,
  PRIMARY KEY (`OWNING_INST_ID`, `OWNING_INST_BIB_ID`),
  INDEX (`OWNING_INST_ID`),
  INDEX (`OWNING_INST_BIB_ID`),
  INDEX (`CREATED_DATE`),
  INDEX (`LAST_UPDATED_DATE`),
  INDEX (`IS_DELETED`),
  KEY `BIBLIOGRAPHIC_ID` (`BIBLIOGRAPHIC_ID`),
  CONSTRAINT `BIBLIOGRAPHIC_OWNING_INST_ID_FK`
  FOREIGN KEY (`OWNING_INST_ID`)
  REFERENCES `INSTITUTION_T` (`INSTITUTION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
  ENGINE = InnoDB;


DROP TABLE IF EXISTS `recap`.`HOLDINGS_T`;
-- -----------------------------------------------------
-- Table `recap`.`HOLDINGS_T`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HOLDINGS_T` (
  `HOLDINGS_ID`             INT          NOT NULL AUTO_INCREMENT,
  `CONTENT`                 LONGBLOB         NOT NULL,
  `CREATED_DATE`            DATETIME     NOT NULL,
  `CREATED_BY`              VARCHAR(45)  NOT NULL,
  `LAST_UPDATED_DATE`       DATETIME     NOT NULL,
  `LAST_UPDATED_BY`         VARCHAR(45)  NOT NULL,
  `OWNING_INST_ID`	        INT          NOT NULL,
  `OWNING_INST_HOLDINGS_ID` VARCHAR(100) NOT NULL,
  `IS_DELETED`              TINYINT(1)   NOT NULL DEFAULT 0,
  KEY `HOLDINGS_ID` (`HOLDINGS_ID`),
  PRIMARY KEY (`OWNING_INST_ID`, `OWNING_INST_HOLDINGS_ID`),
  INDEX (`OWNING_INST_HOLDINGS_ID`),
  INDEX (`OWNING_INST_ID`),
  INDEX (`IS_DELETED`),
  CONSTRAINT `HOLDINGS_OWNING_INST_ID_FK`
  FOREIGN KEY (`OWNING_INST_ID`)
  REFERENCES `INSTITUTION_T` (`INSTITUTION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
  ENGINE = InnoDB;


DROP TABLE IF EXISTS `recap`.`ITEM_T`;
-- -----------------------------------------------------
-- Table `recap`.`ITEM_T`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `recap`.`ITEM_T` (
  `ITEM_ID`                 INT           NOT NULL AUTO_INCREMENT,
  `BARCODE`                VARCHAR(45)   NOT NULL,
  `CUSTOMER_CODE`           VARCHAR(45)   NOT NULL,
  `CALL_NUMBER`             VARCHAR(2000) NULL,
  `CALL_NUMBER_TYPE`        VARCHAR(80)   NULL,
  `ITEM_AVAIL_STATUS_ID`    INT           NOT NULL,
  `COPY_NUMBER`             INT           NULL,
  `OWNING_INST_ID`          INT           NOT NULL,
  `COLLECTION_GROUP_ID`     INT           NOT NULL,
  `CREATED_DATE`            DATETIME      NOT NULL,
  `CREATED_BY`              VARCHAR(45)   NOT NULL,
  `LAST_UPDATED_DATE`       DATETIME      NOT NULL,
  `LAST_UPDATED_BY`         VARCHAR(45)   NOT NULL,
  `USE_RESTRICTIONS`        VARCHAR(2000) NULL,
  `VOLUME_PART_YEAR`        VARCHAR(2000) NULL,
  `OWNING_INST_ITEM_ID`     VARCHAR(45)   NOT NULL,
  `IS_DELETED`              TINYINT(1)    NOT NULL DEFAULT 0,
  PRIMARY KEY (`OWNING_INST_ITEM_ID`, `OWNING_INST_ID`),
  KEY `ITEM_ID` (`ITEM_ID`),
  INDEX `ITEM_AVAIL_STATUS_ID_FK_idx` (`ITEM_AVAIL_STATUS_ID` ASC),
  INDEX `COLLECTION_TYPE_FK_idx` (`COLLECTION_GROUP_ID` ASC),
  INDEX `BAR_CODE_idx` (`BARCODE` ASC),
  INDEX (`IS_DELETED`),
  CONSTRAINT `ITEM_AVAIL_STATUS_ID_FK`
  FOREIGN KEY (`ITEM_AVAIL_STATUS_ID`)
  REFERENCES `recap`.`ITEM_STATUS_T` (`ITEM_STATUS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ITEM_OWNING_INST_ID_FK`
  FOREIGN KEY (`OWNING_INST_ID`)
  REFERENCES `recap`.`INSTITUTION_T` (`INSTITUTION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ITEM_COLLECTION_GROUP_FK`
  FOREIGN KEY (`COLLECTION_GROUP_ID`)
  REFERENCES `recap`.`COLLECTION_GROUP_T` (`COLLECTION_GROUP_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
  ENGINE = InnoDB;


DROP TABLE IF EXISTS `recap`.`BIBLIOGRAPHIC_HOLDINGS_T`;
-- -----------------------------------------------------
-- Table `recap`.`BIBLIOGRAPHIC_HOLDINGS_T`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `recap`.`BIBLIOGRAPHIC_HOLDINGS_T` (
  `OWNING_INST_BIB_ID`      VARCHAR(45)  NOT NULL,
  `BIB_INST_ID`             INT          NOT NULL,
  `HOLDINGS_INST_ID`        INT          NOT NULL,
  `OWNING_INST_HOLDINGS_ID` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`OWNING_INST_BIB_ID`, `BIB_INST_ID`, `HOLDINGS_INST_ID`, `OWNING_INST_HOLDINGS_ID`),
  INDEX (`BIB_INST_ID`),
  INDEX (`OWNING_INST_BIB_ID`),
  CONSTRAINT `OWNING_INST_HOLDINGS_ID_FK`
  FOREIGN KEY (`HOLDINGS_INST_ID`, `OWNING_INST_HOLDINGS_ID`)
  REFERENCES `HOLDINGS_T` (`OWNING_INST_ID`, `OWNING_INST_HOLDINGS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `OWNING_INST_ID_OWNING_INST_BIB_ID_FK`
  FOREIGN KEY (`BIB_INST_ID`, `OWNING_INST_BIB_ID`)
  REFERENCES `BIBLIOGRAPHIC_T` (`OWNING_INST_ID`, `OWNING_INST_BIB_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
  ENGINE = InnoDB;


DROP TABLE IF EXISTS `recap`.`BIBLIOGRAPHIC_ITEM_T`;
-- -----------------------------------------------------
-- Table `recap`.`BIBLIOGRAPHIC_ITEM_T`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `recap`.`BIBLIOGRAPHIC_ITEM_T` (
  `OWNING_INST_BIB_ID` VARCHAR(45) NOT NULL ,
  `BIB_INST_ID` INT NOT NULL ,
  `ITEM_INST_ID` INT NOT NULL ,
  `OWNING_INST_ITEM_ID` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`OWNING_INST_BIB_ID`,`BIB_INST_ID`,`ITEM_INST_ID`,`OWNING_INST_ITEM_ID`),
  CONSTRAINT `BIB_INST_ID_OWNING_INST_BIB_ID_FK`
    FOREIGN KEY (`BIB_INST_ID` , `OWNING_INST_BIB_ID`)
    REFERENCES `recap`.`BIBLIOGRAPHIC_T` (`OWNING_INST_ID` , `OWNING_INST_BIB_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ITEM_INST_ID_OWNING_INST_ITEM_ID_FK`
    FOREIGN KEY (`ITEM_INST_ID` , `OWNING_INST_ITEM_ID`)
    REFERENCES `recap`.`ITEM_T` (`OWNING_INST_ID` , `OWNING_INST_ITEM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


DROP TABLE IF EXISTS `recap`.`ITEM_HOLDINGS_T`;
-- -----------------------------------------------------
-- Table `recap`.`ITEM_HOLDINGS_T`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `recap`.`ITEM_HOLDINGS_T` (
  `OWNING_INST_HOLDINGS_ID`  VARCHAR(100) NOT NULL,
  `HOLDINGS_INST_ID`         INT          NOT NULL,
  `ITEM_INST_ID`             INT          NOT NULL,
  `OWNING_INST_ITEM_ID`      VARCHAR(45)  NOT NULL,
  PRIMARY KEY (`OWNING_INST_HOLDINGS_ID`, `HOLDINGS_INST_ID`, `ITEM_INST_ID`, `OWNING_INST_ITEM_ID`),
  CONSTRAINT `HOLDINGS_INST_ID_OWNING_INST_HOLDINGS_ID_FK`
  FOREIGN KEY (`HOLDINGS_INST_ID`, `OWNING_INST_HOLDINGS_ID`)
  REFERENCES `recap`.`HOLDINGS_T` (`OWNING_INST_ID`, `OWNING_INST_HOLDINGS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `OWNING_INST_ITEM_ID_ITEM_INST_ID_FK`
  FOREIGN KEY (`ITEM_INST_ID`, `OWNING_INST_ITEM_ID`)
  REFERENCES `recap`.`ITEM_T` (`OWNING_INST_ID`, `OWNING_INST_ITEM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
