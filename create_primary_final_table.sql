-- průmyslová odvětví a průměrné mzdy v jednotlivých letech
CREATE OR REPLACE TABLE industry_payroll 
	WITH avg_salary_by_sector AS(
		SELECT
		payroll_year ,
		industry_branch_code ,
		avg(value) AS avg_annual_salary
		FROM czechia_payroll AS cp 
		WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL 
		GROUP BY payroll_year, industry_branch_code 
		ORDER BY industry_branch_code, payroll_year 
	)
	SELECT 
		payroll_year,
		industry_branch_code,
		avg_annual_salary
	FROM avg_salary_by_sector;

-- průměrná mzda v ČR
CREATE OR REPLACE VIEW v_avg_annual_salary_cr AS 
	SELECT
		payroll_year,
		avg(value) AS avg_annual_salary_cr
	FROM czechia_payroll AS cp 
	WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NULL AND payroll_year >= 2006 AND payroll_year <= 2018
	GROUP BY payroll_year 
	ORDER BY payroll_year;

-- HDP v ČR v letech 2006 až 2018
CREATE OR REPLACE VIEW v_HDP_cz AS 
	SELECT country, YEAR, GDP
	FROM economies AS e 
	WHERE country = "Czech Republic" AND year >= 2006 AND year <= 2018 
	ORDER BY YEAR;

CREATE OR REPLACE TABLE prices_salary_GDP AS
WITH avg_prices AS (
-- průměrné ceny potravin v jednotlivých letech
	SELECT 
	category_code, 
	YEAR (date_from) cpyear, 
	round(avg(value),2) cpround  
	FROM czechia_price AS cp 
	WHERE region_code IS NULL 
	GROUP BY category_code, YEAR (date_from)
	ORDER BY category_code, date_from  
)
SELECT 
	ap.*,	
	vas.avg_annual_salary_cr,
	hdp.GDP
FROM avg_prices AS ap, v_avg_annual_salary_cr AS vas, v_HDP_cz AS hdp 
WHERE ap.cpyear = vas.payroll_year AND ap.cpyear = hdp.YEAR
ORDER BY ap.category_code, ap.cpyear;

CREATE OR REPLACE TABLE t_ivo_fiala_project_sql_primary_final AS
SELECT *
FROM industry_payroll
CROSS JOIN prices_salary_gdp AS psg;