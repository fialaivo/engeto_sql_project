# SQL PROJEKT ENGETO
## Výstup projektu:
- Výstupem projektu by měly být dvě tabulky v databázi, ze kterých se požadovaná data dají získat. Tabulky pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) a t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).
## Výzkumné otázky:
- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
## Skripty:
1. **create_primary_final_table.sql** - skript vytváří tabulku kódů potravin, ve které je uvedeno pro dané časové období (roky 2006 - 2018) průměrná cena potraviny, průměrný plat pro příslušný rok a také HDP
   v ČR, z této tabulky vychází výsledky skriptů Q1.sql až Q5.sql
2. **create_secondary_final_table.sql** - skript vytváří tabulku s HDP, GINI koef. a populací dalších evropských států ve stejném období, jako primární přehled pro ČR
3. **Q1.sql** - skript odpovídající na první výzkunou otázku a to zda rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? *Z výsledné tabulky je patrné, že u celé řady odvětví došlo v průběhu let
  k meziročnímu poklesu mezd.*
4. **Q2.sql** - skript odpovídá na druhou výzkumnou otázku. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? *Z výsledku dotazu je možné říci,
   že v roce 2006 si bylo možné koupit za průměrný plat 1172,6 kg chleba a 1309 litrů mléka a v roce 2018 jste si mohli z průměrného platu koupit 1279 kg chleba a 1564 litrů mléka.*
5. **Q3.sql** - výstup skriptu odpovídá na třetí výzkumnou otázku. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? V této otázce jsem postupoval přesně podle zadání -
   neuvažoval jsem potraviny, které zlevňují. *Jako nejpomaleji zražující potravina mi vyšla banány žluté s průměrným ročním nárůstem ceny cca 0,81 procent.*
6. **Q4.sql** - skript odpovídá na otázku zda existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? *Výsledná tabulka za sebe řadí jednotlivé roky podle rozdílu růstu
   potravin a platů, z tabulky je patrné, že k tak výtaznému rustu (nad 10%) ani v jednom roce nedešlo.*
7. **Q5.sql** - skript hledá odpověď na otázku - pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem? V této otázce nebyla přímo
   specifikována hladina charakterizující výrazný růst HDP, proto jsem si ji zvolil na 5 procent. *Z tabulky je patrné, že k takovému růstu došlo ve třech letech (2007, 2015 a 2017), po prozkoumání dat mezd a cen
   potravin je možné konstatovat, že ve všech případech nedochází k výraznému růstu cen potravin nebo mezd ve stejném nebo následujícím roce. V některých případech došlo dokonce k poklesu.*

Ve jednotlivých skriptech je uveden základní popis pomocí komentářů. 
Ivo Fiala

