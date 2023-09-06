# DVD Rental Analysis

In this project, I conducted an in-depth exploration of the  DVD Rental database. This database contains valuable information about a DVD rental company. Throughout this project, I utilized a series of queries to unearth insights into various aspects of the business. I delved into understanding customer behavior, payment earnings, and the performance of different stores within the company.

# Questions and Answers

#### Questions to be answered
In this project, I’ll aim to answer the following questions:

1. What are the top and least rented genres and what are their total sales?
2. Can we know how many distinct users have rented each genre ?
3. What is the average rental rate for each genre?
4. How many rental films were returned late, early and on time?
5. what are the total sales and customer base in each country where the DVD_rental industry is based?
6. who are the top 5 customers per total sales and their details?
7. What are the most-watched movie genres among families, specifically focusing on genres such as Animation, Children, Classics, Comedy, Family, and Music?
8. In which months did each store process the highest total number of rental orders?
9. Can you provide the details of customers who have not returned DVDs?


#### 1. What are the top and least rented genres and what are their total sales?

```sql
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
```

### Results:
|genre      |total_rent|total_sales|
|-----------|----------|-----------|
|Sports     |1,179     |4,892.19   |
|Animation  |1,166     |4,245.31   |
|Action     |1,112     |3,951.84   |
|Sci-Fi     |1,101     |4,336.01   |
|Family     |1,096     |3,830.15   |
|Drama      |1,060     |4,118.46   |
|Documentary|1,050     |3,749.65   |
|Foreign    |1,033     |3,934.47   |
|Games      |969       |3,922.18   |
|Children   |945       |3,309.39   |
|Comedy     |941       |4,002.48   |
|New        |940       |3,966.38   |
|Classics   |939       |3,353.38   |
|Horror     |846       |3,401.27   |
|Travel     |837       |3,227.36   |
|Music      |830       |3,071.52   |


### Insight:
1. **Genre Diversity:** The Film industry has a diverse collection of 16 unique genres, indicating that they cater to a wide range of customer preferences.

2. **Top Performer (Sports):** The sports genre is the most popular among customers, with a total rental count of 1,179 and generating the highest total sales revenue of $4,892.19. This suggests a strong demand for sports-related content, which could be further leveraged for marketing and content acquisition.

3. **Least Popular (Music):** The music genre is the least rented, with only 830 rentals and the lowest total sales revenue of $3,071.52. This indicates that there might be an opportunity to improve the selection or promotion of music-related content to boost rentals and sales.

4. **Popular Genres (Animation, Action, Sci-Fi):** Animation, action, and sci-fi genres also perform well in terms of rental counts and total sales. These genres might warrant special attention in terms of content acquisition and promotion to maximize revenue.

5. **Potential for Improvement (Music and Classics):** Genres like music and classics have room for improvement in terms of rental counts and total sales. Strategies to increase the appeal of these genres, such as offering exclusive content or targeted marketing, could be explored.

In summary, this analysis not only identifies the top and least rented genres but also provides valuable insights for optimizing the content catalog and marketing strategies to enhance rental counts and total sales across various genres.


#### 2. Can we know how many distinct users have rented each genre ?
```sql
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
```

### Results:
|genre      |total_rent|
|-----------|----------|
|Sports     |519       |
|Action     |510       |
|Sci-Fi     |507       |
|Family     |501       |
|Drama      |501       |
|Animation  |500       |
|Comedy     |495       |
|Foreign    |493       |
|Documentary|483       |
|Children   |482       |
|Games      |474       |
|New        |468       |
|Classics   |468       |
|Horror     |451       |
|Music      |447       |
|Travel     |442       |

### Insights:
1. **Distinct Customer Engagement:** The analysis focuses on understanding how many distinct customers have engaged with each genre, providing insights into the diversity of customer preferences.

2. **Travel Genre Surprises:** It's noteworthy that the travel genre, despite having a relatively low total rental count, has the lowest number of distinct customers. This suggests that while fewer people may rent travel-related content, those who do are more likely to engage with this genre multiple times. This could indicate a niche audience with a strong interest in travel content.

3. **Repeat Rentals in Travel:** Building upon the previous point, the higher number of repeat rentals in the travel genre might be due to the evergreen nature of travel content. Customers could be revisiting travel documentaries or shows for inspiration or planning purposes, even multiple times.

4. **Sports Genre Popularity:** The sports genre stands out not only for having a high total rental count but also for attracting the highest number of distinct customers. This indicates a broad and dedicated audience interested in sports-related content, which could be leveraged for targeted marketing and content expansion in this genre.

5. **Opportunities for Music Genre:** Despite having fewer total rentals compared to some genres, the music genre has attracted a relatively high number of distinct customers. This suggests an opportunity to further promote and diversify the music genre's content to increase rental counts and revenue.

6. **Customer Engagement Strategy:** These insights can help in tailoring marketing and content acquisition strategies. For example, for genres like travel and music, there could be strategies to engage repeat customers, while for popular genres like sports, efforts could focus on expanding the customer base.

In summary, this analysis not only provides information about the number of distinct customers for each genre but also highlights the unique characteristics of customer engagement with different genres, which can inform strategies to maximize customer satisfaction and revenue in each genre.



#### 3. What is the average rental rate for each genre?
```sql
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
```

### Results:
|genre      |avg_rental_rate|
|-----------|---------------|
|Games      |3.25           |
|Travel     |3.24           |
|Sci-Fi     |3.22           |
|Comedy     |3.16           |
|Sports     |3.13           |
|New        |3.12           |
|Foreign    |3.1            |
|Horror     |3.03           |
|Drama      |3.02           |
|Music      |2.95           |
|Children   |2.89           |
|Animation  |2.81           |
|Family     |2.76           |
|Classics   |2.74           |
|Documentary|2.67           |
|Action     |2.65           |


### Insights:
1. **Consumer Behavior and Price Sensitivity:** The data suggests that consumer behavior in choosing a rental is not solely driven by the average rental rate. This implies that factors such as genre preference, movie availability, and personal interests play a significant role in rental decisions.

2. **Game Genre Anomaly:** Despite having the lowest average rental rate, the game genre is among the top five most rented genres. This could indicate a strong and dedicated audience for gaming content. Consider exploring opportunities to expand the game genre catalog or offer special promotions to further leverage this popularity.

3. **Action Genre Popularity:** The Action genre, with the highest average rental rate, remains one of the most rented genres. This challenges the assumption that higher rates deter rentals in all cases. It's possible that customers are willing to pay more for high-quality action films. Leveraging this popularity, you might consider acquiring more premium action content or exclusive releases.

4. **Audience Preferences:** The variation in average rental rates across genres also reflects differences in audience preferences. For instance, customers might be more price-sensitive when it comes to genres like Family, Children, or Animation, but less so for genres like Action or Games. This can inform pricing strategies and content acquisition decisions.

5. **Opportunities in Music and Classics:** The Music and Classics genres have relatively low average rental rates, and the data suggests they are not among the most rented genres. There could be opportunities to enhance the content offerings in these genres or explore pricing strategies to attract more rentals.

6. **Competition and Market Trends:** Understanding how different genres perform in terms of rental rates and frequency can help in competitive positioning and adapting to changing market trends. Monitoring these trends over time can provide insights into evolving customer preferences.

In summary, the analysis of the average rental rates for each genre reveals that consumer behavior is influenced by various factors beyond just price. Genre preferences, content quality, and audience interests are crucial considerations in shaping your content acquisition and pricing strategies.



#### 4. How many rental films were returned late, early and on time?
```sql
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
```

### Results:
|return_status   |total|total_pct|
|----------------|-----|---------|
|Returned early  |7,738|48%      |
|Returned late   |6,586|41%      |
|Returned On Time|1,720|11%      |

### Insights:
* **Return Statistics:**
    * Based on the query results, we find that:
        * 48% of movies are returned earlier than the due date.
        * 41% of movies are returned late.
        * 11% of movies arrive on time.
