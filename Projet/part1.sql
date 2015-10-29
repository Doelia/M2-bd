
set long 40000;

-- Donne la requête de création de la table
select DBMS_METADATA.GET_DDL('TABLE','COMMUNE') from DUAL;


set long 40000
set head off echo off
exec DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'SEGMENT_ATTRIBUTES', false);
exec DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'STORAGE', true);
exec DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform, 'TABLESPACE', false);

spool communes.sql
select DBMS_METADATA.GET_DDL('TABLE','COMMUNE', USER) from user_tables;
spool off
