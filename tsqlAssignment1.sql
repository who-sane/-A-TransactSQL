Create DATABASE tsqlAssessment 

USE tsqlAssessment

/*
IF OBJECT_ID('Sale') IS NOT NULL
DROP TABLE SALE;

IF OBJECT_ID('Product') IS NOT NULL
DROP TABLE PRODUCT;

IF OBJECT_ID('Customer') IS NOT NULL
DROP TABLE CUSTOMER;

IF OBJECT_ID('Location') IS NOT NULL
DROP TABLE LOCATION;

GO

CREATE TABLE CUSTOMER (
CUSTID	INT
, CUSTNAME	NVARCHAR(100)
, SALES_YTD	MONEY
, Status	NVARCHAR(7)
, PRIMARY KEY	(CUSTID) 
);


CREATE TABLE PRODUCT (
PRODID	INT
, PRODNAME	NVARCHAR(100)
, SELLING_Price	MONEY
, SALES_YTD	MONEY
, PRIMARY KEY	(PRODID)
);

CREATE TABLE SALE (
SALEID	BIGINT
, CUSTID	INT
, PRODID	INT
, QTY	INT
, Price	MONEY
, SALEDATE	DATE
, PRIMARY KEY 	(SALEID)
, FOREIGN KEY 	(CUSTID) REFERENCES CUSTOMER
, FOREIGN KEY 	(PRODID) REFERENCES PRODUCT
);

CREATE TABLE LOCATION (
  LOCID	NVARCHAR(5)
, MINQTY	INTEGER
, MAXQTY	INTEGER
, PRIMARY KEY 	(LOCID)
, CONSTRAINT CHECK_LOCID_LENGTH CHECK (LEN(LOCID) = 5)
, CONSTRAINT CHECK_MINQTY_RANGE CHECK (MINQTY BETWEEN 0 AND 999)
, CONSTRAINT CHECK_MAXQTY_RANGE CHECK (MAXQTY BETWEEN 0 AND 999)
, CONSTRAINT CHECK_MAXQTY_GREATER_MIXQTY CHECK (MAXQTY >= MINQTY)
);

IF OBJECT_ID('SALE_SEQ') IS NOT NULL
DROP SEQUENCE SALE_SEQ;
CREATE SEQUENCE SALE_SEQ;

GO

----------------------------------------
-- Setup END


IF OBJECT_ID('ADD_CUSTOMER') IS NOT NULL
DROP PROCEDURE ADD_CUSTOMER;
GO

CREATE PROCEDURE ADD_CUSTOMER @PCUSTID INT, @PCUSTNAME NVARCHAR(100) AS

BEGIN
    BEGIN TRY

        IF @PCUSTID < 1 OR @PCUSTID > 499
            THROW 50020, 'Customer ID out of range', 1

        INSERT INTO CUSTOMER (CUSTID, CUSTNAME, SALES_YTD, Status) 
        VALUES (@PCUSTID, @PCUSTNAME, 0, 'OK');

    END TRY
    BEGIN CATCH
        if ERROR_NUMBER() = 2627
            THROW 50010, 'Duplicate customer ID', 1
        ELSE IF ERROR_NUMBER() = 50020
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH;

END;

*/
-- Input parameters for customers (id and name)
GO
EXEC ADD_CUSTOMER @pcustid = 12, @pcustname = 'Test';
EXEC ADD_CUSTOMER @pcustid = 42, @pcustname = 'TestA';
EXEC ADD_CUSTOMER @pcustid = 15, @pcustname = 'TestB';
/*
select * from customer;

-- Procedure 2 
IF OBJECT_ID('DELETE_ALL_CUSTOMERS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_CUSTOMERS;
GO

CREATE PROCEDURE DELETE_ALL_CUSTOMERS AS

BEGIN
    BEGIN TRY
        DELETE FROM Customer;
        DECLARE @ROWSDELETED INT = @@ROWCOUNT;
        SELECT @ROWSDELETED
    END TRY
        BEGIN CATCH 
        DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
        THROW 50000, @ERRORMESSAGE, 1
    END CATCH

END
GO
*/
EXEC DELETE_ALL_CUSTOMERS;
select * from customer;

