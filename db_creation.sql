
-- Database Creation
CREATE DATABASE localProductions OWNER POSTGRES ENCODING = 'UTF8';

-- Connect to thelocals db to create data for its 'public' schema
\c localproductions --con la P maiuscola ritorna errore evidentemente in riga 3 non è case sensitive mentre qui sì.

-- TODO: check if we new to add DOMAIN line 13 db_creation.sql

-- TODO: check ENUM

--Domain Creation

--TODO: eliminated Domain
--CREATE DOMAIN identifier AS VARCHAR(20)
--	NOT NULL;
--COMMENT ON DOMAIN identifier IS 'alphanumeric identifier domain, max 20 chars';


CREATE DOMAIN emailD AS text --TODO: check how to write email domains
    NOT NULL;
COMMENT ON DOMAIN emailD IS 'alphanumeric emailD domain';
-- CREATE DOMAIN name_type AS VARCHAR()

CREATE DOMAIN passwordD AS character varying(254)
	CONSTRAINT properpassword CHECK (((VALUE)::text ~* '[A-Za-z0-9._%-]{5,}'::text));
COMMENT ON DOMAIN passwordD IS 'alphanumeric passwordD domain, max 254 characters';

CREATE DOMAIN reviewScoreD AS SMALLINT
    NOT NULL
    CONSTRAINT review_interval CHECK (VALUE >= 1 AND VALUE <= 5);
COMMENT ON DOMAIN reviewScoreD IS 'A review score can be an int between 1 and 5';



-- Create new data type
--la precedente sintassi era sbagliata
CREATE TYPE role_type AS ENUM('Restaurateur','Regional Manager','Event Organizer','Customer','Producer');
COMMENT ON TYPE role_type IS 'enum for role types';

CREATE TYPE order_type AS ENUM('Reserved','Completed','Canceled');
COMMENT ON TYPE order_type IS 'enum for order types';

CREATE TYPE channel_type AS ENUM('Pay In store','Cash On delivery');
COMMENT ON TYPE  channel_type IS 'enum for sales channel types';




--Table Creation

CREATE TABLE Region(
    name text,
    PRIMARY KEY (name)
);
COMMENT ON TABLE Region IS 'Regions in which each producer operates';

CREATE TABLE Role(
    role role_type,
    PRIMARY KEY (role)
);
COMMENT ON TABLE Role IS 'Role of each user';

CREATE TABLE Sales_Channel(
    type channel_type,
    PRIMARY KEY (type)
);
COMMENT ON TABLE Sales_Channel IS 'Types of sales channels a producer provides';

CREATE TABLE Status(
    status order_type,
    PRIMARY KEY (status)
);
COMMENT ON TABLE Status IS 'Status of an order';

CREATE TABLE Category(
    category_id VARCHAR(4),
    name text NOT NULL,
    description text,
    PRIMARY KEY (category_id)
);
COMMENT ON TABLE Category IS 'Category a product belongs to';

CREATE TABLE Product(
    product_code SERIAL,
    name text NOT NULL,
    general_description text,
    category_id VARCHAR(4),
    PRIMARY KEY (product_code),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);
COMMENT ON TABLE Product IS 'Good sold by the producer within the catalogue';

CREATE TABLE Restaurant(
    restaurant_id SERIAL,
    name text NOT NULL,
    email emailD,
    location text NOT NULL,
    description text,
    images text, -- TODO: Check if correct DONE
    telephone_number text NOT NULL,
    region_name text NOT NULL,
    PRIMARY KEY (restaurant_id),
    FOREIGN KEY (region_name) REFERENCES Region(name)
);
COMMENT ON TABLE Restaurant IS 'Restaurant in which menu there is at least one local product';

CREATE TABLE End_User(
    email emailD,
    password passwordD NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    validated boolean,
    organization text,
    role role_type NOT NULL,
    tax_code text,
    PRIMARY KEY (email),
    CONSTRAINT constr_validation CHECK(--Constaint 1 
        (role = 'Producer' AND validated IS NOT NULL) OR (role = 'Event Organizer' AND validated IS NOT NULL) OR
        (role != 'Producer' AND validated IS NULL) OR (role != 'Event Organizer' AND validated IS NULL)
    ),
    CONSTRAINT constr_tax_code CHECK(--Constaint 2
        (role = 'Producer' AND tax_code IS NOT NULL) OR (role = 'Restaurateur' AND tax_code IS NOT NULL) OR
        (role != 'Producer' AND tax_code IS NULL) OR (role != 'Restaurateur' AND tax_code IS NULL)
    ),
    CONSTRAINT constr_organization CHECK(--Constaint 3
        (role = 'Event Organizer' AND organization IS NOT NULL) OR (role != 'Event Organizer' AND organization IS NULL)
    )
);
COMMENT ON TABLE End_User IS 'Every end user who has registered in the database';

