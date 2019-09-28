SELECT
	HumanResources.Department.DepartmentID,
	HumanResources.Department.Name
FROM 
	HumanResources.Department 
WHERE HumanResources.Department.Name LIKE 'P%';


SELECT
	HumanResources.Employee.BusinessEntityID,
	HumanResources.Employee.JobTitle,
	HumanResources.Employee.Gender,
	HumanResources.Employee.VacationHours,
	HumanResources.Employee.SickLeaveHours 
FROM 
	HumanResources.Employee 
WHERE HumanResources.Employee.VacationHours BETWEEN 10 AND 13;


SELECT
	HumanResources.Employee.BusinessEntityID,
	HumanResources.Employee.JobTitle,
	HumanResources.Employee.Gender,
	HumanResources.Employee.BirthDate,
	HumanResources.Employee.HireDate 
FROM 
	HumanResources.Employee 
WHERE 
	HumanResources.Employee.HireDate LIKE '%01' 
ORDER BY HumanResources.Employee.BusinessEntityID Offset 3 rows fetch next 5 rows only;