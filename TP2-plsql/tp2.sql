-- TP2

set serveroutput on;

-- 2.1
-- Construisez un trigger qui v ́erifie que la population de 2010 (pop 2010 de Commune) est toujours
-- positive (ordres insert et update)
CREATE OR REPLACE TRIGGER verif_pop
before INSERT OR update on Commune
for each row
begin
	if (:new.POP_2010 < 0) then
		raise_application_error(-20500, 'La population doit être positive');
	end if;
end;
/

-- 2.2
CREATE OR REPLACE PROCEDURE JoursEtHeuresOuvrables
IS
begin
	if (to_char(sysdate,'DY')='SAT') or (to_char(sysdate,'DY')='SUN')
	then
		raise_application_error(-20010, 'Modification interdite le '||to_char(sysdate,'DAY'));
	end if ;
end;
/

CREATE OR REPLACE trigger testJour
before insert or update or delete on region
begin
	JoursEtHeuresOuvrables();
end;
/

-- 2.3

CREATE table historique
(
	dateOperation date,
	nomUsager varchar(30),
	typeOperation varchar(200)
);

CREATE OR REPLACE trigger histoRegion
before insert or update or delete on region
declare
	typeOp varchar(15);
BEGIN
	if inserting then
		typeOp := 'Insertion';
	elsif updating then
		typeOp := 'Modification';
	elsif deleting then
		typeOp := 'Suppression';
	end if;
	INSERT INTO historique VALUES (SYSDATE, USER, typeOp);
end;
/

-- 2.4
-- Vous construirez un trigger nommé cascade qui porte sur la table fonction et qui se charge à
-- chaque év`enement de suppression ou de modification d’une région (reg) dans Region de supprimer
-- ou de modifier dans la table Departement, les tuples de département dépendants de cette région
CREATE OR REPLACE TRIGGER CASCADEREGION
BEFORE DELETE OR UPDATE ON REGION FOR EACH ROW
DECLARE
	OLDDEP REGION.REG%TYPE;
BEGIN
	OLDDEP := :OLD.REG;
	IF DELETING THEN
		DELETE FROM DEPARTEMENT WHERE REG=OLDDEP;
	ELSIF UPDATING THEN
		UPDATE DEPARTEMENT SET REG=OLDDEP;
	END IF;
END;
/

-- 2.1.1, Par Marlène (ce que était demandé était bien plus simple :P)
-- Vous écrirez un curseur implicite qui permet d'afficher pour le département de l'Hérault (34), le
-- nombre d'habitants en 2010 (somme de tous les habitants de toutes les communes de l'Hérault.
declare
 record_dep departement%ROWTYPE;
 record_com commune%ROWTYPE;
 ajout float;
 total float;
BEGIN
TOTAL := 0;
FOR RECORD_DEP IN (SELECT DEPARTEMENT.DEP FROM DEPARTEMENT WHERE DEPARTEMENT.NOM_DEP = 'HERAULT')
LOOP
    FOR RECORD_COM IN (SELECT * FROM COMMUNE)
    LOOP
        IF (RECORD_COM.DEP = RECORD_DEP.DEP) THEN
            AJOUT := RECORD_COM.POP_2005;
            TOTAL := TOTAL + AJOUT;
        END IF;
    END LOOP;
END LOOP;
DBMS_OUTPUT.PUT_LINE('Le nombre de habitants en 2005 dans le Hérault est de '||total);
END;
/

-- 2.1.2
-- Vous écrirez un curseur explicite qui permet de retourner le nombre d'habitants en 2010 pour
-- tous les départements français
BEGIN
    FOR RECORD_DEP IN (SELECT D.NOM_DEP, SUM(C.POP_2005) AS N FROM COMMUNE C INNER JOIN DEPARTEMENT D ON D.DEP=C.DEP
    GROUP BY D.NOM_DEP)
    LOOP
        DBMS_OUTPUT.PUT_LINE(RECORD_DEP.NOM_DEP||' POP : '||RECORD_DEP.N);
    END LOOP;
END;
/

-- 2.2.1
-- Vous écrirez une fonction (ou une procédure) qui prend en entrée un numéro de département
-- ainsi qu'une année (comprise entre 1975 et 2010) et qui retournera le nombre d'habitants du
-- département sur l'année considérée (pensez `a gérer les exceptions possibles).
-- TODO Pas terminé, comment générer le nom d'une colonne ? ..
CREATE OR REPLACE FUNCTION
    GETNUMHAB (P_NUMDEP VARCHAR2, P_year VARCHAR2) RETURN NUMBER
IS
BEGIN
    SELECT D.NOM_DEP, SUM(C.P_YEAR) AS N FROM COMMUNE C where D.DEP=P_NUMDEP
END;
/
