/*

Table:: MAP_EMPLOYEE_HIERARCHY

+------------+---------------------+
| EmployeeID | Manager_Employee_ID |
+------------+---------------------+


Table:: DIM_EMPLOYEE
+---------------+-----------+
|	EmployeeID	|	Salary	|
+---------------+-----------+

Q) Write a query to get the list managers whose salary is less than
	twice the average salary of empolyees reporting to them.

*/

SELECT
	a.ManagerEmployeeID AS Manager_ID,
	(SELECT Salary FROM dbo.DimEmployee WHERE ManagerEmployeeID=EmployeeID) AS Manager_Salary,
	AVG(b.Salary) AS Avg_Reporting_Employee_Salary
FROM dbo.MapEmployeeHierarchy AS a
INNER JOIN dbo.DimEmployee AS b ON a.EmployeeID=b.EmployeeID
GROUP BY a.ManagerEmployeeID
HAVING (SELECT Salary FROM dbo.DimEmployee WHERE ManagerEmployeeID=EmployeeID) < 2*AVG(b.Salary)


/*

Table:: MAP_CUSTOMER_TERRITORY

+------------+-------------+--------------+-----------------+
| CustomerID | TerritoryID | CustomerCity | CustomerPinCode |
+------------+-------------+--------------+-----------------+

Table:: FCT_CUSTOMER_SALES

+------------+--------------+---------------+------------+---------+------------+
| CustomerID | ProductSKUID | OrderDateTime | OrderValue | OrderID | OrderMonth |
+------------+--------------+---------------+------------+---------+------------+

Q) Write a query to return Territory and corresponding Sales Growth
	(compare growth between quaterss Q4-2019 vs Q3-2019)

*/

SELECT
	zz.TerritoryID,
	(((zz.Fourth_Qtr_Sales - zz.Third_Qtr_Sales) * 100)/zz.Third_Qtr_Sales) AS Sales_Growth
FROM (
	SELECT
		mct.TerritoryID,
		SUM(CASE WHEN fcs.OrderDateTime BETWEEN CAST('2021-07-01' AS DATE) AND CAST('2021-09-30' AS DATE)
					THEN fcs.OrderValue
				ELSE 0
			END) AS Third_Qtr_Sales,
			
		SUM(CASE WHEN fcs.OrderDateTime BETWEEN CAST('2021-10-01' AS DATE) AND CAST('2021-12-31' AS DATE)
					THEN fcs.OrderValue
				ELSE 0
			END) AS Fourth_Qtr_Sales
	FROM FCT_CUSTOMER_SALES AS fcs
	INNER JOIN MAP_CUSTOMER_TERRITORY AS mct ON fcs.CustomerID = mct.CustomerID
) AS zz
	

/*

Table:: DIM_PRODUCT
+--------------+----------------+--------------+------------+
| ProductSKUID | ProductSKUName | ProductBrand | MarketName |
+--------------+----------------+--------------+------------+

Table:: FACT_CUSTOMER_SALES
+------------+--------------+---------------+------------+---------+------------+
| CustomerID | ProductSKUID | OrderDateTime | OrderValue | OrderID | OrderMonth |
+------------+--------------+---------------+------------+---------+------------+

Table:: MAP_CUSTOMER_TERRITORY
+------------+-------------+--------------+-----------------+
| CustomerID | TerritoryID | CustomerCity | CustomerPinCode |
+------------+-------------+--------------+-----------------+

Q) Write a query to find the Market Share at Product Brand level for each Territory,
	for time period Q4-2019

*/

DECLARE @TotalSales INT;
SET @TotalSales = (SELECT SUM(OrderValue) FROM FACT_CUSTOMER_SALES);

SELECT
	mct.TerritoryID,
	dp.ProductBrand,
	dp.MarketName,
	SUM(fcs.OrderValue)/@TotalSales AS MarketShare
FROM FACT_CUSTOMER_SALES AS fcs
INNER JOIN MAP_CUSTOMER_TERRITORY AS mct ON mct.CustomerID=fcs.CustomerID
INNER JOIN DIM_PRODUCT AS dp ON dp.ProductSKUID=fcs.ProductSKUID
WHERE fct.OrderDateTime BETWEEN CAST('2019-10-01' AS DATE) AND CAST('2019-12-31' AS DATE)
GROUP BY mct.TerritoryID, dp.ProductBrand, dp.MarketName;

