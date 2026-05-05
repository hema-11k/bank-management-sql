-- Bank Management System

CREATE DATABASE ICICI;
USE ICICI;

-- Bank Table
CREATE TABLE Bank(
    Bankid INT PRIMARY KEY,
    bankName VARCHAR(100),
    Branch VARCHAR(100),
    IFSC VARCHAR(15)
);

INSERT INTO Bank
VALUES(1,'ICICI','Vijay Nagar, Indore','SBIN0001234');

-- Customers Table
CREATE TABLE Customers(
    CustomerId INT PRIMARY KEY,
    Name VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(100)
);

INSERT INTO Customers VALUES
(1, "Amit" , "9698996988","Indore"),
(2, "Mohan" , "7895989898","Bhopal"),
(3, "Shyam" , "8798599988","Guna"),
(4, "Dinesh" , "7856985645","Indore");

-- Accounts Table
CREATE TABLE Accounts(
    Accountid INT PRIMARY KEY,
    CustomerId INT,
    Balance DECIMAL(10,2),
    AccountType VARCHAR(50),
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);

INSERT INTO Accounts VALUES
(101,1,5000,'Saving'),
(102,2,7000,'Saving'),
(103,3,3000,'Current'),
(104,4,2000,'Saving');

-- Transactions Table
CREATE TABLE Transactions(
    TransId INT AUTO_INCREMENT PRIMARY KEY,
    Accountid INT,
    Amount DECIMAL(10,2),
    TransType VARCHAR(50),
    TransDate DATETIME,
    FOREIGN KEY (Accountid) REFERENCES Accounts(Accountid)
);

-- Function to check balance
DELIMITER //
CREATE FUNCTION Checkbalance(acc_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE Bal DECIMAL(10,2);
    SELECT Balance INTO Bal
    FROM Accounts
    WHERE Accountid = acc_id;
    RETURN Bal;
END //
DELIMITER ;

-- Deposit Procedure
DELIMITER //
CREATE PROCEDURE Deposit(IN acc_id INT , IN Amt DECIMAL(10,2))
BEGIN
    UPDATE Accounts
    SET Balance = Balance + Amt
    WHERE Accountid = acc_id;

    INSERT INTO Transactions(Accountid , Amount, TransType , TransDate)
    VALUES (acc_id , Amt, 'Deposit', NOW());
END //
DELIMITER ;

-- Withdraw Procedure
DELIMITER //
CREATE PROCEDURE Withdraw(IN acc_id INT , IN Amt DECIMAL(10,2))
BEGIN
    DECLARE Bal DECIMAL(10,2);

    SELECT Balance INTO Bal
    FROM Accounts
    WHERE Accountid = acc_id;

    IF Bal >= Amt THEN
        UPDATE Accounts
        SET Balance = Balance - Amt
        WHERE Accountid = acc_id;

        INSERT INTO Transactions(Accountid , Amount, TransType , TransDate)
        VALUES (acc_id , Amt, 'Withdraw', NOW());
    ELSE
        SELECT 'Insufficient Balance' AS Msg;
    END IF;
END //
DELIMITER ;

-- TEST QUERIES

-- Check balance
SELECT Checkbalance(101);

-- View accounts
SELECT * FROM Accounts;

-- Total balance
SELECT SUM(Balance) AS Total_Balance FROM Accounts;

-- Total customers
SELECT COUNT(CustomerId) AS Total_Customers FROM Customers;

-- Join query
SELECT C.Name, A.Accountid, A.Balance, A.AccountType
FROM Customers C
JOIN Accounts A ON C.CustomerId = A.CustomerId
WHERE C.CustomerId = 2;

-- Call procedures
CALL Deposit(102, 65000.22);
CALL Withdraw(102, 60000);

-- View transactions
SELECT * FROM Transactions;