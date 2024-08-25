-- tvorba tabulky q1 - výpočet průměrné roční mzdy v jednotlivých rocích pro jednotlivá odvětví  (avg_annual_salary), 
-- výpočet rozdílu ve mzdách mezi jednotlivými roky (different_from_previous)
-- indikace změny odvětví (change_branch_code)

CREATE OR REPLACE TABLE q1
WITH Deduplicated_Q1 AS (
	SELECT DISTINCT
		payroll_year,
		industry_branch_code,
		avg_annual_salary
	FROM t_ivo_fiala_project_sql_primary_final AS pf 
)
SELECT 
	payroll_year,
	industry_branch_code,
	avg_annual_salary,
	avg_annual_salary - LAG(avg_annual_salary) 
		OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS difference_from_previous
FROM Deduplicated_Q1
ORDER BY industry_branch_code, payroll_year;

SELECT q1.*, cpib.name
FROM q1 
INNER JOIN czechia_payroll_industry_branch cpib 
ON q1.industry_branch_code = cpib.code 
WHERE q1.difference_from_previous < 0;

