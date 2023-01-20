#########################################################################################
-- we are starting with creating a database name 'Project_India_Census' for this project.
-- importing the two datasets for this project data1 and data2
########################################################################################

create database Project_India_Census;
use Project_India_Census;
select * from data1;
describe data1;  -- this will provide the details of data types associated with each column

-- Growth column is showing as text instead of double type
-- need to covert it to double
-- and change the name of the column to Growth_percent

alter table data1
rename column Growth to Growth_Percent;      -- renaming the column
update data1
set Growth_Percent = replace(Growth_Percent,'%','');       -- removing the % sign as it will create issue

alter table data1
modify Growth_Percent double;           -- Converting the datatype


select * from data2;
describe data2;
-- Area_Km2, Population is showing as text in data2 need to covert it to int

update data2
set Area_Km2 = replace(Area_Km2, ',','');     -- removing ',' as it will create problem
update data2
set Population = replace(Population, ',','');   -- removing ',' as it will create problem

alter table data2
modify Area_km2 int;
alter table data2
modify Population int;

##################################################################### 
##################################################################
#######################################################

-- 1) want to know the number of rows in our data set
select count(*) as count_of_data1 from data1; 
select count(*) as count_of_data2 from data2;

-- 2) want to find data for Uttar Pradesh and Bihar only
select * from data1 where state in ('Uttar Pradesh', 'Bihar');

-- 3) want to know total population
select sum(Population) as total_population from data2;

-- 4) Average Growth by state
select state,round(avg(growth_percent)) as Avg_Growth_percent from data1 group by state order by avg(growth_percent) desc;

-- 5) Average Sex Ratio by state
select state, round((Sex_Ratio)) as Avg_Sex_Ratio from data1 group by state order by avg(Sex_Ratio) desc;

-- 6) Average Literacy Rate by state
select state,round(avg(Literacy)) as Avg_Literacy_rate from data1 group by state order by avg(Literacy) desc;

-- 7) How many states having Literacy rate greater than 90%
select state,round(avg(Literacy)) as Avg_Literacy_rate from data1 
    group by state 
    having round(avg(Literacy)) >90
	order by avg(Literacy) desc;

-- 8) Top 3 states showing highest growth ratio
select state,round(avg(growth_percent)) as Avg_Growth_percent from data1 group by state order by avg(growth_percent) desc limit 3;

-- 9) list of 5 states having lowest sex ratio
select state, round((Sex_Ratio)) as Avg_Sex_Ratio from data1 group by state order by avg(Sex_Ratio) asc limit 5;

-- 10) top and Bottom 3 states in literacy ratio
(select state,round(avg(Literacy)) as Avg_Literacy_rate from data1 group by state order by avg(Literacy) desc limit 3) 
union
(select state,round(avg(Literacy)) as Avg_Literacy_rate from data1 group by state order by avg(Literacy) asc limit 3) ;

-- 11) Filter out the states starting with letter 'a'
select distinct state from data1 where lower(state) like 'a%';

#################################################################################
-- Now combining both the dataset data1 and data2
#################################################################################

-- Joining both the data on the basis of common entry 'District'
select d1.district, d1.state, d1.sex_ratio, d2.population from data1 d1
join data2 d2
on d1.district = d2.district;

-- 12) Find count of males and females statewise
select b.state, sum(b.male) as Total_Male,sum(b.female) as Total_Female from
(select a.district, a.state, (a.population/(1 + a.sex_ratio)) as male,  (a.population*a.sex_ratio)/(1 + a.sex_ratio)  as female from
(select d1.district, d1.state, d1.sex_ratio/1000 sex_ratio, d2.population
from data1 d1
join data2 d2
on d1.district = d2.district) a) b
group by state;

-- 13) Find count of total Literate and Illiterate Peoples Statewise
select b.state, sum(b.Literate_Peoples) Total_Literate, sum(b.Illiterate_peoples) Total_Illiterate from 
(select a.district, a.state, round(a.literacy_ratio*a.population) Literate_Peoples, round((1-a.literacy_ratio)*a.population) Illiterate_Peoples from
(select d1.district, d1.state, d1.literacy/100 literacy_ratio, d2.population from data1 d1 join data2 d2
on d1.district = d2.district) a) b
group by b.state; 

-- 14) Population in Previous Census
select a.district, a.state, round(a.population/(1+Growth)) Previous_Census_Population, a.population Current_Census_Population from
(select d1.district, d1.state, d1.Growth_Percent/100 Growth, d2.population from data1 d1
join data2 d2
on d1.district = d2.district) a;

-- 15) Want to Know what is the total Population In Prev. Census and the current Census
select sum(b.Previous_Census_Population) Previous_Census_Population, sum(b.Current_Census_Population) Current_Census_Population from
(select a.district, a.state, round(a.population/(1+Growth)) Previous_Census_Population, a.population Current_Census_Population from
(select d1.district, d1.state, d1.Growth_Percent/100 Growth, d2.population from data1 d1
join data2 d2
on d1.district = d2.district) a) b;

-- 16) Population by Area
select (p.total_area/p.previous_census_population)*100 current_pop_VS_Area, (p.total_area/p.current_census_population)*100 prev_pop_VS_Area from
(select y.*,z.Total_Area from (
select '1' as common,t1.* from (
select sum(b.Previous_Census_Population) Previous_Census_Population, sum(b.Current_Census_Population) Current_Census_Population from
(select a.district, a.state, round(a.population/(1+Growth)) Previous_Census_Population, a.population Current_Census_Population from
(select d1.district, d1.state, d1.Growth_Percent/100 Growth, d2.population from data1 d1
join data2 d2
on d1.district = d2.district) a) b) t1) y
join (
select '1' as common,t2.* from
( select sum(area_km2) Total_Area from data2) t2) z on y.common = z.common) p; 


-- 17) Using Window Functions find top 3 district from each state with highest literacy rate
select a.* from
(select district, state, literacy, rank() over(partition by state order by literacy desc) ranking from data1) a
where a.ranking in (1,2,3) order by a.state;

