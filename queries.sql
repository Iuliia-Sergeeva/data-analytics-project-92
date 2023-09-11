select count(customer_id) as customers_count
from customers;

with tab as (
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
from tab
order by income desc nulls last
limit 10;

with tab as (
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
from tab
where average_income < (select avg(revenue) from tab)
group by name, average_income
order by average_income asc;
