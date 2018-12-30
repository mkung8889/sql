USE sakila;

/*1a*/
SELECT first_name, last_name
FROM actor;

/*1b*/
SELECT CONCAT(UPPER(first_name),' ', UPPER(last_name)) AS "Actor Name"
FROM actor;

/*2a*/
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

/*2b*/
SELECT *
FROM actor
WHERE last_name LIKE '%GEN%';

/*2c*/
SELECT last_name, first_name
FROM actor
WHERE last_name like '%li%';

/*2d*/
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

/*3a*/
ALTER TABLE sakila.actor
ADD COLUMN description BLOB AFTER last_update;

/*3b*/
ALTER TABLE sakila.actor
DROP COLUMN description;

/*4a*/
SELECT DISTINCT(last_name), COUNT(*) AS 'Count'
FROM actor
GROUP BY last_name;

/*4b*/
SELECT DISTINCT(last_name), COUNT(*) AS 'Count'
FROM actor
GROUP BY last_name
HAVING Count >2;

/*4c*/
UPDATE sakila.actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

/*4d*/
UPDATE sakila.actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

/*5a*/
DESCRIBE sakila.address;

/*6a*/
SELECT s.first_name, s.last_name, a.address
FROM staff s
LEFT JOIN address a
ON s.address_id = a.address_id;

/*6b*/
SELECT s.first_name, s.last_name, SUM(p.amount) AS 'Total'
FROM staff s
LEFT JOIN payment p
ON s.staff_id = p.staff_id
WHERE p.payment_date LIKE '2005-08%'
GROUP BY s.first_name, s.last_name;

/*6c*/
SELECT f.title, COUNT(fc.actor_id) AS 'Number of Actors'
FROM film f
INNER JOIN film_actor fc
ON f.film_id = fc.film_id
GROUP BY f.title;

/*6d*/
SELECT COUNT(film_id) AS 'Number of Copies'
FROM inventory 
WHERE film_id IN (
	SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);

/*6e*/
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'Total'
FROM customer c
LEFT JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name;

/*7a*/
SELECT title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND language_id IN(
	SELECT language_id
    FROM language
    WHERE name = 'English'
);

/*7b*/
SELECT first_name, last_name
FROM actor
WHERE actor_id 
IN(
	SELECT actor_id
    FROM film_actor
    WHERE film_id 
    IN(
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);


/*7c*/
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN(
	SELECT address_id
    FROM address
    WHERE city_id IN(
		SELECT city_id
        FROM city
        WHERE country_id IN(
			SELECT country_id
            FROM country
            WHERE country = 'Canada'
		)
    )
);

/*7d*/
SELECT title
FROM film
WHERE film_id IN(
	SELECT film_id
    FROM film_category
    WHERE category_id IN(
		SELECT category_id
        FROM category
        WHERE name = 'Family' 
    )
);

/*7e*/
SELECT f.film_id, f.title, COUNT(i.film_id) AS 'Number of Times Rented'
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
GROUP BY i.film_id
ORDER BY COUNT(i.film_id) DESC;

/*7f*/
SELECT s.store_id, SUM(p.amount) AS 'Money Made'
FROM store s
JOIN payment p
ON s.manager_staff_id = p.staff_id
GROUP BY s.store_id;

/*7g*/
SELECT s.store_id, c.city, co.country
FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city c
ON a.city_id = c.city_id
JOIN country co
ON c.country_id = co.country_id;

/*7h*/
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue'
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

/*8a*/
CREATE VIEW Top_Five_Genres AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue'
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

/*8b*/
SELECT *
FROM Top_Five_Genres;

/*8c*/
DROP VIEW Top_Five_Genres;
