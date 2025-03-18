DROP DATABASE IF EXISTS adventureworks_dw;
CREATE DATABASE adventureworks_dw;
USE adventureworks_dw;

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
	full_date DATE NOT NULL
):

CREATE TABLE dim_customers (
    customer_key INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    customer_name VARCHAR(255),
    country VARCHAR(100)
);

CREATE TABLE dim_products (
    product_key INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    product_name VARCHAR(255),
    category VARCHAR(255)
);

CREATE TABLE fact_sales (
    sales_key INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_key INT,
    customer_key INT,
    date_key INT,
    unit_price DECIMAL(10,2),
    quantity INT,
    total_amount DECIMAL(12,2),
    FOREIGN KEY (product_key) REFERENCES dim_products(product_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customers(customer_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

INSERT INTO dim_date (date_key, full_date)
SELECT DISTINCT orderdate AS date_key, orderdate AS full_date 
FROM adventureworks.salesorderheader;

INSERT INTO dim_customers (customer_id, customer_name, country)
SELECT DISTINCT c.customerid, c.companyname, c.country 
FROM adventureworks.customer c;

INSERT INTO dim_products (product_id, product_name, category)
SELECT DISTINCT p.productid, p.productname, pc.categoryname
FROM adventureworks.product p
JOIN adventureworks.productcategory pc ON p.categoryid = pc.categoryid;


INSERT INTO fact_sales (order_id, product_key, customer_key, date_key, unit_price, quantity, total_amount)
SELECT 
    soh.salesorderid AS order_id,
    p.productid AS product_key,
    c.customerid AS customer_key,
    soh.orderdate AS date_key,
    sod.unitprice AS unit_price,
    sod.orderqty AS quantity,
    sod.unitprice * sod.orderqty AS total_amount
FROM adventureworks.salesorderdetail sod
JOIN adventureworks.salesorderheader soh ON sod.salesorderid = soh.salesorderid
JOIN adventureworks.customer c ON soh.customerid = c.customerid
JOIN adventureworks.product p ON sod.productid = p.productid;
