--Looking at Total Cases vs Total Deaths 
-- % of people that are dying that actually get infected in a particular location
--Shows the likelihood of dying if you contract the Coronavirus
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM CovidDeaths
WHERE location like '%Nigeria%'
Order by 1,2

--Looking at the TotalCases vs Population
--Shows the Percentage of the Population that has Covid
Select location, date, population, total_cases, (total_deaths/population)*100 AS PercentofInfectedPopulation
FROM CovidDeaths
WHERE location like '%Nigeria%'
Order by 1,2

--Shows what country has the highest infection rate as compared to the Population
Select location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_deaths/population))*100 AS PercentofInfectedPopulation
FROM CovidDeaths
--WHERE location like '%Nigeria%'
Group By location, population
Order by PercentofInfectedPopulation DESC

--Showing the Countries with Highest Deathcounts over population
Select location, MAX(cast(Total_deaths as int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is not Null 
Group By location
Order by TotalDeathCount DESC

--BREAKING IT DOWN BY CONTINENT 
Select continent, MAX(cast(Total_deaths as int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is NOT Null 
Group By continent
Order by TotalDeathCount DESC

--GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
--GROUP BY date
Order by 1,2


--USING CTE
--total Population vs Vaccination
--Total number of People in the World that has been vaccinated

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location)
FROM CovidDeaths dea JOIN CovidVaccinations vac 
	ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null and vac.new_vaccinations is null
--ORDER BY 1,2,3
)
Select *, (RollingPeopleVaccinated/population)*100 as PercentofVaccinatedPeople
From PopvsVac


--TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime, 
Population numeric,
New_Vaccinations numeric, 
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location)
FROM CovidDeaths dea JOIN CovidVaccinations vac 
	ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null and vac.new_vaccinations is null
ORDER BY 1,2,3

Select *, (RollingPeopleVaccinated/population)*100 as PercentofVaccinatedPeople
From #PercentPopulationVaccinated


--CREATING VIEWS FOR STORE DATA FOR LATER VISUALIZATION

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location)
FROM CovidDeaths dea JOIN CovidVaccinations vac 
	ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null and vac.new_vaccinations is null
--ORDER BY 1,2,3

 
