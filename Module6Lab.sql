CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    AuthorID INT,
    PublicationYear INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Insert data into Authors table
INSERT INTO Authors (AuthorID, FirstName, LastName, BirthDate)
VALUES 
(1, 'Jane', 'Austen', '1775-12-16'),
(2, 'George', 'Orwell', '1903-06-25'),
(3, 'J.K.', 'Rowling', '1965-07-31'),
(4, 'Ernest', 'Hemingway', '1899-07-21'),
(5, 'Virginia', 'Woolf', '1882-01-25');

-- Insert data into Books table
INSERT INTO Books (BookID, Title, AuthorID, PublicationYear, Price)
VALUES 
(1, 'Pride and Prejudice', 1, 1813, 12.99),
(2, '1984', 2, 1949, 10.99),
(3, 'Harry Potter and the Philosopher''s Stone', 3, 1997, 15.99),
(4, 'The Old Man and the Sea', 4, 1952, 11.99),
(5, 'To the Lighthouse', 5, 1927, 13.99);

GO

-- Error occuring here, Create View must be the only statement in the batch
-- FIXED using the GO Command, which sends all sql statements prior to the GO to a SQL Server instance
-- So think of GO as a checkpoint, whichout which, all following statements that dont share 

CREATE VIEW BookDetails AS
SELECT
    b.BookID,
    b.Title,
    a.FirstName + ' ' + a.LastName AS AuthorName,
    b.PublicationYear,
    b.Price
FROM 
    Books b
JOIN 
    Authors a ON b.AuthorID = a.AuthorID;
    GO
    


CREATE VIEW RecentBooks AS
SELECT 
    BookID,
    Title,
    PublicationYear,
    Price
FROM 
    Books
WHERE 
    PublicationYear > 1990;
    GO
    


CREATE VIEW AuthorStats AS
SELECT 
    a.AuthorID,
    a.FirstName + ' ' + a.LastName AS AuthorName,
    COUNT(b.BookID) AS BookCount,
    AVG(b.Price) AS AverageBookPrice
FROM 
    Authors a
LEFT JOIN 
    Books b ON a.AuthorID = b.AuthorID
GROUP BY 
    a.AuthorID, a.FirstName, a.LastName;
    GO


-- a) Retrieve all records from the BookDetails view
SELECT Title, Price FROM BookDetails;

-- b) List all books from the RecentBooks view
SELECT * FROM RecentBooks;

-- c) Show statistics for authors
SELECT * FROM AuthorStats;

GO

CREATE VIEW AuthorContactInfo AS
SELECT AuthorID, FirstName, LastName
FROM 
    Authors;
    GO


UPDATE AuthorContactInfo
SET FirstName = 'Joanne'
WHERE AuthorID = 3;

-- Query the view
SELECT * FROM AuthorContactInfo;




CREATE TABLE BookPriceAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO


CREATE TRIGGER trg_BookPriceChange
ON Books
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Price)
    BEGIN
        INSERT INTO BookPriceAudit (BookID, OldPrice, NewPrice)
        SELECT 
            i.BookID,
            d.Price,
            i.Price
        FROM inserted i
        JOIN deleted d ON i.BookID = d.BookID
    END
END;
GO


-- Update a book's price
UPDATE Books
SET Price = 14.99
WHERE BookID = 1;

-- Check the audit table
SELECT * FROM BookPriceAudit;



CREATE TABLE BookReviews (
    ReviewID INT PRIMARY KEY,
    BookID INT,
    CustomerID NCHAR(5),
    Rating INT,
    ReviewText NVARCHAR(MAX),
    ReviewDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

CREATE VIEW vw_BookReviewStats AS
SELECT 
    b.Title AS BookTitle,
    a.Rating.AVG() AS AverageRating,
    COUNT(a.ReviewID) AS ReviewsTotal,
    LAST(a.ReviewDate) AS MostRecentReview
FROM 
    BookReviews a
LEFT JOIN 
    Books b ON a.BookID = b.BookID
    GO

CREATE TRIGGER tr_ValidateReviewDate ON BookReviews 
AFTER INSERT
AS BEGIN
    UPDATE BookReviews
        SET ReviewDate = GETDATE()
        FROM BookReviews p 
        JOIN Inserted i
             ON p.ReviewDate = i.ReviewDate;
END;
GO

CREATE TRIGGER tr_UpdateBookRating ON BookReviews
AFTER INSERT
AS BEGIN
    ALTER TABLE Books
    ADD AverageRating SMALLINT DEFAULT 1;
    INSERT INTO Books.AverageRating 
        SELECT 
            d.Rating
        FROM inserted i
        JOIN deleted d ON i.Rating = d.Rating
END;

-- SMALLINT DEFAULT should work due to the INT value inherant to the Rating data type being altered