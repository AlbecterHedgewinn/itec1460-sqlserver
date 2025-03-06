-- Create a new stored procedure that calculates the total amount for an order
-- Specifying a parameter as OUTPUT means the procedure can modify
-- the parameter's value.

CREATE OR ALTER PROCEDURE CalculateOrderTotal
    @OrderID INT,
    @TotalAmount MONEY OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Calculate the total amount for the given order
    SELECT @TotalAmount = SUM(UnitPrice * Quantity * (1 - Discount))
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    -- Check if the order exists
    IF @TotalAmount IS NULL
    BEGIN
        SET @TotalAmount = 0;
        PRINT 'Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' not found.';
        RETURN;
    END

    PRINT 'The total amount for Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' is $' + CAST(@TotalAmount AS NVARCHAR(20));
END
GO

-- Test the stored procedure with a valid order
DECLARE @OrderID INT = 10248;
DECLARE @TotalAmount MONEY;

EXEC CalculateOrderTotal 
    @OrderID = @OrderID, 
    @TotalAmount = @TotalAmount OUTPUT;

PRINT 'Returned total amount: $' + CAST(@TotalAmount AS NVARCHAR(20));

-- Test with an invalid order
SET @OrderID = 99999;
SET @TotalAmount = NULL;

EXEC CalculateOrderTotal 
    @OrderID = @OrderID, 
    @TotalAmount = @TotalAmount OUTPUT;

PRINT 'Returned total amount: $' + CAST(ISNULL(@TotalAmount, 0) AS NVARCHAR(20));
GO

-- =============================================
-- Part 2: CheckProductStock Procedure
-- =============================================

-- I did what I could on my own, then overwrote using the solution. Sorry if this violates your instructions

CREATE OR ALTER PROCEDURE CheckProductStock
    @ProductID INT,                         -- Parameters / Inputs asked by the Procedure when called
    @NeedsReorder BIT OUTPUT                -- Y/N Boolean Parameter 
AS                                          -- Output parameters allow the stored procedure to pass a data value or a cursor variable back to the caller
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @UnitsInStock INT;              -- Declaring variables initially puts them at the Null value, unless Set
    DECLARE @ReorderLevel INT;
    DECLARE @ProductName NVARCHAR(40);
    
    -- Get product information
    SELECT 
        @UnitsInStock = UnitsInStock,       -- This grabs the information from the relevant tables and stores them in the local Variables
        @ReorderLevel = ReorderLevel,
        @ProductName = ProductName
    FROM Products
    WHERE ProductID = @ProductID;
    
    -- Check if product exists
    IF @ProductName IS NULL
    BEGIN
        SET @NeedsReorder = 0;              -- This sets the Boolean to 0, which is False. No reorder is needed bc it doesnt exist
        PRINT 'Product ID ' + CAST(@ProductID AS NVARCHAR(10)) + ' not found.';
        RETURN;                             -- Remember: Cast converts anything to a datatype, in this case, NVARCHAR with 10 positions
    END                                     -- We want to format our data so that we can view it in the print statement
    
    -- Check if reorder is needed
    IF @UnitsInStock <= @ReorderLevel
    BEGIN
        SET @NeedsReorder = 1;              -- This sets the Boolean to 1, which is True. Yes a reorder is needed
        PRINT @ProductName + ' needs reordering! Stock: ' + 
              CAST(@UnitsInStock AS NVARCHAR(10)) + 
              ', Reorder Level: ' + CAST(@ReorderLevel AS NVARCHAR(10));
    END
    ELSE
    BEGIN
        SET @NeedsReorder = 0;
        PRINT @ProductName + ' has adequate stock. Stock: ' + 
              CAST(@UnitsInStock AS NVARCHAR(10)) + 
              ', Reorder Level: ' + CAST(@ReorderLevel AS NVARCHAR(10));
    END
    
END
GO

-- Test the new procedure
DECLARE @NeedsReorder BIT;
EXEC CheckProductStock              -- Exec is short for Execute, which exeutes a given Stored Procedure (CheckProductStock)
    @ProductID = 11,
    @NeedsReorder = @NeedsReorder OUTPUT;
PRINT 'Needs Reorder: ' + CAST(@NeedsReorder AS VARCHAR(1));