use Database
go 

-- tables used

SELECT *
FROM [Warehouse]

--4 warehouses no orders

SELECT *
FROM [Orders]

--find out the percentage of total orders, and evaluation of each warehouse


SELECT 
CONCAT(w.state , ': ', w.warehouse_alias) Warehouse,
CONVERT(DECIMAL(10,2),
(CAST(COUNT(w.warehouse_alias) AS FLOAT)/9999)*100) AS [Percentage of Orders] ,
	CASE 
		WHEN ((CAST(COUNT(w.warehouse_alias) AS FLOAT)/9999)*100) < 5 THEN 'Less than 5%'
		WHEN ((CAST(COUNT(w.warehouse_alias) AS FLOAT)/9999)*100) < 20 THEN 'Less than 20%'
		WHEN ((CAST(COUNT(w.warehouse_alias) AS FLOAT)/9999)*100) < 30 THEN 'Less than 30%'
		WHEN ((CAST(COUNT(w.warehouse_alias) AS FLOAT)/9999)*100) > 30 THEN 'Over 30%'
		END AS [Evaluation]
FROM [Warehouse] W
FULL OUTER JOIN  [Orders] O
	ON w.warehouse_id = O.warehouse_id
WHERE o.order_id is not null
GROUP BY w.warehouse_alias, w.state
ORDER BY 2 DESC
 
