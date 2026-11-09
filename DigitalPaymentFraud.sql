#CREATING DATABASE
CREATE DATABASE DigitalPaymentFraud;
#======================================================================================================================================#
#SELECTING THE DATABASE
USE DigitalPaymentFraud;
#======================================================================================================================================#
#VERIFYING IF DATABASE CREATED
SELECT DATABASE();
#======================================================================================================================================#
#CREATING TABLES
#1
CREATE TABLE Banks (
    bank_id INT AUTO_INCREMENT PRIMARY KEY,
    bank_name VARCHAR(100) NOT NULL,
    ifsc_prefix VARCHAR(4),
    headquarters VARCHAR(100),
    bank_status VARCHAR(20)
);

#2
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    date_of_birth DATE,
    registration_date DATE,
    customer_status VARCHAR(20)
);


#3
CREATE TABLE Accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    bank_id INT NOT NULL,
    account_number VARCHAR(30) NOT NULL UNIQUE,
    account_type VARCHAR(20),
    balance DECIMAL(15,2),
    account_status VARCHAR(20),
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    FOREIGN KEY (bank_id)
        REFERENCES Banks(bank_id)
);


#4
CREATE TABLE Merchant_Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);


#5
CREATE TABLE Merchants (
    merchant_id INT AUTO_INCREMENT PRIMARY KEY,
    merchant_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    merchant_email VARCHAR(100),
    merchant_phone VARCHAR(15),
    merchant_status VARCHAR(20),
    FOREIGN KEY (category_id)
        REFERENCES Merchant_Categories(category_id)
);


#6
CREATE TABLE Devices (
    device_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    device_type VARCHAR(50),
    device_model VARCHAR(100),
    operating_system VARCHAR(50),
    device_fingerprint VARCHAR(255),
    registration_date DATE,
    device_status VARCHAR(20),
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);


#7
CREATE TABLE Payment_Methods (
    payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL,
    provider_name VARCHAR(100),
    payment_method_status VARCHAR(20)
);


#8
CREATE TABLE Locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50),
    postal_code VARCHAR(15),
    location VARCHAR(255)
);


#9
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    merchant_id INT NOT NULL,
    device_id INT,
    payment_method_id INT NOT NULL,
    location_id INT,
    transaction_amount DECIMAL(15,2) NOT NULL,
    transaction_date DATETIME,
    transaction_type VARCHAR(30),
    transaction_status VARCHAR(20),
    transaction_reference VARCHAR(100) UNIQUE,
    FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id),
    FOREIGN KEY (merchant_id)
        REFERENCES Merchants(merchant_id),
    FOREIGN KEY (device_id)
        REFERENCES Devices(device_id),
    FOREIGN KEY (payment_method_id)
        REFERENCES Payment_Methods(payment_method_id),
    FOREIGN KEY (location_id)
        REFERENCES Locations(location_id)
);


#10
CREATE TABLE Fraud_Rules (
    rule_id INT AUTO_INCREMENT PRIMARY KEY,
    rule_name VARCHAR(100) NOT NULL,
    rule_description VARCHAR(255),
    risk_level VARCHAR(20),
    threshold_amount DECIMAL(15,2),
    rule_status VARCHAR(20)
);


#11
CREATE TABLE Risk_Assessments (
    assessment_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    risk_score INT,
    risk_level VARCHAR(20),
    assessment_date DATETIME,
    assessment_result VARCHAR(50),
    remarks VARCHAR(255),
    FOREIGN KEY (transaction_id)
        REFERENCES Transactions(transaction_id)
);


#12
CREATE TABLE Fraud_Alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    rule_id INT NOT NULL,
    alert_date DATETIME,
    alert_level VARCHAR(20),
    alert_description VARCHAR(255),
    alert_status VARCHAR(20),
    FOREIGN KEY (transaction_id)
        REFERENCES Transactions(transaction_id),
    FOREIGN KEY (rule_id)
        REFERENCES Fraud_Rules(rule_id)
);


