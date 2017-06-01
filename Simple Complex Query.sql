/* Niema Orakwusi Simple Query 6/1/2017*/

--Check to see if the temp table exist and if 
--drop the table
IF EXISTS ( SELECT *
	FROM sys.tables	
	WHERE name = 'TempData')
	DROP TABLE TempData

--Create the TempData table and fields
CREATE TABLE TempData
(
	ID int IDENTITY(1,1) PRIMARY KEY,
	Job_Title NVARCHAR(50) NOT NULL,
	FullName NVARCHAR(50)NOT NULL,
	Hire_Date Date NOT NULL,
	Sale_Quota money NOT NULL
)
INSERT INTO TempData

SELECT        C.JobTitle As Job_Title,  B.FirstName + ' ' + B.LastName AS FullName, C.HireDate As Hire_Date, A.SalesQuota As Sale_Quota
FROM            Sales.SalesPerson As A INNER JOIN
                         Person.Person As B ON A.BusinessEntityID = B.BusinessEntityID INNER JOIN
                         HumanResources.Employee AS C ON A.BusinessEntityID = C.BusinessEntityID
		WHERE C.HireDate IS NOT NULL AND A.SalesQuota IS NOT NULL;

--SET STATISTIC IO ON;;
WITH DResult (Job_Title, FullName, Hire_Date, Sale_Quota)
	As (--display to affected rows
	SELECT Job_Title, FullName,
		CAST(Hire_Date AS date), CAST(Sale_Quota AS money)
	FROM TempData 
	GROUP BY Job_Title, FullName, Hire_Date, Sale_Quota) 
	SELECT YEAR(Hire_Date) As Hire_Year, FullName AS Full_Name, Job_Title, Sale_Quota
	FROM DResult
	GROUP BY Hire_Date, Job_Title, FullName, Sale_Quota
	Go
	