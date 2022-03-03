USE lab4_task1;

SELECT weight
	FROM dish ORDER BY weight
    LIMIT 3;
    
SELECT weight
	FROM dish ORDER BY weight DESC
    LIMIT 3;
    
SELECT weight, rating
	FROM dish ORDER BY weight, rating
    LIMIT 3;

SELECT *
	FROM dish ORDER BY id_dish DESC;