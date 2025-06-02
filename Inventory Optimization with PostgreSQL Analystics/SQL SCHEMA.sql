-- Create schema for the database
CREATE SCHEMA "Customer Satisfaction Supply Chain Optimazation"; 

SET search_path =  "Customer Satisfaction Supply Chain Optimazation";

-- Create product_data table
DROP TABLE IF EXISTS product_data;
CREATE TABLE IF NOT EXISTS product_data(
	product_id BIGINT,
	product_category VARCHAR(100),
	promotions VARCHAR(5)
);

-- create sales_data table
DROP TABLE IF EXISTS sales_data;
CREATE TABLE IF NOT EXISTS sales_data(
	product_id BIGINT,
	sales_date DATE,
	inventory_quantity INT,
	product_cost NUMERIC(5,2)
);

-- create external_factors
DROP TABLE IF EXISTS external_factors;
CREATE TABLE external_factors(
	sales_date DATE,
	GDP NUMERIC(10,2),
	inflation_rate FLOAT,
	seasonal_factor FLOAT
);


--- Load data into product_data table
COPY product_data(product_id, product_category, promotions)
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Customer Satisfaction Supply Chain Optimazation\Dataset\Product_Information.csv'
DELIMITERS ','
CSV HEADER;

--- Load data into sales_data table
COPY sales_data(product_id, sales_date, inventory_quantity, product_cost)
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Customer Satisfaction Supply Chain Optimazation\Dataset\Sales data.csv'
DELIMITERS ','
CSV HEADER;

-- Load data into external_factors table
COPY external_factors(sales_date, GDP, inflation_rate, seasonal_factor)
FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Customer Satisfaction Supply Chain Optimazation\Dataset\External_Factors.csv'
DELIMITERS ','
CSV HEADER;

-- Table inspections
SELECT * FROM product_data pd;
SELECT * FROM sales_data;
SELECT * FROM external_factors;

-- Check the style of date in the database
--SHOW datestyle;
-- change the style from MDY to DMY


SET datestyle = 'ISO, DMY';

SELECT count(*) FROM external_factors;