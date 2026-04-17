-- 50 join questions
select * from customers
select * from Sales_2017
select * from Sales_2016
select * from Products
select * from Product_Subcategories
select * from categories
select * from Territories
select * from Returns

--1 Get all customers with their country from Territories (3-table join)
select distinct c.FirstName , c.LastName , Country from Customers c   -- Distinct to avoid duplicate values
join Sales_2016 s on c.CustomerKey = s.CustomerKey
join Territories t on s.TerritoryKey = t.SalesTerritoryKey

--2 List all products with their subcategory name
select p.ProductName, ps.SubcategoryName from Products p
join Product_Subcategories ps on p.ProductSubcategoryKey = ps.ProductSubcategoryKey

--3 List all subcategories with their category name
select SubcategoryName, CategoryName from Product_Subcategories ps
join Categories cs on ps.ProductCategoryKey = cs.ProductCategoryKey


--4 Get product name and category (3-table join)
select p.ProductName, cs.CategoryName from Products p
join Product_Subcategories ps on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
join Categories cs on ps.ProductCategoryKey = cs.ProductCategoryKey

--5 Show all sales with customer names

select c.FirstName, c.LastName, s.OrderNumber from Customers c
join Sales_2016 s on c.CustomerKey = s.CustomerKey

-- 6 Get top 3 customers by total sales amount

select top 3 c.CustomerKey,FirstName, LastName, round(Sum(p.ProductPrice * s.OrderQuantity),2) total_sales from Customers c
join Sales_2016 s on c.CustomerKey=s.CustomerKey
join Products p on s.ProductKey = p.ProductKey
group by c.CustomerKey, c.FirstName, c.LastName
order by total_sales desc;

--7 Get sales with product names instead of product keys

select ProductName, OrderNumber from Sales_2016 s
join Products p on s.ProductKey = p.ProductKey


--8 Show sales with product + customer

select c.FirstName, c.LastName, s.OrderNumber, p.ProductName from Customers c
join Sales_2015 s on c.CustomerKey = s.CustomerKey
join Products p on s.ProductKey = p.ProductKey

--9 Show sales with product + customer complete name
--using CONCAT(first_name, ' ' , last_name) to join name

select CONCAT(c.FirstName,' ', c.LastName) as Customer_Name, s.OrderNumber, p.ProductName from Customers c
join Sales_2015 s on c.CustomerKey = s.CustomerKey
join Products p on s.ProductKey = p.ProductKey

--10 List all returns with product names
select r.ReturnQuantity, p.ProductName from Products p
join Returns r on p.ProductKey = r.ProductKey

--11 Get customer full name and total orders count
select c.CustomerKey, CONCAT(c.FirstName,' ', c.LastName) as FullName, count(OrderNumber) ordercount from Customers c
join Sales_2016 s on c.CustomerKey=s.CustomerKey
group by c.CustomerKey, CONCAT(c.FirstName,' ', c.LastName)

--12 Show product name with total quantity sold
select p.ProductName, sum(s.OrderQuantity) total_quantity from Sales_2016 s
join Products p on s.ProductKey = p.ProductKey
group by p.ProductName, p.ProductKey

--13 List all customers who made at least 1 purchase
select distinct c.CustomerKey, c.FirstName, c.LastName from Customers c
join Sales_2016 s on c.CustomerKey = s.CustomerKey
where s.OrderQuantity >= 1

--14 Show all products that were sold at least once
select distinct p.ProductName, p.ProductKey from Products p
join Sales_2016 s on p.ProductKey = s.ProductKey
--where s.ProductKey = p.ProductKey

--15 Show all products that were never sold
select p.ProductName, p.ProductKey from Products p
left join Sales_2016 s on p.ProductKey = s.ProductKey
where s.ProductKey is NULL

--16 Get sales amount with product price
select p.ProductKey, p.ProductName, p.ProductPrice, (s.OrderQuantity * p.ProductPrice) as Sales_Amount from Products p
join Sales_2016 s on p.ProductKey = s.ProductKey

