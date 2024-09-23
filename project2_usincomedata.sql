-- data cleaning
select *
from USHouseholdIncome;

select *
from ushouseholdincome_statistics;

select *
from
(
select row_id, 
id,
row_number()over(partition by id order by id) row_nom
from USHouseholdIncome
) as duplicates
where row_nom > 1
;
-- deleting duplicates
delete from USHouseholdIncome
where row_id in (
	select row_id
	from
		(
		select row_id, 
		id,
		row_number()over(partition by id order by id) row_nom
		from USHouseholdIncome
		) 	as duplicates
where row_nom > 1);


select id,
count(id)
from ushouseholdincome_statistics
group by id
having count(id) > 1;

select distinct State_Name
from ushouseholdincome_statistics
order by 1;

select *
from USHouseholdIncome
where State_Name = 'alabama' ;


update USHouseholdIncome
set State_Name = 'Alabama'
where State_Name = 'alabama';

select Type, count(type)
from USHouseholdIncome
group by Type;

update USHouseholdIncome
set Type = 'Borough'
where Type = 'Boroughs';

select AWater, ALand
from USHouseholdIncome
where (ALand = 0
or ALand = ''
or ALand = null)

-- exploratory data analysis
select *
from USHouseholdIncome;

select *
from ushouseholdincome_statistics;

-- looking at the sum of land and water by state 

select State_Name, Sum(ALand), Sum(AWater)
from USHouseholdIncome
group by State_Name
Order by 3 desc
limit 10;

-- joining both tables
select uh.State_Name, County, Type, `Primary`, Mean, Median
from USHouseholdIncome uh
join ushouseholdincome_statistics ui
	on uh.id = ui.id
where mean <> 0;
    
    
--
select uh.State_Name, round(avg(Mean),1), round(avg(Median),1)
from USHouseholdIncome uh
join ushouseholdincome_statistics ui
	on uh.id = ui.id
where mean <> 0
group by uh.State_Name
order by 2 desc
limit 5
;


select Type, count(type), round(avg(Mean),1), round(avg(Median),1)
from USHouseholdIncome uh
join ushouseholdincome_statistics ui
	on uh.id = ui.id
where mean <> 0
group by 1
order by 3 desc
limit 20;



select *
from USHouseholdIncome
where type = 'Community';

select Type, count(type), round(avg(Mean),1), round(avg(Median),1)
from USHouseholdIncome uh
join ushouseholdincome_statistics ui
	on uh.id = ui.id
where mean <> 0
group by 1
having count(type) > 100
order by 3 desc
limit 20;

select uh.State_Name, City, round(avg(Mean), 1), round(avg(Median), 1)
from USHouseholdIncome uh
join ushouseholdincome_statistics ui
	on uh.id = ui.id
group by uh.State_Name, City
order by 3 desc 