* **Complex Factors at Play:**
    * Several factors might contribute to these patterns, such as shipping distances beyond customer control.
        * For example, customers who live further away from the rental store may be more likely to return movies late.
        * Additionally, customers who are busy or forgetful may also be more likely to return movies late.
* **Deeper Analysis Needed:**
    * Further exploration of the data is required to uncover the underlying issues.
        * This could involve analyzing customer demographics, rental patterns, and other factors.
* **Potential for Penalty Fees:**
    * Notably, a significant portion of movies are returned late. Consideration of a late return penalty fee as an additional revenue source is warranted.
        * However, the implementation of such a policy should be informed by a deeper understanding of why late returns occur.
        * For example, if late returns are due to factors beyond the customer's control, such as shipping delays, then a penalty fee may not be fair.
* **Conclusion:**
    * The insights presented in this document provide a valuable starting point for understanding movie return status. Further analysis is needed to uncover the underlying issues and develop strategies to improve the return rate.


#### 5. what are the total sales and customer base in each country where the DVD_rental industry is based?

```sql
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
```

### Results:
|country                              |customer_base|total_sales|
|-------------------------------------|-------------|-----------|
|India                                |60           |6,034.78   |
|China                                |53           |5,251.03   |
|United States                        |36           |3,685.31   |
|Japan                                |31           |3,122.51   |
|Mexico                               |30           |2,984.82   |
|Brazil                               |28           |2,919.19   |
|Russian Federation                   |28           |2,765.62   |
|Philippines                          |20           |2,219.7    |
|Turkey                               |15           |1,498.49   |
|Indonesia                            |14           |1,352.69   |
|Nigeria                              |13           |1,314.92   |
|Argentina                            |13           |1,298.8    |
|South Africa                         |11           |1,069.46   |
|Taiwan                               |10           |1,155.1    |
|United Kingdom                       |9            |850.96     |
|Iran                                 |8            |877.96     |
|Poland                               |8            |786.16     |
|Italy                                |7            |753.26     |
|Germany                              |7            |741.24     |
|Venezuela                            |7            |632.43     |
|Egypt                                |6            |659.48     |
|Ukraine                              |6            |675.53     |
|Vietnam                              |6            |676.45     |
|Colombia                             |6            |661.54     |
|Spain                                |5            |513.8      |
|Canada                               |5            |559.7      |
|Saudi Arabia                         |5            |452.94     |
|Netherlands                          |5            |557.73     |
|Pakistan                             |5            |473.84     |
|South Korea                          |5            |527.77     |
|Peru                                 |4            |407.01     |
|France                               |4            |334.12     |
|Yemen                                |4            |473.93     |
|Israel                               |4            |379.13     |
|Algeria                              |3            |349.18     |
|Switzerland                          |3            |248.41     |
|Tanzania                             |3            |322.22     |
|United Arab Emirates                 |3            |305.25     |
|Morocco                              |3            |274.35     |
|Bangladesh                           |3            |353.19     |
|Chile                                |3            |303.34     |
|Thailand                             |3            |401.08     |
|Malaysia                             |3            |330.23     |
|Austria                              |3            |284.3      |
|Paraguay                             |3            |273.4      |
|Mozambique                           |3            |315.25     |
|Ecuador                              |3            |369.18     |
|Dominican Republic                   |3            |304.26     |
|Sudan                                |2            |202.51     |
|Bolivia                              |2            |178.56     |
|Greece                               |2            |204.54     |
|Belarus                              |2            |271.36     |
|Bulgaria                             |2            |194.52     |
|Yugoslavia                           |2            |233.49     |
|Cambodia                             |2            |179.51     |
|Cameroon                             |2            |186.49     |
|Romania                              |2            |218.42     |
|Puerto Rico                          |2            |224.48     |
|Kazakstan                            |2            |192.51     |
|Kenya                                |2            |245.49     |
|Angola                               |2            |187.55     |
|Latvia                               |2            |249.43     |
|Azerbaijan                           |2            |198.53     |
|Congo, The Democratic Republic of the|2            |168.58     |
|Oman                                 |2            |161.56     |
|Myanmar                              |2            |179.53     |
|French Polynesia                     |2            |205.52     |
|Zambia                               |1            |121.7      |
|American Samoa                       |1            |47.85      |
|Anguilla                             |1            |99.68      |
|Armenia                              |1            |118.75     |
|Bahrain                              |1            |108.76     |
|Brunei                               |1            |107.66     |
|Chad                                 |1            |122.72     |
|Czech Republic                       |1            |132.72     |
|Estonia                              |1            |105.72     |
|Ethiopia                             |1            |91.77      |
|Faroe Islands                        |1            |96.76      |
|Finland                              |1            |78.79      |
|French Guiana                        |1            |97.8       |
|Gambia                               |1            |114.73     |
|Greenland                            |1            |119.72     |
|Holy See (Vatican City State)        |1            |146.68     |
|Hong Kong                            |1            |104.76     |
|Hungary                              |1            |111.71     |
|Iraq                                 |1            |111.73     |
|Kuwait                               |1            |106.75     |
|Liechtenstein                        |1            |99.74      |
|Lithuania                            |1            |63.78      |
|Madagascar                           |1            |92.79      |
|Malawi                               |1            |121.73     |
|Moldova                              |1            |127.66     |
|Nauru                                |1            |143.7      |
|Nepal                                |1            |93.83      |
|New Zealand                          |1            |85.77      |
|North Korea                          |1            |107.71     |
|Runion                               |1            |211.55     |
|Saint Vincent and the Grenadines     |1            |64.82      |
|Senegal                              |1            |95.76      |
|Slovakia                             |1            |80.77      |
|Sri Lanka                            |1            |103.73     |
|Sweden                               |1            |139.67     |
|Tonga                                |1            |64.84      |
|Tunisia                              |1            |73.78      |
|Turkmenistan                         |1            |126.74     |
|Tuvalu                               |1            |93.78      |
|Virgin Islands, U.S.                 |1            |121.69     |
|Afghanistan                          |1            |67.82      |


### Insight:

1. **Market Size Variation:** The data illustrates a significant variation in both customer base and total sales across countries. This indicates that the DVD rental industry's performance is closely tied to the specific market conditions in each country.

2. **Revenue Discrepancies:** It's worth noting that countries with larger customer bases don't always have the highest total sales. For instance, China has a substantial customer base but slightly lower total sales compared to India. This suggests that factors such as rental pricing, customer preferences, and market competition play a role in revenue generation.

3. **Untapped Markets:** Countries with small customer bases like Afghanistan, Nauru, and Tonga might represent untapped or emerging markets for the DVD rental industry. Exploring strategies to expand and attract more customers in these regions could be an opportunity for growth.

4. **Market Saturation:** On the other hand, countries with larger customer bases like India and China might indicate relatively mature markets for DVD rentals. Strategies for retaining and satisfying existing customers, as well as attracting new ones, become essential in such markets.

In conclusion, this data provides valuable insights into the global presence of the DVD rental industry. Understanding the nuances of each market can help guide strategic decisions related to customer acquisition, retention, and revenue optimization in different countries.


#### 6. who are the top 5 customers per total sales and their details?

```sql
SELECT
	concat(first_name,' ',last_name) AS full_name,
	email,
	address,
	phone,
	city,
	country,
	sum(amount) AS total_amount
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
```

### Results:
|full_name     |email                            |address              |phone       |city               |country      |total_amount   |
|--------------|---------------------------------|---------------------|------------|-------------------|-------------|------|
|Eleanor Hunt  |eleanor.hunt@sakilacustomer.org  |1952 Pune Lane       |354615066969|Saint-Denis        |Runion       |211.55|
|Karl Seal     |karl.seal@sakilacustomer.org     |1427 Tabuk Place     |214756839122|Cape Coral         |United States|208.58|
|Marion Snyder |marion.snyder@sakilacustomer.org |1891 Rizhao Boulevard|391065549876|Santa Brbara dOeste|Brazil       |194.61|
|Rhonda Kennedy|rhonda.kennedy@sakilacustomer.org|1749 Daxian Place    |963369996279|Apeldoorn          |Netherlands  |191.62|
|Clara Shaw    |clara.shaw@sakilacustomer.org    |1027 Songkhla Manor  |563660187896|Molodetno          |Belarus      |189.6 |

