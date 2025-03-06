
-- Problem 1 
-- SQL SELECT Statements: Write a query to list all products (ProductName) with their CategoryName and SupplierName.

SELECT
    Product AS ProductName, -- I assumed we're using a hypothetical database
    Category AS CategoryName,
    Supplier AS SupplierName
FROM Products;


-- Problem 2
-- SQL JOINs: Find all customers who have never placed an order. Display the CustomerID and CompanyName.

SELECT c.CustomerID, c.CompanyName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Problem 3
-- Functions and GROUP BY: List the top 5 employees by total sales amount. Include EmployeeID, FirstName, LastName, and TotalSales.

SELECT TOP 5 EmployeeID, FirstName, LastName, TotalSales
FROM employees
ORDER BY TotalSales DESC;

SELECT TOP 5 EmployeeID, FirstName, LastName, SUM(Sales) AS TotalSales
FROM employees
GROUP BY EmployeeID, FirstName, LastName
ORDER BY TotalSales DESC;

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

-- Problem 6
-- SQL Insert and Delete Statements:
-- a) Insert a new order for customer VINET with today's date.
-- b) Delete the order you just created.

INSERT INTO Orders (Customer, OrderDate)
VALUES ('VINET', SYSDATE);

DELETE FROM Orders 
WHERE Customer = 'VINET';

-- Problem 7
-- Creating Tables: Create a new table named "ProductReviews" with the following columns:

-- ReviewID (int, primary key)
-- ProductID (int, foreign key referencing Products table)
-- CustomerID (nchar(5), foreign key referencing Customers table)
-- Rating (int)
-- ReviewText (nvarchar(max))
-- ReviewDate (datetime)

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