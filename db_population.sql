-- Connect to thelocals db to create data for its 'public' schema
\c localProductions

-- Insert operations

INSERT INTO Region (name) VALUES 
('Piemonte'), ('Valle d''Aosta'), ('Lombardia'), ('Trentino-Alto Adige'), ('Veneto'), ('Friuli-Venezia Giulia'), ('Liguria'), ('Emilia-Romagna'), ('Toscana'), ('Umbria'), ('Marche'), ('Lazio'), ('Abruzzo'), ('Molise'), ('Campania'), ('Puglia'), ('Basilicata'), ('Calabria'), ('Sicilia'), ('Sardegna');

INSERT INTO Role (role) VALUES  -- mi restituiva ERRORE:  la colonna "role_type" della relazione "role" non esiste
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

INSERT INTO Restaurant (restaurant_id, name, email, location, description, images, telephone_number, region_name) VALUES

);


INSERT INTO End_User (email, password, first_name, last_name, validated, organization, role, tax_code) VALUES
('Giovanni.Aquila@gmail.com','12345','Giovanni','Aquila',NULL,NULL,'Restaurateur','QLAGNN80P11G273B'),
('Orazio.Gatti@gmail.com','12345','Orazio','Gatti',NULL,NULL,'Restaurateur','GTTRZO75P08D612O'),
('Luisa.Ferrara@gmail.com','12345','Luisa','Ferrara',NULL,NULL,'Restaurateur','FRRLSU80M46G482J'),
('Enzo.Tumicelli@gmail.com','12345','Enzo','Tumicelli',NULL,NULL,'Restaurateur','TMCNZE80H12G478Y'),
('Salvatore.Aloia@gmail.com','12345','Salvatore','Aloia',NULL,NULL,'Regional Manager',NULL),
('Ginevra.Barsotti@gmail.com','12345','Ginevra','Barsotti',NULL,NULL,'Regional Manager',NULL),
('Uberto.Innocenti@gmail.com','12345','Uberto','Innocenti',NULL,NULL,'Regional Manager',NULL),
('Ambrogio.Sparacello@gmail.com','12345','Ambrogio','Sparacello',NULL,NULL,'Regional Manager',NULL),
('Settimo.Albanesi@gmail.com','12345','Settimo','Albanesi',TRUE,'Pro Loco Padova','Event Organizer',NULL),
('Antonio.Como@gmail.com','12345','Antonio','Como',TRUE,'Antichi Sapori','Event Organizer',NULL),
('Michelina.Corti@gmail.com','12345','Michelina','Corti',TRUE,'Chilometro zero','Event Organizer',NULL),
('Fioralba.Murgia@gmail.com','12345','Fioralba','Murgia',TRUE,'Coldiretti','Event Organizer',NULL),
('Evelina.Piazza@gmail.com','12345','Evelina','Piazza',NULL,NULL,'Customer',NULL),
('Gianpaolo.Abano@gmail.com','12345','Gianpaolo','Abano',NULL,NULL,'Customer',NULL),
('Gualtiero.Aldebrandi@gmail.com','12345','Gualtiero','Aldebrandi',NULL,NULL,'Customer',NULL),
('Nicola.Abelli@gmail.com','12345','Nicola','Abelli',NULL,NULL,'Customer',NULL),
('Tatiana.Agnelli@gmail.com','12345','Tatiana','Agnelli ',TRUE,NULL,'Producer','GNLTTN80D45D969Q'),
('Angelo.Antonini@gmail.com','12345','Angelo','Antonini',TRUE,NULL,'Producer','NTNNGL80H08L219J'),
('Gualberto.Alescio@gmail.com','12345','Gualberto','Alescio',TRUE,NULL,'Producer','LSCGBR80P11H501P'),
('Beatrice.Altoviti@gmail.com','12345','Beatrice','Altoviti ',TRUE,NULL,'Producer','LTVBRC80M48G224W');

INSERT INTO Orders (order_id, total_price, order_timestamp, order_status) VALUES
    
);

INSERT INTO Contain (order_id, product_code, quantity, price) VALUES
    
);
