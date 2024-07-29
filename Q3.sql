-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- vytvoření tabulky Q3 - výpočet procentuálního nárůstu mezi jednotlivými lety (percent_increase) a indikace změny potraviny (change_category_code)
CREATE OR REPLACE TABLE Q3 
SELECT *,
	round((cpround - LAG(cpround) OVER (ORDER BY category_code, cpyear)) / ( LAG(cpround) OVER (ORDER BY category_code, cpyear)/ 100),2) AS percent_increase,
	CASE 
	    WHEN category_code = LAG(category_code) OVER (ORDER BY category_code , cpyear) THEN 0
	    ELSE 1
	END AS change_category_code
FROM t_ivo_fiala_project_sql_primary_final tifpspf

-- uprava dat v tabulce q3, změna hodnoty sloupce percent_increase
-- měním hodnotu na NULL u těch řádků, kde dochází u vstupních dat ke změně potraviny

UPDATE q3 
SET percent_increase = NULL 
WHERE change_category_code = 1;

-- výpočet průměrného ročního nárustu, seřazení sestupně
-- odstranění položek u kterých došlo ke zlevnění
-- výpis potraviny podle category_code
 

WITH avg_increase_category AS(
	SELECT 
		category_code,
		avg(percent_increase) avg_increase 
	FROM q3 q 
	WHERE percent_increase IS NOT NULL 
	GROUP BY category_code 
	ORDER BY avg_increase 
)
SELECT 
	aic.category_code,
	min(aic.avg_increase),
	cpc.name 
FROM avg_increase_category aic
LEFT JOIN czechia_price_category cpc 
	ON aic.category_code = cpc.code 
WHERE aic.avg_increase > 0

