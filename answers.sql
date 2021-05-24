-- Practice Join
-- Question 1

SELECT * FROM invoice_line
JOIN invoice
ON invoice_line.invoice_id = invoice.invoice_id
WHERE unit_price > 0.99;

-- Question 2

SELECT i.invoice_date, c.first_name, c.last_name, i.total FROM invoice i
JOIN customer c
ON i.customer_id = c.customer_id;

-- Question 3

SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e
ON c.support_rep_id = e.employee_id;

-- Question 4

SELECT al.title, art.name
FROM album al
JOIN artist art
ON al.artist_id = art.artist_id;

-- Question 5

SELECT playlist_track.track_id FROM playlist_track
JOIN playlist
ON playlist_track.playlist_id = playlist.playlist_id
WHERE playlist.name ILIKE 'music';

-- Question 6

SELECT t.name
FROM playlist_track pt
JOIN track t
ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;

-- Question 7

SELECT t.name, play.name
FROM playlist_track pt
JOIN playlist play
ON pt.playlist_id = play.playlist_id
JOIN track t
ON pt.track_id = t.track_id;

-- Question 8

SELECT t.name, al.title
FROM track t
JOIN genre g
ON t.genre_id = g.genre_id
JOIN album al
ON t.album_id = al.album_id
WHERE g.name ILIKE 'alternative & punk';

-- Black Diamond

SELECT t.name, g.name, al.title, art.name FROM playlist play
JOIN playlist_track pt
ON play.playlist_id = pt.playlist_id
JOIN track t
ON pt.track_id = t.track_id
JOIN genre g
ON t.genre_id = g.genre_id
JOIN album al
ON t.album_id = al.album_id
JOIN artist art
ON al.artist_id = art.artist_id
WHERE play.playlist_id = 1;

-- Practice nested queries
-- Question 1

SELECT *
FROM invoice
WHERE invoice_id IN (
  SELECT invoice_id FROM invoice_line
	WHERE unit_price > 0.99);

-- Question 2

SELECT * FROM playlist_track
WHERE playlist_id IN (
  SELECT playlist_id FROM playlist
  WHERE name ILIKE 'music');

-- Question 3

SELECT name FROM track
WHERE track_id IN (
  SELECT track_id FROM playlist_track
  WHERE playlist_id = 5);

-- Question 4

SELECT * FROM track
WHERE genre_id IN (
  SELECT genre_id FROM genre
  WHERE name ILIKE 'comedy');

-- Question 5

SELECT * FROM track
WHERE album_id IN (
  SELECT album_id FROM album
  WHERE title ILIKE 'fireball');

-- Question 6

SELECT * FROM track
WHERE album_id IN (
  SELECT album_id FROM album
  WHERE artist_id IN (
    SELECT artist_id FROM artist
    WHERE name ILIKE 'Queen')
  );

-- Practice updating rows
-- Question 1

UPDATE customer
SET fax = null
WHERE fax IS NOT NULL;

-- Question 2

UPDATE customer
SET company = 'Self'
WHERE company IS null;

-- Question 3

UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

-- Question 4

UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

-- Question 5

UPDATE track
SET composer = 'The darkness around us'
WHERE composer IS NULL and genre_id = 3;

-- Group by
-- Question 1

SELECT g.name, count(*)
FROM track t
JOIN genre g
ON t.genre_id = g.genre_id
GROUP BY g.name;

-- Question 2

SELECT g.name, count(*)
FROM track t
JOIN genre g
ON t.genre_id = g.genre_id
WHERE g.name IN ('Pop', 'Rock')
GROUP BY g.name;

-- Question 3

SELECT art.name, count(*)
FROM album al
JOIN artist art
ON al.artist_id = art.artist_id
GROUP BY art.name;

-- Use Distinct
-- Question 1

SELECT DISTINCT composer
FROM track;

-- Question 2

SELECT DISTINCT billing_postal_code
FROM invoice;

-- Question 3

SELECT DISTINCT company
FROM customer;

-- Delete rows
-- Question 1

DElETE FROM practice_delete
WHERE type = 'bronze';

-- Question 2

DElETE FROM practice_delete
WHERE type = 'silver';

-- Question 3

DElETE FROM practice_delete
WHERE value = 150;

-- eCommerce Simulation

CREATE TABlE users (
	users_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL
)

CREATE TABlE products (
	products_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  price DEC NOT NULL
)

CREATE TABlE orders (
	orders_id SERIAL PRIMARY KEY,
    order_num INT NOT NULL,
  products_id INT REFERENCES products(products_id)
)

INSERT INTO users
(email, name)
VALUES
('test1@email', 'test 1'),
('test2@email', 'test 2'),
('test3@email', 'test 3');

INSERT INTO products
(name, price)
VALUES
('cool item 1', 300),
('cool item 2', 700),
('cool item 3', 40);

INSERT INTO orders
(order_num, products_id)
VALUES
(1, 1),
(1, 3),
(1, 2),
(2, 1),
(3, 3),
(3, 2);

SELECT * FROM products p
JOIN orders o
ON p.products_id = o.products_id
WHERE o.order_num = 1;

SELECT * FROM products p
JOIN orders o
ON p.products_id = o.products_id;

SELECT sum(p.price) FROM products p
JOIN orders o
ON p.products_id = o.products_id
WHERE o.order_num = 1;

ALTER TABLE orders
ADD COLUMN users_id INT REFERENCES users(users_id);

UPDATE orders
SET
	users_id = 1
WHERE order_num = 1;


UPDATE orders
SET
	users_id = 2
WHERE order_num = 2;


UPDATE orders
SET
	users_id = 3
WHERE order_num = 3;

SELECT u.users_id, count(o.order_num) FROM orders o
JOIN users u
ON o.users_id = u.users_id
GROUP BY u.users_id, o.order_num;

-- Black Diamond

SELECT u.users_id, count(o.order_num), sum(p.price) FROM orders o
JOIN users u
ON o.users_id = u.users_id
JOIN products p
ON o.products_id = p.products_id
GROUP BY u.users_id, o.order_num;