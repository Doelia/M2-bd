
set long 40000;

-- Donne la requête de création de la table commune
select DBMS_METADATA.GET_DDL('TABLE','COMMUNE') from DUAL;


set long 40000
set head off echo off
exec DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'SEGMENT_ATTRIBUTES', false);
exec DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'STORAGE', true);
exec DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'TABLESPACE', false);

spool communes.sql
select DBMS_METADATA.GET_DDL('TABLE','COMMUNE', USER) from user_tables;
spool off

exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR', true);
SELECT dbms_metadata.get_ddl('TABLE', TABLE_NAME, 'STEPHANE') FROM user_tables;

-- Liste des tables pour un user
SELECT TABLE_NAME FROM DBA_TABLES WHERE OWNER='STEPHANE';

-- Schéma de construction pour toutes les tables d'un user
SELECT dbms_metadata.get_ddl('TABLE', TABLE_NAME, 'STEPHANE') FROM ALL_TABLES WHERE OWNER='STEPHANE';

-- Question 2.2.1
-- Soucis de droit : ça marche que pour le schéma STEPHANE en pl/sql
CREATE OR REPLACE
FUNCTION "ToutesTables" (P_USER_NAME IN VARCHAR) RETURN CLOB
IS
	out CLOB;
BEGIN

out := '';

FOR RECORD_INC IN (
SELECT dbms_metadata.get_ddl('TABLE', TABLE_NAME, P_USER_NAME) AS INC FROM ALL_TABLES WHERE OWNER=P_USER_NAME)
LOOP
	out := RECORD_INC.INC||out;
END LOOP;

return out;

END;


-- Exemple exerice 3

set pages 0
set feedback off
set heading off
set trimspool off
set termout off
set verify off
set colsep ""
set tab off
set linesize 100
SPOOL ON
SPOOL file_out
select * from region;
SPOOL OFF
