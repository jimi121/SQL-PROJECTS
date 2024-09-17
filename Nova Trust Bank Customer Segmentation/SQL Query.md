#### View the first five rows of customer table

```sql
SELECT * FROM customers
```

|customer id|first name|last name|date of birth|contact email              |contact phone       |account type|account open date|account number|employment status|
|-----------|----------|---------|-------------|---------------------------|--------------------|------------|-----------------|--------------|-----------------|
|684091     |Kelly     |Greene   |2000-04-21   |kelly.greene@example.com   |(259)906-7878       |savings     |2019-07-19       |9377747487    |student          |
|606805     |Justin    |Owens    |2001-12-24   |justin.owens@example.com   |001-436-754-2711x858|savings     |2023-05-27       |9875822130    |student          |
|897387     |Debra     |Rodriguez|1999-11-09   |debra.rodriguez@example.com|494-347-4745x74504  |current     |2015-07-13       |4246937534    |student          |
|883986     |Dylan     |Lindsey  |2002-08-06   |dylan.lindsey@example.com  |550-888-4899x5565   |current     |2016-12-26       |7327174038    |employed         |
|939985     |Pamela    |Rose     |1992-12-01   |pamela.rose@example.com    |(236)994-3964x910   |savings     |2016-03-18       |2535225529    |student          |

#### View the first five rows of transactions table
```sql
SELECT * FROM customers
```
|transaction id|account number|transaction date       |transaction type|transaction amount|balance|transdescription                            |reference number|
|--------------|--------------|-----------------------|----------------|------------------|-------|--------------------------------------------|----------------|
|TXN943565     |8717551881    |2023-05-07 14:39:00.000|Credit          |15,893            |762,992|Fee Reversal                                |REF100001       |
|TXN344844     |7812182766    |2022-06-18 14:39:00.000|Debit           |3,238             |386,724|Auto Payment to GoTV                        |REF100005       |
|TXN374495     |3516372894    |2021-10-23 14:39:00.000|Credit          |69,484            |56,601 |Online Transfer FROM October-2021 REF100009 |REF100009       |
|TXN619232     |8203917442    |2022-03-01 14:39:00.000|Credit          |69,463            |194,899|Refund from Jumia Nigeria                   |REF100010       |
|TXN189549     |1462029052    |2022-02-10 14:39:00.000|Credit          |56,784            |173,603|Online Transfer FROM February-2022 REF100012|REF100012       |

#### Dealing with duplicates in customers table
```sql
WITH duplicates AS (
    SELECT ctid, ROW_NUMBER() OVER (PARTITION BY "customer id" ORDER BY "customer id") as rn
    FROM customers c 
)
DELETE FROM customers 
WHERE ctid IN (SELECT ctid FROM duplicates WHERE rn > 1);
```

#### Dealing with duplicates in transactions table
```sql
WITH duplicates AS (
	SELECT ctid, ROW_NUMBER () OVER (PARTITION BY "transaction id") AS rn
	FROM transactions t 
)
DELETE FROM transactions
WHERE ctid IN (SELECT ctid FROM duplicates WHERE rn > 1);
```

#### Check for missing values in customers table
```sql
SELECT 
	sum(CASE WHEN "customer id" IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
	sum(CASE WHEN "first name" IS NULL THEN 1 ELSE 0 END) AS missing_first_name,
	sum(CASE WHEN "last name" IS NULL THEN 1 ELSE 0 END) AS missing_last_name,
	sum(CASE WHEN "date of birth" IS NULL THEN 1 ELSE 0 END) AS missing_dob,
	sum(CASE WHEN "contact email" IS NULL THEN 1 ELSE 0 END) AS missing_email,
	sum(CASE WHEN "contact phone" IS NULL THEN 1 ELSE 0 END) AS missing_phone,
	sum(CASE WHEN "account type" IS NULL THEN 1 ELSE 0 END) AS missing_account_type,
	sum(CASE WHEN "account open date" IS NULL THEN 1 ELSE 0 END) AS missing_acct_open_date,
	sum(CASE WHEN "account number" IS NULL THEN 1 ELSE 0 END) AS missing_acct_num,
	sum(CASE WHEN "employment status" IS NULL THEN 1 ELSE 0 END) AS missing_emp_status
FROM
	customers c;
```

