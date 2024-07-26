--BEGINNER

--1.List the top 10 orders with the highest sales from the EachOrderBreakdown table.

SELECT TOP 10 *
FROM EachOrderBreakdown
Order BY Sales DESC

--2.Show the number of orders for each product category in the EachOrderBreakdown table.

SELECT Category, COUNT(*) As NumberOfOrders 
FROM EachOrderBreakdown
GROUP BY Category

--3.Find the total profit for each sub-category in the EachOrderBreakdown table.

SELECT SubCategory, SUM(Profit) As TotalProfit 
FROM EachOrderBreakdown
GROUP BY SubCategory

--Intermediate
--1.Identify the customer with the highest total sales across all orders.

SELECT Top 1 CustomerName, SUM(Sales) AS TotalSales
FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
GROUP By CustomerName
ORDER BY TotalSales DESC


--2.Find the month with the highest average sales in the OrdersList table.

Select * from OrdersList
Select * from EachOrderBreakdown

SELECT Top 1 Month(OrderDate) As Month, AVG(Sales) as AverageSales 
FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
GROUP BY Month(OrderDate)
Order By AverageSales DESC

--3.Find out the average quantity ordered by customers whose first name starts with an alphabet 's'?

SELECT AVG(Quantity) as AverageQuantity 
FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
Where LEFT(CustomerName,1) = 'S'

--Advanced

--1.Find out how many new customers were acquired in the year 2014?
SELECT COUNT(*) As NumberOfNewCustomers FROM (
SELECT CustomerName, MIN(OrderDate) AS FirstOrderDate
from Orderslist
GROUP BY CustomerName
Having YEAR(MIN(OrderDate)) = '2014') AS CustWithFirstOrder2014


--2.Calculate the percentage of total profit contributed by each sub-category to the overall profit.

Select SubCategory, SUM(Profit) As SubCategoryProfit,
SUM(Profit)/(Select SUM(Profit) FROM EachOrderBreakdown) * 100 AS PercentageOfTotalContribution
FROM EachOrderBreakdown
Group By SubCategory


--3.Find the average sales per customer, considering only customers who have made more than one order.
WITH CustomerAvgSales AS(
SELECT CustomerName, COUNT(DISTINCT ol.OrderID) As NumberOfOrders, AVG(Sales) AS AvgSales
FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID 
GROUP BY CustomerName
)
SELECT CustomerName, AvgSales
FROM CustomerAvgSales
WHERE NumberOfOrders > 12


--4.Identify the top-performing subcategory in each category based on total sales. Include the sub-category name, total sales, and a ranking of sub-category within each category.
WITH topsubcategory AS(
SELECT Category, SubCategory, SUM(sales) as TotalSales,
RANK() OVER(PARTITION BY Category ORDER BY SUM(sales) DESC) AS SubcategoryRank
FROM EachOrderBreakdown
Group By Category, SubCategory
)
SELECT *
FROM topsubcategory
WHERE SubcategoryRank = 1

