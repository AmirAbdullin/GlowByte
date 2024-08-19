-- Создание БД
CREATE DATABASE BankCreditSystem;
USE BankCreditSystem;


CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    DateOfBirth DATE NOT NULL,
    Address VARCHAR(255),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100)
);


CREATE TABLE CreditProduct (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    ProductType VARCHAR(50) NOT NULL,
    InterestRate DECIMAL(5, 2) NOT NULL
);


CREATE TABLE LoanApplication (
    ApplicationID INT PRIMARY KEY AUTO_INCREMENT,
    ApplicationDate DATE NOT NULL,
    RequestedAmount DECIMAL(15, 2) NOT NULL,
    ApplicationStatus VARCHAR(50) NOT NULL,
    CustomerID INT,
    ProductID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES CreditProduct(ProductID)
);


CREATE TABLE LoanContract (
    ContractID INT PRIMARY KEY AUTO_INCREMENT,
    ContractDate DATE NOT NULL,
    LoanAmount DECIMAL(15, 2) NOT NULL,
    ContractStatus VARCHAR(50) NOT NULL,
    CustomerID INT,
    ProductID INT,
    ApplicationID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES CreditProduct(ProductID),
    FOREIGN KEY (ApplicationID) REFERENCES LoanApplication(ApplicationID)
);


CREATE TABLE BankEmployee (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    Position VARCHAR(50)
);


CREATE TABLE StatusHistory (
    HistoryID INT PRIMARY KEY AUTO_INCREMENT,
    EntityID INT NOT NULL,
    EntityType ENUM('LoanApplication', 'LoanContract') NOT NULL,
    OldStatus VARCHAR(50),
    NewStatus VARCHAR(50),
    ChangeDate DATE NOT NULL,
    EmployeeID INT,
    FOREIGN KEY (EmployeeID) REFERENCES BankEmployee(EmployeeID)
);


CREATE TABLE EmployeeInApplication (
    InvolvementID INT PRIMARY KEY AUTO_INCREMENT,
    ApplicationID INT,
    EmployeeID INT,
    FOREIGN KEY (ApplicationID) REFERENCES LoanApplication(ApplicationID),
    FOREIGN KEY (EmployeeID) REFERENCES BankEmployee(EmployeeID)
);


CREATE TABLE EmployeeInContract (
    InvolvementID INT PRIMARY KEY AUTO_INCREMENT,
    ContractID INT,
    EmployeeID INT,
    FOREIGN KEY (ContractID) REFERENCES LoanContract(ContractID),
    FOREIGN KEY (EmployeeID) REFERENCES BankEmployee(EmployeeID)
);



--Заполнение данными

INSERT INTO Customer (FirstName, LastName, MiddleName, DateOfBirth, Address, PhoneNumber, Email)
VALUES
('Ivan', 'Ivanov', 'Ivanovich', '1980-01-01', 'Moscow, Red Square, 1', '+79012345678', 'ivanov@example.com'),
('Petr', 'Petrov', 'Petrovich', '1985-05-15', 'St. Petersburg, Nevsky Prospect, 2', '+79012345679', 'petrov@example.com'),
('Sergey', 'Sergeev', 'Sergeevich', '1990-09-09', 'Novosibirsk, Lenin Street, 3', '+79012345680', 'sergeev@example.com'),
('Anna', 'Smirnova', 'Vladimirovna', '1988-03-12', 'Yekaterinburg, 1905 Street, 5', '+79012345681', 'smirnova@example.com'),
('Olga', 'Kuznetsova', 'Mikhailovna', '1992-11-23', 'Kazan, Baumana Street, 7', '+79012345682', 'kuznetsova@example.com'),
('Vladimir', 'Sokolov', 'Nikolaevich', '1975-06-25', 'Moscow, Tverskaya Street, 8', '+79012345683', 'sokolov@example.com'),
('Elena', 'Vasilieva', 'Igorevna', '1980-08-30', 'Moscow, Arbat Street, 10', '+79012345684', 'vasilieva@example.com');


INSERT INTO CreditProduct (ProductName, ProductType, InterestRate)
VALUES
('Apartment Mortgage', 'Mortgage', 6.5),
('New Car Loan', 'Auto Loan', 9.0),
('Personal Loan for Any Purpose', 'Personal Loan', 12.0),
('Country House Mortgage', 'Mortgage', 7.0),
('Home Renovation Loan', 'Personal Loan', 10.0),
('Commercial Mortgage', 'Mortgage', 8.0),
('Student Loan', 'Personal Loan', 11.0),
('Vacation Loan', 'Personal Loan', 13.0);


