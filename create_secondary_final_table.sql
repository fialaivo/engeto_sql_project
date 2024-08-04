-- průměrná mzda v ČR
CREATE OR REPLACE VIEW v_avg_annual_salary AS 
	SELECT
		payroll_year,
		avg(value) as avg_annual_salary
	FROM czechia_payroll cp 
	WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NULL AND payroll_year >= 2006 AND payroll_year <= 2018
	GROUP BY payroll_year 
	ORDER BY payroll_year;

-- HDP v ČR v letech 2006 až 2018
CREATE OR REPLACE VIEW v_HDP_cz AS 
	SELECT country, YEAR, GDP
	FROM economies e 
	WHERE country = "Czech Republic" AND year >= 2006 AND year <= 2018 
	ORDER BY YEAR;

CREATE OR REPLACE TABLE t_Ivo_Fiala_project_SQL_secondary_final AS
WITH avg_prices AS (
-- průměrné ceny potravin v jednotlivých letech
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
	vaas.avg_annual_salary,
	hdp.GDP
FROM avg_prices AS avgp, v_avg_annual_salary AS vaas, v_HDP_cz AS hdp 
WHERE avgp.cpyear = vaas.payroll_year AND avgp.cpyear = hdp.YEAR
ORDER BY avgp.category_code, avgp.cpyear