#13
CREATE TABLE Investigations (
    investigation_id INT AUTO_INCREMENT PRIMARY KEY,
    alert_id INT NOT NULL,
    investigator_name VARCHAR(100),
    investigation_date DATE,
    investigation_status VARCHAR(30),
    investigation_result VARCHAR(50),
    investigation_notes VARCHAR(255),
    FOREIGN KEY (alert_id)
        REFERENCES Fraud_Alerts(alert_id)
);


#14
CREATE TABLE Chargebacks (
    chargeback_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    chargeback_amount DECIMAL(15,2),
    chargeback_date DATE,
    chargeback_reason VARCHAR(255),
    chargeback_status VARCHAR(30),
    resolution_date DATE,
    FOREIGN KEY (transaction_id)
        REFERENCES Transactions(transaction_id)
);


#15
CREATE TABLE Login_Events (
    login_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    device_id INT,
    location_id INT,
    login_date DATETIME,
    login_status VARCHAR(20),
    ip_address VARCHAR(45),
    failure_reason VARCHAR(255),
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    FOREIGN KEY (device_id)
        REFERENCES Devices(device_id),
    FOREIGN KEY (location_id)
        REFERENCES Locations(location_id)
);
#======================================================================================================================================#

#VRIFYING THE TABLES
SHOW TABLES;

#======================================================================================================================================#
#INSRTING SAMPLE DATA INTO TABLES

#1
INSERT INTO Banks
(bank_name, ifsc_prefix, headquarters, bank_status)
VALUES
('State Bank of India', 'SBIN', 'Mumbai', 'ACTIVE'),
('HDFC Bank', 'HDFC', 'Mumbai', 'ACTIVE'),
('ICICI Bank', 'ICIC', 'Mumbai', 'ACTIVE'),
('Axis Bank', 'UTIB', 'Mumbai', 'ACTIVE'),
('Punjab National Bank', 'PUNB', 'New Delhi', 'ACTIVE'),
('Kotak Mahindra Bank', 'KKBK', 'Mumbai', 'ACTIVE'),
('Bank of Baroda', 'BARB', 'Vadodara', 'ACTIVE'),
('Canara Bank', 'CNRB', 'Bengaluru', 'ACTIVE');

#DISPLAYS ALL RECORDS IN BANKS TABLE
SELECT * FROM Banks;


#2
INSERT INTO Customers
(full_name, email, phone, date_of_birth, registration_date, customer_status)
VALUES
('Sampath', 'sampath@gmail.com', '9573198929', '2006-05-12', '2025-01-10', 'ACTIVE'),
('Joshna Priya', 'priya@gmail.com', '9876543211', '2002-08-20', '2025-01-15', 'ACTIVE'),
('Tanu', 'tanu@gmail.com', '9876543212', '2008-03-18', '2025-02-01', 'ACTIVE'),
('Rohit', 'rohit@gmail.com', '9876543213', '2000-11-25', '2025-02-05', 'ACTIVE'),
('Venu', 'venu@gmail.com', '9876543214', '1998-07-14', '2025-02-10', 'BLOCKED'),
('Bhanu', 'Bhanu@gmail.com', '9876543215', '2001-09-09', '2025-03-01', 'ACTIVE'),
('Vikram S', 'vikram@gmail.com', '9876543216', '1997-12-30', '2025-03-05', 'ACTIVE'),
('Gowtham', 'gowtham@gmail.com', '9876543217', '2002-02-14', '2025-03-12', 'INACTIVE'),
('Rohit Verma', 'verma@gmail.com', '9876543218', '1999-06-22', '2025-04-01', 'ACTIVE'),
('Iyer', 'iyer@gmail.com', '9876543219', '2000-04-17', '2025-04-10', 'ACTIVE');


#DISPLAYS ALL RECORDS IN CUSTOMERS TABLE
SELECT * FROM Customers;