-------------------------------------------------------
/*
IF OBJECT_ID('ADD_PRODUCT') IS NOT NULL
DROP PROCEDURE ADD_PRODUCT;
GO

CREATE PROCEDURE ADD_PRODUCT @pProdID INT, @pProdName NVARCHAR(100), @pPrice MONEY AS

BEGIN
    BEGIN TRY

        IF @pprodid < 1000 OR @pprodid > 2500
            THROW 50040, 'Product ID out of range' , 1
         ELSE IF @pPrice < 0 OR @pPrice > 999.99
                 THROW 50050, 'Price out of range', 1

        INSERT INTO PRODUCT (PRODID, PRODNAME, SELLING_Price, SALES_YTD) 
        VALUES (@pprodid, @pprodname, @pPrice, 0);

    END TRY
            BEGIN CATCH
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END CATCH; 

END;
*/
-- TEST PRODUCT
-- tested id 100 came back 'id out of range'

GO
EXEC ADD_PRODUCT @pprodid = 1000, @pprodname = "FRUIT", @pPrice = 390;
SELECT * FROM PRODUCT

-------------------------------------------------------

-- DELETE ALL PRODUCTS

/* USE tsqlAssessment

IF OBJECT_ID('DELETE_ALL_PRODUCTS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_PRODUCTS;

GO

CREATE PROCEDURE DELETE_ALL_PRODUCTS AS

BEGIN
    BEGIN TRY
        DELETE FROM PRODUCT;
        DECLARE @PRDREMOVEDROWS INT = @@ROWCOUNT;
        RETURN @@ROWCOUNT
    END TRY
    BEGIN CATCH
        DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
        THROW 50000, @ERRORMESSAGE, 1
    END CATCH
END
*/
GO;

EXEC DELETE_ALL_PRODUCTS;
SELECT * FROM PRODUCT;


-------------------------------------------------------

-- GET CUSTOMER STRING (ID)
/*
USE tsqlAssessment


IF OBJECT_ID('GET_CUSTOMER_STRING') IS NOT NULL
DROP PROCEDURE GET_CUSTOMER_STRING;

GO
CREATE PROCEDURE GET_CUSTOMER_STRING @pCUSTID INT,
@pReturnString NVARCHAR (1000) OUT AS

BEGIN
    BEGIN TRY
     DECLARE @CUSTNAME NVARCHAR(100), @Status NVARCHAR(7), @SYTD MONEY

    SELECT @CUSTNAME = CUSTNAME, @Status = Status, @SYTD = SALES_YTD
    FROM CUSTOMER WHERE CUSTID = @pCUSTID;
    
    SET @pReturnString = CONCAT(' Custid: ', @pCUSTID, ' Name: ', @CUSTNAME, ' Status: ', @Status, ' SalesYTD: ', @SYTD);
    END TRY
    BEGIN CATCH
        if ERROR_NUMBER() = 2627
            THROW 50060, 'Customer ID not found', 1
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH;

END;
*/

-- Gets CUSTOMER ID 100 (test subject) from database 
EXEC GET_CUSTOMER_STRING @pCUSTID = 100, @pReturnString = "Test"
SELECT * FROM CUSTOMER

-------------------------------------------------------
-- Update CUST SALESYTD

-- UPD_CUST_SALESYTD PROCEDURE
/*
IF OBJECT_ID('UPD_CUST_SALESYTD') IS NOT NULL
DROP PROCEDURE UPD_CUST_SALESYTD;

GO
CREATE PROCEDURE UPD_CUST_SALESYTD @pCUSTID INT, @pAMT MONEY AS

BEGIN
    BEGIN TRY
        IF @pAMT < -999.99 OR @pAMT > 999.99
            THROW 50080, 'Amount out of range', 1
        
        UPDATE CUSTOMER 
        SET SALES_YTD = (SALES_YTD + @pAMT)   
        WHERE @pCUSTID = CUSTID;

    END TRY
    BEGIN CATCH
         if ERROR_NUMBER() = 2627
            THROW 50070, 'Customer ID not found', 1
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH
END;
*/
-- adds @pmt value onto current!
EXEC UPD_CUST_SALESYTD @PCUSTID= 1214, @PAMT= 40
EXEC GET_CUSTOMER_STRING @PCUSTID = 1214, @PRETURNSTRING = "Test"
SELECT * FROM CUSTOMER

