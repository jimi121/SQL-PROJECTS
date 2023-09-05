# Sales Data Explortory
## Questions and Answers

#### 1. Provide table that shows the sales representatives' regions and their associated accounts specifically for the Midwest region?

```sql
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
```

### **Results:**
|rep_name             |region |account_name                     |
|---------------------|-------|---------------------------------|
|Chau Rowles          |Midwest|Abbott Laboratories              |
|Julie Starr          |Midwest|AbbVie                           |
|Cliff Meints         |Midwest|Aflac                            |
|Chau Rowles          |Midwest|Alcoa                            |
|Charles Bidwell      |Midwest|Altria Group                     |
|Delilah Krum         |Midwest|Amgen                            |
|Charles Bidwell      |Midwest|Arrow Electronics                |
|Delilah Krum         |Midwest|AutoNation                       |
|Delilah Krum         |Midwest|Capital One Financial            |
|Cordell Rieder       |Midwest|Centene                          |
|Sherlene Wetherington|Midwest|Community Health Systems         |
|Delilah Krum         |Midwest|Cummins                          |
|Carletta Kosinski    |Midwest|Danaher                          |
|Carletta Kosinski    |Midwest|Dollar General                   |
|Cordell Rieder       |Midwest|Duke Energy                      |
|Cliff Meints         |Midwest|Eli Lilly                        |
|Kathleen Lalonde     |Midwest|EMC                              |
|Charles Bidwell      |Midwest|Emerson Electric                 |
|Chau Rowles          |Midwest|Halliburton                      |
|Delilah Krum         |Midwest|Hartford Financial Services Group|
|Carletta Kosinski    |Midwest|International Paper              |
|Delilah Krum         |Midwest|Kimberly-Clark                   |
|Cordell Rieder       |Midwest|Kohl's                           |
|Kathleen Lalonde     |Midwest|Kraft Heinz                      |
|Julie Starr          |Midwest|Lear                             |
|Julie Starr          |Midwest|ManpowerGroup                    |
|Carletta Kosinski    |Midwest|McDonald's                       |
|Carletta Kosinski    |Midwest|Northrop Grumman                 |
|Cliff Meints         |Midwest|Paccar                           |
|Kathleen Lalonde     |Midwest|Penske Automotive Group          |
|Delilah Krum         |Midwest|Plains GP Holdings               |
|Sherlene Wetherington|Midwest|Progressive                      |
|Charles Bidwell      |Midwest|Qualcomm                         |
|Cliff Meints         |Midwest|Raytheon                         |
|Sherlene Wetherington|Midwest|Rite Aid                         |
|Cliff Meints         |Midwest|Sears Holdings                   |
|Delilah Krum         |Midwest|Southwest Airlines               |
|Chau Rowles          |Midwest|Staples                          |
|Charles Bidwell      |Midwest|Starbucks                        |
|Chau Rowles          |Midwest|Tech Data                        |
|Charles Bidwell      |Midwest|Tenet Healthcare                 |
|Sherlene Wetherington|Midwest|Time Warner Cable                |
|Sherlene Wetherington|Midwest|U.S. Bancorp                     |
|Cliff Meints         |Midwest|Union Pacific                    |
|Kathleen Lalonde     |Midwest|US Foods Holding                 |
|Julie Starr          |Midwest|USAA                             |
|Charles Bidwell      |Midwest|Whirlpool                        |
|Cliff Meints         |Midwest|Xerox                            |



#### 2. Provide a table that displays the regions for each sales representative along with their associated accounts, specifically for sales representatives whose first names start with 'S' and who are located in the Midwest region? 

 ```sql
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
```

### Results:
|rep_name             |region |account_name            |
|---------------------|-------|------------------------|
|Sherlene Wetherington|Midwest|Community Health Systems|
|Sherlene Wetherington|Midwest|Progressive             |
|Sherlene Wetherington|Midwest|Rite Aid                |
|Sherlene Wetherington|Midwest|Time Warner Cable       |
|Sherlene Wetherington|Midwest|U.S. Bancorp            |


#### 3. Provide a table that shows the region for each sales_rep along with their associated accounts. Where the sales rep has a last name starting with K and in the Midwest region.

```sql
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
```


