-- Pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

CREATE OR REPLACE VIEW Deduplicated_Q5_View AS
WITH Deduplicated_Q5 AS (
	SELECT DISTINCT 
		category_code,
		cpyear,
		cpround,
		avg_annual_salary_cr,
		GDP
	FROM t_ivo_fiala_project_sql_primary_final AS pf
)
SELECT *
FROM Deduplicated_Q5;

-- Vytvoření CTE pro výpočet průměrných hodnot
WITH avg_food_salary AS (
	SELECT 
		cpyear, 
		round(avg(cpround), 2) AS avg_food, 
		avg_annual_salary_cr, 
		GDP
	FROM 
		deduplicated_q5_view AS dqv 
	GROUP BY 
		cpyear
)
-- Vytvoření finální tabulky, která obsahuje procentuální nárůst cen, platů a HDP
, q5 AS (
	SELECT 
		afs.cpyear,
		afs.avg_food,
		afs.avg_annual_salary_cr,
		afs.GDP,
		round((afs.avg_food - LAG(afs.avg_food) OVER (ORDER BY afs.cpyear)) / 
			(LAG(afs.avg_food) OVER (ORDER BY afs.cpyear)/100), 2) AS percent_food_increase,
		round((afs.avg_annual_salary_cr - LAG(afs.avg_annual_salary_cr) OVER (ORDER BY afs.cpyear)) / 
			(LAG(afs.avg_annual_salary_cr) OVER (ORDER BY afs.cpyear)/100), 2) AS percent_salary_increase,
		round((afs.GDP - LAG(afs.GDP) OVER (ORDER BY afs.cpyear)) / 
			(LAG(afs.GDP) OVER (ORDER BY afs.cpyear)/100), 2) AS percent_GDP_increase
	FROM 
		avg_food_salary AS afs
)
, marked_rows AS (
-- za výrazný růst HDP jsem si označil růst vyšší než 5 procent - sloupec flag, označení i sloupce následujícího po vysokém růstu 
	SELECT 
		*,
		CASE 
			WHEN percent_GDP_increase > 5 THEN 1
			WHEN LAG(percent_GDP_increase) OVER (ORDER BY cpyear) > 5 THEN 1
			ELSE 0
		END AS flag
	FROM 
		q5
)
-- výpis let ve kterých došlo k vyššímu růstu HDP a také výpis roku následujícího po tomto roku
SELECT * 
FROM marked_rows
WHERE flag = 1
ORDER BY cpyear;