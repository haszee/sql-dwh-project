/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

/*
================================================================================
Pre View-creation checks
================================================================================
*/

-- Do join to get initial table
SELECT
	sd.sls_ord_num,
	pr.product_key, -- use surrogate key; don't need sd.sls_prd_key
	cu.customer_key, -- use surrogate key; don't need sd.sls_cust_id
	sd.sls_order_dt,
	sd.sls_ship_dt,
	sd.sls_due_dt,
	sd.sls_sales,
	sd.sls_quantity,
	sd.sls_price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id



/*
================================================================================
Post View-creation checks
================================================================================
*/

-- Check foreign key integrity (dimensions)
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
  ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL;

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
  ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
  ON p.product_key = f.product_key
WHERE p.product_key IS NULL;


SELECT * FROM gold.fact_sales;