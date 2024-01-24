#### Q1. Who is the senior most employee based on job title?
```sql
SELECT
	*
FROM
	employee
ORDER BY
	levels DESC
LIMIT 1;
```

### Result:
|employee_id|last_name|first_name|title|reports_to|levels|birth_date|hire_date|address|city|state|country|postal_code|phone|fax|email|
|-----------|---------|----------|-----|----------|------|----------|---------|-------|----|-----|-------|-----------|-----|---|-----|
|9|Madan                                             |Mohan                                             |Senior General Manager||L7|1961-08-01 00:00:00.000|2016-04-01 00:00:00.000|1008 Vrinda Ave MT|Edmonton|AB|Canada|T5K 2N1|+1 (780) 428-9482|+1 (780) 428-3457|madan.mohan@chinookcorp.com|

### Insights:
- The most senior employee based on title is Madan Mohan

#### Q2. Which countries have the most Invoices?
```sql
SELECT
	billing_country,
	count(*) AS no_invoice
FROM
	invoice
GROUP BY
	billing_country
ORDER BY
	no_invoice DESC;
```
### Result:
|billing_country|no_invoice|
|---------------|----------|
|USA            |131       |
|Canada         |76        |
|Brazil         |61        |
|France         |50        |
|Germany        |41        |
|Czech Republic |30        |
|Portugal       |29        |
|United Kingdom |28        |
|India          |21        |
|Chile          |13        |
|Ireland        |13        |
|Spain          |11        |
|Finland        |11        |
|Australia      |10        |
|Netherlands    |10        |
|Sweden         |10        |
|Poland         |10        |
|Hungary        |10        |
|Denmark        |10        |
|Austria        |9         |
|Norway         |9         |
|Italy          |9         |
|Belgium        |7         |
|Argentina      |5         |

### Insights:
- USA, Canada and Brazil are the top 3 countries that have the most invoices.

- Austria, Norway, Italy, Belgium and Argntina are the countries with least invoices.

#### Q3. What are top 3 values of total invoice?
```sql
SELECT *
FROM invoice
ORDER BY total DESC 
LIMIT 3;
```
### Result:
|invoice_id|customer_id|invoice_date           |billing_address       |billing_city|billing_state|billing_country|billing_postal|total|billing_postal_code|
|----------|-----------|-----------------------|----------------------|------------|-------------|---------------|--------------|-----|-------------------|
|183       |42         |2018-02-09 00:00:00.000|9, Place Louis Barthou|Bordeaux    |None         |France         |              |23.76|33000              |
|92        |32         |2017-07-02 00:00:00.000|696 Osborne Street    |Winnipeg    |MB           |Canada         |              |19.8 |R3L 2B9            |
|31        |3          |2017-02-21 00:00:00.000|1498 rue Bélanger     |Montréal    |QC           |Canada         |              |19.8 |H2G 1A7            |

#### Q4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.
```sql
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
```
### Result:
|billing_country|billing_city|total |
|---------------|------------|------|
|Czech Republic |Prague      |273.24|

### Insights:
The city that has the best customers is Czech Republic.

#### Q5. Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money.
```sql
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
```
### Result:
|customer_name                                               |total_money|
|------------------------------------------------------------|-----------|
|Wyatt                         Girard                        |23.76      |

### Insight:
Wyatt Girard is the best customer bescause he was the one that spent the most money.

