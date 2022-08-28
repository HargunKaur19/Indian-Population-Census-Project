-- Advanced Queries on Census Data

-- Calculating Total number of males and females at district level

SELECT c.district, c.state, 
	ROUND (c.Population/(c.Sex_ratio+1), 0) AS Total_Males, 
	ROUND ((c.Population*(c.Sex_Ratio)/(c.Sex_Ratio+1)),0) AS Total_Females
FROM (SELECT district.district, district.state, Sex_ratio/1000 AS Sex_Ratio, population
			FROM Census..District 
			JOIN Census..Districtpopulation
			ON District.District = Districtpopulation.District) AS C;

--Calculating the Total number of males and females at state level

SELECT D.state, SUM(D.Total_Males) AS Total_Males_in_State, SUM(D.Total_Females) AS Total_Females_in_State From 
	(SELECT c.district, c.state, 
		ROUND (c.Population/(c.Sex_ratio+1), 0) AS Total_Males, 
		ROUND ((c.Population*(c.Sex_Ratio)/(c.Sex_Ratio+1)),0) AS Total_Females
	FROM (SELECT district.district, district.state, Sex_ratio/1000 AS Sex_Ratio, population
			FROM Census..District 
			JOIN Census..Districtpopulation
			ON District.District = Districtpopulation.District) AS C) AS D
GROUP BY D.state;

-- Calculating the number of literates person and Iliterate persons at district level

SELECT D.district, D.state, 
		ROUND((D.literacy_ratio*D.Population),0) AS Number_of_Literates, 
		ROUND(((1-D.literacy_ratio)*D.Population),0) AS Number_of_Illiterates 
FROM 
	(SELECT district.district, district.state, Literacy/100 AS Literacy_ratio, population
			FROM Census..District 
			JOIN Census..Districtpopulation
			ON District.District = Districtpopulation.District) AS D;

--Calculating the population during the previous census using growth rate

SELECT E.State, 
	SUM (E.Pervious_Census_Population) AS Prev_Census, 
	SUM(E.Current_Census_Population) AS Curr_Census
FROM 
	(SELECT D.district, D.state, 
		ROUND((D.population/(D.Growth_percent+1)),0) AS Pervious_Census_Population,
		Population AS Current_Census_Population
	FROM 
			(SELECT district.district, district.state, Growth AS Growth_percent, population
				FROM Census..District 
				JOIN Census..Districtpopulation
				ON District.District = Districtpopulation.District) AS D) AS E
GROUP BY E.State;

-- Calculating total population of India in Current and Previous Census

SELECT SUM(F.Prev_Census) AS Total_population_in_2001_Census, SUM(F.Curr_Census) AS Total_population_in_2011_Census
FROM 
	(SELECT E.State, 
		SUM (E.Pervious_Census_Population) AS Prev_Census, 
		SUM(E.Current_Census_Population) AS Curr_Census
	FROM 
		(SELECT D.district, D.state, 
			ROUND((D.population/(D.Growth_percent+1)),0) AS Pervious_Census_Population,
			Population AS Current_Census_Population
		FROM 
			(SELECT district.district, district.state, Growth AS Growth_percent, population
				FROM Census..District 
				JOIN Census..Districtpopulation
				ON District.District = Districtpopulation.District) AS D) AS E
GROUP BY E.State) AS F;

-- Calculating the Number of People present in per square Kilometer at state level 

SELECT State,
	(G.Total_area/G.Pervious_Census_Population) AS Population_per_km2_in_2001, 
	(G.Total_area/G.Current_Census_Population) AS Population_per_km2_in_2011
FROM
	(SELECT State_population.*, State_area.Total_Area 
	FROM 
		(SELECT D.state, 
				SUM (ROUND((D.population/(D.Growth_percent+1)),0)) AS Pervious_Census_Population,
				SUM(Population) AS Current_Census_Population
		FROM 
				(SELECT district.district, district.state, Growth AS Growth_percent, population, Area_km2
					FROM Census..District 
					JOIN Census..Districtpopulation
					ON District.District = Districtpopulation.District) AS D
		GROUP BY D.State) AS State_population
	INNER JOIN
	(SELECT State, SUM(Area_km2) AS Total_Area
	FROM Census..districtpopulation
	GROUP BY State) AS State_area 
	ON State_area.State = State_population.State) AS G;

-- List the top three districts from each state with highest literacy rate alongwith ranks

SELECT Districts_ranked.* FROM
	(SELECT state, district, literacy,
		RANK() OVER (PARTITION BY state ORDER BY literacy DESC) AS District_rank
	FROM Census..district) AS Districts_ranked
WHERE Districts_ranked.District_rank IN (1,2,3);
