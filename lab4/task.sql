USE lab4;

-----------------------------------------------------------------------------------------------------------------------
-- 3.1 INSERT
SET SQL_SAFE_UPDATES = 0;

-- a. Без указания списка полей INSERT INTO table_name VALUES (value1, value2, value3, ...);
INSERT INTO dish () VALUES (0, 'Pizza', 300, 1, 5);

-- b. С указанием списка полей INSERT INTO table_name (column1, column2, column3, ...) VALUES (value1, value2, value3, ...);
INSERT INTO dish (id_dish, name, cost, weight, rating) VALUES (1, 'Borch', 60, 0.255, 4.8);
-- c. С чтением значения из другой таблицы INSERT INTO table2 (column_name(s)) SELECT column_name(s) FROM table1;
DROP TABLE IF EXISTS dish_temp;
CREATE TABLE dish_temp LIKE dish;

INSERT INTO dish_temp (id_dish, name, cost, weight, rating) VALUES (2, 'Zapekanka', 50, 0.155, 4.6);

INSERT INTO dish (id_dish, name, cost, weight, rating)
SELECT id_dish, name, cost, weight, rating
FROM dish_temp
WHERE id_dish = 2;

DROP TABLE dish_temp;

SET SQL_SAFE_UPDATES = 1;

-----------------------------------------------------------------------------------------------------------------------
-- 3.2. DELETE

SET SQL_SAFE_UPDATES = 0;
-- a. Всех записей
DELETE FROM dish;

-- b. По условию DELETE FROM table_name WHERE condition;
DELETE FROM dish
WHERE id_dish = 0;

SET SQL_SAFE_UPDATES = 1;

-----------------------------------------------------------------------------------------------------------------------
-- 3.3. UPDATE
SET SQL_SAFE_UPDATES = 0;

-- a. Всех записей
UPDATE dish
SET name = 'empty';
-- b. По условию обновляя один атрибут
-- UPDATE table_name
-- SET column1 = value1, column2 = value2, ...
-- WHERE condition;
UPDATE dish
SET name = 'empty'
WHERE id_dish = 0;

-- c. По условию обновляя несколько атрибутов
-- UPDATE table_name
-- SET column1 = value1, column2 = value2, ...
-- WHERE condition;
UPDATE dish
SET name = 'empty', rating = 0
WHERE id_dish = 0;

SET SQL_SAFE_UPDATES = 1;

-----------------------------------------------------------------------------------------------------------------------
-- 3.4. SELECT
-- a. С набором извлекаемых атрибутов (SELECT atr1, atr2 FROM ...)
SELECT name, rating FROM dish;

-- b. Со всеми атрибутами (SELECT * FROM ...)
SELECT * FROM dish;

-- c. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = value)
SELECT * FROM dish WHERE id_dish = 0;

-----------------------------------------------------------------------------------------------------------------------
-- 3.5. SELECT ORDER BY + TOP (LIMIT)
-- a. С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT weight
FROM dish
ORDER BY weight
LIMIT 3;

-- b. С сортировкой по убыванию DESC
SELECT weight
FROM dish
ORDER BY weight DESC
LIMIT 3;

-- c. С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT weight, rating
FROM dish
ORDER BY weight, rating
LIMIT 3;

-- d. С сортировкой по первому атрибуту, из списка извлекаемых
SELECT *
FROM dish
ORDER BY id_dish DESC;

-----------------------------------------------------------------------------------------------------------------------
-- 3.6. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
-- Например, таблица авторов может содержать дату рождения автора.

-- a. WHERE по дате
SELECT *
FROM phone
WHERE reg_date = '2021-03-03 23:17:03';

-- b. WHERE дата в диапазоне
SELECT *
FROM phone
WHERE last_payment BETWEEN DATE_SUB(NOW(), INTERVAL 5 YEAR) AND DATE_ADD(NOW(), INTERVAL 1 DAY);

-- c. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора. Для этого используется функция YEAR().
SELECT YEAR(reg_date)
FROM phone
WHERE owner_name = 'Paul Ermakov';

