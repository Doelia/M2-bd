
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
SELECT dbms_metadata.get_ddl('TABLE', TABLE_NAME, 'STEPHANE') FROM DBA_TABLES WHERE OWNER='STEPHANE';