-------------------------------------------------------
-- GET PROD STRING PROCEDURE
/*
IF OBJECT_ID('GET_PROD_STRING') IS NOT NULL
DROP PROCEDURE GET_PROD_STRING;

GO
CREATE PROCEDURE GET_PROD_STRING @pprodid INT, @pReturnString NVARCHAR(1000) OUT AS
BEGIN

    BEGIN TRY
    DECLARE @PPRODNAME NVARCHAR(100), @PSELLING_Price MONEY, @PSYTD MONEY;

    SELECT @PPRODNAME = PRODNAME, @PSELLING_Price = SELLING_Price, @PSYTD = SALES_YTD
    FROM PRODUCT WHERE PRODID = @pprodid;

    IF @@ROWCOUNT = 0 
    THROW 50060, 'Customer ID not Found', 1
    ELSE
    SET @pReturnString = CONCAT(' Prodid: ', @pprodid, ' Name: ', @pprodname,  ' Price: ', @PSELLING_Price, ' SalesYTD: ' , @PSYTD);
    END TRY
    BEGIN CATCH
        if ERROR_NUMBER() = 2627
            THROW 50090, 'Product ID not found', 1
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END; 
    END CATCH;

END;
*/
-- DELETE FROM PRODUCT;
-- EXEC ADD_PRODUCT @pprodid = 1021, @pprodname = 'clown nose', @pPrice = 5;


-- DECLARE @test NVARCHAR(1000);
-- EXEC GET_PROD_STRING @pprodid = 1021, @PRETURNSTRING = @test OUT;

SELECT * FROM PRODUCT

-------------------------------------------------------
-- UPD_PROD_SALESYTD
/*
IF OBJECT_ID('UPD_PROD_SALESYTD') IS NOT NULL
DROP PROCEDURE UPD_PROD_SALESYTD;
GO

CREATE PROCEDURE UPD_PROD_SALESYTD @pprodid INT, @pamt MONEY AS
BEGIN
    BEGIN TRY
    IF @pamt < -999.99 OR @pamt > 999.99
            THROW 50110, 'Amount out of range', 1
        
        UPDATE PRODUCT SET SALES_YTD = SALES_YTD + @pamt  WHERE PRODID = @pprodid;
    END TRY
    BEGIN CATCH
        if ERROR_NUMBER() = 50110
            THROW 
        if ERROR_NUMBER() = 50100
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END;
    END CATCH
END;
GO
*/

EXEC UPD_PROD_SALESYTD @pprodid = 1021, @pamt = 50;
SELECT  * FROM PRODUCT


-------------------------------------------------------
-- UPD_CUSTOMER_Status PROCEDURE

/*
IF OBJECT_ID('UPD_CUSTOMER_Status') IS NOT NULL
DROP PROCEDURE UPD_CUSTOMER_Status;
GO

CREATE PROCEDURE UPD_CUSTOMER_Status @pcustid INT, @pStatus NVARCHAR(7) AS


BEGIN
    BEGIN TRY
    IF @pStatus = 'OK' or @pStatus = 'SUSPEND'
        UPDATE CUSTOMER SET Status = @pStatus
        WHERE Custid = @pcustid
        UPDATE CUSTOMER SET Status = @pStatus 
        WHERE CUSTID = @pcustid;
    
    IF @@ROWCOUNT = 0
            THROW 50120, 'Customer ID not found', 1
    END TRY

    BEGIN CATCH
        DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
        THROW 50000, @ERRORMESSAGE, 1
    END CATCH
END;
*/
-- change SUSPEND to OK and run again to test
EXEC UPD_CUSTOMER_Status @pcustid = 1214, @pStatus = 'SUSPEND';
SELECT * FROM CUSTOMER

-------------------------------------------------------
-- ADD_SIMPLE_SALE
/*
USE tsqlAssessment

IF OBJECT_ID('ADD_SIMPLE_SALE') IS NOT NULL
DROP PROCEDURE ADD_SIMPLE_SALE;
GO

CREATE PROCEDURE ADD_SIMPLE_SALE @pcustid INT, @pprodid INT, @pQty MONEY AS
BEGIN
BEGIN TRY 
    DECLARE @Status AS NVARCHAR(7)
    SELECT @Status = Status FROM CUSTOMER WHERE CUSTID = @pcustid
    IF @Status != 'OK'
        THROW 50150, 'Customer Status is not OK',1;
    IF @pQty > 999 or @pQty < 1
        THROW 50140, 'Sale Quantity outside valid range',1;
        
    IF EXISTS (SELECT * FROM CUSTOMER WHERE CUSTID = @pcustid) 
    
    IF EXISTS (SELECT * FROM PRODUCT WHERE PRODID = @pPRODID)
        BEGIN

        DECLARE @Price AS MONEY
        SELECT @Price =  SELLING_Price FROM PRODUCT WHERE PRODID = @pprodid
        DECLARE @total money = @pQty * @Price;
        UPDATE CUSTOMER SET SALES_YTD += @total WHERE CUSTID = @pcustid;
        UPDATE PRODUCT SET SALES_YTD += @total WHERE PRODID = @pprodid;
        END;

         ELSE 
            THROW 50170, 'Product ID not found', 1;
         ELSE  
            THROW 50160, 'Customer ID not found', 1;
         END TRY
    BEGIN CATCH
        if ERROR_NUMBER() = 50150 OR ERROR_NUMBER() = 50160 OR  ERROR_NUMBER() = 50140 or ERROR_NUMBER() = 50170
        THROW;

        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END;
    END CATCH
END;
*/

