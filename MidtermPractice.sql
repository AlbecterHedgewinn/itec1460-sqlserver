
-- Problem 1 
-- SQL SELECT Statements: Write a query to list all products (ProductName) with their CategoryName and SupplierName.

SELECT 
    p.ProductName,
    c.CategoryName,
    s.CompanyName AS SupplierName
FROM 
    Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
    INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
ORDER BY 
    p.ProductName;
GO


-- Problem 2
-- SQL JOINs: Find all customers who have never placed an order. Display the CustomerID and CompanyName.

SELECT c.CustomerID, c.CompanyName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Correct Version
SELECT 
    c.CustomerID, 
    c.CompanyName
FROM 
    Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE 
    o.OrderID IS NULL
ORDER BY 
    c.CompanyName;
GO

-- Problem 3
-- Functions and GROUP BY: List the top 5 employees by total sales amount. Include EmployeeID, FirstName, LastName, and TotalSales.

SELECT TOP 5
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM 
    Employees e
    INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY 
    e.EmployeeID, e.FirstName, e.LastName
ORDER BY 
    TotalSales DESC;
GO

-- Problem 4
-- SQL Insert Statement: Add a new product to the Products table with the following details:
--ProductName: "Northwind Coffee"
--SupplierID: 1
--CategoryID: 1
--QuantityPerUnit: "10 boxes x 20 bags"
--UnitPrice: 18.00
--UnitsInStock: 39
--UnitsOnOrder: 0
--ReorderLevel: 10
--Discontinued: 0

INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES ('Northwind Coffee', 1, 1, '10 boxes x 20 bags', 18.00, 39, 0, 10, 0);

-- Problem 5
-- SQL Update Statement: Increase the UnitPrice of all products in the "Beverages" category by 10%.

UPDATE Beverages SET UnitPrice = UnitPrice * 1.10;

-- Updated
UPDATE Products
SET UnitPrice = UnitPrice * 1.10
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages';
GO

-- Problem 6
-- SQL Insert and Delete Statements:
-- a) Insert a new order for customer VINET with today's date.
-- b) Delete the order you just created.

INSERT INTO Orders (Customer, OrderDate)
VALUES ('VINET', SYSDATE);

DELETE FROM Orders 
WHERE Customer = 'VINET';


-- Altered
INSERT INTO Orders (
    CustomerID,
    EmployeeID,
    OrderDate,
    RequiredDate
)
VALUES (
    'VINET',
    1,
    GETDATE(),
    DATEADD(day, 7, GETDATE())
);

DELETE FROM Orders 
WHERE CustomerID = "Vinet";




-- Problem 7
-- Creating Tables: Create a new table named "ProductReviews" with the following columns:

-- ReviewID (int, primary key)
-- ProductID (int, foreign key referencing Products table)
-- CustomerID (nchar(5), foreign key referencing Customers table)
-- Rating (int)
-- ReviewText (nvarchar(max))
-- ReviewDate (datetime)

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductReviews')
    DROP TABLE ProductReviews;
GO

CREATE TABLE ProductReviews (
    ReviewID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CustomerID NCHAR(5) FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    Rating INT,
    ReviewText NVARCHAR(max),
    ReviewDate DATETIME
);

-- Problem 8
-- Creating Views: Create a view named "vw_ProductSales" that shows 
-- ProductName, CategoryName, and TotalSales (sum of UnitPrice * Quantity) for each product.



IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_ProductSalesView')
    DROP VIEW vw_ProductSalesViews;
GO


GO                                                          -- Remember to use GO for seperating creation blocks
CREATE VIEW vw_ProductSalesView AS
SELECT
    p.ProductName,
    c.CategoryName,
    SUM(o.UnitPrice * o.Quantity) AS TotalSales
FROM
    Products AS p
JOIN
    Categories AS c ON p.CategoryID = c.CategoryID
JOIN
    OrderDetails AS o ON p.ProductID = o.ProductID
GROUP BY
    p.ProductName, c.CategoryName;

-- Problem 9
-- Stored Procedures: Write a stored procedure named "sp_TopCustomersByCountry" 
-- that takes a country name as input and returns the top 3 customers by total order amount for that country.

GO
CREATE PROCEDURE sp_TopCustomersByCountry
    @CountryName NVARCHAR(255)
AS
BEGIN
    SELECT TOP 3
        CustomerName,
        SUM(TotalOrderAmount) AS TotalSpending
    FROM
        Customers
    JOIN
        Orders ON Customers.CustomerID = Orders.CustomerID
    WHERE
        Customers.Country = @CountryName
    GROUP BY
        CustomerName
    ORDER BY
        TotalSpending DESC;
END;

-- Problem 10
-- Complex Query: Write a query to find the employee who has processed orders for the most unique products. 
-- Display the EmployeeID, FirstName, LastName, and the count of unique products they've processed.

SELECT TOP 1
    EmployeeID,
    FirstName,
    LastName,
    COUNT(DISTINCT ProductID) AS UniqueProductsProcessed
FROM Employeess
GROUP BY FirstName, LastName
ORDER BY EmployeeID, UniqueProductsProcessed DESC;

-- Apparently Count Distinct is not supported in MS Access, here is a workaround:
-- SELECT Count(*) AS DistinctCountries
-- FROM (SELECT DISTINCT Country FROM Customers);

SELECT TOP 1 E.EmployeeID, E.FirstName, E.LastName, COUNT(P.ProductID) AS UniqueProductsProcessed
FROM EmployeeSales AS E
INNER JOIN 
    (SELECT EmployeeID, ProductID FROM EmployeeSales GROUP BY EmployeeID, ProductID) 
    AS P
    ON E.EmployeeID = P.EmployeeID
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY UniqueProductsProcessed DESC;