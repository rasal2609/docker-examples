use sakila;

select first_name, last_name, title 
	from actor a, film f, film_actor fa
		where a.actor_id = fa.actor_id
        and fa.film_id = f.film_id;