-----------------------------------------------------------------------------------------------------------------------
-- 3.7. Функции агрегации

-- a. Посчитать количество записей в таблице
SELECT COUNT(*)
FROM phone;

-- b. Посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT id_phone)
FROM phone;

-- c. Вывести уникальные значения столбца
SELECT DISTINCT owner_name, id_phone
FROM phone;

-- d. Найти максимальное значение столбца
SELECT owner_name, MAX(traffic_value)
FROM phone;

-- e. Найти минимальное значение столбца
SELECT owner_name, MIN(talk_value)
FROM phone;

-- f. Написать запрос COUNT () + GROUP BY
SELECT active, COUNT(*) as amount
FROM phone
GROUP BY active;

-----------------------------------------------------------------------------------------------------------------------
-- 3.8. SELECT GROUP BY + HAVING

-- a. Написать 3 разных запроса с использованием GROUP BY + HAVING.
-- Для каждого запроса написать комментарий с пояснением, какую информацию извлекает запрос.
-- Запрос должен быть осмысленным, т.е. находить информацию, которую можно использовать.

-- Найти все тарифы, имеющие одинаковый период, стоймость которых находится в определённом ценовом диапазоне
SELECT *
FROM tariff t
GROUP BY t.tariff_period
HAVING t.cost BETWEEN 100 AND 5000;

-- Найти активных пользователей, зарегестрированных в определённую дату, имеющих отрицательный баланс, чтобы предложить им скидку на следующую оплату
SELECT *
FROM phone p
GROUP BY p.reg_date
HAVING p.active AND p.wallet_value > 0 AND p.reg_date BETWEEN ("2000-01-01") AND NOW();

-- Найти все услуги, имеющие одинаковый период, стоймость которых в определённом ценовом диапазоне
SELECT *
FROM service s
GROUP BY s.service_period
HAVING s.cost BETWEEN 100 AND 5000;

-----------------------------------------------------------------------------------------------------------------------
-- 3.9. SELECT JOIN

-- a. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT phone, owner_name, wallet_value, active, cost
FROM
payment pay LEFT JOIN phone ph ON ph.id_phone = pay.id_phone
WHERE pay.payment_status;

-- b. RIGHT JOIN. Получить такую же выборку, как и в 3.9.a
SELECT phone, owner_name, wallet_value, active, cost
FROM
phone ph RIGHT JOIN payment pay ON ph.id_phone = pay.id_phone
WHERE pay.payment_status;

-- c. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT DISTINCT phone, owner_name, t.name, t.cost
FROM phone p
LEFT JOIN phone_has_tariff pht ON p.id_phone = pht.id_phone
LEFT JOIN tariff t ON pht.id_tariff = t.id_tariff
WHERE pht.id_phone AND p.active AND t.cost > 0;

-- d. INNER JOIN двух таблиц
SELECT id_payment, phone, owner_name, wallet_value, pay.cost, payment_status
FROM phone ph INNER JOIN payment pay ON ph.id_phone = pay.id_phone
ORDER BY id_payment;

-----------------------------------------------------------------------------------------------------------------------
-- 3.10. Подзапросы
-- a. Написать запрос с условием WHERE IN (подзапрос)
SELECT *
FROM payment pay
WHERE pay.id_phone IN (SELECT DISTINCT id_phone FROM phone);

-- b. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT p.owner_name, p.reg_date, (SELECT MAX(reg_date) FROM phone) AS max_reg_date
FROM phone p;

-- c. Написать запрос вида SELECT * FROM (подзапрос)
SELECT *
FROM (
	SELECT owner_name, phone
    FROM phone
    ORDER BY owner_name
) AS phone_owner;

-- d. Написать запрос вида SELECT * FROM table JOIN (подзапрос) ON ...
SELECT *
FROM
phone p JOIN (
	SELECT id_phone, s.name, s.cost
    FROM phone_has_service phs
    LEFT JOIN service s ON phs.id_service = s.id_service
) AS phone_and_service ON p.id_phone = phone_and_service.id_phone;
 