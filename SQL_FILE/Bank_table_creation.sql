-- CREATE DATABASE BANK
CREATE DATABASE bank;

-- CREATE SCHEMA BANKING 
CREATE SCHEMA banking;

-- USING DATABASE SCHEMA
USE bank;
use schema banking;

-- CREATING TABLE DISTRICT 

CREATE OR REPLACE TABLE DISTRICT(
District_Code INT PRIMARY KEY,
District_Name VARCHAR(100)	,
Region VARCHAR(100),
No_of_inhabitants	INT,
No_of_municipalities_with_inhabitants_less_499 INT,
No_of_municipalities_with_inhabitants_500_btw_1999	INT,
No_of_municipalities_with_inhabitants_2000_btw_9999	INT,
No_of_municipalities_with_inhabitants_less_10000 INT,	
No_of_cities	INT,
Ratio_of_urban_inhabitants	FLOAT,
Average_salary	INT,
No_of_entrepreneurs_per_1000_inhabitants INT,
No_committed_crime_2017	INT,
No_committed_crime_2018 INT
);


-- CREATING TABLE ACCOUNT

CREATE OR REPLACE TABLE ACCOUNT
(
account_id INT PRIMARY KEY,	
district_id	INT,
frequency VARCHAR(50),	
Date DATE,	
Account_type VARCHAR(50),
Card_assigned VARCHAR(50),
FOREIGN KEY (district_id) references DISTRICT(District_Code) 
);

-- -- CREATING TABLE CARD

CREATE OR REPLACE TABLE CARD 
(
card_id INT PRIMARY KEY,
dis_id INT,
type CHAR(10),
issued DATE
);

-- -- CREATING TABLE CLIENT

CREATE OR REPLACE TABLE CLIENT
(
client_id INT PRIMARY KEY,	
Sex CHAR(10),
birth_date DATE, 
district_id	INT, 
FOREIGN KEY (district_id) references DISTRICT(District_Code)
);

-- CREATING TABLE DISPOSITION TABLE

CREATE OR REPLACE TABLE DISPOSITION
(
disp_id	INT PRIMARY KEY,
client_id INT,
account_id	INT,
`type` CHAR(15),
FOREIGN KEY (account_id) references ACCOUNT(account_id),
FOREIGN KEY (client_id) references CLIENT(client_id)
);


-- CREATING TABLE LOAN

CREATE OR REPLACE TABLE LOAN(
loan_id	INT,
account_id	INT,
`Date`	DATE,
amount	INT,
duration	INT,
payments	INT,
`status` VARCHAR(35),
FOREIGN KEY (account_id) references ACCOUNT(account_id)
);

-- CREATING TABLE ORDER_LIST

CREATE OR REPLACE TABLE ORDER_LIST(
order_id	INT PRIMARY KEY,
account_id	INT,
bank_to	VARCHAR(45),
account_to	INT,
amount FLOAT,
FOREIGN KEY (account_id) references ACCOUNT(account_id)
);


-- CREATING TABLE TRANSLATIONS

CREATE OR REPLACE TABLE TRANSACTIONS(
trans_id INT,	
account_id	INT,
Date	DATE,
Type	VARCHAR(30),
operation	VARCHAR(40),
amount	INT,
balance	FLOAT,
Purpose	VARCHAR(40),
bank	VARCHAR(45),
account_partner_id INT,
FOREIGN KEY (account_id) references ACCOUNT(account_id));


SHOW TABLES;
-- -----------------------------------------------------------------------------------------------------------

