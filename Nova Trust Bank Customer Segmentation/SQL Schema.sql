-- DROP DATABASE
DROP DATABASE IF EXISTS "AMDARI PROJECT";
-- CREATE DATABASE
CREATE DATABASE "AMDARI PROJECT";
-- Create Schema
CREATE SCHEMA IF NOT EXISTS "NovaTrust Bank Customer Segmentation";
-- CREATE TABLE FOR CUSTOMERS
DROP TABLE IF EXISTS "NovaTrust Bank Customer Segmentation".customers;
CREATE TABLE "NovaTrust Bank Customer Segmentation".customers (
  "customer id" bigint,
  "first name" varchar(50),
  "last name" varchar(50),
  "date of birth" Date,
  "contact email" varchar(50),
  "contact phone" varchar(50),
  "account type" varchar(50),
  "account open date" date,
  "account number" bigint,
  "employment status" varchar(50),
  PRIMARY KEY ("account number")
);
-- COPY DATA INTO CUSTOMERS TABLE
COPY "NovaTrust Bank Customer Segmentation".customers("customer id", "first name", "last name", "date of birth", "contact email", "contact phone", "account type", "account open date", "account number", "employment status")
FROM 'C:/Users/USER/Desktop/PORTFOLIO PROJECT/AMDARI PROJECT/Data Analysis/SQL/Banking on Analytics Tailoring Services for Former Student Customers at NovaTrust for Enhanced Loyalty/Dataset/Customers.csv'
DELIMITER ','
CSV HEADER;

SET search_path = "NovaTrust Bank Customer Segmentation";

SELECT * FROM customers;


-- CREATE TABLE FOR TRANSACTIONS
DROP TABLE IF EXISTS "NovaTrust Bank Customer Segmentation".transactions;
CREATE TABLE transactions(
	"transaction id" varchar(50),
	"account number" bigint,
	"transaction date" timestamp,
	"transaction type" varchar(50),
	"transaction amount" bigint,
	balance bigint,
	"transdescription" varchar(250),
	"reference number" varchar(50),
	PRIMARY KEY ("transaction id"),
	FOREIGN KEY ("account number") REFERENCES customers ("account number")
);

-- COPY DATA INTO TRANSACTIONS TABLE
COPY "NovaTrust Bank Customer Segmentation".transactions("transaction id", "account number", "transaction date", "transaction type", "transaction amount", "balance", "transdescription", "reference number")
FROM 'C:/Users/USER/Desktop/PORTFOLIO PROJECT/AMDARI PROJECT/Data Analysis/SQL/Banking on Analytics Tailoring Services for Former Student Customers at NovaTrust for Enhanced Loyalty/Dataset/transaction.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM transactions;
