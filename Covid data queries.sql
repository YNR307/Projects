select * from [dbo].[coviddeaths]

--select * from [dbo].[covidvaccinations]

select [location],[date],[population],[total_cases],[new_cases],[total_deaths]
from [dbo].[coviddeaths]
order by 1,2


select [location],[date],[total_cases],[total_deaths],(total_deaths/total_cases)*100 as 'Death %'
from [dbo].[coviddeaths]
where location='india'
order by 1,2


--'% Covid cases V Population' 
select [location],[date],[total_cases],population,(total_cases/population)*100 as '% Covid cases V Population'
from [dbo].[coviddeaths]
--where location='india'
order by 1,2 

--max '% Covid cases V Population' and max(total_cases)

select [location],population,max(total_cases) as 'Highest total cases',max((total_cases/population)*100) as '% Covid cases V Population'
from [dbo].[coviddeaths]
--where location='india'
group by [location],population
order by '% Covid cases V Population' desc

--all countries
select [location],max(cast(total_deaths as int)) as Deathcount
from [dbo].[coviddeaths]
where continent is not null
group by [location]
order by Deathcount desc

--all continents
select [location],max(cast(total_deaths as int)) as Deathcount
from [dbo].[coviddeaths]
where continent is null
group by [location]
order by Deathcount desc


--Global numbers
select date,total_cases,total_deaths, (total_deaths/total_cases)*100 as 'Death %'
from [dbo].[coviddeaths]
where continent is not null
order by date


select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, 
(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from [dbo].[coviddeaths]
where continent is not null
group by date
order by 1,2

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, 
(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from [dbo].[coviddeaths]
where continent is not null
order by 1,2


select continent, sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, 
(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from [dbo].[coviddeaths]
where continent is not null
group by continent
order by 1,2



--combined table


select *
from [dbo].[coviddeaths]as CD
join [dbo].[covidvaccinations] as CV
on CD.location=CV.location
and CD.date=CV.date


--vaccination V population

select CD.location, CD.date, CD.population,CV.new_vaccinations
from [dbo].[coviddeaths]as CD
join [dbo].[covidvaccinations] as CV
on CD.location=CV.location
and CD.date=CV.date



select CD.location, CD.date, CD.population,CV.new_vaccinations,
sum(convert(int,CV.new_vaccinations)) OVER(partition by CD.location order by CD.location, CD.date)  as Rolling_vaccinations
from [dbo].[coviddeaths]as CD
join [dbo].[covidvaccinations] as CV
on CD.location=CV.location
and CD.date=CV.date
where CD.continent is not NULL
order by 1,2
 
 ----use CTE(Common Table Expression)

 WITH POPvsVAC (continent,location, date, population, new_vaccinations, Rolling_vaccinations)
 as
 (
select CD.continent,CD.location, CD.date, CD.population,CV.new_vaccinations,
sum(convert(int,CV.new_vaccinations)) OVER(partition by CD.location order by CD.location, CD.date)  as Rolling_vaccinations
from [dbo].[coviddeaths]as CD
join [dbo].[covidvaccinations] as CV
on CD.location=CV.location
and CD.date=CV.date
where CD.continent is not NULL
--order by 1,2
)
select * from POPvsVAC




--creating views
create view percentpopulationvaccinated as
select CD.location, CD.date, CD.population,CV.new_vaccinations,
sum(convert(int,CV.new_vaccinations)) OVER(partition by CD.location order by CD.location, CD.date)  as Rolling_vaccinations
from [dbo].[coviddeaths]as CD
join [dbo].[covidvaccinations] as CV
on CD.location=CV.location
and CD.date=CV.date
where CD.continent is not NULL
--order by 1,2

