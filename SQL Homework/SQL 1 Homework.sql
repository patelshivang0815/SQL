use sakila;
-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor;
-- 1b.Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(first_name, " ", last_name) AS "Actor Name" from actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name from actor
where first_name = "JOE";
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor WHERE last_name LIKE '%GEN%';
-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name FROM actor WHERE last_name LIKE '%LI%';
-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country IN ('Afghanistan' , 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor 
ADD COLUMN description BLOB NULL DEFAULT NULL;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor DROP COLUMN description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT DISTINCT last_name, COUNT(last_name) AS 'name_count' FROM actor GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT DISTINCT last_name, COUNT(last_name) AS 'name_count' FROM actor GROUP BY last_name HAVING name_count >= 2;
-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';
-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT 
    staff.first_name, staff.last_name, address.address, city.city, country.country
FROM
    staff
        INNER JOIN
    address ON staff.address_id = address.address_id 
		INNER JOIN
	city ON address.city_id = city.city_id
		INNER JOIN
	country ON city.country_id = country.country_id;
-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT 
    staff.first_name, staff.last_name, SUM(payment.amount) 
FROM
    staff
        INNER JOIN
    payment ON staff.staff_id = payment.staff_id
WHERE
    payment.payment_date LIKE '2005-08%'
GROUP BY payment.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT 
    title, COUNT(actor_id)
FROM
    film
        INNER JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY title;
-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, COUNT(inventory_id) AS number_of_copies FROM film INNER JOIN inventory ON film.film_id = inventory.film_id WHERE title = 'Hunchback Impossible';
-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT last_name, first_name, SUM(amount) AS total_paid FROM payment INNER JOIN customer ON payment.customer_id = customer.customer_id GROUP BY payment.customer_id
ORDER BY last_name ASC;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title FROM film
WHERE language_id IN
	(SELECT language_id 
	FROM language
	WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT a.actor_id, a.first_name, a.last_name, film_actor.film_id, film.title from actor as a 
JOIN film_actor on a.actor_id = film_actor.actor_id
JOIN film on film.film_id = film_actor.film_id
WHERE title = "ALONE TRIP"
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email, country.country from customer
JOIN address on address.address_id = customer.address_id
JOIN city on address.city_id = city.city_id
JOIN country on city.country_id = country.country_id where country = "CANADA"
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title, name from category 
join film_category on category.category_id = film_category.category_id
join film on film_category.film_id = film.film_id where name = "Family";
-- 7e. Display the most frequently rented movies in descending order.
SELECT film.title, COUNT(*) AS 'rent_count'FROM film, inventory, rental WHERE film.film_id = inventory.film_id
        AND rental.inventory_id = inventory.inventory_id
GROUP BY inventory.film_id
ORDER BY COUNT(*) DESC, film.title ASC;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(amount) AS revenue FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN payment ON payment.staff_id = staff.staff_id
GROUP BY store.store_id;
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country FROM store
JOIN address on store.address_id = address.address_id
JOIN city on address.address_id = city.city_id
JOIN country on city.country_id = country.country_id;
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name, SUM(payment.amount) AS gross_revenue FROM category 
JOIN film_category  ON film_category.category_id = category.category_id
JOIN inventory ON inventory.film_id = film_category.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
DROP VIEW IF EXISTS top_five_genres;
CREATE VIEW top_five_genres AS
SELECT name, SUM(payment.amount) AS gross_revenue FROM category 
JOIN film_category  ON film_category.category_id = category.category_id
JOIN inventory ON inventory.film_id = film_category.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;
