                               -- Lab | SQL Subqueries
					 
-- Instructions
						
						
-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?

  select f.film_id
  from film f
  WHERE title = 'Hunchback Impossible';  -- First step:find film_id for given title
  
  select count(i.inventory_id)
  from inventory i
  where film_id = 
  (select f.film_id
  from film f
  WHERE title = 'Hunchback Impossible'); 


-- 2.List all films whose length is longer than the average of all the films

 select f.title,f.length
 from film f
 where f.length >
 (select avg(length)
 from film);
 
 
-- 3.Use subqueries to display all actors who appear in the film Alone Trip
 
 -- Solution with subquery
	
	select film_id 
	from film f
	where title IN ('Alone Trip');      -- First step:find film_id for the given film
	

	select actor_id 
	from film_actor fa
	where film_id = 
	(select film_id 
	from film f
	where title IN ('Alone Trip'));   -- Second step:find actor_id 
	
	
	select concat(a.first_name, ' ', a.last_name) as actor
	from actor a
	where actor_id IN 
	(select actor_id 
	from film_actor fa
	where film_id = 
	(select film_id 
	from film f
	where title IN ('Alone Trip')));
	
 -- Solution with join
 
 select concat(a.first_name, ' ', a.last_name) as actor
 from film f
 join film_actor fa
 using (film_id)
 join actor a
 using (actor_id)
 where title IN ('Alone Trip');
	
	
-- 4.Sales have been lagging among young families, and you wish to target all family movies for a 
-- promotion. Identify all movies categorized as family films

 select f.title
 from film f
 join film_category fc
 using(film_id)
 join category c
 using(category_id)
 where c.name = 'Family'; 


-- 5.Get name and email from customers from Canada using subqueries. Do the same with joins
-- Note that to create a join, you will have to identify the correct tables with their primary 
-- keys and foreign keys, that will help you get the relevant information

-- With join:

select concat(c2.first_name, ' ', c2.last_name) as customer,c2.email as email
from country c
join city ci
using(country_id)
join address a
using(city_id)
join customer c2 
using(address_id)
where country = 'Canada';

-- With subquery

select country_id 
from country
where country = 'Canada';  -- First step:find country_id

select city_id 
from city
where country_id = 
(select country_id 
from country
where country = 'Canada'); -- Second step:find city_id


select address_id 
from address
where city_id IN  
(select city_id 
from city
where country_id = 
(select country_id 
from country
where country = 'Canada'));  -- Third step:find address_id


select concat(first_name, ' ', last_name) as customer,email
from customer  
where address_id IN 
(select address_id 
from address
where city_id IN  
(select city_id 
from city
where country_id = 
(select country_id 
from country
where country = 'Canada')));



-- 6.Which are films starred by the most prolific actor? Most prolific actor is defined as the 
-- actor that has acted in the most number of films. First you will have to find the most prolific
-- actor and then use that actor_id to find the different films that he/she starred

select actor_id 
from (select actor_id,count(film_id) as `Number of films`
from film_actor fa
group by actor_id
Order by `Number of films` desc
Limit 1)a;                           -- First step:find actor_id of most prolific actor

select f.film_id,f.title
from film f
join film_actor fa
using(film_id)
where fa.actor_id = 
(select actor_id 
from (select actor_id,count(film_id) as `Number of films`
from film_actor fa
group by actor_id
Order by `Number of films` desc
Limit 1)as a);


-- 7.Films rented by most profitable customer. You can use the customer table and payment table to 
-- find the most profitable customer ie the customer that has made the largest sum of payments

select customer_id,sum(amount)
from customer c
join payment p
using (customer_id)
group by customer_id
Order by sum(amount)desc
Limit 1;


select film_id
from customer c
join payment p  
using(customer_id)
join rental r 
using(rental_id)
join inventory i 
using(inventory_id)
where c.customer_id = (select customer_id from(select customer_id,sum(amount) 
											   from customer c
                                               join payment p
                                               using (customer_id)
                                               group by customer_id
                                               Order by sum(amount)desc
                                               Limit 1)as `Most profitable Customer`);




-- 8.Get the client_id and the total_amount_spent of those clients who spent more than the average
-- of the total_amount spent by each client


select customer_id,sum(amount) as `Total Amount`
from payment
group by customer_id
having `Total Amount` > (select avg(amount) from payment);



