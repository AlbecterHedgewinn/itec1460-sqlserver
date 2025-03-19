/*
Questions
1. SQL SELECT:

You're giving awards to employees based on the year they started working at Northwind.
Write a query to list all employees (FirstName, LastName) along with their start date.
*/

SELECT 
    FirstName,
    LastName,
    HireDate
FROM 
    Employees
ORDER BY 
    HireDate
GO

/*
2. SQL JOIN:

Create a simple report showing which employees are handling orders. Write a query that:

1. Lists employee names (FirstName and LastName)
2. Shows the OrderID for each order they've processed
3. Shows the OrderDate
4. Sorts the results by EmployeeID and then OrderDate

This basic report will help us see which employees are actively processing orders in the Northwing system.
*/

SELECT
    e.FirstName,
    e.LastName,
    e.EmployeeID,
    o.OrderID,
    o.OrderDate
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
ORDER BY e.Employee, o.OrderDate

/*
3. Functions and GROUP BY:

Create a simple report showing total sales by product category. Include the CategoryName and TotalSales 
(calculated as the sum of UnitPrice * Quantity). Sort your results by TotalSales in descending order.
*/

SELECT
    p.ProductID,
    p.CategoryID,
    c.CategoryName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales -- The phrasing is the same as the practice exam, so I used the same calculation
FROM Products p 
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID              -- Wasn't sure if OrderDetails or [Order Details] was preferred
GROUP BY p.ProductID, p.CategoryID
ORDER BY TotalSales DESC;
GO

/*
4. SQL Insert Statements:

Complete the following tasks:

Insert a new supplier named "Northwind Traders" based in Seattle, USA.
Create a new category called "Organic Products".
Update all products from supplier "Exotic Liquids" to belong to the new "Organic Products" category.
Insert a new product called "Minneapolis Pizza". You can choose the category, supplier, and other values.

5. SQL Update Statement:

Update all products from supplier "Exotic Liquids" to belong to the new "Organic Products" category.
*/

-- I couldn't help but notice the repeated instruction for problem 5 from problem 4, so I just decided to do them together

INSERT INTO Suppliers (
    SupplierID,
    SupplierName,
    Adress,
    City,
    Country
)
VALUES (
    '123',
    'Northwind Traders',
    '2545 Whatever Lane',
    'Seattke',
    'USA'
);
GO

INSERT INTO Categories (
    CategoryID,
    CategoryName
)
VALUES (
    343,
    'Organic Products'
)
GO

UPDATE Products
SET CategoryID = 343
FROM Products p
INNER JOIN Categories c ON p.ProductID = c.ProductID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID 
WHERE s.SupplierName = 'Exotic Liquids';
GO

INSERT INTO Products (
    ProductName,
    SupplierID,
    CategoryID,
    QuantityPerUnit,
    UnitPrice,
    UnitsInStock,
    UnitsOnOrder,
    ReorderLevel,
    Discontinued
)
VALUES (
    'Minneapolis Pizza',
    6,
    6,
    '8 slices x 1 box',
    20.00,
    3900000,
    1,
    1,
    0
);
GO

/*
6. SQL Delete Statement:

Remove the product "Minneapolis Pizza".
*/

DELETE FROM Products WHERE ProductName = 'Minneapolis Pizza';
GO

/*
7. Creating Tables and Constraints:

Create a new table named "EmployeePerformance" with the following columns:

PerformanceID (int, primary key, auto-increment)
EmployeeID (int, foreign key referencing Employees table)
Year (int)
Quarter (int)
SalesTarget (decimal(15,2))
ActualSales (decimal(15,2))
Hint: Remember to add a foreign key constraint to the EmployeeID column so that EmployeeID is a foreign key in the Employee Performance table that references the EmployeeID that is the primary key in the employees table. This will establish a relationship between Employees and EmployeePerformance.
*/

-- Following your example for ensuring that this table doesn't already exist :)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeePerformance')
    DROP TABLE EmployeePerformance;
GO

CREATE TABLE EmployeePerformance (
    PerformanceID int PRIMARY KEY AUTO INCREMENT,
    EmployeeID int FOREIGN KEY REFERENCES Employees(EmployeeID),
    Year int,
    Quarter int,
    SalesTarget DECIMAL(15, 2),
    ActualSales DECIMAL(15, 2)
);
GO

/*
8. Creating Views:

Create a view named "vw_ProductInventory" that shows ProductName, CategoryName, UnitsInStock, and UnitsOnOrder for all products.
*/

IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_ProductInventory')
    DROP VIEW vw_ProductInventory;
GO

CREATE VIEW vw_ProductInventory AS
SELECT 
    p.ProductName,
    p.UnitsInStock,
    p.UnitsOnOrder,
    c.CategoryName
FROM 
    Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY 
    p.ProductName
GO

/*
9. Stored Procedures:

Create a stored procedure called "sp_UpdateProductInventory" that:

Takes two inputs: ProductID and NewStockLevel
Updates the UnitsInStock value for the product you specify
Makes sure the stock level is never less than zero
*/

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_UpdateProductInventory')
    DROP PROCEDURE sp_UpdateProductInventory;
GO

CREATE PROCEDURE sp_UpdateProductInventory
    @ProductID int,
    @NewStockLevel int
AS
BEGIN
    SET NOCOUNT ON; -- Reduces Network Traffic for better performance
 
    IF @NewStockLevel < 1
    BEGIN
        -- This should set the stock level to at least 1 no matter what as per the directions
        SET @NewStockLevel = 1;
    END
    
    UPDATE Products
    SET UnitsInStock = @NewStockLevel
    WHERE ProductID = @ProductID;
END;
GO

/*
10. Complex Query:

Write a query to find the top 5 customers by total freight costs. 
Include CustomerID, TotalFreightCost, NumberOfOrders, and AverageFreightPerOrder. Use only the Orders table without any JOINs.
*/

SELECT TOP 5
    OrderID,
    COUNT(DISTINCT OrderID) AS NumberOfOrders,
    Freight AS TotalFreightCost,
    AVG(Freight) AS AverageFreightPerOrder
FROM Orders
GROUP BY OrderID
ORDER BY TotalFreightCost;
GO

-- This one was a doozy due to semantics. To begin with, I assumed you wanted the total number of orders rather than the quantity of all orders
-- I actually wasn't sure what you wanted for FreightCost, since the ERDs conflict heavily. Some have a Freight whereas others dont,
-- And I think none of them have a Cost per Freight, so I thought about subbing for UnitPrice and Quantity
-- SUM((SELECT Quantity FROM OrderDetails WHERE Orders.OrderID = OrderDetails.OrderID) * (SELECT UnitPrice FROM OrderDetails WHERE Orders.OrderID = OrderDetails.OrderID)) as TotalFreightCost
-- I eventually concluded that although the definition of Freight is bulk transportation and weight, that the Freight value contains the cost
-- -of its total size/weight rather than the actual size/weight
-- I didn't get to test if that SUM function would have worked, but I assumed you wanted a subquery, and that would've fit the bill xD