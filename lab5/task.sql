USE lab5;

-- 1. Добавить внешние ключи.

ALTER TABLE room_in_booking
	DROP FOREIGN KEY FK_room_in_booking_room1;
    
-- Необходимо удалять ограничения перед выполнением следующих ALTER
    
ALTER TABLE room_in_booking
	ADD CONSTRAINT fk_room_in_booking_room1 FOREIGN KEY (id_room)
    REFERENCES room (id_room);
    
ALTER TABLE room_in_booking
	ADD CONSTRAINT fk_room_in_booking_booking1 FOREIGN KEY (id_booking)
    REFERENCES booking (id_booking);
    
ALTER TABLE booking
	ADD CONSTRAINT fk_booking_client1 FOREIGN KEY (id_booking)
    REFERENCES client (id_client);
    
ALTER TABLE room
	ADD CONSTRAINT fk_room_hotel FOREIGN KEY (id_hotel)
    REFERENCES hotel (id_hotel);
    
ALTER TABLE room
	ADD CONSTRAINT fk_room_room_category1 FOREIGN KEY (id_room_category)
    REFERENCES room_category (id_room_category);

-- 2. Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г

SET @COSMOS_HOTEL_ID = (
	SELECT id_hotel
    FROM hotel
	WHERE name = "Космос"
);

SET @LUKS_ROOM_CATEGORY_ID = (
	SELECT id_room_category
    FROM room_category
	WHERE name = "Люкс"
);

SET @NEEDED_DATE_TASK_2 = DATE("2019-04-01");

SELECT name, phone
FROM client
WHERE id_client IN (
	SELECT id_client
    FROM booking
	WHERE id_booking IN (
		SELECT id_booking
        FROM room_in_booking
		WHERE DATE(checkin_date) <= @NEEDED_DATE_TASK_2 AND @NEEDED_DATE_TASK_2 < DATE(checkout_date) AND id_room IN (
			SELECT id_room
            FROM room
			WHERE id_hotel = @COSMOS_HOTEL_ID AND id_room_category = @LUKS_ROOM_CATEGORY_ID
		)
	)
);

-- 3. Дать список свободных номеров всех гостиниц на 22 апреля

SET @NEEDED_DATE_TASK_3 = DATE("2019-04-22");

SELECT room.id_room, number, hotel.name
FROM room
LEFT JOIN hotel
ON hotel.id_hotel = room.id_hotel
WHERE room.id_room IN (
	SELECT DISTINCT room_in_booking.id_room
	FROM room_in_booking
	WHERE @NEEDED_DATE_TASK_3 NOT BETWEEN checkin_date AND DATE_SUB(checkout_date, INTERVAL 1 DAY))
ORDER BY hotel.name , number;
    
-- 4. Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров

SELECT name, COUNT(*) AS count
FROM room_category
JOIN room r
ON room_category.id_room_category = r.id_room_category
JOIN room_in_booking rib
ON r.id_room = rib.id_room
WHERE r.id_hotel = @COSMOS_HOTEL_ID AND DATE('2019-03-23') BETWEEN rib.checkin_date AND DATE_SUB(rib.checkout_date, INTERVAL 1 DAY)
GROUP BY name;

-- 5. Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда

SELECT name, phone, rib.id_room, checkout_date
FROM client
JOIN
booking b
ON client.id_client = b.id_client
JOIN room_in_booking rib
ON b.id_booking = rib.id_booking
JOIN room r
ON r.id_room = rib.id_room
WHERE MONTH(checkout_date) = 4 AND r.id_hotel = @COSMOS_HOTEL_ID
GROUP BY r.id_room
HAVING MAX(rib.checkout_date);

-- 6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая.
 
 SET SQL_SAFE_UPDATES = 0;
 
 SET @BUSINESS_CATEGORY_ID = (
	SELECT id_room_category
    FROM room_category rc
	WHERE rc.name = "Бизнес"
);

UPDATE room_in_booking rib
SET rib.checkout_date = DATE_ADD(rib.checkout_date, INTERVAL 2 DAY)
WHERE MONTH(rib.checkin_date) = 5 AND DAY(rib.checkin_date) = 19 AND rib.id_room IN (
	SELECT id_room
    FROM room r
	WHERE r.id_room_category = @BUSINESS_CATEGORY_ID AND r.id_hotel = @COSMOS_HOTEL_ID
);
    
SELECT *
FROM room_in_booking rib
WHERE MONTH(rib.checkin_date) = 5 AND DAY(rib.checkin_date) = 19 AND rib.id_room IN (
	SELECT id_room
    FROM room r
	WHERE r.id_room_category = @BUSINESS_CATEGORY_ID AND r.id_hotel = @COSMOS_HOTEL_ID
);
    
UPDATE room_in_booking rib
SET rib.checkout_date = DATE_SUB(rib.checkout_date, INTERVAL 2 DAY)
WHERE MONTH(rib.checkin_date) = 5 AND DAY(rib.checkin_date) = 19 AND rib.id_room IN (
	SELECT id_room
    FROM room r
	WHERE r.id_room_category = @BUSINESS_CATEGORY_ID AND r.id_hotel = @COSMOS_HOTEL_ID
);

SELECT *
FROM room_in_booking rib
WHERE MONTH(rib.checkin_date) = 5 AND DAY(rib.checkin_date) = 19 AND rib.id_room IN (
	SELECT id_room
    FROM room r
	WHERE r.id_room_category = @BUSINESS_CATEGORY_ID AND r.id_hotel = @COSMOS_HOTEL_ID
);

SET SQL_SAFE_UPDATES = 1;

-- 7. Найти все "пересекающиеся" варианты проживания.

SELECT *
FROM room_in_booking rib_1
LEFT JOIN room_in_booking rib_2
ON rib_1.id_room = rib_2.id_room AND rib_1.id_booking != rib_2.id_booking
WHERE
	rib_1.checkin_date  BETWEEN rib_2.checkin_date AND DATE_SUB(rib_2.checkout_date, INTERVAL 1 DAY) OR
	rib_1.checkout_date BETWEEN rib_2.checkin_date AND rib_2.checkout_date;

-- 8. Создать бронирование в транзакции.

START TRANSACTION;

INSERT IGNORE INTO client VALUES ('John', '88888888');
INSERT INTO booking VALUES ((
	SELECT id_client
    FROM client c
    WHERE c.name = 'John' AND c.phone = '88888888'
), NOW());

COMMIT;

-- 9. Добавить необходимые индексы для всех таблиц

CREATE INDEX fk_room_hotel_idx ON room(id_hotel);
CREATE INDEX fk_room_room_category1_idx ON room(id_room_category);

CREATE INDEX fk_booking_client1_idx ON booking(id_client);

CREATE INDEX fk_room_in_booking_room1_idx ON room_in_booking(id_room);
CREATE INDEX fk_room_in_booking_booking1_idx ON room_in_booking(id_booking);
