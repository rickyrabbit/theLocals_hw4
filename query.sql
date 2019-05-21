-- connect to localProductions db
\c localProductions

/*

- Visualizzare storico ordini di un utente 
- Visualizzare un dettaglio ordine (Prodotti, prezzo singolo, prezzo totale ordini, produttore, data) 
- Visualizzare eventi presenti e futuri in una regione (Quando si tengono, descrizione e i prodotti che contengono)

- STATISTICHE
-- visualizzare statistiche di vendita per un produttore (per ogni prodotto le unita' gia' vendute)

*/


-- Visualizzare storico ordini (ultimi 15) di un utente
SELECT o.order_id, o.order_timestamp, o.total_price, m.type FROM Make AS m
INNER JOIN Orders AS o ON m.order_id = o.order_id
WHERE customer_email = 'Evelina.Piazza@gmail.com'
ORDER BY order_id DESC
LIMIT 15;


-- Visualizzare un dettaglio ordine (Prodotti, prezzo singolo, produttore)

SELECT c.order_id, p.product_code, name, quantity, price AS "Unit Price", business_name FROM Contain as c
INNER JOIN Make AS m On c.order_id = m.order_id
INNER JOIN Product AS p ON c.product_code = p.product_code
INNER JOIN Producer AS prdcr ON m.producer_email = prdcr.email
WHERE c.order_id = 3
ORDER BY name ASC;


-- Visualizzare eventi presenti e futuri in una regione (Quando si tengono, descrizione e i prodotti che contengono)
SELECT e.event_id, e.name, description, start_date, end_date, location, region_name, p.product_code, p.name FROM Event AS e
INNER JOIN Promote AS prm ON prm.event_id = e.event_id
INNER JOIN Product AS p ON p.product_code = prm.product_code
WHERE end_date >= CURRENT_DATE AND region_name = 'Veneto';


--STATISTICHE
-- visualizzare statistiche di vendita per un produttore (per ogni prodotto le unita' gia' vendute)
SELECT c.product_code, SUM(c.quantity) AS "Total Sell" FROM Make AS m
INNER JOIN Orders AS o ON m.order_id = o.order_id
INNER JOIN Contain AS c ON m.order_id = c.order_id
WHERE m.producer_email = 'Angelo.Antonini@gmail.com' AND o.order_status = 'Completed'
GROUP BY c.product_code
ORDER BY "Total Sell" DESC
LIMIT 3;
