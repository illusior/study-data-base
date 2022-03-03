USE lab4_task1;

SET SQL_SAFE_UPDATES = 0;

UPDATE dish SET name = 'empty';
UPDATE dish SET name = 'empty' WHERE id_dish = 0;
UPDATE dish SET name = 'empty', rating = 0 WHERE id_dish = 0;

SET SQL_SAFE_UPDATES = 1;
