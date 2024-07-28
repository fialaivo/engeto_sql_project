SELECT *
FROM czechia_payroll cp 
WHERE calculation_code = 100 AND value_type_code = 5958 AND industry_branch_code IS NULL 

-- průměrná mzda v ČR
CREATE OR REPLACE VIEW v_avg_annual_salary AS 
	SELECT
	payroll_year,
	avg(value) as avg_annual_salary
	FROM czechia_payroll cp 
	WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NULL AND payroll_year >= 2006 AND payroll_year <= 2018
	GROUP BY payroll_year 
	ORDER BY payroll_year 

SELECT *
FROM czechia_price cp 
WHERE region_code IS NULL 
ORDER BY category_code, date_from

-- průměrné ceny potravin v jednotlivých letech
SELECT 
	category_code, 
	YEAR (date_from) cpyear, 
	round(avg(value),2) cpround  
FROM czechia_price cp 
WHERE region_code IS NULL 
GROUP BY category_code, YEAR (date_from)
ORDER BY category_code, date_from 

CREATE OR REPLACE TABLE t_Ivo_Fiala_project_SQL_primary_final AS
WITH avg_prices AS (
	SELECT 
	category_code, 
	YEAR (date_from) cpyear, 
	round(avg(value),2) cpround  
	FROM czechia_price cp 
	WHERE region_code IS NULL 
	GROUP BY category_code, YEAR (date_from)
	ORDER BY category_code, date_from  
)
SELECT 
	avgp.*,	
	vaas.avg_annual_salary 
FROM avg_prices as avgp, v_avg_annual_salary AS vaas
WHERE avgp.cpyear = vaas.payroll_year 
ORDER BY avgp.category_code, avgp.cpyear