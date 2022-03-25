SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lab4
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lab4` ;

-- -----------------------------------------------------
-- Schema lab4
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lab4` DEFAULT CHARACTER SET utf8 ;
USE `lab4` ;

-- -----------------------------------------------------
-- Table `phone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phone` ;

CREATE TABLE IF NOT EXISTS `phone` (
  `id_phone` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `phone` VARCHAR(45) NOT NULL,
  `owner_name` VARCHAR(45) NOT NULL,
  `reg_date` DATETIME NOT NULL,
  `wallet_value` INT NOT NULL,
  `talk_value` INT NOT NULL,
  `traffic_value` INT NOT NULL,
  `sms_value` INT NOT NULL,
  `last_payment` DATETIME NOT NULL,
  `active` TINYINT NOT NULL,
  PRIMARY KEY (`id_phone`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tariff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tariff` ;

CREATE TABLE IF NOT EXISTS `tariff` (
  `id_tariff` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `talk_value` INT NOT NULL,
  `traffic_value` INT NOT NULL,
  `sms_value` INT NOT NULL,
  `cost` INT NOT NULL,
  `tariff_period` TIME NOT NULL,
  PRIMARY KEY (`id_tariff`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `service` ;

CREATE TABLE IF NOT EXISTS `service` (
  `id_service` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `service_period` TIME NOT NULL,
  `cost` INT NOT NULL,
  PRIMARY KEY (`id_service`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phone_has_service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phone_has_service` ;

CREATE TABLE IF NOT EXISTS `phone_has_service` (
  `id_service` INT UNSIGNED NOT NULL,
  `id_phone` INT UNSIGNED NOT NULL,
  `reg_date` DATETIME NOT NULL,
  PRIMARY KEY (`id_service`, `id_phone`),
  INDEX `fk_phone_has_service_phone1_idx` (`id_phone` ASC) VISIBLE,
  CONSTRAINT `fk_phone_has_service_service1`
    FOREIGN KEY (`id_service`)
    REFERENCES `service` (`id_service`),
  CONSTRAINT `fk_phone_has_service_phone1`
    FOREIGN KEY (`id_phone`)
    REFERENCES `phone` (`id_phone`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payment` ;

CREATE TABLE IF NOT EXISTS `payment` (
  `id_payment` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_phone` INT UNSIGNED NOT NULL,
  `reg_date` DATETIME NOT NULL,
  `cost` INT UNSIGNED NOT NULL,
  `payment_status` TINYINT NOT NULL,
  `payment_date` DATETIME NOT NULL,
  PRIMARY KEY (`id_payment`),
  INDEX `fk_payment_phone1_idx` (`id_phone` ASC) VISIBLE,
  CONSTRAINT `fk_payment_phone1`
    FOREIGN KEY (`id_phone`)
    REFERENCES `phone` (`id_phone`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `phone_has_tariff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phone_has_tariff` ;

CREATE TABLE IF NOT EXISTS `phone_has_tariff` (
  `id_phone` INT UNSIGNED NOT NULL,
  `id_tariff` INT UNSIGNED NOT NULL,
  `reg_date` DATETIME NOT NULL,
  PRIMARY KEY (`id_phone`, `id_tariff`),
  INDEX `fk_phone_has_tariff_tariff1_idx` (`id_tariff` ASC) VISIBLE,
  CONSTRAINT `fk_phone_has_tariff_phone1`
    FOREIGN KEY (`id_phone`)
    REFERENCES `phone` (`id_phone`),
  CONSTRAINT `fk_phone_has_tariff_tariff1`
    FOREIGN KEY (`id_tariff`)
    REFERENCES `tariff` (`id_tariff`))
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