#3
INSERT INTO Accounts
(customer_id, bank_id, account_number, account_type, balance, account_status)
VALUES
(1, 1, 'SBI100001', 'SAVINGS', 85000.00, 'ACTIVE'),
(2, 2, 'HDFC100002', 'SAVINGS', 125000.00, 'ACTIVE'),
(3, 3, 'ICICI100003', 'CURRENT', 45000.00, 'ACTIVE'),
(4, 4, 'AXIS100004', 'SAVINGS', 67000.00, 'ACTIVE'),
(5, 5, 'PNB100005', 'SAVINGS', 92000.00, 'BLOCKED'),
(6, 6, 'KOTAK100006', 'CURRENT', 150000.00, 'ACTIVE'),
(7, 7, 'BOB100007', 'SAVINGS', 38000.00, 'ACTIVE'),
(8, 8, 'CANARA100008', 'SAVINGS', 76000.00, 'ACTIVE'),
(9, 1, 'SBI100009', 'CURRENT', 210000.00, 'ACTIVE'),
(10, 2, 'HDFC100010', 'SAVINGS', 54000.00, 'INACTIVE');

#DISPLAS ALL RECORDS IN ACCOUNTS TABLE
SELECT * FROM Accounts;


#4
INSERT INTO Merchant_Categories
(category_name, description)
VALUES
('E-Commerce', 'Online shopping and retail purchases'),
('Food and Restaurants', 'Restaurants, cafes and food delivery'),
('Travel', 'Flight, train, bus and hotel bookings'),
('Healthcare', 'Hospitals, pharmacies and medical services'),
('Entertainment', 'Movies, games and entertainment services'),
('Education', 'Schools, colleges and online learning'),
('Utilities', 'Electricity, water and gas bill payments'),
('Fuel', 'Petrol pumps and fuel stations'),
('Telecommunications', 'Mobile and internet recharges'),
('Grocery', 'Supermarkets and grocery stores');

#DISPLAYS ALL RECORDS FROM  Merchant_Categories TABLE
SELECT * FROM Merchant_Categories;


#5
INSERT INTO Merchants
(merchant_name, category_id, merchant_email, merchant_phone, merchant_status)
VALUES
('Amazon India', 1, 'support@amazon.in', '9000000001', 'ACTIVE'),
('Swiggy', 2, 'support@swiggy.in', '9000000002', 'ACTIVE'),
('IRCTC', 3, 'support@irctc.co.in', '9000000003', 'ACTIVE'),
('Apollo Hospitals', 4, 'support@apollo.in', '9000000004', 'ACTIVE'),
('BookMyShow', 5, 'support@bookmyshow.com', '9000000005', 'ACTIVE'),
('Unacademy', 6, 'support@unacademy.com', '9000000006', 'ACTIVE'),
('APEPDCL', 7, 'support@apepdcl.in', '9000000007', 'ACTIVE'),
('Indian Oil', 8, 'support@indianoil.in', '9000000008', 'ACTIVE'),
('Airtel', 9, 'support@airtel.in', '9000000009', 'ACTIVE'),
('DMart', 10, 'support@dmart.in', '9000000010', 'ACTIVE');

#DISPLAYS ALL RECORDS IN MERCHANTS TABLE
SELECT * FROM MerchantS;


#6
INSERT INTO Devices
(customer_id, device_type, device_model, operating_system,
 device_fingerprint, registration_date, device_status)
VALUES
(1, 'Mobile', 'Samsung Galaxy A55', 'Android', 'DEV001A55', '2025-01-10', 'ACTIVE'),
(2, 'Mobile', 'iPhone 15', 'iOS', 'DEV002IP15', '2025-01-15', 'ACTIVE'),
(3, 'Laptop', 'Dell Inspiron', 'Windows 11', 'DEV003DELL', '2025-02-01', 'ACTIVE'),
(4, 'Mobile', 'OnePlus 12', 'Android', 'DEV004OP12', '2025-02-05', 'ACTIVE'),
(5, 'Mobile', 'Redmi Note 13', 'Android', 'DEV005REDMI', '2025-02-10', 'BLOCKED'),
(6, 'Laptop', 'HP Pavilion', 'Windows 11', 'DEV006HP', '2025-03-01', 'ACTIVE'),
(7, 'Mobile', 'Vivo V30', 'Android', 'DEV007VIVO', '2025-03-05', 'ACTIVE'),
(8, 'Tablet', 'iPad Air', 'iPadOS', 'DEV008IPAD', '2025-03-12', 'ACTIVE'),
(9, 'Mobile', 'Google Pixel 8', 'Android', 'DEV009PIXEL', '2025-04-01', 'ACTIVE'),
(10, 'Laptop', 'Lenovo ThinkPad', 'Windows 11', 'DEV010LEN', '2025-04-10', 'INACTIVE');


