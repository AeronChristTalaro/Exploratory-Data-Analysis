# EDA/EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoffs_staging2;

SELECT max(total_laid_off)
FROM layoffs_staging2;

SELECT MAX(percentage_laid_off)
FROM layoffs_staging2;

#Shows every company individual
SELECT company, count(*) as total_company
FROM layoffs_staging2
WHERE percentage_laid_off = 1
group by company;

#Shows totality
SELECT COUNT(*) AS total_company
FROM layoffs_staging2
WHERE percentage_laid_off = 1;


SELECT company,SUM(total_laid_off) 
FROM layoffs_staging2
group by company;


WITH ranked_layoffs AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY company ORDER BY percentage_laid_off DESC, company) AS row_numb
    FROM layoffs_staging2
    WHERE percentage_laid_off = 1
)
SELECT *
FROM ranked_layoffs
WHERE row_num = 1;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
order by total_laid_off desc;
SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
order by funds_raised_millions desc;


#This count the sum of other company that has the same name
#ex. Amazon has 3 branches it counts each from 10k + 8k + 150 so total of 18150
Select COMPANY,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
order by 2 desc;

#Show industry from highest laid off to lowest
Select industry,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
order by 2 desc;

#Show country from highest laid off to lowest
Select country,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
order by 2 desc;


Select company
FROM layoffs_staging2
Where industry = 'consumer';
#Show the Min and Max Date
SELECT min(date), max(date)
FROM layoffs_staging2;



#Show date of highest laid off to lowest
Select `date`,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
order by 1 desc;

#Show date base on YEARS ALONE of highest laid off to lowest
Select YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
order by 1 desc;


#Show date base on YEARS AND MONTHS of highest laid off to lowest
SELECT 
    YEAR(`date`) AS year,
    MONTH(`date`) AS month,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`), MONTH(`date`)
ORDER BY year DESC, month DESC;


#ALMOST SAME AS ABOVE
SELECT SUBSTRING(`DATE` ,1,7) as Month, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`DATE` ,1,7) is not NULL
GROUP BY `MONTH`
ORDER BY 2 DESC;


#Rolling total/Additive laid off per month each year of laid off
WITH rolling_total as
(
SELECT SUBSTRING(`DATE` ,1,7) as Month, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`DATE` ,1,7) is not NULL
GROUP BY `MONTH`
ORDER BY 2 DESC
)
SELECT `MONTH`,total_off, sum(total_off)OVER(ORDER BY `MONTH`) as rolling_total1
FROM rolling_total  ;



SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
HAVING SUM(total_laid_off) IS NOT NULL
ORDER BY 3 desc;




#2020-2023 RANKINGS (PER YEAR)
WITH company_year(Company, Years, Total_Laid_Off) as
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER(PARTITION BY years Order By total_laid_off DESC) as Ranking
FROM company_year
where years is not NULL;



#RANKINGS AS A WHOLE
WITH company_year(Company, Years, Total_Laid_Off) as
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER(PARTITION BY years Order By total_laid_off DESC) as Ranking
FROM company_year
where years is not NULL
ORDER BY Ranking; 







#RANKINGS AS A WHOLE
WITH company_year(Company, Years, Total_Laid_Off) as
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank as
(SELECT *, DENSE_RANK() OVER(PARTITION BY years Order By total_laid_off DESC) as Ranking
FROM company_year
where years is not NULL
)
SELECT *
FROM Company_Year_Rank
WHERE RANKING <=5;



	SELECT company, YEAR(`date`), sum(total_laid_off)
	FROM layoffs_staging2
    WHERE total_laid_off is not NULL
    GROUP BY  company ,YEAR(`date`);



SELECT company, YEAR(`date`), total_laid_off
FROM layoffs_staging2
WHERE total_laid_off is not NULL and company = '100 Thieves';

SELECT *
FROM layoffs_staging2;

SELECT company, COUNT(company)
FROM layoffs_staging2
GROUP BY company
HAVING COUNT(company) > 1;