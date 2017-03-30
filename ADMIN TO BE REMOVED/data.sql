INSERT INTO addresses (address_line_1, address_line_2, town, postcode)
VALUES('25', 'Westbourne Gardens', 'Hove', 'BN31OT');
INSERT INTO addresses (address_line_1, address_line_2, town, postcode)
VALUES('12', 'Holly Road', 'Hove', 'BN33YD');
INSERT INTO addresses (address_line_1, address_line_2, town, postcode) 
VALUES('61', 'Landing Street', 'Hove', 'BN35UQ');

INSERT INTO invoicees (first_name, last_name, telephone, email, payment_method, address_id)
VALUES ('Katria', 'Condor', '07543679512', 'thecondors@sky.com', 'DD', 1);
INSERT INTO invoicees (first_name, last_name, telephone, email, payment_method, address_id)
VALUES ('Liza', 'Heath', '07856341297', 'theheaths@gmail.com', 'DD', 2);
INSERT INTO invoicees (first_name, last_name, telephone, email, payment_method, address_id)
VALUES ('Sarin', 'Smith', '07998335162', 'sarin@hotmail.com', 'DD', 3);

INSERT INTO students (first_name, last_name, invoicee_id)
VALUES ('Helen', 'Condor', 1);
INSERT INTO students (first_name, last_name, invoicee_id)
VALUES ('Anna', 'Condor', 1);
INSERT INTO students (first_name, last_name, invoicee_id)
VALUES ('Ally', 'Heath', 2);
INSERT INTO students (first_name, last_name, invoicee_id)
VALUES ('Fran', 'Heath', 2);
INSERT INTO students (first_name, last_name, invoicee_id)
VALUES ('Theo', 'Smith', 3);
INSERT INTO students (first_name, last_name)
VALUES ('Martin', 'Jarrett');

INSERT INTO SESSIONS (start_time, end_time, student_id)
VALUES ('2017-2-10 17:00:00', '2017-2-10 17:30:00', 1);
INSERT INTO SESSIONS (start_time, end_time, student_id)
VALUES ('2017-2-10 17:30:00', '2017-2-10 18:00:00', 2);
INSERT INTO SESSIONS (start_time, end_time, student_id)
VALUES ('2017-2-11 15:00:00', '2017-2-11 15:30:00', 3);
INSERT INTO SESSIONS (start_time, end_time, student_id)
VALUES ('2017-2-11 15:30:00', '2017-2-11 16:15:00', 4);
INSERT INTO SESSIONS (start_time, end_time, student_id)
VALUES ('2017-2-13 17:00:00', '2017-2-13 17:30:00', 5);
INSERT INTO SESSIONS (start_time, end_time, student_id)
VALUES ('2017-2-13 17:00:00', '2017-2-13 17:30:00', 1);
INSERT INTO SESSIONS (start_time, end_time, student_id)
VALUES ('2017-2-17 17:00:00', '2017-2-17 17:30:00', 2);
INSERT INTO SESSIONS (start_time, end_time, student_id)
VALUES ('2017-2-17 17:00:00', '2017-2-17 17:30:00', 3);

