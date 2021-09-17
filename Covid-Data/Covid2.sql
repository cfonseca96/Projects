SELECT *
FROM [Database]..CovidDeaths

-- Data ill be using

SELECT location, date, total_cases, total_deaths, new_cases
FROM [Database]..CovidDeaths
order by 1, 2

-- Total Cases vs Total Deaths
-- Likelihood of dying if you contract covid in your country

SELECT location Country, max(total_cases) Cases, max(cast(total_deaths as int)) Deaths, max(cast(total_deaths as int))/max(total_cases)*100 DeathsPercentage
FROM [Database]..CovidDeaths
where continent is not null and total_deaths is not null
group by location
order by 2 desc

-- Covid Cases vs Population

SELECT location Country, population, max(total_cases) Cases, max(total_cases)/population*100 PercentageOfPopulation
FROM [Database]..CovidDeaths
where continent is not null and total_deaths is not null
group by location, population
order by 3 desc

-- Covid Deaths per Location (by deaths)

SELECT location Country, max(cast(total_deaths as int)) Deaths
FROM [Database]..CovidDeaths
where continent is not null and total_deaths is not null
group by location
order by 2 desc

-- Percentage of deaths per population

select location Country, max(cast(total_deaths as int)) Deaths, population, max(cast(total_deaths as int))/population*100 Percentage
from [Database]..CovidDeaths
where total_deaths is not null and continent is not null
group by location, population
order by 2 desc

-- Average new Cases a day per location

select location Country, floor(avg(new_cases)) AverageNewCasesPerDay
from [Database]..CovidDeaths
where new_cases is not null 
and continent is not null
group by location
order by 2 desc

-- Highest Cases

SELECT location Country, max(total_cases) TotalCases
FROM [Database]..CovidDeaths
where continent is not null 
and total_cases is not null
group by location
order by 2 desc

-- Highest Deaths

SELECT location Country, max(cast(total_deaths as int)) TotalDeaths
FROM [Database]..CovidDeaths
where continent is not null 
and total_deaths is not null
group by location
order by 2 desc

-- Highest Cases per Continent

SELECT continent, max(total_cases) Cases
FROM [Database]..CovidDeaths
where continent is not null 
group by continent
order by 2 desc

-- Highest death per Continent

SELECT continent, max(cast(total_deaths as int)) Deaths
FROM [Database]..CovidDeaths
where continent is not null 
group by continent
order by 2 desc

-- Global Numbers
-- Cases and deaths

select sum(new_cases) [Total Cases], sum(cast(new_deaths as int)) [Total Deaths], 
sum(cast(new_deaths as int))/sum(new_cases)*100 Percentage
from [Database]..CovidDeaths
where continent is not null



-- My Data joined

select *
from [Database]..CovidDeaths d
join [Database]..CovidVaccine v
	on d.location = v.location 
	and d.date = v.date

-- Total people Vaccinated

select d.location, max(people_vaccinated) [People Vaccinated]
from [Database]..CovidDeaths d
join [Database]..CovidVaccine v
	on d.location = v.location 
	and d.date = v.date
where people_vaccinated is not null
group by d.location
order by 1, 2

-- looking at population and vaccines

select d.location, d.date, new_vaccinations, d.population 
from [Database]..CovidDeaths d
join [Database]..CovidVaccine v
	on d.location = v.location 
	and d.date = v.date
where new_vaccinations is not null
and d.continent is not null

-- Rolling count of people vaccinated

select d.continent, d.location, d.date, v.new_vaccinations, d.population, sum(cast(v.new_vaccinations as int)) 
over (Partition by d.location order by d.location, d.date) RollingVaccine
from [Database]..CovidDeaths d
join [Database]..CovidVaccine v
	on d.location = v.location 
	and d.date = v.date
where new_vaccinations is not null
and d.continent is not null
order by 2, 3


-- use cte


with PopvsVac (Continent, location, date, new_vaccinations, population, RollingVaccine) 
as
(
select d.continent, d.location, d.date, v.new_vaccinations, d.population, sum(cast(v.new_vaccinations as int)) 
over (Partition by d.location order by d.location, d.date) RollingVaccine
from [Database]..CovidDeaths d
join [Database]..CovidVaccine v
	on d.location = v.location 
	and d.date = v.date
where new_vaccinations is not null
and d.continent is not null
)

select *, (RollingVaccine/population)*100 Percentage
from PopvsVac
order by 2


-- Temp table


drop table if exists #PercentPopulationVaccinations
create table #PercentPopulationVaccinations
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric, 
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinations
select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(cast(v.new_vaccinations as int)) 
over (Partition by d.location order by d.location, d.date) RollingPeopleVaccinated
from [Database]..CovidDeaths d
join [Database]..CovidVaccine v
	on d.location = v.location 
	and d.date = v.date
where d.continent is not null
order by 2, 3

select *, (RollingPeopleVaccinated/population)*100 Percentage
from #PercentPopulationVaccinations


-- create views

use [Porfolio Project]
go

Create view [Deaths Per Country] as 
SELECT location Country, max(cast(total_deaths as int)) TotalDeaths
FROM [Database]..CovidDeaths
where continent is not null 
and total_deaths is not null
group by location
--order by 2 desc
go

Create View [Cases Per Country] as 
SELECT location Country, max(total_cases) TotalCases
FROM [Database]..CovidDeaths
where continent is not null 
and total_cases is not null
group by location
--order by 2 desc
go

create view [People Vaccinated] as
select d.location, max(people_vaccinated) [People Vaccinated]
from [Database]..CovidDeaths d
join [Database]..CovidVaccine v
	on d.location = v.location 
	and d.date = v.date
where people_vaccinated is not null
group by d.location
--order by 1, 2
go


-- for tableau

-- Global Numbers

use [Porfolio Project]
go

create view [Global Numbers] as
select sum(new_cases) [Total Cases], sum(cast(new_deaths as int)) [Total Deaths], 
sum(cast(new_deaths as int))/sum(new_cases)*100 Percentage
from [Database]..CovidDeaths
where continent is not null


-- Infected per Country

create view [Infected Per Country] as
SELECT location Country, max(total_cases) TotalCases
FROM [Database]..CovidDeaths
where continent is not null 
and total_cases is not null
group by location

--Percentage Of Population Infected

create view [Cases] as
select max(total_cases) [Cases], population
from [Database]..CovidDeaths
where total_cases is not null
and continent is not null
group by population

create view [Population Infected] as
select sum(Cases) Cases, sum(population) Population, sum(Cases)/sum(population)*100 [Percentage Population Infected]
from [Cases]



create view [Total Deaths] as
SELECT continent Continent, max(cast(total_deaths as int)) [Total Deaths]
FROM [Database]..CovidDeaths
where continent is not null
group by continent



-- Data Ready
use [Database]
select *
from [Global Numbers]

select *
from [Infected Per Country]

select *
from [Population Infected]

select *
from [Total Deaths]

select *
from [Daily Cases]
order by 1, 3

-- average cases per day per countinent

create view [Daily Cases] as
select continent, date, sum(new_cases) over (partition by continent order by date) as [Total Cases]
from [Database]..CovidDeaths
where continent is not null 
and new_cases is not null


select continent, max(cast(total_deaths as int))
from CovidDeaths
where continent is not null
group by continent

select continent, max(total_cases)
from CovidDeaths
group by continent










