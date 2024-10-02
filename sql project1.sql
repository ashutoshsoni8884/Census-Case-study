SELECT * FROM dataset1;
select * from dataset2;

ALTER TABLE dataset1
CHANGE COLUMN `ï»¿District` District VARCHAR(255);

ALTER TABLE dataset2
CHANGE COLUMN `ï»¿District` District VARCHAR(255);

SET SQL_SAFE_UPDATES = 0;
UPDATE dataset2
SET population = REPLACE(population, ',', '');
UPDATE dataset2
SET population = REPLACE(population, ',', '');
-- Q1. Count the number of rows present in the table.

select count(*) from dataset1;
select count(*) from dataset2;
    
-- Q2. Data for jharkhand and bihar only.

select d1.ï»¿District,d1.State,Growth,Sex_Ratio,
Literacy,Area_km2,Population from dataset1 d1
join dataset2 d2 
	on d1.state=d2.state
where
	d1.State in ('jharkhand','bihar');
    
-- Q3. Total poulation of india.

select sum(population) from dataset2;

-- Q4. What is the average growth of india.

select round(avg(growth),2) from dataset1;

-- Q6. What is the average growth by state

select state,round(avg(growth),2) from dataset1
group by state;

-- Q7. What is the average sex_ratio per state.

select state,round(avg(sex_ratio),2) from dataset1
group by state;

-- Q8. average litracy rate per state.

select state,round(avg(literacy),2) from dataset1
group by state having round(avg(literacy),2)>90;

-- Q9. top 3 states showing highest growth ratio.
	
select state,avg(growth) from dataset1 group by state order by avg(growth) desc
limit 3;

-- Q10. top 3 states showing lowest sex ratio.

select state,avg(Sex_Ratio) from dataset1 group by state order by avg(growth)
limit 3;

-- Q11. top and bottom 3 states as per literacy rate

(select state, avg(literacy) from dataset1 group by state order by avg(Literacy) asc limit 3)
union all
( select state, avg(literacy) from dataset1 group by state order by avg(Literacy) desc limit 3);

-- Q12. show all the data of states starting with letter a

select * from dataset1 where State like "a%";

-- Q13. show total no. male and female in each district

select c.District,c.state,c.population,
c.population/(c.Sex_Ratio+1) male,(c.population*c.Sex_Ratio)/(c.sex_ratio+1)  female from
(select d1.District,d1.State,(d1.Sex_Ratio/1000) sex_ratio,d2.Population from dataset1 d1  join dataset2 d2 on d1.District=d2.District)  c;

-- Q14. show total no. male and female in each state 

select d.state,sum(d.male),sum(d.female) from 
(select c.District,c.state,c.population,
c.population/(c.Sex_Ratio+1) male,(c.population*c.Sex_Ratio)/(c.sex_ratio+1)  female from
(select d1.District,d1.State,(d1.Sex_Ratio/1000) sex_ratio,d2.Population from dataset1 d1  join dataset2 d2 on d1.District=d2.District)  c) 
d group by d.state;

-- Q15. find out total literate and illerate person.
SELECT * FROM dataset1;
select * from dataset2;

select d.state,sum(d.literate_person),sum(d.illiterate_person),sum(d.population) from
(select c.district,c.state,c.population,(c.literacy_ratio*c.population) literate_person,((1-c.literacy_ratio)*c.population) illiterate_person from
(select d1.District,d1.State,(d1.Literacy/1000) literacy_ratio,d2.Population from dataset1 d1  join dataset2 d2 on d1.District=d2.District) c) d group by d.state;

-- Q16. find out previous census population
 
 select c.district,c.state,c.population,population/(1+c.growth_ratio) previous_population from
 (select d1.District,d1.State,d1.Growth/100 growth_ratio,d2.Population from dataset1 d1  join dataset2 d2 on d1.District=d2.District) c;
 
 -- Q17. select top 3 district from all the state by highest literacy rate.
 
 select d.* from 
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from dataset1 ) d where d.rnk in (1,2,3) order by state;