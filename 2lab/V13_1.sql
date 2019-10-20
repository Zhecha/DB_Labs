select
	a.BusinessEntityID,
	a.JobTitle,
	HumanResources.Department.DepartmentID,
	HumanResources.Department.Name
from 
	((HumanResources.Employee as a
		inner join HumanResources.EmployeeDepartmentHistory as b
		on a.HireDate = b.StartDate and a.BusinessEntityID = b.BusinessEntityID)
	inner join HumanResources.Department
	on b.DepartmentID = HumanResources.Department.DepartmentID)


select
	HumanResources.Department.DepartmentID,
	HumanResources.Department.Name,
COUNT(*) as EmpCount
from
	((HumanResources.Department
		inner join HumanResources.EmployeeDepartmentHistory
		on HumanResources.Department.DepartmentID = HumanResources.EmployeeDepartmentHistory.DepartmentID)
	inner join HumanResources.Employee
	on HumanResources.EmployeeDepartmentHistory.BusinessEntityID = HumanResources.Employee.BusinessEntityID)
group by HumanResources.Department.DepartmentID, HumanResources.Department.Name order by HumanResources.Department.Name


select
	HumanResources.Employee.JobTitle,
	HumanResources.EmployeePayHistory.Rate,
	HumanResources.EmployeePayHistory.RateChangeDate,
	CONCAT('the rate for ',HumanResources.Employee.JobTitle,' was set to ',HumanResources.EmployeePayHistory.Rate,' at ',convert(nvarchar, HumanResources.EmployeePayHistory.RateChangeDate, 106)) as Report
from
	(HumanResources.Employee
		inner join HumanResources.EmployeePayHistory
			on HumanResources.Employee.BusinessEntityID = HumanResources.EmployeePayHistory.BusinessEntityID)



