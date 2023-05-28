-- Change the column type to float
ALTER TABLE CovidDeaths
ALTER COLUMN population float;

-- Change the column type to decimal with precision 5 and scale 2
ALTER TABLE CovidDeaths
ALTER COLUMN population DECIMAL(5, 2);

-- Change the column type to float
ALTER TABLE CovidDeaths
ALTER COLUMN total_cases float;

-- Change the column type to decimal with precision 5 and scale 2
ALTER TABLE CovidDeaths
ALTER COLUMN total_cases DECIMAL(5, 2);

-- Getting All the Data from Covid Deaths table
Select *
From PortfolioProject..CovidDeaths
Where continent is not NULL
order by 3,4

-- Getting All the Data from Covid Vaccinations table
-- Select *
-- From PortfolioProject..CovidVaccinations
-- Where continent is not NULL
-- Order by 3,4

--  1. Selects the data that we are going to using. Listed by country first in alphabetical order for readabililty
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2
-- The first deaths don't start until about a month out. 

--  2. Total cases vs Total Deaths. This will show the percentage of people dying who are infected
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
order by 1,2

--  3. Shows the likelyhood of dying if you contract the virus in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
order by 1,2


--  4. Total Cases vs Population: Shows what population was affected by Covid
SELECT location, date, population, total_cases,(total_cases/population)*100 as InfectedPopulation
From PortfolioProject..CovidDeaths
order by 1,2

--  5. What Countries have the highest infection rates compared to population. Ordered by the Highest
--  The MAX(total_cases) value is the highest values per country because we don't need to look at every single  
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PopulationByCountry
From PortfolioProject..CovidDeaths
Where continent is not NULL
Group by location, population
Order by PopulationByCountry DESC

-- 6. Showing the highest death count per population. We insert the Where clause to avoid grouping by continent
SELECT Location, MAX(Total_Deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not NULL
Group by location
Order by TotalDeathCount DESC

-- 7. Showing the highest death by continent INCLUDING and Oceania and International
SELECT location, MAX(total_deaths) as TotalDeathCountByContinient
From PortfolioProject..CovidDeaths
Where continent is NULL
Group by location
Order by TotalDeathCountByContinient DESC;

-- 8. Showing the highest death count by continent EXCLUDING and Oceania and International
SELECT continent, MAX(total_deaths) as TotalDeathCountByContinient
From PortfolioProject..CovidDeaths
Where continent is not NULL
Group by continent
Order by TotalDeathCountByContinient DESC;



--  Global Statistics --

-- 9. Observing all countries and not world numbers. Shows the death percentage by the day. Aggregatre functions are used to help with grouping. The SUM of new cases will add up to total cases

Select date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as GlobalDeathPercentageByDay
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
Order by 1,2

-- 10.  Observing all countries and not world numbers. About 2% Shows the death percentage total. Aggregatre functions are used to help with grouping. The SUM of new cases will add up to total cases

Select SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as GlobalDeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

-- Observing Covid Vaccinations Table --

-- 11. Observing total population that is vaccinated. Joining the tables by location 

Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- 12. Rolling Vaccinations by day using a CTE

With PopulationVsVaccination (continient, location, date, population, new_vaccinations, RollingVaccinations)
as
(
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingVaccinations

From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)

Select *, (RollingVaccinations/population)*100
From PopulationVsVaccination

-- Using a Temp Table
DROP Table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continient nvarchar(255),
location nvarchar(255),
date DATETIME,
population NUMERIC,
new_vaccinations NUMERIC,
RollingVaccinations NUMERIC
)

Insert into #PercentPopulationVaccinated
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) as RollingVaccinations

From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

Select *, (RollingVaccinations/population)*100
From #PercentPopulationVaccinated


-- Creating a View
Create view continent_deaths_view as
Select continent, MAX(total_deaths) as TotalDeathCountByContinent
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent;
-- ORDER BY TotalDeathCountByContinent DESC;







