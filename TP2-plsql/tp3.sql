set serveroutput on;


create or replace package UrbanUnits
as
	k_rad constant float := 57.295779513082;

	function DistanceKM (comA in varchar, comB in varchar) return number;
end UrbanUnits;
/

create or replace package body UrbanUnits
as

	function
		DistanceKM (comA in varchar, comB in varchar) return number
	IS
		lat_a FLOAT;
		lat_b FLOAT;
		long_a FLOAT;
		long_b FLOAT;
	begin
		SELECT latitude, longitude into lat_a, long_a
		FROM Commune where nom_com = comA;

		SELECT latitude, longitude into lat_b, long_b
		FROM Commune where nom_com = comB;

		lat_a := lat_a/k_rad;
		lat_b := lat_b/k_rad;
		long_a := long_a/k_rad;
		long_b := long_b/k_rad;

		return 6366*acos(cos((lat_a))*cos((lat_b))*cos((long_b)-(long_a))+sin((lat_a))*sin((lat_b)));

		EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		       raise_application_error(-20010, 'Commune introuvable');

	end;

end UrbanUnits;
/

-- Utilisation:
SELECT UrbanUnits.DistanceKM('MONTPELLIER', 'PARIS') FROM dual;
-- Return  594.478432



CREATE or REPLACE package Supervision
as
	procedure getDatas (nameTable in varchar);
	procedure getConnectedUsers;
end Supervision;
/


CREATE OR REPLACE
package body SUPERVISION
as
	procedure GETDATAS (nameTable in varchar)
	is

	begin

		for CUR_VAR IN (SELECT c.COLUMN_NAME, c.DATA_TYPE, k.CONSTRAINT_NAME
		FROM user_tab_columns c
		LEFT JOIN user_cons_columns k ON c.TABLE_NAME=k.TABLE_NAME AND c.COLUMN_NAME=k.COLUMN_NAME
		WHERE c.TABLE_NAME = nameTable)
		loop
			 dbms_output.put_line(CUR_VAR.COLUMN_NAME||' '||CUR_VAR.DATA_TYPE||' '||CUR_VAR.CONSTRAINT_NAME);
		end loop;

	end ;

	procedure getConnectedUsers
	is
	begin
		for CUR_VAR IN (select username, osuser, terminal
		from v$session
		where username is not null)
		loop
			 dbms_output.put_line(CUR_VAR.username||' '||CUR_VAR.osuser||' '||CUR_VAR.terminal);
		end loop;
	end;


end SUPERVISION;
/

-- TEST:
EXEC SUPERVISION.GETDATAS('COMMUNE');
