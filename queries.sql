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

