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
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line, 
	pn.prd_start_dt,
	pn.prd_end_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info as pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id;

-- Check whether there are any duplicates
SELECT prd_key, COUNT(*) FROM (
	SELECT 
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line, 
	pn.prd_start_dt,
	pn.prd_end_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info as pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filter  out all historical data
)t 
GROUP BY prd_key
HAVING COUNT(*) > 1;

/*
================================================================================
Post View-creation checks
================================================================================
*/


SELECT * FROM gold.dim_products;