USE lab4_task2;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM phone;

INSERT INTO phone ()
	VALUES (1, 79028887776, 'Paul Ermakov', '2021-03-03 23:17:03', 100500, 300, 25, 50, NOW(), 1);
INSERT INTO phone ()
	VALUES (2, 79028887776, 'James Donovan', DATE_SUB(NOW(), INTERVAL 360 DAY), 500, 650, 25, 44, DATE_ADD(NOW(), INTERVAL 1 DAY), 1);
INSERT INTO phone ()
	VALUES (3, 79028887776, 'Abdul Lazar', DATE_SUB(NOW(), INTERVAL 726 DAY), 100400, 210, 23, 0, DATE_ADD(NOW(), INTERVAL 2 DAY), 0);
INSERT INTO phone ()
	VALUES (4, 79028887776, 'Chicken Fried', DATE_SUB(NOW(), INTERVAL 366 DAY), 0, 200, 25, 48, DATE_ADD(NOW(), INTERVAL 3 DAY), 1);
INSERT INTO phone ()
	VALUES (5, 79028887776, 'Paul Ermakov', '2021-03-03 23:17:03', 100500, 300, 25, 50, NOW(), 0);

DELETE FROM tariff;

INSERT INTO tariff ()
	VALUES (1, 'Bezlimitishe', 30000, 100, 100, 50, '500:00:00');
INSERT INTO tariff ()
	VALUES (2, 'Bezlimitishe+', 300000, 1000, 200, 100, '600:00:00');
INSERT INTO tariff ()
	VALUES (3, 'Wow', 999999, 999999, 999999, 999999, '830:00:00');
INSERT INTO tariff ()
	VALUES (4, 'Wow', 999999, 999999, 999999, 999999, '830:00:00');

INSERT INTO phone_has_tariff ()
	VALUES (1, 2, DATE_SUB(NOW(), INTERVAL 3 YEAR));
INSERT INTO phone_has_tariff ()
	VALUES (2, 3, DATE_SUB(NOW(), INTERVAL 4 YEAR));
INSERT INTO phone_has_tariff ()
	VALUES (3, 3, DATE_SUB(NOW(), INTERVAL 5 YEAR));
INSERT INTO phone_has_tariff ()
	VALUES (4, 1, DATE_SUB(NOW(), INTERVAL 6 YEAR));
INSERT INTO phone_has_tariff ()
	VALUES (5, 4, DATE_SUB(NOW(), INTERVAL 7 YEAR));

SET SQL_SAFE_UPDATES = 1;