CREATE TABLE Orders(
    order_id SERIAL,
    total_price money NOT NULL,--TODO: 
	order_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
	order_status order_type NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (order_status) REFERENCES Status(status),
    CONSTRAINT order_cancel_type
        ON DELETE CASCADE --TODO: rivedere
);
COMMENT ON TABLE Orders IS 'Summary of an order';


CREATE TABLE Contain(
    order_id INT,
    product_code INT,
    quantity INT NOT NULL,
    price money NOT NULL,
    PRIMARY KEY (order_id, product_code),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_code) REFERENCES Product(product_code)
);
COMMENT ON TABLE Contain IS 'List of products contained in an order';


CREATE TABLE Producer(
    email emailD,
    pec emailD,
    activity_description text,
    location text NOT NULL,
    telephone_number text NOT NULL,
    business_name text NOT NULL,
    vat_number text NOT NULL,
    region_name text NOT NULL,
    PRIMARY KEY (email),
    FOREIGN KEY (email) REFERENCES End_User(email),
    FOREIGN KEY (region_name) REFERENCES Region(name)
);
COMMENT ON TABLE Producer IS 'local producer of foodstuff'; -- punto e virgola

CREATE TABLE Review(
    email emailD,
    product_code INT,
    score reviewScoreD,
    content text,
    review_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    PRIMARY KEY (email, product_code),
    FOREIGN KEY (email) REFERENCES End_User(email),
    FOREIGN KEY (product_code) REFERENCES Product(product_code)
); 
COMMENT ON TABLE Review IS 'Review of a bought product';

CREATE TABLE Event(
    event_id SERIAL,
    name text NOT NULL,
    location text NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    description text,
    email emailD,
    region_name text NOT NULL,
    PRIMARY KEY(event_id),
    FOREIGN KEY(email) REFERENCES End_User(email),
    FOREIGN KEY(region_name) REFERENCES Region(name) 
);
COMMENT ON TABLE Event IS 'Event in which at least one local product is promoted';

CREATE TABLE Manage(
    email emailD,
    region_name text NOT NULL,
    PRIMARY KEY (email),
    FOREIGN KEY (email) REFERENCES End_User(email),
    FOREIGN KEY (region_name) REFERENCES Region(name)
);
COMMENT ON TABLE Manage IS 'Set of regions which a user of role_type "regional manager" is assigned to';

CREATE TABLE Offer(
    restaurant_id INT,
    product_code INT,
    PRIMARY KEY (restaurant_id, product_code),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
    FOREIGN KEY (product_code) REFERENCES Product(product_code)
);
COMMENT ON TABLE Offer IS 'List of local products that a restaurant offers in its menu';

CREATE TABLE Own(
    restaurant_id INT,
    email emailD,
    PRIMARY KEY (restaurant_id,email),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
    FOREIGN KEY (email) REFERENCES End_User(email)
);
COMMENT ON TABLE Own IS 'Restaurant owned by an user of role_type "restaurateur"';

CREATE TABLE Make(
    order_id INT,
    type channel_type,
    customer_email emailD,
    producer_email emailD,
    PRIMARY KEY (order_id, type, customer_email, producer_email),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (type) REFERENCES Sales_Channel(type),
    FOREIGN KEY (customer_email) REFERENCES End_User(email),
    FOREIGN KEY (producer_email) REFERENCES Producer(email) --virgola in più
);
COMMENT ON TABLE Make IS 'List of orders made by users of role_type "costumer" from "producers"';

CREATE TABLE Sell(
    email emailD,
    product_code INT NOT NULL, --si riferisce a un datatype serial quindi va messo come INT
    price money NOT NULL,
    stock INT NOT NULL,
    image bytea, -- TODO: Check if correct
    producer_description text,
    PRIMARY KEY (email, product_code),
    FOREIGN KEY (email) REFERENCES Producer(email),
    FOREIGN KEY (product_code) REFERENCES Product(product_code)
);
COMMENT ON TABLE Sell IS '';


