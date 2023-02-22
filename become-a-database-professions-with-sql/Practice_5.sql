-- PRACTICE SET 5
-- https://www.educative.io/module/page/JZmo10C1K3V0gqV0w/10370001/5844917766586368/5026739381600256

-- Exercise 1: Calculate the running total of the revenue generated per week 
-- for the first 10 weeks for the movie Avengers.

SELECT MS1.Weekend AS Weekend, MS1.RevenueInMillions AS RevenueInMillions, SUM(MS2.RevenueInMillions) AS RunningTotal
FROM MovieScreening AS MS1 INNER JOIN MovieScreening AS MS2
ON MS1.MovieId = MS2.MovieId
WHERE MS1.MovieId = (SELECT Id
                    FROM Movies AS M
                    WHERE Name LIKE '%Avengers%'
                    LIMIT 1)
    AND MS1.Weekend >= MS2.Weekend
GROUP BY MS1.Weekend, MS1.RevenueInMillions
ORDER BY MS1.Weekend ASC;

-- Exercise 2: Calculate the total revenue of each Genre and find the percentage of revenue of each
SELECT M.Genre as Genre, SUM(MS.RevenueInMillions) AS TotalRevenueInMillions, (
    SELECT SUM(MS.RevenueInMillions) / SUM(MS2.RevenueInMillions) * 100
    FROM MovieScreening AS MS2) AS "%OfTotalRevenues"
FROM Movies AS M INNER JOIN MovieScreening AS MS
ON M.Id = MS.MovieId
GROUP BY Genre;

-- Exercise 3: Calculate the moving average of revenue generated in a three week window for the movie Ocean’s 11

SELECT M.Name, M.Id
FROM Movies AS M
WHERE Name LIKE "%Ocean\'s 11%";

SELECT MS1.Weekend, MS1.RevenueInMillions, SUM(MS2.RevenueInMillions) AS "3 Week Total", AVG(MS2.RevenueInMillions) AS "3 Week Avg"
FROM MovieScreening AS MS1, MovieScreening AS MS2
WHERE  MS1.MovieId = MS2.MovieId AND
        MS1.MovieId IN (SELECT M.Id
                    FROM Movies AS M
                    WHERE Name LIKE "%Ocean\'s 11%") AND
        WEEK(MS2.Weekend, 0) <= WEEK(MS1.Weekend, 0) + 3 AND
        WEEK(MS2.Weekend, 0) >= WEEK(MS1.Weekend, 0)
GROUP BY MS1.Weekend, MS1.RevenueInMillions
ORDER BY MS1.Weekend DESC;

-- Exercise 4: Find the value of RevenueInMillions at the start of each month for the movie Mr. & Mrs. Smith

SELECT MS.Weekend AS Date, MONTH(MS.Weekend) AS Month, MS.RevenueInMillions AS RevenueInMillions, (
    SELECT MS2.RevenueInMillions FROM MovieScreening AS MS2
    WHERE MONTH(MS2.Weekend) = MONTH(MS.Weekend)
    ORDER BY MS2.Weekend ASC
    LIMIT 1
) AS FirstValue
FROM Movies AS M INNER JOIN MovieScreening AS MS
ON M.Id = MS.MovieId
WHERE M.Id = (SELECT M.Id 
                FROM Movies AS M 
                WHERE Name LIKE "%Smith%")
ORDER BY MS.Weekend ASC;

-- Exercise 5: Calculate the monthly growth rate of revenue for the movie Mission Impossible
-- NOTE: I was not able to finish this one as it was so damn hard
SELECT MONTH(MS1.Weekend) as Month, SUM(MS1.RevenueInMillions) as "Total Revenue In Millions", 
    (SELECT (SUM(MS2.RevenueInMillions) - SUM(MS1.RevenueInMillions)) / (100 * SUM(MS1.RevenueInMillions))
    FROM MovieScreening AS MS2 
    WHERE MONTH(MS2.Weekend) = MONTH(MS1.Weekend) - 1) AS "Growth %"
FROM MovieScreening AS MS1
WHERE MS1.MovieId = (SELECT M.Id 
                FROM Movies AS M 
                WHERE Name LIKE "%Impossible%")
GROUP BY MONTH(MS1.Weekend)
ORDER BY Month;

-- SOLUTION: Just genious
SELECT Month, TotalRevenueInMillions, 
       IF(@PrevVal = 0, 0, ROUND(((TotalRevenueInMillions - @PrevVal) / @PrevVal) * 100, 2))  "Growth %",
       @PrevVal := TotalRevenueInMillions         
FROM
      ( SELECT @PrevVal := 0) d1,
      ( SELECT MONTH(Weekend) AS Month, 
               SUM(RevenueInMillions) as TotalRevenueInMillions 
        FROM MovieScreening 
        WHERE MovieId = 3 
        GROUP BY MONTH(Weekend) ) d2;