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
	acc_number INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	created_date DATE,
	current_balance FLOAT(100,2),
	user_id INT,
	account_type_id INT,
	currency_id INT,
	account_status INT,
	FOREIGN KEY (currency_id) REFERENCES Currency(currency_id) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS Pay_Orders(
	pay_order_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	transaction_amount FLOAT(100,2),
	transaction_date INT,
	acc_number INT,
	to_acc_number INT,
	frequency INT,
	FOREIGN KEY (acc_number) REFERENCES Account(acc_number) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS Transactions(
	transaction_id INT PRIMARY KEY,
	transaction_amount FLOAT(100,2),
	transaction_date TIMESTAMP,
	utility_provider_id INT,
	pay_order_id INT,
	acc_number INT NOT NULL,
	currency_id INT,
	FOREIGN KEY (currency_id) REFERENCES Currency(currency_id) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS OTP_Info(
    id INT NOT NULL AUTO_INCREMENT,
    otp_id VARCHAR(100),
    created_date TIMESTAMP,
    user_id INT,
    PRIMARY KEY(id),
    FOREIGN KEY (user_id) REFERENCES Customer_Info(user_id) ON DELETE CASCADE
)


INSERT INTO `Bank`.`Account_Type` (`account_type_id`, `account_name`, `interest_rate`) VALUES ('1', 'Hapan', '5');
INSERT INTO `Bank`.`Account_Type` (`account_type_id`, `account_name`, `interest_rate`) VALUES ('2', 'Ithuru Mithuru', '4.5');

INSERT INTO `Bank`.`Currency` (`currency_id`, `currency_name`) VALUES ('1', 'LKR');
INSERT INTO `Bank`.`Currency` (`currency_id`, `currency_name`) VALUES ('2', 'USD');
INSERT INTO `Bank`.`Currency` (`currency_id`, `currency_name`) VALUES ('3', 'AUD');
INSERT INTO `Bank`.`Currency` (`currency_id`, `currency_name`) VALUES ('4', 'CAD');
INSERT INTO `Bank`.`Currency` (`currency_id`, `currency_name`) VALUES ('5', 'INR');

INSERT INTO `Bank`.`Account` (`acc_number`, `created_date`, `current_balance`, `user_id`, `account_type_id`, `currency_id`, `account_status`) VALUES ('0114565456', '2005/11/02', '129000.89', '01034567890', '1', '1', '1');
INSERT INTO `Bank`.`Account` (`acc_number`, `created_date`, `current_balance`, `user_id`, `account_type_id`, `currency_id`, `account_status`) VALUES ('0114565457', '2010/04/03', '350344.78', '01067544678', '2', '1', '1');
INSERT INTO `Bank`.`Account` (`acc_number`, `created_date`, `current_balance`, `user_id`, `account_type_id`, `currency_id`, `account_status`) VALUES ('0114565458', '2016/09/23', '234888.67', '01076699776', '1', '2', '1');
INSERT INTO `Bank`.`Account` (`acc_number`, `created_date`, `current_balance`, `user_id`, `account_type_id`, `currency_id`, `account_status`) VALUES ('0114565459', '2014/03/13', '238999.34', '01067544678', '1', '1', '1');

INSERT INTO `Bank`.`Customer_Info` (`user_id`, `first_name`, `last_name`, `national_id`, `birth_date`, `email`, `address`) VALUES ('01067544678', 'Dilini', 'Gunatilake', '897645244V', '1989/05/01', 'dilinisg@gmai.com', '15C, Rathmalana');
INSERT INTO `Bank`.`Customer_Info` (`user_id`, `first_name`, `last_name`, `national_id`, `birth_date`, `email`, `address`) VALUES ('01034567890', 'Chathurika', 'De Silva', '867865344V', '1986/07/23', 'chathurika@gmail.com', 'No.12,Maradana');
INSERT INTO `Bank`.`Customer_Info` (`user_id`, `first_name`, `last_name`, `national_id`, `birth_date`, `email`, `address`) VALUES ('01076699776', 'Yasassri', 'Rathnayake', '897637266V', '1989/05/31', 'yasassri@gmai.com', 'No.67/23, Kottawa');

INSERT INTO `Bank`.`OTP_Info` (`id`, `otp_id`, `created_date`, `user_id`) VALUES ('1', '6789', '2017/11/01', '01067544678');
INSERT INTO `Bank`.`OTP_Info` (`id`, `otp_id`, `created_date`, `user_id`) VALUES ('2', '3456', '2017/11/10', '01034567890');
INSERT INTO `Bank`.`OTP_Info` (`id`, `otp_id`, `created_date`, `user_id`) VALUES ('3', '4532', '2017/11/03', '01076699776');

INSERT INTO `Bank`.`Pay_Orders` (`transaction_amount`, `transaction_date`, `acc_number`, `to_acc_number`, `frequency`) VALUES (1000.00, 29, 0114565456, 0114565459, 12);
INSERT INTO `Bank`.`Pay_Orders` (`transaction_amount`, `transaction_date`, `acc_number`, `to_acc_number`, `frequency`) VALUES (2500.00, 29, 0114565458, 0114565459, 12);

INSERT INTO `Bank`.`Utility_Provider` (`utility_provider_id`, `utlity_provider_name`) VALUES ('1', 'HSBC');
INSERT INTO `Bank`.`Utility_Provider` (`utility_provider_id`, `utlity_provider_name`) VALUES ('2', 'Mobitel');
INSERT INTO `Bank`.`Utility_Provider` (`utility_provider_id`, `utlity_provider_name`) VALUES ('3', 'Dialog');
INSERT INTO `Bank`.`Utility_Provider` (`utility_provider_id`, `utlity_provider_name`) VALUES ('4', 'Water Board');

INSERT INTO `Bank`.`Transactions` (`transaction_id`, `transaction_amount`, `transaction_date`, `utility_provider_id`, `acc_number`, `currency_id`) VALUES ('1000', '2350.00', '2017/11/05', '1', '0114565456', '1');
INSERT INTO `Bank`.`Transactions` (`transaction_id`, `transaction_amount`, `transaction_date`, `utility_provider_id`, `acc_number`, `currency_id`) VALUES ('1001', '5000.50', '2017/10/23', '2', '0114565458', '1');
INSERT INTO `Bank`.`Transactions` (`transaction_id`, `transaction_amount`, `transaction_date`, `utility_provider_id`, `acc_number`, `currency_id`) VALUES ('1002', '4567.90', '2017/09/22', '3', '0114565459', '1');