#### Check for missing values in transactions table
```sql
SELECT 
	sum(CASE WHEN "transaction id" IS NULL THEN 1 ELSE 0 END) AS missing_transaction_id,
	sum(CASE WHEN "account number" IS NULL THEN 1 ELSE 0 END) AS missing_acct_num,
	sum(CASE WHEN "transaction date" IS NULL THEN 1 ELSE 0 END) AS missing_transaction_date,
	sum(CASE WHEN "transaction type" IS NULL THEN 1 ELSE 0 END) AS missing_transaction_type,
	sum(CASE WHEN "transaction amount" IS NULL THEN 1 ELSE 0 END) AS missing_transaction_amount,
	sum(CASE WHEN "balance" IS NULL THEN 1 ELSE 0 END) AS missing_balance,
	sum(CASE WHEN "transdescription" IS NULL THEN 1 ELSE 0 END) AS missing_transdescription,
	sum(CASE WHEN "reference number" IS NULL THEN 1 ELSE 0 END) AS missing_reference_number
FROM 
	transactions t;
```

#### -- Begin by extracting relevant salary transactions from student accounts in the last year
```sql
WITH salary AS (
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
			AND t."transaction date" >= ('2023-08-31'::date - INTERVAL '12 months')
	),
```

#### -- Calculate RFM values for each customer, and filter only those with an average salary above 200000
```sql
RFM AS (
		SELECT 
			"account number",
			max("transaction date") AS last_transaction_date,
			date_part('month', age('2023-08-31'::date, max("transaction date"))) AS recency,
			count("transaction id") AS frequency,
			round(avg("transaction amount")) AS monetary_value
		FROM 
			salary
		GROUP BY 
			"account number"
		HAVING avg("transaction amount") >= 200000
		),
```
#### -- Assign RFM scores to each customer based on their RFM values
```sql
RFM_Scores AS (
        SELECT 
        	   "account number",
               last_transaction_date,
               recency,
               frequency,
               monetary_value,
               CASE
                   WHEN recency = 0 THEN 10
                   WHEN recency < 3 THEN 7
                   WHEN recency < 5 THEN 4
                   ELSE 1
               END AS R_Score,
               CASE 
                   WHEN frequency = 12 THEN 10
                   WHEN frequency >= 9 THEN 7
                   WHEN frequency >= 6 THEN 4
                   ELSE 1
               END AS F_Score,
               CASE 
                   WHEN monetary_value > 600000 THEN 10
                   WHEN monetary_value > 400000 THEN 7
                   WHEN monetary_value BETWEEN 300000 AND 400000 THEN 4
                   ELSE 1
               END AS M_Score
        FROM RFM
    ),
```
#### -- Combine RFM scores to derive customer's segment and create an additional column for salary range
```sql
CustomerSegment AS (
        SELECT 
        	  "account number",
               last_transaction_date,
               recency,
               frequency,
               monetary_value,
               R_Score + F_Score + M_Score AS RFM_Segment,
               CASE
                   WHEN monetary_value > 600000 THEN 'Above 600k'
                   WHEN monetary_value BETWEEN 400000 AND 600000 THEN '400-600k'
                   WHEN monetary_value BETWEEN 300000 AND 400000 THEN '300-400k'
                   ELSE '200-300K'
               END AS SalaryRange,
               R_Score,
               F_Score,
               M_Score,
               (R_Score + F_Score + M_Score)::FLOAT / 30 AS RFM_Score,
               CASE
                   WHEN (R_Score + F_Score + M_Score)::FLOAT / 30 >= 0.8 THEN 'Tier 1 Customers'
                   WHEN (R_Score + F_Score + M_Score)::FLOAT / 30 >= 0.6 THEN 'Tier 2 Customers'
                   WHEN (R_Score + F_Score + M_Score)::FLOAT / 30 >= 0.5 THEN 'Tier 3 Customers'
                   ELSE 'Tier 4 Customers'
               END AS Segment
        FROM RFM_Scores
    )
```
#### -- Retrieve final list of customer segments sorted by Frequency score
```sql
SELECT 
   S."account number",
   C."contact email",
   last_transaction_date,
   recency AS Months_Since_Last_Salary,
   frequency AS Transaction_Count,
   monetary_value AS Monthly_Salary_Value,
   SalaryRange,
   RFM_Segment AS RFM_Score,
   Segment
FROM 
	CustomerSegment S
LEFT JOIN Customers C 
ON S."account number" = C."account number"
ORDER BY Segment DESC;
```

## CREATE STORED PROCEDURES
#### -- To enhance efficiency, all queries are encapsulated in a stored procedure 
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
    RETURN QUERY

-- Extracting relevant salary transactions from student accounts in the last year

    WITH salary AS (
        SELECT 
            c."account number" AS account_number,
            t."transaction id" AS transaction_id,
            t."transaction date" AS transaction_date,
            t."transaction amount" AS transaction_amount,
            t.transdescription 
        FROM 
            customers c 
        JOIN 
            transactions t ON c."account number" = t."account number" 
        WHERE 
            lower(c."employment status") = lower(p_EmploymentStatus)
            AND lower(t.transdescription) LIKE '%' || lower(p_TransDescription) || '%'
            AND lower(t."transaction type") = 'credit'
            AND t."transaction date" >= (p_DateCriteria - INTERVAL '12 months')
    ),
 