### Results:
|rep_name         |region |account_name                     |
|-----------------|-------|---------------------------------|
|Delilah Krum     |Midwest|Amgen                            |
|Delilah Krum     |Midwest|AutoNation                       |
|Delilah Krum     |Midwest|Capital One Financial            |
|Delilah Krum     |Midwest|Cummins                          |
|Carletta Kosinski|Midwest|Danaher                          |
|Carletta Kosinski|Midwest|Dollar General                   |
|Delilah Krum     |Midwest|Hartford Financial Services Group|
|Carletta Kosinski|Midwest|International Paper              |
|Delilah Krum     |Midwest|Kimberly-Clark                   |
|Carletta Kosinski|Midwest|McDonald's                       |
|Carletta Kosinski|Midwest|Northrop Grumman                 |
|Delilah Krum     |Midwest|Plains GP Holdings               |
|Delilah Krum     |Midwest|Southwest Airlines               |



#### 4. For each account, determine the average amount of each type of paper they purchased across their orders.
```sql
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
```

### Results:
|account_name               |avg_of_standard_qty|avg_gloss_qty |avg_poster_qty  |avg_total_quantity|
|---------------------------|-------------------|--------------|----------------|------------------|
|Pacific Life               |335.6923076923     |30.3076923077 |2,184.4615384615|2,550.4615384615  |
|Kohl's                     |1,878.2857142857   |285.7142857143|167.4285714286  |2,331.4285714286  |
|State Farm Insurance Cos.  |1,891.7777777778   |235.2222222222|150.4444444444  |2,277.4444444444  |
|Fidelity National Financial|404                |16.125        |1,430.625       |1,850.75          |
|Berkshire Hathaway         |1,148              |0             |215             |1,363             |
|AmerisourceBergen          |178                |262.25        |841.5           |1,281.75          |
|Edison International       |756.6              |25.2          |423.4           |1,205.2           |
|CBS                        |297                |32            |853             |1,182             |
|CenturyLink                |298                |391.3333333333|370             |1,059.3333333333  |
|Starbucks                  |164                |313.5         |526             |1,003.5           |

### Insights:
**Among the accounts, it's noteworthy that State Pacific Life stands out as the company that has purchased the highest quantity of paper on average.**


#### 5. For each account, determine the average amount spent per order on each paper type.

```sql
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
```

### Results:
|account_name               |avg_of_standard_amt|avg_gloss_amt   |avg_poster_amt   |average_total_amount|
|---------------------------|-------------------|----------------|-----------------|--------------------|
|Pacific Life               |1,675.1046153846   |227.0046153846  |17,737.8276923077|19,639.9369230769   |
|Fidelity National Financial|2,015.96           |120.77625       |11,616.675       |13,753.41125        |
|Kohl's                     |9,372.6457142857   |2,140           |1,359.52         |12,872.1657142857   |
|State Farm Insurance Cos.  |9,439.9711111111   |1,761.8144444444|1,221.6088888889 |12,423.3944444444   |
|AmerisourceBergen          |888.22             |1,964.2525      |6,832.98         |9,685.4525          |
|CBS                        |1,482.03           |239.68          |6,926.36         |8,648.07            |
|Berkshire Hathaway         |5,728.52           |0               |1,745.8          |7,474.32            |
|Starbucks                  |818.36             |2,348.115       |4,271.12         |7,437.595           |
|CenturyLink                |1,487.02           |2,931.0866666667|3,004.4          |7,422.5066666667    |
|Edison International       |3,775.434          |188.748         |3,438.008        |7,402.19            |

### Insights:
**Among the accounts, Pacific Life stands out with the highest average spending per order on standard, gloss, and poster paper types. This suggests that they make substantial investments in each order.**

#### 6. Determine the number of times a particular channel was used in the web_events table for each sales rep.

```sql
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
```

### Results:
|rep_name             |no_of_channel_used|
|---------------------|------------------|
|Vernita Plump        |382               |
|Earlie Schleusner    |362               |
|Maren Musto          |350               |
|Moon Torian          |333               |
|Maryanna Fiorentino  |330               |
|Tia Amato            |325               |
|Nelle Meaux          |288               |
|Dorotha Seawell      |284               |
|Georgianna Chisholm  |282               |
|Elna Condello        |267               |
|Micha Woodford       |265               |
|Arica Stoltzfus      |263               |
|Delilah Krum         |260               |
|Charles Bidwell      |252               |
|Michel Averette      |250               |
|Sibyl Lauria         |242               |
|Hilma Busick         |233               |
|Gianna Dossey        |232               |
|Brandie Riva         |230               |
|Elwood Shutt         |222               |
|Calvin Ollison       |221               |
|Cliff Meints         |205               |
|Saran Ram            |196               |
|Dawna Agnew          |176               |
|Julia Behrman        |174               |
|Necole Victory       |167               |
|Debroah Wardle       |158               |
|Eugena Esser         |152               |
|Samuel Racine        |140               |
|Derrick Boggess      |135               |
|Ayesha Monica        |132               |
|Elba Felder          |123               |
|Ernestine Pickron    |123               |
|Marquetta Laycock    |116               |
|Renetta Carew        |106               |
|Carletta Kosinski    |102               |
|Lavera Oles          |98                |
|Cordell Rieder       |95                |
|Sherlene Wetherington|95                |
|Akilah Drinkard      |93                |
|Soraya Fulton        |88                |
|Babette Soukup       |87                |
|Retha Sears          |79                |
|Chau Rowles          |72                |
|Shawanda Selke       |69                |
|Cara Clarke          |68                |
|Silvana Virden       |48                |
|Kathleen Lalonde     |47                |
|Julie Starr          |41                |
|Nakesha Renn         |15                |

