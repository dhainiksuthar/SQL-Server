/* Trigger */
USE BikeStores;
SELECT * FROM production.products;

DROP TABLE production.deleted_product_record;
SELECT * INTO production.deleted_product_record FROM production.products WHERE 1 = 2;
SELECT * FROM production.products

SET IDENTITY_INSERT production.deleted_product_record ON;
SET IDENTITY_INSERT production.deleted_product_record ON;


DROP TRIGGER production.deleted_product;
CREATE TRIGGER production.deleted_product ON production.products
AFTER DELETE
AS
BEGIN
	INSERT INTO production.deleted_product_record(product_id, product_name, brand_id, category_id, model_year, list_price) 
	SELECT * FROM deleted;
END

DELETE FROM production.products WHERE product_id = 2;

SELECT * FROM production.deleted_product_record;


-- Foreign Key
CREATE TABLE production.vendor_groups(
	group_id INT IDENTITY PRIMARY KEY,
	group_name VARCHAR(100) NOT NULL
);

CREATE TABLE production.vendors(
	vendor_id INT IDENTITY PRIMARY KEY,
	vendor_name VARCHAR(100) NOT NULL,
	group_id INT NOT NULL
	CONSTRAINT fk_vendors FOREIGN KEY(vendor_id)
	REFERENCES production.vendor_groups(group_id)
);

ALTER TABLE production.vendors
DROP CONSTRAINT fk_vendors;

ALTER TABLE production.vendors
ADD CONSTRAINT fk_vendors FOREIGN KEY(vendor_id)
						  REFERENCES production.vendor_groups(group_id);

-- List of all constraints
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME='vendor_groups';

-- Primary key

ALTER TABLE production.vendor_groups
DROP CONSTRAINT PK__vendor_g__D57795A0EF18E50C;


SELECT * FROM production.products WHERE brand_id = 8 ;

-- Cast
SELECT 1 + CAST(1 AS INT) AS result;

SELECT CAST(5.95 AS INT) result;

SELECT CAST(5.95 AS DEC(2, 1));

SELECT CEILING(25.25);

SELECT CHARINDEX('t', 'Customer') AS MatchPosition;

SELECT COALESCE(NULL, NULL, NULL, 'hii', NULL, 'hyi');

SELECT CONCAT_WS('..', 'www', 'W3Schools', 'com');

SELECT CONVERT(float, 25), CONVERT(INT, 25.55);

SELECT DATALENGTH('123 5 7 9');

SELECT DATEADD(month, 11, '2017/08/25') AS DateAdd;

SELECT DATEDIFF(MONTH, '2002-08-25',  '2017-08-25');

SELECT DATEFROMPARTS(2018, 2, 4);

SELECT DATENAME(YEAR, '2018-02-1');

SELECT DATEPART(year, '2017/08/25') AS DatePartInt;

SELECT DAY('2017-2-12');

SELECT DIFFERENCE('asdf', 'errerdf');    -- Return number 0 to 4 based on similarity

SELECT FLOOR(24.9), FLOOR(-24.5);

-- Full outer join
SELECT * FROM sales.orders FULL OUTER JOIN sales.customers ON sales.orders.customer_id = sales.customers.customer_id;

SELECT GETDATE();

-- To know transaction was started or not
SELECT @@TRANCOUNT AS OpenTransactions 

-- Transactions
BEGIN TRANSACTION
SELECT * FROM sales.staffs WHERE staff_id = 3;

UPDATE sales.staffs SET first_name = 'johndoe' WHERE staff_id = 3; 
SELECT @@TRANCOUNT AS OpenTransactions 
COMMIT TRANSACTION;

--Dynamic SQL
DECLARE @SQL VARCHAR(100)
DECLARE @Pid VARCHAR(50)

SET @Pid = '3';
SET @SQL = 'SELECT * FROM sales.staffs WHERE staff_id = ' + @Pid;

EXEC (@SQL);

SELECT LTRIM('     Simform') + ':' + CAST(LEN(LTRIM('   Simform')) as varchar)

SELECT RTRIM('Simform      ') + ':' + CAST(LEN(RTRIM('Simform     ')) AS VARCHAR)