### Insights:

The table above provides the full names, addresses, and email addresses of your top customers. This information can be shared with the marketing team to help them strategize and decide how to best reward these valuable customers.

What are some ideas for rewarding your top customers?

- Send them a gift card to their favorite store.

- Offer them a free upgrade to a higher membership tier.

- Invite them to a special event or promotion.

- Give them a personalized thank-you note.



#### 7. What are the most-watched movie genres among families, specifically focusing on genres such as Animation, Children, Classics, Comedy, Family, and Music?

```sql
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
```

### Results:
|genre    |total_no_of_movie|
|---------|-----------------|
|Animation|1,166            |
|Family   |1,096            |
|Children |945              |
|Comedy   |941              |
|Classics |939              |
|Music    |830              |

### Insights:

The table above provides insights into the most-watched movie genres among families. Here's a summary of the findings:

1. **Animation**: Animation movies are the most popular among families, with a total of 1,166 movies watched. This genre often appeals to both children and adults, making it a top choice for family entertainment.

2. **Family**: The genre specifically labeled as "Family" is the second most-watched, with 1,096 movies viewed. This genre is explicitly designed for family audiences and often includes content suitable for all age groups.

3. **Children**: The "Children" genre is also highly popular among families, with 945 movies watched. This genre typically targets younger audiences and is a staple for family movie nights.

4. **Comedy**: Comedy movies, with 941 movies viewed, are another favorite among families. Humor has universal appeal, making it a common choice for family gatherings.

5. **Classics**: Classic movies, with 939 movies watched, indicate that families enjoy revisiting timeless cinematic treasures. These films often have enduring appeal across generations.

6. **Music**: While still popular, the "Music" genre has a slightly lower viewership among families, with 830 movies watched. Music-themed movies may appeal more to specific family members with a passion for music.

These insights can guide movie rental services in curating their movie collections to cater to family audiences. Offering a diverse selection of movies across these genres can help attract and retain family-oriented customers.

#### 8. In which months did each store process the highest total number of rental orders? 	

```sql
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
```

### Results:
|year|month|month_name|store_1|store_2|
|----|-----|----------|-------|-------|
|2005|5|May      |575|581|
|2005|6|June     |1121|1190|
|2005|7|July     |3334|3375|
|2005|8|August   |2801|2885|
|2006|2|February |92|90|

### Insights:
**Monthly Rental Order Processing: Store Performance**

The table presents the monthly performance of two stores in terms of the total number of rental orders processed. Here are the key insights:

- **Store 1 vs. Store 2:** The data provides a month-by-month comparison of rental order processing for Store 1 and Store 2.

- **May 2005:** In May 2005, both stores processed a substantial number of rental orders, with Store 2 slightly ahead at 581 orders, while Store 1 processed 575 orders.

- **June 2005:** In June 2005, both stores significantly increased their order processing, with Store 2 still leading at 1,190 orders, while Store 1 processed 1,121 orders.

- **July 2005:** July 2005 saw a further increase in rental order processing, with Store 2 processing 3,375 orders, surpassing Store 1, which processed 3,334 orders.

- **August 2005:** In August 2005, both stores continued to process a high number of orders. Store 2 processed 2,885 orders, while Store 1 processed 2,801 orders.

- **February 2006:** The data also includes a point from February 2006, where both stores processed a relatively low number of orders, with Store 2 processing 90 orders and Store 1 processing 92 orders.

These insights can be used to identify peak months for rental order processing in each store, which can inform staffing and inventory management strategies to meet customer demand during busy periods.


#### 9. Can you provide the details of customers who have not returned DVDs?
```sql
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
```

