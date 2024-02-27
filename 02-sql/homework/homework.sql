-- 1
SELECT * FROM movies
WHERE year = 1993;

-- 2
SELECT year, COUNT(*) AS total_movies
FROM movies
WHERE year = 1982;

-- 3
SELECT *
FROM actors
WHERE last_name LIKE '%stack%';

-- 4
SELECT first_name, last_name, COUNT(*) AS total
FROM actors
GROUP BY LOWER(first_name), LOWER(last_name)
ORDER BY total DESC
LIMIT 10;

-- 5
-- roles        actors
SELECT first_name, last_name, COUNT(*) AS total_roles
FROM actors
JOIN roles ON actors.id = roles.actor_id
GROUP BY actor_id
ORDER BY total_roles DESC
LIMIT 100;

-- 6 
SELECT genre, COUNT(*) AS total_movies
FROM movies_genres
GROUP BY genre
ORDER BY total_movies;

-- 7
-- opción 1
SELECT first_name, last_name
FROM actors
JOIN roles ON actors.id = roles.actor_id
WHERE movie_id IN (
    SELECT id FROM movies
    WHERE name = 'Braveheart' AND year = 1995
)
ORDER BY last_name;

-- opcion 2
SELECT first_name, last_name
FROM actors
JOIN roles ON actors.id = roles.actor_id
JOIN movies ON roles.movie_id = movies.id
WHERE movies.name = 'Braveheart' AND year = 1995
ORDER BY last_name;

-- 8
-- directors    movies_directors      movies    movies_genres
SELECT d.first_name, d.last_name, movies.name AS movie, movies.year
FROM directors AS d
JOIN movies_directors AS md ON d.id = md.director_id
JOIN movies ON md.movie_id = movies.id
JOIN movies_genres AS mg ON mg.movie_id = movies.id
WHERE genre = 'Film-Noir' AND year % 4 = 0
ORDER BY movie;

-- 9
-- actors       roles      movies      movies_genres
SELECT actors.first_name, actors.last_name, movies.name AS movie
FROM actors
JOIN roles ON actors.id = roles.actor_id
JOIN movies ON roles.movie_id = movies.id
JOIN movies_genres AS mg ON movies.id = mg.movie_id
WHERE genre = 'Drama'
AND movies.id IN (
    SELECT movie_id
    FROM roles
    JOIN actors ON roles.actor_id = actors.id
    WHERE first_name = 'Kevin' AND last_name = 'Bacon'
)
AND (actors.first_name || ' ' || actors.last_name) != 'Kevin Bacon';

-- 10
-- actors       roles       movies
SELECT first_name, last_name
FROM actors
WHERE id IN (
    SELECT actor_id
    FROM roles
    JOIN movies ON roles.movie_id = movies.id
    WHERE year < 1900
) AND id IN (
    SELECT actor_id
    FROM roles
    JOIN movies ON roles.movie_id = movies.id
    WHERE year > 2000
);

-- 11
-- actors     roles       movies
SELECT actors.first_name, actors.last_name, movies.name AS movie, COUNT(DISTINCT role) AS total_roles
FROM actors
JOIN roles ON actors.id = roles.actor_id
JOIN movies ON roles.movie_id = movies.id
WHERE year > 1990
GROUP BY actor_id, movie_id
HAVING total_roles >= 5;


-- 12
-- movies       roles       actors 
SELECT year, COUNT(*) AS total_movies
FROM movies
WHERE id NOT IN (
    SELECT movie_id
    FROM roles
    JOIN actors ON roles.actor_id = actors.id
    WHERE actors.gender = 'M'
)
GROUP BY year;
