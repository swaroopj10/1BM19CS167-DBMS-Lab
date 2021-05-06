create database Lab2;
use Lab2;

create table Branch(branch_name varchar(30),branch_city varchar(30),assests real, primary key(branch_name));
desc Branch;

create table BankCustomer(customer_name varchar(30),customer_street varchar(30),customer_city varchar(30), primary key(customer_name));
desc BankCustomer;

create table BankAccount(
accno int,
branch_name varchar(20),
balance real,
primary key(accno),
foreign key(branch_name) references Branch(branch_name)
);
desc BankAccount;

create table Depositer(
customer_name varchar(20),
accno int,
primary key(customer_name,accno),
foreign key(customer_name) references BankCustomer(customer_name),
foreign key(accno) references BankAccount(accno)
);
desc Depositer;


create table Loan(
loan_number int,
branch_name varchar(20),
Amount real,
primary key(loan_number),
foreign key(branch_name) references Branch(branch_name) 
);
desc Loan;

insert into Branch values('SBI_Chamrajpet','Bangalore',50000);
insert into Branch values('SBI_ResidencyRoad','Bangalore',10000);
insert into Branch values('SBI_ShivajiRoad','Bangalore',20000);
insert into Branch values('SBI_ParlimentRoad','Delhi',10000);
insert into Branch values('SBI_Jantarmantar','Delhi',20000);
select *from Branch;


insert into Loan values(2,'SBI_ResidencyRoad',2000);
insert into Loan values(1,'SBI_Chamrajpet',1000);
insert into Loan values(3,'SBI_ShivajiRoad',3000);
insert into Loan values(4,'SBI_ParlimentRoad',4000);
insert into Loan values(5,'SBI_Jantarmantar',3000);
select *from Loan;

insert into BankAccount values(1,'SBI_Chamrajpet',2000);
insert into BankAccount values(2,'SBI_ResidencyRoad',5000);
insert into BankAccount values(3,'SBI_ShivajiRoad',6000);
insert into BankAccount values(4,'SBI_ParlimentRoad',9000);
insert into BankAccount values(5,'SBI_Jantarmantar',8000);
insert into BankAccount values(6, 'SBI_ShivajiRoad', 4000);
insert into BankAccount values(8, 'SBI_ResidencyRoad', 4000);
insert into BankAccount values(9, 'SBI_ParlimentRoad', 3000);
insert into BankAccount values(10, 'SBI_ResidencyRoad', 5000);
insert into BankAccount values(11, 'SBI_Jantarmantar', 2000);
select *from BankAccount;

insert into BankCustomer values ('Avinash', 'Bull_Temple_Road', 'Bangalore');
insert into BankCustomer values ('Dinesh', 'Bannergatta_Road', 'Bangalore');
insert into BankCustomer values ('Mohan', 'National_College_Road', 'Bangalore');
insert into BankCustomer values ('Nikhil', 'Akbar_Road', 'Delhi');
insert into BankCustomer values ('Ravi', 'Prithviraj_Road', 'Delhi');
select *from BankCustomer;


insert into Depositer values('Avinash', 1);
insert into Depositer values('Dinesh', 2);
insert into Depositer values('Nikhil', 4);
insert into Depositer values('Ravi', 5);
insert into Depositer values('Avinash', 8);
insert into Depositer values('Nikhil', 9);
insert into Depositer values('Dinesh', 10);
insert into Depositer values('Nikhil', 11);
select *from Depositer;

select c.customer_name
from BankCustomer c
where exists(
select d.customer_name
from Depositer d, BankAccount ba
where
d.accno=ba.accno and
c.customer_name=d.customer_name and
ba.branch_name='SBI_ResidencyRoad'
group by d.customer_name
having count(d.customer_name)>=2
);


select distinct d.customer_name from Depositer d where exists( select * from BankAccount ba 
where ba.accno=d.accno and exists (select * from Branch b where b.branch_name = ba.branch_name and b.branch_city='Delhi'));

delete from BankAccount where branch_name in (select branch_name from branch where branch_city = 'Bombay');
select *from BankAccount;