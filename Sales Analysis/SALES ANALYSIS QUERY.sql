SELECT * FROM web_events;
SELECT * FROM sales_reps;
SELECT * FROM orders;
SELECT * FROM accounts;
SELECT * FROM region;

/*1. Provide table that shows the sales representatives' regions and their associated accounts specifically for the Midwest region?*/
SELECT
	   sr.name AS rep_name, 
	   r.name AS region, 
	   a.name AS account_name
FROM
	sales_reps sr
JOIN region r 
ON
	sr.region_id = r.id
JOIN accounts a 
ON
	sr.id = a.sales_rep_id
WHERE r.name = 'Midwest'
ORDER BY a.name ASC;


/*2.Can you provide a table that displays the regions for each sales representative along with their associated accounts, 
 specifically for sales representatives whose first names start with 'S' and who are located in the Midwest region?*/
SELECT
	sr.name AS rep_name,
	r.name AS region,
	a.name AS account_name
FROM
	sales_reps sr
JOIN region r 
ON
	sr.region_id = r.id
JOIN accounts a 
ON
	a.sales_rep_id = sr.id
WHERE
	r.name = 'Midwest'
	AND sr.name LIKE 'S%'
ORDER BY
	a.name ASC;

	
/*3. Provide a table that provides the region for each sales_rep along with their associated accounts.
where the sales rep has a last name starting with K and in the Midwest region.*/
SELECT
	sr.name AS rep_name,
	r.name AS region,
	a.name AS account_name
FROM
	sales_reps sr
JOIN region r 
ON
	sr.region_id = r.id
JOIN accounts a 
ON
	a.sales_rep_id = sr.id
WHERE
	r.name = 'Midwest'
	AND split_part(sr."name", ' ', 2) LIKE 'K%' 
ORDER BY
	a.name ASC;
	
/*4. Provide the top 10 name for each region for every order, as well as the account name and the unit price they paid for the order when the standard order quantity exceeds 100.*/

SELECT
	r.name AS region,
	a.name AS account_name,
	(o.total_amt_usd / o.total) AS unit_price
FROM
	region r
JOIN sales_reps sr 
	ON
	sr.region_id = r.id
JOIN accounts a 
	ON
	sr.id = a.sales_rep_id
JOIN orders o ON
	o.account_id = a.id
WHERE
	o.standard_qty > 100
LIMIT 10;


/*5. Provide the name for each region for every order, as well as the account name and the unit price they paid for the order when the standard order quantity exceeds 100
 and the poster order quantity exceeds 50*/

	
SELECT
	r.name AS region,
	a.name AS account_name,
	(o.total_amt_usd / o.total) AS unit_price
FROM
	region r
JOIN sales_reps sr 
	ON
	sr.region_id = r.id
JOIN accounts a 
	ON
	sr.id = a.sales_rep_id
JOIN orders o ON
	o.account_id = a.id
WHERE
	o.standard_qty > 100
AND 
	o.poster_qty > 50
ORDER BY 3 ASC;


/*6. For each account, determine the average amount of each type of paper they purchased across their orders.*/
	
SELECT
	a.name AS account_name,
	avg(o.standard_qty) AS avg_of_standard_qty,
	avg(o.gloss_qty) AS avg_gloss_qty,
	avg(o.poster_qty) AS avg_poster_qty,
	avg(o.total) AS avg_total_quantity
FROM
	accounts a
JOIN orders o 
ON
	a.id = o.account_id
GROUP BY
	a."name"
ORDER BY 
	avg_total_quantity DESC
LIMIT 10;

/*7. For each account, determine the average amount spent per order on each paper type. */
	
SELECT
	a.name AS account_name,
	avg(o.standard_amt_usd) AS avg_of_standard_amt,
	avg(o.gloss_amt_usd) AS avg_gloss_amt,
	avg(o.poster_amt_usd) AS avg_poster_amt,
	avg(o.total_amt_usd) AS average_total_amount
FROM
	accounts a
JOIN orders o 
ON
	a.id = o.account_id
GROUP BY
	a."name"
ORDER BY
	average_total_amount DESC
LIMIT 10;

/*8. Determine the number of times a particular channel was used in the web_events table for each sales rep. */
SELECT
	sr.name AS rep_name,
	count(we.channel) AS no_of_channel_used
FROM
	sales_reps sr
JOIN accounts a 
ON
	sr.id = a.sales_rep_id