### Insights:
**The table shows the number of times each sales representative was associated with a specific web channel in the web_events table. For instance, Vernita Plump was associated with a channel 382 times, indicating a high level of engagement with web events.**

#### 7. What is total amount used for each year ? 

```sql
SELECT
	EXTRACT(YEAR FROM occurred_at) AS YEAR,
	SUM(total_amt_usd) AS total_usd
FROM
	orders
GROUP BY
	YEAR
ORDER BY
	total_usd ASC;
```

### Results:
|year|total_usd|
|----|---------|
|2017|78151.43|
|2013|377331.00|
|2014|4069106.54|
|2015|5752004.94|
|2016|12864917.92|

### Insights:

**The data indicates that there were lower sales figures in the years 2013 and 2017. However, from 2014 onwards, there has been a consistent and substantial increase in total sales. Notably, the year 2016 stands out as having the highest total sales among all the years in the dataset. This suggests a positive trend in sales growth over the years, with 2016 being the most successful in terms of revenue generation.**

#### 8. which month of the year did sales occur for 2017 and 2013 ?

```sql
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
	YEAR;
```

### Results:

|year|month|month_name|total_usd|
|----|-----|----------|---------|
|2013|12|December |377331.00|
|2017|1|January  |78151.43|

### Insights:
**The table indicates that there is data available for only one month in each of the years 2013 and 2017. In 2013, sales data is available for December, while in 2017, sales data is available for January. This suggests that the sales data for these years is limited to specific months rather than covering the entire year.**

#### 9. Which day of the month did sales occur in 2017 ?

```sql
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
	total_usd ASC;
```

### Results:
|year|month|month_name|day|day_name|total_usd|
|----|-----|----------|---|--------|---------|
|2017|1|January  |2|Monday   |6451.76|
|2017|1|January  |1|Sunday   |71699.67|

**The table reveals that there are records for only two days in the year 2017, specifically, the first and second days of January. This indicates a limited dataset for that year, focusing solely on the sales that occurred during these two days.**

#### 10. Compare the sales of january 1st for each year ?

```sql
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
	total_usd ASC;
```

### Results:
|year|month|day_name|total_usd|
|----|-----|--------|---------|
|2014|January   1|Wednesday|14850.29|
|2015|January   1|Thursday |23235.79|
|2016|January   1|Friday   |28256.34|
|2017|January   1|Sunday   |71699.67|

### Insights:
**The table clearly demonstrates a consistent year-on-year increase in sales, with each year's sales data corresponding to the first day of January. This suggests a positive sales trend over these years, with progressively higher sales figures.**

#### 11. what is the parcentage of growth in each year ?

```sql
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
```

### Results:
|year|month|day_name|total_usd|growth|percentage_growth|
|----|-----|--------|---------|------|-----------------|
|2014|January   1|Wednesday|14850.29|||
|2015|January   1|Thursday |23235.79|8385.50|56.5|
|2016|January   1|Friday   |28256.34|5020.55|21.6|
|2017|January   1|Sunday   |71699.67|43443.33|153.7|

### Insights:
The table clearly illustrates the year-on-year growth in sales. Here's a summary of the percentage growth for each year:

- In 2015, sales grew by 56.5% compared to 2014.

- In 2016, sales increased by 21.6% compared to 2015.

- In 2017, there was a substantial growth of 153.7% compared to 2016.

This information effectively highlights the significant growth in sales over these years, especially the remarkable increase from 2016 to 2017.

#### 12. In which month of which year did Walmart spend the most on gloss paper in terms of dollars ?

```sql
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
```

### Results:

|account_name|year|month|gloss_total_usd|
|------------|----|-----|---------------|
|Walmart|2016|May      |9257.64|

### Insights:
**Walmart spent the most on gloss paper in terms of dollars in May 2016, with a total of $9257.64**

#### 13. What iS the total amount Of paper that has been sold ?

```sql
SELECT 
	sum(standard_qty) AS total_standard_quantity,
	sum(gloss_qty) AS total_gloss_quantity,
	sum(poster_qty) AS total_poster_quantity
FROM
	orders;
```