#7
INSERT INTO Payment_Methods
(method_name, provider_name, payment_method_status)
VALUES
('UPI', 'Google Pay', 'ACTIVE'),
('UPI', 'PhonePe', 'ACTIVE'),
('UPI', 'Paytm', 'ACTIVE'),
('Debit Card', 'Visa', 'ACTIVE'),
('Debit Card', 'Mastercard', 'ACTIVE'),
('Credit Card', 'Visa', 'ACTIVE'),
('Credit Card', 'RuPay', 'ACTIVE'),
('Net Banking', 'SBI Net Banking', 'ACTIVE'),
('Net Banking', 'HDFC Net Banking', 'ACTIVE'),
('Mobile Wallet', 'Amazon Pay', 'ACTIVE');


#8
INSERT INTO Locations
(country, state, city, postal_code, location)
VALUES
('India', 'Andhra Pradesh', 'Visakhapatnam', '530001', 'MVP Colony, Visakhapatnam'),
('India', 'Andhra Pradesh', 'Vijayawada', '520001', 'Benz Circle, Vijayawada'),
('India', 'Telangana', 'Hyderabad', '500001', 'Hitech City, Hyderabad'),
('India', 'Karnataka', 'Bengaluru', '560001', 'Whitefield, Bengaluru'),
('India', 'Maharashtra', 'Mumbai', '400001', 'Andheri, Mumbai'),
('India', 'Tamil Nadu', 'Chennai', '600001', 'T Nagar, Chennai'),
('India', 'Delhi', 'New Delhi', '110001', 'Connaught Place, New Delhi'),
('India', 'Kerala', 'Kochi', '682001', 'MG Road, Kochi'),
('India', 'West Bengal', 'Kolkata', '700001', 'Salt Lake, Kolkata'),
('India', 'Rajasthan', 'Jaipur', '302001', 'Malviya Nagar, Jaipur');


#9
INSERT INTO Transactions
(account_id, merchant_id, device_id, payment_method_id,
 location_id, transaction_amount, transaction_date,
 transaction_type, transaction_status, transaction_reference)
VALUES
(1, 1, 1, 1, 1, 1500.00, '2025-06-01 10:15:00', 'DEBIT', 'SUCCESS', 'TXN100001'),
(2, 2, 2, 2, 2, 2500.00, '2025-06-01 11:30:00', 'DEBIT', 'SUCCESS', 'TXN100002'),
(3, 3, 3, 3, 3, 75000.00, '2025-06-02 14:20:00', 'DEBIT', 'SUCCESS', 'TXN100003'),
(4, 4, 4, 4, 4, 12000.00, '2025-06-02 16:45:00', 'DEBIT', 'SUCCESS', 'TXN100004'),
(5, 5, 5, 5, 5, 95000.00, '2025-06-03 02:10:00', 'DEBIT', 'SUCCESS', 'TXN100005'),
(6, 6, 6, 6, 6, 800.00, '2025-06-03 09:00:00', 'DEBIT', 'FAILED', 'TXN100006'),
(7, 7, 7, 7, 7, 45000.00, '2025-06-04 13:15:00', 'DEBIT', 'SUCCESS', 'TXN100007'),
(8, 8, 8, 8, 8, 3000.00, '2025-06-04 18:30:00', 'DEBIT', 'SUCCESS', 'TXN100008'),
(9, 9, 9, 9, 9, 150000.00, '2025-06-05 01:25:00', 'DEBIT', 'SUCCESS', 'TXN100009'),
(10, 10, 10, 10, 10, 500.00, '2025-06-05 12:00:00', 'DEBIT', 'PENDING', 'TXN100010');


