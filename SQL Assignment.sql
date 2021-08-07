
-- 1. We want to run an Email Campaigns for customers of Store 2 (First, Last name,
-- and Email address of customers from Store 2)

SELECT first_name, last_name, email FROM customer WHERE store_id = 2;

-- 2. List of the movies with a rental rate of 0.99$

SELECT * FROM film WHERE rental_rate = 0.99;

--3. Your objective is to show the rental rate and how many movies are in each rental
-- rate categories

SELECT rental_rate, count((rental_rate)) As Number_Of_Movies_Under_Rental_Rates FROM film 
GROUP BY rental_rate ORDER BY count((rental_rate)) DESC ; 

--4. Which rating do we have the most films in?

SELECT rating, count(rating) FROM film GROUP BY rating;

--5. Which rating is most prevalent in each store?

SELECT store_id, rating, count(inventory.film_id) As Number_Of_Films  from inventory
inner join  film ON inventory.film_id = film.film_id
GROUP BY store_id, rating ORDER BY count(inventory.film_id) DESC;

--6. We want to mail the customers about the upcoming promotion


--7. List of films by Film Name, Category, Language

SELECT film_list.title , film_list.category, language.name FROM film
INNER JOIN film_list ON film_list.FID = film.film_id
INNER JOIN language ON film.language_id = language.language_id;

--8. How many times each movie has been rented out?

select film.title, count(rental.inventory_id) AS Number_Of_Rentals  FROM rental
INNER JOIN Inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY film.title ORDER BY count(rental.inventory_id) DESC;

--9. What is the Revenue per Movie?

Select film.title ,sum(amount) As Total_Revenue_from_Each_Movie
from payment
INNER JOIN rental ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id 
INNER JOIN film on film.film_id = inventory.film_id
group by film.title order by sum(amount) DESC;

--10.Most Spending Customer so that we can send him/her rewards or debate points

Select customer.customer_id, customer.first_name, customer.last_name, customer.email,sum(amount) As Total_Payment_From_customer
from payment
INNER JOIN customer ON customer.customer_id = payment.customer_id
group by customer_id order by sum(amount) DESC LIMIT 1;

--11. What Store has historically brought the most revenue?

SELECT staff.store_id, sum( amount) FROM payment
INNER JOIN staff ON payment.staff_id=staff.staff_id
GROUP BY staff.store_id ORDER BY sum(amount) DESC LIMIT 1;

--12. How many rentals do we have for each month?

select extract(month from rental_date) , count(rental_id) AS Total_Rentals_For_Each_month from rental
group by extract(month from rental_date);

--13.Rentals per Month (such Jan => How much, etc)

select monthname(rental_date) as Months , count(rental_id) AS Total_Rentals_For_Each_month from rental
group by monthname(rental_date);

--14.Which date the first movie was rented out?

SELECT MIN(rental_date) AS FirstDate FROM rental;

--15.Which date the last movie was rented out?

SELECT MAX(rental_date) AS LastDate FROM rental;

--16.For each movie, when was the first time and last time it was rented out?
 
SELECT DISTINCT(rental.rental_id), film.title as Film_Title, min(rental_date) AS FirstDate,  max(rental_date) AS LastDate FROM rental 
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film on film.film_id = inventory.film_id
GROUP BY rental.rental_id;

--17.What is the Last Rental Date of every customer?

SELECT DISTINCT(rental.customer_id), customer.first_name, customer.last_name,  max(rental_date) AS LastDate FROM rental 
INNER JOIN customer ON customer.customer_id = rental.customer_id
GROUP BY rental.customer_id;

--18.What is our Revenue Per Month?


SELECT extract(month FROM payment_date) , sum(amount) AS Total_Revenue_For_Each_month FROM payment
GROUP BY extract(MONTH FROM payment_date);

--19.How many distinct Renters do we have per month?


SELECT  DISTINCT(Count(customer_id)) As Renters, monthname(rental_date) As Months FROM rental GROUP BY monthname(rental_date)

-- 20.Show the Number of Distinct Film Rented Each Month

SELECT count(DISTINCT(film.film_id)) AS Number_Of_Fims, extract(MONTH FROM rental_date) AS Rental_Month FROM rental 
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film on film.film_id = inventory.film_id
GROUP BY extract(MONTH FROM rental_date);

--21.Number of Rentals in Comedy, Sports, and Family

SELECT count(category.category_id) As Number_Of_Fims, category.name as Name FROM rental 
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film_category on film_category.film_id= inventory.inventory_id
INNER JOIN category on film_category.category_id= category.category_id
GROUP BY category.name;

--22.Users who have been rented at least 3 times

SELECT (count(rental.customer_id)), customer.first_name, customer.last_name FROM rental 
INNER JOIN customer ON customer.customer_id = rental.customer_id
GROUP BY rental.customer_id
HAVING count(rental.customer_id) >= 3
ORDER BY count(rental.customer_id) DESC;

--23.How much revenue has one single store made over PG13 and R-rated films?

SELECT staff.store_id, sum(amount) AS Total_Revenue_For_Each_Store_For_PG13_And_R_Films FROM payment
INNER JOIN staff ON  payment.staff_id = staff.staff_id
INNER JOIN rental ON payment.rental_id = rental.rental_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
WHERE film.rating = 'PG-13' OR film.rating ='R'
GROUP BY staff.store_id 
ORDER BY sum(amount) ASC;

--24.Active User where active = 1

select * from customer where active = 1;

--25.Reward Users: who has rented at least 30 times

SELECT (count(rental.customer_id)), customer.first_name, customer.last_name FROM rental 
INNER JOIN customer ON customer.customer_id = rental.customer_id
GROUP BY rental.customer_id
HAVING count(rental.customer_id) >= 30
ORDER BY count(rental.customer_id) DESC;

--26.Reward Users who are also active

SELECT  DISTINCT(customer.first_name), customer.last_name, customer.active FROM rental 
INNER JOIN customer ON customer.customer_id = rental.customer_id
HAVING  customer.active = 1

--27.All Rewards Users with Phone

select * from customer where address_id IN (select address_id from address where phone is not null);