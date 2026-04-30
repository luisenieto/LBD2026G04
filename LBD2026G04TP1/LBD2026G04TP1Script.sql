-- MySQL Workbench Forward Engineering
-- Año: 2026
-- Grupo: 04
-- Integrantes: Francisco Mariano Bobba, Matías Eduardo Nieva
-- Tema: Taller biomédico
-- Nombre del Esquema: LBD2026G04TallerBio
-- Plataforma (SO + Versión): Windows 11 Home Single Language 25H2
-- Motor y Versión: MySQL Server 8.0.46
-- Versión corregida: se cambió el nombre de la Base de Datos de "mydb" a "LBD2026G04TallerBio" y se poblaron correctamente con 20 filas cada tabla

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LBD2026G04TallerBio
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `LBD2026G04TallerBio` ;

-- -----------------------------------------------------
-- Schema LBD2026G04TallerBio
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LBD2026G04TallerBio` DEFAULT CHARACTER SET utf8 ;
USE `LBD2026G04TallerBio` ;

-- -----------------------------------------------------
-- Table `Roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Roles` ;

CREATE TABLE IF NOT EXISTS `Roles` (
  `idRoles` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idRoles`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nombre_UNIQUE` ON `Roles` (`nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Usuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Usuarios` ;

CREATE TABLE IF NOT EXISTS `Usuarios` (
  `idUsuarios` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `contraseña` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NULL,
  `rolId` INT NOT NULL,
  PRIMARY KEY (`idUsuarios`),
  CONSTRAINT `fkRolesUsuarios`
    FOREIGN KEY (`rolId`)
    REFERENCES `Roles` (`idRoles`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
	CONSTRAINT chk_password_length
    CHECK (CHAR_LENGTH(`contraseña`) >= 8),
    CONSTRAINT chk_email_formato
	CHECK (email LIKE '%@%.%'))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_UNIQUE` ON `Usuarios` (`email` ASC) VISIBLE;

CREATE UNIQUE INDEX `username_UNIQUE` ON `Usuarios` (`username` ASC) VISIBLE;

