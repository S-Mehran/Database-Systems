SELECT * FROM Customers;

SELECT * FROM items;

SELECT* FROM [Order];

SELECT * FROM OrderDetails;

-- EXERCISE 1
-- Q1
CREATE VIEW Order_View (OrderNo, TotalPrice)
AS SELECT OrderNo, (Quantity*Price) AS TotalPrice
FROM OrderDetails JOIN Items ON OrderDetails.ItemNo=items.ItemNo;

SELECT * FROM Order_View;



--Q2
CREATE VIEW Profitable_Items (ItemNo, Name, Quantity)
AS SELECT OD.ItemNo, Name, Quantity 
FROM OrderDetails OD JOIN Items I ON OD.ItemNo = I.ItemNo
WHERE Quantity>20;

SELECT * FROM Profitable_Items;


--Q3
CREATE VIEW Star_Customers (CustomerNo, Name, Purchase)
AS SELECT C.CustomerNo, C.Name, (Price*Total_Items_Ordered) AS Purchase
FROM Customers C JOIN [Order] O ON C.CustomerNo=O.CustomerNo 
JOIN OrderDetails OD ON OD.OrderNo = O.OrderNo
JOIN items I ON I.ItemNo=Od.ItemNo
WHERE Price*Total_Items_Ordered>2000
;


SELECT * FROM Star_Customers;



CREATE VIEW Star_Customers2 (CustomerNo, Name, Purchase)
AS SELECT C.CustomerNo, C.Name, (Price*Total_Items_Ordered) AS Purchase
FROM Customers C JOIN [Order] O ON C.CustomerNo=O.CustomerNo 
JOIN OrderDetails OD ON OD.OrderNo = O.OrderNo
JOIN items I ON I.ItemNo=Od.ItemNo
GROUP BY C.CustomerNo, C.Name, Price, Total_Items_Ordered
HAVING (Price*Total_Items_Ordered)>2000
;

SELECT * FROM Star_Customers2;



--Q4
CREATE VIEW Phone_Num (CustomerNo, Name, City, Phone)
AS SELECT CustomerNo, Name, City, Phone
FROM Customers 
WHERE Phone is NOT NULL;


SELECT * FROM Phone_Num;




--EXERCISE 2
--Q1
CREATE PROCEDURE InsertOrderDetail
    @OrderNo INT,
    @ItemNo INT,
    @Quantity INT
AS
BEGIN
    DECLARE @QuantityInStore INT;
    
    
    SELECT @QuantityInStore = [Quantity in Store]
    FROM [dbo].[Items]
    WHERE ItemNo = @ItemNo;
    
    IF @QuantityInStore < @Quantity
    BEGIN
        PRINT 'Only ' + CAST(@QuantityInStore AS VARCHAR(10)) + ' is present, which is less than your required quantity.';
    END
    ELSE
    BEGIN
    
        INSERT INTO [dbo].[OrderDetails] (OrderNo, ItemNo, Quantity)
        VALUES (@OrderNo, @ItemNo, @Quantity);
        
         UPDATE [dbo].[Items]
        SET [Quantity in Store] = [Quantity in Store] - @Quantity
        WHERE ItemNo = @ItemNo;
        
        PRINT 'Order placed successfully. Quantity in store updated.';
    END
END;
GO


EXEC InsertOrderDetail @OrderNo = 5, @ItemNo = 200, @Quantity = 15;




--Q2
CREATE PROCEDURE CustomerSignup
    @CustomerNo VARCHAR(2),
    @Name VARCHAR(30),
    @City VARCHAR(3),
    @Phone VARCHAR(11),
    @Flag INT OUTPUT
AS
BEGIN
    
    IF EXISTS (SELECT 1 FROM [dbo].[Customers] WHERE [CustomerNo] = @CustomerNo)
    BEGIN
        SET @Flag = 1;  
        RETURN;
    END


    IF @City IS NULL
    BEGIN
        SET @Flag = 2;  
        RETURN;
    END

    IF LEN(@Phone) <> 6
    BEGIN
        SET @Flag = 3;  
        RETURN;
    END


    INSERT INTO [dbo].[Customers] (CustomerNo, Name, City, Phone)
    VALUES (@CustomerNo, @Name, @City, @Phone);

    SET @Flag = 0;
END;
GO

--Execution(Q2)
DECLARE @ResultFlag INT;

EXEC CustomerSignup 
    @CustomerNo = 'C7', 
    @Name = 'John Doe', 
    @City = 'KHI', 
    @Phone = '123456', 
    @Flag = @ResultFlag OUTPUT;


SELECT @ResultFlag AS ResultFlag;



--Q3
CREATE PROCEDURE CancelOrder
    @CustomerNo VARCHAR(2),
    @OrderNo INT
AS
BEGIN
    DECLARE @CustomerName VARCHAR(30);
    

    SELECT @CustomerName = Name
    FROM [dbo].[Customers]
    WHERE [CustomerNo] = @CustomerNo;

    IF EXISTS (SELECT 1 FROM [dbo].[Order] WHERE [OrderNo] = @OrderNo AND [CustomerNo] = @CustomerNo)
    BEGIN
        DELETE FROM [dbo].[OrderDetails] WHERE [OrderNo] = @OrderNo;


        DELETE FROM [dbo].[Order] WHERE [OrderNo] = @OrderNo;

        PRINT 'Order ' + CAST(@OrderNo AS VARCHAR(10)) + ' for customer ' + @CustomerNo + ' (' + @CustomerName + ') has been successfully canceled.';
    END
    ELSE
    BEGIN
        PRINT 'Order no ' + CAST(@OrderNo AS VARCHAR(10)) + ' is not of customer ' + @CustomerNo + ' (' + @CustomerName + ').';
    END
END;
GO

--Execution(Q3)
EXEC CancelOrder @CustomerNo = 'C3', @OrderNo = 2;



--Q4
CREATE PROCEDURE GetCustomerPoints
    @CustomerName VARCHAR(30),
    @TotalPoints INT OUTPUT
AS
BEGIN
    DECLARE @CustomerNo VARCHAR(2);

    SELECT @CustomerNo = CustomerNo
    FROM [dbo].[Customers]
    WHERE Name = @CustomerName;

    IF @CustomerNo IS NOT NULL
    BEGIN
        SELECT @TotalPoints = SUM(Total_Items_Ordered * (Price / 100))
        FROM [dbo].[OrderDetails] OD
        JOIN [dbo].[Order] O ON OD.OrderNo = O.OrderNo
        JOIN [dbo].[Items] I ON OD.ItemNo = I.ItemNo
        WHERE O.CustomerNo = @CustomerNo;
        
        IF @TotalPoints IS NULL
            SET @TotalPoints = 0;
    END
    ELSE
    BEGIN
        PRINT 'Customer ' + @CustomerName + ' not found.';
        SET @TotalPoints = 0;
    END
END;
GO



--Executions
EXEC InsertOrderDetail @OrderNo = 5, @ItemNo = 200, @Quantity = 15;


--Execution(Q2)
DECLARE @ResultFlag INT;

EXEC CustomerSignup 
    @CustomerNo = 'C7', 
    @Name = 'John Doe', 
    @City = 'KHI', 
    @Phone = '123456', 
    @Flag = @ResultFlag OUTPUT;


SELECT @ResultFlag AS ResultFlag;


EXEC CancelOrder @CustomerNo = 'C3', @OrderNo = 2;



DECLARE @Points INT;

EXEC GetCustomerPoints @CustomerName = 'AHMED ALI', @TotalPoints = @Points OUTPUT;


SELECT @Points AS TotalPoints;
