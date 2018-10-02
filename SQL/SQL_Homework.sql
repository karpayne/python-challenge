-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from sakila.actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name," ",last_name) as 'Actor Name' from sakila.actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
select actor_id, first_name, last_name from sakila.actor where first_name like '%Joe%';

-- 2b. Find all actors whose last name contain the letters GEN:
select first_name, last_name from sakila.actor where last_name like '%Gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select first_name, last_name from sakila.actor where last_name like '%li%' order by last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from sakila.country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE `sakila`.`actor` ADD COLUMN `description` BLOB NULL AFTER `last_update`;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) from sakila.actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) from sakila.actor group by last_name having count(*) >1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
-- select first_name, last_name from sakila.actor where first_name ='GROUCHO' and last_name ='WILLIAMS';
SET SQL_SAFE_UPDATES = 0;
update sakila.actor set first_name ='HARPO' where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update sakila.actor set first_name ='GROUCHO' where first_name = 'HARPO' and last_name = 'WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select s.first_name, s.last_name, a.address
from sakila.staff s
inner join sakila.address a on s.address_id=a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.staff_id, sum(amount)
from sakila.staff s 
inner join sakila.payment p on s.staff_id=p.staff_id
where ((payment_date >='09/01/2005') and (payment_date <= '09/30/2005'))
group by s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title, count(actor_id) as 'Count'
from sakila.film f 
inner join sakila.film_actor fa on f.film_id=fa.film_id
group by f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(inventory_id)
from sakila.film f
inner join sakila.inventory i on f.film_id=i.film_id
where f.title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name:
select c.customer_id, c.last_name, c.first_name, sum(amount) as 'Total Paid by Customer'
from sakila.customer c
inner join payment p on c.customer_id=p.customer_id
group by c.customer_id, c.last_name, c.first_name
order by c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select f.title
 from sakila.film f inner join sakila.language l on f.language_id = l.language_id where ((title like ('K%') and l.name = 'English')
 or 
 (title like ('Q%') and l.name = 'English'));
 
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM sakila.film_actor
  WHERE film_id IN
  (
   SELECT film_id
   FROM sakila.film
   WHERE title = 'Alone Trip'
  )
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select c.first_name, c.last_name, c.email
from sakila.customer c
inner join sakila.address a on c.address_id=a.address_id
inner join sakila.city ci on ci.city_id = a.city_id
inner join sakila.country co on co.country_id = ci.country_id
where co.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select f.title, c.name
from sakila.film f 
inner join sakila.film_category fc on f.film_id=fc.film_id
inner join sakila.category c on c.category_id = fc.category_id
where c.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
select f.title, count(rental_id)
from sakila.rental r 
inner join sakila.inventory i on r.inventory_id = i.inventory_id 
inner join sakila.film f on f.film_id = i.film_id 
group by f.title
 asc;
 
-- 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(amount) as 'Dollars'
from sakila.store s 
inner join sakila.staff st on s.store_id = st.store_id 
inner join sakila.payment p on st.staff_id = p.staff_id 
group by s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, c.city, co.country
from sakila.store s 
inner join sakila.address a on s.address_id = a.address_id
inner join sakila.city c on a.city_id = c.city_id
inner join sakila.country co on c.country_id= co.country_id ;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select ca.name, sum(amount)

from sakila.inventory i 
inner join sakila.rental r on r.inventory_id = i.inventory_id
inner join sakila.payment p on p.rental_id = r.rental_id
inner join sakila.film_category fc on fc.film_id = i.film_id
inner join sakila.category ca on fc.category_id = ca.category_id
group by ca.name;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view Executive as 
select ca.name, sum(amount)
from sakila.inventory i 
inner join sakila.rental r on r.inventory_id = i.inventory_id
inner join sakila.payment p on p.rental_id = r.rental_id
inner join sakila.film_category fc on fc.film_id = i.film_id
inner join sakila.category ca on fc.category_id = ca.category_id
group by ca.name;

-- 8b. How would you display the view that you created in 8a?
select * from sakila.executive;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view sakila.executive;










