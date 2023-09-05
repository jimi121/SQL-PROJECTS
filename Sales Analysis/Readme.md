# Sales Data Exploratory

## **Introduction:**

Conduct a comprehensive sales analysis on a PostgreSQL database with the goal of uncovering valuable insights. This analysis will focus on identifying the following key aspects:

1. **Best-Selling Products:** Identify the products with the highest sales volume.
2. **Top Customers:** Determine the most significant customers based on their purchasing behavior.
3. **Sales Growth Rate:** Analyze the growth rate of sales over time.

## **Aim and objective:**

1. **Identify High-Value Accounts:** The aim is to identify and prioritize high-value accounts like Pacific Life, focusing on those that purchase the highest quantity of paper on average.

2. **Optimize Customer Engagement:** The aim is to enhance customer engagement, both online and offline, by recognizing and learning from the high engagement levels of sales representatives like Vernita Plump.

3. **Understand Sales Trends:** The aim is to understand and analyze historical sales trends, including the consistent growth in sales from 2014 onwards and the standout year of 2016.

4. **Improve Data Coverage:** The aim is to improve data coverage for the years 2013 and 2017 to provide a more comprehensive view of sales performance during these periods.

5. **Enhance Sales Strategies:** The aim is to refine and develop sales strategies based on the insights gained from the year-on-year growth analysis, ensuring sustainable revenue growth.

6. **Time-Sensitive Marketing:** The aim is to leverage peak spending periods, such as Walmart's high spending in May 2016 on gloss paper, for targeted marketing campaigns.

7. **Product Diversification:** The aim is to explore opportunities for diversifying product offerings while acknowledging the popularity of standard paper.


## **Database Content:**

This database contains records of orders for various types of paper, placed by a range of companies, including notable names like Walmart and Microsoft. The database captures essential details, such as:

- Quantity of each paper type ordered.
- Total expenditure.
- The individual responsible for the order.
- Geographic location of the ordering company.
- Dates of various web events hosted by each company.

## Datasets Utilized:

1. **Accounts**:
   - **Description**: This table encompasses diverse companies with pertinent attributes.
   - **Attributes**:
     - `account_id`: Unique identifier for each company.
     - `website`: Company's website address.
     - `contact`: Contact point within the company.
     - `sales_representative_id`: Identifier for the sales representative associated with the company.

2. **Orders**:
   - **Description**: This table documents order-related information.
   - **Attributes**:
     - `timestamp`: Timestamp indicating when each order occurred.
     - `standard_qty`: Quantity of standard paper ordered.
     - `gloss_qty`: Quantity of gloss paper ordered.
     - `poster_qty`: Quantity of poster paper ordered.
     - `total_qty`: Total quantity of paper ordered.
     - `standard_amt_usd`: Total expenditure on standard paper (in USD).
     - `gloss_amt_usd`: Total expenditure on gloss paper (in USD).
     - `poster_amt_usd`: Total expenditure on poster paper (in USD).
     - `total_amt_usd`: Total expenditure (in USD).

3. **Region**:
   - **Description**: This table categorizes regions into four segments.
   - **Regions**:
     - Northeast
     - Midwest
     - Southeast
     - West

4. **Sales Representatives**:
   - **Description**: This table lists sales representatives along with their unique identifiers and respective region assignments.
   - **Attributes**:
     - `sales_rep_id`: Unique identifier for each sales representative.
     - `name`: Name of the sales representative.
     - `region_id`: Identifier for the region assigned to the sales representative.

5. **Web Events**:
   - **Description**: This table compiles data on web events conducted by each company.
   - **Attributes**:
     - `account_id`: Identifier of the company associated with the web event.
     - `event_date`: Date of the web event.
     - `channel`: Channel used for the web event (e.g., Facebook, Twitter, etc.).

## Conclusion:
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

## Recommendation:
This is my suggestions on how the company can generate more money:

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