### Results:
|total_standard_quantity|total_gloss_quantity|total_poster_quantity|
|-----------------------|--------------------|---------------------|
|1,938,346              |1,013,773           |723,646              |

###  Insights:

**Based on the provided tables, it's evident that the standard paper has the highest total sales quantity compared to gloss and poster paper.**


## **Conclusion:**

In this comprehensive analysis of the dataset, several key insights emerge:

1. **Top Account and Spending:** Pacific Life stands out as a notable account, both in terms of purchasing the highest quantity of paper on average and spending generously on standard, gloss, and poster paper types. This suggests a strong commitment to quality and volume in their orders.

2. **Sales Representative Engagement:** The analysis of web events associated with sales representatives highlights that Vernita Plump has the highest level of engagement, indicating a proactive approach to web channel interactions.

3. **Sales Trend:** The dataset illustrates a consistent and significant increase in sales from 2014 onwards. Notably, 2016 recorded the highest total sales among all years, demonstrating a positive trend in sales growth over the years.

4. **Limited Sales Data:** Limited sales data is available for the years 2013 and 2017, with records for specific months (December 2013 and January 2017). This suggests that the dataset focuses on particular months rather than providing a comprehensive annual overview for those years.

5. **Short Data Duration:** The dataset for 2017 includes records for only two days, specifically the first and second days of January, indicating a highly restricted dataset for that year.

6. **Percentage Sales Growth:** The percentage growth in sales from year to year is substantial, particularly the remarkable increase from 2016 to 2017. This demonstrates robust growth in sales over this period.

7. **Walmart's Spending:** Walmart's highest spending on gloss paper in May 2016 underscores the importance of analyzing specific time periods to identify peak spending patterns.

8. **Paper Sales:** Standard paper emerges as the most popular paper type based on total sales quantity, surpassing gloss and poster paper.

In summary, this analysis highlights the significance of Pacific Life as a key account, the engagement of sales representatives in web events, and the consistent sales growth trend. However, it's essential to recognize the limitations in the dataset, particularly in the coverage of certain years and specific months. Understanding these insights can guide business decisions and strategies for the future. Further analysis and consideration of these factors will be valuable for making informed business choices.


## Recommenddation:
1. **Focus on Key Accounts:** Given that Pacific Life stands out as a top account both in terms of quantity and spending, it would be wise to continue nurturing this relationship. Consider offering tailored incentives or discounts to maintain their loyalty and potentially attract similar high-value clients.

2. **Sales Representative Training:** Recognize the high engagement of sales representatives like Vernita Plump and encourage other representatives to follow suit. Provide additional training and resources to help them excel in customer engagement and web events participation, as this can positively impact sales.

3. **Expand Data Collection:** To gain a more comprehensive understanding of sales trends, consider expanding data collection beyond specific months and years. A year-round dataset can provide more accurate insights into seasonal variations and long-term trends.

4. **Optimize Sales Strategies:** Analyze the sales data from high-growth years, particularly 2016 and 2017, to identify the strategies that contributed to this success. Replicate and refine these strategies to continue the upward sales trajectory.

5. **Diversify Product Offerings:** While standard paper is the top seller, explore opportunities to diversify product offerings. Introduce new paper types or related products that align with customer preferences to increase revenue streams.

6. **Time-Sensitive Promotions:** Leverage insights from Walmart's peak spending in May 2016. Implement time-sensitive promotions and discounts during periods when customers are more likely to make substantial purchases.

7. **Data Quality Assurance:** Ensure data quality and completeness, especially for missing or limited records in certain years. Comprehensive data is essential for accurate trend analysis and decision-making.

8. **Customer Feedback:** Collect feedback from key accounts like Pacific Life to understand their needs, preferences, and pain points. Use this feedback to tailor product offerings and improve customer satisfaction.

9. **Market Expansion:** Given the growth potential indicated in the data, explore opportunities for expanding into new markets or regions where there is a demand for the company's products.

10. **Competitive Analysis:** Continuously monitor competitors in the paper industry. Identify their strategies and customer segments to stay competitive and adjust pricing or offerings accordingly.

11. **Sustainability Initiatives:** Consider integrating sustainability initiatives into the business model, such as offering eco-friendly paper options. This can attract environmentally conscious customers and align with current market trends.

12. **Invest in Analytics:** Invest in advanced analytics and data science capabilities to gain deeper insights from the available data. Predictive analytics can help forecast future trends and customer behavior.

These recommendations aim to capitalize on existing strengths, address limitations, and position the company for sustained growth and competitiveness in the paper market.