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

