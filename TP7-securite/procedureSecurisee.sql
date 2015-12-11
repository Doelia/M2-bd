
declare
empcur pls_integer;
sqlStmt varchar2(32767);
fonction varchar2(20) :='commercial';
nom varchar2(20);
v_execute pls_integer;
begin
sqlStmt := 'SELECT nom FROM emp WHERE fonction = :fonction';
empcur := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(empcur, sqlStmt, DBMS_SQL.NATIVE);
DBMS_SQL.BIND_VARIABLE(empcur, ':fonction', fonction);
DBMS_SQL.DEFINE_COLUMN_CHAR(empcur, 1, nom, 20);
v_execute := DBMS_SQL.EXECUTE(empcur);
loop
     if DBMS_SQL.FETCH_ROWS(empcur) = 0 then
        exit;
     end if;
     DBMS_SQL.COLUMN_VALUE_CHAR(empcur, 1, nom);
     DBMS_OUTPUT.PUT_LINE('Emp name: '||nom);
   end loop;
   DBMS_SQL.CLOSE_CURSOR(empcur);
 EXCEPTION
   when others then
        DBMS_SQL.CLOSE_CURSOR(empcur);
        raise_application_error(-20000, 'Unknown Exception Raised: '||sqlcode||' '||sqlerrm);
end;
/

