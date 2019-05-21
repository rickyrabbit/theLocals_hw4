-- Connect to thelocals db to create data for its 'public' schema
\c localproductions

-- Insert operations

INSERT INTO Region(name) VALUES 
('Piemonte'), 
('Valle d''Aosta'), 
('Lombardia'), 
('Trentino-Alto Adige'), 
('Veneto'), 
('Friuli-Venezia Giulia'), 
('Liguria'), 
('Emilia-Romagna'), 
('Toscana'), 
('Umbria'), 
('Marche'), 
('Lazio'), 
('Abruzzo'), 
('Molise'), 
('Campania'), 
('Puglia'), 
('Basilicata'), 
('Calabria'), 
('Sicilia'), 
('Sardegna');

INSERT INTO Role(role) VALUES  -- mi restituiva ERRORE:  la colonna "role_type" della relazione "role" non esiste
('Restaurateur'), 
('Regional Manager'), 
('Event Organizer'), 
('Customer'), 
('Producer');

INSERT INTO Sales_Channel(type) VALUES
('Pay In store'), 
('Cash On delivery');

INSERT INTO Status(status) VALUES
('Reserved'),
('Completed'),
('Canceled');

INSERT INTO Category(category_id, name, description) VALUES
('A1', 'Carne Rossa', 'Lavorazione di carni di ungulati domestici o selvatici per produzione e vendita di prodotti a base di carne'),
('A2', 'Carne Bianca', 'Macellazione e vendita carni di volatili da cortile, conigli, piccola selvaggina allevata o selvatica.'),
('A3', 'Miele', 'Produzione e vendita di MIELE, prodotti dolciari a base di miele con frutta secca o propoli; pappa reale o gelatina reale; polline; idromele; aceto di miele'),
('A4', 'Conserve', 'Produzione e vendita di CONSERVE ALIMENTARI VEGETALI, VEGETALI TOSTATI, VEGETALI ESSICCATI E FARINE, CONFETTURE, MARMELLATE, COMPOSTE, SCIROPPI E SUCCHI DI FRUTTA, VEGETALI FRESCHI ED ERBE ALIMURGICHE'),
('A5', 'Pane', 'Produzione, cottura e vendita di PANE e PRODOTTI DA FORNO'),
('A6', 'Olii', 'Produzione e vendita di OLIO EXTRAVERGINE DI OLIVA E OLIVE'),
('A7', 'Latte e derivati', 'Produzione, lavorazione e vendita di LATTE CRUDO, LATTE TRATTATO TERMICAMENTE E PRODOTTI LATTIERO CASEARI DI MALGA E DI PICCOLI CASEIFICI AZIENDALI'),
('A8', 'Chiocciole', 'Produzione, lavorazione e vendita di CHIOCCIOLE'),
('A9', 'Pesca e pescati', 'Produzione, lavorazione e vendita di PRODOTTI DELLA PESCA, DELL"ACQUACOLTURA E PRODOTTI TRASFORMATI'),
('A10', 'Pasta Secca','Produzione, lavorazione e vendita di: PASTA SECCA '),
('A11', 'Birra','Produzione, lavorazione e vendita di: BIRRA '),
('A12', 'Aceti','Produzione, lavorazione e vendita di: ACETI');

