select * from cen..data1
select * from cen..data2
select count(*) from cen..Data1

--dataset for jharkhand and bihar
select * from cen..data1 where state in ('Jharkhand','Bihar')

--total pop of india
select sum(population) population from cen..data2

--avg grwoth
select avg(growth)*100 avg_growth from cen..data1
select avg(Sex_ratio) avg_s_r from cen..data1

--avg growth by state
select state,avg(growth)*100 avg_growth from cen..data1 group by state

--avg sex ratio by state
select state,round(avg(Sex_Ratio),0) avg_sex_ratio from cen..data1 group by state order by avg_sex_ratio  desc

--avg literacy rate
select state,round(avg(Literacy),0) avg_literacy_ratio from cen..data1 group by state 
having round(avg(Literacy),0) >90 order by avg_literacy_ratio desc

--top 3 states
select top 3 state,avg(growth)*100 avg_growth from cen..data1 group by state order by avg_growth  desc
select state,avg(growth)*100 avg_growth from cen..data1 group by state order by avg_growth desc limit 3

select top 3 state,avg(growth)*100 avg_growth from cen..data1 group by state order by avg_growth  asc
select top 3 state,round(avg(Sex_Ratio),0) avg_sex_ratio from cen..data1 group by state order by avg_sex_ratio asc

--top and bottom 
drop table if exists #topstates
create table #topstates
(state nvarchar(100),
 topstates float
)
insert into #topstates
select state,round(avg(Literacy),0) avg_literacy_ratio from cen..data1 group by state order by avg_literacy_ratio
select top 3 * from #topstates order by #topstates.topstates desc

drop table if exists #bottomstates
create table #bottomstates
(state nvarchar(100),
 bottomstates float
)
insert into #bottomstates
select state,round(avg(Literacy),0) avg_literacy_ratio from cen..data1 group by state order by avg_literacy_ratio
select top 3 * from #bottomstates order by #bottomstates.bottomstates asc

--union operator
select * from(
select top 3 * from #topstates order by #topstates.topstates desc) a
union
select * from (
select top 3 * from #bottomstates order by #bottomstates.bottomstates asc) b

--states starting with lettter a
select distinct  state from cen..data1 where lower(state) like 'a%' or lower(state) like 'b%' 
select distinct  state from cen..data1 where lower(state) like 'a%' and lower(state) like '%s'

--total males and females join males=population/(sex_ratio+1) female=popualtion(sex_ratio)/(sex_ratio+1)
select d.state ,sum(d.males) total_males ,sum(d.females) total_females from
(select c.district,c.state, round(c.population/(c.sex_ratio+1),0) males , round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio ,b.population from cen..data1 a inner join cen..data2 b on a.District=b.district ) c )d 
group by d.state

--total literacy rate 
select d.state ,sum(literate_population) total_literate_population ,sum(illiterate_population) total_illiterate_population from
(select c.district,c.state, round(c.literacy_rate*c.Population,0) literate_population , round(c.Population-(c.literacy_rate*c.Population),0) illiterate_population from
(select a.district,a.state,a.Literacy/100 literacy_rate ,b.population from cen..data1 a inner join cen..data2 b on a.District=b.district )c) d
group by d.state

--pop in previous census
select sum(c.previous_census_population) previous_census_population, sum(c.current_census_population) current_census_population from( 
select e.state,sum(e.previous_census_population) previous_census_population ,sum(e.current_census_population) current_census_population from
(select d.District,d.state,round(d.population/(1+d.growth_rate),0) previous_census_population ,d.population current_census_population from
(select a.district,a.state,a.growth growth_rate ,b.population from cen..data1 a inner join cen..data2 b on a.District=b.district) d) e
group by e.state)c

--population vs area
select (g.total_area/g.previous_census_population) as previous_census_population_vs_area, (g.total_area/g.current_census_population) as 
current_census_population_vs_area from 
(select q.*,r.total_area from(

select '1' as keyy,n.* from
(select sum(c.previous_census_population) previous_census_population, sum(c.current_census_population) current_census_population from( 
select e.state,sum(e.previous_census_population) previous_census_population ,sum(e.current_census_population) current_census_population from
(select d.District,d.state,round(d.population/(1+d.growth_rate),0) previous_census_population ,d.population current_census_population from
(select a.district,a.state,a.growth growth_rate ,b.population from cen..data1 a inner join cen..data2 b on a.District=b.district) d) e
group by e.state)c) n) q inner join (

select '1' as keyy,j.* from(
select sum(area_km2) total_area from cen..data2)j) r on q.keyy=r.keyy) g

--window output top 3 district from each state with highest literacy rate
select a.* from
(select district,state,literacy,rank() over (partition by state order by literacy desc) rnk from cen..data1) a
where a.rnk in(1,2,3) order by state








 

