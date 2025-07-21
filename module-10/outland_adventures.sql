-- Drop and create user
DROP USER IF EXISTS 'outland_user'@'localhost';
CREATE USER 'outland_user'@'localhost' IDENTIFIED BY 'guide';
GRANT ALL PRIVILEGES ON outland_adventures.* TO 'outland_user'@'localhost';

-- Use the database
USE outland_adventures;

-- Temporarily disable foreign key checks to drop tables
SET FOREIGN_KEY_CHECKS = 0;

-- Drop tables if they exist
DROP TABLE IF EXISTS EquipmentTransaction;
DROP TABLE IF EXISTS Equipment;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS TripGuide;
DROP TABLE IF EXISTS Trip;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Guide;
DROP TABLE IF EXISTS Employee;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Create tables
CREATE TABLE IF NOT EXISTS Employee (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Role VARCHAR(50),
    HireDate DATE
);

CREATE TABLE IF NOT EXISTS Guide (
    GuideID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    HireDate DATE
);

CREATE TABLE IF NOT EXISTS Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    RegistrationDate DATE
);

CREATE TABLE IF NOT EXISTS Trip (
    TripID INT AUTO_INCREMENT PRIMARY KEY,
    Destination VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    VisaRequired BOOLEAN,
    InoculationsRequired VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS TripGuide (
    TripID INT,
    GuideID INT,
    PRIMARY KEY (TripID, GuideID),
    FOREIGN KEY (TripID) REFERENCES Trip(TripID),
    FOREIGN KEY (GuideID) REFERENCES Guide(GuideID)
);

CREATE TABLE IF NOT EXISTS Booking (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    TripID INT,
    BookingDate DATE,
    PaymentStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TripID) REFERENCES Trip(TripID)
);

CREATE TABLE IF NOT EXISTS Equipment (
    EquipmentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Type VARCHAR(50),
    PurchaseDate DATE,
    Conditions VARCHAR(20),
    StockQuantity INT,
    ReorderLevel INT,
    Price DECIMAL(10,2),
    ManagedByEmployeeID INT,
    FOREIGN KEY (ManagedByEmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE IF NOT EXISTS EquipmentTransaction (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    EquipmentID INT,
    TransactionType VARCHAR(10),
    TransactionDate DATE,
    Quantity INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);

-- Insert sample data

INSERT INTO Employee (EmployeeID, FirstName, LastName, Role, HireDate) VALUES
    (1, 'Blake', 'Timmerson', 'Admin', '2020-01-01'),
    (2, 'Jim', 'Ford', 'Admin', '2020-02-01'),
    (3, 'John', 'MacNell', 'Guide', '2021-05-01'),
    (4, 'Duke', 'Marland', 'Guide', '2021-06-15'),
    (5, 'Anita', 'Gall', 'Marketing', '2021-07-01'),
    (6, 'Tim', 'Strat', 'Inventory', '2021-08-01');

INSERT INTO Guide (GuideID, FirstName, LastName, HireDate) VALUES
    (1, 'John', 'MacNell', '2021-05-01'),
    (2, 'Duke', 'Marland', '2021-06-15'),
    (3, 'Sophie', 'Hill', '2022-01-20'),
    (4, 'Liam', 'Young', '2022-03-10'),
    (5, 'Nina', 'Clark', '2022-05-25'),
    (6, 'Oscar', 'Wright', '2023-01-05');

INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Phone, RegistrationDate) VALUES
    (1, 'Alice', 'Smith', 'alice@gmail.com', '1234567890', '2022-01-15'),
    (2, 'Bob', 'Johnson', 'bob@gmail.com', '1234567891', '2022-02-10'),
    (3, 'Carol', 'Taylor', 'carol@yahoo.com', '1234567892', '2022-03-05'),
    (4, 'David', 'Lee', 'david@aol.com', '1234567893', '2022-04-20'),
    (5, 'Eva', 'Brown', 'eva@yahoo.com', '1234567894', '2022-05-18'),
    (6, 'Frank', 'Wilson', 'frank@aol.com', '1234567895', '2022-06-11');

INSERT INTO Trip (TripID, Destination, StartDate, EndDate, VisaRequired, InoculationsRequired) VALUES
    (1, 'Africa', '2023-09-01', '2023-09-15', 1, 'Yellow Fever'),
    (2, 'Asia', '2023-10-05', '2023-10-20', 1, 'Hepatitis A, Typhoid'),
    (3, 'Southern Europe', '2023-11-01', '2023-11-12', 0, ''),
    (4, 'Africa', '2024-01-10', '2024-01-24', 1, 'Yellow Fever'),
    (5, 'Asia', '2024-03-05', '2024-03-19', 1, 'Hepatitis A'),
    (6, 'Southern Europe', '2024-05-10', '2024-05-22', 0, '');

INSERT INTO TripGuide (TripID, GuideID) VALUES
    (1, 1),  -- Africa trip in 2023-09, guided by John MacNell (hired 2021-05)
    (2, 2),  -- Asia trip in 2023-10, guided by Duke Marland (hired 2021-06)
    (3, 3),  -- Southern Europe in 2023-11, guided by Sophie Hill (hired 2022-01)
    (4, 4),  -- Africa in 2024-01, guided by Liam Young (hired 2022-03)
    (5, 5),  -- Asia in 2024-03, guided by Nina Clark (hired 2022-05)
    (6, 6);  -- Southern Europe in 2024-05, guided by Oscar Wright (hired 2023-01)


INSERT INTO Booking (BookingID, CustomerID, TripID, BookingDate, PaymentStatus) VALUES
    (1, 1, 1, '2023-07-01', 'Paid'),
    (2, 2, 2, '2023-07-15', 'Paid'),
    (3, 3, 3, '2023-08-01', 'Pending'),
    (4, 4, 4, '2023-12-01', 'Paid'),
    (5, 5, 5, '2024-01-01', 'Paid'),
    (6, 6, 6, '2024-03-01', 'Pending');

INSERT INTO Equipment (EquipmentID, Name, Type, PurchaseDate, Conditions, StockQuantity, ReorderLevel, Price, ManagedByEmployeeID) VALUES
    (1, 'Tent 2-Person', 'Tent', '2019-04-15', 'Good', 10, 3, 120.00, 6),
    (2, 'Hiking Boots', 'Footwear', '2020-07-10', 'Fair', 15, 5, 90.00, 6),
    (3, 'Sleeping Bag', 'Sleeping Gear', '2021-05-12', 'Excellent', 20, 5, 60.00, 6),
    (4, 'Camp Stove', 'Cooking', '2022-01-20', 'Excellent', 8, 2, 50.00, 6),
    (5, 'Backpack 50L', 'Pack', '2023-03-18', 'New', 12, 4, 75.00, 6),
    (6, 'Water Filter', 'Safety', '2020-11-11', 'Good', 6, 2, 40.00, 6);

INSERT INTO EquipmentTransaction (TransactionID, CustomerID, EquipmentID, TransactionType, TransactionDate, Quantity) VALUES
    (1, 1, 1, 'rental', '2023-08-15', 1),
    (2, 2, 2, 'sale', '2023-08-16', 1),
    (3, 3, 3, 'rental', '2023-08-17', 2),
    (4, 4, 4, 'sale', '2023-08-18', 1),
    (5, 5, 5, 'rental', '2023-08-19', 1),
    (6, 6, 6, 'sale', '2023-08-20', 1);