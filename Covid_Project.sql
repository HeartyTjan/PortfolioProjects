-- QUERY 1: Display all records in 'coviddeaths$' table

SELECT *
FROM PortfolioProject..coviddeaths$
ORDER BY 3, 4;

-- QUERY 2: Retrieve COVID-19 data for 'Nigeria' from 'coviddeaths$' table, sorted by location and date.

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..coviddeaths$
WHERE location = 'Nigeria'
ORDER BY 1, 2;

-- QUERY 3: Calculate and display the mortality rate for 'Nigeria', rounded to two decimal places.

SELECT location, date, population, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) AS Mortality_rate 
FROM PortfolioProject..coviddeaths$
WHERE location LIKE 'Nigeria%'
ORDER BY 1, 2;

-- QUERY 4: Calculate the percentage of the population tested positive for COVID-19 in Nigeria.

SELECT date, location, population, total_cases, ROUND((total_cases/population)*100, 2) AS Infection_rate
FROM PortfolioProject..coviddeaths$
WHERE location LIKE 'Nigeria%'
ORDER BY 1, 2;

-- QUERY 5: Find the countries with the highest infection rate percentage based on total cases and population.

SELECT location, Population, MAX(total_cases) AS Highest_infection_count, ROUND(MAX((total_cases/Population))*100, 2) AS Perc_of_InfectionRate
FROM PortfolioProject..coviddeaths$
GROUP BY population, Location
ORDER BY 4 DESC;

-- QUERY 6: Find the top 20 countries with the highest death count per population and the percentage.

SELECT TOP 20 location, Population, MAX(total_deaths) AS Highest_death_count, ROUND(MAX((total_deaths/Population))*100, 2) AS Perc_of_deathcount
FROM PortfolioProject..coviddeaths$
WHERE Continent IS NOT NULL
GROUP BY population, Location
ORDER BY 3 DESC;

-- QUERY 7: Find the total death count for each continent from 'coviddeaths$' table.

SELECT Continent, MAX(total_deaths) AS Total_deathcount 
FROM PortfolioProject..coviddeaths$
WHERE Continent IS NOT NULL
GROUP BY continent 
ORDER BY 2 DESC;

-- QUERY 8: Calculate the total cases, total deaths, and death percentage by date from 'coviddeaths$' table.
SELECT date, SUM(total_cases) AS Total_cases, SUM(total_deaths) AS Total_deaths,  SUM(total_deaths)/SUM(total_cases)* 100 AS Death_Perc
FROM  PortfolioProject..coviddeaths$
WHERE Continent IS NOT NULL
GROUP BY date 
ORDER BY 1, 2;

-- QUERY 9: Create a temporary table to store population and vaccination data, and calculate the vaccination percentage.

DROP TABLE IF EXISTS #PercpopulationVaccinated 
CREATE TABLE #PercpopulationVaccinated(
	continent VARCHAR(70),
	Location VARCHAR(70),
	Date DATE,
	Population NUMERIC,
	new_vaccinations NUMERIC,
	TotalpeopleVaccinated NUMERIC
	)
INSERT INTO  #PercpopulationVaccinated
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(Cast( vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as TotalpeopleVaccinated
FROM PortfolioProject..Covidvaccinations$ vac
JOIN PortfolioProject..coviddeaths$ dea
    ON vac.date = dea.date
    AND vac.location = dea.location
--WHERE dea.continent is not null
--ORDER BY 1,2,3

SELECT *, ROUND((TotalpeopleVaccinated/population)*100,2) as Vaccinatedperc
FROM #PercpopulationVaccinated

-- QUERY 10: Create a view 'PercpopulationVaccinated' to store the calculated population and vaccination percentage data.

CREATE VIEW PercpopulationVaccinated AS
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(Cast( vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS TotalpeopleVaccinated
FROM PortfolioProject..Covidvaccinations$ vac
JOIN PortfolioProject..coviddeaths$ dea ON vac.date = dea.date AND vac.location = dea.location;

-- QUERY 11: Create a view 'Totaldeath_by_continent' to store the total death count for each continent.

CREATE VIEW Totaldeath_by_continent AS
SELECT Continent, MAX(total_deaths) AS Total_deathcount 
FROM PortfolioProject..coviddeaths$
WHERE Continent IS NOT NULL
GROUP BY continent;

-- QUERY 12: Create a view 'Top20_Countriesdeathcount' to store the top 20 countries with the highest death count per population and percentage.
CREATE VIEW Top20_Countriesdeathcount AS
SELECT TOP 20 location, Population, MAX(total_deaths) AS Highest_death_count, ROUND(MAX((total_deaths/Population))*100, 2) AS Perc_of_deathcount
FROM PortfolioProject..coviddeaths$
WHERE Continent IS NOT NULL
GROUP BY population, Location
ORDER BY 3 DESC;

-- QUERY 13: Create a view 'Nigeria_Infectionrate' to store the infection rate for 'Nigeria'.

CREATE VIEW Nigeria_Infectionrate AS
SELECT date, location, population, total_cases, ROUND((total_cases/population)*100, 2) AS Infection_rate
FROM PortfolioProject..coviddeaths$
WHERE location LIKE 'Nigeria%';

-- QUERY 14: Create a view 'Nigeria_MortalityRate' to store the mortality rate for 'Nigeria'.

CREATE VIEW Nigeria_MortalityRate AS
SELECT location, date, population, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) AS Mortality_rate 
FROM PortfolioProject..coviddeaths$
WHERE location LIKE 'Nigeria%';