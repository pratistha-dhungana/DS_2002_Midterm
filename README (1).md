# DS-2002 Data Project 1

## Overview
This project demonstrates an ETL (Extract, Transform, Load) pipeline that processes structured and semi-structured data into a dimensional data warehouse (`adventureworks_dw`). The ETL workflow extracts data from **AdventureWorks**, transforms it into a usable format, and loads it into **MySQL** and **MongoDB** for analysis.

## Business Process Modeled
This project models a **Retail Sales Order Management System**, tracking transactions between customers and products over time.

- **Fact Table**: `fact_sales` - Stores transactional sales data.
- **Dimension Tables**:
  - `dim_date` - Tracks order dates.
  - `dim_customers` - Stores customer details.
  - `dim_products` - Stores product details.

## ETL Pipeline
The ETL pipeline extracts data from:
- **MySQL (`adventureworks`)**: Structured relational data.
- **MongoDB**: Semi-structured product data.
- **CSV File**: Customer information.

### Workflow:
1. **Extract Data**: Data is retrieved from SQL tables, MongoDB collections, and CSV files.
2. **Transform Data**:
   - Column renaming and data type conversions.
   - Handling missing or duplicate values.
   - Creating surrogate keys for dimensions.
3. **Load Data**:
   - Structured data is loaded into `adventureworks_dw` (MySQL).
   - Semi-structured product data is loaded into MongoDB.

## Database Schema

### `fact_sales` (Fact Table)
| sale_id | date_key | customer_key | product_key | quantity | total_price |
|---------|---------|-------------|-------------|----------|-------------|
| 1       | 20240301 | 101         | 201         | 2        | 49.98       |

### `dim_date` (Dimension Table)
| date_key | full_date |
|----------|-----------|
| 20240301 | 2024-03-01 |

### `dim_customers` (Dimension Table)
| customer_key | customer_name | city     | state | country |
|-------------|--------------|---------|-------|---------|
| 101         | John Doe     | Chicago | IL    | USA     |

### `dim_products` (Dimension Table)
| product_key | product_name | category    | price |
|------------|-------------|-------------|-------|
| 201        | Laptop      | Electronics | 999.99 |

## SQL Queries
To demonstrate functionality, the following queries were executed:

### 1. Total Sales by Year
```sql
SELECT d.calendar_year, SUM(f.total_price) AS total_sales
FROM adventureworks_dw.fact_sales f
JOIN adventureworks_dw.dim_date d ON f.date_key = d.date_key
GROUP BY d.calendar_year;