EXEC ADD_SIMPLE_SALE @pcustid = 42, @pprodid = 1000, @pQty = 5
-- rows are affected so it seems to work


-- SUM_CUSTOMER_SALESYTD
-------------------------------------------------------
/* 
IF OBJECT_ID('SUM_CUSTOMER_SALESYTD') IS NOT NULL
DROP PROCEDURE SUM_CUSTOMER_SALESYTD;
GO

CREATE PROCEDURE SUM_CUSTOMER_SALESYTD AS

BEGIN

    BEGIN TRY 

    DECLARE @total as INT;
    SELECT @total = SUM(SALES_YTD) 
    FROM CUSTOMER;
    RETURN @total;

    END TRY
    BEGIN CATCH

    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
    THROW 50000, @ERRORMESSAGE, 1

    END CATCH

END;

GO

-- SUM_PRODUCT_SALESYTD
-------------------------------------------------------

IF OBJECT_ID('SUM_PRODUCT_SALESYTD') IS NOT NULL
DROP PROCEDURE SUM_PRODUCT_SALESYTD;

GO

CREATE PROCEDURE SUM_PRODUCT_SALESYTD AS

BEGIN

    BEGIN TRY 

    DECLARE @total as INT;
    SELECT @total = SUM(SALES_YTD) 
    FROM PRODUCT;
    RETURN @total;

    END TRY

    BEGIN CATCH

    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
    THROW 50000, @ERRORMESSAGE, 1

    END CATCH

END;
GO
/*


-- GET_ALL_CUSTOMERS
-------------------------------------------------------
/*
IF OBJECT_ID('GET_ALL_CUSTOMERS') IS NOT NULL
DROP PROCEDURE GET_ALL_CUSTOMERS;
GO

CREATE PROCEDURE GET_ALL_CUSTOMERS @POUTCUR CURSOR VARYING OUTPUT AS

BEGIN
    BEGIN TRY 

    SET NOCOUNT ON;
    SET @POUTCUR = CURSOR FOR 
    SELECT * FROM CUSTOMER;
    OPEN @POUTCUR

    END TRY
    BEGIN CATCH

    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
    THROW 50000, @ERRORMESSAGE, 1

    END CATCH
END;
GO
*/

-- GET_ALL_PRODUCTS
--------------------------------------------------------
-- ESSENTIALLY THE SAME AS ABOVE
/*
IF OBJECT_ID('GET_ALL_PRODUCTS') IS NOT NULL
DROP PROCEDURE GET_ALL_PRODUCTS;
GO

CREATE PROCEDURE GET_ALL_PRODUCTS @POUTCUR CURSOR VARYING OUTPUT AS

BEGIN
    BEGIN TRY 

    SET NOCOUNT ON;
    SET @POUTCUR = CURSOR FOR 
    SELECT * FROM PRODUCT;
    OPEN @POUTCUR

    END TRY
    BEGIN CATCH

    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
    THROW 50000, @ERRORMESSAGE, 1

    END CATCH
END;
*/
GO

--------------------------------------------------------
-- ADD_LOCATION
--------------------------------------------------------

