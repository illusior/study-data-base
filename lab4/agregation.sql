USE lab4_task2;

SELECT COUNT(*) FROM phone;

SELECT COUNT(DISTINCT id_phone) FROM phone;

SELECT DISTINCT id_phone, owner_name FROM phone;

SELECT owner_name, MAX(traffic_value) FROM phone;

SELECT owner_name, MIN(talk_value) FROM phone;

SELECT active, COUNT(*) as count FROM phone
    GROUP BY active;