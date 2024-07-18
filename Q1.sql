WITH avg_salary_by_sector AS(
	SELECT
	payroll_year ,
	industry_branch_code ,
	avg(value) as prumerna_rocni_mzda
	FROM czechia_payroll cp 
	WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL 
	GROUP BY payroll_year, industry_branch_code 
	ORDER BY industry_branch_code, payroll_year 
)
SELECT 
  	payroll_year,
  	industry_branch_code,
    prumerna_rocni_mzda,
    prumerna_rocni_mzda - LAG(prumerna_rocni_mzda) OVER (ORDER BY industry_branch_code, payroll_year) AS difference_from_previous,
    CASE 
    	WHEN industry_branch_code = LAG(industry_branch_code) OVER (ORDER BY industry_branch_code, payroll_year) THEN 0
    	ELSE 1
    END AS porovnani 
FROM avg_salary_by_sector;