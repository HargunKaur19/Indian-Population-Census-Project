SELECT * FROM Census.dbo.district;

SELECT * FROM Census.dbo.districtpopulation;


-- Number of rows in the data set
SELECT COUNT(*) FROM Census..district;

SELECT COUNT(*) FROM Census..districtpopulation;

--Gathering data for literacy rate for a some particular states

SELECT * FROM Census..district	
	WHERE State IN ('Jharkhand', 'Bihar', 'Gujarat');

-- Estimating total population of the country 

SELECT SUM(Population) AS Population_Of_India FROM Census..districtpopulation;


--Average population across districts

SELECT 'Avg_population_districts', AVG(Population) FROM Census..districtpopulation;

-- Average growth across states

SELECT state, AVG(growth)*100 AS State_avg_growth 
FROM Census..district
GROUP BY state
ORDER BY AVG(growth)*100 DESC;

--Average sex ratio across states

SELECT state, ROUND(AVG(Sex_Ratio),2) AS State_avg_Sex_Ratio
FROM Census..district
GROUP BY state
ORDER BY AVG(Sex_Ratio)*100 DESC;

--Average Literacy Rate across states and filter the states with literacy rate over 80

SELECT state, ROUND(AVG(Literacy),2) AS State_Literacy_Rate
FROM Census..district
GROUP BY state
HAVING ROUND(AVG(Literacy),2) >80
ORDER BY AVG(Literacy)DESC;

--List the top 3 and bottom 3 states based on the literacy rate (using union operator alongwith sub query)
SELECT * FROM (SELECT TOP 3 state, ROUND(AVG(Literacy),2) AS State_Literacy_Rate
FROM Census..district
GROUP BY state
ORDER BY AVG(Literacy)DESC) AS A
UNION
SELECT * FROM (SELECT TOP 3 state, ROUND(AVG(Literacy),2) AS State_Literacy_Rate
FROM Census..district
GROUP BY state
ORDER BY AVG(Literacy) ASC) AS B;

-- Listing ou data for the states starting with letter A 

SELECT State, Growth, Sex_Ratio, Literacy 
FROM Census..district
WHERE State LIKE 'A%';

-- List the name of the states having 'Pradesh' in them

SELECT DISTINCT(State)
FROM Census..district
WHERE State LIKE '%Pradesh%';

-- List the district names that end with 'pur' in the end

SELECT DISTINCT(District)
FROM Census..district
WHERE District LIKE '%Pur';






--