#10
INSERT INTO Fraud_Rules
(rule_name, rule_description, risk_level, threshold_amount, rule_status)
VALUES
('High Value Transaction', 'Transaction amount exceeds normal spending limit', 'HIGH', 50000.00, 'ACTIVE'),
('Late Night Transaction', 'Transaction performed between 12 AM and 5 AM', 'MEDIUM', 0.00, 'ACTIVE'),
('Multiple Transactions', 'Multiple transactions within a short time', 'HIGH', 10000.00, 'ACTIVE'),
('Unusual Location', 'Transaction from an unusual geographical location', 'HIGH', 0.00, 'ACTIVE'),
('Blocked Account Usage', 'Transaction attempted using a blocked account', 'CRITICAL', 0.00, 'ACTIVE'),
('Suspicious Merchant', 'Transaction involving a flagged merchant', 'HIGH', 0.00, 'ACTIVE'),
('Large International Payment', 'Unusually large international transaction', 'CRITICAL', 100000.00, 'ACTIVE'),
('Repeated Failed Payments', 'Multiple failed payment attempts', 'MEDIUM', 0.00, 'ACTIVE'),
('Unregistered Device', 'Transaction from an unregistered device', 'HIGH', 0.00, 'ACTIVE'),
('Unusual Spending Pattern', 'Transaction differs significantly from customer spending history', 'MEDIUM', 25000.00, 'ACTIVE');


#11
INSERT INTO Risk_Assessments
(transaction_id, risk_score, risk_level, assessment_date,
 assessment_result, remarks)
VALUES
(1, 10, 'LOW', '2025-06-01 10:16:00', 'SAFE', 'Normal transaction pattern'),
(2, 15, 'LOW', '2025-06-01 11:31:00', 'SAFE', 'Regular UPI transaction'),
(3, 75, 'HIGH', '2025-06-02 14:21:00', 'SUSPICIOUS', 'High transaction amount'),
(4, 25, 'LOW', '2025-06-02 16:46:00', 'SAFE', 'Transaction within normal limits'),
(5, 90, 'CRITICAL', '2025-06-03 02:11:00', 'SUSPICIOUS', 'High-value late-night transaction'),
(6, 40, 'MEDIUM', '2025-06-03 09:01:00', 'SUSPICIOUS', 'Failed payment attempt'),
(7, 60, 'HIGH', '2025-06-04 13:16:00', 'SUSPICIOUS', 'Unusual transaction amount'),
(8, 12, 'LOW', '2025-06-04 18:31:00', 'SAFE', 'Normal transaction activity'),
(9, 95, 'CRITICAL', '2025-06-05 01:26:00', 'SUSPICIOUS', 'Very high transaction during unusual hours'),
(10, 20, 'LOW', '2025-06-05 12:01:00', 'SAFE', 'Low-value pending transaction');


#12
INSERT INTO Fraud_Alerts
(transaction_id, rule_id, alert_date, alert_level,
 alert_description, alert_status)
VALUES
(1, 1, '2025-06-01 10:16:00', 'LOW', 'Transaction flagged for routine monitoring', 'CLOSED'),
(2, 2, '2025-06-01 11:31:00', 'LOW', 'UPI transaction monitored', 'CLOSED'),
(3, 1, '2025-06-02 14:21:00', 'HIGH', 'Transaction exceeded high-value threshold', 'OPEN'),
(4, 3, '2025-06-02 16:46:00', 'LOW', 'Transaction monitored for spending frequency', 'CLOSED'),
(5, 2, '2025-06-03 02:11:00', 'CRITICAL', 'High-value transaction during late-night hours', 'OPEN'),
(6, 8, '2025-06-03 09:01:00', 'MEDIUM', 'Failed payment attempt detected', 'REVIEWED'),
(7, 10, '2025-06-04 13:16:00', 'HIGH', 'Unusual spending pattern detected', 'OPEN'),
(8, 4, '2025-06-04 18:31:00', 'LOW', 'Location activity monitored', 'CLOSED'),
(9, 1, '2025-06-05 01:26:00', 'CRITICAL', 'Very high-value transaction detected', 'OPEN'),
(10, 8, '2025-06-05 12:01:00', 'MEDIUM', 'Payment status requires monitoring', 'REVIEWED');


