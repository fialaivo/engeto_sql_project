-- tabulka s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR
CREATE OR REPLACE TABLE t_ivo_fiala_project_sql_secondary_final AS
SELECT country, `year`, GDP, gini, population
FROM economies e 
WHERE country IN (
	SELECT country 
	FROM countries c
	WHERE continent = 'Europe' 
) AND `year` >= 2006 AND `year` <= 2018
ORDER BY country, `year` ASC 
