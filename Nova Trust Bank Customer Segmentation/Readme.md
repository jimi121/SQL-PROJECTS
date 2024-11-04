# NovaTrust Bank - SQL-Based Customer Segmentation Project 
![](https://github.com/jimi121/SQL-PROJECTS/blob/main/Nova%20Trust%20Bank%20Customer%20Segmentation/Nova%20Trust%20Bank%20images.jpg)
## Project Overview

**NovaTrust Bank** needed a targeted approach to engage former student customers who have transitioned into the workforce, offering them banking solutions aligned with their current financial needs. This project focused on using SQL to identify customers now receiving regular salary deposits, allowing the bank to offer tailored products, including loans and account upgrades. My role involved designing a segmentation strategy based on transaction data, optimizing it for efficiency, and creating a reusable solution that enables targeted marketing campaigns.

---

## Business Challenge

NovaTrust’s specialized student services no longer meet the needs of customers who have entered the workforce. Our goal was to:
1. **Identify former students** who regularly receive salary deposits.
2. **Segment these customers** based on transaction patterns using a tailored RFM (Recency, Frequency, Monetary) analysis.
3. Enable the bank to offer personalized products, improving customer retention and satisfaction.

---

## Data Description

### 1. Customers Table  
Stores customer information such as contact details, account information, and employment status.

| Column               | Description                      |
|----------------------|----------------------------------|
| `CustomerID`         | Unique identifier for each customer |
| `FirstName`          | Customer’s first name           |
| `EmploymentStatus`   | Employment status (e.g., Student) |
| ...                  | (Other personal and account details) |

### 2. Transactions Table  
Contains details of each customer’s transactions, including date, type, and description.

| Column               | Description                          |
|----------------------|--------------------------------------|
| `TransactionID`      | Unique transaction identifier       |
| `TransactionType`    | Type of transaction (Credit/Debit) |
| `TransactionAmount`  | Transaction amount                 |
| `TransDescriptions`  | Description (e.g., Salary)         |
| ...                  | (Other transaction details)         |

---

## My Role & Key Contributions

In this project, I utilized SQL for data processing, segmentation, and analytics. My responsibilities included:

1. **Data Cleaning & Preparation**  
   - Used SQL to remove duplicates, handle missing values, and ensure data integrity across `customers` and `transactions` tables.

2. **Salary-Based Segmentation**  
   - Developed SQL queries to identify student accounts receiving salary credits and filtered relevant transactions from the past year.
   - Set up criteria to capture customers with **at least 10 salary deposits** in the last year.

3. **RFM-Based Segmentation Analysis**  
   - Built an RFM model to evaluate each customer based on:
     - **Recency** of their latest salary transaction,
     - **Frequency** of salary credits,
     - **Monetary** value (average salary amount).
   - Segmented customers into four tiers based on calculated RFM scores.

4. **Automated Stored Procedure for Dynamic Segmentation**  
   - Encapsulated the logic in a stored procedure, enabling the marketing team to easily retrieve segmented lists for targeted campaigns.

5. **Data-Driven Recommendations**  
   - Provided actionable insights, with tailored recommendations for each segment to maximize engagement and revenue.

---

## Technical Implementation

### Database & SQL Techniques

**Database Setup:**  
- PostgreSQL was used to manage the `customers` and `transactions` tables. We imported datasets containing 10,000 customer records and 283,041 transactions spanning 2021-2023.

**SQL Techniques Employed:**

- **Common Table Expressions (CTEs):** Used to structure complex queries, especially for filtering salary transactions and calculating RFM scores.
- **String Functions:** Utilized `LOWER()` and `LIKE` to search transaction descriptions for keywords like "salary."
- **Date Manipulation:** Employed date functions for filtering transactions within the past year.
- **Stored Procedures & Functions:** Encapsulated logic in a stored procedure to allow dynamic segmentation and improve query reusability.
  
---

### Process and Methodology

#### Step 1: Data Preparation  
- Cleaned and preprocessed data using SQL, ensuring no duplicates or missing values in critical fields.

#### Step 2: Identifying Salary Transactions  
- Filtered transaction records with `transactionType = 'Credit'` and `transDescription` containing "salary" to find all student accounts with salary inflows in the last 12 months.
  ```sql
  SELECT 
      c."account_number",
      t."transaction_id",
      t."transaction_date",
      t."transaction_amount",
      t."transdescription" 
  FROM 
      customers c 
  JOIN 
      transactions t ON c."account_number" = t."account_number" 
  WHERE 
      LOWER(c."employment_status") = 'student' 
      AND LOWER(t.transdescription) LIKE '%salary%' 
      AND LOWER(t."transaction_type") = 'credit'
      AND t."transaction_date" >= (CURRENT_DATE - INTERVAL '12 months');

#### Step 3: RFM Scoring & Customer Segmentation

Using SQL, I developed an RFM model to score customers based on:

- **Recency:** Days since the last salary transaction.
- **Frequency:** Count of salary deposits within the past year.
- **Monetary:** Average salary amount in the past year.

Each metric was assigned a score, and the scores were combined into an overall RFM score, which was normalized to a percentage scale (0–100%). The segmentation criteria were:

| RFM Score     | Customer Tier |
|---------------|---------------|
| ≥ 80%         | Tier 1        |
| 60% - 80%     | Tier 2        |
| 50% - 60%     | Tier 3        |
| < 50%         | Tier 4        |

---

#### Step 4: Stored Procedure for Reusability

I created a stored procedure (`getcustomersegment`) that allows for dynamic segmentation, with parameters for `EmploymentStatus`, `DateCriteria`, and `TransDescription`. This enables on-demand retrieval of specific segments by the marketing team:

```sql
CREATE OR REPLACE FUNCTION getcustomersegment(
    p_EmploymentStatus VARCHAR(50),
    p_DateCriteria DATE,
    p_TransDescription VARCHAR(100)
) RETURNS TABLE (
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
    -- Procedure logic for segmentation
END;
$$ LANGUAGE plpgsql;
```

## Results and Recommendations
-	**Tier 1 Customers:** High-value customers with an RFM score above 80%. Recommendation: Offer premium banking services like personal loans and investment accounts.

-	**Tier 2 Customers:** Early-career professionals with potential for growth. Recommendation: Provide short-term loan offers and incentives for referring friends and family.
-	**Tier 3 Customers:** Active but less engaged customers. Recommendation: Share information on managing finances and introduce working professional services.
-	**Tier 4 Customers:** Low engagement and financial instability. Recommendation: Work with these customers to create personalized financial plans and offer affordable services.

## Sample Results:

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

## Conclusion
This project demonstrates how SQL-driven data analysis can empower customer segmentation and enable targeted product offerings. By implementing an RFM model, developing a stored procedure for reusable segmentation, and leveraging advanced SQL techniques, I provided actionable insights that align with NovaTrust Bank’s business goals.

### Highlights:

- **SQL Skills:** CTEs, string functions, stored procedures, and RFM modeling.

- **Outcome:** Improved segmentation for targeted marketing, with recommendations based on customer transaction behavior.

### Data Analysis And Results
- SQL queries utilised are linked [here](https://github.com/jimi121/SQL-PROJECTS/blob/main/Nova%20Trust%20Bank%20Customer%20Segmentation/SQL%20Query%20And%20Solution.md).

- The segmentation results are available [here](https://github.com/jimi121/SQL-PROJECTS/blob/main/Nova%20Trust%20Bank%20Customer%20Segmentation/Customer%20Segmentation%20data.xlsx).

- Find project recommendations [here](https://github.com/jimi121/SQL-PROJECTS/blob/main/Nova%20Trust%20Bank%20Customer%20Segmentation/Insights%20And%20Recommendations.PPtx).
