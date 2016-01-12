Vous testerez les sequences d''instruction suivantes et vous expliquerez les effets obtenus

-- sequence 1
set transaction read only;
select * from cat;
update employe set fonction='commerciale' where fonction='commercial';


--sequence 2
select * from cat;
set transaction read only;
rollback;


--sequence 3
set transaction read only;
create table PrVoir (valeur integer primary key);
update emp set fonction='commerciale' where fonction='commercial';
rollback;


--sequence 4
insert into PrVoir values (1);
insert into PrVoir values (2);
insert into PrVoir values (3);
insert into PrVoir values (4);
insert into PrVoir values (5);
create table EncorePrVoir (valeur integre cle primaire);
rollback;


--sequence 5
insert into PrVoir values (1);
insert into PrVoir values (2);
insert into PrVoir values (3);
insert into PrVoir values (4);
insert into PrVoir values (5);
create table EncorePrVoir (valeur integer primary key);
rollback;


--sequence 6
delete from PrVoir;
create table CorePrVoir (valeur integer primary key);
insert into PrVoir values (1);
insert into PrVoir values (2);
insert into PrVoir values (3);
insert into PrVoir values (4);
insert into PrVoir values (5);
rollback; 


--sequence 7
insert into PrVoir values (1);
create table CorePrVoir (valeur integre);
rollback;
select * from PrVoir;

-- sequence 8
-- deux sessions ouvertes par ex. user1/user1 et user2/user2 sur master (travaillez en binôme)

-- sur user2
donner tous les droits a user1 sur la table emp
-- sur user1
set transaction isolation level serializable;
--sur user2
insérer un tuple dans la table emp (de user2)
-- sur user1
consulter la table user2.emp 
constatation ?
-- sur user2 
valider la transaction
-- sur user1
consulter la table user2.emp 
constatation ? quel aurait été le résultat avec un mode transactionnel read committed ?

-- sur user2 
-- mettre à jour un tuple 
update emp set salaire =1000 where num=12;

-- sur user1
-- essayer de mettre à jour le même tuple
update user2.compte set salaire =2000 where num=12;
constatation ? 
-- sur user2 
valider la transaction
-- sur user1
constatation ? quel aurait été le résultat avec un mode transactionnel read committed ?

-- sequence 9
-- interblocage
-- deux sessions ouvertes en mode read committed
-- sur user2 
-- mettre à jour un tuple 
update emp set salaire =1000 where num=10;

-- sur user1
-- essayer de mettre à jour le même tuple
update user2.compte set salaire =2000 where num=11;

-- sur user2 
-- mettre à jour le tuple verrouillé par user 1 
update emp set salaire =1000 where num=11;

-- sur user1
-- mettre à jour le tuple verrouillé par user 2
update user2.compte set salaire =2000 where num=10;

constatation ? comment sortir de l''interblocage et quelle est l''information perdue
quel aurait été le résultat avec un mode transactionnel serializable ?

