explain plan for
select 
	c.nom_com, c.latitude, c.longitude
from
	commune c,
	departement d
where
	c.dep=d.dep
	and (d.nom_dep='HERAULT'
	or d.nom_dep='GARD')
;

explain plan for
select 
	c.nom_com, c.latitude, c.longitude
from
	commune c
where
	exists (select * from departement d where c.dep=d.dep)
;

