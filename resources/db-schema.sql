CREATE TABLE IF NOT EXISTS Account_Type(
	account_type_id INT PRIMARY KEY,
	account_name VARCHAR(100),
	interest_rate FLOAT(100,2)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS Utility_Provider(
	utility_provider_id INT PRIMARY KEY,
	utlity_provider_name VARCHAR(100)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS Currency(
	currency_id INT PRIMARY KEY,
	currency_name VARCHAR(100)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS Customer_Info(
	user_id INT PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	national_id VARCHAR(10),
	birth_date DATE,
	email VARCHAR(100),
	address VARCHAR(100)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS Account(
	acc_number INT PRIMARY KEY,
	created_date DATE,
	current_balance FLOAT(100,2),
	user_id INT,
	account_type_id INT,
	currency_id INT,
	FOREIGN KEY (user_id) REFERENCES Customer_Info(user_id) ON DELETE CASCADE,
	FOREIGN KEY (account_type_id) REFERENCES Account_Type(account_type_id) ON DELETE CASCADE,
	FOREIGN KEY (currency_id) REFERENCES Currency(currency_id) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS Pay_Orders(
	pay_order_id INT PRIMARY KEY,
	transaction_amount FLOAT(100,2),
	transaction_date TIMESTAMP,
	acc_number INT,
	to_acc_number INT,
	FOREIGN KEY (acc_number) REFERENCES Account(acc_number) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS Transaction(
	transaction_id INT PRIMARY KEY,
	transaction_amount FLOAT(100,2),
	transaction_date TIMESTAMP,
	utility_provider_id INT,
	pay_order_id INT,
	acc_number INT,
	currency_id INT,
	FOREIGN KEY (currency_id) REFERENCES Currency(currency_id) ON DELETE CASCADE
)ENGINE INNODB;
