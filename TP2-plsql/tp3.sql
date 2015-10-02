--


create or replace function
	DistanceKM (comA in varchar, comB in varchar)
	return number
IS
	lat_a FLOAT;
	lat_b FLOAT;
	long_a FLOAT;
	long_b FLOAT;
begin
	SELECT latitude into lat_a
	FROM Commune where nom_com = comA;
	SELECT longitude into long_a
	FROM Commune where nom_com = comA;
	SELECT latitude into lat_b
	FROM Commune where nom_com = comB;
	SELECT longitude into long_b
	FROM Commune where nom_com = comB;

	lat_a := lat_a/57.295779513082;
	lat_b := lat_b/57.295779513082;
	long_a := long_a/57.295779513082;
	long_b := long_b/57.295779513082;

	return 6366*acos(cos((lat_a))*cos((lat_b))*cos((long_b)-(long_a))+sin((lat_a))*sin((lat_b)));

	EXCEPTION
	      WHEN NO_DATA_FOUND THEN
	       raise_application_error(-20010, 'Commune introuvable');

end;
/

SELECT DistanceKM('MONTPELLIER', 'PARIS') FROM dual;
-- Return  594.478432


