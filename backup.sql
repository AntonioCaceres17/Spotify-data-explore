-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema group20
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema group20
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `group20` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema report
-- -----------------------------------------------------
USE `group20` ;

-- -----------------------------------------------------
-- Table `group20`.`playlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`playlist` ;

CREATE TABLE IF NOT EXISTS `group20`.`playlist` (
  `pid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `collaborative` TINYINT(1) NOT NULL,
  `num_tracks` INT NOT NULL,
  `num_followers` INT NULL,
  PRIMARY KEY (`pid`),
  UNIQUE INDEX `pid_UNIQUE` (`pid` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`album`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`album` ;

CREATE TABLE IF NOT EXISTS `group20`.`album` (
  `album_name` VARCHAR(300) NOT NULL,
  `album_uri` VARCHAR(300) NOT NULL,
  `num_tracks` INT NOT NULL,
  `album_id` INT NOT NULL AUTO_INCREMENT,
  UNIQUE INDEX `album_uri_UNIQUE` (`album_uri` ASC) VISIBLE,
  PRIMARY KEY (`album_id`),
  UNIQUE INDEX `album_id_UNIQUE` (`album_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`track`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`track` ;

CREATE TABLE IF NOT EXISTS `group20`.`track` (
  `track_id` INT NOT NULL AUTO_INCREMENT,
  `track_name` VARCHAR(200) NOT NULL,
  `track_uri` VARCHAR(200) NOT NULL,
  `album_id` INT NOT NULL,
  `duration` INT NOT NULL,
  `popularity` INT NULL,
  PRIMARY KEY (`track_id`, `album_id`),
  UNIQUE INDEX `track_uri_UNIQUE` (`track_uri` ASC) VISIBLE,
  UNIQUE INDEX `track_id_UNIQUE` (`track_id` ASC) VISIBLE,
  CONSTRAINT `track_album_fk`
    FOREIGN KEY (`album_id`)
    REFERENCES `group20`.`album` (`album_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`artist` ;

CREATE TABLE IF NOT EXISTS `group20`.`artist` (
  `artist_uri` VARCHAR(300) NOT NULL,
  `artist_name` VARCHAR(100) NOT NULL,
  `artist_id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`artist_id`),
  UNIQUE INDEX `artist_uri_UNIQUE` (`artist_uri` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`track_artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`track_artist` ;

CREATE TABLE IF NOT EXISTS `group20`.`track_artist` (
  `track_id` INT NOT NULL,
  `artist_id` INT NOT NULL,
  PRIMARY KEY (`track_id`, `artist_id`),
  INDEX `track_artist_artist_fk_idx` (`artist_id` ASC) VISIBLE,
  CONSTRAINT `track_artist_track_fk`
    FOREIGN KEY (`track_id`)
    REFERENCES `group20`.`track` (`track_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `track_artist_artist_fk`
    FOREIGN KEY (`artist_id`)
    REFERENCES `group20`.`artist` (`artist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`playlist_tracks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`playlist_tracks` ;

CREATE TABLE IF NOT EXISTS `group20`.`playlist_tracks` (
  `pid` INT NOT NULL,
  `track_id` INT NOT NULL,
  PRIMARY KEY (`pid`, `track_id`),
  INDEX `playist_tracks_track_fk_idx` (`track_id` ASC) VISIBLE,
  CONSTRAINT `playist_tracks_playlist_fk`
    FOREIGN KEY (`pid`)
    REFERENCES `group20`.`playlist` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `playist_tracks_track_fk`
    FOREIGN KEY (`track_id`)
    REFERENCES `group20`.`track` (`track_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`user` ;

CREATE TABLE IF NOT EXISTS `group20`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `display_name` VARCHAR(200) NOT NULL,
  `user_uri` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_uri_UNIQUE` (`user_uri` ASC) VISIBLE,
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`user_playlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`user_playlist` ;

CREATE TABLE IF NOT EXISTS `group20`.`user_playlist` (
  `user_id` INT NOT NULL,
  `pid` INT NOT NULL,
  PRIMARY KEY (`user_id`, `pid`),
  INDEX `user_playlist_playlist_fk_idx` (`pid` ASC) VISIBLE,
  CONSTRAINT `user_playlist_user_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `group20`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_playlist_playlist_fk`
    FOREIGN KEY (`pid`)
    REFERENCES `group20`.`playlist` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`genre` ;

CREATE TABLE IF NOT EXISTS `group20`.`genre` (
  `genre_name` VARCHAR(200) NOT NULL,
  `genre_id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`genre_id`),
  UNIQUE INDEX `genre_name_UNIQUE` (`genre_name` ASC) VISIBLE,
  UNIQUE INDEX `genre_id_UNIQUE` (`genre_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`artist_genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`artist_genre` ;

CREATE TABLE IF NOT EXISTS `group20`.`artist_genre` (
  `artist_id` INT NOT NULL,
  `genre_id` INT NOT NULL,
  PRIMARY KEY (`artist_id`, `genre_id`),
  INDEX `artist_genre_genre_fk_idx` (`genre_id` ASC) VISIBLE,
  CONSTRAINT `artist_genre_artist_fk`
    FOREIGN KEY (`artist_id`)
    REFERENCES `group20`.`artist` (`artist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `artist_genre_genre_fk`
    FOREIGN KEY (`genre_id`)
    REFERENCES `group20`.`genre` (`genre_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`audio_features`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`audio_features` ;

CREATE TABLE IF NOT EXISTS `group20`.`audio_features` (
  `danceability` DECIMAL(10,3) NULL,
  `acousticness` DECIMAL(10,3) NULL,
  `energy` DECIMAL(10,3) NULL,
  `loudness` DECIMAL(10,3) NULL,
  `liveness` DECIMAL(10,3) NULL,
  `track_id` INT NOT NULL,
  PRIMARY KEY (`track_id`),
  INDEX `id_fk1_idx` (`track_id` ASC) VISIBLE,
  CONSTRAINT `id_fk1`
    FOREIGN KEY (`track_id`)
    REFERENCES `group20`.`track` (`track_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group20`.`album_artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `group20`.`album_artist` ;

CREATE TABLE IF NOT EXISTS `group20`.`album_artist` (
  `album_id` INT NOT NULL,
  `artist_id` INT NOT NULL,
  PRIMARY KEY (`album_id`, `artist_id`),
  INDEX `album_artist_artist_fk_idx` (`artist_id` ASC) VISIBLE,
  CONSTRAINT `album_artist_artist_fk`
    FOREIGN KEY (`artist_id`)
    REFERENCES `group20`.`artist` (`artist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `album_artist_album_fk`
    FOREIGN KEY (`album_id`)
    REFERENCES `group20`.`album` (`album_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
