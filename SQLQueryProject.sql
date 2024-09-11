Select *
From PortfolioProject. .Covid19Death
Where continent is not NULL
Order by 3,4

Select *
From PortfolioProject. .Covid19Death
Order by 3,4

Select location, date, population_density, total_cases, new_cases, total_deaths
From PortfolioProject. .Covid19Death
Order by 1,2

SELECT location, date, total_cases, total_deaths,
    CASE 
        WHEN total_cases = 0 THEN NULL
        ELSE total_deaths / total_cases
    END AS Result
FROM PortfolioProject. .Covid19Death
ORDER BY 1,2


SELECT location, date, total_cases, total_deaths,
    CASE 
        WHEN total_cases = 0 THEN NULL
        ELSE total_deaths / total_cases * 100
    END AS Result
FROM PortfolioProject. .Covid19Death
Where location like '%Nigeria%'
ORDER BY 1,2


SELECT location, date, total_cases, population_density,
    CASE 
        WHEN total_cases = 0 THEN NULL
        ELSE population_density / total_cases * 100
    END AS Result
FROM PortfolioProject. .Covid19Death
Where location like '%Nigeria%'
ORDER BY 1,2

SELECT location, population_density, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population_density))*100 as PercentpopulationInfected
From PortfolioProject. .Covid19Death
Group by population_density, location
Order by 1,2


SELECT location, population_density, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population_density))*100 as PercentpopulationInfected
From PortfolioProject. .Covid19Death
Group by population_density, location
Order by PercentPopulationInfected desc

SELECT location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject. .Covid19Death
Group by location
Order by TotalDeathCount desc


SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject. .Covid19Death
Where continent is not NULL
Group by location
Order by TotalDeathCount desc




Select SUM(new_cases), SUM(cast(new_deaths as int)), CASE WHEN SUM(new_cases) = 0 THEN 0 ELSE SUM(cast(new_deaths as int))/SUM(new_cases)*100 END as DeathPercentage
From PortfolioProject. .Covid19Death
Where continent is not null
--Group By date
Order by 1,2


Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
From PortfolioProject. .Covid19Death dea
Join PortfolioProject. .Covid19Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
	Order by 2,3


Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, SUM(CONVERT(Bigint,vac.new_vaccinations)) OVER (Partition by dea.location) as Total
From PortfolioProject. .Covid19Death dea
Join PortfolioProject. .Covid19Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
	Order by 2,3


	Select location,sum(population_density) as TOTAL 
	from PortfolioProject.dbo.Covid19Death 
	where population_density is not null  group by location  
	order by 1



WITH PopvsVac (Continent, location, date, Popullation_density, New_Vaccination, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, SUM(CONVERT(Bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
From PortfolioProject. .Covid19Death dea
Join PortfolioProject. .Covid19Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *
From PopvsVac



WITH PopvsVac (Continent, location, date, Popullation_density, New_Vaccination, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, SUM(CONVERT(Bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
From PortfolioProject. .Covid19Death dea
Join PortfolioProject. .Covid19Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (PeopleVaccinated/Popullation_density)*100
From PopvsVac




Create Table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population_density numeric,
New_Vaccinations numeric,
PeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, SUM(CONVERT(Bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
From PortfolioProject. .Covid19Death dea
Join PortfolioProject. .Covid19Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Select *,
CASE 
           WHEN Population_density = 0 THEN 0 
           ELSE (PeopleVaccinated / Population_density) * 100 
       END AS TotalPercentVaccinated
From #PercentPopulationVaccinated

Select *
from #PercentPopulationVaccinated



---creating view 

Create view PopvsVac as
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, SUM(CONVERT(Bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
From PortfolioProject. .Covid19Death dea
Join PortfolioProject. .Covid19Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


Create view PercentPopulationVaccinated as
---Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, SUM(CONVERT(Bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
From PortfolioProject. .Covid19Death dea
Join PortfolioProject. .Covid19Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


Create view TotalDeathCount as 
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject. .Covid19Death
Where continent is NULL
Group by location
---Order by TotalDeathCount desc


Create view TotalVac as
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, SUM(CONVERT(Bigint,vac.new_vaccinations)) OVER (Partition by dea.location) as Total
From PortfolioProject. .Covid19Death dea
Join PortfolioProject. .Covid19Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


Create view NigeriaCases as
SELECT location, date, total_cases, total_deaths,
    CASE 
        WHEN total_cases = 0 THEN NULL
        ELSE total_deaths / total_cases * 100
    END AS Result
FROM PortfolioProject. .Covid19Death
Where location like '%Nigeria%'
--ORDER BY 1,2


Create view NigeriaPopvsCas as
SELECT location, date, total_cases, population_density,
    CASE 
        WHEN total_cases = 0 THEN NULL
        ELSE population_density / total_cases * 100
    END AS Result
FROM PortfolioProject. .Covid19Death
Where location like '%Nigeria%'
--ORDER BY 1,2


Create view PercentPopulationinfected as
SELECT location, population_density, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population_density))*100 as PercentpopulationInfected
From PortfolioProject. .Covid19Death
Group by population_density, location
--Order by 1,2


CREATE VIEW DeathPercentage AS
SELECT SUM(new_cases) AS TotalCases, 
       SUM(CAST(new_deaths AS int)) AS TotalDeaths, 
       CASE 
           WHEN SUM(new_cases) = 0 THEN 0 
           ELSE SUM(CAST(new_deaths AS int)) / SUM(new_cases) * 100 
       END AS DeathPercentage
FROM PortfolioProject. .Covid19Death
WHERE continent IS NOT NULL;



Create view TotalPopulation as
Select location,sum(population_density) as TOTAL 
	from PortfolioProject.dbo.Covid19Death 
	where population_density is not null  group by location  
	--order by 1