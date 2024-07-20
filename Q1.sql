-- tvorba tabulky q1 - výpočet průměrné roční mzdy v jednotlivých rocích pro jednotlivá odvětví  (avg_annual_salary), 
-- výpočet rozdílu ve mzdách mezi jednotlivými roky (different_from_previous)
-- indikace změny odvětví (change_branch_code)

CREATE OR REPLACE TABLE Q1 
	WITH avg_salary_by_sector AS(
		SELECT
		payroll_year ,
		industry_branch_code ,
		avg(value) as avg_annual_salary
		FROM czechia_payroll cp 
		WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL 
		GROUP BY payroll_year, industry_branch_code 
		ORDER BY industry_branch_code, payroll_year 
	)
	SELECT 
	  	payroll_year,
	  	industry_branch_code,
	    avg_annual_salary,
	    avg_annual_salary - LAG(avg_annual_salary) OVER (ORDER BY industry_branch_code, payroll_year) AS difference_from_previous,
	    CASE 
	    	WHEN industry_branch_code = LAG(industry_branch_code) OVER (ORDER BY industry_branch_code, payroll_year) THEN 0
	    	ELSE 1
	    END AS change_branch_code 
	FROM avg_salary_by_sector;

-- uprava dat v tabulce q1, změna hodnoty sloupce different_from_previous (udává meziroční změnu mzdy v příslušném odvětví)
-- měním hodnotu na NULL u těch řádků, kde dochází u vstupních dat ke změně odvětví

UPDATE q1 
SET difference_from_previous = NULL 
WHERE change_branch_code = 1;

-- přidání názvu odvětví a vypsání roků, ve kterých došlo k meziročnímu poklesu poklesu mezd v jednotlivých odvětvích

SELECT q1.*, cpib.name
FROM q1 
INNER JOIN czechia_payroll_industry_branch cpib 
ON q1.industry_branch_code = cpib.code 
WHERE q1.difference_from_previous < 0
