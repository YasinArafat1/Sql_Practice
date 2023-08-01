USE AP
--Question 1.	Write a query to retrieve last 5 those invoices record whose invoice total is equal to the sum of payment total & credit total
SELECT TOP 5 * FROM Invoices 
WHERE InvoiceTotal=PaymentTotal+CreditTotal
ORDER BY InvoiceTotal DESC;
GO
--2.	Write a query to retrieve those invoices record whose date is later then 01/01/2016 or invoice total is more than 500 and invoice total must be greater than sum of payment total and credit total.

SELECT InvoiceID,InvoiceDate,InvoiceTotal FROM Invoices
WHERE InvoiceTotal>PaymentTotal+CreditTotal AND InvoiceDate >'2016-01-01'
GO

--3.	Write a query to retrieve those invoices whose vendor states are all except ‘CA’, ‘NV’, ‘OR’ and invoice dates are later than 01/01/2016

SELECT InvoiceID,VendorState FROM Invoices i
INNER JOIN  Vendors v ON i.VendorID = v.VendorID 
WHERE VendorState NOT IN ('CA','NV','OR')
GO
--4.	Write a query to retrieve invoices from 01/05/2016 to 31/05/2016
SELECT InvoiceID,InvoiceNumber,InvoiceDate FROM Invoices
WHERE InvoiceDate BETWEEN '2016-01-01' AND '2016-05-31'
GO

--5.	Write a query to retrieve vendors whose vendor city starts with ‘SAN’.	
SELECT VendorID,VendorCity FROM Vendors
WHERE VendorCity LIKE 'SAN%'

--6. Write a query to retrieve vendors whose contact name has one of the following characters: a, e, i, o, u.	
SELECT VendorName,VendorID FROM Vendors
WHERE VendorName LIKE '%[a,e,i,o,u]%'
GO
--7.	Write a query to find all vendors whose first letter of state starts with N and the next letter is one of A through J.

SELECT VendorID,VendorCity,VendorState FROM Vendors
WHERE VendorState LIKE 'N[A-J]'
GO
--8.	Write a query to find all vendors whose first letter of state starts with N and the next letter is not in K through Y.

SELECT VendorID,VendorCity,VendorState FROM Vendors
WHERE VendorState LIKE 'N[^K-Y]'
GO

--9.	Write a query to retrieve 11 through 20 records of vendors.	
SELECT VendorID,VendorName,VendorState
FROM Vendors
ORDER BY VendorID
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;
GO

--10.	Write a group query to retrieve invoices those average of invoice total is more than 2000.
SELECT InvoiceID,AVG(InvoiceTotal) AS InvoiceTotal  FROM Invoices
WHERE InvoiceTotal>2000
GROUP BY InvoiceID
GO

--11.	Give an example of CUBE operator

SELECT VendorState,VendorCity FROM Vendors
GROUP BY CUBE (VendorState,VendorCity)
GO

--12.Give an example of ROLLUP operator

SELECT VendorState,VendorCity FROM Vendors
GROUP BY ROLLUP (VendorState,VendorCity)
GO

--13.	Give an example of GROUPING SETS operator

SELECT VendorState,VendorCity FROM Vendors
GROUP BY GROUPING SETS (VendorState,VendorCity)
GO

--14.	Give an example of OVER clause

SELECT InvoiceID,InvoiceDate,InvoiceTotal,
SUM(InvoiceTotal) OVER (PARTITION BY InvoiceDate) AS DateSum
FROM Invoices
GO

--15.	Write a subquery to retrieve vendors who have invoices

SELECT InvoiceID,InvoiceDate,v.VendorID FROM Invoices i
INNER JOIN Vendors v ON i.VendorID= v.VendorID 
GO

--16.	Give an example of ANY keyword
IF 552>ANY (SELECT  DefaultAccountNo FROM Vendors)
PRINT 'YES 552 is Bigger than SOME AC No'
ELSE 
PRINT 'FALSE'
GO

--17.	Give an example of ALL keyword

IF 552>ALL (SELECT  DefaultAccountNo FROM Vendors)
PRINT 'TRUE'
ELSE 
PRINT 'NO 552 is not Bigger than all AC No'
GO

--18.	Give an example of SOME keyword 

IF 552>SOME  (SELECT  DefaultAccountNo FROM Vendors)
PRINT 'YES 552 is Bigger than SOME AC No'
ELSE 
PRINT 'FALSE'
GO
--19.Give an example of correlated subquery

SELECT VendorID,InvoiceID,InvoiceDate,InvoiceTotal 
FROM Invoices i WHERE InvoiceTotal = (SELECT InvoiceTotal FROM Invoices i1 WHERE i.InvoiceID =i1.InvoiceID )
GO
--20. Give an example of  subquery

SELECT VendorID,VendorName,DefaultAccountNo 
FROM Vendors   WHERE DefaultAccountNo > (SELECT AVG(DefaultAccountNo) FROM Vendors) 
GO

--21.	Give an example of EXISTS operator

SELECT VendorID,VendorName FROM Vendors
WHERE EXISTS 
(
SELECT Invoiceid,VendorID,InvoiceDate FROM Invoices
)
GO

--22.	Give an example on CTE.