#13
INSERT INTO Investigations
(alert_id, investigator_name, investigation_date,
 investigation_status, investigation_result, investigation_notes)
VALUES
(1, 'Amit Kumar', '2025-06-01', 'COMPLETED', 'LEGITIMATE', 'Normal customer transaction'),
(2, 'Priya Sharma', '2025-06-01', 'COMPLETED', 'LEGITIMATE', 'Regular UPI activity'),
(3, 'Rahul Verma', '2025-06-02', 'IN_PROGRESS', 'INCONCLUSIVE', 'High transaction amount requires verification'),
(4, 'Amit Kumar', '2025-06-02', 'COMPLETED', 'LEGITIMATE', 'No suspicious activity found'),
(5, 'Neha Singh', '2025-06-03', 'IN_PROGRESS', 'INCONCLUSIVE', 'Late-night high-value transaction under review'),
(6, 'Priya Sharma', '2025-06-03', 'COMPLETED', 'LEGITIMATE', 'Payment failed due to technical issue'),
(7, 'Rahul Verma', '2025-06-04', 'PENDING', 'INCONCLUSIVE', 'Unusual spending pattern needs review'),
(8, 'Amit Kumar', '2025-06-04', 'COMPLETED', 'LEGITIMATE', 'Location verified'),
(9, 'Neha Singh', '2025-06-05', 'IN_PROGRESS', 'INCONCLUSIVE', 'Very high-value transaction requires customer confirmation'),
(10, 'Priya Sharma', '2025-06-05', 'COMPLETED', 'LEGITIMATE', 'Pending payment was not fraudulent');


#14
INSERT INTO Chargebacks
(transaction_id, chargeback_amount, chargeback_date,
 chargeback_reason, chargeback_status, resolution_date)
VALUES
(1, 1500.00, '2025-06-02', 'Unauthorized transaction', 'APPROVED', '2025-06-05'),
(2, 2500.00, '2025-06-03', 'Duplicate payment', 'REJECTED', '2025-06-06'),
(3, 75000.00, '2025-06-04', 'Suspicious high-value transaction', 'PENDING', NULL),
(4, 12000.00, '2025-06-05', 'Service not received', 'APPROVED', '2025-06-10'),
(5, 95000.00, '2025-06-06', 'Unauthorized late-night payment', 'PENDING', NULL),
(6, 800.00, '2025-06-07', 'Incorrect payment deduction', 'REJECTED', '2025-06-09'),
(7, 45000.00, '2025-06-08', 'Fraudulent transaction reported', 'APPROVED', '2025-06-12'),
(8, 3000.00, '2025-06-09', 'Product not delivered', 'PENDING', NULL),
(9, 150000.00, '2025-06-10', 'Unauthorized high-value payment', 'PENDING', NULL),
(10, 500.00, '2025-06-11', 'Incorrect transaction amount', 'REJECTED', '2025-06-13');


#15
INSERT INTO Login_Events
(customer_id, device_id, location_id, login_date,
 login_status, ip_address, failure_reason)
VALUES
(1, 1, 1, '2025-06-01 09:00:00', 'SUCCESS', '192.168.1.10', NULL),
(2, 2, 2, '2025-06-01 09:15:00', 'SUCCESS', '192.168.1.11', NULL),
(3, 3, 3, '2025-06-02 10:30:00', 'SUCCESS', '192.168.1.12', NULL),
(4, 4, 4, '2025-06-02 11:45:00', 'FAILED', '192.168.1.13', 'Incorrect password'),
(5, 5, 5, '2025-06-03 02:00:00', 'FAILED', '192.168.1.14', 'Multiple incorrect password attempts'),
(6, 6, 6, '2025-06-03 08:30:00', 'SUCCESS', '192.168.1.15', NULL),
(7, 7, 7, '2025-06-04 12:00:00', 'SUCCESS', '192.168.1.16', NULL),
(8, 8, 8, '2025-06-04 17:30:00', 'FAILED', '192.168.1.17', 'Unrecognized device'),
(9, 9, 9, '2025-06-05 01:15:00', 'SUCCESS', '192.168.1.18', NULL),
(10, 10, 10, '2025-06-05 11:00:00', 'SUCCESS', '192.168.1.19', NULL);

