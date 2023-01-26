
SELECT *
FROM payment

CREATE OR REPLACE PROCEDURE lateFee()
	LANGUAGE plpgsql
	AS $$
	BEGIN

		UPDATE payment
		SET amount = amount + 3
		WHERE customer_id IN(
			SELECT customer_id
			FROM rental
			WHERE rental_duration > '7 days'
	);
		COMMIT;
	END;
	$$

	Call lateFee()
	
-- #2

SELECT *
FROM payment

SELECT *
FROM customer

ALTER TABLE customer
ADD COLUMN platinum_member BOOLEAN;

CREATE OR REPLACE PROCEDURE is_prem_membership()
	LANGUAGE plpgsql
	AS $$
	BEGIN
		
		UPDATE customer
		SET platinum_member = true
		WHERE customer_id IN(
			SELECT customer_id
			FROM payment
			GROUP BY customer_id
			HAVING sum(amount)> 200);
			
		UPDATE customer
		SET platinum_member = false
		WHERE customer_id NOT IN(
			SELECT customer_id
			FROM payment
			GROUP BY customer_id
			HAVING sum(amount)> 200);
			
			COMMIT;
		END;
	$$
	CALL is_prem_membership();
	
