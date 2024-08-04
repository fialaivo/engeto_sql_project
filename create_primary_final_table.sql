-- průměrná mzda v ČR
CREATE OR REPLACE VIEW v_avg_annual_salary AS 
	SELECT
		payroll_year,
		avg(value) as avg_annual_salary
	FROM czechia_payroll cp 
	WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NULL AND payroll_year >= 2006 AND payroll_year <= 2018
	GROUP BY payroll_year 
	ORDER BY payroll_year;

-- vytvoření tabulky s průměrnými cenami potravin v jednotlivých letech, připojen sloupec s průměrnými platy v jednotlivých letech
CREATE OR REPLACE TABLE t_Ivo_Fiala_project_SQL_primary_final AS
WITH avg_prices AS (
-- průměrné ceny potravin v jednotlivých letech
	SELECT 
		category_code, 
		YEAR(date_from) AS cpyear, 
		round(avg(value),2) AS cpround  
	FROM czechia_price cp 
	WHERE region_code IS NULL 
	GROUP BY category_code, YEAR(date_from)
	ORDER BY category_code, date_from  
)
SELECT 
	avgp.*,	
	vaas.avg_annual_salary 
FROM avg_prices AS avgp
JOIN v_avg_annual_salary AS vaas
ON avgp.cpyear = vaas.payroll_year 
ORDER BY avgp.category_code, avgp.cpyear;
