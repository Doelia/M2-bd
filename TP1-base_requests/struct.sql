/*
 Navicat Premium Data Transfer

 Source Server         : Oracle UM
 Source Server Type    : Oracle
 Source Server Version : 112010
 Source Host           : venus
 Source Schema         : SWOUTERS

 Target Server Type    : Oracle
 Target Server Version : 112010
 File Encoding         : utf-8

 Date: 09/18/2015 14:32:14 PM
*/

-- ----------------------------
--  Table structure for Commune
-- ----------------------------
DROP TABLE Commune;
DROP TABLE Departement;
DROP TABLE Region;

CREATE TABLE Commune (   reg VARCHAR2(4BYTE), dep VARCHAR2(4BYTE), com VARCHAR2(4BYTE), article VARCHAR2(4BYTE), com_nom VARCHAR2(46BYTE), longitude FLOAT(126), latitude FLOAT(126), pop_1975 FLOAT(126), pop_1976 FLOAT(126), pop_1977 FLOAT(126), pop_1978 FLOAT(126), pop_1979 FLOAT(126), pop_1980 FLOAT(126), pop_1981 FLOAT(126), pop_1982 FLOAT(126), pop_1983 FLOAT(126), pop_1984 FLOAT(126), pop_1985 FLOAT(126), pop_1986 FLOAT(126), pop_1987 FLOAT(126), pop_1988 FLOAT(126), pop_1989 FLOAT(126), pop_1990 FLOAT(126), pop_1991 FLOAT(126), pop_1992 FLOAT(126), pop_1993 FLOAT(126), pop_1994 FLOAT(126), pop_1995 FLOAT(126), pop_1996 FLOAT(126), pop_1997 FLOAT(126), pop_1998 FLOAT(126), pop_1999 FLOAT(126), pop_2000 FLOAT(126), pop_2001 FLOAT(126), pop_2002 FLOAT(126), pop_2003 FLOAT(126), pop_2004 FLOAT(126), pop_2005 FLOAT(126), pop_2006 FLOAT(126), pop_2007 FLOAT(126), pop_2008 FLOAT(126), pop_2009 FLOAT(126), pop_2010 FLOAT(126));

-- ----------------------------
--  Table structure for Departement
-- ----------------------------
CREATE TABLE Departement (   reg VARCHAR2(4BYTE), dep VARCHAR2(3BYTE) NOT NULL, chef_lieu VARCHAR2(46BYTE), nom_dep VARCHAR2(30BYTE));

-- ----------------------------
--  Table structure for Region
-- ----------------------------
CREATE TABLE Region (   reg VARCHAR2(4BYTE) NOT NULL, chef_lieu VARCHAR2(46BYTE), nom_reg VARCHAR2(30BYTE));

-- ----------------------------
--  Primary key structure for table Departement
-- ----------------------------
ALTER TABLE Departement ADD CONSTRAINT SYS_C0074687 PRIMARY KEY(dep);

-- ----------------------------
--  Checks structure for table Departement
-- ----------------------------
ALTER TABLE Departement ADD CONSTRAINT SYS_C0074686 CHECK (dep IS NOT NULL) ENABLE;

-- ----------------------------
--  Primary key structure for table Region
-- ----------------------------
ALTER TABLE Region ADD CONSTRAINT SYS_C0074685 PRIMARY KEY(reg);

-- ----------------------------
--  Checks structure for table Region
-- ----------------------------
ALTER TABLE Region ADD CONSTRAINT SYS_C0074684 CHECK (reg IS NOT NULL) ENABLE;

-- ----------------------------
--  Foreign keys structure for table Commune
-- ----------------------------
ALTER TABLE Commune
ADD CONSTRAINT fk_com_dep FOREIGN KEY (dep) REFERENCES Departement (dep) ENABLE
ADD CONSTRAINT fk_com_reg FOREIGN KEY (reg) REFERENCES Region (reg) ENABLE;

-- ----------------------------
--  Foreign keys structure for table Departement
-- ----------------------------
ALTER TABLE Departement ADD CONSTRAINT fk_dep FOREIGN KEY (reg) REFERENCES Region (reg) ENABLE;

ALTER TABLE Commune ADD code_insee VARCHAR2(6BYTE);

UPDATE Commune set com='00'||com where length(com)=1;
UPDATE Commune set com='0'||com where length(com)=2;

UPDATE Commune SET code_insee = CONCAT(dep, com);

ALTER TABLE Commune ADD CONSTRAINT pk_commune PRIMARY KEY(code_insee);

SELECT COUNT(*),code_insee
FROM Commune
GROUP BY code_insee
HAVING COUNT(*)>1;

ALTER TABLE Commune DROP colum reg;
