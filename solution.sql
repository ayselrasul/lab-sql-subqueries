-- Lab | SQL Subqueries
					 
SELECT 
    f.film_id
FROM
    film f
WHERE
    title = 'Hunchback Impossible';-- First step:find film_id for given title
  
SELECT 
    COUNT(i.inventory_id)
FROM
    inventory i
WHERE
    film_id = (SELECT 
            f.film_id
        FROM
            film f
        WHERE
            title = 'Hunchback Impossible');


-- 2.List all films whose length is longer than the average of all the films

SELECT 
    f.title, f.length
FROM
    film f
WHERE
    f.length > (SELECT 
            AVG(length)
        FROM
            film);
 
 
-- 3.Use subqueries to display all actors who appear in the film Alone Trip
 
SELECT 
    film_id
FROM
    film f
WHERE
    title IN ('Alone Trip');-- First step:find film_id for the given film
	

	SELECT 
    actor_id
FROM
    film_actor fa
WHERE
    film_id = (SELECT 
            film_id
        FROM
            film f
        WHERE
            title IN ('Alone Trip'));-- Second step:find actor_id 
	
	
	SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM
    actor a
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor fa
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    film f
                WHERE
                    title IN ('Alone Trip')));
	
 -- Solution with join
 
SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM
    film f
        JOIN
    film_actor fa USING (film_id)
        JOIN
    actor a USING (actor_id)
WHERE
    title IN ('Alone Trip');
	
	
-- 4.Sales have been lagging among young families, and you wish to target all family movies for a 
-- promotion. Identify all movies categorized as family films

SELECT 
    f.title
FROM
    film f
        JOIN
    film_category fc USING (film_id)
        JOIN
    category c USING (category_id)
WHERE
    c.name = 'Family';


-- 5.Get name and email from customers from Canada using subqueries. Do the same with joins
-- Note that to create a join, you will have to identify the correct tables with their primary 
-- keys and foreign keys, that will help you get the relevant information

SELECT 
    CONCAT(c2.first_name, ' ', c2.last_name) AS customer,
    c2.email AS email
FROM
    country c
        JOIN
    city ci USING (country_id)
        JOIN
    address a USING (city_id)
        JOIN
    customer c2 USING (address_id)
WHERE
    country = 'Canada';

-- With subquery

SELECT 
    country_id
FROM
    country
WHERE
    country = 'Canada';-- First step:find country_id

SELECT 
    city_id
FROM
    city
WHERE
    country_id = (SELECT 
            country_id
        FROM
            country
        WHERE
            country = 'Canada');-- Second step:find city_id


SELECT 
    address_id
FROM
    address
WHERE
    city_id IN (SELECT 
            city_id
        FROM
            city
        WHERE
            country_id = (SELECT 
                    country_id
                FROM
                    country
                WHERE
                    country = 'Canada'));-- Third step:find address_id


SELECT 
    CONCAT(first_name, ' ', last_name) AS customer, email
FROM
    customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    city
                WHERE
                    country_id = (SELECT 
                            country_id
                        FROM
                            country
                        WHERE
                            country = 'Canada')));



-- 6.Which are films starred by the most prolific actor? Most prolific actor is defined as the 
-- actor that has acted in the most number of films. First you will have to find the most prolific
-- actor and then use that actor_id to find the different films that he/she starred

SELECT 
    actor_id
FROM
    (SELECT 
        actor_id, COUNT(film_id) AS `Number of films`
    FROM
        film_actor fa
    GROUP BY actor_id
    ORDER BY `Number of films` DESC
    LIMIT 1) a;-- First step:find actor_id of most prolific actor

SELECT 
    f.film_id, f.title
FROM
    film f
        JOIN
    film_actor fa USING (film_id)
WHERE
    fa.actor_id = (SELECT 
            actor_id
        FROM
            (SELECT 
                actor_id, COUNT(film_id) AS `Number of films`
            FROM
                film_actor fa
            GROUP BY actor_id
            ORDER BY `Number of films` DESC
            LIMIT 1) AS a);


-- 7.Films rented by most profitable customer. You can use the customer table and payment table to 
-- find the most profitable customer ie the customer that has made the largest sum of payments

SELECT 
    customer_id, SUM(amount)
FROM
    customer c
        JOIN
    payment p USING (customer_id)
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;


SELECT 
    film_id
FROM
    customer c
        JOIN
    payment p USING (customer_id)
        JOIN
    rental r USING (rental_id)
        JOIN
    inventory i USING (inventory_id)
WHERE
    c.customer_id = (SELECT 
            customer_id
        FROM
            (SELECT 
                customer_id, SUM(amount)
            FROM
                customer c
            JOIN payment p USING (customer_id)
            GROUP BY customer_id
            ORDER BY SUM(amount) DESC
            LIMIT 1) AS `Most profitable Customer`);




-- 8.Get the client_id and the total_amount_spent of those clients who spent more than the average
-- of the total_amount spent by each client


SELECT 
    customer_id, SUM(amount) AS `Total Amount`
FROM
    payment
GROUP BY customer_id
HAVING `Total Amount` > (SELECT 
        AVG(amount)
    FROM
        payment);