#### Q6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners.
```sql
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
```
### Result:
|email                        |first_name                    |last_name                     |genre_name|
|-----------------------------|------------------------------|------------------------------|----------|
|aaronmitchell@yahoo.ca       |Aaron                         |Mitchell                      |Rock      |
|alero@uol.com.br             |Alexandre                     |Rocha                         |Rock      |
|astrid.gruber@apple.at       |Astrid                        |Gruber                        |Rock      |
|bjorn.hansen@yahoo.no        |Bjørn                         |Hansen                        |Rock      |
|camille.bernard@yahoo.fr     |Camille                       |Bernard                       |Rock      |
|daan_peeters@apple.be        |Daan                          |Peeters                       |Rock      |
|diego.gutierrez@yahoo.ar     |Diego                         |Gutiérrez                     |Rock      |
|dmiller@comcast.com          |Dan                           |Miller                        |Rock      |
|dominiquelefebvre@gmail.com  |Dominique                     |Lefebvre                      |Rock      |
|edfrancis@yachoo.ca          |Edward                        |Francis                       |Rock      |
|eduardo@woodstock.com.br     |Eduardo                       |Martins                       |Rock      |
|ellie.sullivan@shaw.ca       |Ellie                         |Sullivan                      |Rock      |
|emma_jones@hotmail.com       |Emma                          |Jones                         |Rock      |
|enrique_munoz@yahoo.es       |Enrique                       |Muñoz                         |Rock      |
|fernadaramos4@uol.com.br     |Fernanda                      |Ramos                         |Rock      |
|fharris@google.com           |Frank                         |Harris                        |Rock      |
|fralston@gmail.com           |Frank                         |Ralston                       |Rock      |
|frantisekw@jetbrains.com     |František                     |Wichterlová                   |Rock      |
|ftremblay@gmail.com          |François                      |Tremblay                      |Rock      |
|fzimmermann@yahoo.de         |Fynn                          |Zimmermann                    |Rock      |
|hannah.schneider@yahoo.de    |Hannah                        |Schneider                     |Rock      |
|hholy@gmail.com              |Helena                        |Holý                          |Rock      |
|hleacock@gmail.com           |Heather                       |Leacock                       |Rock      |
|hughoreilly@apple.ie         |Hugh                          |O'Reilly                      |Rock      |
|isabelle_mercier@apple.fr    |Isabelle                      |Mercier                       |Rock      |
|jacksmith@microsoft.com      |Jack                          |Smith                         |Rock      |
|jenniferp@rogers.ca          |Jennifer                      |Peterson                      |Rock      |
|jfernandes@yahoo.pt          |João                          |Fernandes                     |Rock      |
|joakim.johansson@yahoo.se    |Joakim                        |Johansson                     |Rock      |
|johavanderberg@yahoo.nl      |Johannes                      |Van der Berg                  |Rock      |
|johngordon22@yahoo.com       |John                          |Gordon                        |Rock      |
|jubarnett@gmail.com          |Julia                         |Barnett                       |Rock      |
|kachase@hotmail.com          |Kathy                         |Chase                         |Rock      |
|kara.nielsen@jubii.dk        |Kara                          |Nielsen                       |Rock      |
|ladislav_kovacs@apple.hu     |Ladislav                      |Kovács                        |Rock      |
|leonekohler@surfeu.de        |Leonie                        |Köhler                        |Rock      |
|lucas.mancini@yahoo.it       |Lucas                         |Mancini                       |Rock      |
|luisg@embraer.com.br         |Luís                          |Gonçalves                     |Rock      |
|luisrojas@yahoo.cl           |Luis                          |Rojas                         |Rock      |
|manoj.pareek@rediff.com      |Manoj                         |Pareek                        |Rock      |
|marc.dubois@hotmail.com      |Marc                          |Dubois                        |Rock      |
|mark.taylor@yahoo.au         |Mark                          |Taylor                        |Rock      |
|marthasilk@gmail.com         |Martha                        |Silk                          |Rock      |
|masampaio@sapo.pt            |Madalena                      |Sampaio                       |Rock      |
|michelleb@aol.com            |Michelle                      |Brooks                        |Rock      |
|mphilips12@shaw.ca           |Mark                          |Philips                       |Rock      |
|nschroder@surfeu.de          |Niklas                        |Schröder                      |Rock      |
|patrick.gray@aol.com         |Patrick                       |Gray                          |Rock      |
|phil.hughes@gmail.com        |Phil                          |Hughes                        |Rock      |
|ricunningham@hotmail.com     |Richard                       |Cunningham                    |Rock      |
|rishabh_mishra@yahoo.in      |Rishabh                       |Mishra                        |Rock      |
|robbrown@shaw.ca             |Robert                        |Brown                         |Rock      |
|roberto.almeida@riotur.gov.br|Roberto                       |Almeida                       |Rock      |
|stanisław.wójcik@wp.pl       |Stanisław                     |Wójcik                        |Rock      |
|steve.murray@yahoo.uk        |Steve                         |Murray                        |Rock      |
|terhi.hamalainen@apple.fi    |Terhi                         |Hämäläinen                    |Rock      |
|tgoyer@apple.com             |Tim                           |Goyer                         |Rock      |
|vstevens@yahoo.com           |Victor                        |Stevens                       |Rock      |
|wyatt.girard@yahoo.fr        |Wyatt                         |Girard                        |Rock      |