### Results:
|full_name         |title                 |rental_date            |return_date|email                                |address                              |phone       |city                 |country             |
|------------------|----------------------|-----------------------|-----------|-------------------------------------|-------------------------------------|------------|---------------------|--------------------|
|Dwayne Olvera     |Academy Dinosaur      |2005-08-21 00:30:32.000|           |dwayne.olvera@sakilacustomer.org     |1447 Imus Place                      |62127829280 |Rajkot               |India               |
|Brandon Huey      |Ace Goldfinger        |2006-02-14 15:16:03.000|           |brandon.huey@sakilacustomer.org      |1912 Emeishan Drive                  |99883471275 |Balikesir            |Turkey              |
|Carmen Owens      |Affair Prejudice      |2006-02-14 15:16:03.000|           |carmen.owens@sakilacustomer.org      |1378 Alvorada Avenue                 |272234298332|Caracas              |Venezuela           |
|Seth Hannon       |African Egg           |2006-02-14 15:16:03.000|           |seth.hannon@sakilacustomer.org       |1759 Niznekamsk Avenue               |864392582257|al-Manama            |Bahrain             |
|Tracy Cole        |Ali Forever           |2006-02-14 15:16:03.000|           |tracy.cole@sakilacustomer.org        |1002 Ahmadnagar Manor                |371490777743|Huixquilucan         |Mexico              |
|Marcia Dean       |Alone Trip            |2006-02-14 15:16:03.000|           |marcia.dean@sakilacustomer.org       |1479 Rustenburg Boulevard            |727785483194|Tanza                |Philippines         |
|Cecil Vines       |Amadeus Holy          |2006-02-14 15:16:03.000|           |cecil.vines@sakilacustomer.org       |548 Uruapan Street                   |879347453467|London               |United Kingdom      |
|Marie Turner      |American Circus       |2006-02-14 15:16:03.000|           |marie.turner@sakilacustomer.org      |1998 Halifax Drive                   |177727722820|Lipetsk              |Russian Federation  |
|Joe Gilliland     |Amistad Midsummer     |2006-02-14 15:16:03.000|           |joe.gilliland@sakilacustomer.org     |953 Hodeida Street                   |53912826864 |Imus                 |Philippines         |
|Edward Baugh      |Armageddon Lost       |2006-02-14 15:16:03.000|           |edward.baugh@sakilacustomer.org      |1359 Zhoushan Parkway                |46568045367 |Trshavn              |Faroe Islands       |
|Beth Franklin     |Baked Cleopatra       |2006-02-14 15:16:03.000|           |beth.franklin@sakilacustomer.org     |1149 A Corua (La Corua) Boulevard    |470884141195|Haiphong             |Vietnam             |
|Gina Williamson   |Bang Kwai             |2006-02-14 15:16:03.000|           |gina.williamson@sakilacustomer.org   |1001 Miyakonojo Lane                 |584316724815|Taizz                |Yemen               |
|Melvin Ellington  |Basic Easy            |2006-02-14 15:16:03.000|           |melvin.ellington@sakilacustomer.org  |1557 Cape Coral Parkway              |368284120423|Laohekou             |China               |
|Sonia Gregory     |Berets Agent          |2006-02-14 15:16:03.000|           |sonia.gregory@sakilacustomer.org     |1279 Udine Parkway                   |195003555232|Benin City           |Nigeria             |
|Florence Woods    |Blade Polish          |2006-02-14 15:16:03.000|           |florence.woods@sakilacustomer.org    |1532 Dzerzinsk Way                   |330838016880|Merlo                |Argentina           |
|Tyler Wren        |Blanket Beverly       |2006-02-14 15:16:03.000|           |tyler.wren@sakilacustomer.org        |1060 Tandil Lane                     |211256301880|Rizhao               |China               |
|Mildred Bailey    |Boogie Amelie         |2006-02-14 15:16:03.000|           |mildred.bailey@sakilacustomer.org    |81 Hodeida Way                       |250767749542|Jaipur               |India               |
|Anna Hill         |Boulevard Mob         |2006-02-14 15:16:03.000|           |anna.hill@sakilacustomer.org         |127 Purnea (Purnia) Manor            |911872220378|Alessandria          |Italy               |
|Robin Hayes       |Bound Cheaper         |2006-02-14 15:16:03.000|           |robin.hayes@sakilacustomer.org       |1913 Kamakura Place                  |942570536750|Jelets               |Russian Federation  |
|Lois Butler       |Bubble Grosse         |2006-02-14 15:16:03.000|           |lois.butler@sakilacustomer.org       |1370 Le Mans Avenue                  |345679835036|Bandar Seri Begawan  |Brunei              |
|Lisa Anderson     |Bull Shawshank        |2006-02-14 15:16:03.000|           |lisa.anderson@sakilacustomer.org     |1542 Tarlac Parkway                  |635297277345|Sagamihara           |Japan               |
|Sergio Stanfield  |Camelot Vacation      |2006-02-14 15:16:03.000|           |sergio.stanfield@sakilacustomer.org  |1402 Zanzibar Boulevard              |387448063440|Celaya               |Mexico              |
|Helen Harris      |Candidate Perdition   |2006-02-14 15:16:03.000|           |helen.harris@sakilacustomer.org      |419 Iligan Lane                      |990911107354|Bhopal               |India               |
|Angela Hernandez  |Canyon Stock          |2006-02-14 15:16:03.000|           |angela.hernandez@sakilacustomer.org  |786 Aurora Avenue                    |18461860151 |Shimonoseki          |Japan               |
|Dianne Shelton    |Cat Coneheads         |2006-02-14 15:16:03.000|           |dianne.shelton@sakilacustomer.org    |600 Bradford Street                  |117592274996|Tabriz               |Iran                |
|Willie Markham    |Center Dinosaur       |2006-02-14 15:16:03.000|           |willie.markham@sakilacustomer.org    |1623 Kingstown Drive                 |296394569728|Almirante Brown      |Argentina           |
|Mildred Bailey    |Chamber Italian       |2006-02-14 15:16:03.000|           |mildred.bailey@sakilacustomer.org    |81 Hodeida Way                       |250767749542|Jaipur               |India               |
|Gail Knight       |Chasing Fight         |2006-02-14 15:16:03.000|           |gail.knight@sakilacustomer.org       |185 Novi Sad Place                   |904253967161|Bern                 |Switzerland         |
|Gary Coy          |Chitty Lock           |2006-02-14 15:16:03.000|           |gary.coy@sakilacustomer.org          |867 Benin City Avenue                |168884817145|Yuzhou               |China               |
|Chris Brothers    |Cincinatti Whisperer  |2006-02-14 15:16:03.000|           |chris.brothers@sakilacustomer.org    |331 Bydgoszcz Parkway                |537374465982|Gijn                 |Spain               |
|Bill Gavin        |Cleopatra Devil       |2006-02-14 15:16:03.000|           |bill.gavin@sakilacustomer.org        |1485 Bratislava Place                |924663855568|Rockford             |United States       |
|Peggy Myers       |Club Graffiti         |2006-02-14 15:16:03.000|           |peggy.myers@sakilacustomer.org       |733 Mandaluyong Place                |196568435814|Abha                 |Saudi Arabia        |
|Florence Woods    |Club Graffiti         |2006-02-14 15:16:03.000|           |florence.woods@sakilacustomer.org    |1532 Dzerzinsk Way                   |330838016880|Merlo                |Argentina           |
|Emily Diaz        |Connection Microcosmos|2006-02-14 15:16:03.000|           |emily.diaz@sakilacustomer.org        |588 Vila Velha Manor                 |333339908719|Kimchon              |South Korea         |
|Rafael Abney      |Conversation Downhill |2006-02-14 15:16:03.000|           |rafael.abney@sakilacustomer.org      |48 Maracabo Place                    |82671830126 |Talavera             |Philippines         |
|Barry Lovelace    |Creatures Shakespeare |2006-02-14 15:16:03.000|           |barry.lovelace@sakilacustomer.org    |1836 Korla Parkway                   |689681677428|Kitwe                |Zambia              |
|Ivan Cromwell     |Creatures Shakespeare |2006-02-14 15:16:03.000|           |ivan.cromwell@sakilacustomer.org     |1351 Sousse Lane                     |203804046132|Monclova             |Mexico              |
|Dustin Gillette   |Crooked Frogmen       |2006-02-14 15:16:03.000|           |dustin.gillette@sakilacustomer.org   |1854 Okara Boulevard                 |131912793873|Emmen                |Netherlands         |
|Lucy Wheeler      |Curtain Videotape     |2006-02-14 15:16:03.000|           |lucy.wheeler@sakilacustomer.org      |624 Oshawa Boulevard                 |49677664184 |Balurghat            |India               |
|Allison Stanley   |Cyclone Family        |2006-02-14 15:16:03.000|           |allison.stanley@sakilacustomer.org   |754 Valencia Place                   |594319417514|Phnom Penh           |Cambodia            |
|Kyle Spurlock     |Dances None           |2006-02-14 15:16:03.000|           |kyle.spurlock@sakilacustomer.org     |1269 Botosani Manor                  |736517327853|Shanwei              |China               |
|Jessie Banks      |Dances None           |2006-02-14 15:16:03.000|           |jessie.banks@sakilacustomer.org      |1229 Valencia Parkway                |352679173732|Stara Zagora         |Bulgaria            |
|Yolanda Weaver    |Day Unfaithful        |2006-02-14 15:16:03.000|           |yolanda.weaver@sakilacustomer.org    |605 Rio Claro Parkway                |352469351088|Tabora               |Tanzania            |
|Margaret Moore    |Deep Crusade          |2006-02-14 15:16:03.000|           |margaret.moore@sakilacustomer.org    |613 Korolev Drive                    |380657522649|Masqat               |Oman                |
|Annette Olson     |Deer Virginian        |2006-02-14 15:16:03.000|           |annette.olson@sakilacustomer.org     |431 Xiangtan Avenue                  |230250973122|Allappuzha (Alleppey)|India               |
|Stacey Montgomery |Details Packer        |2006-02-14 15:16:03.000|           |stacey.montgomery@sakilacustomer.org |1333 Haldia Street                   |408304391718|Fuyu                 |China               |
|Lee Hawks         |Detective Vision      |2006-02-14 15:16:03.000|           |lee.hawks@sakilacustomer.org         |1661 Abha Drive                      |270456873752|Pudukkottai          |India               |
|Perry Swafford    |Devil Desire          |2006-02-14 15:16:03.000|           |perry.swafford@sakilacustomer.org    |773 Dallas Manor                     |914466027044|Quilmes              |Argentina           |
|Milton Howland    |Disciple Mother       |2006-02-14 15:16:03.000|           |milton.howland@sakilacustomer.org    |758 Korolev Parkway                  |441628280920|Vijayawada           |India               |
|Sarah Lewis       |Divine Resurrection   |2006-02-14 15:16:03.000|           |sarah.lewis@sakilacustomer.org       |1780 Hino Boulevard                  |902731229323|Liepaja              |Latvia              |
|Judith Cox        |Doors President       |2006-02-14 15:16:03.000|           |judith.cox@sakilacustomer.org        |1966 Amroha Avenue                   |333489324603|Daxian               |China               |
|Wanda Patterson   |Doors President       |2006-02-14 15:16:03.000|           |wanda.patterson@sakilacustomer.org   |1740 Portoviejo Avenue               |198123170793|Sincelejo            |Colombia            |
|Grace Ellis       |Dragonfly Strangers   |2006-02-14 15:16:03.000|           |grace.ellis@sakilacustomer.org       |442 Rae Bareli Place                 |886636413768|Duisburg             |Germany             |
|Mattie Hoffman    |Drifter Commandments  |2006-02-14 15:16:03.000|           |mattie.hoffman@sakilacustomer.org    |1497 Yuzhou Drive                    |246810237916|London               |United Kingdom      |
|Courtney Day      |Driver Annie          |2006-02-14 15:16:03.000|           |courtney.day@sakilacustomer.org      |300 Junan Street                     |890289150158|Uijongbu             |South Korea         |
|Michelle Clark    |Dwarfs Alter          |2006-02-14 15:16:03.000|           |michelle.clark@sakilacustomer.org    |262 A Corua (La Corua) Parkway       |892775750063|Tangail              |Bangladesh          |
|Mario Cheatham    |Eagles Panky          |2006-02-14 15:16:03.000|           |mario.cheatham@sakilacustomer.org    |1924 Shimonoseki Drive               |406784385440|Batna                |Algeria             |
|Hilda Hopkins     |Earth Vision          |2006-02-14 15:16:03.000|           |hilda.hopkins@sakilacustomer.org     |1831 Nam Dinh Loop                   |322888976727|Mandaluyong          |Philippines         |
|Jeanette Greene   |Effect Gladiator      |2006-02-14 15:16:03.000|           |jeanette.greene@sakilacustomer.org   |1077 San Felipe de Puerto Plata Place|812824036424|Novoterkassk         |Russian Federation  |
|Claudia Fuller    |Encino Elf            |2006-02-14 15:16:03.000|           |claudia.fuller@sakilacustomer.org    |346 Skikda Parkway                   |630424482919|Jalib al-Shuyukh     |Kuwait              |
|Guy Brownlee      |Enough Raging         |2006-02-14 15:16:03.000|           |guy.brownlee@sakilacustomer.org      |346 Cam Ranh Avenue                  |978430786151|Zhoushan             |China               |
|Elmer Noe         |Falcon Volume         |2006-02-14 15:16:03.000|           |elmer.noe@sakilacustomer.org         |1768 Udine Loop                      |448876499197|Battambang           |Cambodia            |
|Terry Grissom     |Family Sweet          |2006-02-14 15:16:03.000|           |terry.grissom@sakilacustomer.org     |619 Hunuco Avenue                    |142596392389|Matsue               |Japan               |
|Miguel Betancourt |Family Sweet          |2006-02-14 15:16:03.000|           |miguel.betancourt@sakilacustomer.org |319 Springs Loop                     |72524459905 |Erlangen             |Germany             |
|Leonard Schofield |Fight Jawbreaker      |2006-02-14 15:16:03.000|           |leonard.schofield@sakilacustomer.org |88 Nagaon Manor                      |779461480495|Tandil               |Argentina           |
|Gwendolyn May     |Flying Hook           |2006-02-14 15:16:03.000|           |gwendolyn.may@sakilacustomer.org     |446 Kirovo-Tepetsk Lane              |303967439816|Higashiosaka         |Japan               |
|Marion Snyder     |Forrester Comancheros |2006-02-14 15:16:03.000|           |marion.snyder@sakilacustomer.org     |1891 Rizhao Boulevard                |391065549876|Santa Brbara dOeste  |Brazil              |
|Sonia Gregory     |Frida Slipper         |2006-02-14 15:16:03.000|           |sonia.gregory@sakilacustomer.org     |1279 Udine Parkway                   |195003555232|Benin City           |Nigeria             |
|Louise Jenkins    |Frisco Forrest        |2006-02-14 15:16:03.000|           |louise.jenkins@sakilacustomer.org    |929 Tallahassee Loop                 |800716535041|Springs              |South Africa        |
|Zachary Hite      |Frost Head            |2006-02-14 15:16:03.000|           |zachary.hite@sakilacustomer.org      |98 Pyongyang Boulevard               |191958435142|Akron                |United States       |
|Elizabeth Brown   |Gables Metropolis     |2006-02-14 15:16:03.000|           |elizabeth.brown@sakilacustomer.org   |53 Idfu Parkway                      |10655648674 |Nantou               |Taiwan              |
|Freddie Duggan    |Ghost Groundhog       |2006-02-14 15:16:03.000|           |freddie.duggan@sakilacustomer.org    |1103 Quilmes Boulevard               |644021380889|Sullana              |Peru                |
|Bill Gavin        |Gleaming Jawbreaker   |2006-02-14 15:16:03.000|           |bill.gavin@sakilacustomer.org        |1485 Bratislava Place                |924663855568|Rockford             |United States       |
|Curtis Irby       |Gorgeous Bingo        |2006-02-14 15:16:03.000|           |curtis.irby@sakilacustomer.org       |432 Garden Grove Street              |615964523510|Richmond Hill        |Canada              |
|Scott Shelley     |Grail Frankenstein    |2006-02-14 15:16:03.000|           |scott.shelley@sakilacustomer.org     |587 Benguela Manor                   |165450987037|Aurora               |United States       |
|Allison Stanley   |Grapes Fury           |2006-02-14 15:16:03.000|           |allison.stanley@sakilacustomer.org   |754 Valencia Place                   |594319417514|Phnom Penh           |Cambodia            |
|Betty White       |Groundhog Uncut       |2006-02-14 15:16:03.000|           |betty.white@sakilacustomer.org       |770 Bydgoszcz Avenue                 |517338314235|Citrus Heights       |United States       |
|Jerry Jordon      |Gunfight Moon         |2006-02-14 15:16:03.000|           |jerry.jordon@sakilacustomer.org      |124 al-Manama Way                    |647899404952|Onomichi             |Japan               |
|Enrique Forsythe  |Gunfight Moon         |2006-02-14 15:16:03.000|           |enrique.forsythe@sakilacustomer.org  |1101 Bucuresti Boulevard             |199514580428|Patras               |Greece              |
|Christian Jung    |Half Outfield         |2006-02-14 15:16:03.000|           |christian.jung@sakilacustomer.org    |949 Allende Lane                     |122981120653|Amroha               |India               |
|Lawrence Lawton   |Half Outfield         |2006-02-14 15:16:03.000|           |lawrence.lawton@sakilacustomer.org   |114 Jalib al-Shuyukh Manor           |845378657301|Yaound               |Cameroon            |
|Ana Bradley       |Happiness United      |2006-02-14 15:16:03.000|           |ana.bradley@sakilacustomer.org       |682 Garden Grove Place               |72136330362 |Memphis              |United States       |
|Norman Currier    |Harry Idaho           |2006-02-14 15:16:03.000|           |norman.currier@sakilacustomer.org    |1445 Carmen Parkway                  |598912394463|Cianjur              |Indonesia           |
|Laurie Lawrence   |Haunted Antitrust     |2006-02-14 15:16:03.000|           |laurie.lawrence@sakilacustomer.org   |9 San Miguel de Tucumn Manor         |956188728558|Firozabad            |India               |
|Cathy Spencer     |Holes Brannigan       |2006-02-14 15:16:03.000|           |cathy.spencer@sakilacustomer.org     |1287 Xiangfan Boulevard              |819416131190|Kakamigahara         |Japan               |
|Tom Milner        |Hunchback Impossible  |2006-02-14 15:16:03.000|           |tom.milner@sakilacustomer.org        |535 Ahmadnagar Manor                 |985109775584|Abu Dhabi            |United Arab Emirates|
|Gregory Mauldin   |Hunger Roof           |2006-02-14 15:16:03.000|           |gregory.mauldin@sakilacustomer.org   |507 Smolensk Loop                    |80303246192 |Sousse               |Tunisia             |
|Gail Knight       |Hyde Doctor           |2006-02-14 15:16:03.000|           |gail.knight@sakilacustomer.org       |185 Novi Sad Place                   |904253967161|Bern                 |Switzerland         |
|Gloria Cook       |Igby Maker            |2006-02-14 15:16:03.000|           |gloria.cook@sakilacustomer.org       |1668 Saint Louis Place               |347487831378|Papeete              |French Polynesia    |
|Lawrence Lawton   |Insects Stone         |2006-02-14 15:16:03.000|           |lawrence.lawton@sakilacustomer.org   |114 Jalib al-Shuyukh Manor           |845378657301|Yaound               |Cameroon            |
|Ramona Hale       |Insider Arizona       |2006-02-14 15:16:03.000|           |ramona.hale@sakilacustomer.org       |951 Stara Zagora Manor               |429925609431|Patiala              |India               |
|Jessie Milam      |Insider Arizona       |2006-02-14 15:16:03.000|           |jessie.milam@sakilacustomer.org      |1332 Gaziantep Lane                  |383353187467|Binzhou              |China               |
|Melanie Armstrong |Intentions Empire     |2006-02-14 15:16:03.000|           |melanie.armstrong@sakilacustomer.org |1166 Changhwa Street                 |650752094490|Bayugan              |Philippines         |
|Marilyn Ross      |Intentions Empire     |2006-02-14 15:16:03.000|           |marilyn.ross@sakilacustomer.org      |1888 Kabul Drive                     |701457319790|Ife                  |Nigeria             |
|Jay Robb          |Intrigue Worst        |2006-02-14 15:16:03.000|           |jay.robb@sakilacustomer.org          |1947 Paarl Way                       |834061016202|Surakarta            |Indonesia           |
|Cory Meehan       |Jason Trap            |2006-02-14 15:16:03.000|           |cory.meehan@sakilacustomer.org       |556 Asuncin Way                      |338244023543|Mogiljov             |Belarus             |
|Joshua Mark       |Juggler Hardly        |2006-02-14 15:16:03.000|           |joshua.mark@sakilacustomer.org       |1920 Weifang Avenue                  |869507847714|Rampur               |India               |
|Terrance Roush    |Kick Savannah         |2006-02-14 15:16:03.000|           |terrance.roush@sakilacustomer.org    |42 Fontana Avenue                    |437829801725|Szkesfehrvr          |Hungary             |
|Felix Gaffney     |Lady Stage            |2006-02-14 15:16:03.000|           |felix.gaffney@sakilacustomer.org     |1059 Yuncheng Avenue                 |107092893983|Vilnius              |Lithuania           |
|Heather Morris    |Lawless Vision        |2006-02-14 15:16:03.000|           |heather.morris@sakilacustomer.org    |17 Kabul Boulevard                   |697760867968|Nagareyama           |Japan               |
|Tamara Nguyen     |Loathing Legally      |2006-02-14 15:16:03.000|           |tamara.nguyen@sakilacustomer.org     |356 Olomouc Manor                    |22326410776 |Anpolis              |Brazil              |
|Brent Harkins     |Lord Arizona          |2006-02-14 15:16:03.000|           |brent.harkins@sakilacustomer.org     |319 Plock Parkway                    |854259976812|Sultanbeyli          |Turkey              |
|Joel Francisco    |Lovely Jingle         |2006-02-14 15:16:03.000|           |joel.francisco@sakilacustomer.org    |287 Cuautla Boulevard                |82619513349 |Sucre                |Bolivia             |
|Margie Wade       |Lust Lock             |2006-02-14 15:16:03.000|           |margie.wade@sakilacustomer.org       |1762 Paarl Parkway                   |192459639410|Lengshuijiang        |China               |
|Tammy Sanders     |Lust Lock             |2006-02-14 15:16:03.000|           |tammy.sanders@sakilacustomer.org     |1551 Rampur Lane                     |251164340471|Changhwa             |Taiwan              |
|Lauren Hudson     |Midnight Westward     |2006-02-14 15:16:03.000|           |lauren.hudson@sakilacustomer.org     |1740 Le Mans Loop                    |168476538960|Le Mans              |France              |
|Elmer Noe         |Minority Kiss         |2006-02-14 15:16:03.000|           |elmer.noe@sakilacustomer.org         |1768 Udine Loop                      |448876499197|Battambang           |Cambodia            |
|Ian Still         |Mockingbird Hollywood |2006-02-14 15:16:03.000|           |ian.still@sakilacustomer.org         |1894 Boa Vista Way                   |239357986667|Garland              |United States       |
|Katie Elliott     |Monster Spartacus     |2006-02-14 15:16:03.000|           |katie.elliott@sakilacustomer.org     |447 Surakarta Loop                   |940830176580|Kisumu               |Kenya               |
|Colleen Burton    |Moonwalker Fool       |2006-02-14 15:16:03.000|           |colleen.burton@sakilacustomer.org    |430 Alessandria Loop                 |669828224459|Saarbrcken           |Germany             |
|Derrick Bourque   |Mosquito Armageddon   |2006-02-14 15:16:03.000|           |derrick.bourque@sakilacustomer.org   |1153 Allende Way                     |856872225376|Gatineau             |Canada              |
|Christine Roberts |Motions Details       |2006-02-14 15:16:03.000|           |christine.roberts@sakilacustomer.org |1447 Imus Way                        |539758313890|Faaa                 |French Polynesia    |
|Jordan Archuleta  |Movie Shakespeare     |2006-02-14 15:16:03.000|           |jordan.archuleta@sakilacustomer.org  |1229 Varanasi (Benares) Manor        |817740355461|Avellaneda           |Argentina           |
|Allen Butterfield |Mulan Moon            |2006-02-14 15:16:03.000|           |allen.butterfield@sakilacustomer.org |791 Salinas Street                   |129953030512|Hoshiarpur           |India               |
|Jeanne Lawson     |Mulholland Beast      |2006-02-14 15:16:03.000|           |jeanne.lawson@sakilacustomer.org     |387 Mwene-Ditu Drive                 |764477681869|Ashgabat             |Turkmenistan        |
|Craig Morrell     |Mummy Creatures       |2006-02-14 15:16:03.000|           |craig.morrell@sakilacustomer.org     |717 Changzhou Lane                   |426255288071|Cavite               |Philippines         |
|Stacy Cunningham  |Name Detective        |2006-02-14 15:16:03.000|           |stacy.cunningham@sakilacustomer.org  |1410 Benin City Parkway              |104150372603|Pereira              |Colombia            |
|Juanita Mason     |None Spiking          |2006-02-14 15:16:03.000|           |juanita.mason@sakilacustomer.org     |943 Johannesburg Avenue              |90921003005 |Pune                 |India               |
|Kenneth Gooden    |Operation Operation   |2006-02-14 15:16:03.000|           |kenneth.gooden@sakilacustomer.org    |1542 Lubumbashi Boulevard            |508800331065|Bat Yam              |Israel              |
|Sylvia Ortiz      |Opposite Necklace     |2006-02-14 15:16:03.000|           |sylvia.ortiz@sakilacustomer.org      |241 Mosul Lane                       |765345144779|Dos Quebradas        |Colombia            |
|April Burns       |Outfield Massacre     |2006-02-14 15:16:03.000|           |april.burns@sakilacustomer.org       |483 Ljubertsy Parkway                |581174211853|Dundee               |United Kingdom      |
|John Farnsworth   |Outlaw Hanky          |2006-02-14 15:16:03.000|           |john.farnsworth@sakilacustomer.org   |41 El Alto Parkway                   |51917807050 |Parbhani             |India               |
|Heather Morris    |Peach Innocent        |2006-02-14 15:16:03.000|           |heather.morris@sakilacustomer.org    |17 Kabul Boulevard                   |697760867968|Nagareyama           |Japan               |
|Margie Wade       |Philadelphia Wife     |2006-02-14 15:16:03.000|           |margie.wade@sakilacustomer.org       |1762 Paarl Parkway                   |192459639410|Lengshuijiang        |China               |
|Jordan Archuleta  |Pianist Outfield      |2006-02-14 15:16:03.000|           |jordan.archuleta@sakilacustomer.org  |1229 Varanasi (Benares) Manor        |817740355461|Avellaneda           |Argentina           |
|Annette Olson     |Pirates Roxanne       |2006-02-14 15:16:03.000|           |annette.olson@sakilacustomer.org     |431 Xiangtan Avenue                  |230250973122|Allappuzha (Alleppey)|India               |
|Christine Roberts |Pollock Deliverance   |2006-02-14 15:16:03.000|           |christine.roberts@sakilacustomer.org |1447 Imus Way                        |539758313890|Faaa                 |French Polynesia    |
|Daisy Bates       |Pride Alamo           |2006-02-14 15:16:03.000|           |daisy.bates@sakilacustomer.org       |661 Chisinau Lane                    |816436065431|Kolpino              |Russian Federation  |
|Cassandra Walters |Princess Giant        |2006-02-14 15:16:03.000|           |cassandra.walters@sakilacustomer.org |920 Kumbakonam Loop                  |685010736240|Salinas              |United States       |
|Larry Thrasher    |Pulp Beverly          |2006-02-14 15:16:03.000|           |larry.thrasher@sakilacustomer.org    |663 Baha Blanca Parkway              |834418779292|Adana                |Turkey              |
|Darryl Ashcraft   |Pure Runner           |2006-02-14 15:16:03.000|           |darryl.ashcraft@sakilacustomer.org   |166 Jinchang Street                  |717566026669|Ezeiza               |Argentina           |
|Bernard Colby     |Queen Luke            |2006-02-14 15:16:03.000|           |bernard.colby@sakilacustomer.org     |495 Bhimavaram Lane                  |82088937724 |Dhule (Dhulia)       |India               |
|Jean Bell         |Ridgemont Submarine   |2006-02-14 15:16:03.000|           |jean.bell@sakilacustomer.org         |1114 Liepaja Street                  |212869228936|Kuching              |Malaysia            |
|Carolyn Perez     |River Outlaw          |2006-02-14 15:16:03.000|           |carolyn.perez@sakilacustomer.org     |1632 Bislig Avenue                   |471675840679|Pak Kret             |Thailand            |
|Clinton Buford    |Scarface Bang         |2006-02-14 15:16:03.000|           |clinton.buford@sakilacustomer.org    |43 Vilnius Manor                     |484500282381|Aurora               |United States       |
|Travis Estep      |Seabiscuit Punk       |2006-02-14 15:16:03.000|           |travis.estep@sakilacustomer.org      |289 Santo Andr Manor                 |214976066017|al-Qatif             |Saudi Arabia        |
|Lucy Wheeler      |Seattle Expecations   |2006-02-14 15:16:03.000|           |lucy.wheeler@sakilacustomer.org      |624 Oshawa Boulevard                 |49677664184 |Balurghat            |India               |
|Viola Hanson      |Shawshank Bubble      |2006-02-14 15:16:03.000|           |viola.hanson@sakilacustomer.org      |582 Papeete Loop                     |569868543137|Lapu-Lapu            |Philippines         |
|Adrian Clary      |Shock Cabin           |2006-02-14 15:16:03.000|           |adrian.clary@sakilacustomer.org      |1986 Sivas Place                     |182059202712|Udine                |Italy               |
|Stephanie Mitchell|Shock Cabin           |2006-02-14 15:16:03.000|           |stephanie.mitchell@sakilacustomer.org|42 Brindisi Place                    |42384721397 |Yerevan              |Armenia             |
|Beverly Brooks    |Shrek License         |2006-02-14 15:16:03.000|           |beverly.brooks@sakilacustomer.org    |1947 Poos de Caldas Boulevard        |427454485876|Chiayi               |Taiwan              |
|Gilbert Sledge    |Silverado Goldfinger  |2006-02-14 15:16:03.000|           |gilbert.sledge@sakilacustomer.org    |1515 Korla Way                       |959467760895|York                 |United Kingdom      |
|Norma Gonzales    |Sleeping Suspects     |2006-02-14 15:16:03.000|           |norma.gonzales@sakilacustomer.org    |152 Kitwe Parkway                    |835433605312|Bislig               |Philippines         |
|Alicia Mills      |Sleepless Monsoon     |2006-02-14 15:16:03.000|           |alicia.mills@sakilacustomer.org      |1963 Moscow Place                    |761379480249|Nagaon               |India               |
|Tammy Sanders     |Sleepy Japanese       |2006-02-14 15:16:03.000|           |tammy.sanders@sakilacustomer.org     |1551 Rampur Lane                     |251164340471|Changhwa             |Taiwan              |
|Helen Harris      |Smoking Barbarella    |2006-02-14 15:16:03.000|           |helen.harris@sakilacustomer.org      |419 Iligan Lane                      |990911107354|Bhopal               |India               |
|Raymond Mcwhorter |Smoochy Control       |2006-02-14 15:16:03.000|           |raymond.mcwhorter@sakilacustomer.org |503 Sogamoso Loop                    |834626715837|Sumqayit             |Azerbaijan          |
|Charlie Bess      |Song Hedwig           |2006-02-14 15:16:03.000|           |charlie.bess@sakilacustomer.org      |362 Rajkot Lane                      |962020153680|Baiyin               |China               |
|Cathy Spencer     |Sons Interview        |2006-02-14 15:16:03.000|           |cathy.spencer@sakilacustomer.org     |1287 Xiangfan Boulevard              |819416131190|Kakamigahara         |Japan               |
|Wendy Harrison    |Sons Interview        |2006-02-14 15:16:03.000|           |wendy.harrison@sakilacustomer.org    |1107 Nakhon Sawan Avenue             |867546627903|Nezahualcyotl        |Mexico              |
|Holly Fox         |South Wait            |2006-02-14 15:16:03.000|           |holly.fox@sakilacustomer.org         |435 0 Way                            |760171523969|Haldia               |India               |
|Kristin Johnston  |Star Operation        |2006-02-14 15:16:03.000|           |kristin.johnston@sakilacustomer.org  |226 Brest Manor                      |785881412500|Sunnyvale            |United States       |
|Miguel Betancourt |State Wasteland       |2006-02-14 15:16:03.000|           |miguel.betancourt@sakilacustomer.org |319 Springs Loop                     |72524459905 |Erlangen             |Germany             |
|Daryl Larue       |Streak Ridgemont      |2006-02-14 15:16:03.000|           |daryl.larue@sakilacustomer.org       |1208 Tama Loop                       |954786054144|Mosul                |Iraq                |
|Roland South      |Suit Walls            |2006-02-14 15:16:03.000|           |roland.south@sakilacustomer.org      |1993 0 Loop                          |25865528181 |Yingkou              |China               |
|Laura Rodriguez   |Suit Walls            |2006-02-14 15:16:03.000|           |laura.rodriguez@sakilacustomer.org   |28 Charlotte Amalie Street           |161968374323|Sal                  |Morocco             |
|Judy Gray         |Summer Scarface       |2006-02-14 15:16:03.000|           |judy.gray@sakilacustomer.org         |1031 Daugavpils Parkway              |107137400143|Bchar                |Algeria             |
|Allan Cornish     |Sundance Invasion     |2006-02-14 15:16:03.000|           |allan.cornish@sakilacustomer.org     |947 Trshavn Place                    |50898428626 |Tarlac               |Philippines         |
|Cynthia Young     |Suspects Quills       |2006-02-14 15:16:03.000|           |cynthia.young@sakilacustomer.org     |1425 Shikarpur Manor                 |678220867005|Munger (Monghyr)     |India               |
|Vickie Brewer     |Swarm Gold            |2006-02-14 15:16:03.000|           |vickie.brewer@sakilacustomer.org     |1966 Tonghae Street                  |567359279425|Halle/Saale          |Germany             |
|Natalie Meyer     |Sweden Shining        |2006-02-14 15:16:03.000|           |natalie.meyer@sakilacustomer.org     |1201 Qomsheh Manor                   |873492228462|Aparecida de Goinia  |Brazil              |
|Fred Wheat        |Sweethearts Suspects  |2006-02-14 15:16:03.000|           |fred.wheat@sakilacustomer.org        |433 Florencia Street                 |561729882725|Jurez                |Mexico              |
|Cassandra Walters |Theory Mermaid        |2006-02-14 15:16:03.000|           |cassandra.walters@sakilacustomer.org |920 Kumbakonam Loop                  |685010736240|Salinas              |United States       |
|Morris Mccarter   |Titanic Boondock      |2006-02-14 15:16:03.000|           |morris.mccarter@sakilacustomer.org   |1568 Celaya Parkway                  |278669994384|Fengshan             |Taiwan              |
|Justin Ngo        |Titanic Boondock      |2006-02-14 15:16:03.000|           |justin.ngo@sakilacustomer.org        |519 Nyeri Manor                      |764680915323|Santo Andr           |Brazil              |
|Willie Howell     |Titans Jerk           |2006-02-14 15:16:03.000|           |willie.howell@sakilacustomer.org     |1244 Allappuzha (Alleppey) Place     |991802825778|Vicente Lpez         |Argentina           |
|Carolyn Perez     |Torque Bound          |2006-02-14 15:16:03.000|           |carolyn.perez@sakilacustomer.org     |1632 Bislig Avenue                   |471675840679|Pak Kret             |Thailand            |
|Julie Sanchez     |Trading Pinocchio     |2006-02-14 15:16:03.000|           |julie.sanchez@sakilacustomer.org     |939 Probolinggo Loop                 |680428310138|A Corua (La Corua)   |Spain               |
|Justin Ngo        |Trojan Tomorrow       |2006-02-14 15:16:03.000|           |justin.ngo@sakilacustomer.org        |519 Nyeri Manor                      |764680915323|Santo Andr           |Brazil              |
|Tammy Sanders     |Trouble Date          |2006-02-14 15:16:03.000|           |tammy.sanders@sakilacustomer.org     |1551 Rampur Lane                     |251164340471|Changhwa             |Taiwan              |
|Andy Vanhorn      |Tuxedo Mile           |2006-02-14 15:16:03.000|           |andy.vanhorn@sakilacustomer.org      |966 Asuncin Way                      |995527378381|Huejutla de Reyes    |Mexico              |
|Morris Mccarter   |Vanished Garden       |2006-02-14 15:16:03.000|           |morris.mccarter@sakilacustomer.org   |1568 Celaya Parkway                  |278669994384|Fengshan             |Taiwan              |
|Alberto Henning   |Vanishing Rocky       |2006-02-14 15:16:03.000|           |alberto.henning@sakilacustomer.org   |502 Mandi Bahauddin Parkway          |618156722572|Barcelona            |Venezuela           |
|Albert Crouse     |Varsity Trip          |2006-02-14 15:16:03.000|           |albert.crouse@sakilacustomer.org     |1641 Changhwa Place                  |256546485220|Bamenda              |Cameroon            |
|Becky Miles       |Virginian Pluto       |2006-02-14 15:16:03.000|           |becky.miles@sakilacustomer.org       |1993 Tabuk Lane                      |648482415405|Tambaram             |India               |
|Jenny Castro      |Volcano Texas         |2006-02-14 15:16:03.000|           |jenny.castro@sakilacustomer.org      |1405 Chisinau Place                  |62781725285 |Ponce                |Puerto Rico         |
|Greg Robins       |Wanda Chamber         |2006-02-14 15:16:03.000|           |greg.robins@sakilacustomer.org       |1786 Salinas Place                   |206060652238|Nam Dinh             |Vietnam             |
|Regina Berry      |Wedding Apollo        |2006-02-14 15:16:03.000|           |regina.berry@sakilacustomer.org      |475 Atinsk Way                       |201705577290|Jinchang             |China               |
|Naomi Jennings    |Wild Apollo           |2006-02-14 15:16:03.000|           |naomi.jennings@sakilacustomer.org    |1884 Shikarpur Avenue                |959949395183|Karnal               |India               |
|Jeremy Hurtado    |Window Side           |2006-02-14 15:16:03.000|           |jeremy.hurtado@sakilacustomer.org    |1133 Rizhao Avenue                   |600264533987|Vitria de Santo Anto |Brazil              |
|Natalie Meyer     |Women Dorado          |2006-02-14 15:16:03.000|           |natalie.meyer@sakilacustomer.org     |1201 Qomsheh Manor                   |873492228462|Aparecida de Goinia  |Brazil              |
|Neil Renner       |World Leathernecks    |2006-02-14 15:16:03.000|           |neil.renner@sakilacustomer.org       |1817 Livorno Way                     |478380208348|Cam Ranh             |Vietnam             |
|Louis Leone       |Zhivago Core          |2006-02-14 15:16:03.000|           |louis.leone@sakilacustomer.org       |1191 Tandil Drive                    |45554316010 |Tanauan              |Philippines         |


