SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lab7
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lab7` ;

-- -----------------------------------------------------
-- Schema lab7
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lab7` DEFAULT CHARACTER SET utf8 ;
USE `lab7` ;

-- -----------------------------------------------------
-- Table `group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group` ;

CREATE TABLE IF NOT EXISTS `group` (
  `id_group` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_group`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `teacher`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `teacher` ;

CREATE TABLE IF NOT EXISTS `teacher` (
  `id_teacher` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_teacher`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `subject`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `subject` ;

CREATE TABLE IF NOT EXISTS `subject` (
  `id_subject` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_subject`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lesson`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lesson` ;

CREATE TABLE IF NOT EXISTS `lesson` (
  `id_lesson` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_teacher` INT UNSIGNED NOT NULL,
  `id_subject` INT UNSIGNED NOT NULL,
  `id_group` INT UNSIGNED NOT NULL,
  `date` DATE NOT NULL,
  PRIMARY KEY (`id_lesson`, `id_teacher`, `id_subject`, `id_group`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `student`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `student` ;

CREATE TABLE IF NOT EXISTS `student` (
  `id_student` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_group` INT UNSIGNED NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_student`, `id_group`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mark`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mark` ;

CREATE TABLE IF NOT EXISTS `mark` (
  `id_mark` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_lesson` INT UNSIGNED NOT NULL,
  `id_student` INT UNSIGNED NOT NULL,
  `mark` SMALLINT NOT NULL,
  PRIMARY KEY (`id_mark`, `id_lesson`, `id_student`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