INSERT INTO Product(name, general_description, category_id) VALUES
('Sopressa Vicentina D.O.P.', 'La Soppressa Vicentina è ottenuta dalla lavorazione di cosce, coppa, spalla, pancetta, grasso di gola e lombo di maiale.', 'A1'),
('Coppa di Testa di Este', 'La coppa di testa viene prodotta da tempo immemorabile dai contadini dell"estense, nel periodo invernale, immediatamente dopo la macellazione del maiale.', 'A1'),
('Gallina Padovana', 'Razza riconosciuta come "pura" da uno standard nazionale redatto dalla Federazione Italiana delle razze avicole.', 'A2'),
('Coniglio Veneto', 'Anticamente l"allevamento del coniglio costituiva la forma di reddito integrativo per le famiglie della mezzadria veneta.', 'A2'),
('Miele delle Dolomiti Bellunesi D.O.P.', 'Miele prodotto a partire dal nettare dei fiori del territorio montano bellunese, dall"ecotipo locale di “Apis mellifera.”', 'A3'),
('Confettura di Mirtillo e Mela della Altopiano di Asiago', 'Esistono numerosi tipi di marmellate e confetture tipiche delle diverse zone del Veneto dovute alla ricca produzione di frutta.', 'A4'),
('Confettura di Ciliegia di Marostica I.G.P.', 'Esistono numerosi tipi di marmellate e confetture tipiche delle diverse zone del Veneto dovute alla ricca produzione di frutta.', 'A4'),
('Panada Veneta', 'Pancotto aromatizzato alla cannella.', 'A5'),
('Sopa Coada', 'Zuppa gratinata composta di strati di pane raffermo e piccione', 'A5'),
('Olio Extravergine Di Oliva D.O.P.', 'Olio tipico dei Colli Euganei.', 'A6'),
('Asiago D.O.P.', 'Formaggio tipico delle zone limitrofe all"Altopiano di Asiago.', 'A7'),
('Chiocciole D.O.P. Vicentine', 'Chiocciole tipiche della pianura vicino a Vicenza.', 'A8'),
('Calamari Veneziani', 'Pesce tipico della laguna di Venezia.', 'A9'),
('Bigoli Veneti', 'Ottima pasta da abbinare con il ragù d''anatra.', 'A10'),
('Birra di Rovigo D.O.P.', 'La birra artigianale è un prodotto non pastorizzato e non filtrato.', 'A11'),
('Aceto di Vino Euganeo', 'Aceto tipico dei Colli Euganei.', 'A12');

INSERT INTO Restaurant(name, email, location, description, images, telephone_number, region_name) VALUES
('Le calandre', 'lecalandre@gmail.com', 'Padova', 'Traditional Italian restaurant', NULL, '0490000', 'Veneto'),
('Da Orazio', 'daorazio@gmail.com', 'Treviso', 'Seafood restaurant', NULL, '04221000', 'Veneto'),
('Da Luisa', 'daluisa@gmail.com', 'Venezia', 'Trattoria', NULL, '346013406', 'Veneto'),
('Da Pino', 'dapino@gmail.com', 'Verona', 'Pizzeria', NULL, '346713406', 'Veneto');