### Insights:
This table above shows all the customers that have not returned their DvD back to the industry.

The reason why this happened is because most of the customers did not know their return date.

The industry should try to update the data by putting the treturn date to where it is empty.


# Conclusions:

**Genre Diversity and Customer Preferences:**

* The DVD rental industry caters to a diverse audience, offering a wide range of 16 unique genres. This diversity is a positive sign as it accommodates various customer preferences.

**Genre Performance:**

* The sports genre stands out as the top performer, with the highest rental count and total sales revenue. It's crucial to recognize and leverage this genre's popularity for marketing and content acquisition.

* Conversely, the music genre lags behind in rentals and revenue, indicating room for improvement. Strategies to enhance the selection and promotion of music-related content could boost rentals and sales.

* Animation, action, and sci-fi genres also perform well. These genres deserve special attention for maximizing revenue potential.

* Genres like classics and music have potential for improvement. Strategies to increase their appeal, such as exclusive content or targeted marketing, could be explored.

**Consumer Behavior and Price Sensitivity:**

* Rental decisions are influenced by factors beyond the average rental rate, highlighting the significance of genre preference, content availability, and personal interests in consumer behavior.

**Store Performance:**

* The data provides a month-by-month comparison of rental order processing for two stores. It's evident that both stores experience fluctuations in rental order volumes, and understanding these patterns can inform inventory and staffing decisions.