#### Q7. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands.
```sql
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
```
### Result:
|artist_name                 |genre_name|track_count|
|----------------------------|----------|-----------|
|Led Zeppelin                |Rock      |114        |
|U2                          |Rock      |112        |
|Deep Purple                 |Rock      |92         |
|Iron Maiden                 |Rock      |81         |
|Pearl Jam                   |Rock      |54         |
|Van Halen                   |Rock      |52         |
|Queen                       |Rock      |45         |
|The Rolling Stones          |Rock      |41         |
|Creedence Clearwater Revival|Rock      |40         |
|Kiss                        |Rock      |35         |

### Insights:
Led Zeppelin and U2 are the artists that have written the most rock music.

#### Q8. Return all the track names that have a song length longer than the average song length.
```sql
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
	2 DESC;
```
### Result:
|name|milliseconds|
|----|------------|
|Occupation / Precipice|5286953|
|Through a Looking Glass|5088838|
|Greetings from Earth, Pt. 1|2960293|
|The Man With Nine Lives|2956998|
|Battlestar Galactica, Pt. 2|2956081|
|Battlestar Galactica, Pt. 1|2952702|
|Murder On the Rising Star|2935894|
|Battlestar Galactica, Pt. 3|2927802|
|Take the Celestra|2927677|
|Fire In Space|2926593|

#### Q9. Find how much amount spent by each customer on artists. Write a query to return the customer name, artist name, and total spent.
```sql
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
	3 DESC;
```
### Result:
This is the first 10 result
|customer_name                                               |artist_name                 |total_price|
|------------------------------------------------------------|----------------------------|-----------|
|Hugh                          O'Reilly                      |Queen                       |27.72      |
|Wyatt                         Girard                        |Frank Sinatra               |23.76      |
|Robert                        Brown                         |Creedence Clearwater Revival|19.8       |
|František                     Wichterlová                   |Kiss                        |19.8       |
|François                      Tremblay                      |The Who                     |19.8       |
|Aaron                         Mitchell                      |James Brown                 |19.8       |
|Helena                        Holý                          |Red Hot Chili Peppers       |19.8       |
|Niklas                        Schröder                      |Queen                       |18.81      |
|Hugh                          O'Reilly                      |Nirvana                     |18.81      |
|Heather                       Leacock                       |House Of Pain               |18.81      |

####  Q10. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. 
#### Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres.
```sql
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
	row_num = 1

```
### Result:
|country       |top_genre         |total_purchase|
|--------------|------------------|--------------|
|Argentina     |Alternative & Punk|17            |
|Australia     |Rock              |34            |
|Austria       |Rock              |40            |
|Belgium       |Rock              |26            |
|Brazil        |Rock              |205           |
|Canada        |Rock              |333           |
|Chile         |Rock              |61            |
|Czech Republic|Rock              |143           |
|Denmark       |Rock              |24            |
|Finland       |Rock              |46            |
|France        |Rock              |211           |
|Germany       |Rock              |194           |
|Hungary       |Rock              |44            |
|India         |Rock              |102           |
|Ireland       |Rock              |72            |
|Italy         |Rock              |35            |
|Netherlands   |Rock              |33            |
|Norway        |Rock              |40            |
|Poland        |Rock              |40            |
|Portugal      |Rock              |108           |
|Spain         |Rock              |46            |
|Sweden        |Rock              |60            |
|United Kingdom|Rock              |166           |
|USA           |Rock              |561           |

