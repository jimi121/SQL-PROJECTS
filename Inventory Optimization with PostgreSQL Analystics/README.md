# Inventory Optimization with PostgreSQL Analytics
![](https://github.com/jimi121/SQL-PROJECTS/blob/main/Inventory%20Optimization%20with%20PostgreSQL%20Analystics/img.png)
## Introduction
Efficient inventory management is a critical driver of success across industries, enabling organizations to meet demand while controlling costs. Overstocking consumes capital and storage resources, while understocking leads to lost sales and dissatisfied customers. This project addresses these challenges by leveraging SQL-based analytics in PostgreSQL to optimize inventory levels. By analyzing historical sales, product details, and external economic factors, I developed a scalable, data-driven system to ensure product availability without excess stock. This repository contains the code, documentation, and insights for a solution adaptable to any sector.

## Project Overview
This project delivers a robust inventory optimization system built using PostgreSQL. I analyzed sales data, product attributes, and external economic indicators to determine optimal stock levels, reducing costs and enhancing demand responsiveness. The process involved importing and exploring datasets, cleaning and integrating them, and applying advanced SQL techniques to calculate reorder points, safety stock, and performance metrics. Automation through stored procedures and triggers, along with monitoring tools, ensures ongoing efficiency. The result is a dynamic system that minimizes waste, ensures availability, and supports strategic decision-making across industries.

## Business Problem
- **Overstocking**: Excess inventory ties up capital and storage space, increasing costs.
- **Understocking**: Stockouts of high-demand products lead to lost sales and reduced customer satisfaction.
- **Customer Experience**: Inefficient inventory management negatively impacts loyalty and trust.

## Project Objectives
- Determine optimal inventory levels for each product SKU to balance supply and demand.
- Enable data-driven decisions to reduce costs and enhance customer satisfaction.
- Build a scalable inventory optimization system using PostgreSQL analytics.

## Data Used
The project leverages three datasets, each providing critical insights for analysis:

1. **Sales Data**  
   - **Description**: Daily records of sales transactions, capturing product identifiers, dates, inventory quantities, and costs.
   - **Schema**:  
     - `product_id` (BIGINT): Unique product identifier.
     - `sales_date` (DATE): Date of the sales record.
     - `inventory_quantity` (INT): Units in stock.
     - `product_cost` (NUMERIC(5,2)): Cost per unit.
   - **Purpose**: Supports calculation of sales trends, stock levels, and reorder points.

2. **Product Data**  
   - **Description**: Details product attributes, including categories and promotional status.
   - **Schema**:  
     - `product_id` (BIGINT): Matches `product_id` in sales data.
     - `product_category` (VARCHAR(100)): Product category.
     - `promotions` (VARCHAR(5)): Indicates promotional status (e.g., 'yes' or 'no').
   - **Purpose**: Enables analysis of product-specific performance and promotion impacts.

3. **External Factors Data**  
   - **Description**: Economic indicators influencing demand, recorded by date.
   - **Schema**:  
     - `sales_date` (DATE): Date of the economic record.
     - `GDP` (NUMERIC(10,2)): Gross Domestic Product, reflecting economic health.
     - `inflation_rate` (FLOAT): Rate of price increases.
     - `seasonal_factor` (FLOAT): Seasonal demand multiplier.
   - **Purpose**: Enhances demand forecasting by assessing external economic influences.

**Data Import**:  
Datasets were imported into PostgreSQL using the `COPY` command for efficient bulk loading, e.g.:
```sql
COPY sales_data FROM '/path/to/sales_data.csv' DELIMITER ',' CSV HEADER;
COPY product_data FROM '/path/to/product_data.csv' DELIMITER ',' CSV HEADER;
COPY external_factors FROM '/path/to/external_factors.csv' DELIMITER ',' CSV HEADER;
```

## Approach and Methodology
The project followed a structured pipeline:
1. **Data Exploration**: Inspected datasets to understand structure, types, and quality.
2. **Data Cleaning**: Standardized formats, removed duplicates, and verified completeness.
3. **Data Integration**: Combined datasets into a unified view using SQL joins.
4. **Descriptive Analytics**: Calculated statistics (e.g., average sales, median stock) and identified top/least-selling products.
5. **External Factors Analysis**: Evaluated the impact of GDP and inflation on sales trends.
6. **Inventory Optimization**: Used SQL window functions to compute reorder points and safety stock.
7. **Automation**: Implemented stored procedures and triggers for real-time updates.
8. **Monitoring**: Developed queries to track inventory levels, sales trends, and stockouts.
9. **Feedback Loop**: Proposed a system for stakeholder input to drive continuous improvement.

## Key Techniques and Skills Demonstrated
- **Advanced SQL**: Window functions, stored procedures, triggers, and query optimization.
- **Data Analysis**: Exploratory analysis, descriptive statistics, and trend evaluation.
- **Inventory Management**: Reorder point and safety stock calculations, automation workflows.
- **Database Management**: Efficient data import, schema design, and view creation.

## Results and Insights
- **Inventory Imbalances**: Identified overstocked (e.g., Product 1387) and understocked products.
- **External Influences**: Linked positive GDP and inflation to increased sales, aiding forecasting.
- **Optimized Levels**: Established data-driven reorder points and safety stock for each SKU.

## Recommendations
- **Dynamic Inventory Management**: Adopt real-time adjustments based on sales trends and economic factors.
- **Regular Updates**: Continuously refine reorder points and safety stocks using automated processes.
- **Pricing Optimization**: Adjust prices for low-performing products (e.g., Product 8821) to boost sales.
- **Overstock Reduction**: Use promotions or discontinuation to clear excess inventory.
- **Feedback Loop**: Implement a portal and meetings for stakeholder input to ensure adaptability.
- **Proactive Monitoring**: Run monitoring queries daily to address discrepancies swiftly.

## Technologies Used
- **PostgreSQL**: Core platform for data storage, analysis, and automation.
- **SQL**: Primary language for queries, analytics, and process automation.

## Installation Instructions
To run this project locally:
1. **Install PostgreSQL**: Download and install PostgreSQL from [postgresql.org](https://www.postgresql.org/download/).
2. **Set Up Database**:
   - Create a database: `CREATE DATABASE inventory_optimization;`
   - Connect to the database: `\c inventory_optimization`
3. **Load Schema and Data**:
   - Run the schema creation script from `schema.sql` to create tables.
   - Import data using the `COPY` commands in `data_import.sql` (update file paths to your CSV files).
4. **Execute Queries**:
   - Run the SQL scripts in `SQL QUERY.sql` to perform analysis and set up automation.

**Requirements**:
- PostgreSQL 12 or later.
- CSV files for `sales_data`, `product_data`, and `external_factors` (sample data not provided due to privacy).

## How to Use
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/inventory-optimization-postgresql.git
   cd inventory-optimization-postgresql
   ```
2. **Set Up Database**: Follow the installation instructions above.
3. **Run Analysis**:
   - Execute scripts in `SQL QUERY.sql` sequentially to replicate the analysis pipeline.
   - Use monitoring functions (e.g., `monitor_inventory_levels()`) to view real-time metrics.
4. **Explore Documentation**: Refer to `Inventory Optimization with PostgreSQL Analytics.pdf` for detailed methodology.

## Project Structure
```
├── data_import.sql              # Scripts for importing data via COPY
├── schema.sql                   # Table creation scripts
├── SQL QUERY.sql                # Main SQL scripts for analysis and automation
├── Inventory Optimization with PostgreSQL Analytics.pdf  # Detailed project documentation
├── README.md                    # Project overview and instructions
```

## SQL Code
SQL scripts for data cleaning, integration, analysis, and automation are available in the `SQL QUERY.sql` file in this repository.

## Documentation
Comprehensive project details are available in the `Inventory Optimization with PostgreSQL Analytics.pdf` file in this repository.

## Conclusion
This project demonstrates the power of SQL-driven analytics to tackle inventory management challenges. By optimizing stock levels, organizations can enhance customer satisfaction, streamline operations, and boost profitability. Explore the code and documentation to see how PostgreSQL can transform data into actionable insights.

## 📌 **Follow me on:**  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](www.linkedin.com/in/olajimi-adeleke)  
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?logo=github)](https://github.com/jimi121?tab=repositories)   

📧 Email me at: [adelekejimi@gmail.com](mailto:adelekejimi@gmail.com)
