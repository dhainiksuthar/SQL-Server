DECLARE @json NVARCHAR(MAX);
SET @json = '{
			"info" :{
					"address" : [
								{"town": "Belgrade"},
								{"town": "Paris"},
								{"town": "Madrid"}
										]
					}
			}';

SET @json = JSON_MODIFY(@json, '$.info.address[1].town', 'London');

SELECT @json;


-- Example - 2
DECLARE @json NVARCHAR(MAX);
SET @json = '[
				{"id":2, "info":{"name":"Dhainik", "surname":"Suthar"}, "age":20},
				{"id":5, "info":{"name":"Sagar", "surname":"Patel"}, "age":20}
]' 

SELECT * FROM OPENJSON(@json)
	WITH(
		id INT '$.id',
		firstname NVARCHAR(50) '$.info.name',
		lastname NVARCHAR(50) '$.info.surname',
		age INT '$.age'
	);

-- Example - 3
DECLARE @json NVARCHAR(MAX);
SET @json = '[
				{"id":2, "info":{"name":"Dhainik", "surname":"Suthar"}, "age":20, "skills":["SQL", "Python"]},
				{"id":5, "info":{"name":"Sagar", "surname":"Patel"}, "age":20}
]';
SELECT * FROM OPENJSON(@json)
	WITH(
		id INT '$.id',
		firstname NVARCHAR(50) '$.info.name',
		lastname NVARCHAR(50) '$.info.surname',
		age INT '$.age',
		skills NVARCHAR(MAX) '$.skills' AS JSON
	) OUTER APPLY OPENJSON(skills)
  WITH (skill NVARCHAR(8) '$');

SELECT id , firstname AS "info.name", lastname AS "info.surname", age FROM people FOR json PATH;





-- Working with array in MSSQL

--Table
CREATE TABLE arr(
	id INT,
	brand_id INT
);
INSERT INTO arr VALUES(1, 8), (2, 9);
SELECT * FROM arr;

SELECT * FROM BikeStores.dbo.product_table WHERE brand_id IN (SELECT brand_id FROM arr);

-- STRING_SPLIT()

DECLARE @brand_ids VARCHAR(50);
SET @brand_ids = '8,9';
SELECT VALUE FROM STRING_SPLIT('8,9' , ',');

SELECT * FROM BikeStores.dbo.product_table WHERE brand_id IN (SELECT VALUE FROM STRING_SPLIT(@brand_ids, ','));

