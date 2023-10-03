with a as 
(
select store_id,
sum (cast (list_price as float)- (cast (list_price as float))*(discount))
as 'sum_revenue'
from [dbo].[order_items] a
full join [dbo].[orders] b
on a.order_id= b.order_id 
group by store_id 

), b as
(
select store_id,
store_name
from [dbo].[stores]
)

select a.store_id,
store_name,
sum_revenue
from b
left join a
on b.store_id= a.store_id
order by sum_revenue DESC


-- כמות קניות וקונים בכל חנות?
select store_id,
COUNT (distinct a.customer_id) customers,
COUNT (order_id) orders
from [dbo].[orders] a
group by store_id



-- איזה מוצרים נמכרים יותר? איזה פחות?
select *
from (
select product_name,
COUNT (a.order_id) 'orders',
max (COUNT (a.order_id)) over () 'maxi'
from [dbo].[order_items] a
full join [dbo].[products] b
on a.product_id= b.product_id
group by product_name ) q
--where q.maxi= q.orders
order by orders DESC

--מה הקטוגריה הכי רווחית?

with a as
(
select category_id,
SUM (q.count_orders) 'orders_per_category'
from (
select a.product_id,
b.category_id,
COUNT (order_id) 'count_orders'
from [dbo].[order_items] a
full join [dbo].[products] b
on a.product_id= b.product_id
group by a.product_id, b.category_id
) q
group by category_id
), b as
(
select *
from [dbo].[categories]
)

select a.category_id,
b.category_name,
orders_per_category
from a
left join b
on a.category_id= b.category_id


-- איזה מותגים הכי נמכרים?
select q.brand_id,
brand_name,
q.orders
from (
select brand_id,
COUNT (order_id) 'orders'
from [dbo].[products] a
full join  [dbo].[order_items] b
on a.product_id= b.product_id
group by brand_id
) q
full join [dbo].[brands] a
on q.brand_id= a.brand_id