SELECT TRIM('     Simform      ') + ':' + CAST(LEN(TRIM('     Simform     ')) AS VARCHAR)

SELECT NCHAR(65)

SELECT USER_NAME();

-- DDL Triggers
CREATE TABLE dbo.tablelog(
	loginid INT IDENTITY(1, 1) PRIMARY KEY,
	eventval XML NOT NULL,
	eventdate DATETIME NOT NULL,
	changedby SYSNAME NOT NULL
);

CREATE TRIGGER trgtablechanges ON DATABASE
FOR
	CREATE_TABLE,
	ALTER_TABLE,
	DROP_TABLE
AS
BEGIN
	INSERT INTO dbo.tablelog(eventval, eventdate, changedby)
					VALUES(EVENTDATA(), GETDATE(), USER);
END;

CREATE TABLE dbo.TestDDLTrigger(
    LogID int IDENTITY(1,1) PRIMARY KEY,
    TestedBy SYSNAME NOT NULL
);
DROP TABLE dbo.TestDDLTrigger;
SELECT * FROM dbo.tablelog;

DISABLE TRIGGER trgtablechanges ON DATABASE;

ENABLE TRIGGER trgtablechanges ON DATABASE;

--While Loop
DECLARE @a INT = 10;

WHILE @a < 30
	BEGIN
		PRINT(@a);
		SET @a = @a + 1;
		IF @a = 16 BREAK;
	END;

--Procedures
DROP PROC stafflist;
CREATE PROCEDURE stafflist
AS
BEGIN
	SELECT * FROM sales.staffs;
END;
EXEC stafflist;


ALTER PROC stafflist
AS
BEGIN
	SELECT * FROM sales.staffs ORDER BY first_name;
END;


CREATE PROCEDURE uspFindProducts(
    @min_list_price AS DECIMAL
    ,@max_list_price AS DECIMAL
)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM 
        production.products
    WHERE
        list_price >= @min_list_price AND
        list_price <= @max_list_price
    ORDER BY
        list_price;
END;

EXEC uspFindProducts 125, 10000;

-- Function
CREATE FUNCTION sales.returnorder(@order_id INT) RETURNS INT
AS
BEGIN
	DECLARE @n INT;
	SELECT TOP 1 @n = customer_id FROM sales.orders WHERE order_id = @order_id;
	RETURN @n;
END;

SELECT sales.returnorder(2);
SELECT * FROM sales.orders;


DECLARE @product_table TABLE(
	product_name VARCHAR NOT NULL,
	brand_id INT NOT NULL,
	list_price DEC(11,2) NOT NULL
);

SELECT product_name, brand_id, list_price INTO product_table FROM production.products;
SELECT * FROM product_table;


SELECT DB_NAME();

-- Merge
DROP TABLE source, target;
CREATE TABLE source(
	id INT,
	data_ TEXT);

CREATE TABLE target(
	id INT,
	data_ TEXT);

INSERT INTO source VALUES(1, 'dhainik'), (2, 'sagar');
INSERT INTO target VALUES(1, 'asdf'), (3, 'dev') ;
SELECT * FROM source;
SELECT * FROM target;

MERGE source USING target
ON source.id = target.id
WHEN MATCHED 
	THEN UPDATE SET source.data_ = target.data_
WHEN NOT MATCHED BY TARGET
	THEN INSERT VALUES(target.id, target.data_)
WHEN NOT MATCHED BY SOURCE
		THEN DELETE;


-- Pivot
SELECT * FROM production.products;
SELECT * FROM production.categories;

SELECT category_name, COUNT(product_id) 
FROM production.products AS p INNER JOIN production.categories AS c 
ON p.category_id = p.category_id
GROUP BY c.category_name;

SELECT * FROM (
	SELECT category_name, product_id
	FROM production.products AS p INNER JOIN production.categories AS c 
	ON p.category_id = p.category_id
) AS t 
PIVOT(
	COUNT(product_id)
	FOR category_name IN (
	[Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;


--Materialized View
CREATE OR ALTER VIEW product_master
AS
	SELECT product_id, product_name, brand_id, category_id, model_year 
	FROM production.products;

SELECT * FROM product_master;
UPDATE product_master SET product_name = 'dhhd11' WHERE product_id = 3;