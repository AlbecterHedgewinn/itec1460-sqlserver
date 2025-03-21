SELECT C.CompanyName, O.OrderDate FROM Customers AS c JOIN Orders AS o ON c.CustomerID = o.CustomerID;

SELECT c.CustomerID, /* Unique identifier for each customer */ 
c.CompanyName, /* Name of the customer's company */ 
o.OrderID, /* Order number (will be NULL if no orders) */ 
o.OrderDate /* Date of order (will be NULL if no orders) */ 
FROM Customers c /* Main (left) table */ 
LEFT JOIN Orders o /* Table we're matching against */ 
ON c.CustomerID = o.CustomerID; /* The matching condition */

SELECT OrderID, 
ROUND(SUM(UnitPrice * Quantity * (1 - Discount) ), 2 ) 
AS TotalValue, COUNT(*) 
AS NumberOfItems FROM [Order Details] 
GROUP BY OrderID
ORDER BY TotalValue DESC;

SELECT p.ProductID, p.ProductName, COUNT(od.OrderID) AS TimesOrdered
FROM Products p
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(od.OrderID) > 10
ORDER BY TimesOrdered DESC;

SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (
SELECT AVG(UnitPrice)
FROM Products
)
ORDER BY UnitPrice;

SELECT TOP 5
c.CustomerID,
c.CompanyName,
ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalPurchase
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalPurchase DESC;

