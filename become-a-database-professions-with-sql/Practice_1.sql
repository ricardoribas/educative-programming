-- PRACTICE SET 1
-- https://www.educative.io/module/page/JZmo10C1K3V0gqV0w/10370001/5844917766586368/6127188411154432

-- Exercise 1: Write a query that prints the top three movies by box office collection?
SELECT Name FROM Movies ORDER BY CollectionInMillions LIMIT 3;

-- Exercise 2: Can you write a query to determine if any two actors share the same second name?
SELECT A1.FirstName, A1.SecondName
FROM Actors AS A1 
INNER JOIN Actors AS A2 
ON A1.SecondName = A2.SecondName
WHERE A1.Id != A2.Id;

-- Exercise 3: Write a query to count the number of actors who share the same second name. Print the second name along with the count.
SELECT A1.SecondName AS Actors_With_Shared_SecondNames, COUNT(A2.SecondName)
FROM Actors as A1, Actors as A2
WHERE A1.ID != A2.Id AND A1.SecondName = A2.SecondName
GROUP BY A1.SecondName;

-- Exercise 4: Write a query to display all those actors who have acted in at least one movie.
SELECT * 
FROM Actors 
WHERE Id IN (
    SELECT ActorId 
    FROM Cast 
    GROUP BY ActorId 
    HAVING COUNT(MovieId) > 1);

SELECT DISTINCT CONCAT(FirstName, " ", SecondName) AS Actors_Acted_In_Atleast_1_Movies 
FROM Actors
INNER JOIN Cast
ON Id = ActorId;

-- Exercise 5: As a corollary to the previous question, can you find the different ways of 
-- listing those aspiring actors who haven’t acted in any movie yet?
SELECT * 
FROM Actors 
WHERE Id NOT IN (
    SELECT ActorId 
    FROM Cast 
    GROUP BY ActorId 
    HAVING COUNT(MovieId) > 0);

SELECT Id, CONCAT(FirstName, " ", SecondName) AS Actors_With_No_Movies
FROM Actors
WHERE Id NOT IN (SELECT Id 
                 FROM Actors
                 INNER JOIN Cast
                 ON Id = ActorId);

SELECT CONCAT(FirstName, " ", SecondName)  AS Actors_With_No_Movies 
FROM Actors
LEFT JOIN Cast
ON Id = ActorId
WHERE MovieId IS NULL;


