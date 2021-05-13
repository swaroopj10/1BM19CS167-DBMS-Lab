create database Lab3;
use Lab3;

create table catalog(sid int,pid int,cost int);
desc catalog;

create table supplier(sid int,sname varchar(20),city varchar(15),primary key (sid));
desc supplier;

create table parts(pid int,pname varchar(15),color varchar(10),primary key (pid));
desc parts;

insert into supplier values(10001, 'Acme Widget','Bengaluru');
insert into supplier values(10002,'Johns','Kolkata');
insert into supplier values(10003, 'Vimal','Mumbai');
insert into supplier values(10004, 'Reliance','Delhi');
insert into supplier values(10005, 'Mahindra','Mumbai');
select * from supplier;


insert into parts values(20001, 'Book','Red');
insert into parts values(20002, 'Pen','Red');
insert into parts values(20003, 'Pencil','Green');
insert into parts values(20004, 'Mobile','Green');
insert into parts values(20005, 'Charger','Black');
select * from parts;

insert into catalog values(10001, '20001','10');
insert into catalog values(10001, '20002','10');
insert into catalog values(10001, '20003','30');
insert into catalog values(10001, '20004','10');
insert into catalog values(10001, '20005','10');
insert into catalog values(10002, '20001','10');
insert into catalog values(10002, '20002','20');
insert into catalog values(10003, '20003','30');
insert into catalog values(10004, '20003','40');
select * from catalog;

select distinct p.pname from parts p, catalog c where p.pid = c.pid;

select s.sname from supplier s 
where not exists (select p.pid from parts p where not exists 
(select c.sid from catalog c where c.sid = s.sid and c.pid = p.pid));

select s.sname from supplier s where not exists
 (select p.pid from parts p where p.color = 'Red' and
 (not exists (select c.sid from catalog c where c.sid = s.sid and c.pid = p.pid)));

select p.pname from parts p , catalog c, supplier s
 where p.pid = c.pid and c.sid = s.sid and s.sname = 'Acme Widget' 
and not exists
 (select * from catalog c1, supplier s1 where
 p.pid = c1.pid and c1.sid = s1.sid and s1.sname <> 'Acme Widget');

select distinct c.sid from catalog c
where c.cost > ( select avg (c1.cost)
from catalog c1
where c1.pid = c.pid );

select p.pid, s.sname
from parts p, supplier s, catalog c
where c.pid = p.pid
and c.sid = s.sid
and c.cost = (select MAX(c1.cost)
from catalog c1
where c1.pid = p.pid);