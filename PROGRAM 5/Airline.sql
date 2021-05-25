create database Lab5;
use Lab5;

create table flights(
	flno int,
    fromplace varchar(15),
    toplace varchar(15),
    distance int,
    departs datetime,
    arrives datetime,
    price int,
    primary key (flno));
desc flights;

create table aircraft(
	aid int,
    aname varchar(15),
    cruisingrange int,
    primary key (aid));
desc aircraft;

create table employees (
	eid int,
    ename varchar(15),
    salary int,
    primary key (eid));
desc employees;

create table certified (
	eid int,
    aid int,
    foreign key (eid) references employees(eid),
    foreign key (aid) references aircraft(aid));
desc certified;


insert into flights values(101, 'Bangalore', 'Delhi', 2500, '2005-05-13 07:15:31', '2005-05-13 18:15:31', 5000);
insert into flights values(102, 'Bangalore', 'Lucknow', 3000, '2013-05-05 07:15:31', '2013-05-05 11:15:31', 6000);
insert into flights values(103, 'Lucknow', 'Delhi', 500, '2013-05-05 12:15:31', '2013-05-05 17:15:31', 3000);
insert into flights values(107, 'Bangalore', 'Frankfurt', 8000, '2013-05-05 07:15:31', '2013-05-05 22:15:31', 60000);
insert into flights values(104, 'Bangalore', 'Frankfurt', 8500, '2013-05-05 07:15:31', '2013-05-05 23:15:31', 75000);
insert into flights values(105, 'Kolkata', 'Delhi', 3400, '2013-05-05 07:15:31', '2013-05-05 09:15:31', 7000);
insert into flights values(106, 'Bangalore', 'Kolkata', 1000, '2013-05-05 01:15:30', '2013-05-05 09:20:30', 10000);
insert into flights values(108, 'Lucknow', 'Kolkata', 1000, '2013-05-05 11:30:30', '2013-05-05 15:20:30', 10000);
select * from flights;

insert into aircraft values(101, '747', 3000);
insert into aircraft values(102, 'Boeing', 900);
insert into aircraft values(103, '647', 800);
insert into aircraft values(104, 'Dreamliner', 10000);
insert into aircraft values(105, 'Boeing', 3500);
insert into aircraft values(106, '707', 1500);
insert into aircraft values(107, 'Dream', 120000);
insert into aircraft values(108, '707', 760);
insert into aircraft values(109, '747', 1000);
select * from aircraft;

insert into employees values(701, 'A', 50000);
insert into employees values(702, 'B', 100000);
insert into employees values(703, 'C', 150000);
insert into employees values(704, 'D', 90000);
insert into employees values(705, 'E', 40000);
insert into employees values(706, 'F', 60000);
insert into employees values(707, 'G', 90000);
select * from employees;

insert into certified values(701, 101);
insert into certified values(701, 102);
insert into certified values(701, 106);
insert into certified values(701, 105);
insert into certified values(702, 104);
insert into certified values(703, 104);
insert into certified values(704, 104);
insert into certified values(702, 107);
insert into certified values(703, 107);
insert into certified values(704, 107);
insert into certified values(702, 101);
insert into certified values(702, 108);
insert into certified values(701, 109);
select * from certified;


select distinct a.aname from aircraft a where a.aid in (
	select c.aid from certified c, employees e where
    c.eid = e.eid and not exists(
		select * from employees e1 where e1.eid=e.eid and e1.salary<80000
    ));


select max(a.cruisingrange), c.eid from certified c, aircraft a
 where c.aid = a.aid group by c.eid having count(c.eid)>3;


select ename from employees where salary <(
select min(price) from flights where fromplace='Bangalore' and toplace='Frankfurt');


select avg(e.salary), c.aid from certified c, employees e where c.aid in(
select aid from aircraft where cruisingrange>1000) and e.eid = c.eid group by c.aid;


select ename from employees where eid in(
select eid from certified where aid in(
select aid from aircraft where aname = 'Boeing'));


select aname from aircraft where cruisingrange > any 
(select distance from flights where fromplace='Bangalore' and toplace='Delhi');


select F.flno, F.departs
from flights F
Where F.flno in ( ( select F0.flno
 from flights F0
 where F0.fromplace = 'Bangalore' and F0.toplace = 'Kolkata'
 and extract(hour from F0.arrives) < 18 )
 union
( select F0.flno
 from flights F0, flights F1
 where F0.fromplace = 'Bangalore' and F0.toplace <> 'Kolkata'
 and F0.toplace = F1.fromplace and F1.toplace = 'Kolkata'
 and F1.departs > F0.arrives
 and extract(hour from F1.arrives) < 18)
 union
( select F0.flno
 from flights F0, flights F1, flights F2
 where F0.fromplace = 'Bangalore'
 and F0.toplace = F1.fromplace
 and F1.toplace = F2.fromplace
 and F2.toplace = 'Kolkata'
 and F0.toplace <> 'Kolkata'
 and F1.toplace <> 'Kolkata'
 and F1.departs > F0.arrives
 and F2.departs > F1.arrives
 and extract(hour from F2.arrives) < 18));