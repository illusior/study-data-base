SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS `lab4_task1`;

CREATE SCHEMA IF NOT EXISTS `lab4_task1` DEFAULT CHARACTER SET utf8;
USE `lab4_task1`;

DROP TABLE IF EXISTS `lab4_task1`.`dish`;

CREATE TABLE IF NOT EXISTS `lab4_task1`.`dish` (
  `id_dish` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `cost` FLOAT NOT NULL,
  `weight` FLOAT NOT NULL,
  `rating` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_dish`))
ENGINE = InnoDB;
                                                             
DROP TABLE IF EXISTS `lab4_task1`.`dish_has_dishware`;

CREATE TABLE IF NOT EXISTS `lab4_task1`.`dish_has_dishware` (
  `id_dish` INT UNSIGNED NOT NULL,
  `id_dishware` INT UNSIGNED NOT NULL,
  `amount` INT NOT NULL,
  PRIMARY KEY (`id_dish`, `id_dishware`),
  INDEX `fk_dish_has_dishware_dishware1_idx` (`id_dishware` ASC) VISIBLE,
  CONSTRAINT `fk_dish_has_dishware_dish1`
    FOREIGN KEY (`id_dish`)
    REFERENCES `lab4_task1`.`dish` (`id_dish`),
  CONSTRAINT `fk_dish_has_dishware_dishware1`
    FOREIGN KEY (`id_dishware`)
    REFERENCES `lab4_task1`.`dishware` (`id_dishware`))
ENGINE = InnoDB;                

DROP TABLE IF EXISTS `lab4_task1`.`dish_has_recipe`;

CREATE TABLE IF NOT EXISTS `lab4_task1`.`dish_has_recipe` (
  `id_recipe` INT UNSIGNED NOT NULL,
  `id_dish` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_recipe`, `id_dish`),
  INDEX `fk_dish_has_recipe_dish1_idx` (`id_dish` ASC) VISIBLE,
  CONSTRAINT `fk_dish_has_recipe_recipe`
    FOREIGN KEY (`id_recipe`)
    REFERENCES `lab4_task1`.`recipe` (`id_recipe`),
  CONSTRAINT `fk_dish_has_recipe_dish1`
    FOREIGN KEY (`id_dish`)
    REFERENCES `lab4_task1`.`dish` (`id_dish`))
ENGINE = InnoDB;          

DROP TABLE IF EXISTS `lab4_task1`.`dishware`;

CREATE TABLE IF NOT EXISTS `lab4_task1`.`dishware` (
  `id_dishware` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_dishware_type` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_dishware`, `id_dishware_type`),
  INDEX `fk_dishware_dishware_type1_idx` (`id_dishware_type` ASC) VISIBLE,
  CONSTRAINT `fk_dishware_dishware_type1`
    FOREIGN KEY (`id_dishware_type`)
    REFERENCES `lab4_task1`.`dishware_type` (`id_dishware_type`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `lab4_task1`.`dishware_type`;

CREATE TABLE IF NOT EXISTS `lab4_task1`.`dishware_type` (
  `id_dishware_type` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_dishware_type`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `lab4_task1`.`ingredient`;

CREATE TABLE IF NOT EXISTS `lab4_task1`.`ingredient` (
  `id_ingredient` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `amount` FLOAT NOT NULL,
  `is_vegan` TINYINT NOT NULL,
  `gluten_free` TINYINT NOT NULL,
  PRIMARY KEY (`id_ingredient`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `lab4_task1`.`recipe`;

CREATE TABLE IF NOT EXISTS `lab4_task1`.`recipe` (
  `id_recipe` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `cooking_time` TIME NOT NULL,
  PRIMARY KEY (`id_recipe`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `lab4_task1`.`recipe_has_ingredient`;

CREATE TABLE IF NOT EXISTS `lab4_task1`.`recipe_has_ingredient` (
  `id_ingredient` INT UNSIGNED NOT NULL,
  `id_recipe` INT UNSIGNED NOT NULL,
  `id_scale_type` INT UNSIGNED NOT NULL,
  `scale` FLOAT NOT NULL,
  PRIMARY KEY (`id_ingredient`, `id_recipe`),
  INDEX `fk_recipe_has_ingredient_recipe1_idx` (`id_recipe` ASC) VISIBLE,
  INDEX `fk_recipe_has_ingredient_scale_type1_idx` (`id_scale_type` ASC) VISIBLE,
  CONSTRAINT `fk_recipe_has_ingredient_ingredient1`
    FOREIGN KEY (`id_ingredient`)
    REFERENCES `lab4_task1`.`ingredient` (`id_ingredient`),
  CONSTRAINT `fk_recipe_has_ingredient_recipe1`
    FOREIGN KEY (`id_recipe`)
    REFERENCES `lab4_task1`.`recipe` (`id_recipe`),
  CONSTRAINT `fk_recipe_has_ingredient_scale_type1`
    FOREIGN KEY (`id_scale_type`)
    REFERENCES `lab4_task1`.`scale_type` (`id_scale_type`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `lab4_task1`.`scale_type`;

CREATE TABLE IF NOT EXISTS `lab4_task1`.`scale_type` (
  `id_scale_type` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_scale_type`))
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