--17 Show each sale with order date from Calendar
select OrderNumber, OrderDate from Sales_2016

--18 Count total sales per year using Calendar join
select SUM(s_19.OrderQuantity * p.ProductPrice) as Total_sales from Sales_2016 s_16
join Products p on p.prod

--19 Write a query to return:
"
CustomerKey
FirstName
LastName
OrderNumber
OrderDate

👉 Only include customers who have placed orders.

📌 Requirements:
Use an INNER JOIN
Sort results by OrderDate (latest first)
"

select 
c.CustomerKey,
c.FirstName,
LastName,
s.OrderNumber,
s.OrderDate from Sales_2016 s
join Customers c on c.CustomerKey = s.CustomerKey
order by s.OrderDate desc;

--20 Write a query to return:
"
OrderNumber
OrderDate
ProductName
SubcategoryName
CategoryName

Sort by OrderDate DESC
"

select s.OrderNumber,
s.OrderDate,
p.ProductName,
ps.SubcategoryName,
CategoryName 
from Sales_2016 s
join Products p 
	on s.ProductKey = p.ProductKey
join Product_Subcategories ps
	on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
join Categories c
	on ps.ProductCategoryKey = c.ProductCategoryKey
order by s.OrderDate desc;

--21 Business scenario:
"
Management wants to see total sales volume by region.

Task:
Write a query to return:

Region
TotalOrders → count of distinct OrderNumber
TotalQuantity
"

select t.Region,
count(distinct s.OrderNumber) as TotalOrders,
sum(s.orderquantity)as TotalQuantity from sales_2016 s
join Territories t
	ON s.TerritoryKey = t.SalesTerritoryKey
group by t.Region
order by TotalQuantity desc;

--22 Business scenario:
"
You need to find high-value products.

Return:

ProductKey
ProductName
ListPrice
"

select ProductKey,
	ProductName,
	ProductPrice as ListPrice from Products p
where ProductPrice > (select avg(ProductPrice) from Products)
order by ListPrice desc;

--23 Correlated Subquery
"Business scenario:
Find customers who have placed above-average order quantities.

Task:
Return:
CustomerKey
OrderNumber
OrderQuantity
"

select c.CustomerKey,
s.OrderNumber,
s.OrderQuantity from Sales_2016 s
join Customers c on s.CustomerKey = c.CustomerKey
where OrderQuantity > (select avg(OrderQuantity) from Sales_2016 s2 where s.CustomerKey = s2.CustomerKey)
order by s.OrderQuantity desc;

--24 Write a query to get the latest order per customer using ROW_NUMBER()

select OrderNumber,orderdate from 
							(select s.OrderNumber,
							s.OrderDate, 
							row_number() over (partition by CustomerKey order by OrderDate desc) rn 
							from sales_2016 s) 
							t 
where rn = 1;

--25
"
Write a query to show:

ProductName
ListPrice
RANK()
DENSE_RANK()

Ordered by highest price first
"
select ProductName,
ProductPrice as ListPrice,
RANK() over (order by ProductPrice desc) as Rank,
DENSE_RANK() over (order by ProductPrice desc) as dense_rank
from Products;


-- 26 Return top 3 most expensive products 

select ProductName, 
	   ProductPrice  
		from (select ProductName, 
					ProductPrice, 
					DENSE_RANK() over (order by ProductPrice desc) as denserank from Products) t
where denserank <= 3;
-- this gives multiple products having 1,2,3 ranking


-- For exactly 3 rows

select ProductName, 
	   ProductPrice  
		from (select ProductName, 
					ProductPrice, 
					row_number() over (order by ProductPrice desc) as denserank from Products) t
where denserank <= 3 ;

-- 27 Earliest Order per Customer

"
Task:
Return:
CustomerKey
OrderNumber
OrderDate
"

