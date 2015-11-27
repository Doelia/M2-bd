-- Exercice 1

set linesize 160

-- Vérifier que l'index existe :
select index_name, blevel, table_name FROM user_indexes WHERE index_name='PK_COMMUNE';

-- Après un explain
select plan_table_output from table(dbms_xplan.display());

-- Désactiver/réactiver l'index
alter index PK_COMMUNE unusable;
alter index PK_COMMUNE rebuild;

-- Exercice 2
