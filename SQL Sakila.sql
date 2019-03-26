-- Question 1a : first and last names of all actors from the table actor
use sakila;
select first_name, last_name from actor;

/*Question 1b : first and last name of each actor in a single column in upper case letters; name the column Actor Name.
concat ex) SELECT CONCAT("SQL ", "Tutorial ", "is ", "fun!") AS ConcatenatedString; */
use sakila;
select concat(first_name," ", last_name) as actor_name
from actor;

-- Question 2a : Query first/last name, actor_id for first name "Joe"
use sakila;
select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters `GEN`:
use sakila;
select actor_id, first_name, last_name
from actor
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
use sakila;
select actor_id, first_name, last_name
from actor
where last_name like '%LI%'
order by last_name, first_name;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select c.country_id, c.country
from country c
where c.country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. create a column in the table `actor` named `description` and use the data type `BLOB`
use sakila; 
alter table actor
add column description blob; 

-- 3b. drop 'description' column
alter table actor
drop column description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as "Last Name Count"
from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, shared by at least two actors
use sakila; 

select last_name
, count(last_name) as "Last Name Count"
from actor
group by last_name
having count(*) >= 2; 

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor
set first_name = 'Harpo'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d.  In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
 update actor
 set first_name = 
 case 
 when first_name = 'HARPO' 
 then 'GROUCHO'
 else 'MUCHO GROUCHO'
 end
 where actor_id = 172;
 
 -- 5a. recreate address table 	address
 create table sakila_address(
	`address_id` smallint(5) NOT NULL AUTO_INCREMENT,
	`address` varchar(50) NOT NULL,
	`address2` varchar(50) DEFAULT NULL,
	`district` varchar(20) NOT NULL,
	`city_id` smallint(5)  NOT NULL,
	`postal_code` varchar(10) DEFAULT NULL,
	`phone` varchar(20) NOT NULL,
	`location` geometry NOT NULL,
	`last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	primary key (`address_id`))

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select s.first_name, s.last_name, a.address
from staff s 
left join address a on s.address_id = a.address_id; 

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
use sakila;
select s.first_name, s.last_name, sum(p.amount) as "Total Amount Paid"
from staff s
inner join payment p
on s.staff_id = p.staff_id
group by p.staff_id
order by last_name asc;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title, count(fa.actor_id)
from film f
inner join film_actor fa
on f.film_id = fa.film_id
group by title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select f.title, count(i.inventory_id)
from film f
inner join inventory i 
on f.film_id = i.film_id
where title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select c.first_name, c.last_name, sum(p.amount)
from payment p
inner join customer c
on p.customer_id = c.customer_id
group by p.customer_id
order by last_name asc;

-- 7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select f.title 
from film f
inner join language l on f.language_id = l.language_id 
where name = "English" and (title like "K%") or (title like "Q%");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select a.first_name, a.last_name
from film f
	inner join film_actor fa on fa.film_id = f.film_id
	inner join actor a on a.actor_id = fa.actor_id
where title = 'Alone Trip';

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
use sakila; 
select cust.first_name, cust.last_name, cust.email
from customer cust
inner join address a on a.address_id = cust.address_id 
inner join city on city.city_id = a.city_id
inner join country c on c.country_id = city.country_id 
where country = "Canada"; 

-- 7d. Identify all movies categorized as family films.
select f.title
from film f
inner join film_category fc on fc.film_id = f.film_id
inner join category c on c.category_id = fc.category_id
where name = "family"; 

-- 7e. Display the most frequently rented movies in descending order.
use sakila; 
select f.title, count(r.inventory_id) as "Rental Count"
from film f 
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
group by f.title
order by count(r.inventory_id) desc; 

-- 7f. Write a query to display how much business, in dollars, each store brought in.
use sakila; 
select s.store_id, sum(p.amount) as "Total Revenue"
from store s
inner join staff st on st.store_id = s.store_id
inner join payment p on p.staff_id = st.staff_id
group by s.store_id
order by sum(p.amount);

-- 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, city, country
from store s
inner join customer cu on s.store_id = cu.store_id
inner join staff st on s.store_id = st.store_id
inner join address a on cu.address_id = a.address_id
inner join city ci on a.city_id = ci.city_id
inner join country coun on ci.country_id = coun.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
select c.name, sum(p.amount)
from category c
inner join film_category fc on c.category_id = fc.category_id
inner join inventory i on i.film_id = fc.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner  join payment p on p.rental_id = r.rental_id
group by c.name
LIMIT 5;

-- 8a.  Use the solution from the problem above to create a view.
create view top_five_grossing_genres as 

select c.name, sum(p.amount)
from category c
inner join film_category fc on c.category_id = fc.category_id
inner join inventory i on i.film_id = fc.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner  join payment p on p.rental_id = r.rental_id
group by c.name
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
select * from top_five_grossing_genres;

-- 8c. Write a query to delete it.
drop view top_five_grossing_genres;