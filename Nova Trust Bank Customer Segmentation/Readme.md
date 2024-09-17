# NovaTrust Bank - SQL-Based Customer Segmentation Project 
![image](https://github.com/jimi121/SQL-PROJECTS/blob/main/Nova%20Trust%20Bank%20Customer%20Segmentation/Image.jpg)
## Project Overview

NovaTrust Bank, a financial institution with a significant student customer base, faced a challenge: identifying former students who have transitioned into the workforce and tailoring banking services to their evolving financial needs. As part of my role, I was responsible for developing a data-driven solution to segment these customers based on their transaction patterns, specifically identifying those who now regularly receive salary payments. This would enable the bank to offer personalized products, including loans and account upgrades, to meet their current financial situation.

## Business Problem
NovaTrust Bank offers specialized services for students. However, many of these students, after transitioning into the workforce, continue to use their student accounts, which may no longer align with their financial needs. The goal was to identify these customers and segment them based on their salary transactions over the last year. By targeting former students with curated offerings, the bank aimed to increase customer retention and provide tailored financial services.

## Data Description
### 1.	Customers Table
Contains details of the bank's customers, including personal information, account details, and employment status.

#### Columns:
_CustomerID, FirstName, LastName, DateOfBirth, Contact Email, Phone, Account Type, Account Open Date, Account Number, Employment Status_

### 2.	Transactions Table
Contains transaction details related to customer accounts, including transaction type, amount, and description.

#### Columns:
_TransactionID, Account Number, Transaction Date, Transaction Type, Transaction Amount, TransDescriptions_


## My Role and Contribution
I was tasked with designing and implementing an SQL-based solution that identified and segmented former student customers using transaction data. 
My responsibilities included:
1.	**Data Cleaning and Preparation:**
-	I conducted data exploration, removed duplicates from both the customers and transactions tables, and handled missing values using SQL scripts.
-	Ensured the integrity of the dataset by thoroughly cleanin and preparing it for analysis.

2.	**Data Extraction:**
-	I wrote complex SQL queries to extract relevant salary transactions from customers with student accounts, filtering those who had received at least 10 salary deposits in the last year.

3.	**Customer Segmentation:**
-	Using RFM (Recency, Frequency, Monetary) analysis, I segmented customers based on their transaction behavior, such as the recency of their last salary transaction, the frequency of salary deposits, and the average salary amount.
-	Assigned each customer a score and categorized them into different tiers, enabling targeted marketing campaigns.

4.	**Stored Procedures for Efficiency:**
-	To enhance the scalability and reusability of the solution, I encapsulated the queries in a stored procedure. This allowed the marketing team to easily retrieve customer segments based on different date criteria or transaction descriptions.

## Technical Stack
**PostgreSQL :** For data exploration, query development, and managing database objects.

## Project Methodology
1.	**Data Cleaning:**
Removed duplicates and identified missing data points across customers and transactions tables to ensure accurate analysis.

2.	**RFM Scoring:** Created a custom RFM model using SQL to assign scores to customers based on the recency of their salary deposits, the frequency of transactions, and the average salary amount.

3.	**Customer Segmentation:** Classified customers into four distinct segments based on their RFM scores, ranging from Tier 1 (most valuable) to Tier 4 (least engaged). Each segment received different recommendations for personalized marketing strategies.

## Key SQL Techniques
- Common Table Expressions (CTEs): Used to break down the complex logic into manageable parts, including filtering salary transactions and calculating RFM scores.
- Stored Procedures: Developed to allow for dynamic retrieval of customer segments, improving the efficiency and reusability of the solution.

## The Process
### 1. Setup Database
1.	First, create a Database in PostgreSQL called NovaTrust Bank Customer Segmentation

2.	Create table for customers and transaction
3.	Import customers.csv and transaction.csv into table
4.	customers.csv contains 10,000 unique accounts. 
5.	transaction.csv contains 283,041 transaction records between 2021-2023.

### 2. Identify all student accounts with regular salary inflows in the last one year.
1.	Extract student accounts from customers where employmentStatus = Student.

2.	Combine with transaction to access their transaction history.
3.	Filter to retain only transactionType = Credit records from the past year.
4.	Filter to retain data where the transDescription column contains the word “Salary”. This would give you all student account numbers that have received salary over time.
```sql
SELECT 
			c."account number",
			t."transaction id",
			t."transaction date",
			t."transaction amount",
			t.transdescription 
		FROM 
			customers c 
		JOIN 
			transactions t ON c."account number" = t."account number" 
		WHERE lower(c."employment status") = 'student'
			AND lower(t.transdescription) LIKE '%salary%'
			AND lower(t."transaction type") = 'credit'
			AND t."transaction date" >= ('2023-08-31'::date - INTERVAL '12 months');
```
### 3. Customer Segmentation using RFM Model
The RFM (Recency, Frequency, Monetary) model is a customer segmentation model that uses three variables to segment customers:
1.	Recency: When was their last salary credited in the past year?

2.	Frequency: How many times was a salary credited in the past year?
3.	Monetary: What's their average salary over the past year?
Each variable is assigned a score, and the scores are then combined to create an overall RFM score. Customers with higher RFM scores are generally considered to be more valuable customers.
For brevity, only accounts with average salaries exceeding 200,000 are considered.

### 4. RFM Score
The RFM Score was calculated by summing the R, F, and M scores. Each customer can have a maximum possible score of 30, and the sum of the R, F, and M scores was divided by 30 to make it a 100%. This provides an overall assessment of a customer's value and engagement.

### 5. Customer Categories
Tier 1 Customer: RFM Score >= 80%
Tier 2 Customer: RFM Score between 60 and 80%
Tier 3 Customers: RFM Score between 50 and 60%
Tier 4 Customers: RFM Score less than 50%

### 6. Code Reusability (Stored Procedure)
- To enhance efficiency, all queries are encapsulated in a stored procedure (getcustomersegment). This eliminates the need to rewrite the queries every time there's a need to segment customers. 
- Create the stored procedure using the following SQL statement:

```sql
CREATE OR REPLACE FUNCTION getcustomersegment(
    p_EmploymentStatus VARCHAR(50),
    p_DateCriteria DATE,
    p_TransDescription VARCHAR(100)
)
RETURNS TABLE (
    account_number VARCHAR,
    contact_email VARCHAR,
    last_transaction_date DATE,
    months_since_last_salary INTEGER,
    transaction_count INTEGER,
    monthly_salary_value NUMERIC,
    salary_range VARCHAR,
    rfm_score INTEGER,
    segment VARCHAR
) AS $$
BEGIN

    -- Rest of the Code
END;
$$ LANGUAGE plpgsql;
```
To call the stored procedure, use the following SQL statement:

```sql
SELECT * FROM getcustomersegment('student', '2023-08-31', 'salary');
```

### 7. Data Analysis and Results

SQL queries utilised are linked [here](https://github.com/jimi121/SQL-PROJECTS/blob/main/Nova%20Trust%20Bank%20Customer%20Segmentation/SQL%20Query.md).

The segmentation results are available here.

Find project recommendations here.

## Table Result for the Segmentation
|account number|contact email               |last_transaction_date  |months_since_last_salary|transaction_count|monthly_salary_value|salaryrange|rfm_score|segment         |
|--------------|----------------------------|-----------------------|------------------------|-----------------|--------------------|-----------|---------|----------------|
|1126445943    |kevin.escobar@example.com   |2023-08-23 00:00:00.000|0                       |5                |246,044             |200-300K   |12       |Tier 4 Customers|
|1154628051    |rachel.garrett@example.com  |2022-10-25 00:00:00.000|10                      |2                |549,892             |400-600k   |9        |Tier 4 Customers|
|1113297907    |lori.cox@example.com        |2022-09-27 00:00:00.000|11                      |1                |275,984             |200-300K   |3        |Tier 4 Customers|
|1083942478    |steve.villa@example.com     |2023-07-25 00:00:00.000|1                       |8                |285,488             |200-300K   |12       |Tier 4 Customers|
|1110901069    |jessica.johnson@example.com |2022-10-28 00:00:00.000|10                      |1                |584,779             |400-600k   |9        |Tier 4 Customers|
|1032670254    |amanda.ramos@example.com    |2022-10-26 00:00:00.000|10                      |2                |250,786             |200-300K   |3        |Tier 4 Customers|
|1015841347    |deanna.mitchell@example.com |2022-10-28 00:00:00.000|10                      |2                |533,602             |400-600k   |9        |Tier 4 Customers|
|1101703920    |sherry.sanchez@example.com  |2023-03-24 00:00:00.000|5                       |6                |353,950             |300-400k   |9        |Tier 4 Customers|
|1031130613    |tracy.thomas@example.com    |2022-11-23 00:00:00.000|9                       |3                |509,786             |400-600k   |9        |Tier 4 Customers|
|1189212253    |robert.schroeder@example.com|2022-10-24 00:00:00.000|10                      |1                |550,535             |400-600k   |9        |Tier 4 Customers|


## Results and Insights
-	**Tier 1 Customers:** High-value customers with an RFM score above 80%. Recommendation: Offer premium banking services like personal loans and investment accounts.

-	**Tier 2 Customers:** Early-career professionals with potential for growth. Recommendation: Provide short-term loan offers and incentives for referring friends and family.
-	**Tier 3 Customers:** Active but less engaged customers. Recommendation: Share information on managing finances and introduce working professional services.
-	**Tier 4 Customers:** Low engagement and financial instability. Recommendation: Work with these customers to create personalized financial plans and offer affordable services.

## Conclusion
This project demonstrated the power of SQL in data segmentation and customer analysis. By leveraging SQL queries to clean data, calculate RFM scores, and segment customers, I was able to provide NovaTrust Bank with actionable insights that will help them tailor their product offerings to former students who are now working professionals.

This project highlights my ability to:
- Solve real-world business problems using SQL.
- Develop efficient data extraction and segmentation techniques.
- Communicate insights and strategies based on data analysis.
 
