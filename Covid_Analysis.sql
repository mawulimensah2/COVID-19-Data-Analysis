CREATE DATABASE Portfolio

create table table1(
name nvarchar(100),
age int
);

select * from [dbo].[CovidDeaths]


Select *
From [dbo].[CovidDeaths]
Where continent is not null 
order by 3,4

Select Location, date, sum(total_cases), sum(total_deaths), new_cases, population
From [dbo].[CovidDeaths]
Where continent is not null 
group by location, date, new_cases, population
order by 1,2

Select Location, date, total_cases,total_deaths, (convert(float, total_deaths)/convert(float, total_cases))*100 as DeathPercentage
From [dbo].[CovidDeaths]
Where location like '%states%'
and continent is not null 
order by 1,2

Select Location, date, Population, convert(float, total_cases),  (convert(float, total_cases)/convert(float, population))*100 as PercentPopulationInfected
From [dbo].[CovidDeaths]
--Where location like '%states%'
order by 1,2

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((convert(float, total_cases)/population))*100 as PercentPopulationInfected
From  [dbo].[CovidDeaths]
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population
select location, Date, MAX(total_deaths) as HighestDeath, population, (convert(float, total_deaths)/convert(float, population))*100 As PercentageDied 
from [dbo].[CovidDeaths]
where continent is not NULL
group by location, population, total_deaths, Date
order by HighestDeath desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [dbo].[CovidDeaths]
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population
select continent, MAX(CONVERT(float, total_deaths)) as HighestDeath, population
from dbo.CovidDeaths
where continent is not NULL
group by continent, population
order by HighestDeath desc

-- Global Numbers
-- total deaths, total cases, deathPercentage

select SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) AS totalDeaths, SUM((CONVERT(int, new_deaths))) / SUM(convert(float, population ))*100 AS DeathPercentage
from [dbo].[CovidDeaths]
where continent is not NULL
--group by new_deaths, new_cases
order by 1, 2


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From dbo.CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2





-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.Date, dea.location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [dbo].[CovidDeaths] dea
Join [dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


with PopulationVsVac( continent, location, date, population, new_vacations, RollingPeopleVaccinated)
AS (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.Date, dea.location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [dbo].[CovidDeaths] dea
Join [dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/convert(float, population))*100 percentageVaccinated
from PopulationVsVac


create Table #PercentPopulationVaccinated
(continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.Date, dea.location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [dbo].[CovidDeaths] dea
Join [dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100 AS PercentVaccinated
from #PercentPopulationVaccinated
where New_vaccinations is not NULL and RollingPeopleVaccinated is not NULL
order by 7 desc



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.Date, dea.location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [dbo].[CovidDeaths] dea
Join [dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null



