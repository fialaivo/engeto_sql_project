-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

CREATE OR REPLACE VIEW Deduplicated_Q4_View AS
WITH Deduplicated_Q4 AS (
	SELECT DISTINCT 
		category_code,
		cpyear,
		cpround,
		avg_annual_salary_cr,
		GDP
	FROM t_ivo_fiala_project_sql_primary_final AS pf
)
SELECT *
FROM Deduplicated_Q4;


-- Vytvoření CTE pro výpočet průměrných hodnot
WITH avg_food_salary AS (
	SELECT 
		cpyear, 
		round(avg(cpround), 2) AS avg_food, 
		avg_annual_salary_cr 
	FROM 
		deduplicated_q4_view AS dqv 
	GROUP BY 
		cpyear
)
-- Vytvoření finální tabulky, která obsahuje procentuální nárůst cen a platů
, q4 AS (
	SELECT 
		*,
		round((afs.avg_food - LAG(afs.avg_food) OVER (ORDER BY cpyear)) / 
			(LAG(afs.avg_food) OVER (ORDER BY cpyear)/100), 2) AS percent_food_increase,
		round((afs.avg_annual_salary_cr - LAG(afs.avg_annual_salary_cr) OVER (ORDER BY cpyear)) / 
			(LAG(afs.avg_annual_salary_cr) OVER (ORDER BY cpyear)/100), 2) AS percent_salary_increase
	FROM 
		avg_food_salary AS afs
)
-- Výběr finálních dat a výpočet rozdílu mezi procentuálním nárůstem cen potravin a platů
SELECT 
	*,
	q.percent_food_increase - q.percent_salary_increase AS different_food_salary
FROM 
	q4 AS q
ORDER BY 
	different_food_salary DESC;
