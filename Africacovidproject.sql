/*
Africa Covid 19 Data Exploration (with slight emphasy on the Nigerian Population) 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, 
Aggregate Functions, Creating Views, Converting Data Types(cast etc), concat
*/

Create DATABASE AfricaCovidproject

SELECT TOP (1000) [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[new_cases_smoothed]
      ,[total_deaths]
      ,[new_deaths]
      ,[new_deaths_smoothed]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      ,[new_cases_smoothed_per_million]
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
      ,[new_deaths_smoothed_per_million]
      ,[reproduction_rate]
      ,[icu_patients]
      ,[icu_patients_per_million]
      ,[hosp_patients]
      ,[hosp_patients_per_million]
      ,[weekly_icu_admissions]
      ,[weekly_icu_admissions_per_million]
      ,[weekly_hosp_admissions]
      ,[weekly_hosp_admissions_per_million]
  FROM [AfricaCovidproject].[dbo].[CovidDeaths]

Select *
From AfricaCovidproject..CovidDeaths
Where continent is not null 
order by 3,4

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From AfricaCovidproject..CovidDeaths
Where continent is not null 
order by 1,2

-- Ratio of Total Cases vs Total Deaths In Nigeria
-- Shows Ratio of people who contracted against those that actually died of covid

Select Location, date, total_deaths, total_cases, (total_cases/total_deaths) as Death_ratio
From AfricaCovidproject..CovidDeaths
Where location like '%Nigeria%'
and continent is not null 
order by 1,2 DESC

-- with CONCAT
Select Location 
,date
,total_deaths
,total_cases
,CONCAT((total_cases/total_deaths), ':1')as Death_ratio
From AfricaCovidproject..CovidDeaths
Where location like '%Nigeria%'
and continent is not null 
order by 1,2 DESC

-- Ratio of Total Cases vs Total Deaths In Africa per country
-- Shows Ratio of people who contracted against those that actually died of covid

Select Location
,sum(total_cases) AS 'Total Cases'
,sum(total_deaths) AS 'Total Deaths'
,sum(total_cases)/sum(total_deaths) 'Cases/Death Ratio'
From AfricaCovidproject..CovidDeaths
Where continent like '%africa%'
and continent is not null 
GROUP BY location
order by 4 DESC

-- with concat for print

Select Location
,sum(total_cases) AS 'Total Cases'
,sum(total_deaths) AS 'Total Deaths'
,CONCAT (sum(total_cases)/sum(total_deaths), ':1') 'Cases/Death Ratio'
From AfricaCovidproject..CovidDeaths
Where continent like '%africa%'
and continent is not null 
GROUP BY location
order by 'Cases/Death Ratio'

-- Ratio of Total Cases vs Total Deaths In Nigeria
-- Shows Ratio of people who contracted against those that actually died of covid

Select Location, date, total_deaths, total_cases, (total_cases/total_deaths) as Death_ratio
From AfricaCovidproject..CovidDeaths
Where location like '%Nigeria%'
and continent is not null 
order by 1,2 DESC

-- Total Cases vs Population in Africa
-- Shows what percentage of population infected with Covid

Select Location
,sum(total_cases) AS 'Total Cases'
,MAX(population) Population
,sum(Population)/sum(total_cases) 'Population/Death Ratio'
From AfricaCovidproject..CovidDeaths
Where continent like '%africa%'
and continent is not null 
GROUP BY location
order by 3 DESC

-- Total Cases vs Population in Nigeria
-- Shows what percentage of population infected with Covid

Select Location
,sum(total_cases) AS 'Total Cases'
,MAX(population) Population
,sum(Population)/sum(total_cases) 'Population/Death Ratio'
From AfricaCovidproject..CovidDeaths
Where location like '%nigeria%'
and continent is not null 
GROUP BY location
order by 3 DESC

-- Countries with Highest Infection Rate compared to Population in africa

Select Location, Population, MAX(total_cases) as HighestInfectionCount, (population/MAX(total_cases)) as PopulationInfectedratio
From AfricaCovidproject..CovidDeaths
Where continent LIKE '%africa%' 
and continent is not NULL
Group by Location, Population
order by 2

-- Countries in africa with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From AfricaCovidproject..CovidDeaths
Where continent LIKE '%africa%' 
and continent is not NULL
Group by Location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalhighestDeathCount
From AfricaCovidproject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalhighestDeathCount desc

-- GLOBAL NUMBERS (showing ratio of death per cases)

Select 
    SUM(new_cases) as total_cases, 
    SUM(cast(new_deaths as int)) as total_deaths, 
    SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From AfricaCovidproject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine in africa

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From AfricaCovidproject..CovidDeaths dea
Join AfricaCovidproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent like '%Africa%'AND
dea.continent is not null 
order by 2,3


-- TOTAL NUMBER PEOPLE VACCINATED IN AFRICA PER COUNTRY

select
dea.location
,MAX(dea.population) AS Population
,SUM(vac.new_vaccinations) AS 'Total Vaccinated'
from CovidDeaths dea
JOIN CovidVaccinations vac 
ON dea.location = vac.LOCATION 
AND dea.date = vac.date
WHERE dea.continent LIKE '%africa%'
AND dea.continent is not NULL
GROUP BY dea.location
ORDER BY 3 DESC

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From AfricaCovidproject..CovidDeaths dea
Join AfricaCovidproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date CHAR(10),
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From AfricaCovidproject..CovidDeaths dea
Join AfricaCovidproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From AfricaCovidproject..CovidDeaths dea
Join AfricaCovidproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null