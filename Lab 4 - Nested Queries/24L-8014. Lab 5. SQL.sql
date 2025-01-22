-- Q1

SELECT MAX(Age) AS Maximum_Age, MIN(Age) as Minimum_Age, STDEV(Age) AS STD from users; 

-- Q2

SELECT TOP 2 FollowedUserName, COUNT(*) AS No_of_Followers from Following
GROUP BY FollowedUserName
ORDER BY COUNT(*) DESC;

-- Q3

SELECT TOP 4 FollowedUserName, COUNT(*) AS No_of_Followers from Following
 WHERE FollowedUserName NOT IN (
SELECT TOP 2 FollowedUserName from Following GROUP BY FollowedUserName ORDER BY COUNT(FollowedUserName))
GROUP BY FollowedUserName
ORDER BY COUNT(*) DESC ;

-- Q4

SELECT UserName from users 
WHERE UserName NOT IN (SELECT UserName from tweets); 

-- Q5


-- Q6

SELECT UserName from Users
WHERE UserName IN (SELECT UserName from tweets WHERE Text NOT Like '%#Census%');

-- Q7


SELECT UserName from users
EXCEPT 
SELECT FollowedUserName from Following;


--Q8

SELECT UserName from Users
WHERE UserName NOT IN (SELECT FollowedUserName from Following);


--Q9

SELECT UserName from users
WHERE NOT EXISTS (SELECT FollowedUserName from Following WHERE Users.UserName = Following.FollowedUserName);

--Q10

SELECT TOP 1 InterestID, COUNT(*) FROM UserInterests
GROUP BY InterestID ORDER BY COUNT(InterestID) DESC;


SELECT TOP 1 InterestID, COUNT(*) FROM UserInterests
GROUP BY InterestID ORDER BY COUNT(InterestID) DESC;


--Q11


SELECT Country, COUNT(*) AS Country_Count
FROM (
    SELECT U.Country
    FROM Users U
    JOIN tweets T ON T.UserName = U.UserName
) AS Subquery
GROUP BY Country;


-- Q12
SELECT UserName, COUNT(*) as TweetCount
FROM tweets
GROUP BY UserName
HAVING COUNT(*) > (
    SELECT AVG(TweetCount)
    FROM (
        SELECT COUNT(*) as TweetCount
        FROM tweets
        GROUP BY UserName
    ) as SubQuery
)
ORDER BY COUNT(*) DESC;


-- Q13
SELECT UserName from Users
WHERE UserName In (SELECT FollowedUserName from Users U
JOIN Following F ON U.UserName=F.FollowerUserName
WHERE Country = 'Pakistan')


-- Q14

SELECT U.InterestID, DESCRIPTION, COUNT(U.InterestID) 
from UserInterests U
JOIN Interests I ON I.InterestID = U.InterestID
GROUP BY U.InterestID, Description
HAVING COUNT(U.InterestID) = (SELECT MAX(TweetCount)
FROM (SELECT COUNT(*) as TweetCount
from UserInterests 
GROUP BY InterestID) as subquery);





SELECT U.InterestID, I.Description, COUNT(U.InterestID) as InterestCount
FROM UserInterests U 
JOIN Interests I ON I.InterestID = U.InterestID 
GROUP BY U.InterestID, I.Description 
HAVING COUNT(U.InterestID) = (
        SELECT MAX(TweetCount) 
        FROM (SELECT COUNT(*) as TweetCount 
            FROM UserInterests 
            GROUP BY InterestID
        ) as subquery
    );
