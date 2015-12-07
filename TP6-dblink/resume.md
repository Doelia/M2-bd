

## Préambule

### Approche déscendante (top-dowm)
À partir d'un schéma global pour produire des schémas locaux
- Fragmentation horizontale
- Fragmentation verticale
- Fragmentation hybride

### Approche ascendante (down-top)
À partir des schémas locaux pour
produire un schéma global

## Plusieurs types de liens :

Lien privé portant sur un schéma utilisateur :
```
create database link nomDuLien connect to nomSchema identifie by motPasseSchema using 'nomService';
```

Lien public défini globalement sur la base de donnés :
```
create public database link nomDuLien using 'nomService';
```

Lien privé portant sur le schéma utilisateur interne user1 et la BD master :
```
create database link monLien connect to user1 identified by user1 using 'master';
```

Lien privé portant sur le schéma utilisateur interne user1 et la BD licence :
```
create database link me_to_user1_licence connect to user1 identified by user1 using 'licence';
```

## TP

Etapes :
1. démarche d'intégration de schémas de bases de données existants
2. démarche de décomposition

Schéma 1 : pcavalet / MASTER
Schéma 2 : swouters / LICENCE
Master global : swouters / MASTER

### Création les liens
```
create database link sc1 connect to pcavalet identified by pikynau using 'MASTER';
create database link sc2 connect to swouters identified by wugaxu2 using 'LICENCE';
```

Vérifier que ça marche :
```
select table_name from user_tables@sc1;
```

### Requetes

les informations générales sur les virus
```
select * from virus@sc1;
```

### Créer des vues

Vue dynamique :
CREATE VIEW virus AS select * from virus@sc1;

Vue matérialisée :
CREATE MATERIALIZED VIEW virus AS select * from virus@sc1;

