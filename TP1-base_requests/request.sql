# 1 - 365
SELECT nom_com,pop_2010 FROM Commune WHERE DEP='34';

# 2 - 25 645
SELECT nom_com,pop_1975,pop_2010 FROM Commune WHERE pop_2010 > pop_1975;

# 3 - 332
SELECT nom_com,pop_1975,pop_2010 FROM Commune c
INNER JOIN Departement d ON c.DEP=d.DEP
INNER JOIN Region r ON r.reg=d.reg
WHERE pop_2010 < pop_1975 AND
r.nom_reg='LANGUEDOC-ROUSSILLON'
ORDER BY nom_com;

# 4 - 8869
CREATE VIEW view_com_down
AS
SELECT nom_com,nom_dep,nom_reg,(pop_2000-pop_2010) as popDown
FROM Commune c
INNER JOIN Departement d ON c.DEP=d.DEP
INNER JOIN Region r ON r.reg=d.reg
WHERE pop_2000>pop_2010;

# 5 - 24971
SELECT dep FROM
(
	(SELECT nom_com FROM Commune)
	MINUS
	(SELECT nom_com FROM view_com_down)
) t INNER JOIN Commune c ON t.nom_com=c.nom_com
GROUP BY c.dep
HAVING COUNT(c.nom_com) = 0;

# 6 - 332
SELECT nom_com FROM Commune c
INNER JOIN Departement d ON c.DEP=d.DEP
INNER JOIN Region r ON r.reg=d.reg
WHERE r.nom_reg='LANGUEDOC-ROUSSILLON'
AND (pop_1975 - pop_2010) =
(
	SELECT MAX(pop_1975 - pop_2010) FROM Commune c
	INNER JOIN Departement d ON c.DEP=d.DEP
	INNER JOIN Region r ON r.reg=d.reg
	WHERE r.nom_reg='LANGUEDOC-ROUSSILLON'
);

# 7 - 7
SELECT nom_com,nom_dep,nom_reg
FROM Commune c
INNER JOIN Departement d ON c.DEP=d.DEP
INNER JOIN Region r ON r.reg=d.reg
WHERE pop_2010=(SELECT MIN(pop_2010) FROM Commune);

# 8 - 21
SELECT nom_com
FROM Commune c INNER JOIN
(
	(SELECT chef_lieu FROM Region)
	INTERSECT
	(SELECT chef_lieu FROM Departement)
) t ON c.code_insee=t.chef_lieu;

# 9 - 64
SELECT nom_com
FROM Commune c INNER JOIN
(
	(SELECT chef_lieu FROM Departement)
	MINUS
	(SELECT chef_lieu FROM Region)
) t ON c.code_insee=t.chef_lieu;

# 10 - 0
SELECT nom_com
FROM Commune c INNER JOIN
(
	(SELECT chef_lieu FROM Region)
	MINUS
	(SELECT chef_lieu FROM Departement)
) t ON c.code_insee=t.chef_lieu;

# 11 - 343
SELECT c1.nom_com
FROM Commune c1 INNER JOIN Departement d1 ON c1.dep=d1.dep,
Commune c2 INNER JOIN Departement d2 ON c2.dep=d2.dep
WHERE d2.chef_lieu=d1.chef_lieu AND c2.code_insee='34101';

# 12
SELECT 
	COUNT(*) as nDepartement, nom_reg
	FROM Departement d INNER JOIN Region r ON r.reg=d.reg
	GROUP BY nom_reg;

# 13
SELECT t1.nom_reg, nDepartement, nCommunes
FROM 
(
	SELECT 
	COUNT(*) as nDepartement, nom_reg
	FROM Departement d INNER JOIN Region r ON r.reg=d.reg
	GROUP BY nom_reg
) t1 INNER JOIN
(
	SELECT
	COUNT(*) as nCommunes, nom_reg
	FROM Commune c
	INNER JOIN Departement d ON c.dep=d.dep
	INNER JOIN Region r ON r.reg=d.reg
	GROUP BY r.nom_reg
) t2 ON t1.nom_reg=t2.nom_reg;

# 14
SELECT
nom_reg
FROM
Region r
WHERE
NOT EXISTS (
SELECT * FROM Commune c INNER JOIN Departement d ON c.dep=d.dep WHERE d.reg = r.reg
);

