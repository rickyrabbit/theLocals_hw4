-- connect to localProductions db
\c localProductions

/*

- Visualizzare storico ordini di un utente DONE
- Visualizzare un dettaglio ordine (Prodotti, prezzo singolo, prezzo totale ordini, produttore, data) DONE
- Visualizzare eventi presenti e futuri in una regione (Quando si tengono, descrizione e i prodotti che contengono)
- 


- STATISTICHE
	-- visualizzare statistiche di vendita per un produttore (per ogni prodotto le unita' gia' vendute)
    -- prodotti piu' venduti per regione
     


*/


-- Visualizzare storico ordini (ultimi 15) di un utente
SELECT order_id, order_timestamp, total_price, type FROM Make AS m
INNER JOIN Orders AS o ON m.order_id = o.order_id
WHERE customer_email = "Evelina.Piazza@gmail.com" --TODO: Insert correct email
ORDER BY order_id DESC
LIMIT 15;


-- Visualizzare un dettaglio ordine (Prodotti, prezzo singolo, produttore)

SELECT order_id, product_code, name, quantity, price, business_name FROM Contain as c
INNER JOIN Make AS m On c.order_id = m.order_id
INNER JOIN Product AS p ON c.product_code = p.product_code
INNER JOIN Producer AS prdcr ON m.producer_email = prdcr.producer_email
WHERE order_id = 10 --TODO: Control serial number generated
ORDER BY name ASC;


-- Visualizzare eventi presenti e futuri in una regione (Quando si tengono, descrizione e i prodotti che contengono)

SELECT event_id, e.name, description, start_date, end_date, location, region_name, product_code, p.name FROM Event AS e
INNER JOIN Promote as prm ON e.event_id = prm.event_id
INNER JOIN Product as p ON prm.product_code = p.product_code
WHERE end_date >= CURRENT_DATE; --TODO: check date

--STATISTICHE
	-- visualizzare statistiche di vendita per un produttore (per ogni prodotto le unita' gia' vendute)
WITH producer_products AS (
    SELECT email,product_code FROM Producer AS prdcr
    INNER JOIN Sell AS s ON prdcr.email = s.email
    INNER JOIN Product AS p ON s.product_code = p.product_code
    WHERE email = "m8.avanzi@gmail.com"
)
WITH sold_product_quantities AS (
    SELECT 
)
    
    
    
    -- 3 prodotti piu' venduti per regione
SELECT product_code, name, quantity
