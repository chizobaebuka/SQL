--1.
Select SUM(new_cases) as total_newcases, SUM(Cast(new_deaths as int)) as total_deaths, SUM(Cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidPortfolioProject..CovidDeaths$
--Where location like '%Nigeria%'
Where continent is not null
Order by 1,2

--2 Showing the Total number of deaths in some locations excluding Wold, European Union and International
SELECT location, SUM(Cast(new_deaths as int)) as TotalDeathCount
FROM CovidPortfolioProject..CovidDeaths$
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
Order by TotalDeathCount desc

--3 Showing the Percentage of the population that's been infected and grouping them based on location, and population only
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentofInfectedPopulation
From CovidPortfolioProject..CovidDeaths$
--Where location like'%Nigeria%'
Group by location, population
Order by PercentofInfectedPopulation desc

--4. Showing the Percentage of the population that's been infected and grouping them based on location, population and date
Select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentofInfectedPopulation
From CovidPortfolioProject..CovidDeaths$
--Where location like'%Nigeria%'
Group by location, population, date
Order by PercentofInfectedPopulation desc
