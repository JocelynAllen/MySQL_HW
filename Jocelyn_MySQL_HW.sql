USE sakila; 

#1A first and last names of all actors from the table actor
SELECT first_name, last_name FROM actor;  

#1B upper case, rename column
SELECT concat_ws(" ", `first_name`,`last_name`) AS 'Actor Name' FROM actor; 

#2A ID, first name, last name of actor with first name Joe
SELECT actor_id, first_name, last_name  FROM actor 
WHERE first_name = "Joe"; 

#2B last name contain gen
SELECT first_name, last_name  FROM actor 
WHERE last_name LIKE '%gen%'; 

#2C last name contain 'li' order by
SELECT first_name, last_name  FROM actor 
WHERE last_name LIKE '%li%'
ORDER BY last_name, first_name; 

#2D use IN to display Afghanistan, Bangladesh and China
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China'); 

#3A add description column as BLOB 
ALTER TABLE actor
	ADD description BLOB; 
 SELECT first_name, last_name, description FROM actor;    
 
    
 #3B delete description
 ALTER TABLE actor
	DROP COLUMN description;
    
#4A list last names and how many with that last name
SELECT last_name,
COUNT(last_name)
FROM actor
GROUP BY last_name;



#4B list names and counts of actor last names if more than 2 actors
SELECT last_name,
COUNT(last_name) AS last_name_count
FROM actor
GROUP BY last_name
HAVING last_name_count >= 2;




#4C HARPO WILLIAMS to GROUCHO WILLIAMS using query
UPDATE actor 
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS'; 



#4D change to either HARPO or MUCHO with unique identifier

SELECT * FROM actor; 

UPDATE actor 
SET first_name = 'GROUCHO' 
WHERE actor_id = 172; 



#5A can't locate the schema for address - did not run as don't want to overright current values 
DESC address; 
DROP TABLE IF EXISTS address; 
CREATE TABLE address (
address_id SMALLINT(5) AUTO_INCREMENT NOT NULL, 
address VARCHAR(50), 
address2 VARCHAR(50) , 
district VARCHAR(20), 
city_id SMALLINT(5), 
postal_code VARCHAR(10), 
phone VARCHAR(20), 
location GEOMETRY, 
last_update TIMESTAMP, 
PRIMARY KEY(address_id)
);



#6A use join first and last name and address of staff 
SELECT staff.first_name, staff.last_name, address.address
FROM address 
JOIN staff ON
staff.address_id = address.address_id; 

#6B use join to display total rung by each staff in Aug 2005 
SELECT staff.first_name, staff.last_name, payment.amount
FROM staff
JOIN payment ON 
staff.staff_id = payment.staff_id 
WHERE payment.payment_date BETWEEN '2005-08-01' AND '2005-08-31'; 



#6C film and number of actors  

SELECT film.title, 
COUNT(film_actor.actor_id) AS Number_of_Actors_in_Film
FROM film_actor
JOIN film ON
film.film_id = film_actor.film_id
GROUP BY film.title;


#6D copies of Hunchback Impossible  
SELECT COUNT(*)
FROM inventory 
WHERE film_id IN

(SELECT film_id
FROM film
WHERE title = 'Hunchback Impossible');


#6E total paid by each customer, list alpha by last name  

SELECT customer.last_name, customer.first_name,
SUM(payment.amount) AS Customer_Total_Pmt
FROM payment
JOIN customer ON
customer.customer_id = payment.customer_id
GROUP BY customer.last_name, customer.first_name
ORDER BY customer.last_name ASC;

#7A Q'ueen' and K'ris Kristofferson'  and in English

	SELECT title
	FROM film
	WHERE (
    title LIKE 'K%' OR 
    title LIKE 'Q%' AND 
    language_id IN
		(
		SELECT language_id
		FROM language
		WHERE name = 'English'));


#7B subquery all actors in Alone Trip 

SELECT first_name, last_name FROM actor
WHERE actor_id IN
    (
	SELECT actor_id
	FROM actor 
	WHERE actor_id IN	
    
    (
	SELECT actor_id
	FROM film_actor 
	WHERE film_id IN
		(
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip')));



#7C names and email of all Canadian customers  
SELECT customer.first_name, customer.last_name, customer.email 
FROM customer 
JOIN address ON
customer.address_id = address.address_id
JOIN city ON  
address.city_id = city.city_id
JOIN country ON
city.country_id = country.country_id
WHERE country = 'Canada' ;


#7D all movies categorized as family films  

SELECT title FROM film
WHERE film_id IN
	(
	SELECT film_id
	FROM film_category 
	WHERE category_id IN
		(
		SELECT category_id
		FROM category
		WHERE name = 'Family'));
        


#7E most frequently rented movies in descending order 

SELECT title,
SUM(rental_rate) AS 'Number_of_Rentals'
FROM film
GROUP BY title
ORDER BY Number_of_Rentals DESC; 


#7F query how much business in $ each store bought in 

SELECT  store.store_id, 
SUM(payment.amount) 
FROM payment
JOIN staff ON
payment.staff_id = staff.staff_id
JOIN store ON
staff.store_id = store.store_id
GROUP BY store.store_id; 


#7G query to display for each store its store id, city and country 
SELECT store.store_id,  city.city, country.country
From store
JOIN customer ON
store.store_id = customer.store_id
JOIN address ON
customer.address_id = address.address_id
JOIN city ON
address.city_id = city.city_id
JOIN country ON
city.country_id = country.country_id
ORDER BY store.store_id ASC;


#7H top 5 genres in gross revenue in descending order 
SELECT category.name,
SUM(payment.amount) AS Gross_Revenue
FROM payment
Join rental ON
payment.customer_id = rental.customer_id
JOIN inventory ON
rental.inventory_id = inventory.inventory_id
JOIN film_category ON
inventory.film_id = film_category.film_id
JOIN category ON
film_category.category_id = category.category_id
GROUP BY name
ORDER BY Gross_Revenue DESC
LIMIT 5;


#8A view: top 5 genres by gross revenue (top_five_genres) 
CREATE VIEW top_five_genres AS
SELECT category.name,
SUM(payment.amount) AS Gross_Revenue
FROM payment
Join rental ON
payment.customer_id = rental.customer_id
JOIN inventory ON
rental.inventory_id = inventory.inventory_id
JOIN film_category ON
inventory.film_id = film_category.film_id
JOIN category ON
film_category.category_id = category.category_id
GROUP BY name
ORDER BY Gross_Revenue DESC
LIMIT 5; 


#8B display the view from 8A 

SELECT * FROM top_five_genres; 



#8C write a query to delete  (top_five_genres) 

DROP VIEW top_five_genres;