#======================================================================================================================================#
#SAMPLE COMMANDS

# Display all customers
SELECT * FROM Customers;
#======================================================================================================================================#

# Display all banks
SELECT * FROM Banks;

#======================================================================================================================================#

# Display only active customers
SELECT * FROM Customers
WHERE customer_status = 'ACTIVE';

#======================================================================================================================================#


# Display blocked customers
SELECT * FROM Customers
WHERE customer_status = 'BLOCKED';

#======================================================================================================================================#

# Display transactions above ₹50,000
SELECT * FROM Transactions
WHERE transaction_amount > 50000;

#======================================================================================================================================#


# Display failed transactions
SELECT * FROM Transactions
WHERE transaction_status = 'FAILED';

#======================================================================================================================================#

# Display transactions in descending order of amount
SELECT * FROM Transactions
ORDER BY transaction_amount DESC;

#======================================================================================================================================#

# Display all unique payment methods
SELECT DISTINCT method_name FROM Payment_Methods;

#======================================================================================================================================#

# Count the total number of customers
SELECT COUNT(*) AS total_customers
FROM Customers;

#======================================================================================================================================#

# Find the highest transaction amount
SELECT MAX(transaction_amount) AS highest_transaction
FROM Transactions;

#======================================================================================================================================#

# Calculate the running total of transactions
SELECT transaction_id, account_id, transaction_amount,
       SUM(transaction_amount) OVER (
           PARTITION BY account_id
           ORDER BY transaction_date
       ) AS running_total
FROM Transactions;

#======================================================================================================================================#

# Classify transactions based on risk scores
SELECT transaction_id, risk_score,
       CASE
           WHEN risk_score >= 80 THEN 'CRITICAL RISK'
           WHEN risk_score >= 60 THEN 'HIGH RISK'
           WHEN risk_score >= 30 THEN 'MEDIUM RISK'
           ELSE 'LOW RISK'
       END AS risk_category
FROM Risk_Assessments;

#======================================================================================================================================#

# Find customers whose average transaction amount is greater than the overall average
SELECT c.customer_id, c.full_name,
       AVG(t.transaction_amount) AS average_amount
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.full_name
HAVING AVG(t.transaction_amount) >
       (SELECT AVG(transaction_amount) FROM Transactions);

#======================================================================================================================================#

# Find customers who have failed login attempts
SELECT c.customer_id, c.full_name
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Login_Events l
    WHERE l.customer_id = c.customer_id
      AND l.login_status = 'FAILED'
);

#======================================================================================================================================#

# Display transactions above ₹50,000 
WITH HighValueTransactions AS (
    SELECT *
    FROM Transactions
    WHERE transaction_amount > 50000
)
SELECT * FROM HighValueTransactions;

#======================================================================================================================================#

# Calculate monthly transaction volume
SELECT YEAR(transaction_date) AS transaction_year,
       MONTH(transaction_date) AS transaction_month,
       COUNT(*) AS total_transactions,
       SUM(transaction_amount) AS total_amount
FROM Transactions
GROUP BY YEAR(transaction_date), MONTH(transaction_date);

#======================================================================================================================================#

# Find accounts with multiple transactions on the same day
SELECT account_id, DATE(transaction_date) AS transaction_day,
       COUNT(*) AS total_transactions
FROM Transactions
GROUP BY account_id, DATE(transaction_date)
HAVING COUNT(*) > 1;

#======================================================================================================================================#

# Identify transactions exceeding fraud rule limits
SELECT t.transaction_id, t.transaction_amount,
       f.rule_name, f.threshold_amount
FROM Transactions t
JOIN Fraud_Rules f
ON t.transaction_amount > f.threshold_amount
WHERE f.threshold_amount > 0;

#======================================================================================================================================#

# Display transactions between ₹10,000 and ₹1,00,000
SELECT * FROM Transactions
WHERE transaction_amount BETWEEN 10000 AND 100000;

#======================================================================================================================================#

