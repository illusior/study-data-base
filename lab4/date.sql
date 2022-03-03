USE lab4_task2;

SELECT * FROM phone
	WHERE reg_date = '2021-03-03 23:17:03';

SELECT * FROM phone
	WHERE last_payment BETWEEN DATE_SUB(NOW(), INTERVAL 5 YEAR) AND DATE_ADD(NOW(), INTERVAL 1 DAY);

SELECT YEAR(reg_date) FROM phone
	WHERE owner_name = 'Paul Ermakov';