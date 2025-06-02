SET search_path =  "Customer Satisfaction Supply Chain Optimazation";

-- DATA EXPLORATION
-- Table Inspections
SELECT * FROM product_data pd;
SELECT * FROM sales_data sd;
SELECT * FROM external_factors ef;

-- UNDERSTANDING THE STRUCTURE OF THE DATASETS
-- external_factors structure 
SELECT 
	column_name, 
	data_type
FROM 
	information_schema.columns
WHERE 
	table_schema = 'Customer Satisfaction Supply Chain Optimazation'
	AND table_name = 'external_factors';

-- product_data structure
SELECT 
	column_name, 
	data_type
FROM 
	information_schema.columns
WHERE 
	table_schema = 'Customer Satisfaction Supply Chain Optimazation'
	AND table_name = 'product_data';

-- sales_data structure
SELECT 
	column_name, 
	data_type
FROM 
	information_schema.columns
WHERE 
	table_schema = 'Customer Satisfaction Supply Chain Optimazation'
	AND table_name = 'sales_data';

-- DATA CLEANING
-- Create a custom ENUM type for promotions in product_data table
CREATE TYPE promotion_type AS ENUM('Yes', 'No');
--change the data type of promotions to promotion_type
ALTER TABLE product_data
ALTER COLUMN promotions
TYPE promotion_type
USING promotions::promotion_type;

-- Identify missing values using `IS NULL` or `COALESCE` functions.
-- external_factor
SELECT 
    SUM(CASE WHEN Sales_Date IS NULL THEN 1 ELSE 0 END) AS missing_sales_date,
    SUM(CASE WHEN GDP IS NULL THEN 1 ELSE 0 END) AS missing_gdp,
    SUM(CASE WHEN Inflation_Rate IS NULL THEN 1 ELSE 0 END) AS missing_inflation_rate,
    SUM(CASE WHEN Seasonal_Factor IS NULL THEN 1 ELSE 0 END) AS missing_seasonal_factor
FROM external_factors;

-- Product Data
SELECT
	COUNT(*) FILTER (WHERE product_id IS NULL) AS missing_product_id,
	COUNT(*) FILTER (WHERE product_category IS NULL) AS missing_product_category,
	COUNT(*) FILTER (WHERE promotions IS NULL) AS missing_promotions
FROM product_data;

-- sales_data
SELECT
	COUNT(*) FILTER (WHERE product_id IS NULL) AS missing_product_id,
	COUNT(*) FILTER (WHERE sales_date IS NULL) AS missing_sales_date,
	COUNT(*) FILTER (WHERE inventory_quantity IS NULL) AS missing_inventory_quantity,
	COUNT(*) FILTER (WHERE product_cost IS NULL) AS missing_product_cost
FROM sales_data;

-- Dealing with duplicates for external_facctors and Products_data
-- external factor

--DELETE FROM external_factors e1
--USING (
--		SELECT 
--			sales_date, 
--			MIN(ctid) AS min_ctid
--		FROM external_factors
--		GROUP BY sales_date
--	) e2
--WHERE e1.sales_date = e2.sales_date AND e1.ctid != e2.min_ctid;

WITH duplicate AS (
	SELECT 
	    ctid,
	    ROW_NUMBER() OVER (PARTITION BY sales_date ORDER BY ctid) AS rn
  	FROM external_factors
)
DELETE FROM external_factors
WHERE ctid IN (SELECT ctid FROM duplicate WHERE rn > 1);

SELECT COUNT(*) FROM external_factors;

-- Product Data

--DELETE FROM product_data p1
--USING (
--SELECT product_id, MIN(ctid) AS min_ctid
--FROM product_data
--GROUP BY product_id
--) p2
--WHERE p1.product_id = p2.product_id AND p1.ctid != p2.min_ctid;

WITH duplicate AS (
	SELECT 
		ctid,
		ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY ctid) AS rn
	FROM product_data pd 
)
DELETE FROM product_data
WHERE ctid IN (SELECT ctid FROM duplicate WHERE rn > 1);

SELECT COUNT(*) FROM product_data pd;

-- DATA INTREGATION
-- Combine relevant datasets using SQL joins (`INNER JOIN`, `LEFT JOIN`, etc.).
-- Integrate `External_Factors`, `Product_data`, and `Sales_data` to create a unified dataset for analysis.

--  sales_data and product_data view first 