WITH InvoiceInfo AS 
(
SELECT VendorID,InvoiceID,InvoiceDate,InvoiceNumber FROM Invoices
),
VendorInfo AS 
(
SELECT VendorID,VendorName,VendorState,VendorCity FROM Vendors
)
SELECT InvoiceID, InvoiceDate,v.VendorID,VendorState FROM InvoiceInfo i 
INNER JOIN VendorInfo v ON i.VendorID = v.VendorID
GO 
--23.	Insert a vendor record

SELECT * FROM Vendors
INSERT INTO Vendors (VendorID,VendorName,VendorState)
VALUES 
(124,'Yasin Arafat','Cumilla '),
(125,'Rakib Khan','Naogaon ')
GO 
--24.	Write a query with CAST and CONVERT, TRY_CONVERT Function

SELECT CAST (InvoiceDate AS VARCHAR(50)) FROM Invoices --It Changed the data type date to Varchar- 
SELECT CONVERT (VARCHAR(50),InvoiceDate,110 ) FROM Invoices --It Changed the data type date to Varchar And a Style code also 
SELECT TRY_CONVERT (VARCHAR(50),'2017-01-01',110 ) AS Date FROM Invoices
GO
--25.	Write a query with RANK, DENSE_RANK, NTILE, GROUPING Function
--RANK FUNCTION
SELECT VendorID,VendorName,VendorState,
RANK() OVER (ORDER BY VendorState)
FROM Vendors
GO
--Dense rank 
SELECT Vendorid,VendorName,VendorState,
DENSE_RANK() OVER(ORDER BY VendorState) 
FROM Vendors
GO
--NTILE 
SELECT VendorID,VendorName,VendorState,
NTILE(10) OVER(ORDER BY VendorState) AS State
FROM Vendors 
GO
--26.	Write a query with DATEADD, DATEDIFF
--DATEADD
SELECT DATEADD(MONTH,2,'2015-01-01')
--DATEDIFF
SELECT DATEDIFF(YEAR,'2016-01-01' , '2020-01-01')
GO
--27.	Write a query with CASE, IIF, CHOOSE Function
--CASE 
SELECT VendorState,
CASE VendorState 
WHEN 'CA' THEN'California'
WHEN 'DC' THEN 'Dracula'
END 
FROM Vendors
GO
--IIF
SELECT InvoiceTotal,
IIF(InvoiceTotal >500, 'MuchOrder', 'LessOrder')
FROM Invoices
GO
--CHOOSE 
SELECT InvoiceID,
CHOOSE(InvoiceID,'First Vendor','2nd Vendor','3rd Vendor','4th Vendor') AS VendorName
FROM Invoices 
ORDER BY InvoiceID 
Go
--28.	Write a query with MARGE
CREATE TABLE Warehouse 
(
ProductId INT,
Location VARCHAR(50),
Name VARCHAR(50),
Qty INT 
)
INSERT INTO Warehouse 
VALUES
(1,'Wh','Sharies',220),
(2,'Wh','Khatan Sharies',100),
(3,'Wh','Lehenga',150),
(4,'Wh','Zamdani Sharies',220),
(5,'Wh','Bloues',200),
(6,'Wh','Pedicote',50)

CREATE TABLE Shop1 
(
ProductId INT,
Location VARCHAR(50),
Name VARCHAR(50),
UpdateTime DATETIME,
Comments VARCHAR(75)
)
SELECT * FROM Shop1
INSERT INTO Shop1 
VALUES
(1,'sp','Sharies',NULL,NULL),
(2,'sp','Khatan Sharies',NULL,NULL),
(4,'sp','Lehenga',NULL,NULL),
(6,'sp','Zamdani Sharies',NULL,NULL),
(7,'sp','Sirajgong Sharies',NULL,NULL)

MERGE INTO Shop1 AS Target 
USING Warehouse AS src 
ON Target.ProductId = src.ProductId 
WHEN MATCHED --Product is available in sp and wh
THEN 
UPDATE SET UpdateTime =GETDATE(),Comments='Product is Available'
WHEN NOT MATCHED 
THEN 
INSERT (ProductId,Location,Name,UpdateTime,Comments)
VALUES ('src.ProductId','wh to shp','src.Name',GETDATE(),'Product Move From wh to shp')
WHEN NOT MATCHED BY SOURCE 
THEN
UPDATE SET Comments = 'Last unit available in shop ';
GO
--29.	Write select aggregate query
SELECT InvoiceNumber,SUM(InvoiceTotal)AS Total FROM Invoices 
GROUP BY (InvoiceNumber) 
GO

--30.	Write a join query
SELECT * FROM Vendors v
JOIN
Invoices i ON v.VendorID = i.VendorID
GO
--31.	Write a sub-query
SELECT VendorID,VendorName,DefaultAccountNo 
FROM Vendors   WHERE DefaultAccountNo > (SELECT AVG(DefaultAccountNo) FROM Vendors) 
GO
--32.	Write select query with having clause and group by function

SELECT   InvoiceID,InvoiceTotal,AVG(PaymentTotal)
FROM Invoices 
GROUP BY InvoiceID,InvoiceTotal
HAVING AVG(PaymentTotal)<=InvoiceTotal
GO






