-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- code chleba 111301 mléko 114201
   
WITH Deduplicated_Q2 AS (
    SELECT DISTINCT 
        category_code,
        cpyear,
        cpround,
        avg_annual_salary_cr,
        GDP
    FROM t_ivo_fiala_project_sql_primary_final pf 
    WHERE (pf.cpyear = (SELECT min(cpyear) FROM t_ivo_fiala_project_sql_primary_final)
       OR pf.cpyear = (SELECT max(cpyear) FROM t_ivo_fiala_project_sql_primary_final))
       AND ((pf.category_code = 111301) OR (pf.category_code = 114201))
)
SELECT *,
	round(Deduplicated_Q2.avg_annual_salary_cr / Deduplicated_Q2.cpround, 2) how_many 
FROM Deduplicated_Q2
ORDER BY category_code, cpyear;

