-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- Vytvoření CTE pro výpočet průměrných hodnot
WITH avg_food_salary AS (
    SELECT 
        cpyear, 
        round(avg(cpround), 2) AS avg_food, 
        avg_annual_salary 
    FROM 
        t_ivo_fiala_project_sql_primary_final tifpspf
    GROUP BY 
        cpyear
)
-- Vytvoření finální tabulky, která obsahuje procentuální nárůst cen a platů
, q4 AS (
    SELECT 
        *,
        round((afs.avg_food - LAG(afs.avg_food) OVER (ORDER BY cpyear)) / 
              (LAG(afs.avg_food) OVER (ORDER BY cpyear)/100), 2) AS percent_food_increase,
        round((afs.avg_annual_salary - LAG(afs.avg_annual_salary) OVER (ORDER BY cpyear)) / 
              (LAG(afs.avg_annual_salary) OVER (ORDER BY cpyear)/100), 2) AS percent_salary_increase
    FROM 
        avg_food_salary afs
)

-- Výběr finálních dat a výpočet rozdílu mezi procentuálním nárůstem cen potravin a platů
SELECT 
    *,
    q.percent_food_increase - q.percent_salary_increase AS different_food_salary
FROM 
    q4 q
ORDER BY 
    different_food_salary DESC;
