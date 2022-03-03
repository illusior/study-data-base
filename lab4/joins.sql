USE lab4_task2;

SELECT owner_name, phone.phone, active
FROM
	phone
		LEFT JOIN
	tariff ON phone.id_phone_tariff = 3 AND tariff.id_tariff = 3
WHERE
	tariff.name IS NOT NULL;
    
SELECT owner_name, phone.phone, active
FROM
	phone
		RIGHT JOIN
	tariff ON phone.id_phone_tariff = 3 AND tariff.id_tariff = 3
WHERE
	phone.owner_name IS NOT NULL;
    
SELECT *
FROM
	phone
		INNER JOIN
	tariff;
    