CREATE VIEW sales_product_data AS
SELECT 
	sd.product_id,
	sd.sales_date,
	sd.inventory_quantity,
	sd.product_cost,
	pd.product_category,
	pd.promotions
FROM sales_data sd
JOIN  product_data pd
ON sd.product_id = pd.product_id;

SELECT * FROM sales_product_data

-- Inventory Data View 

CREATE VIEW inventory_data AS 
SELECT 
	sp.product_id,
	sp.sales_date,
	sp.inventory_quantity,
	sp.product_cost,
	sp.product_category,
	sp.promotions,
	ef.gdp,
	ef.inflation_rate,
	ef.seasonal_factor
FROM sales_product_data sp
LEFT JOIN external_factors ef
ON sp.sales_date = ef.sales_date;

-- Describe view structure
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'Customer Satisfaction Supply Chain Optimazation'
AND table_name = 'inventory_data';

-- DESCRIPTIVE ANALYSIS
-- Basic Statistics:
-- Average sales (calculated as the product of "Inventory Quantity" and "Product Cost").
SELECT 
	id.product_id,
	ROUND(AVG(id.inventory_quantity * id.product_cost)) AS avg_sales
FROM inventory_data id
GROUP BY id.product_id 
ORDER BY avg_sales DESC;

-- Median stock levels (i.e., "Inventory Quantity").
SELECT
	id.product_id,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY id.inventory_quantity) AS median_stock
FROM inventory_data id 
GROUP BY id.product_id;

-- Product performance metrics (total sales per product).
SELECT 
	id.product_id,
	ROUND(SUM(id.inventory_quantity * id.product_cost)) AS total_sales
FROM inventory_data id 
GROUP BY id.product_id
ORDER BY total_sales DESC;

-- Identify high-demand products based on average sales
-- We'll consider the top 5% of products in terms of average sales as high-demand products

WITH product_avg_sales AS (
SELECT product_id, AVG(inventory_quantity) AS avg_sales
FROM inventory_data
GROUP BY product_id
),
threshold AS (
SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY avg_sales) AS threshold_value
FROM product_avg_sales
),
high_demand_products AS (
SELECT pas.product_id
FROM product_avg_sales pas, threshold t
WHERE pas.avg_sales > t.threshold_value
)
-- Calculate stockout frequency for high-demand products
SELECT s.product_id,
COUNT(*) AS stockout_frequency
FROM inventory_data s
WHERE s.product_id IN (SELECT product_id FROM high_demand_products)
AND s.inventory_quantity = 0
GROUP BY s.product_id;

-- OR 
--WITH high_demand_products AS (
--SELECT 
--	product_id, 
--	round(avg_unit::numeric,2) AS threshold_value
--FROM (
--SELECT 
--	id.product_id,
--	cume_dist() over(ORDER BY (AVG(id.inventory_quantity)) DESC) AS avg_unit
--FROM inventory_data id 
--GROUP BY id.product_id) t
--WHERE avg_unit <= 0.05
--)
---- Calculate stockout frequency for high-demand products
--SELECT s.product_id,
--COUNT(*) AS stockout_frequency
--FROM inventory_data s
--WHERE s.product_id IN (SELECT product_id FROM high_demand_products)
--AND s.inventory_quantity = 0
--GROUP BY s.product_id;


-- INFLUENCE OF EXTERNAL FACTORS
-- GDP Influence-  the overall economic health and growth of a country.
SELECT 
	id.product_id,
	AVG(CASE WHEN gdp > 0 THEN inventory_quantity ELSE NULL END) AS avg_sales_positive_gdp,
	AVG(CASE WHEN gdp <= 0 THEN inventory_quantity ELSE NULL END) AS avg_sales_negative_gdp
FROM inventory_data id 
GROUP BY id.product_id 
HAVING AVG(CASE WHEN gdp > 0 THEN inventory_quantity ELSE NULL END) IS NOT NULL;

-- Inflation Influence
SELECT 
	id.product_id,
	AVG(CASE WHEN id.inflation_rate > 0 THEN inventory_quantity ELSE NULL END) AS avg_sales_positive_inflation,
	AVG(CASE WHEN inflation_rate <= 0 THEN inventory_quantity ELSE NULL END) AS avg_sales_negative_inflation
