select * from customer

--Q1
select gender, sum(purchase_amount) as revenue
from customer
group by gender

--Q2
select customer_id, purchase_amount 
from customer
where discount_applied = 'Yes'
and purchase_amount >=
(select avg(purchase_amount) from customer)

--Q3
select item_purchased, floor(avg(review_rating)) as AvgProduct
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

--Q4
select shipping_type, 
ceiling(avg(purchase_amount))
from customer
where shipping_type in ('Standard', 'Express')
group by shipping_type

--Q5
select subscription_status,
count(customer_id) as total_customers,
ceiling(avg(purchase_amount)) as avg_spend,
ceiling(sum(purchase_amount)) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;

--Q6
select item_purchased,
ceiling(100*sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*)) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

--Q7
with customer_type as(
select customer_id, previous_purchases,
case
	when previous_purchases between 2 and 20 then 'Returning' 
	else 'loyal'
	end as customer_segment
from customer
)
select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment

--Q8
with item_counts as(
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over (partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;

--Q9
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status

--Q10
select age_group, sum(purchase_amount) as revenue
from customer
group by age_group
order by revenue desc;