**Customer DVD Returns:**

* The table lists customers who have not returned DVDs, primarily due to missing return dates. To address this, updating the data with return dates can help ensure timely returns.

**Overall Strategy:**

These conclusions emphasize the need for a strategic approach that considers customer preferences, genre performance, and store dynamics. Leveraging popular genres, optimizing content catalogs, and addressing missing data are all essential steps in maximizing revenue and customer satisfaction in the DVD rental industry.


## Recommendation:

**Genre Recommendations:**

* **Promote Sports Content:** Given the popularity of the sports genre, consider investing in more sports-related content, including live events, documentaries, and classic games. Create targeted marketing campaigns around major sporting events to attract sports enthusiasts.

* **Revitalize Music Category:** To improve the music genre's performance, expand the music selection, including concerts, music documentaries, and artist biopics. Implement specialized music promotions and discounts to entice customers.

* **Leverage Animation and Sci-Fi:** As animation and sci-fi genres perform well, continue to acquire high-quality content in these areas. Consider exclusive releases or themed promotions to cater to fans of these genres.

* **Revisit Classic Films:** Classics have enduring appeal. Curate a collection of timeless classics from various eras and promote them to cinephiles. Highlight the historical and artistic value of classic films in marketing campaigns.

**Consumer Behavior and Price Sensitivity:**