FROM inventory_data id
GROUP BY id.product_id 
HAVING AVG(CASE WHEN id.inflation_rate > 0 THEN inventory_quantity ELSE NULL END) IS NOT NULL;

-- OPTIMIZING INVENTORY
-- Define an SQL query to compute the Lead Time Demand, Safety Stock, and Reorder Point
WITH cte1 AS (
	SELECT 
		id.product_id,
		id.sales_date,
		id.inventory_quantity * id.product_cost AS daily_sales,
		AVG(id.inventory_quantity * id.product_cost) OVER (PARTITION BY product_id ORDER BY id.sales_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_sales,
		power(id.inventory_quantity * id.product_cost - AVG(id.inventory_quantity * id.product_cost) OVER (PARTITION BY product_id ORDER BY id.sales_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS squared_diff
	FROM inventory_data id 	
),
cte2 AS (
	SELECT 
		product_id,
		rolling_avg_sales,
		AVG(squared_diff) OVER (PARTITION BY product_id ORDER BY sales_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_variance
	FROM cte1
),
inventory_calculations AS (
	SELECT 
		product_id,
		AVG(rolling_avg_sales) AS avg_rolling_sales,
		AVG(rolling_variance) AS avg_rolling_variance
	FROM cte2
	GROUP BY product_id
)
SELECT 
	product_id,
	round(avg_rolling_sales * 7,2) AS lead_time_deman,-- Assuming a lead time of 7 days
	round(1.645 * SQRT(avg_rolling_variance * 7),2) AS safety_stock,-- Using Z value for 95% service LEVEL
	round((avg_rolling_sales * 7) + (1.645 * (avg_rolling_variance * 7)),2) AS reorder_point
FROM inventory_calculations;

-- Automate the Calculate of Reorder points when new rows are added to the inventory table to ensure optimal inventory

-- Step 1: Create inventory optimization table (if not already present)
DROP TABLE IF EXISTS inventory_optimization;
CREATE TABLE IF NOT EXISTS inventory_optimization(
	product_id int PRIMARY KEY,
	reorder_point NUMERIC
);

-- Step 2: Create the Stored Procedure to Recalculate Reorder Point
CREATE OR REPLACE PROCEDURE recalculate_reorder_point(p_product_id int)
LANGUAGE plpgsql
AS $$
DECLARE
	p_avg_rolling_sales   NUMERIC;
	p_avg_rolling_variance NUMERIC;
	p_lead_time_demand    NUMERIC;
	p_safety_stock        NUMERIC;
	new_reorder_point   NUMERIC;
BEGIN 
	WITH cte1 AS (
		SELECT 
			id.product_id,
			id.sales_date,
			id.inventory_quantity * id.product_cost AS daily_sales,
			AVG(id.inventory_quantity * id.product_cost) OVER (PARTITION BY product_id ORDER BY id.sales_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_sales,
			power(id.inventory_quantity * id.product_cost - AVG(id.inventory_quantity * id.product_cost) OVER (PARTITION BY product_id ORDER BY id.sales_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS squared_diff
		FROM inventory_data id 	
	),
cte2 AS (
		SELECT 
			product_id,
			rolling_avg_sales,
			AVG(squared_diff) OVER (PARTITION BY product_id ORDER BY sales_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_variance
		FROM cte1
	),
 -- Compute 7-day rolling average sales and variance for this product
inventory_calculations AS (
		SELECT 
			product_id,
			AVG(rolling_avg_sales) AS avg_rolling_sales,
			AVG(rolling_variance) AS avg_rolling_variance
		FROM cte2
		GROUP BY product_id
	),
-- Calculate lead-time demand & safety stock for 95% service level
final_inventory_calculation AS (
SELECT 
	product_id,
	avg_rolling_sales,
	avg_rolling_variance,
	round(avg_rolling_sales * 7,2) AS lead_time_demand,-- Assuming a lead time of 7 days
	round(1.645 * SQRT(avg_rolling_variance * 7),2) AS safety_stock,-- Using Z value for 95% service LEVEL
	round((avg_rolling_sales * 7) + (1.645 * (avg_rolling_variance * 7)),2) AS reorder_point
FROM inventory_calculations
WHERE product_id = p_product_id
	)

SELECT
	avg_rolling_sales,
	avg_rolling_variance,
	lead_time_demand,
	safety_stock,
	reorder_point
INTO
	p_avg_rolling_sales,
	p_avg_rolling_variance,
	p_lead_time_demand,
	p_safety_stock,
	new_reorder_point
FROM
	final_inventory_calculation;
-- Upsert into optimization table
INSERT INTO inventory_optimization(product_id, reorder_point)
VALUES (p_product_id, new_reorder_point)
ON CONFLICT (product_id) DO UPDATE SET reorder_point = EXCLUDED.reorder_point;
END;
$$;

-- Testying the procedure function
CALL recalculate_reorder_point(1019);
CALL recalculate_reorder_point(1029);
CALL recalculate_reorder_point(1036);
CALL recalculate_reorder_point(104);
CALL recalculate_reorder_point(106);
CALL recalculate_reorder_point(103);

-- checking the table for inventory_optimization
SELECT * FROM inventory_optimization io;

-- Step 3: make inventory_data a permanent table
CREATE TABLE inventory_table AS SELECT * FROM inventory_data;

-- Step 4: Create the Trigger function
CREATE OR REPLACE FUNCTION after_insert_inventory_table()
RETURNS TRIGGER AS $$
BEGIN 
	PERFORM recalculate_reorder_point(NEW.product_id);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- step 5: create trigger 
CREATE TRIGGER after_insert_into_table
AFTER INSERT ON inventory_table
FOR EACH ROW 
EXECUTE FUNCTION after_insert_inventory_table();

-- Overstocking and Understocking
-- Query to identify overstocked and understocked products
WITH rolling_sales AS (
SELECT
	product_id,
	sales_date,
	AVG(inventory_quantity * product_cost) OVER (PARTITION BY product_id
ORDER BY
	sales_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_sales
FROM
	inventory_table
),
stockout_days AS (
SELECT
	product_id,
	COUNT(*) AS stockout_days
FROM
	inventory_table
WHERE
	inventory_quantity = 0
GROUP BY
	product_id
)
SELECT
	f.product_id,
	AVG(f.inventory_quantity * f.product_cost) AS avg_inventory_value,
	AVG(rs.rolling_avg_sales) AS avg_rolling_sales,
	COALESCE(sd.stockout_days,
	0) AS stockout_days
FROM
	inventory_table f
JOIN rolling_sales rs ON
	f.product_id = rs.product_id
	AND f.sales_date = rs.sales_date
LEFT JOIN stockout_days sd ON
	f.product_id = sd.product_id
GROUP BY
	f.product_id,
	sd.stockout_days;


-- MONITOR AND ADJUST
-- Monitor inventory levels
DROP FUNCTION monitor_inventory_levels();
CREATE OR REPLACE FUNCTION monitor_inventory_levels()
RETURNS TABLE (p_product_id BIGINT, avg_inventory NUMERIC) AS $$
BEGIN
	RETURN QUERY
	SELECT
		product_id,
		AVG(inventory_quantity) AS avg_inventory
	FROM
		inventory_table
	GROUP BY
		product_id
	ORDER BY
		avg_inventory DESC;
END;
$$ LANGUAGE plpgsql;
-- call out the function
SELECT * FROM monitor_inventory_levels();

-- Monitor Sales Trends
DROP FUNCTION MonitorSalesTrends();
CREATE OR REPLACE FUNCTION MonitorSalesTrends()
RETURNS TABLE (p_product_id BIGINT, p_sales_date DATE, rolling_avg_sales NUMERIC) AS $$
BEGIN 
	RETURN query
	SELECT 
		product_id, 
		sales_date,
		AVG(inventory_quantity * product_cost) OVER (PARTITION BY product_id ORDER BY sales_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_sales
	FROM inventory_table
	ORDER BY product_id, sales_date;
END;
$$ LANGUAGE plpgsql;
-- call out the function
SELECT * FROM MonitorSalesTrends();


-- Monitor Stockout Frequencies
DROP FUNCTION monitor_stockouts();
CREATE OR REPLACE FUNCTION monitor_stockouts()
RETURNS TABLE (P_product_id BIGINT, stockout_days BIGINT) AS $$
BEGIN
	RETURN QUERY
	SELECT 
		product_id, 
		COUNT(*) AS stockout_days
	FROM inventory_table
	WHERE inventory_quantity = 0
	GROUP BY product_id
	ORDER BY stockout_days DESC;
END;
$$ LANGUAGE plpgsql;
-- call out the function
SELECT * FROM monitor_stockouts();






