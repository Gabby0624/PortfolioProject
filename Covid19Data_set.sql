Select *
from  CovidDeaths;

select *
FRom CovidVaccinations;

---select Data that we are going to use. 
Select location, date, total_cases, new_cases, total_deaths, Population
from  CovidDeaths
order by 1, 2;

----Looking at the Total case Vs total Deaths 
Select location, date, total_cases, total_deaths, (total_deaths/Total_cases)* 100 As DeathPercentage
from  CovidDeaths
order by 1, 2;

---shows the likelihood of death in Nigeria if you contract
Select location, date, total_cases, total_deaths, (total_deaths/Total_cases)* 100 As DeathPercentage
from  CovidDeaths
where location like '%Nigeria%'
order by 1, 2;

----Looking at Total Cases Vs Population
-----shows what percentage of population in Nigeria had covid
Select location, date,Population, total_cases,  (total_cases/Population)* 100 As TotalCasePopulationPer
from  CovidDeaths
Where Location like '%Nigeria%'
order by 1, 2;

-----Looking at countries with highest infection rate compared to population
Select location, Population, Max (total_cases) As Highestinfectcount, Max ((total_cases/Population))* 100 As PercentPopulationinfected
from  CovidDeaths
---Where Location like '%Nigeria%'
Group by Location, population
order by PercentPopulationinfected desc;


---showing the countries with highest death count per population
----I use cast to convert the total death column from Varchar to int
Select location, Max (Cast(Total_deaths as int)) as Totaldeathcount
from  CovidDeaths
---Where Location like '%Nigeria%'
Group by Location
order by Totaldeathcount desc;

--- to remove the continent values, i use there where clause.
Select location, Max (Cast(Total_deaths as int)) as Totaldeathcount
from  CovidDeaths
---Where Location like '%Nigeria%'
where continent is not null
Group by Location
order by Totaldeathcount desc;

----Lets break this down by Continent 
Select location, Max (Cast(Total_deaths as int)) as Totaldeathcount
from  CovidDeaths
---Where Location like '%Nigeria%'
where continent is null
Group by Location
order by Totaldeathcount desc;


-----Showing the continent with the highest death count

Select location, Max (Cast(Total_deaths as int)) as Totaldeathcount
from  CovidDeaths
---Where Location like '%Nigeria%'
where continent is null
Group by Location
order by Totaldeathcount desc;


-----Global Numbers 
 
Select date, Sum(New_cases) As totalCases, Sum(Cast(New_deaths as int)) As TotalDeaths, Sum(Cast(New_deaths as int))/Sum(new_cases) *100 As DeathPercentage
from  CovidDeaths
----where location like '%Nigeria%'
where continent is not null
Group by date
order by 1, 2;

---remove the date to get the total values

Select  Sum(New_cases) As totalCases, Sum(Cast(New_deaths as int)) As TotalDeaths, Sum(Cast(New_deaths as int))/Sum(new_cases) *100 As DeathPercentage
from  CovidDeaths
----where location like '%Nigeria%'
where continent is not null
--Group by date
order by 1, 2;



---From the covid vaccination table
select *
from CovidVaccinations;

--Looking at Total Population Vs Vaccination

select *
From CovidDeaths As dea
Join CovidVaccinations As vac 
	on dea.location = vac.location
	and dea.date = vac.date;

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
From CovidDeaths As dea
Join CovidVaccinations As vac 
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3;

--Rolling count on new Vaccination

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as rollingvaccination
From CovidDeaths As dea
Join CovidVaccinations As vac 
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3;

-----Create a CTE
with PopsvsVac (continent, location, date , population,new_vaccination, rollingvacinnation)
as
(
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as rollingvaccination
From CovidDeaths As dea
Join CovidVaccinations As vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (rollingvacinnation/population) *100 As PercentagePopvsVac
From PopsvsVac;

----Creating view to store data for later visuali

Create View PercentagePopVsVac as 
Select date, Sum(New_cases) As totalCases, Sum(Cast(New_deaths as int)) As TotalDeaths, Sum(Cast(New_deaths as int))/Sum(new_cases) *100 As DeathPercentage
from  CovidDeaths
----where location like '%Nigeria%'
where continent is not null
Group by date
---order by 1, 2;


---View of Total Population vs Vaccination 

Create view TotalpopulationVsVaccination as 
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
From CovidDeaths As dea
Join CovidVaccinations As vac 
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
---Order by 2,3;










