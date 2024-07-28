-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- code chleba 111301 mléko 114201
SELECT 
	tifpspf.*, 
	cpc.name,
	round(tifpspf.avg_annual_salary / tifpspf.cpround, 2) how_many 
FROM t_ivo_fiala_project_sql_primary_final tifpspf 
LEFT JOIN czechia_price_category cpc 
	ON tifpspf.category_code = cpc.code 
WHERE (tifpspf.cpyear = (SELECT min(cpyear) FROM t_ivo_fiala_project_sql_primary_final)
   OR tifpspf.cpyear = (SELECT max(cpyear) FROM t_ivo_fiala_project_sql_primary_final))
   AND ((tifpspf.category_code = 111301) OR (tifpspf.category_code = 114201))

