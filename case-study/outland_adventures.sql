-- Create database
DROP DATABASE IF EXISTS outland_adventures;
CREATE DATABASE outland_adventures;
USE outland_adventures;

-- Drop and recreate user
DROP USER IF EXISTS 'outland_user'@'localhost';
CREATE USER 'outland_user'@'localhost' IDENTIFIED BY 'guide';
GRANT ALL PRIVILEGES ON outland_adventures.* TO 'outland_user'@'localhost';

-- Create all tables
DROP TABLE IF EXISTS EquipmentTransaction;
DROP TABLE IF EXISTS Equipment;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS TripGuide;
DROP TABLE IF EXISTS Trip;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Guide;
DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Role VARCHAR(50),
    HireDate DATE
);

CREATE TABLE Guide (
    GuideID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    HireDate DATE
);

CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    RegistrationDate DATE
);

CREATE TABLE Trip (
    TripID INT AUTO_INCREMENT PRIMARY KEY,
    Destination VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    VisaRequired BOOLEAN,
    InoculationsRequired BOOLEAN
);

CREATE TABLE TripGuide (
    TripID INT,
    GuideID INT,
    PRIMARY KEY (TripID, GuideID),
    FOREIGN KEY (TripID) REFERENCES Trip(TripID),
    FOREIGN KEY (GuideID) REFERENCES Guide(GuideID)
);

CREATE TABLE Booking (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    TripID INT,
    BookingDate DATE,
    PaymentStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TripID) REFERENCES Trip(TripID)
);

CREATE TABLE Equipment (
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

CREATE TABLE EquipmentTransaction (
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
INSERT INTO Employee (FirstName, LastName, Role, HireDate) VALUES 
('James', 'Brown', 'Inventory Manager', '2025-07-11'),
('Alexis', 'Mitchell', 'E-commerce Admin', '2025-07-11'),
('Gabe', 'Conner', 'Guide', '2025-07-11');

INSERT INTO Guide (FirstName, LastName, HireDate) VALUES 
('Gabe', 'Conner', '2025-07-11');

INSERT INTO Customer (FirstName, LastName, Email, Phone, RegistrationDate) VALUES 
('John', 'Doe', 'johndoe@email.com', '123-456-7890', '2025-07-11'),
('Mary', 'Smith', 'marysmith@email.com', '987-654-3210', '2025-07-11');

INSERT INTO Trip (Destination, StartDate, EndDate, VisaRequired, InoculationsRequired) VALUES 
('Africa', '2025-07-11', '2025-07-11', TRUE, TRUE);

INSERT INTO TripGuide (TripID, GuideID) VALUES (1, 1);

INSERT INTO Booking (CustomerID, TripID, BookingDate, PaymentStatus) VALUES 
(1, 1, '2025-07-11', 'Paid');

INSERT INTO Equipment (Name, Type, PurchaseDate, Conditions, StockQuantity, ReorderLevel, Price, ManagedByEmployeeID)
VALUES ('Backpack', 'Camping Gear', '2025-07-11', 'Good', 15, 5, 120.00, 1);

INSERT INTO EquipmentTransaction (CustomerID, EquipmentID, TransactionType, TransactionDate, Quantity)
VALUES (1, 1, 'Rental', '2025-07-11', 1);