* **Personalized Recommendations:** Implement a recommendation system that factors in customer preferences beyond just genre. Analyze viewing history and use machine learning algorithms to suggest movies tailored to individual tastes.

**Store Performance:**

* **Inventory Management:** Based on the historical order processing data, optimize inventory management. Ensure popular genres are well-stocked during peak months, and consider offering promotions during slower periods to boost rentals.

* **Staffing Adjustments:** Align staffing levels with the expected order volumes. During peak months, hire temporary staff to handle increased demand, while scaling back during slower months to control costs.

**Customer DVD Returns:**

* **Data Integrity:** Ensure that return dates are consistently recorded for all rentals. Implement a reminder system to notify customers of upcoming return deadlines, reducing the number of late returns.

* **Late Return Policies:** Consider implementing a fair late return policy that takes into account factors beyond the customer's control, such as shipping delays. Offer incentives for on-time returns, such as discounts on future rentals.

**Overall Strategy:**

* **Customer Engagement:** Invest in customer engagement initiatives, such as loyalty programs, exclusive previews, or bonus content for repeat customers. Make it rewarding for customers to return and rent more movies.

* **Market Expansion:** Explore opportunities to expand into countries with smaller customer bases but growth potential. Tailor content offerings to suit local preferences and establish a strong online presence.

* **Analytics and Feedback:** Continuously monitor customer behavior, rental patterns, and feedback. Use data analytics to make data-driven decisions regarding content acquisition, marketing strategies, and inventory management.

* **Content Quality:** Focus on acquiring high-quality, critically acclaimed movies across genres. Quality content can drive customer satisfaction and encourage repeat business.

These recommendations aim to enhance the DVD rental industry's performance by optimizing content, improving customer engagement, and refining operational strategies to meet market demands effectively.