/*
IF OBJECT_ID('ADD_LOCATION') IS NOT NULL
DROP PROCEDURE ADD_LOCATION;
GO

CREATE PROCEDURE ADD_LOCATION @ploccode NVARCHAR(5), @pminqty INT, @pMaxQty INT AS

BEGIN
BEGIN TRY

    IF @pLocCode != 5
        THROW 50190, 'Location Code length invalid', 1

    IF @pMinQty > 999 OR @pMinQty < 0 
        THROW 50200, 'Minimum Qty out of range', 1

    IF @pMaxQty > 999 OR @pMaxQty < 0 
        THROW 50210, 'Maximum Qty out of range', 1

    IF @pMaxQty < @pMinQty 
        THROW 50220, 'Minimum Qty larger than Maximum Qty', 1
        
    INSERT INTO LOCATION (LOCID, MINQTY, MAXQTY)
    VALUES(@pLocCode, @pMinQty, @);
    END TRY

BEGIN CATCH

        IF ERROR_NUMBER() = 50190 OR ERROR_NUMBER() = 50200 OR ERROR_NUMBER() = 50210 OR ERROR_NUMBER() = 50220
        THROW

        IF ERROR_NUMBER() = 2627
        THROW 50180, 'Duplicate location ID',1

        ELSE
        BEGIN
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
            END;
    END CATCH

END;
GO
*/


-- ADD_COMPLEX_SALE
-------------------------------------------------------

-- Similar to Simple Add (similar template)
/*
IF OBJECT_ID('ADD_COMPLEX_SALE') IS NOT NULL
DROP PROCEDURE ADD_COMPLEX_SALE;
GO

CREATE PROCEDURE ADD_COMPLEX_SALE @pcustid INT, @pprodid INT, @pQty INT, @pdate DATE AS
BEGIN
    BEGIN TRY 
    DECLARE @Status AS NVARCHAR(7)
    SELECT @Status = Status FROM CUSTOMER WHERE CUSTID = @pcustid
    IF @Status != 'OK'
        THROW 50240, 'Customer Status is not OK',1;
    IF @pQty > 999 or @pQty < 1
        THROW 50230, 'Sale Quantity Outside Valid Range',1;
        
    IF EXISTS (SELECT * FROM CUSTOMER WHERE CUSTID = @pcustid)
    IF EXISTS (SELECT * FROM PRODUCT WHERE PRODID = @pprodid)

        BEGIN
        DECLARE @Price AS MONEY
        SELECT @Price =  SELLING_Price FROM PRODUCT WHERE PRODID = @pprodid;

        DECLARE @total money = @pQty * @Price;
        UPDATE CUSTOMER SET SALES_YTD += @total WHERE CUSTID = @pcustid;
        UPDATE PRODUCT SET SALES_YTD += @total WHERE PRODID = @pprodid;

        DECLARE @saleid BIGINT;
        SELECT @Price = SELLING_Price FROM PRODUCT WHERE PRODID = @pprodid;
        INSERT INTO SALE (SALEID, CUSTID, PRODID, QTY, Price, SALEDATE)
        VALUES(NEXT VALUE FOR SALE_SEQ,@pcustid, @pprodid,@pQty, @Price, @pdate )
        END;

        ELSE 
            THROW 50270, 'Product ID not found',1;
        ELSE 
            THROW 50260, 'Customer ID not found',1;
    END TRY

    BEGIN CATCH
        IF ERROR_NUMBER() = 50230 OR ERROR_NUMBER() = 50240 OR ERROR_NUMBER() = 50250 OR ERROR_NUMBER() = 50260 OR ERROR_NUMBER() = 50270
        Throw
        ELSE
            BEGIN
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
            END;
    END CATCH
END;
GO
*/ 




-- GET ALL SALES
-------------------------------------------------------
/*
USE tsqlAssessment

IF OBJECT_ID('GET_ALL_SALES') IS NOT NULL
    DROP PROCEDURE GET_ALL_SALES

GO

CREATE PROCEDURE GET_ALL_SALES @POUTCUR CURSOR VARYING OUTPUT AS
BEGIN
    BEGIN TRY
        SET @POUTCUR = CURSOR
        FORWARD_ONLY STATIC FOR
        SELECT * FROM SALE
        OPEN @POUTCUR

    END TRY
    BEGIN CATCH
        DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
        THROW 50000, @ERRORMESSAGE, 1
    END CATCH
END
*/

-- COUNT PRODUCT SALES
-------------------------------------------------------
/* 
IF OBJECT_ID('COUNT_PRODUCT_SALES') IS NOT NULL
    DROP PROCEDURE COUNT_PRODUCT_SALES

GO

CREATE PROCEDURE COUNT_PRODUCT_SALES @pdays INT AS
BEGIN
    DECLARE @numSales INT
    BEGIN TRY
        SELECT @numSales = COUNT(*)
        FROM SALE
        WHERE DATEDIFF(day, SALEDATE, GETDATE()) BETWEEN 0 AND @pdays
    END TRY
    BEGIN CATCH
        DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
        THROW 50000, @ERRORMESSAGE, 1
    END CATCH
    RETURN @numSales
END
*/

