-- Connect to thelocals db to create data for its 'public' schema
\c localproductions 
-------------------------------------
-- TRIGGERS CREATION --
-------------------------------------

--Constraint 4
CREATE FUNCTION category_check() RETURNS TRIGGER AS $$
DECLARE 
cat_id text;

BEGIN

    SELECT p.category_id INTO cat_id
    FROM Product AS p
    WHERE p.product_code = NEW.product_code;

    PERFORM * FROM Belong1 AS b
    WHERE b.email = NEW.email AND b.category_id = cat_id;

    IF NOT FOUND THEN -- if the query found 0 rows
        RAISE EXCEPTION 'The product category is not associated to the producer';
    END IF;

    RETURN NEW; -- proceed to the insert
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sell_check BEFORE INSERT -- Constraint 4
ON Sell
    FOR EACH ROW
EXECUTE PROCEDURE category_check();

-- Constraint 6 and 10
CREATE FUNCTION cancel_order(id INT) RETURNS void AS $$ 
    BEGIN
        DELETE FROM Orders
        WHERE Orders.order_id = id;
    END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION decrease_stock(p_email text, qnt_to_decrease INT, p_code INT) RETURNS void AS $$ 
    BEGIN
        UPDATE Sell
        SET stock = stock - qnt_to_decrease
        WHERE email = p_email AND product_code = p_code;
    END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION quantity_check() RETURNS TRIGGER AS $$
    DECLARE
    mystock INT;
    p_email text;

    BEGIN

        SELECT producer_email INTO p_email
        FROM Make
        WHERE order_id = NEW.order_id;

        SELECT stock INTO mystock 
        FROM Sell
        WHERE product_code = NEW.product_code AND email = p_email; 

        -- If the quantity selected is greater than the available product cancel the order instance and all instances that reference to i
        IF NEW.quantity > mystock THEN
            PERFORM cancel_order(NEW.order_id);
            RAISE EXCEPTION 'The quantity selected cannot be purchased. Please select a lower quantity';
        ELSE
            PERFORM decrease_stock(p_email, NEW.quantity, NEW.product_code);
        END IF;

        RETURN NEW; -- proceed to the insert

    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER contain_check BEFORE INSERT 
ON Contain
    FOR EACH ROW
EXECUTE PROCEDURE quantity_check();


--Constraint 8
CREATE FUNCTION promote_check() RETURNS TRIGGER AS $$

    BEGIN

        PERFORM * FROM Sell
        WHERE email = NEW.email AND product_code = NEW.product_code;
    
        IF NOT FOUND THEN -- if the query found 0 rows
            RAISE EXCEPTION 'The producer does not sell that product';
        END IF;

        RETURN NEW; -- proceed to the insert

    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER event_promote_check BEFORE INSERT 
ON Promote
    FOR EACH ROW
EXECUTE PROCEDURE promote_check();


--Constraint 11
CREATE FUNCTION order_status_check() RETURNS TRIGGER AS $$
    DECLARE
    qnt_to_increase INT;
    p_email text;
    p_code INT;
        
    BEGIN
        
        IF NEW.status = "Canceled" AND OLD.status = "Reserved" THEN
            SELECT product_code, quantity INTO p_code, qnt_to_increase
            FROM Contain 
            WHERE order_id = NEW.order_id;

            SELECT producer_email INTO p_email
            FROM Make 
            WHERE order_id = NEW.order_id;

            UPDATE Sell
            SET stock = stock + qnt_to_increase
            WHERE producer_email = p_email AND product_code = p_code;
        END IF;
    
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER order_status_canceled AFTER UPDATE 
ON Orders
    FOR EACH ROW
EXECUTE PROCEDURE order_status_check();