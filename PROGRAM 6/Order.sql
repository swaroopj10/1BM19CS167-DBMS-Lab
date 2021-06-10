create database Lab6;
use Lab6;

create table salesman (
	salesman_id int, 
	name varchar (20), 
	city varchar (20), 
	commission varchar (20), 
	primary key (salesman_id));
desc salesman;

create table customer (
	customer_id int, 
	cust_name varchar (20), 
	city varchar (20), 
	grade int , 
    salesman_id int, 
	primary key (customer_id), 
	foreign key (salesman_id) references salesman(salesman_id) on delete set null);
desc customer;

create table orders (
	ord_no int , 
	purchase_amt int, 
	ord_date date, 
    customer_id int, 
	salesman_id int, 
	primary key (ord_no), 
	foreign key (customer_id) references customer (customer_id) on delete cascade, 
	foreign key (salesman_id) references salesman (salesman_id) on delete cascade);
desc orders;

insert into salesman values (1000, 'john','bangalore','25 %'); 
insert into salesman values (2000, 'ravi','bangalore','20 %'); 
insert into salesman values (3000, 'kumar','mysore','15 %'); 
insert into salesman values (4000, 'smith','delhi','30 %'); 
insert into salesman values (5000, 'harsha','hydrabad','15 %'); 
select * from salesman;

insert into customer values (10, 'preethi','bangalore', 100, 1000); 
insert into customer values (11,'vivek','mangalore', 300, 1000); 
insert into customer values (12, 'bhaskar','chennai', 400, 2000); 
insert into customer values (13, 'chethan','bangalore', 200, 2000); 
insert into customer values (14, 'mamatha','bangalore', 400, 3000); 
select * from customer;

insert into orders values (50, 5000, '04-06-17', 10, 1000); 
insert into orders values (51, 450, '20-01-17', 10, 2000);
insert into orders values (52, 1000, '24-02-17', 13, 2000); 
insert into orders values (53, 3500, '13-04-17', 14, 3000); 
insert into orders values (54, 550, '09-03-17', 12, 2000);
select * from orders;



SELECT grade, count(DISTINCT customer_id) 
FROM customer
GROUP BY grade 
HAVING grade > (SELECT AVG(grade) 
FROM customer
WHERE city='bangalore');



SELECT salesman_id, NAME 
FROM salesman a 
WHERE 1 < (SELECT count(*) 
FROM customer 
WHERE salesman_id=a.salesman_id);



SELECT salesman.salesman_id, NAME, cust_name, commission 
FROM salesman, customer
WHERE salesman.city = customer.city 
UNION 
SELECT salesman_id, name, 'no customer', commission 
FROM salesman 
WHERE NOT city = ANY 
(SELECT city 
FROM customer) 
ORDER BY 2 DESC;



CREATE VIEW highsalesman AS
SELECT b.ord_date, a.salesman_id, a.name 
FROM salesman a, orders b
WHERE a.salesman_id = b.salesman_id 
AND b.purchase_amt=(SELECT max(purchase_amt) 
FROM orders c 
WHERE c.ord_date = b.ord_date);
SELECT * FROM highsalesman;


DELETE FROM salesman 
WHERE salesman_id=1000;
SELECT * FROM salesman;
SELECT * FROM orders;