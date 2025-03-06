/*
Questions
1. SQL SELECT:

You're giving awards to employees based on the year they started working at Northwind.
Write a query to list all employees (FirstName, LastName) along with their start date.

2. SQL JOIN:

Create a simple report showing which employees are handling orders. Write a query that:

1. Lists employee names (FirstName and LastName)
2. Shows the OrderID for each order they've processed
3. Shows the OrderDate
4. Sorts the results by EmployeeID and then OrderDate

This basic report will help us see which employees are actively processing orders in the Northwing system.

3. Functions and GROUP BY:

Create a simple report showing total sales by product category. Include the CategoryName and TotalSales (calculated as the sum of UnitPrice * Quantity). Sort your results by TotalSales in descending order.

4. SQL Insert Statements:

Complete the following tasks:

Insert a new supplier named "Northwind Traders" based in Seattle, USA.
Create a new category called "Organic Products".
Update all products from supplier "Exotic Liquids" to belong to the new "Organic Products" category.
Insert a new product called "Minneapolis Pizza". You can choose the category, supplier, and other values.
5. SQL Update Statement:

Update all products from supplier "Exotic Liquids" to belong to the new "Organic Products" category.

6. SQL Delete Statement:

Remove the product "Minneapolis Pizza".

7. Creating Tables and Constraints:

Create a new table named "EmployeePerformance" with the following columns:

PerformanceID (int, primary key, auto-increment)
EmployeeID (int, foreign key referencing Employees table)
Year (int)
Quarter (int)
SalesTarget (decimal(15,2))
ActualSales (decimal(15,2))
Hint: Remember to add a foreign key constraint to the EmployeeID column so that EmployeeID is a foreign key in the Employee Performance table that references the EmployeeID that is the primary key in the employees table. This will establish a relationship between Employees and EmployeePerformance.

8. Creating Views:

Create a view named "vw_ProductInventory" that shows ProductName, CategoryName, UnitsInStock, and UnitsOnOrder for all products.

9. Stored Procedures:

Create a stored procedure called "sp_UpdateProductInventory" that:

Takes two inputs: ProductID and NewStockLevel
Updates the UnitsInStock value for the product you specify
Makes sure the stock level is never less than zero
10. Complex Query:

Write a query to find the top 5 customers by total freight costs. Include CustomerID, TotalFreightCost, NumberOfOrders, and AverageFreightPerOrder. Use only the Orders table without any JOINs.
/*



