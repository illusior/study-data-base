USE lab4_task1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM dish;

INSERT INTO dish () VALUES (0, 'Pizza', 300, 1, 5);
INSERT INTO dish (id_dish, name, cost, weight, rating) VALUES (1, 'Borch', 60, 0.255, 4.8);

DROP TABLE IF EXISTS dish_temp;
CREATE TABLE dish_temp LIKE dish;

INSERT INTO dish_temp (id_dish, name, cost, weight, rating) VALUES (2, 'Zapekanka', 50, 0.155, 4.6);
INSERT INTO dish (id_dish, name, cost, weight, rating)
SELECT id_dish, name, cost, weight, rating
  FROM dish_temp
WHERE id_dish = 2;

DROP TABLE dish_temp;

SET SQL_SAFE_UPDATES = 1;
