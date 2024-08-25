-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- vytvoření tabulky Q3 - výpočet procentuálního nárůstu mezi jednotlivými lety (percent_increase) 
CREATE OR REPLACE TABLE Q3 AS
WITH Deduplicated_Q3 AS (
	SELECT DISTINCT 
		category_code,
		cpyear,
		cpround,
		avg_annual_salary_cr,
		GDP
	FROM t_ivo_fiala_project_sql_primary_final AS pf 
)
SELECT *,
	CASE 
		WHEN category_code = LAG(category_code) OVER (PARTITION BY category_code ORDER BY cpyear) THEN
			ROUND((cpround - LAG(cpround) OVER (PARTITION BY category_code ORDER BY cpyear)) / (LAG(cpround) OVER (PARTITION BY category_code ORDER BY cpyear) / 100), 2)
		ELSE 
			NULL 
	END AS percent_increase
FROM Deduplicated_Q3;

-- výpočet průměrného ročního nárustu, seřazení sestupně
-- odstranění položek u kterých došlo ke zlevnění
-- výpis potraviny podle category_code

WITH avg_increase_category AS(
	SELECT 
		category_code,
		avg(percent_increase) avg_increase 
	FROM q3 AS q 
	WHERE percent_increase IS NOT NULL 
	GROUP BY category_code 
	ORDER BY avg_increase 
)
SELECT 
	aic.category_code,
	min(aic.avg_increase),
	cpc.name 
FROM avg_increase_category AS aic
LEFT JOIN czechia_price_category AS cpc 
	ON aic.category_code = cpc.code 
WHERE aic.avg_increase > 0