CREATE TABLE Promote(
    email emailD,
    product_code INT,
    event_id INT,
    PRIMARY KEY (email, product_code, event_id),
    FOREIGN KEY (email) REFERENCES End_User(email),
    FOREIGN KEY (product_code) REFERENCES Product(product_code),
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
);
COMMENT ON TABLE Promote IS 'List of products sold by a "producer"';


CREATE TABLE Belong1(
    email emailD,
    category_id VARCHAR(4),
    PRIMARY KEY (email, category_id),
    FOREIGN KEY (email) REFERENCES End_User(email),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);
COMMENT ON TABLE Belong1 IS 'List of categories a "producer" belongs to';

CREATE TABLE Sale_Through(
    type channel_type, --Le colonne chiave "type" e "type" avevano tipi incompatibili: text e channel_type
    email emailD,
    PRIMARY KEY (type, email),
    FOREIGN KEY (type) REFERENCES Sales_Channel(type),
    FOREIGN KEY (email) REFERENCES Producer(email)
);
COMMENT ON TABLE Sale_Through IS 'List of sales channels provided by each "producer"';


--------------------------
-- EXTERNAL CONSTRAINTS --
--------------------------

--Constraint 4
--Procedure to check if the product belongs to the same category its producer is associated to
CREATE FUNCTION category_check() RETURNS TRIGGER AS $$
DECLARE 
cat_id text

BEGIN

    SELECT p.category_id INTO cat_id
    FROM Product AS p
    WHERE p.product_code = NEW.product_code

    PERFORM * FROM Belong1 AS b
    WHERE b.email = NEW.email AND b.category_id = cat_id

    IF NOT FOUND THEN -- if the query found 0 rows
        RAISE EXCEPTION 'The product category is not associated to your account';
    END IF;

    RETURN NEW; -- proceed to the insert
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER sell_check BEFORE INSERT -- Constraint 4
ON Sell
    FOR EACH ROW
EXECUTE PROCEDURE category_check();


-- Constraint 6 and 10
--
CREATE FUNCTION cancel_order(id INT) RETURN void AS $$ 
    BEGIN
        DELETE FROM Orders
        WHERE Orders.order_id = id
    END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION decrease_stock(p_email text, qnt_to_decrease INT, p_code INT) RETURN void AS $$ 
    BEGIN
        UPDATE Sell
        SET stock = stock - qnt_to_decrease
        WHERE producer_email = p_email AND product_code = p_code;
    END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION quantity_check() RETURNS TRIGGER AS $$
    DECLARE
    mystock INT;
    p_email text;

    BEGIN

        SELECT producer_email INTO p_email
        FROM Make
        WHERE producer_email = NEW.email;

        SELECT stock INTO mystock 
        FROM Sell
        WHERE product_code = NEW.product_code AND email = p_email; 

        -- If the quantity selected is greater than the available product cancel the order instance and all instances that reference to i
        IF NEW.quantity > mystock THEN
            cancel_order(NEW.order_id);
            RAISE EXCEPTION 'The quantity selected cannot be purchased. Please select a lower quantity';
        ELSE
            decrease_stock(p_email, NEW.quantity, NEW.product_code);
        END IF;

    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER contain_check BEFORE INSERT 
ON Contain
    FOR EACH ROW
EXECUTE PROCEDURE quantity_check();


--Constraint 8
CREATE FUNCTION promote_check() RETURN TRIGGER $$

    BEGIN
        PERFORM * FROM Sell
        WHERE email = NEW.email AND product_code = NEW.product_code;
    
        IF NOT FOUND THEN -- if the query found 0 rows
            RAISE EXCEPTION 'The producer does not sell that product';
        END IF;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER event_promote_check() BEFORE INSERT 
ON Promote
    FOR EACH ROW
EXECUTE PROCEDURE promote_check();


--Constraint 11
CREATE FUNCTION order_status_check() RETURN TRIGGER $$
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


CREATE TRIGGER order_status_canceled() AFTER UPDATE 
ON Order
    FOR EACH ROW
EXECUTE PROCEDURE order_status_check();
