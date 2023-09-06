--1. What are the top and least rented genres and what are their total sales?
WITH cte1 AS (
				SELECT
					c.name AS Genre,
					count(c2.customer_id) AS total_rent
				FROM category c 
				JOIN film_category fc 
				using(category_id)
				JOIN film f 
				using(film_id)
				JOIN inventory i 
				using(film_id)
				JOIN rental r 
				using(inventory_id)
				JOIN customer c2 
				using(customer_id)
				GROUP BY 1
				ORDER BY 2 DESC
				),
	cte2 AS (
				SELECT
					c.name AS genre,
					sum(p.amount) AS total_sales
				FROM category c 
				JOIN film_category fc 
				using(category_id)
				JOIN film f
				using(film_id)
				JOIN inventory i 
				using(film_id)
				JOIN rental r 
				using(inventory_id)
				JOIN payment p
				using(rental_id)
				GROUP BY 1
				ORDER BY 2 DESC
				)
SELECT
	cte1.genre,
	cte1.total_rent,
	cte2.total_sales
FROM
	cte1
JOIN cte2
		USING(genre)


--2. Can we know how many distinct users have rented each genre ?
SELECT
	c.name AS genre,
	count(DISTINCT c2.customer_id) AS total_rent
FROM
	category c
JOIN film_category fc
		USING(category_id)
JOIN film f
		USING(film_id)
JOIN inventory i
		USING(film_id)
JOIN rental r
		USING(inventory_id)
JOIN customer c2
		USING(customer_id)
GROUP BY
	1
ORDER BY
	2 DESC

--3. What is the average rental rate for each genre?
SELECT
	c.name AS genre,
	round(avg(f.rental_rate),2) AS avg_rental_rate
FROM
	category c
JOIN film_category fc
		USING(category_id)
JOIN film f
		USING(film_id)
GROUP BY
	1
ORDER BY
	2 DESC;

--4. How many rental films were returned late, early and on time?
WITH t1 AS (SELECT
				*,
				date_part('day',
				return_date - rental_date) AS date_difference
			FROM
				rental
			),
	 t2 AS (SELECT
				CASE
					WHEN rental_duration > date_difference THEN 'Returned early'
					WHEN rental_duration = date_difference THEN 'Returned On Time'
					ELSE 'Returned late'
					END AS Return_status
			FROM
				film
			JOIN inventory
					USING(film_id)
			JOIN t1
					USING(inventory_id)
			),
	t3 AS (SELECT
				Return_status,
				count(*) AS total
			FROM
				t2
			GROUP BY
				1
			ORDER BY
				2 DESC)
SELECT
	Return_status,
	total,
	concat((round(total /(SELECT sum(total) FROM t3)*100,0)),'%') AS total_pct
FROM
	t3
GROUP BY
	1,
	2
ORDER BY
	2 DESC;

--5. what are the total sales and customer base in each country where the DVD_rental industry is based?
SELECT
	country AS country,
	count(DISTINCT customer_id) AS customer_base,
	sum(amount) AS total_sales
FROM
	payment
JOIN customer
		USING(customer_id)
JOIN address
		USING(address_id)
JOIN city
		USING(city_id)
JOIN country
		USING (country_id)
GROUP BY
	1
ORDER BY
	2 DESC;

--6. who are the top 5 customers per total sales and their details?
SELECT
	concat(first_name,' ',last_name) AS full_name,
	email,
	address,
	phone,
	city,
	country,
	sum(amount)
FROM
	payment
JOIN customer
		USING(customer_id)
JOIN address
		USING(address_id)
JOIN city
		USING(city_id)
JOIN country
		USING(country_id)
GROUP BY
	1,
	2,
	3,
	4,
	5,
	6
ORDER BY
	7 DESC
LIMIT 5;


--7. What are the most-watched movie genres among families, specifically focusing on genres such as Animation, Children, Classics, Comedy, Family, and Music?

SELECT
	c.name AS genre,
	count(rental_id) AS total_no_of_movie
FROM
	category c
JOIN film_category fc
		USING (category_id)
JOIN film f
		USING(film_id)
JOIN inventory i
		USING(film_id)
JOIN rental r
		USING (inventory_id)
WHERE
	c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY
	1
ORDER BY
	2 DESC;


--8. Can you provide the details of customers who have not returned DVDs?
SELECT
	concat(first_name,' ',last_name) AS full_name,
	title,
	rental_date,
	return_date,
	email,
	address,
	phone,
	city,
	country
FROM
	film f
JOIN inventory i
		USING(film_id)
JOIN rental r
		USING(inventory_id)
JOIN customer c
		USING(customer_id)
JOIN address a
		USING (address_id)
JOIN city
		USING(city_id)
JOIN country c2
		USING (country_id)
WHERE
	return_date IS NULL
	

--9. In which months did each store process the highest total number of rental orders? 		
   SELECT
		EXTRACT(YEAR FROM r.rental_date) AS YEAR,
		EXTRACT(MONTH FROM r.rental_date) AS MONTH, 
		to_char(r.rental_date, 'Month') AS MONTH_NAME,
		sum(CASE WHEN store_id = 1 THEN 1 ELSE 0 END) AS store_1,
		sum(CASE WHEN store_id = 2 THEN 1 ELSE 0 END) AS store_2
   FROM rental r 
   JOIN inventory i  
   using(inventory_id)
   GROUP BY 
   		1,
   		2,
   		3
   ORDER BY 
   		1,
   		2 

