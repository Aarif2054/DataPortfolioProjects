
SELECT *
  FROM CovidVax
  go

select * 
from CovidDeaths
go

--select data that we are going to use
select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by 1,2
go

--Looking at Death Percentage
select location,date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
order by 1,2
go

--Chances of dying if you contract Covid in India
select date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as DeathPerc_India
from CovidDeaths
where location='India'
order by date
go

--percentage of population got Covid in India
select location,date,total_cases,population,
(total_cases/population)*100 as PercentageInfected
from CovidDeaths
where location='India'
order by date
go

--countries with highest infection percentage
select location,max(population),
Max((total_cases/population)*100) as PercentageInfected
from CovidDeaths
group by location
order by PercentageInfected desc
go

--countries with highest deaths 
select location,max(cast(total_deaths as int)) as TotalDeaths 
from CovidDeaths
where continent is not null
group by location
order by TotalDeaths desc
go

--looking at total vaccinations vs population
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cast(cv.new_vaccinations as bigint)) over (Partition by cd.location order by cd.location,cd.date)
as totalvaccinated
from CovidDeaths cd join CovidVax cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
order by 2,3
go

--create a view
create view peoplevaccinated as
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cast(cv.new_vaccinations as bigint)) over (Partition by cd.location order by cd.location,cd.date)
as totalvaccinated
from CovidDeaths cd join CovidVax cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
go

select *,(totalvaccinated/population)*100 as PercentageVaxinated from peoplevaccinated
go