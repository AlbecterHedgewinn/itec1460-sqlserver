sqlq "INSERT INTO Customers (CustomerID, CompanyName, ContactName, Country)
VALUES ('STUDE', 'Student Company', 'Daniel Bittner', 'USA');"
sqlq "SELECT CUSTOMERID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"
sqlq "INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipCountry)
VALUES ('STUDE', 1, GETDATE(), 'USA');"

sqlq "SELECT TOP 1 OrderID FROM Orders WHERE CustomerID = 'STUDE' ORDER BY OrderID DESC;"
sqlq "UPDATE Customers SET ContactName = 'New Contact Name' WHERE CustomerID = 'STUDE';"
sqlq "SELECT ContactName FROM Customers WHERE CustomerID = 'STUDE';"
sqlq "UPDATE Orders SET ShipCountry = 'New Country' WHERE CustomerID = 'STUDE';"
sqlq "SELECT ShipCountry FROM Orders WHERE CustomerID = 'STUDE';"

sqlq "DELETE Orders WHERE CustomerID = 'STUDE';"
sqlq "SELECT OrderID, CustomerID FROM Orders WHERE CustomerID = 'STUDE';"
sqlq "DELETE FROM Customers WHERE CustomerID = 'STUDE';"
sqlq "SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"

-- Part 2 of Lab 5

-- Insert Operation 
sqlq "INSERT INTO Customers (CustomerID, CompanyName, ContactName, Country) VALUES ('STUDE', 'Student Company', 'Your Name', 'Your Country');"
sqlq "SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"
sqlq "INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipCountry) VALUES ('STUDE', 1, GETDATE(), 'Your Country');"
sqlq "SELECT TOP 1 OrderID FROM Orders WHERE CustomerID = 'STUDE' ORDER BY OrderID DESC;"

-- Update Operation
sqlq "UPDATE Customers SET ContactName = 'New Contact Name' WHERE CustomerID = 'STUDE';"
sqlq "UPDATE Orders SET ShipCountry = 'New Country' WHERE CustomerID = 'STUDE';"
sqlq "UPDATE Orders SET ShipCountry = 'New Country' WHERE CustomerID = 'STUDE';"
sqlq "SELECT ShipCountry FROM Orders WHERE CustomerID = 'STUDE';"

-- Delete Operation
sqlq "DELETE FROM Orders WHERE CustomerID = 'STUDE';"
sqlq "SELECT OrderID, CustomerID FROM Orders WHERE CustomerID = 'STUDE';"
sqlq "DELETE FROM Customers WHERE CustomerID = 'STUDE';"
sqlq "SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"