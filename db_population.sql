-- Connect to thelocals db to create data for its 'public' schema
\c localProductions

-- Insert operations

INSERT INTO Region (name) VALUES 
('Piemonte'), ('Valle d''Aosta'), ('Lombardia'), ('Trentino-Alto Adige'), ('Veneto'), ('Friuli-Venezia Giulia'), ('Liguria'), ('Emilia-Romagna'), ('Toscana'), ('Umbria'), ('Marche'), ('Lazio'), ('Abruzzo'), ('Molise'), ('Campania'), ('Puglia'), ('Basilicata'), ('Calabria'), ('Sicilia'), ('Sardegna');

INSERT INTO Role (role_type) VALUES 
('Restaurateur'), ('Regional Manager'), ('Event Organizer'), ('Customer'), ('Producer');

INSERT INTO TABLE Sales_Channel (type) VALUES
('Pay In store'), ('Cash On delivery');

INSERT INTO Status(status) VALUES
('Reserved'), ('Completed'), ('Canceled');

INSERT INTO Category (category_id, name, description) VALUES
('A1', 'Carne Rossa', 'Lavorazione di carni di ungulati domestici o selvatici per produzione e vendita di prodotti a base di carne'),
('A2', 'Carne Bianca', 'Macellazione e vendita carni di volatili da cortile, conigli, piccola selvaggina allevata o selvatica.'),
('A3', 'Miele', 'Produzione e vendita di MIELE, prodotti dolciari a base di miele con frutta secca o propoli; pappa reale o gelatina reale; polline; idromele; aceto di miele'),
('A5', 'Pane', 'Produzione, cottura e vendita di PANE e PRODOTTI DA FORNO'),
('A4', 'Conserve', 'Produzione e vendita di CONSERVE ALIMENTARI VEGETALI, VEGETALI TOSTATI, VEGETALI ESSICCATI E FARINE, CONFETTURE, MARMELLATE, COMPOSTE, SCIROPPI E SUCCHI DI FRUTTA, VEGETALI FRESCHI ED ERBE ALIMURGICHE'),
('A6', 'Olii', 'Produzione e vendita di OLIO EXTRAVERGINE DI OLIVA E OLIVE'),
('A7', 'Latte e derivati', 'Produzione, lavorazione e vendita di LATTE CRUDO, LATTE TRATTATO TERMICAMENTE E PRODOTTI LATTIERO CASEARI DI MALGA E DI PICCOLI CASEIFICI AZIENDALI'),
('A8', 'Chiocciole', 'Produzione, lavorazione e vendita di CHIOCCIOLE'),
('A9', 'Pesca e pescati', 'Produzione, lavorazione e vendita di PRODOTTI DELLA PESCA, DELL’ACQUACOLTURA E PRODOTTI TRASFORMATI'),
('A10', 'Pasta Secca','Produzione, lavorazione e vendita di: PASTA SECCA '),
('A11', 'Birra','Produzione, lavorazione e vendita di: BIRRA '),
('A12', 'Aceti','Produzione, lavorazione e vendita di: ACETI');

INSERT INTO Product (name, general_description, category_id) VALUES
('Olio Extravergine Di Oliva DOP', 'Olio supercalifragilistico', 'A6'),
('Ricky Rabbit', 'Il coniglietto più buono del DEI', 'A2');

INSERT INTO TABLE Restaurant (restaurant_id, name, email, location, description, images, telephone_number, region_name) VALUES

);

INSERT INTO TABLE End_User (email, password, first_name, last_name, validated, organization, role, tax_code) VALUES

);

INSERT INTO TABLE Orders (order_id, total_price, order_timestamp, order_status) VALUES
    
);

INSERT INTO TABLE Contain (order_id, product_code, quantity, price) VALUES
    
);
