/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [BikeStores].[sales].[customers]


SELECT * FROM [BikeStores].[sales].[customers] WHERE first_name = 'Kasha' AND customer_id = 2;

SELECT * FROM [BikeStores].[sales].[customers] WHERE first_name = 'Debra';


-- Select * vs select field

CREATE INDEX idx_state ON BikeStores.sales.customers(state)

DROP INDEX idx_state ON BikeStores.sales.customers;

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SELECT customer_id, state FROM [BikeStores].[sales].[customers] WHERE state = 'NY';

SELECT * FROM [BikeStores].[sales].[customers] WHERE state = 'NY';
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


SELECT * FROM sales.customers;

SELECT * FROM sales.orders;

-- Exists Vs IN VS Join
SELECT * FROM sales.customers JOIN sales.orders ON sales.customers.customer_id = sales.orders.customer_id;

SELECT * FROM sales.customers WHERE sales.customers.customer_id IN (SELECT customer_id FROM sales.orders);

SELECT * FROM sales.customers WHERE EXISTS (SELECT customer_id FROM sales.orders WHERE sales.customers.customer_id = sales.orders.customer_id)


-- NOT Exists Vs NOT IN VS Join WITH NULL

SELECT * FROM sales.customers JOIN sales.orders ON sales.customers.customer_id = sales.orders.customer_id WHERE sales.customers.customer_id IS NULL;

SELECT * FROM sales.customers WHERE sales.customers.customer_id NOT IN (SELECT customer_id FROM sales.orders);

SELECT * FROM sales.customers WHERE NOT EXISTS (SELECT customer_id FROM sales.orders WHERE sales.customers.customer_id = sales.orders.customer_id);


SELECT * FROM sales.customers JOIN sales.orders ON sales.customers.customer_id = sales.orders.customer_id;

SELECT * FROM sales.customers JOIN sales.orders ON sales.customers.customer_id = sales.orders.customer_id;

-- Parameter Sniffing
CREATE PROCEDURE find_customer 
@city VARCHAR(50)
AS
	SELECT * FROM sales.customers WHERE city = @city;


DBCC FREEPROCCACHE()    -- Will clear plan cache
EXEC find_customer 'Campbell';

DBCC FREEPROCCACHE()    -- Will clear plan cache
EXEC find_customer 'Uniondale';

create index idx_name
on exa(name);

create table exa(
	id int,
	name varchar(300),
	city varchar(200),
	zipcode varchar(6)
)
insert into exa values (3,'sagar','visavadar','362130'), (3,'riyank','visavadar','362130'),(3,'priyanshu','dhainik','362130'),(3,'priyank','junagadh','362130');

select * from exa where name = 'riyank';

-- Dynamic

DECLARE @query NVARCHAR(MAX);
SET @query = N'SELECT * FROM sales.customers'
DECLARE
@phone int ;
SET @phone = 1;

IF @phone IS NOT NULL 
SET @query = @query + N' WHERE ' + 'customer_id = ' + cast(@phone as varchar(10));

EXEC SP_EXECUTESQL @query;
GO 100

DROP INDEX idx_order_id ON sales.orders;
CREATE INDEX idx_order_id ON sales.orders(order_id);

SELECT * from sales.orders WHERE order_id = 2;

SELECT * FROM sales.orders WHERE LTRIM(order_id) = 2;

DBCC FREEPROCCACHE
GO

SELECT * 
FROM sys.dm_exec_cached_plans AS cp 
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle)
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle);  
GO