JOIN web_events we 
ON
	a.id = we.account_id
GROUP BY
	sr."name"
ORDER BY
	2 DESC;

/*9. What is total amount used for each year ?*/

SELECT
	EXTRACT(YEAR FROM occurred_at) AS YEAR,
	SUM(total_amt_usd) AS total_usd
FROM
	orders
GROUP BY
	YEAR
ORDER BY
	total_usd ASC

/*10. which month of the year did sales occur for 2017 and 2013 ?*/
SELECT
	EXTRACT(YEAR FROM occurred_at) AS YEAR,
	EXTRACT(MONTH FROM occurred_at) AS MONTH,
	to_char(occurred_at, 'Month') AS MONTH_NAME,
	SUM(total_amt_usd) AS total_usd
FROM
	orders
WHERE
	EXTRACT(YEAR FROM occurred_at) = 2013
	OR EXTRACT(YEAR FROM occurred_at)= 2017
GROUP BY
	YEAR,
	MONTH,
	MONTH_NAME
ORDER BY
	YEAR
	
	
/*11. Which day of the month did sales occur in 2017 ?*/	

SELECT
	EXTRACT(YEAR FROM occurred_at) AS YEAR,
	EXTRACT(MONTH FROM occurred_at) AS MONTH,
	to_char(occurred_at, 'Month') AS MONTH_NAME,
	EXTRACT(DAY FROM occurred_at) AS DAY,
	to_char(occurred_at, 'Day') AS DAY_NAME,
	SUM(total_amt_usd) AS total_usd
FROM
	orders
WHERE
	EXTRACT(YEAR FROM occurred_at)= 2017
GROUP BY
	YEAR,
	MONTH,
	DAY,
	MONTH_NAME,
	DAY_NAME
ORDER BY
	total_usd ASC


/*12. Compare the sales of january 1st for every year ?*/
	
SELECT
	EXTRACT(YEAR FROM occurred_at) AS YEAR,
	concat(to_char(occurred_at, 'Month'),' ',EXTRACT(DAY FROM occurred_at)) AS MONTH,
	to_char(occurred_at, 'Day') AS DAY_NAME,
	SUM(total_amt_usd) AS total_usd
FROM
	orders
WHERE 
	EXTRACT(MONTH FROM occurred_at)= 1 
	AND EXTRACT(DAY FROM occurred_at)= 1
GROUP BY
	YEAR,
	MONTH,
	DAY_NAME
ORDER BY
	total_usd ASC
	
	
/*13. what is the parcentage of growth in each year ?*/	
WITH CTE_GROWTH AS 
(
	SELECT
		EXTRACT(YEAR FROM occurred_at) AS YEAR,
		concat(to_char(occurred_at, 'Month'),' ',EXTRACT(DAY FROM occurred_at)) AS MONTH,
		to_char(occurred_at, 'Day') AS DAY_NAME,
		SUM(total_amt_usd) AS total_usd
	FROM
		orders
	WHERE
		EXTRACT(MONTH FROM occurred_at)= 1
		AND EXTRACT(DAY FROM occurred_at)= 1
	GROUP BY
		YEAR,
		MONTH,
		DAY_NAME
	ORDER BY
		total_usd ASC
	) 
SELECT
	YEAR,
	MONTH,
	DAY_NAME,
	total_usd,
	total_usd - LAG(total_usd) OVER (ORDER BY YEAR ASC) AS growth,
	round((total_usd - LAG (total_usd) OVER (ORDER BY YEAR ASC))/ LAG (total_usd) OVER (ORDER BY YEAR ASC)* 100,1) AS percentage_growth
FROM
	CTE_GROWTH


/*14. In which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/

SELECT
	a.name AS account_name,
	EXTRACT(YEAR FROM o.occurred_at) AS YEAR,
	to_char(occurred_at, 'Month') AS MONTH,
	SUM(o.gloss_amt_usd) AS gloss_total_usd
FROM
	accounts a
JOIN orders o ON
	a.id = o.account_id
WHERE
	a.name = 'Walmart'
GROUP BY
	account_name,
	YEAR,
	MONTH
ORDER BY
	gloss_total_usd DESC
LIMIT 1

/* 15. What iS the total amount OF paper that has been sold ?*/
SELECT 
	sum(standard_qty) AS total_standard_quantity,
	sum(gloss_qty) AS total_gloss_quantity,
	sum(poster_qty) AS total_poster_quantity
FROM
	orders 
	