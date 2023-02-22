-- PRACTICE SET 2
-- https://www.educative.io/module/page/JZmo10C1K3V0gqV0w/10370001/5844917766586368/5313222558613504

-- Exercise 1: Write a query to display all those actors who have acted in 2 or more movies.
SELECT CONCAT(FirstName, ' ', SecondName) AS Actor_Names 
FROM Actors
INNER JOIN Cast 
ON Id = ActorId 
GROUP BY Id HAVING COUNT(MovieId) >= 2;

-- Exercise 2: Find the cast of movie Mr and Mrs. Smith without using joins.
SELECT CONCAT(A.FirstName, ' ', A.SecondName)
FROM Movies as M, Cast as C, Actors as A
WHERE M.Id = C.MovieId 
    AND A.Id = C.ActorId
    AND M.Name = "Mr & Mrs. Smith";

-- Exercise 3: Print a list of movies and the actor(s) who participated in each movie ordered by movie name.
SELECT M.Name, CONCAT(A.FirstName, ' ', A.SecondName)
FROM Movies as M, Cast as C, Actors as A
WHERE M.Id = C.MovieId AND A.Id = C.ActorId
ORDER BY M.Name;

-- Exercise 4: Print the count of actors in each movie.
SELECT M.Name, COUNT(*)
FROM Movies as M INNER JOIN Cast as C
ON M.Id = C.MovieId
GROUP BY M.Name;

-- Exercise 5: List the names of Producers who never produced a movie for Tom Cruise.
SELECT DISTINCT Producer AS Producer_Never_Worked_With_Tom
FROM Movies 
WHERE Producer NOT IN (SELECT Producer
                        FROM Movies as M, Cast as C, Actors as A
                        WHERE M.Id = C.MovieId 
                            AND A.Id = C.ActorId
                            AND CONCAT(A.FirstName, ' ', A.SecondName) = 'Tom Cruise');