INSERT INTO End_User(email, password, first_name, last_name, validated, organization, role, tax_code) VALUES
('Giovanni.Aquila@gmail.com', md5('12345'), 'Giovanni', 'Aquila', NULL, NULL, 'Restaurateur', 'QLAGNN80P11G273B'),
('Orazio.Gatti@gmail.com', md5('12345'), 'Orazio', 'Gatti', NULL, NULL, 'Restaurateur', 'GTTRZO75P08D612O'),
('Luisa.Ferrara@gmail.com', md5('12345'), 'Luisa', 'Ferrara', NULL, NULL, 'Restaurateur', 'FRRLSU80M46G482J'),
('Enzo.Tumicelli@gmail.com', md5('12345'), 'Enzo', 'Tumicelli', NULL, NULL, 'Restaurateur', 'TMCNZE80H12G478Y'),
('Salvatore.Aloia@gmail.com', md5('12345'), 'Salvatore', 'Aloia', NULL, NULL, 'Regional Manager', NULL),
('Ginevra.Barsotti@gmail.com', md5('12345'), 'Ginevra', 'Barsotti', NULL, NULL, 'Regional Manager', NULL),
('Uberto.Innocenti@gmail.com', md5('12345'), 'Uberto', 'Innocenti', NULL, NULL, 'Regional Manager', NULL),
('Ambrogio.Sparacello@gmail.com', md5('12345'), 'Ambrogio', 'Sparacello', NULL, NULL, 'Regional Manager', NULL),
('Settimo.Albanesi@gmail.com', md5('12345'), 'Settimo', 'Albanesi', TRUE, 'Pro Loco Padova', 'Event Organizer', NULL),
('Antonio.Como@gmail.com', md5('12345'), 'Antonio', 'Como', TRUE, 'Antichi Sapori', 'Event Organizer', NULL),
('Michelina.Corti@gmail.com', md5('12345'), 'Michelina', 'Corti', TRUE, 'Chilometro zero', 'Event Organizer', NULL),
('Fioralba.Murgia@gmail.com', md5('12345'), 'Fioralba', 'Murgia', TRUE, 'Coldiretti', 'Event Organizer', NULL),
('Evelina.Piazza@gmail.com', md5('12345'), 'Evelina', 'Piazza', NULL, NULL, 'Customer', NULL),
('Gianpaolo.Abano@gmail.com', md5('12345'), 'Gianpaolo', 'Abano', NULL, NULL, 'Customer', NULL),
('Gualtiero.Aldebrandi@gmail.com', md5('12345'), 'Gualtiero', 'Aldebrandi', NULL, NULL, 'Customer', NULL),
('Nicola.Abelli@gmail.com', md5('12345'), 'Nicola', 'Abelli', NULL, NULL, 'Customer', NULL),
('Tatiana.Agnelli@gmail.com', md5('12345'), 'Tatiana', 'Agnelli ', TRUE, NULL, 'Producer', 'GNLTTN80D45D969Q'),
('Angelo.Antonini@gmail.com', md5('12345'), 'Angelo', 'Antonini', TRUE, NULL, 'Producer', 'NTNNGL80H08L219J'),
('Gualberto.Alescio@gmail.com', md5('12345'), 'Gualberto', 'Alescio', TRUE, NULL, 'Producer', 'LSCGBR80P11H501P'),
('Beatrice.Altoviti@gmail.com', md5('12345'), 'Beatrice', 'Altoviti', TRUE, NULL, 'Producer', 'LTVBRC80M48G224W');

INSERT INTO Orders(total_price, order_timestamp, order_status) VALUES
('20.20', '2019-03-24 14:13:25+02', 'Completed'),
('2.50', '2019-03-29 12:05:09+02', 'Completed'),
('43.75', '2019-04-5 17:47:35+02', 'Completed'),
('3.60', '2019-04-7 14:13:25+02', 'Canceled'),
('13.10', '2019-04-13 10:22:13+02', 'Completed'),
('12.00', '2019-04-19 18:44:30+02', 'Canceled'),
('8.05', '2019-04-22 12:15:00+02', 'Completed'),
('12.05', '2019-04-27 20:37:55+02', 'Completed'),
('12.35', '2019-05-01 19:18:57+02', 'Completed'),
('14.20', '2019-05-03 13:33:47+02', 'Canceled');

INSERT INTO Contain(order_id, product_code, quantity, price) VALUES
(1, 1, 2, '12.05'),
(1, 5, 1, '8.15'),
(2, 7, 1, '2.50'),
(3, 3, 2, '12.00'),
(3, 11, 3, '6.75'),
(3, 12, 1, '25.00'),
(4, 6, 1, '3.60'),
(5, 8, 3, '1.05'),
(5, 1, 3, '12.05'),
(6, 3, 1, '12.00'),
(7, 5, 1, '8.05'),
(8, 12, 1, '12.05'),
(9, 1, 2, '12.35'),
(10, 10, 1, '14.20');

INSERT INTO Producer(email, pec, activity_description , location, telephone_number , business_name , vat_number, region_name ) VALUES
('Tatiana.Agnelli@gmail.com', 'Tatiana.Agnelli@legalmail.it', 'Allevamento di maiali e produzione propria di salumi', 'Conegliano', '3923085842', 'Le carni di Tatiana', '01906530983', 'Veneto'),
('Angelo.Antonini@gmail.com', 'Angelo.Antonini@legalmail.it', 'Produzione di olio dei Colli Euganei', 'Cinto Euganeo', '0429634030', 'Sapori dei Colli', '01835500940', 'Veneto'),
('Gualberto.Alescio@gmail.com', 'Gualberto.Alescio@legalmail.it', 'Piccolo allevamento di conigli', 'Padova', '0496588741', 'Allevamento Alescio', '02976538413', 'Veneto'),
('Beatrice.Altoviti@gmail.com', 'Beatrice.Altoviti@legalmail.it', 'Produzione di confetture', 'Asiago', '0424461475', 'Le confetture di Bea', '01984568450', 'Veneto');

