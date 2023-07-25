CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);

CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;


--1.What is the amount Each Customer spent on Zomato(Sales Table and Product Table)

Select a.product_id,sum(b.price ) as total_amount_Spent from product as b inner join sales as a on a.product_id=b.product_id
group by a.product_id;

--2.How many Days each customer as spent on Zomato(Sales Table)

select userid,count(distinct created_date) as No_of_days_spent from sales
group by userid;

--3.What was the first product purcahsed by the customer
select * from
(Select *,rank() over(Partition by userid order by created_date) rnk from sales) sales where rnk =1

--4.What is most purchased product in the menu and how many times was it purchased by all customers

--to find the product that was purchased most number of times
select product_id,count(product_id) from sales group by product_id order by count(product_id);
--to find the most purchased product
select top 1 product_id from sales group by product_id order by count(product_id);

select userid,count(product_id) as no_of_times_purchased from sales where product_id=
(select top 1 product_id from sales group by product_id order by count(product_id) desc)
group by userid;

--5.Which item was the most popular for each customer?

select c.*,rank() over(partition by userid order by no_of_times_purchased desc) as rnk from
(select userid,product_id,count(product_id) no_of_times_purchased from sales group by userid,product_id)c;

--6.Which item was purchased first by the customers after they became a member?

Select * from
(select c.* , rank() Over(partition by userid order by created_date) rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b
on a.userid=b.userid where created_date>=gold_signup_date)c)d where rnk=1;

--7.which item was purchased just before the customer became the member?

Select * from
(select c.* , rank() Over(partition by userid order by created_date desc) rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b
on a.userid=b.userid where created_date<=gold_signup_date)c)d where rnk=1;

--8.What is total orders and amount spent for each memnber before they became a member
select userid,count(created_date),sum(price) from
(select c.*,d.price from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b
on a.userid=b.userid where created_date<=gold_signup_date)c inner join product d on c.product_id=d.product_id)e
group by userid;