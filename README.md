India Census 2011 SQL Portfolio Project

Table of Contents
1. Project Overview
2. Dataset Description
3. SQL Queries
4. Database Schema
5. Usage

1. Project Overview
Welcome to the India Census SQL Portfolio Project!
This project is a demonstration of using SQL to analyze and query data from the India Census 2011 dataset. The project showcases various SQL queries, and database schema, and provides insights into demographic data.

Objective: To demonstrate SQL skills in data retrieval and analysis using the India Census dataset.

2. Dataset Description
The India Census 2011 dataset is a comprehensive collection of demographic data, capturing various aspects of India's population. It includes information on population, age, gender, education, occupation, and more. This dataset can be used for various demographic studies and analyses.
Dataset Source: https://www.census2011.co.in/district.php
                https://www.census2011.co.in/literacy.php

4. SQL Queries
In this project, we have developed several SQL queries to extract meaningful insights from the India Census 2011 dataset. These queries include:

Query 1: Retrieve the total population of India.

      select sum(population) population from cen..data2
Query 2: Find the male and female populations separately.
       Formula used: males=population/(sex_ratio+1) 
                     female=popualtion(sex_ratio)/(sex_ratio+1)

     select d.state ,sum(d.males) total_males ,sum(d.females) total_females from (select c.district,c.state, round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from (select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from cen..data1 a inner join cen..data2 b on a.District=b.district ) c )d group by d.state
     
Query 3: Calculate the average growth rate and sex ratio by state.

    select state,avg(growth)*100 avg_growth from cen..data1 group 
    by state
    select state,round(avg(Sex_Ratio),0) avg_sex_ratio from 
    cen..data1 group by state order by avg_sex_ratio  desc

Query 4: Identify the top 3 states by average growth.

    select top 3 state,avg(growth)*100 avg_growth from cen..data1 
    group by state order by avg_growth  desc
       
Query 5: Determine the average literacy rate in India.
       
    select state,round(avg(Literacy),0) avg_literacy_ratio from 
    cen..data1 group by state having round(avg(Literacy),0) >90 
    order by avg_literacy_ratio desc
Query 6: Using the window function for the top 3 districts from each state with the highest literacy rate.

    select a.* from (select district, state, literacy, rank() over 
    (partition by state order by literacy desc) rnk from 
    cen..data1) a where a.rnk in(1,2,3) order by state

4. Database Schema
The database schema for this project consists of multiple tables, each representing different aspects of the census data. Below are the key tables:

Dataset 1: Contains information about	Growth,	Sex_Ratio, Literacy	Population by state
Dataset 2: Stores District, State,	Area_km2,	Population related data.
The database schema allows for efficient storage and retrieval of data, facilitating various types of queries.

5. Usage
To use this project, you will need to set up a SQL database and import the datasets. Follow these steps:
Create a SQL database and configure your connection.
Import the dataset into your database, making sure it matches the database schema provided.
Run the SQL queries provided in this project to retrieve insights from the data.
Feel free to modify or extend the queries to conduct your analysis.

Enjoy exploring the India Census 2011 dataset and leveraging the SQL queries in this portfolio project! If you have any questions or suggestions, please don't hesitate to contact me.









