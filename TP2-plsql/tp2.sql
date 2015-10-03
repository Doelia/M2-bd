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
CREATE OR REPLACE procedure
	JoursEtHeuresOuvrables
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
CREATE OR REPLACE TRIGGER cascadeRegion
before delete or update on region for each row
declare
	oldDep region.reg%TYPE;
begin
	oldDep := :old.reg;
	if deleting then
		DELETE FROM departement WHERE reg=oldDep;
	elsif updating then
		UPDATE departement SET reg=oldDep;
	end if;
end;
/

-- 2.1.1
-- Par Marlène (ce que était demandé était bien plus simple :P)
declare
 record_dep departement%ROWTYPE;
 record_com commune%ROWTYPE;
 ajout float;
 total float;
BEGIN
total := 0;
FOR record_dep IN (SELECT departement.dep FROM departement WHERE departement.nom_dep = 'HERAULT')
LOOP
    FOR record_com IN (SELECT * FROM commune)
    LOOP
        if (record_com.dep = record_dep.dep) then
            ajout := record_com.pop_2005;
            total := total + ajout;
        end if;
    END LOOP;
END LOOP;
DBMS_OUTPUT.PUT_LINE('Le nombre de habitants en 2005 dans le Hérault est de '||total);
END;
/

-- 2.1.2
BEGIN
    FOR record_dep IN (SELECT d.nom_dep, SUM(c.POP_2005) as n FROM commune c INNER JOIN departement d ON d.dep=c.dep
    GROUP BY d.nom_dep)
    LOOP
        DBMS_OUTPUT.PUT_LINE(record_dep.nom_dep||' pop : '||record_dep.n);
    END LOOP;
END;
/

-- 2.2.1