-- Calculate RFM values for each customer, and filter only those with an average salary above 200000

    RFM AS (
        SELECT 
            salary.account_number,
            max(salary.transaction_date) AS last_transaction_date,
            date_part('month', age(p_DateCriteria, max(salary.transaction_date))) AS recency,
            count(salary.transaction_id) AS frequency,
            round(avg(salary.transaction_amount)) AS monetary_value
        FROM 
            salary
        GROUP BY 
            salary.account_number
        HAVING avg(salary.transaction_amount) >= 200000
    ),

-- Assign RFM scores to each customer based on their RFM values
    RFM_Scores AS (
        SELECT 
            RFM.account_number,
            RFM.last_transaction_date,
            RFM.recency,
            RFM.frequency,
            RFM.monetary_value,
            CASE
                WHEN RFM.recency = 0 THEN 10
                WHEN RFM.recency < 3 THEN 7
                WHEN RFM.recency < 5 THEN 4
                ELSE 1
            END AS r_score,
            CASE 
                WHEN RFM.frequency = 12 THEN 10
                WHEN RFM.frequency >= 9 THEN 7
                WHEN RFM.frequency >= 6 THEN 4
                ELSE 1
            END AS f_score,
            CASE 
                WHEN RFM.monetary_value > 600000 THEN 10
                WHEN RFM.monetary_value > 400000 THEN 7
                WHEN RFM.monetary_value BETWEEN 300000 AND 400000 THEN 4
                ELSE 1
            END AS m_score
        FROM RFM
    ),

-- Combine RFM scores to derive customer's segment and create an additional column for salary range
    CustomerSegment AS (
        SELECT 
            RFM_Scores.account_number,
            RFM_Scores.last_transaction_date,
            RFM_Scores.recency,
            RFM_Scores.frequency,
            RFM_Scores.monetary_value,
            RFM_Scores.r_score + RFM_Scores.f_score + RFM_Scores.m_score AS rfm_segment,
            CASE
                WHEN RFM_Scores.monetary_value > 600000 THEN 'Above 600k'
                WHEN RFM_Scores.monetary_value BETWEEN 400000 AND 600000 THEN '400-600k'
                WHEN RFM_Scores.monetary_value BETWEEN 300000 AND 400000 THEN '300-400k'
                ELSE '200-300K'
            END AS salary_range,
            RFM_Scores.r_score,
            RFM_Scores.f_score,
            RFM_Scores.m_score,
            (RFM_Scores.r_score + RFM_Scores.f_score + RFM_Scores.m_score)::FLOAT / 30 AS rfm_score,
            CASE
                WHEN (RFM_Scores.r_score + RFM_Scores.f_score + RFM_Scores.m_score)::FLOAT / 30 >= 0.8 THEN 'Tier 1 Customers'
                WHEN (RFM_Scores.r_score + RFM_Scores.f_score + RFM_Scores.m_score)::FLOAT / 30 >= 0.6 THEN 'Tier 2 Customers'
                WHEN (RFM_Scores.r_score + RFM_Scores.f_score + RFM_Scores.m_score)::FLOAT / 30 >= 0.5 THEN 'Tier 3 Customers'
                ELSE 'Tier 4 Customers'
            END AS segment
        FROM RFM_Scores
    )

-- Retrieve final list of customer segments sorted by Frequency score
    SELECT 
        CustomerSegment.account_number,
        customers."contact email" AS contact_email,
        CustomerSegment.last_transaction_date::date,
        CustomerSegment.recency::integer AS months_since_last_salary,
        CustomerSegment.frequency::integer AS transaction_count,
        CustomerSegment.monetary_value::numeric AS monthly_salary_value,
        CustomerSegment.salary_range::varchar,
        CustomerSegment.rfm_segment AS rfm_score,
        CustomerSegment.segment::varchar
    FROM 
        CustomerSegment
    LEFT JOIN customers 
        ON CustomerSegment.account_number = customers."account number"
    ORDER BY 
        CustomerSegment.segment DESC;
END;
$$ LANGUAGE plpgsql;

-- To call the function:
SELECT * FROM getcustomersegment('student', '2023-08-31', 'salary');
-- To drop the function
/* DROP FUNCTION getcustomersegment(p_EmploymentStatus VARCHAR(50),
    p_DateCriteria DATE,
    p_TransDescription VARCHAR(100)); */
```