-- DELETE SALE
-------------------------------------------------------

/*
IF OBJECT_ID('DELETE_SALE') IS NOT NULL
    DROP PROCEDURE DELETE_SALE

GO

CREATE PROCEDURE DELETE_SALE @saleid BIGINT OUTPUT AS
BEGIN
DECLARE @custid INT, @prodid INT, @price INT, @qty INT, @amt INT

BEGIN TRY

    SELECT @saleid = SALEID, @custid = CUSTID, @prodid = PRODID, @price = PRICE, @qty = QTY
    FROM SALE
    WHERE SALEID = (SELECT MIN(SALEID) FROM SALE)

    IF @@ROWCOUNT = 0
        THROW 50280, 'No Sale Rows Found', 1;

    SET @amt = -1 * (@price * @qty)
    EXEC UPD_CUST_SALESYTD @pcustid = @custid, @pamt = @amt
    EXEC UPD_PROD_SALESYTD @pprodid = @prodid, @pamt = @amt

    DELETE FROM SALE
    WHERE SALEID = (SELECT MIN(SALEID) FROM SALE)

    IF @@ROWCOUNT = 0
        THROW 50280, 'No Sale Rows Found', 1;
    END TRY

    BEGIN CATCH
    IF ERROR_NUMBER() = 50280
        THROW
    ELSE
        DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
    THROW 50000, @ERRORMESSAGE, 1

    END CATCH

END

GO
*/


-- DELETE ALL SALE
-------------------------------------------------------

-- Similarly to del all customers

/*
IF OBJECT_ID('DELETE_ALL_SALES') IS NOT NULL
    DROP PROCEDURE DELETE_ALL_SALES

GO

CREATE PROCEDURE DELETE_ALL_SALES  AS
BEGIN

BEGIN TRY
    DELETE FROM SALE

    UPDATE CUSTOMER
    SET SALES_YTD = 0;

    UPDATE PRODUCT
    SET SALES_YTD = 0;

    END TRY
   
    BEGIN CATCH
    
    DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
    THROW 50000, @ERRORMESSAGE, 1
    
    END CATCH
END

GO
*/


-- DELETE CUSTOMER
-------------------------------------------------------
/* 
IF OBJECT_ID('DELETE_CUSTOMER') IS NOT NULL
    DROP PROCEDURE DELETE_CUSTOMER

GO

CREATE PROCEDURE DELETE_CUSTOMER @pcustid INT AS
BEGIN
    
BEGIN TRY

    IF NOT EXISTS(SELECT * FROM CUSTOMER WHERE CUSTID = @pcustid)
        THROW 50290, 'Customer ID not found', 1
    IF EXISTS(SELECT * FROM SALE WHERE CUSTID = @pcustid)
        THROW 50300, 'Customer cannot be deleted as sales exist', 1
    DELETE FROM CUSTOMER WHERE CUSTID = @pcustid
    
    END TRY
    
    BEGIN CATCH

    IF ERROR_NUMBER() IN (50290, 50300)
        THROW

    ELSE

        DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
        THROW 50000, @ERRORMESSAGE, 1

    END CATCH
END

GO
*/

-- DELETE PRODUCT
-------------------------------------------------------
/* 

IF OBJECT_ID('DELETE_PRODUCT') IS NOT NULL
    DROP PROCEDURE DELETE_PRODUCT

GO

CREATE PROCEDURE DELETE_PRODUCT @pprodid INT AS
BEGIN

    BEGIN TRY

    IF NOT EXISTS(SELECT * FROM PRODUCT WHERE PRODID = @pprodid)
        THROW 50310, 'Product ID not found', 1
    IF EXISTS(SELECT * FROM SALE WHERE PRODID = @pprodid)
        THROW 50320, 'Product cannot be deleted as sales exist', 1
    DELETE FROM PRODUCT WHERE PRODID = @pprodid

    END TRY
   
    BEGIN CATCH

        IF ERROR_NUMBER() IN (50290, 50300)
            THROW

        ELSE
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1

    END CATCH
END

GO
*/

--------------------------------
-- DONE