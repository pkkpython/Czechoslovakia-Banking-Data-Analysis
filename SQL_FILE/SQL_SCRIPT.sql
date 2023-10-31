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

CREATE OR REPLACE STORAGE integration s3_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN ='arn:aws:iam::010397652565:role/Bankrole'
STORAGE_ALLOWED_LOCATIONS =('s3://czechoslovakia.bank/');  



DESC INTEGRATION s3_int;


CREATE OR REPLACE STAGE BANK
URL ='s3://czechoslovakia.bank/'
file_format = BANK_CSV
storage_integration = s3_int;


LIST @BANK;


SHOW STAGES;


--CREATE SNOWPIPE THAT RECOGNISES CSV THAT ARE INGESTED FROM EXTERNAL STAGE AND COPIES THE DATA INTO EXISTING TABLE

--The AUTO_INGEST=true parameter specifies to read 
--- event notifications sent from an S3 bucket to an SQS queue when new data is ready to load.


CREATE OR REPLACE PIPE BANK_SNOWPIPE_DISTRICT AUTO_INGEST = TRUE AS
COPY INTO "BANK"."BANKING"."DISTRICT" --yourdatabase -- your schema ---your table
FROM '@bank/District/' --your database name s3 bucket subfolde4r name
FILE_FORMAT = BANK_CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_ACCOUNT AUTO_INGEST = TRUE AS
COPY INTO "BANK"."BANKING"."ACCOUNT" --yourdatabase -- your schema ---your table
FROM '@bank/Account/' --your database name s3 bucket subfolde4r name
FILE_FORMAT = BANK_CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_CARD AUTO_INGEST = TRUE AS
COPY INTO "BANK"."BANKING"."CARD" --yourdatabase -- your schema ---your table
FROM '@bank/Card/' --your database name s3 bucket subfolde4r name
FILE_FORMAT = BANK_CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_CLIENT AUTO_INGEST = TRUE AS
COPY INTO "BANK"."BANKING"."CLIENT" --yourdatabase -- your schema ---your table
FROM '@bank/Client/' --your database name s3 bucket subfolde4r name
FILE_FORMAT = BANK_CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_DISPOSITION AUTO_INGEST = TRUE AS
COPY INTO "BANK"."BANKING"."DISPOSITION" --yourdatabase -- your schema ---your table
FROM '@bank/disp/' --your database name s3 bucket subfolde4r name
FILE_FORMAT = BANK_CSV;


CREATE OR REPLACE PIPE BANK_SNOWPIPE_LOAN AUTO_INGEST = TRUE AS
COPY INTO "BANK"."BANKING"."LOAN" --yourdatabase -- your schema ---your table
FROM '@bank/Loan/' --your database name s3 bucket subfolde4r name
FILE_FORMAT = BANK_CSV;


CREATE OR REPLACE PIPE BANK_SNOWPIPE_ORDER_LIST AUTO_INGEST = TRUE AS
COPY INTO "BANK"."BANKING"."ORDER_LIST" --yourdatabase -- your schema ---your table
FROM '@bank/Order/' --your database name s3 bucket subfolde4r name
FILE_FORMAT = BANK_CSV;


CREATE OR REPLACE PIPE BANK_SNOWPIPE_TRANSACTIONS AUTO_INGEST = TRUE AS
COPY INTO "BANK"."BANKING"."TRANSACTIONS" --yourdatabase -- your schema ---your table
FROM '@bank/Trnx/' --your database name s3 bucket subfolde4r name
FILE_FORMAT = BANK_CSV;



SHOW PIPES;

ALTER PIPE BANK_SNOWPIPE_DISTRICT REFRESH;

ALTER PIPE BANK_SNOWPIPE_DISPOSITION REFRESH;

ALTER PIPE BANK_SNOWPIPE_ACCOUNT REFRESH;

ALTER PIPE BANK_SNOWPIPE_CARD REFRESH;

ALTER PIPE BANK_SNOWPIPE_ORDER_LIST REFRESH;

ALTER PIPE BANK_SNOWPIPE_CLIENT REFRESH;

ALTER PIPE BANK_SNOWPIPE_LOAN REFRESH;

ALTER PIPE BANK_SNOWPIPE_TRANSACTIONS REFRESH;


SELECT count(*) from DISTRICT;

SELECT count(*) from TRANSACTIONS;

SELECT count(*) from ORDER_LIST;

SELECT count(*) from ACCOUNT;

SELECT count(*) FROM DISPOSITION;

SELECT count(*) FROM CARD;

SELECT count(*) FROM LOAN;

SELECT count(*) FROM CLIENT;

-- CHECKING DATA IN TABLES 

SELECT * FROM DISTRICT;
SELECT * FROM ACCOUNT;
SELECT * FROM TRANSACTIONS limit 100;
SELECT * FROM DISPOSITION;
SELECT * FROM CARD;
SELECT * FROM ORDER_LIST;
SELECT * FROM LOAN;
SELECT * FROM CLIENT;




SHOW TABLES;

select * from account;

select * from card limit 100;


select distinct year(issued) from card;

select type, count(*) from card
group by type;

select , count(*) from card
group by type;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT CLIENT_ID, MAX(DATE) - BIRTH_DATE as age
FROM client c
LEFT JOIN account a
c.ACCOUNT_ID = a.account_id
LEFT JOIN TRANSACTIONS t
ON ;


desc table client;

desc table TRANSACTIONS;

desc table ACCOUNT;


SELECT YEAR(DATE), COUNT(TRANS_ID)
FROM TRANSACTIONS
WHERE BANK IS NULL
GROUP BY 1
ORDER BY 1;