CREATE INDEX `rolId_idx` ON `Usuarios` (`rolId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Clientes` ;

CREATE TABLE IF NOT EXISTS `Clientes` (
  `idClientes` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NULL,
  `telefono` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `observaciones` VARCHAR(1000) NULL,
  `cuil` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idClientes`),
  CONSTRAINT chck_email_formato
	CHECK (email LIKE '%@%.%'))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `cuil_UNIQUE` ON `Clientes` (`cuil` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `TiposDeEquipos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TiposDeEquipos` ;

CREATE TABLE IF NOT EXISTS `TiposDeEquipos` (
  `idTiposDeEquipos` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idTiposDeEquipos`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nombre_UNIQUE` ON `TiposDeEquipos` (`nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Marcas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Marcas` ;

CREATE TABLE IF NOT EXISTS `Marcas` (
  `idMarcas` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idMarcas`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nombre_UNIQUE` ON `Marcas` (`nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Modelos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Modelos` ;

CREATE TABLE IF NOT EXISTS `Modelos` (
  `idModelos` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(1000) NULL,
  `tiposId` INT NOT NULL,
  `marcasId` INT NOT NULL,
  PRIMARY KEY (`idModelos`),
  CONSTRAINT `fkTiposModelos`
    FOREIGN KEY (`tiposId`)
    REFERENCES `TiposDeEquipos` (`idTiposDeEquipos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkMarcasModelos`
    FOREIGN KEY (`marcasId`)
    REFERENCES `Marcas` (`idMarcas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT unique_modelo_marca
    UNIQUE (`nombre`, `marcasId`))
ENGINE = InnoDB;

CREATE INDEX `tipoId_idx` ON `Modelos` (`tiposId` ASC) VISIBLE;

CREATE INDEX `marcasId_idx` ON `Modelos` (`marcasId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Equipos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Equipos` ;

CREATE TABLE IF NOT EXISTS `Equipos` (
  `idEquipos` INT NOT NULL AUTO_INCREMENT,
  `numeroSerie` VARCHAR(45) NULL,
  `fechaFinGarantia` DATE NULL,
  `modelosId` INT NOT NULL,
  `clientesId` INT NOT NULL,
  PRIMARY KEY (`idEquipos`),
  CONSTRAINT `fkModelosEquipos`
    FOREIGN KEY (`modelosId`)
    REFERENCES `Modelos` (`idModelos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkClientesEquipos`
    FOREIGN KEY (`clientesId`)
    REFERENCES `Clientes` (`idClientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `numeroSerie_UNIQUE` ON `Equipos` (`numeroSerie` ASC) VISIBLE;

CREATE INDEX `modelosId_idx` ON `Equipos` (`modelosId` ASC) VISIBLE;

CREATE INDEX `clientesId_idx` ON `Equipos` (`clientesId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `EstadosOT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EstadosOT` ;

CREATE TABLE IF NOT EXISTS `EstadosOT` (
  `idEstadosOT` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEstadosOT`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nombre_UNIQUE` ON `EstadosOT` (`nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `OrdenesDeTrabajo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OrdenesDeTrabajo` ;

CREATE TABLE IF NOT EXISTS `OrdenesDeTrabajo` (
  `idOrdenesDeTrabajo` INT NOT NULL AUTO_INCREMENT,
  `fechaIngreso` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `fechaSalida` DATE NULL,
  `falla` VARCHAR(1000) NULL,
  `diagnostico` VARCHAR(1000) NULL,
  `numeroOT` VARCHAR(45) NOT NULL,
  `estadosId` INT NOT NULL,
  `equiposId` INT NOT NULL,
  `clientesId` INT NOT NULL,
  `tecnicoId` INT NOT NULL,
  PRIMARY KEY (`idOrdenesDeTrabajo`),
  CONSTRAINT `fkEquiposOt`
    FOREIGN KEY (`equiposId`)
    REFERENCES `Equipos` (`idEquipos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkClientesOt`
    FOREIGN KEY (`clientesId`)
    REFERENCES `Clientes` (`idClientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkTecnicoOt`
    FOREIGN KEY (`tecnicoId`)
    REFERENCES `Usuarios` (`idUsuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkEstadosOt`
    FOREIGN KEY (`estadosId`)
    REFERENCES `EstadosOT` (`idEstadosOT`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `chk_fechas_ot`
    CHECK (fechaSalida IS NULL OR fechaSalida >= fechaIngreso),
    CONSTRAINT chk_ot_diagnostico
  CHECK (
	fechaSalida IS NULL 
	OR diagnostico IS NOT NULL))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `numeroOT_UNIQUE` ON `OrdenesDeTrabajo` (`numeroOT` ASC) VISIBLE;

CREATE INDEX `equiposId_idx` ON `OrdenesDeTrabajo` (`equiposId` ASC) VISIBLE;

CREATE INDEX `clientesId_idx` ON `OrdenesDeTrabajo` (`clientesId` ASC) VISIBLE;

CREATE INDEX `tecnicoId_idx` ON `OrdenesDeTrabajo` (`tecnicoId` ASC) VISIBLE;

CREATE INDEX `estadosId_idx` ON `OrdenesDeTrabajo` (`estadosId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Repuestos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Repuestos` ;

CREATE TABLE IF NOT EXISTS `Repuestos` (
  `idRepuestos` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `numeroSerie` VARCHAR(45) NULL,
  `descripcion` VARCHAR(1000) NULL,
  `existencias` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idRepuestos`),
  CONSTRAINT chk_existencias_no_negativo
  CHECK (existencias >= 0))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `numeroSerie_UNIQUE` ON `Repuestos` (`numeroSerie` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `AccionesTecnicas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AccionesTecnicas` ;

CREATE TABLE IF NOT EXISTS `AccionesTecnicas` (
  `idAccionesTecnicas` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `descripcion` VARCHAR(1000) NOT NULL,
  `tecnicoId` INT NOT NULL,
  `ordenesDeTrabajoId` INT NOT NULL,
  PRIMARY KEY (`idAccionesTecnicas`),
  CONSTRAINT `fkTecnicoAcciones`
    FOREIGN KEY (`tecnicoId`)
    REFERENCES `Usuarios` (`idUsuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkOtAcciones`
    FOREIGN KEY (`ordenesDeTrabajoId`)
    REFERENCES `OrdenesDeTrabajo` (`idOrdenesDeTrabajo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `tecnicoId_idx` ON `AccionesTecnicas` (`tecnicoId` ASC) VISIBLE;

CREATE INDEX `ordenesDeTrabajoId_idx` ON `AccionesTecnicas` (`ordenesDeTrabajoId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `ConsumoDeRepuestos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ConsumoDeRepuestos` ;

CREATE TABLE IF NOT EXISTS `ConsumoDeRepuestos` (
  `idAccionesTecnicas` INT NOT NULL,
  `idRepuestos` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`idAccionesTecnicas`, `idRepuestos`),
  CONSTRAINT `fkAccionesConsumo`
    FOREIGN KEY (`idAccionesTecnicas`)
    REFERENCES `AccionesTecnicas` (`idAccionesTecnicas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkRepuestosConsumo`
    FOREIGN KEY (`idRepuestos`)
    REFERENCES `Repuestos` (`idRepuestos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `chk_cantidad_positiva`
    CHECK (cantidad > 0))
ENGINE = InnoDB;

CREATE INDEX `fk_Consumo de Repuestos_Repuestos1_idx` ON `ConsumoDeRepuestos` (`idRepuestos` ASC) INVISIBLE;


-- -----------------------------------------------------
-- Table `Observaciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Observaciones` ;

CREATE TABLE IF NOT EXISTS `Observaciones` (
  `idObservaciones` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(1000) NOT NULL,
  `fecha` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `usuariosId` INT NOT NULL,
  `equiposId` INT NULL,
  `modelosId` INT NULL,
  `ordenesDeTrabajoId` INT NULL,
  PRIMARY KEY (`idObservaciones`),
  CONSTRAINT `fkUsuariosObservaciones`
    FOREIGN KEY (`usuariosId`)
    REFERENCES `Usuarios` (`idUsuarios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkEquiposObservaciones`
    FOREIGN KEY (`equiposId`)
    REFERENCES `Equipos` (`idEquipos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkModelosObservaciones`
    FOREIGN KEY (`modelosId`)
    REFERENCES `Modelos` (`idModelos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkOtObservaciones`
    FOREIGN KEY (`ordenesDeTrabajoId`)
    REFERENCES `OrdenesDeTrabajo` (`idOrdenesDeTrabajo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT chk_observaciones_referencia
  CHECK (
	equiposId IS NOT NULL 
	OR modelosId IS NOT NULL 
	OR ordenesDeTrabajoId IS NOT NULL))
ENGINE = InnoDB;

CREATE INDEX `usuariosId_idx` ON `Observaciones` (`usuariosId` ASC) VISIBLE;

CREATE INDEX `equiposId_idx` ON `Observaciones` (`equiposId` ASC) VISIBLE;

CREATE INDEX `modelosId_idx` ON `Observaciones` (`modelosId` ASC) VISIBLE;

CREATE INDEX `ordenesDeTrabajoId_idx` ON `Observaciones` (`ordenesDeTrabajoId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `EstadosAlarmas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EstadosAlarmas` ;

CREATE TABLE IF NOT EXISTS `EstadosAlarmas` (
  `idEstadosAlarmas` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEstadosAlarmas`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nombre_UNIQUE` ON `EstadosAlarmas` (`nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Alarmas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Alarmas` ;

CREATE TABLE IF NOT EXISTS `Alarmas` (
  `idAlarmas` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(1000) NOT NULL,
  `fechaProgramada` DATE NOT NULL,
  `fechaRealizada` DATE NULL,
  `equiposId` INT NOT NULL,
  `estadosId` INT NOT NULL,
  PRIMARY KEY (`idAlarmas`),
  CONSTRAINT `fkEquiposAlarmas`
    FOREIGN KEY (`equiposId`)
    REFERENCES `Equipos` (`idEquipos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkEstadosAlarmas`
    FOREIGN KEY (`estadosId`)
    REFERENCES `EstadosAlarmas` (`idEstadosAlarmas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT chk_fechas_alarmas
  CHECK (
	fechaRealizada IS NULL 
	OR fechaRealizada >= fechaProgramada))
ENGINE = InnoDB;

CREATE INDEX `equiposId_idx` ON `Alarmas` (`equiposId` ASC) VISIBLE;

CREATE INDEX `estadosId_idx` ON `Alarmas` (`estadosId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `TiposDeManuales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TiposDeManuales` ;

CREATE TABLE IF NOT EXISTS `TiposDeManuales` (
  `idTiposDeManuales` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idTiposDeManuales`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nombre_UNIQUE` ON `TiposDeManuales` (`nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Manuales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Manuales` ;

CREATE TABLE IF NOT EXISTS `Manuales` (
  `idManuales` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `url` VARCHAR(45) NOT NULL,
  `modelosId` INT NOT NULL,
  `tiposId` INT NOT NULL,
  PRIMARY KEY (`idManuales`),
  CONSTRAINT `fkModelosManuales`
    FOREIGN KEY (`modelosId`)
    REFERENCES `Modelos` (`idModelos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkTiposManuales`
    FOREIGN KEY (`tiposId`)
    REFERENCES `TiposDeManuales` (`idTiposDeManuales`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `modelosId_idx` ON `Manuales` (`modelosId` ASC) VISIBLE;

CREATE INDEX `tiposId_idx` ON `Manuales` (`tiposId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Adjuntos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Adjuntos` ;

CREATE TABLE IF NOT EXISTS `Adjuntos` (
  `idAdjuntos` INT NOT NULL AUTO_INCREMENT,
  `url` VARCHAR(45) NOT NULL,
  `tipo` VARCHAR(45) NULL,
  `ordenesDeTrabajoId` INT NOT NULL,
  PRIMARY KEY (`idAdjuntos`),
  CONSTRAINT `fkOtAdjuntos`
    FOREIGN KEY (`ordenesDeTrabajoId`)
    REFERENCES `OrdenesDeTrabajo` (`idOrdenesDeTrabajo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `ordenesDeTrabajoId_idx` ON `Adjuntos` (`ordenesDeTrabajoId` ASC) VISIBLE;

INSERT INTO Roles (nombre) VALUES
('Admin'),('Tecnico'),('Supervisor'),('Recepcion'),('Gerente'),
('Soporte'),('Ventas'),('Calidad'),('Logistica'),('Auditor'),
('Operador1'),('Operador2'),('Operador3'),('Operador4'),('Operador5'),
('Operador6'),('Operador7'),('Operador8'),('Operador9'),('Operador10');

INSERT INTO TiposDeEquipos (nombre) VALUES
('Laser'),('Ultrasonido'),('Radiofrecuencia'),('Criolipolisis'),('IPL'),
('Dermapen'),('Electroestimulador'),('Presoterapia'),('Cavitacion'),('Magnetoterapia'),
('Equipo11'),('Equipo12'),('Equipo13'),('Equipo14'),('Equipo15'),
('Equipo16'),('Equipo17'),('Equipo18'),('Equipo19'),('Equipo20');

INSERT INTO Marcas (nombre) VALUES
('Philips'),('Siemens'),('GE'),('Samsung'),('Meditech'),
('Brand6'),('Brand7'),('Brand8'),('Brand9'),('Brand10'),
('Brand11'),('Brand12'),('Brand13'),('Brand14'),('Brand15'),
('Brand16'),('Brand17'),('Brand18'),('Brand19'),('Brand20');

INSERT INTO EstadosOT (nombre) VALUES
('Ingresada'),('Diagnostico'),('Reparacion'),('Espera'),('Finalizada'),
('Cancelada'),('Pendiente'),('Rechazada'),('Garantia'),('Revision'),
('Estado11'),('Estado12'),('Estado13'),('Estado14'),('Estado15'),
('Estado16'),('Estado17'),('Estado18'),('Estado19'),('Estado20');

INSERT INTO EstadosAlarmas (nombre) VALUES
('Pendiente'),('Realizada'),('Cancelada'),('Vencida'),('Reprogramada'),
('Estado6'),('Estado7'),('Estado8'),('Estado9'),('Estado10'),
('Estado11'),('Estado12'),('Estado13'),('Estado14'),('Estado15'),
('Estado16'),('Estado17'),('Estado18'),('Estado19'),('Estado20');

INSERT INTO TiposDeManuales (nombre) VALUES
('Usuario'),('Tecnico'),('Instalacion'),('Servicio'),('Rapido'),
('Tipo6'),('Tipo7'),('Tipo8'),('Tipo9'),('Tipo10'),
('Tipo11'),('Tipo12'),('Tipo13'),('Tipo14'),('Tipo15'),
('Tipo16'),('Tipo17'),('Tipo18'),('Tipo19'),('Tipo20');

INSERT INTO Clientes (nombre, cuil) VALUES
('Cliente1','20000000001'),('Cliente2','20000000002'),('Cliente3','20000000003'),
('Cliente4','20000000004'),('Cliente5','20000000005'),
('Cliente6','20000000006'),('Cliente7','20000000007'),('Cliente8','20000000008'),
('Cliente9','20000000009'),('Cliente10','20000000010'),
('Cliente11','20000000011'),('Cliente12','20000000012'),
('Cliente13','20000000013'),('Cliente14','20000000014'),
('Cliente15','20000000015'),('Cliente16','20000000016'),
('Cliente17','20000000017'),('Cliente18','20000000018'),
('Cliente19','20000000019'),('Cliente20','20000000020');

INSERT INTO Usuarios (nombre, apellido, email, username, contraseña, rolId) VALUES
('User1','Test','u1@mail.com','u1','12345678',1),
('User2','Test','u2@mail.com','u2','12345678',2),
('User3','Test','u3@mail.com','u3','12345678',2),
('User4','Test','u4@mail.com','u4','12345678',3),
('User5','Test','u5@mail.com','u5','12345678',2),
('User6','Test','u6@mail.com','u6','12345678',2),
('User7','Test','u7@mail.com','u7','12345678',2),
('User8','Test','u8@mail.com','u8','12345678',2),
('User9','Test','u9@mail.com','u9','12345678',2),
('User10','Test','u10@mail.com','u10','12345678',2),
('User11','Test','u11@mail.com','u11','12345678',2),
('User12','Test','u12@mail.com','u12','12345678',2),
('User13','Test','u13@mail.com','u13','12345678',2),
('User14','Test','u14@mail.com','u14','12345678',2),
('User15','Test','u15@mail.com','u15','12345678',2),
('User16','Test','u16@mail.com','u16','12345678',2),
('User17','Test','u17@mail.com','u17','12345678',2),
('User18','Test','u18@mail.com','u18','12345678',2),
('User19','Test','u19@mail.com','u19','12345678',2),
('User20','Test','u20@mail.com','u20','12345678',2);

INSERT INTO Modelos (nombre, tiposId, marcasId) VALUES
('Modelo1',1,1),('Modelo2',2,2),('Modelo3',3,3),('Modelo4',4,4),('Modelo5',5,5),
('Modelo6',6,6),('Modelo7',7,7),('Modelo8',8,8),('Modelo9',9,9),('Modelo10',10,10),
('Modelo11',11,11),('Modelo12',12,12),('Modelo13',13,13),('Modelo14',14,14),('Modelo15',15,15),
('Modelo16',16,16),('Modelo17',17,17),('Modelo18',18,18),('Modelo19',19,19),('Modelo20',20,20);

INSERT INTO Equipos (numeroSerie, modelosId, clientesId) VALUES
('SN1',1,1),('SN2',2,2),('SN3',3,3),('SN4',4,4),('SN5',5,5),
('SN6',6,6),('SN7',7,7),('SN8',8,8),('SN9',9,9),('SN10',10,10),
('SN11',11,11),('SN12',12,12),('SN13',13,13),('SN14',14,14),('SN15',15,15),
('SN16',16,16),('SN17',17,17),('SN18',18,18),('SN19',19,19),('SN20',20,20);

INSERT INTO Repuestos (nombre, existencias) VALUES
('Rep1',10),('Rep2',10),('Rep3',10),('Rep4',10),('Rep5',10),
('Rep6',10),('Rep7',10),('Rep8',10),('Rep9',10),('Rep10',10),
('Rep11',10),('Rep12',10),('Rep13',10),('Rep14',10),('Rep15',10),
('Rep16',10),('Rep17',10),('Rep18',10),('Rep19',10),('Rep20',10);

INSERT INTO OrdenesDeTrabajo (fechaIngreso, numeroOT, estadosId, equiposId, clientesId, tecnicoId)
VALUES
(CURDATE(),'OT1',1,1,1,1),
(CURDATE(),'OT2',1,2,2,2),
(CURDATE(),'OT3',1,3,3,3),
(CURDATE(),'OT4',1,4,4,4),
(CURDATE(),'OT5',1,5,5,5),
(CURDATE(),'OT6',1,6,6,6),
(CURDATE(),'OT7',1,7,7,7),
(CURDATE(),'OT8',1,8,8,8),
(CURDATE(),'OT9',1,9,9,9),
(CURDATE(),'OT10',1,10,10,10),
(CURDATE(),'OT11',1,11,11,11),
(CURDATE(),'OT12',1,12,12,12),
(CURDATE(),'OT13',1,13,13,13),
(CURDATE(),'OT14',1,14,14,14),
(CURDATE(),'OT15',1,15,15,15),
(CURDATE(),'OT16',1,16,16,16),
(CURDATE(),'OT17',1,17,17,17),
(CURDATE(),'OT18',1,18,18,18),
(CURDATE(),'OT19',1,19,19,19),
(CURDATE(),'OT20',1,20,20,20);

INSERT INTO AccionesTecnicas (fecha, descripcion, tecnicoId, ordenesDeTrabajoId)
VALUES
(CURDATE(),'Accion1',1,1),(CURDATE(),'Accion2',2,2),(CURDATE(),'Accion3',3,3),
(CURDATE(),'Accion4',4,4),(CURDATE(),'Accion5',5,5),
(CURDATE(),'Accion6',6,6),(CURDATE(),'Accion7',7,7),(CURDATE(),'Accion8',8,8),
(CURDATE(),'Accion9',9,9),(CURDATE(),'Accion10',10,10),
(CURDATE(),'Accion11',11,11),(CURDATE(),'Accion12',12,12),
(CURDATE(),'Accion13',13,13),(CURDATE(),'Accion14',14,14),
(CURDATE(),'Accion15',15,15),(CURDATE(),'Accion16',16,16),
(CURDATE(),'Accion17',17,17),(CURDATE(),'Accion18',18,18),
(CURDATE(),'Accion19',19,19),(CURDATE(),'Accion20',20,20);

INSERT INTO ConsumoDeRepuestos (idAccionesTecnicas, idRepuestos, cantidad)
VALUES
(1,1,1),(2,2,1),(3,3,1),(4,4,1),(5,5,1),
(6,6,1),(7,7,1),(8,8,1),(9,9,1),(10,10,1),
(11,11,1),(12,12,1),(13,13,1),(14,14,1),(15,15,1),
(16,16,1),(17,17,1),(18,18,1),(19,19,1),(20,20,1);

INSERT INTO Alarmas (descripcion, fechaProgramada, equiposId, estadosId)
VALUES
('Alarma1',CURDATE(),1,1),('Alarma2',CURDATE(),2,1),
('Alarma3',CURDATE(),3,1),('Alarma4',CURDATE(),4,1),
('Alarma5',CURDATE(),5,1),('Alarma6',CURDATE(),6,1),
('Alarma7',CURDATE(),7,1),('Alarma8',CURDATE(),8,1),
('Alarma9',CURDATE(),9,1),('Alarma10',CURDATE(),10,1),
('Alarma11',CURDATE(),11,1),('Alarma12',CURDATE(),12,1),
('Alarma13',CURDATE(),13,1),('Alarma14',CURDATE(),14,1),
('Alarma15',CURDATE(),15,1),('Alarma16',CURDATE(),16,1),
('Alarma17',CURDATE(),17,1),('Alarma18',CURDATE(),18,1),
('Alarma19',CURDATE(),19,1),('Alarma20',CURDATE(),20,1);

INSERT INTO Adjuntos (url, tipo, ordenesDeTrabajoId) VALUES
('url1.pdf','pdf',1),
('url2.jpg','imagen',2),
('url3.pdf','pdf',3),
('url4.png','imagen',4),
('url5.doc','doc',5),
('url6.pdf','pdf',6),
('url7.jpg','imagen',7),
('url8.pdf','pdf',8),
('url9.png','imagen',9),
('url10.doc','doc',10),
('url11.pdf','pdf',11),
('url12.jpg','imagen',12),
('url13.pdf','pdf',13),
('url14.png','imagen',14),
('url15.doc','doc',15),
('url16.pdf','pdf',16),
('url17.jpg','imagen',17),
('url18.pdf','pdf',18),
('url19.png','imagen',19),
('url20.doc','doc',20);

INSERT INTO Manuales (nombre, url, modelosId, tiposId) VALUES
('Manual1','url1',1,1),
('Manual2','url2',2,2),
('Manual3','url3',3,3),
('Manual4','url4',4,4),
('Manual5','url5',5,5),
('Manual6','url6',6,6),
('Manual7','url7',7,7),
('Manual8','url8',8,8),
('Manual9','url9',9,9),
('Manual10','url10',10,10),
('Manual11','url11',11,11),
('Manual12','url12',12,12),
('Manual13','url13',13,13),
('Manual14','url14',14,14),
('Manual15','url15',15,15),
('Manual16','url16',16,16),
('Manual17','url17',17,17),
('Manual18','url18',18,18),
('Manual19','url19',19,19),
('Manual20','url20',20,20);

INSERT INTO Observaciones (descripcion, fecha, usuariosId, equiposId, modelosId, ordenesDeTrabajoId) VALUES
('Obs1',CURDATE(),1,1,NULL,NULL),
('Obs2',CURDATE(),2,NULL,2,NULL),
('Obs3',CURDATE(),3,NULL,NULL,3),
('Obs4',CURDATE(),4,4,NULL,NULL),
('Obs5',CURDATE(),5,NULL,5,NULL),
('Obs6',CURDATE(),6,NULL,NULL,6),
('Obs7',CURDATE(),7,7,NULL,NULL),
('Obs8',CURDATE(),8,NULL,8,NULL),
('Obs9',CURDATE(),9,NULL,NULL,9),
('Obs10',CURDATE(),10,10,NULL,NULL),
('Obs11',CURDATE(),11,NULL,11,NULL),
('Obs12',CURDATE(),12,NULL,NULL,12),
('Obs13',CURDATE(),13,13,NULL,NULL),
('Obs14',CURDATE(),14,NULL,14,NULL),
('Obs15',CURDATE(),15,NULL,NULL,15),
('Obs16',CURDATE(),16,16,NULL,NULL),
('Obs17',CURDATE(),17,NULL,17,NULL),
('Obs18',CURDATE(),18,NULL,NULL,18),
('Obs19',CURDATE(),19,19,NULL,NULL),
('Obs20',CURDATE(),20,NULL,20,NULL);

-- Consultas de prueba para visualizar contenido de las tablas

SELECT 
    ot.numeroOT,
    ot.fechaIngreso,
    ot.fechaSalida,
    c.nombre AS cliente,
    e.numeroSerie,
    m.nombre AS modelo,
    ma.nombre AS marca,
    u.nombre AS tecnico,
    u.apellido,
    est.nombre AS estado
FROM OrdenesDeTrabajo ot
JOIN Clientes c ON ot.clientesId = c.idClientes
JOIN Equipos e ON ot.equiposId = e.idEquipos
JOIN Modelos m ON e.modelosId = m.idModelos
JOIN Marcas ma ON m.marcasId = ma.idMarcas
JOIN Usuarios u ON ot.tecnicoId = u.idUsuarios
JOIN EstadosOT est ON ot.estadosId = est.idEstadosOT;

SELECT 
    ot.numeroOT,
    at.fecha,
    at.descripcion,
    u.nombre AS tecnico
FROM AccionesTecnicas at
JOIN OrdenesDeTrabajo ot ON at.ordenesDeTrabajoId = ot.idOrdenesDeTrabajo
JOIN Usuarios u ON at.tecnicoId = u.idUsuarios;

SELECT 
    at.idAccionesTecnicas,
    r.nombre AS repuesto,
    cr.cantidad
FROM ConsumoDeRepuestos cr
JOIN AccionesTecnicas at ON cr.idAccionesTecnicas = at.idAccionesTecnicas
JOIN Repuestos r ON cr.idRepuestos = r.idRepuestos;

SELECT 
    e.idEquipos,
    ot.numeroOT,
    ot.fechaIngreso,
    at.descripcion
FROM Equipos e
JOIN OrdenesDeTrabajo ot ON e.idEquipos = ot.equiposId
LEFT JOIN AccionesTecnicas at ON ot.idOrdenesDeTrabajo = at.ordenesDeTrabajoId
WHERE e.idEquipos = 1;

SELECT 
    u.nombre,
    COUNT(at.idAccionesTecnicas) AS total_acciones
FROM Usuarios u
LEFT JOIN AccionesTecnicas at ON u.idUsuarios = at.tecnicoId
GROUP BY u.idUsuarios;

SHOW TABLES;

SELECT * FROM accionestecnicas;
SELECT * FROM adjuntos;
SELECT * FROM alarmas;
SELECT * FROM clientes;
SELECT * FROM consumoderepuestos;
SELECT * FROM equipos;
SELECT * FROM estadosalarmas;
SELECT * FROM estadosot;
SELECT * FROM manuales;
SELECT * FROM marcas;
SELECT * FROM modelos;
SELECT * FROM observaciones;
SELECT * FROM ordenesdetrabajo;
SELECT * FROM repuestos;
SELECT * FROM roles;
SELECT * FROM tiposdeequipos;
SELECT * FROM tiposdemanuales;
SELECT * FROM usuarios;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