INSERT INTO Review(email, product_code, score, content, review_timestamp) VALUES
('Evelina.Piazza@gmail.com', 1, 5, 'Sopressa di ottima fattura, con un buon rapporto qualità/prezzo.', '2019-05-10 11:23:54+02'),
('Nicola.Abelli@gmail.com', 5, 4, 'Miele molto buono, forse un po'' troppo caro.', '2019-05-13 10:23:54+02'),
('Gianpaolo.Abano@gmail.com', 7, 3, 'Marmellata un po'' troppo dolce, accettabile per il prezzo.', '2019-05-15 12:23:54+02'),
('Evelina.Piazza@gmail.com', 3, 5, 'Ottima qualità di carne, riacquisterò sicuramente in futuro.', '2019-05-16 10:43:54+02'),
('Evelina.Piazza@gmail.com', 11, 5, 'Asiago perfetto.', '2019-05-18 10:23:54+02'),
('Gualtiero.Aldebrandi@gmail.com', 12, 1, 'Chiocciole arrivare troppo vecchie, le ho buttate.', '2019-05-19 09:29:54+02');

INSERT INTO Event(name, location, start_date, end_date, description, email, region_name) VALUES
('Festa di Primavera', 'Via Casoni, 31057 Casale sul Sile (TV)', '[2019-03-20]', '[2019-03-23]', 'Musica, vino e artigianato, tutti i giorni dalle 20 alle 23', 'Antonio.Como@gmail.com', 'Veneto'),
('In Vino Veritas', 'Prato della Valle, 35123 Padova (PD)', '[2019-09-15]', '[2019-09-20]', 'Gustate i vini dei colli, tutti i giorni dalle 10 alle 23', 'Settimo.Albanesi@gmail.com', 'Veneto'),
('Orto in Tavola', 'Piazza IV Novembre, 06100 Perugia (PG)', '[2019-06-10]', '[2019-06-20]', 'Le migliori produzioni locali in piazza, tutti i giorni dalle 10 alle 22', 'Fioralba.Murgia@gmail.com', 'Umbria'),
('Festa della tagliata', 'Piazza della Biade, 36100 Vicenza (VI)', '[2019-07-01]', '[2019-07-05]', 'Carne di qualità tutte le sere dalle 19 alle 00', 'Antonio.Como@gmail.com', 'Veneto'),
('Festa del Pane', 'Piazza del Duomo, 56126 Pisa (PI)', '[2019-06-25]', '[2019-06-30]', 'Cibo e musica tutte le sere dalle 19 alle 23', 'Michelina.Corti@gmail.com', 'Toscana');

INSERT INTO Manage(email, region_name) VALUES
('Salvatore.Aloia@gmail.com', 'Veneto'),
('Ginevra.Barsotti@gmail.com', 'Piemonte'),
('Uberto.Innocenti@gmail.com', 'Trentino-Alto Adige'),
('Ambrogio.Sparacello@gmail.com', 'Friuli-Venezia Giulia');

INSERT INTO Offer(restaurant_id, product_code) VALUES
(1, 3),
(1, 4),
(2, 13),
(2, 15),
(3, 1),
(4, 10);

INSERT INTO Own(restaurant_id, email) VALUES
(1, 'Giovanni.Aquila@gmail.com'),
(2, 'Orazio.Gatti@gmail.com'),
(3, 'Luisa.Ferrara@gmail.com'),
(4, 'Enzo.Tumicelli@gmail.com');

