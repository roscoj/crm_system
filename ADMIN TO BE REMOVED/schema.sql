CREATE TABLE addresses (
	id SERIAL PRIMARY KEY,
	address_line_1 VARCHAR(15) NOT NULL,
	address_line_2 VARCHAR(50) NOT NULL,
	town VARCHAR(25) NOT NULL,
	postcode VARCHAR(7) NOT NULL
);

CREATE TABLE invoicees (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(25) NOT NULL,
	last_name VARCHAR(25) NOT NULL,
	telephone VARCHAR(11) NOT NULL,
	email VARCHAR(50) NOT NULL,
	payment_method VARCHAR(5) CHECK (payment_method IN ('CASH','BACS','DD')) NOT NULL, 
	address_id INT REFERENCES addresses (id) ON UPDATE CASCADE NOT NULL
);

CREATE TABLE students (
	id SERIAL PRIMARY KEY,
	invoicee_id INT REFERENCES invoicees (id) ON UPDATE CASCADE,
	first_name VARCHAR(25) NOT NULL,
	last_name VARCHAR(25) NOT NULL,
  active BOOLEAN DEFAULT true NOT NULL,
  fee_per_hour NUMERIC(4,2) DEFAULT 30.00 NOT NULL
);

CREATE TABLE sessions (
	id SERIAL PRIMARY KEY,
	student_id INT REFERENCES students (id) ON UPDATE CASCADE NOT NULL,
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP NOT NULL
);

CREATE TABLE invoices (
  id SERIAL PRIMARY KEY,
  invoicee_id INT REFERENCES invoicees (id) NOT NULL
  current_balance NUMERIC(4,2)
);