#### Q11. Write a query that determines the customer that has spent the most on music for each country. 
#### Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount
```sql
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
	row_num = 1
```
### Result
|country       |customer_name                                               |total_price|
|--------------|------------------------------------------------------------|-----------|
|Argentina     |Diego                         Gutiérrez                     |39.6       |
|Australia     |Mark                          Taylor                        |81.18      |
|Austria       |Astrid                        Gruber                        |69.3       |
|Belgium       |Daan                          Peeters                       |60.39      |
|Brazil        |Luís                          Gonçalves                     |108.9      |
|Canada        |François                      Tremblay                      |99.99      |
|Chile         |Luis                          Rojas                         |97.02      |
|Czech Republic|František                     Wichterlová                   |144.54     |
|Denmark       |Kara                          Nielsen                       |37.62      |
|Finland       |Terhi                         Hämäläinen                    |79.2       |
|France        |Wyatt                         Girard                        |99.99      |
|Germany       |Fynn                          Zimmermann                    |94.05      |
|Hungary       |Ladislav                      Kovács                        |78.21      |
|India         |Manoj                         Pareek                        |111.87     |
|Ireland       |Hugh                          O'Reilly                      |114.84     |
|Italy         |Lucas                         Mancini                       |50.49      |
|Netherlands   |Johannes                      Van der Berg                  |65.34      |
|Norway        |Bjørn                         Hansen                        |72.27      |
|Poland        |Stanisław                     Wójcik                        |76.23      |
|Portugal      |João                          Fernandes                     |102.96     |
|Spain         |Enrique                       Muñoz                         |98.01      |
|Sweden        |Joakim                        Johansson                     |75.24      |
|United Kingdom|Phil                          Hughes                        |98.01      |
|USA           |Jack                          Smith                         |98.01      |

#### Q12. Who are the most popular artists?
```sql
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
Limit 10;
```
### Result:
|artist_name          |no_of_records_produced|
|---------------------|----------------------|
|Queen                |192                   |
|Jimi Hendrix         |187                   |
|Nirvana              |130                   |
|Red Hot Chili Peppers|130                   |
|Pearl Jam            |129                   |
|Guns N' Roses        |124                   |
|AC/DC                |124                   |
|Foo Fighters         |121                   |
|The Rolling Stones   |117                   |
|Metallica            |106                   |


### Insight:
The most popular artist are Queen with 192 records produced.

#### Q13. What is the most popular song?
```sql
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
```
### Result:
|song_name               |total_quantities|
|------------------------|----------------|
|War Pigs                |33              |
|Are You Experienced?    |14              |
|Changes                 |14              |
|Highway Chile           |14              |
|Hey Joe                 |13              |
|Third Stone From The Sun|13              |
|Put The Finger On You   |13              |
|Radio/Video             |12              |
|We Are The Champions    |12              |
|Love Or Confusion       |12              |


#### Q14. What are the average prices of different types of music?
```sql
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
```
### Result:
|genre             |avg_purchase|
|------------------|------------|
|Rock              |$ 26752     |
|Metal             |$ 5316      |
|Alternative & Punk|$ 4841      |
|R&B/Soul          |$ 1751      |
|Latin             |$ 1706      |
|Blues             |$ 1379      |
|Jazz              |$ 1303      |
|Alternative       |$ 1096      |
|Easy Listening    |$ 951       |
|Electronica/Dance |$ 615       |
|Pop               |$ 568       |
|Hip Hop/Rap       |$ 463       |
|Classical         |$ 361       |
|Reggae            |$ 257       |
|Heavy Metal       |$ 70        |
|Soundtrack        |$ 47        |
|TV Shows          |$ 20        |
|Drama             |$ 6         |

#### -- Q15. What are the most popular countries for music purchases?
```sql
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
```
### Result:
|country|total_purchase|
|-------|--------------|
|USA|1051|
|Canada|541|
|Brazil|432|
|France|393|
|Germany|338|
|Czech Republic|276|
|United Kingdom|248|
|Portugal|187|
|India|185|
|Ireland|116|
|Spain|99|
|Chile|98|
|Australia|82|
|Finland|80|
|Hungary|79|
|Poland|77|
|Sweden|76|
|Norway|73|
|Austria|70|
|Netherlands|66|
|Belgium|61|
|Italy|51|
|Argentina|40|
|Denmark|38|