INSERT INTO LoanApplication (ApplicationDate, RequestedAmount, ApplicationStatus, CustomerID, ProductID)
VALUES

('2024-03-01', 500000, 'Approved', 1, 1),
('2024-03-05', 600000, 'Rejected', 1, 2),
('2024-03-10', 800000, 'Approved', 2, 1),
('2024-03-15', 400000, 'Rejected', 2, 3),
('2024-03-20', 300000, 'Rejected', 3, 4),
('2024-03-22', 1000000, 'Approved', 3, 5),
('2024-03-25', 700000, 'Approved', 4, 6),
('2024-03-28', 200000, 'Rejected', 4, 7),
('2024-03-29', 500000, 'Approved', 5, 8),
('2024-03-30', 400000, 'Rejected', 5, 8),

('2024-01-15', 2500000, 'Approved', 1, 1),
('2024-02-20', 500000, 'Rejected', 6, 2),
('2024-04-15', 1500000, 'Approved', 7, 3);


INSERT INTO LoanContract (ContractDate, LoanAmount, ContractStatus, CustomerID, ProductID, ApplicationID)
VALUES
('2024-02-01', 2500000, 'Active', 1, 1, 1),
('2024-03-01', 500000, 'Active', 1, 1, 1),
('2024-03-10', 800000, 'Active', 2, 1, 3),
('2024-03-22', 1000000, 'Active', 3, 5, 6),
('2024-03-25', 700000, 'Active', 4, 6, 7),
('2024-03-29', 500000, 'Active', 5, 8, 9),
('2024-04-15', 1500000, 'Active', 7, 3, 12);


INSERT INTO BankEmployee (FirstName, LastName, MiddleName, Position)
VALUES
('Alexey', 'Smirnov', 'Vladimirovich', 'Credit Manager'),
('Olga', 'Kuznetsova', 'Sergeevna', 'Credit Analyst'),
('Dmitry', 'Petrov', 'Ivanovich', 'Branch Manager'),
('Irina', 'Sidorova', 'Alekseevna', 'Mortgage Specialist'),
('Elena', 'Vasilieva', 'Igorevna', 'Bank Teller'),
('Maxim', 'Ivanov', 'Nikolayevich', 'Loan Specialist'),
('Natalia', 'Petrova', 'Sergeevna', 'Credit Manager'),
('Yulia', 'Nikolaeva', 'Ivanovna', 'Branch Manager');


INSERT INTO StatusHistory (EntityID, EntityType, OldStatus, NewStatus, ChangeDate, EmployeeID)
VALUES

(1, 'LoanApplication', 'Submitted', 'Approved', '2024-01-20', 1),
(2, 'LoanApplication', 'Submitted', 'Rejected', '2024-03-06', 2),
(3, 'LoanApplication', 'Submitted', 'Approved', '2024-03-12', 1),
(4, 'LoanApplication', 'Submitted', 'Rejected', '2024-03-21', 3),
(5, 'LoanApplication', 'Submitted', 'Approved', '2024-03-23', 4),
(6, 'LoanApplication', 'Submitted', 'Approved', '2024-03-26', 5),
(7, 'LoanApplication', 'Submitted', 'Rejected', '2024-03-27', 6),
(8, 'LoanApplication', 'Submitted', 'Approved', '2024-03-28', 7),
(9, 'LoanApplication', 'Submitted', 'Rejected', '2024-03-31', 8),

(1, 'LoanContract', 'Inactive', 'Active', '2024-02-01', 1),
(2, 'LoanContract', 'Inactive', 'Active', '2024-03-01', 3),
(3, 'LoanContract', 'Inactive', 'Active', '2024-03-22', 4),
(4, 'LoanContract', 'Inactive', 'Active', '2024-03-25', 5),
(5, 'LoanContract', 'Inactive', 'Active', '2024-03-29', 6);


INSERT INTO EmployeeInApplication (ApplicationID, EmployeeID)
VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 3),
(5, 4),
(6, 5),
(7, 6),
(8, 7),
(9, 8);


INSERT INTO EmployeeInContract (ContractID, EmployeeID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 1);


