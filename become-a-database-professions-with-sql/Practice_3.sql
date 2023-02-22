-- PRACTICE SET 3
-- https://www.educative.io/module/page/JZmo10C1K3V0gqV0w/10370001/5844917766586368/6327951666184192

-- Exercise 1: Write a query to display all those movie titles whose budget is greater than the average budget of all the movies.
SELECT Name 
FROM Movies
WHERE BudgetInMillions > (SELECT AVG(BudgetInMillions) 
                          FROM Movies);

-- Exercise 2: Find all those actors who don’t have any digital media presence using a right join statement.
SELECT CONCAT(A.FirstName, ' ', A.SecondName)
AS Actors_With_No_Online_Presence
FROM DigitalAssets AS DA
RIGHT JOIN Actors AS A
ON A.Id = DA.ActorId
WHERE URL IS NULL;

-- Exercise 3: Can you rewrite the previous query without a join and using EXISTS operator?
SELECT CONCAT(A.FirstName, ' ', A.SecondName) as Actors_With_No_Online_Presence
FROM Actors as A
WHERE NOT EXISTS (
    SELECT ActorId 
    FROM DigitalAssets as DA 
    WHERE A.Id = DA.ActorId);

-- Exercise 4: Write a query to print the name of the fifth highest grossing movie at the box office.
SELECT M.Name, M.CollectionInMillions as Collection_In_Millions
FROM Movies as M
ORDER BY M.CollectionInMillions DESC
LIMIT 1 OFFSET 4;

-- Exercise 5: Find those movies, whose cast latest activity on social media occurred between the span of 5 days before and 5 days after the release date.
SELECT CONCAT(A.FirstName, ' ', A.SecondName) as Actors_Posting_Online_Within_Five_Days_Of_Movie_Release
FROM Actors as A
INNER JOIN (SELECT C.ActorId, M.Name 
            FROM Movies as M 
            INNER JOIN Cast as C
            ON M.Id = C.MovieId
            WHERE C.ActorId IN (
                SELECT ActorId 
                FROM DigitalAssets 
                WHERE DATEDIFF(M.ReleaseDate, LastUpdatedOn) >= -5 
                    AND DATEDIFF(M.ReleaseDate, LastUpdatedOn) <= 5)) as T
ON A.Id = T.ActorId;