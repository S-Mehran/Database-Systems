-- SECTION 1

--Q1--
SELECT CT.name AS CardType, COUNT(DISTINCT UC.userID) AS TotalUsers
FROM Card C
JOIN CardType CT ON C.cardTypeID = CT.cardTypeID
JOIN UserCard UC ON C.cardNum = UC.cardNum
GROUP BY CT.name;


--Q2--
SELECT C.cardNum, U.name
FROM Card C
JOIN UserCard UC ON C.cardNum = UC.cardNum
JOIN User U ON UC.userID = U.userId
WHERE C.balance BETWEEN 2000 AND 4000;



--Q3--
SELECT* FROM [User];
SELECT userId  FROM [User]
except
SELECT userID FROM UserCard;


--Q4--
SELECT C.cardNum, CT.name AS CardType, U.name AS OwnerName
FROM Card C
JOIN CardType CT ON C.cardTypeID = CT.cardTypeID
JOIN UserCard UC ON C.cardNum = UC.cardNum
JOIN [User] U ON UC.userID = U.userId
EXCEPT
SELECT T.cardNum, CT.name AS CardType, U.name AS OwnerName
FROM [Transaction] T
JOIN Card C ON T.cardNum = C.cardNum
JOIN CardType CT ON C.cardTypeID = CT.cardTypeID
JOIN UserCard UC ON C.cardNum = UC.cardNum
JOIN [User] U ON UC.userID = U.userId
WHERE YEAR(T.transDate) = YEAR(GETDATE()) - 1;


--Q5--
SELECT userid, name
FROM [User]
WHERE userid NOT IN (
    SELECT DISTINCT transid
    FROM [Transaction]
    WHERE YEAR(transdate) = 2023
);

--SECTION 2--
-- Q1 --
SELECT transId FROM [Transaction]
GROUP BY transId
HAVING SUM(amount) > 1000;


--Q2--
SELECT* FROM [Transaction]
WHERE YEAR(transDate) <= 2018 and YEAR(transDate) >=2015;


--Q3--
SELECT Card.cardTypeID, COUNT(transid) AS transaction_count
FROM [Transaction]
JOIN Card ON 
GROUP BY cardTypeID
ORDER BY transaction_count DESC;

--Q4--
SELECT userId, name
FROM [User]
WHERE userId NOT IN (SELECT DISTINCT transId FROM [Transaction]);


--Q5--
SELECT cardTypeID, COUNT(cardTypeID) AS total_count
FROM [Card]
JOIN [User] ON [User].userId = Card.cardTypeID
WHERE city IN ('Lahore', 'Narowal')
GROUP BY cardTypeID;


--Q6--
SELECT name, userid, COUNT(userid) AS Count_Users, SUM(balance) AS total_sum
FROM [User]
JOIN Card ON [User].userId = Card.cardTypeID
GROUP BY [User].city, [User].name, [User].userid;


--Q7--
SELECT Card.cardNum, [User].name
FROM [Transaction]
JOIN [User] ON [User].userId = [Transaction].transId
JOIN [Card] ON [Card].cardTypeID = [Transaction].transId
GROUP BY card.cardnum, [user].name
HAVING SUM([Transaction].amount) > (SELECT AVG([transaction].amount) FROM [Transaction]); 


--SECTION 3--

--Q1--
SELECT DISTINCT [User].userId FROM [User]
RIGHT JOIN UserCard ON [User].userId = [UserCard].userID;



--Q2--
SELECT CardType.cardTypeID, CardType.name, [User].name
FROM [User]
JOIN CardType ON CardType.cardTypeID = [User].userId
JOIN [Transaction] ON [Transaction].transId = [User].userId
WHERE YEAR([Transaction].transDate) Not IN (2023);


--Q3--
SELECT [User].userId, [User].name, [User].phoneNum, [User].city
FROM [User]
JOIN USERCARD ON [User].userId = [USERCard].userID
JOIN CARD ON [UserCard].cardNum = [Card].cardNum
WHERE YEAR(CARD.expireDate) < 2020; 

--Q4--
SELECT [User].userId, [User].name, [User].phoneNum, [User].city, [userCard].cardNum, [CardType].name
FROM [User]
JOIN USERCARD ON [User].userId = [USERCard].userID
JOIN CARD ON [UserCard].cardNum = [Card].cardNum
JOIN CardType ON CardType.cardTypeID = CARD.cardTypeID
WHERE YEAR(CARD.expireDate) < 2020; 


--Q5--
SELECT [User].userId, [User].name, [Card].balance
FROM [User]
JOIN USERCARD ON [User].userId = [USERCard].userID
JOIN CARD ON [UserCard].cardNum = [Card].cardNum 
WHERE [Card].balance > 15000;


--Q6--
SELECT [User].userId, [User].name, SUM([Card].balance) as total_balance
FROM [User]
JOIN USERCARD ON [User].userId = [USERCard].userID
JOIN CARD ON [UserCard].cardNum = [Card].cardNum
GROUP BY [Card].cardTypeID, [User].userId, [User].name, [Card].balance 
HAVING [Card].balance > 15000;


-- Q7

SELECT U1.name AS User1, U2.name AS User2
FROM User U1, User U2
WHERE U1.userId < U2.userId
AND LEFT(U1.name, 1) = LEFT(U2.name, 1);


-- Q8
SELECT U.name, CT.name AS CardType
FROM User U
JOIN UserCard UC ON U.userId = UC.userID
JOIN Card C ON UC.cardNum = C.cardNum
JOIN CardType CT ON C.cardTypeID = CT.cardTypeID
JOIN Transaction T ON C.cardNum = T.cardNum
WHERE T.amount > 10000;


-- Q9
SELECT U.userId, U.name, U.phoneNum, U.city
FROM User U
JOIN UserCard UC ON U.userId = UC.userID
JOIN Card C ON UC.cardNum = C.cardNum
LEFT JOIN Transaction T ON C.cardNum = T.cardNum AND YEAR(T.transDate) = YEAR(CURDATE()) - 1
WHERE T.transId IS NULL;
