select count(customer_id) as customers_count
from customers;

with report_1 as (
select 
concat(e.first_name,' ',e.last_name) as name,
count (s.quantity) as operations,
FLOOR (sum (s.quantity * p.price)) as income
from employees as e
left join sales as s on s.sales_person_id = e.employee_id
left join products as p on p.product_id  = s.product_id
group by e.first_name,e.last_name
)
select *
from report_1
order by income desc nulls last
limit 10;

with report_2 as (
select 
concat(e.first_name,' ',e.last_name) as name,
FLOOR (sum (s.quantity * p.price)) as revenue,
FLOOR (avg (s.quantity * p.price)) as average_income
from employees as e
left join sales as s on s.sales_person_id = e.employee_id
left join products as p on p.product_id  = s.product_id
group by e.first_name,e.last_name
)
select name, average_income
from report_2
where average_income < (select avg(revenue) from tab)
group by name, average_income
order by average_income asc;

with report_3 as (
select 
concat(e.first_name,' ',e.last_name) as name, 
to_char(s.sale_date, 'day') as weekday,
to_char(s.sale_date, 'id') as weekday_id,
round(sum (s.quantity * p.price),0) as income
from employees as e
join sales as s on s.sales_person_id = e.employee_id
join products as p on p.product_id  = s.product_id
group by e.first_name, e.last_name, s.sale_date
)
select name, weekday, sum (income)
from report_3
group by name, weekday_id, weekday
order by name, weekday_id;

with step6_report_1 as (
select s.customer_id, c.age, 
case
	when age > 15 and age < 26 then '16-25'
	when age > 25 and age < 41 then '26-40'
	else '40+'
end as age_category
from sales as s
join customers as c on c.customer_id = s.customer_id
group by age, s.customer_id
)
select age_category, count (customer_id)
from step6_report_1
group by age_category
order by age_category;

select to_char(s.sale_date,'YYYY-MM') as date, count(distinct s.customer_id) as total_customers, round(sum (s.quantity * p.price), 0) as income 
from sales as s
join products as p on p.product_id = s.product_id 
group by to_char(s.sale_date,'YYYY-MM')
order by to_char(s.sale_date,'YYYY-MM');

with step6_report_3 as (
select concat(c.first_name, ' ', c.last_name ) as customer, s.sale_date,
concat(e.first_name,' ',e.last_name) as seller,
price, quantity, s.customer_id,
row_number () over (partition by s.customer_id order by sale_date) as row_numb
from sales as s
inner join customers as c on c.customer_id  = s.customer_id 
inner join employees e on e.employee_id = s.sales_person_id 
inner join products as p on p.product_id = s.product_id  
group by c.first_name, c.last_name, e.first_name, e.last_name, sale_date, s.customer_id, price, quantity
order by s.customer_id
)
select customer, sale_date, seller
from step6_report_3
where row_numb = 1 and price = '0'
order by customer_id;

