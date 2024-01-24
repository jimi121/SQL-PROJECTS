-- Q1. Who is the senior most employee based on job title?
SELECT
	*
FROM
	employee
ORDER BY
	levels DESC
LIMIT 1;

-- Q2. Which countries have the most Invoices?
SELECT
	billing_country,
	count(*) AS no_invoice
FROM
	invoice
GROUP BY
	billing_country
ORDER BY
	no_invoice DESC;

-- Q3. What are top 3 values of total invoice?
SELECT *
FROM invoice
ORDER BY total DESC 
LIMIT 3;

-- Q4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--     Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.
SELECT
	billing_country ,
	billing_city,
	sum(total) AS total
FROM
	invoice
GROUP BY
	billing_city,
	billing_country
ORDER BY
	total DESC
LIMIT 1;

-- Q5. Who is the best customer? The customer who has spent the most money will be declared the best customer. 
--     Write a query that returns the person who has spent the most money.
SELECT
	concat(c.first_name,c.last_name) AS customer_name,
	sum(i.total) AS total_money
FROM
	customer c
JOIN invoice i 
ON
	c.customer_id = i.customer_id
GROUP BY
	first_name,
	last_name,
	total
ORDER BY
	total DESC
LIMIT 1;

/*-- Q6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. 
 Return your list ordered alphabetically by email starting with A*/
SELECT
	   c.email,
	   c.first_name,
	   c.last_name,
	   g.name AS genre_name
FROM
	customer c
JOIN invoice i
		USING(customer_id)
JOIN invoice_line il
		USING(invoice_id)
JOIN track t
		USING(track_id)
JOIN genre g
		USING(genre_id)
WHERE
	g.name = 'Rock'
GROUP BY
	c.email,
	c.first_name,
	c.last_name,
	g.name
ORDER BY
	c.email ASC;
	
-- Q7. Let's invite the artists who have written the most rock music in our dataset. 
--     Write a query that returns the Artist name and total track count of the top 10 rock bands.
SELECT
	   a.name AS artist_name,
	   g.name AS genre_name,
	   count(*) AS track_count
FROM
	artist a
JOIN album a2
		USING (artist_id)
JOIN track t
		USING (album_id)
JOIN genre g
		USING (genre_id)
WHERE
	g.name = 'Rock'
GROUP BY
	a.name,
	g.name
ORDER BY
	3 DESC
LIMIT 10;
	
-- Q8. Return all the track names that have a song length longer than the average song length. 
--     Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
SELECT
	name,
	milliseconds
FROM
	track
WHERE
	milliseconds > (
	SELECT
		avg(milliseconds)
	FROM
		track)
ORDER BY
	2 DESC
LIMIT 10;

-- Q9. Find how much amount spent by each customer on artists. Write a query to return the customer name, artist name, and total spent.
SELECT
	  concat(c.first_name, last_name) AS customer_name,
	  a2.name AS artist_name,
	  sum((il.unit_price * il.quantity)) AS total_price
FROM
	customer c
JOIN invoice i
		USING (customer_id)
JOIN invoice_line il
		USING (invoice_id)
JOIN track t
		USING (track_id)
JOIN album a
		USING (album_id)
JOIN artist a2
		USING(artist_id)
GROUP BY
	c.first_name,
	c.last_name,
	a2.name,
	il.unit_price,
	il.quantity
ORDER BY
	3 DESC
LIMIT 10;


/* Q10. We want to find out the most popular music Genre for each country. 
        We determine the most popular genre as the genre with the highest amount of purchases. 
        Write a query that returns each country along with the top Genre. 
		For countries where the maximum number of purchases is shared return all Genres.*/
WITH cte AS (
SELECT
	country,
	   top_genre,
	   total_purchase,
	   ROW_NUMBER () OVER (PARTITION BY country ORDER BY total_purchase DESC) AS row_num
FROM
	(
	SELECT
		i.billing_country AS country,
		g.name AS top_genre,
		count(il.quantity) AS total_purchase
	FROM
		invoice i
	JOIN invoice_line il
			USING (invoice_id)
	JOIN track t
			USING (track_id)
	JOIN genre g
			USING (genre_id)
	GROUP BY
		i.billing_country,
		g.name,
		il.quantity
	ORDER BY
		3 DESC ) x
		)
SELECT
	country,
	top_genre,
	total_purchase
FROM
	cte
WHERE
	row_num = 1;


/*Q11. Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount.*/
WITH top_customer AS (
SELECT
	country,
	   customer_name,
	   total_price,
	   ROW_NUMBER () OVER(PARTITION BY country ORDER BY total_price DESC) AS row_num
FROM
	(
	SELECT
		c.country,
		concat(c.first_name, c.last_name) AS customer_name,
		sum(il.unit_price * il.quantity) AS total_price
	FROM
		customer c
	JOIN invoice i
			USING(customer_id)
	JOIN invoice_line il
			USING (invoice_id)
	GROUP BY
		c.country,
		c.first_name,
		c.last_name,
		il.unit_price,
		il.quantity
	ORDER BY
		total_price DESC )x
		)
SELECT
	country,
	customer_name,
	total_price
FROM
	top_customer
WHERE
	row_num = 1;


-- Q12. Who are the most popular artists?
SELECT
	   a.name AS artist_name,
	   sum(il.quantity) AS no_of_records_produced
FROM
	invoice_line il
JOIN track t
		USING (track_id)
JOIN album a2
		USING (album_id)
JOIN artist a
		USING (artist_id)
GROUP BY
	a.name,
	il.quantity
ORDER BY
	2 DESC
LIMIT 10;

-- Q13. What is the most popular song?
SELECT
	   t.name AS song_name,
	   sum(il.quantity) AS total_quantities
FROM
	invoice_line il
JOIN track t
		USING (track_id)
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT 10;

-- Q14. What are the average prices of different types of music?
SELECT
	genre,
	concat('$',' ', round(avg(total_purchase))) AS avg_purchase
FROM
	(
	SELECT
		g.name AS genre,
		sum(total) AS Total_purchase
	FROM
		invoice i
	JOIN invoice_line il
			USING (invoice_id)
	JOIN track
			USING (track_id)
	JOIN genre g
			USING (genre_id)
	GROUP BY
		g.name)x
GROUP BY
	x.genre
ORDER BY
	avg(total_purchase) DESC;


-- Q15. What are the most popular countries for music purchases?
SELECT
	c.country,
	   sum(il.quantity) AS total_purchase
FROM
	customer c
JOIN invoice i
		USING (customer_id)
JOIN invoice_line il
		USING (invoice_id)
GROUP BY
	1
ORDER BY
	2 DESC;
