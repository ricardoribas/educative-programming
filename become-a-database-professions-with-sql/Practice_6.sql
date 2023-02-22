-- PRACTICE SET 6
-- https://www.educative.io/module/page/JZmo10C1K3V0gqV0w/10370001/5844917766586368/6298497074069504

-- Exercise 1: Find the top two movies of distributors who have more than one movie to their name
SET @current_rank = 0, @current_distributor = "";
SELECT M.Distributor, M.Name, M.CollectionInMillions, 
    @current_rank := IF(@current_distributor = M.Distributor, @current_rank + 1, 1) AS Rank,
    @current_distributor := M.Distributor as TmpDistributor
FROM Movies as M
ORDER BY M.Distributor
WHERE current_rank <= 2;

-- Exercise 2: Find the total, average, minimum and maximum of the production
-- budget and revenue earned from the Movies table and append the summary data to the top of the table.
SELECT "Total", SUM(BudgetInMillions) AS BudgetInMillions, SUM(CollectionInMillions) AS CollectionInMillions FROM Movies
UNION
SELECT "Average", AVG(BudgetInMillions) AS BudgetInMillions, AVG(CollectionInMillions) AS CollectionInMillions FROM Movies
UNION
SELECT "Maximum", MAX(BudgetInMillions) AS BudgetInMillions, MAX(CollectionInMillions) AS CollectionInMillions FROM Movies
UNION
SELECT "Minimum", MIN(BudgetInMillions) AS BudgetInMillions, MIN(CollectionInMillions) AS CollectionInMillions FROM Movies
UNION
SELECT M.Name, SUM(M.BudgetInMillions), SUM(M.CollectionInMillions)
FROM Movies AS M
GROUP BY M.Name
ORDER BY M.Name;

-- Exercise 3: Calculate the mean median and mode of the running time of movies
(SELECT "Mean" AS Measure, ROUND(AVG(M.RunningTime), 2) AS Value 
    FROM Movies AS M)
UNION
(SELECT "Median" AS Measure, RunningTime AS Value
    FROM (SELECT @row_num := @row_num + 1 AS RowNumber, RunningTime
            FROM Movies, (SELECT @row_num := 0) AS TmpIncrementor
            ORDER BY RunningTime) AS M
    WHERE M.RowNumber IN (FLOOR((@row_num + 1) / 2), CEIL((@row_num + 1) / 2)))
UNION
(SELECT "Mode" AS Measure, (SELECT M.RunningTime
    FROM Movies AS M
    GROUP BY M.RunningTime
    ORDER BY COUNT(M.RunningTime) DESC
    LIMIT 1) AS Value);

-- Exercise 4: Find the correlation between budget, collection 
-- and running time of movies and display the results as a table.
-- NOTE: Too much information for a single exercis

-- Exercise 5: Find the market share of top 3 distributors and aggregate the remaining distributors in a single row.
CREATE OR REPLACE VIEW TopThreeDistributors AS (
    SELECT M.Distributor, SUM(M.CollectionInMillions) AS TotalCollection
    FROM Movies as M
    GROUP BY M.Distributor
    ORDER BY SUM(M.CollectionInMillions) DESC
    LIMIT 3
);

(SELECT * FROM TopThreeDistributors)
UNION
(SELECT "All Others", SUM(M.CollectionInMillions) AS TotalCollection
FROM Movies as M
WHERE M.Distributor NOT IN (SELECT TTD.Distributor FROM TopThreeDistributors AS TTD));
