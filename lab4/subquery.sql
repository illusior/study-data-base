USE lab4_task2;

SELECT * FROM (
	SELECT phone.phone, owner_name, wallet_value
    FROM phone.phone
		WHERE wallet_value > 0
);

    