# Display customers whose names start with S
SELECT * FROM Customers
WHERE full_name LIKE 'S%';

#======================================================================================================================================#

# Find the total number of transactions made by each account
SELECT account_id, COUNT(*) AS total_transactions
FROM Transactions
GROUP BY account_id;

#======================================================================================================================================#

# Display accounts having a balance greater than ₹50,000
SELECT * FROM Accounts
WHERE balance > 50000;

#======================================================================================================================================#

# Find customers who have more than one account
SELECT customer_id, COUNT(*) AS total_accounts
FROM Accounts
GROUP BY customer_id
HAVING COUNT(*) > 1;

#======================================================================================================================================#

# Display the second-highest transaction amount
SELECT MAX(transaction_amount) AS second_highest_amount
FROM Transactions
WHERE transaction_amount < (
    SELECT MAX(transaction_amount)
    FROM Transactions
);

#======================================================================================================================================#

# Display transactions with their customer names and merchant names
SELECT c.full_name, m.merchant_name, t.transaction_amount
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id
JOIN Merchants m ON t.merchant_id = m.merchant_id;

#======================================================================================================================================#

# Find the total amount of successful transactions
SELECT SUM(transaction_amount) AS successful_amount
FROM Transactions
WHERE transaction_status = 'SUCCESS';

#======================================================================================================================================#

# Display fraud alerts that are still open
SELECT * FROM Fraud_Alerts
WHERE alert_status = 'OPEN';

#======================================================================================================================================#

# Find the number of fraud alerts for each alert level
SELECT alert_level, COUNT(*) AS total_alerts
FROM Fraud_Alerts
GROUP BY alert_level;

#======================================================================================================================================#
# Find customers who made transactions above ₹50,000
SELECT c.full_name, t.transaction_amount
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
WHERE t.transaction_amount > 50000;

#======================================================================================================================================#

# Display customers who have more than one transaction
SELECT c.full_name, COUNT(t.transaction_id) AS total_transactions
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(t.transaction_id) > 1;

#======================================================================================================================================#

# Find merchants with an average transaction amount above ₹10,000
SELECT m.merchant_name, AVG(t.transaction_amount) AS average_amount
FROM Merchants m
JOIN Transactions t ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_id, m.merchant_name
HAVING AVG(t.transaction_amount) > 10000;

#======================================================================================================================================#

# Display customers whose account balance is greater than ₹50,000
SELECT c.full_name, a.account_number, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.balance > 50000
ORDER BY a.balance DESC;

#======================================================================================================================================#

# Find transactions that have a high or critical risk level
SELECT t.transaction_id, t.transaction_amount,
       r.risk_score, r.risk_level
FROM Transactions t
JOIN Risk_Assessments r ON t.transaction_id = r.transaction_id
WHERE r.risk_level IN ('HIGH', 'CRITICAL');

#======================================================================================================================================#

# Display the total transaction amount for each payment method
SELECT p.method_name, SUM(t.transaction_amount) AS total_amount
FROM Payment_Methods p
JOIN Transactions t
ON p.payment_method_id = t.payment_method_id
GROUP BY p.payment_method_id, p.method_name
ORDER BY total_amount DESC;

#======================================================================================================================================#

# Find customers who have at least one failed transaction
SELECT DISTINCT c.full_name
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'FAILED';

#======================================================================================================================================#

# Display fraud alerts along with investigator details
SELECT f.alert_id, f.alert_level,
       i.investigator_name, i.investigation_status
FROM Fraud_Alerts f
JOIN Investigations i ON f.alert_id = i.alert_id;

#======================================================================================================================================#

# Find transactions with an amount greater than the average transaction amount
SELECT transaction_id, transaction_amount
FROM Transactions
WHERE transaction_amount > (
    SELECT AVG(transaction_amount)
    FROM Transactions
);

#======================================================================================================================================#
# Display the total number of fraud alerts for each customer
SELECT c.full_name, COUNT(f.alert_id) AS total_alerts
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
JOIN Fraud_Alerts f ON t.transaction_id = f.transaction_id
GROUP BY c.customer_id, c.full_name;