select CustomerKey,
		OrderNumber,
		OrderDate from (select CustomerKey,
						OrderNumber,
						OrderDate, ROW_NUMBER() over (partition by customerkey order by orderdate) date_number from Sales_2016) d
						
where date_number = 1

-- 28 Second Earliest Order per Customer

select CustomerKey,
		OrderNumber,
		OrderDate from (select CustomerKey,
						OrderNumber,
						OrderDate, ROW_NUMBER() over (partition by customerkey order by orderdate) date_number from Sales_2016) d
						
where date_number = 2

--29 Create a view called CustomerOrders that includes:

CustomerKey
FirstName
LastName
OrderNumber
OrderDate
OrderQuantity

create view CustomerOrders 
as
select c.CustomerKey,
c.FirstName,
c.LastName,
s.OrderNumber,
s.OrderDate,
s.OrderQuantity from Sales_2016 s
join Customers c on s.CustomerKey = c.CustomerKey
;

select * from CustomerOrders;

--30 Create a stored procedure that:
"
Takes CustomerKey as input
Returns all orders for that customer

Output:
OrderNumber
OrderDate
OrderQuantity
"

create procedure customer_orders(@c_key int)
as begin
select OrderNumber,
OrderDate,
OrderQuantity from Sales_2016
where CustomerKey = @c_key
end

exec customer_orders 26708

-- 31 Get the total number of orders per customer.
"
Expected columns:
customerkey, total_orders"

select customerkey, count(OrderNumber) total_orders from Sales_2016 s
group by CustomerKey;

--32 Find the top 5 customers by total spending.
"
👉 Spending = quantity * productprice

Expected columns:
customerkey, total_spent"

select top 5 customerkey, sum(s.OrderQuantity * p.ProductPrice) total_spent from Sales_2016 s
join Products p on s.ProductKey = p.ProductKey
group by CustomerKey
order by total_spent desc ;

-- 33 Get the total quantity sold per product.
"
Expected columns:
productkey, total_quantity"

select productkey, sum(OrderQuantity )total_quantity from Sales_2016
group by ProductKey;


-- 34 Find the total revenue per product category.
"
👉 Revenue = OrderQuantity * ProductPrice

Tables involved:

sales_2016
products
subcatogery
catogery

Expected columns:
catogerykey, total_revenue"

select ps.ProductCategoryKey, sum(s.OrderQuantity * p.ProductPrice) total_revenue from Sales_2016 s
join Products p on s.ProductKey = p.ProductKey
join Product_Subcategories ps on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
join Categories c on ps.ProductCategoryKey = c.ProductCategoryKey
group by ps.ProductCategoryKey;

-- 35 Find customers who have placed more than 5 orders.
"
Expected columns:
customerkey"

-- using group by

select customerkey from Sales_2016
group by CustomerKey
having count(OrderNumber) > 5;

-- using cte
with cte1 
as
(select CustomerKey, count(OrderNumber) total_order from Sales_2016
group by CustomerKey
having count(OrderNumber) > 5
)
select CustomerKey from cte1;

--36 find the highest spending customer.
"
👉 Spending = OrderQuantity * ProductPrice

Expected columns:
customerkey, total_spent"

with cte 
as
(select s.CustomerKey, round(sum(s.OrderQuantity * p.ProductPrice),2) total_spent from Sales_2016 s
join Products p on s.ProductKey = p.ProductKey
group by s.CustomerKey
)
select top 1 customerkey, total_spent from cte
order by total_spent desc;

with cte2 
as
(select s.CustomerKey, round(sum(s.OrderQuantity * p.ProductPrice),2) total_spent, 
ROW_NUMBER() over (order by round(sum(s.OrderQuantity * p.ProductPrice),2) desc) ranked  from Sales_2016 s
join Products p on s.ProductKey = p.ProductKey
group by s.CustomerKey
)
select customerkey, total_spent from cte2
where ranked = 1