INSERT INTO Make(order_id, type, customer_email, producer_email) VALUES
(1, 'Cash On delivery', 'Evelina.Piazza@gmail.com', 'Angelo.Antonini@gmail.com'),
(2, 'Pay In store', 'Gianpaolo.Abano@gmail.com', 'Tatiana.Agnelli@gmail.com'),
(3, 'Cash On delivery', 'Evelina.Piazza@gmail.com', 'Angelo.Antonini@gmail.com'),
(4, 'Pay In store', 'Gianpaolo.Abano@gmail.com', 'Gualberto.Alescio@gmail.com'),
(5, 'Pay In store', 'Gualtiero.Aldebrandi@gmail.com', 'Angelo.Antonini@gmail.com'),
(6, 'Pay In store', 'Gianpaolo.Abano@gmail.com', 'Beatrice.Altoviti@gmail.com'),
(7, 'Pay In store', 'Nicola.Abelli@gmail.com', 'Gualberto.Alescio@gmail.com'),
(8, 'Cash On delivery', 'Gualtiero.Aldebrandi@gmail.com', 'Tatiana.Agnelli@gmail.com'),
(9, 'Pay In store', 'Evelina.Piazza@gmail.com', 'Tatiana.Agnelli@gmail.com'),
(10, 'Cash On delivery', 'Gianpaolo.Abano@gmail.com', 'Angelo.Antonini@gmail.com');

INSERT INTO Sell(email , product_code , price, stock, image,  producer_description) VALUES
('Tatiana.Agnelli@gmail.com', 1, '12.05', 7, NULL, 'Soppressa Vicentina D.O.P di coppa e spalla aromatizata con rosmarino. Prezzo indicato per 800g di prodotto.'),
('Tatiana.Agnelli@gmail.com', 2, '8.10', 10, NULL, 'Cappa di testa tradizionale estense aromatizzata al timo. Prezzo indicato per 900g di prodotto.'),
('Angelo.Antonini@gmail.com', 10, '14.20', 5, NULL, 'Olio dei Colli Euganei spremuto a freddo,dal retrogusto piccante. Prezzo indicato per 1L di prodotto.'),
('Gualberto.Alescio@gmail.com', 4, '12.30', 37, NULL, 'Coniglio intero allevato all"aperto. Prezzo indicato per 1800g di prodotto.'),
('Beatrice.Altoviti@gmail.com', 6, '3.60', 40, NULL, 'Confettura di Mirtillo e Mela di coltivazioni secolari presenti nell" Altopiano. Prezzo indicato per 600g di prodotto.'),
('Beatrice.Altoviti@gmail.com', 7, '2.50', 38, NULL, 'Deliziosa confettura della rinomata Ciliegia di Marostica,famosa per il suo gusto caramelloso. Prezzo indicato per 450g di prodotto.');

INSERT INTO Promote(email, product_code, event_id) VALUES
('Beatrice.Altoviti@gmail.com', 6, 2),
('Beatrice.Altoviti@gmail.com', 6, 1),
('Beatrice.Altoviti@gmail.com', 7, 1),
('Angelo.Antonini@gmail.com', 10, 2),
('Gualberto.Alescio@gmail.com', 4, 2);

INSERT INTO Belong1(email, category_id ) VALUES
('Tatiana.Agnelli@gmail.com','A1'),
('Angelo.Antonini@gmail.com','A6'),
('Gualberto.Alescio@gmail.com','A2'),
('Beatrice.Altoviti@gmail.com','A4');

INSERT INTO Sale_Through(type, email) VALUES
('Pay In store', 'Tatiana.Agnelli@gmail.com'),
('Cash On delivery', 'Tatiana.Agnelli@gmail.com'),
('Pay In store', 'Angelo.Antonini@gmail.com'),
('Cash On delivery', 'Angelo.Antonini@gmail.com'),
('Pay In store', 'Gualberto.Alescio@gmail.com'),
('Pay In store', 'Beatrice.Altoviti@gmail.com');
