SELECT * 
FROM world_life_expectancy;
-- data cleaning 
-- step 1 finding duplicatea

SELECT country, year, concat(country,year), count(concat(country,year)) 
FROM world_life_expectancy
group by country, year, concat(country,year)
having  count(concat(country,year))  > 1;

SELECT Row_ID, concat(country,year),
row_number() over(partition by concat(country,year) order by concat(country,year)) as the_row_num
FROM world_life_expectancy;

SET SQL_SAFE_UPDATES = 0;

select *
from
(
	SELECT Row_ID, concat(country,year),
	row_number() over(partition by concat(country,year) order by concat(country,year)) as the_row_num
	FROM world_life_expectancy
) as the_row_table
where the_row_num > 1 ;

delete from world_life_expectancy
where 
Row_ID in (

select Row_ID
from
(
	SELECT Row_ID, concat(country,year),
	row_number() over(partition by concat(country,year) order by concat(country,year)) as the_row_num
	FROM world_life_expectancy
) as the_row_table
where the_row_num > 1 
);
-- the query abbove removes all the duplicate rows alter
-- using a query that first identitifies the duplicate row id


SELECT * 
FROM world_life_expectancy
where status  = '';

select distinct(status)
FROM world_life_expectancy
where status != '';

select distinct(country)
FROM world_life_expectancy
where status = 'developing';

update world_life_expectancy t1
join world_life_expectancy t2
	ON t1.country = t2.country
set t1.status = 'Developing'
where t1.status = '' 
and t2.status <> ''
and t2.status = 'Developing';

update world_life_expectancy t1
join world_life_expectancy t2
	ON t1.country = t2.country
set t1.status = 'Developed'
where t1.status = '' 
and t2.status <> ''
and t2.status = 'Developed';

SELECT * 
FROM world_life_expectancy;

-- filling other blanks

SELECT *
FROM world_life_expectancy
where Lifeexpectancy = '';


SELECT t1.Country, t1.year, t1.Lifeexpectancy,
t2.Country, t2.year, t2.Lifeexpectancy,
t3.Country, t3.year, t3.Lifeexpectancy,
round((t2.Lifeexpectancy+t3.Lifeexpectancy)/2,1)
FROM world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
    and t1.year = t2.year - 1
join world_life_expectancy t3
	on t1.country = t3.country
    and t1.year = t3.year + 1
where t1.Lifeexpectancy = '';

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
    and t1.year = t2.year - 1
join world_life_expectancy t3
	on t1.country = t3.country
    and t1.year = t3.year + 1
set t1.Lifeexpectancy = round((t2.Lifeexpectancy+t3.Lifeexpectancy)/2,1)
where t1.Lifeexpectancy = '';

sELECT *
FROM world_life_expectancy;

-- exploratory data analysis
SELECT country, 
min(Lifeexpectancy), 
max(Lifeexpectancy),
ROUND((max(Lifeexpectancy)-min(Lifeexpectancy)),2)
FROM world_life_expectancy
group by country
having min(Lifeexpectancy) <> 0
and  max(Lifeexpectancy) <> 0
order by country ;


SELECT *
FROM world_life_expectancy
where country = 'Saint Kitts and Nevis';

SELECT year, round(avg(Lifeexpectancy),2)
FROM world_life_expectancy
group by year
order by year;

-- checking for correlation between gdp and life expectancy
SELECT country, 
round(avg(Lifeexpectancy),2) as avg_Lifeexpectancy, 
round(avg(GDP),2) as avg_gdp
FROM world_life_expectancy
group by country
having avg_gdp > 0
and avg_Lifeexpectancy >0
order by avg_gdp;


SELECT 

sum(case when GDP >= 1500 then 1 else 0 end) high_gdp_count,
avg(case when GDP >= 1500 then Lifeexpectancy else null end) high_gdp_Lifeexpectancy,
sum(case when GDP < 1500 then 1 else 0 end) low_gdp_count,
avg(case when GDP <
 1500 then Lifeexpectancy else null end) low_gdp_Lifeexpectancy
FROM world_life_expectancy;

-- relationship between life expectancy and status

SELECT status,  count(distinct country),round(avg(Lifeexpectancy),2)
FROM world_life_expectancy
group by status;


SELECT status, count(distinct country)
FROM world_life_expectancy
group by status;

-- relationship between life expectanct and bmi
SELECT country, 
round(avg(Lifeexpectancy),2) as avg_Lifeexpectancy, 
round(avg(BMI),2) as BMI
FROM world_life_expectancy
group by country
having BMI > 0
and avg_Lifeexpectancy >0
order by BMI;

-- rolling total on death mortality over 15 years
SELECT country,
year, 
Lifeexpectancy,
AdultMortality,
sum(AdultMortality) over(partition by country order by year) as rolling_total
FROM world_life_expectancy;



