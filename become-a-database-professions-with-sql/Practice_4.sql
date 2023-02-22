-- PRACTICE SET 4
-- https://www.educative.io/module/page/JZmo10C1K3V0gqV0w/10370001/5844917766586368/6146660022878208

-- Exercise 1: Write a query to display the average collection in millions of 
-- producers who have produced more than one movie

SELECT Producer as Producer_Name, 
    AVG(CollectionInMillions) as Average_Collection_In_Millions
FROM Movies
GROUP BY Producer
HAVING COUNT(Id) > 1;

-- Exercise 2: Find all those actors who have not worked with producer Ryan Seacrest.

SELECT DISTINCT CONCAT(A.FirstName, ' ', A.SecondName) as Actors_Who_Not_Worked_With_Ryan_Seacrest
FROM Actors AS A
INNER JOIN (SELECT *
            FROM Movies AS M
            INNER JOIN Cast AS C
            ON M.Id = C.MovieId
            WHERE M.Id NOT IN (SELECT Id 
                                FROM Movies
                                WHERE Producer = 'Ryan Seacrest')) as tmpTable
ON A.Id = tmpTable.ActorId;

-- Exercise 3: Populate a table DigitalActivityTrack with the last digital 
-- activity of each actor along with the asset type on which the activity occurred.

CREATE VIEW DigitalActivityTrack
AS (SELECT DA1.ActorId as Actor_Name, DA1.AssetType as Digital_Asset, DA1.LastUpdatedOn as Last_Updated_At
    FROM DigitalAssets AS DA1
    INNER JOIN (SELECT ActorId, MAX(LastUpdatedOn) as LastUpdatedOn
                FROM DigitalAssets 
                GROUP BY ActorId) AS DA2
    WHERE DA1.ActorId = DA2.ActorId
        AND DA1.LastUpdatedOn = DA2.LastUpdatedOn);

-- Exercise 4: Find the actor with the third lowest Net Worth in Millions without using the LIMIT clause
SELECT CONCAT(A.FirstName, ' ', A.SecondName) AS Actor_Name, NetWorthInMillions AS 3rd_Lowest_Net_Worth_In_Millions
From Actors AS A1
WHERE 2 = (SELECT COUNT(DISTINCT (NetWorthInMillions)) 
           FROM Actors AS A2
           WHERE A2. NetWorthInMillions < A1. NetWorthInMillions);

-- Exercise 5: Write a query to display actors along with a comma separated list of their digital assets.
SELECT CONCAT (FirstName, ' ', SecondName) AS Actor_Name,                
       GROUP_CONCAT(AssetType) AS Digital_Assets
FROM Actors INNER JOIN DigitalAssets
ON Actors.Id = DigitalAssets.ActorId
GROUP BY Id;