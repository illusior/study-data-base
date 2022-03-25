USE lab6;

-- 1. Добавить внешние ключи.

ALTER TABLE dealer
    ADD CONSTRAINT fk_dealer_company FOREIGN KEY (id_company)
        REFERENCES company (id_company);

ALTER TABLE production
    ADD CONSTRAINT fk_production_company FOREIGN KEY (id_company)
        REFERENCES company (id_company);

ALTER TABLE production
    ADD CONSTRAINT fk_production_medicine FOREIGN KEY (id_medicine)
        REFERENCES medicine (id_medicine);

ALTER TABLE `order`
    ADD CONSTRAINT fk_order_production FOREIGN KEY (id_production)
        REFERENCES production (id_production);

ALTER TABLE `order`
    ADD CONSTRAINT fk_order_pharmacy FOREIGN KEY (id_pharmacy)
        REFERENCES pharmacy (id_pharmacy);

ALTER TABLE `order`
    ADD CONSTRAINT fk_order_dealer FOREIGN KEY (id_dealer)
        REFERENCES dealer (id_dealer);

-- 2. Выдать информацию по всем заказам лекарства “Кордеон” компании “Аргус” с указанием названий аптек, дат, объема заказов.

SET @ARGUS_COMPANY_ID = (
    SELECT id_company
    FROM company
    WHERE name = 'Аргус'
);

SET @CORDEON_MEDICINE_ID = (
    SELECT id_medicine
    FROM medicine
    WHERE name = 'Кордеон'
);

SET @PRODUCTION_ID = (
    SELECT id_production
    FROM production p
    WHERE p.id_company = @ARGUS_COMPANY_ID
      AND p.id_medicine = @CORDEON_MEDICINE_ID
);

SELECT name, date, quantity
FROM `order` o
         LEFT JOIN pharmacy p ON o.id_pharmacy = p.id_pharmacy
WHERE o.id_production = @PRODUCTION_ID
ORDER BY quantity;

-- 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.

SET @TASK_3_DATE = DATE('2019-01-25');

SELECT id_medicine, name
FROM medicine m
WHERE m.id_medicine NOT IN
      (SELECT p.id_medicine
       FROM `order` o
                LEFT JOIN production p on o.id_production = p.id_production
                JOIN company c on p.id_company = c.id_company AND c.name = 'Фарма'
       WHERE o.date < @TASK_3_DATE);

-- 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов.
SELECT p.id_company, MIN(p.rating) AS min_rating, MAX(p.rating) AS max_rating, COUNT(*) AS count
FROM `order` o
         JOIN production p on o.id_production = p.id_production
GROUP BY p.id_company
HAVING count > 120;

-- 5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”. Если у дилера нет заказов, в названии аптеки проставить NULL.

SET @ASTRA_ZENECA_COMPANY_ID = (
    SELECT id_company
    FROM company c
    WHERE c.name = 'AstraZeneca'
);

SELECT p.name
FROM `order` o
         JOIN pharmacy p ON p.id_pharmacy = o.id_pharmacy
         RIGHT JOIN dealer d ON d.id_dealer = o.id_dealer
WHERE d.id_company = @ASTRA_ZENECA_COMPANY_ID
GROUP BY d.name;

-- 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.

SELECT *
FROM production p
WHERE p.id_medicine IN (
    SELECT id_medicine
    FROM medicine m
    WHERE m.cure_duration <= 7
)
ORDER BY p.price;

UPDATE production p
SET p.price = p.price * 0.8
WHERE p.id_medicine IN (
    SELECT id_medicine
    FROM medicine m
    WHERE m.cure_duration <= 7
);

UPDATE production p
SET p.price = p.price * 1.25
WHERE p.id_medicine IN (
    SELECT id_medicine
    FROM medicine m
    WHERE m.cure_duration <= 7
);

-- 7. Добавить необходимые индексы.

CREATE INDEX `IX_dealer_id_company`
    ON dealer (`id_company`);

CREATE INDEX `IX_production_id_company-id_medicine`
    ON production (id_company, id_medicine);

CREATE INDEX `IX_order_id_production-id_pharmacy-id_dealer`
    ON `order` (id_production, id_pharmacy, id_dealer);

CREATE INDEX IX_production_price
    ON production (price);

CREATE INDEX IX_medicine_cure_duration
    ON medicine (cure_duration);

CREATE INDEX IX_order_date
    ON `order` (date);