select *
from Unemployment_India

select *
from Unemployment_2020

--Updating M in Frequency column in the Unemployment_2020 table as Monthly
update Unemployment_2020
set [ Frequency]='Monthly'
where [ Frequency]=' M'


--Union of the 2 tables, storing all the columns of the union as CTE and creating a temp table using those columns
drop table if exists #whole;
with joined_table as
(
	select State, [ Date], [ Frequency], [ Estimated Unemployment Rate (%)], [ Estimated Employed], [ Estimated Labour Participation Rate (%)]
	from Unemployment_India
	union
	select State, [ Date], [ Frequency], [ Estimated Unemployment Rate (%)], [ Estimated Employed], [ Estimated Labour Participation Rate (%)]
	from Unemployment_2020
)
select *
into #whole
from joined_table

select *
from #whole

--Final table for both 2019, 2020, without latitude, longitude
select State, [ Date], ROUND(AVG([ Estimated Unemployment Rate (%)]),2) as Avg_EUR_prcnt, SUM([ Estimated Employed]) as Total_EE, ROUND(AVG([ Estimated Labour Participation Rate (%)]),2) as Avg_ELPR_prcnt
from #whole
group by [ Date], State


--Finding datatype of the Date column
select COLUMN_NAME,DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Unemployment_India' 
AND COLUMN_NAME = ' Date';

drop table if exists #whole1;
with joined_table1 as
(
	select *
	from 
	(
		select State, [ Date], [ Frequency], [ Estimated Unemployment Rate (%)], [ Estimated Employed], [ Estimated Labour Participation Rate (%)]
		from Unemployment_India
		union
		select State, [ Date], [ Frequency], [ Estimated Unemployment Rate (%)], [ Estimated Employed], [ Estimated Labour Participation Rate (%)]
		from Unemployment_2020
	) as c
	where RIGHT(c.[ Date], 2)='20'
)
select *
into #whole1
from joined_table1

select *
from #whole1

--Final table for 2020, with latitude, longitude
select a.State, a.[ Date], a.Avg_EUR_prcnt, a.Total_EE, a.Avg_ELPR_prcnt, Unemployment_2020.latitude, Unemployment_2020.longitude
from
(select State, [ Date], ROUND(AVG([ Estimated Unemployment Rate (%)]),2) as Avg_EUR_prcnt, SUM([ Estimated Employed]) as Total_EE, ROUND(AVG([ Estimated Labour Participation Rate (%)]),2) as Avg_ELPR_prcnt
from #whole1
group by [ Date], State) as a
left join Unemployment_2020
on a.[ Date]=Unemployment_2020.[ Date]