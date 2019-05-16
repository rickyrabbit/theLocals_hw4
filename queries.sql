-- Database Creation
CREATE SCHEMA localProductions OWNER POSTGRES ENCODING = 'UTF8';

-- Connect to thelocals db to create data for its 'public' schema
\c thelocals


-- TODO: check if we new to add DOMAIN line 13 db_creation.sql

-- TODO: check ENUM perche' mattia e' STRASICURO CREATE TYPE  (Piscio in boca)

--Domain Creation

CREATE DOMAIN identifier AS VARCHAR(20)
	NOT NULL;

CREATE DOMAIN emailD AS text --TODO: check how to write email domains
    NOT NULL;
-- CREATE DOMAIN name_type AS VARCHAR()

CREATE DOMAIN password AS character varying(254)
	CONSTRAINT properpassword CHECK (((VALUE)::text ~* '[A-Za-z0-9._%-]{5,}'::text));

-- Create new data type
CREATE TYPE role_type AS ENUM(
    'Restaurateur'
    'Regional Manager'
    'Event Organizer'
    'Customer'
);

CREATE TYPE order_type AS ENUM(
    'Reserved'
    'Completed'
    'Canceled'
);

CREATE TYPE channel_type AS ENUM(
    --TODO
)

--Table Creation

/*
Region
Role
Sales Channel
Status
Category

Product
Restaurant
User
Order

Contain
Producer
Review
Event
Manage
Offer
Own

Make
Sell
Promote
Category
Belong1
*/

CREATE TABLE Region(
    name text,
    PRIMARY KEY (name)
);

CREATE TABLE Role(
    role text,
    PRIMARY KEY (role)
);

CREATE TABLE Sales_Channel(
    type text,
    PRIMARY KEY (type)
);

CREATE TABLE Status(
    status text,
    PRIMARY KEY (status)
);

CREATE TABLE Category(
    category_id text,
    name text NOT NULL,
    PRIMARY KEY (category_id)
);



CREATE TABLE Product(
    product_code text,
    name text NOT NULL,
    general_description text,
    category_id text,
    PRIMARY KEY (product_code),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Restaurant(
    restaurant_id text,
    name text NOT NULL,
    email emailD,
    location text NOT NULL,
    description text,
    images bytea, -- TODO: Check if correct
    telephone_number text NOT NULL,
    region_name text,
    PRIMARY KEY (restaurant_id),
    FOREIGN KEY (region_name) REFERENCES Region(name)
);

CREATE TABLE User(
    email emailD,
    password password NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    validated boolean,
    organization text,
    role role_type NOT NULL,
    tax_code text,
    PRIMARY KEY (emailD),
);

CREATE TABLE Order(
    order_id identifier,
    total_price money NOT NULL,--TODO: 
	order_timestamp timestamp NOT NULL,
	order_status order_type NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (order_status) REFERENCES Status(status) 
);


CREATE TABLE Contain(
 AS ENUM(
     --TODO
 )    order_id identifier,
    product_code identifier,
    quantity int NOT NULL,
    price money NOT NULL,
    PRIMARY KEY (order_id, product_code),
    FOREIGN KEY (order_id) REFERENCES Order(order_id),
    FOREIGN KEY (product_code) REFERENCES Product(product_code)
);

CREATE TABLE Producer(
    email emailD,
    pec emailD,
    activity_description text,
    location text NOT NULL,
    telephone_number text NOT NULL,
    business_name text NOT NULL,
    vat_number text NOT NULL,
    name text NOT NULL, -- TODO: cambiare in region_name
    PRIMARY KEY (email),
    FOREIGN KEY (email) REFERENCES User(email),
    FOREIGN KEY (name) REFERENCES Region(name)
);

CREATE TABLE Review(
    email emailD,
    product_code text,
    score int NOT NULL,
    content text,
    review_timestamp timestamp NOT NULL,
    PRIMARY KEY (email, product_code),
    FOREIGN KEY (email) REFERENCES User(email),
    FOREIGN KEY (product_code) REFERENCES Product(product_code)
); 

CREATE TABLE Event(
    event_id text,
    name text NOT NULL,
    location text NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    description text,
    email emailD,
    PRIMARY KEY(event_id),
    FOREIGN KEY(email) REFERENCES User(email) 
);

CREATE TABLE Manage(
    email emailD,
    name text NOT NULL, --TODO: cambiare in region_name
    PRIMARY KEY (email),
    FOREIGN KEY (email) REFERENCES User(email),
    FOREIGN KEY (name) REFERENCES Region(name)
);

CREATE TABLE Offer(
    restaurant_id identifier,
    product_code identifier,
    PRIMARY KEY (restaurant_id, product_code),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
    FOREIGN KEY (product_code) REFERENCES Product(product_code),
);

CREATE TABLE Own(
    restaurant_id text,
    email emailD,
    PRIMARY KEY (restaurant_id,email),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
    FOREIGN KEY (email) REFERENCES User(email),
);

CREATE TABLE Make(
    order_id identifier,
    type 
    customer_email
    producer_email
);

CREATE TABLE Sell(
    email emailD,
    product_code text NOT NULL,
    price money NOT NULL,
    stock int NOT NULL,
    image bytea, -- TODO: Check if correct
    producer_description text,
    PRIMARY KEY (email, product_code),
    FOREIGN KEY (email) REFERENCES Producer(email),
    FOREIGN KEY (product_code) REFERENCES Product(product_code)
);


CREATE TABLE Promote(
    email emailD,
    product_code identifier,
    event_id identifier,
    PRIMARY KEY (email, product_code, event_id),
    FOREIGN KEY (email) REFERENCES User(email),
    FOREIGN KEY (product_code) REFERENCES Product(product_code),
    FOREIGN KEY (event_id) REFERENCES Event(event_id),
);

CREATE TABLE Category(
    category_id identifier,
    name TEXT NOT NULL,
    PRIMARY KEY (category_id)
);

CREATE TABLE Belong1(
    email emailD,
    category_id identifier,
    PRIMARY KEY (email, category_id),
    FOREIGN KEY (email) REFERENCES User(email),
    FOREIGN KEY (category_id) REFERENCES Category(category_id),
);
