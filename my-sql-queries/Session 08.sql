-- 1 --
CREATE VIEW ViewBonus AS
SELECT
	BinusId = STUFF(c.CustomerId, 1, 2, 'BN'),
	c.CustomerName
FROM
	MsCustomer c
WHERE
	LEN(c.CustomerName) > 10
GO


-- 2 --
CREATE VIEW ViewCustomerData AS
SELECT
	Name = LEFT(c.CustomerName, CHARINDEX(' ', c.CustomerName, 1) - 1),
	c.CustomerAddress,
	c.CustomerPhone
FROM
	MsCustomer c
WHERE
	CHARINDEX(' ', c.CustomerName, 1) != 0
GO

-- 3 --
CREATE VIEW ViewTreatment AS
SELECT
	t.TreatmentName,
	tt.TreatmentTypeName,
	Price = 'Rp.' + CAST(t.Price AS VARCHAR(20))
FROM
	MsTreatment t
	JOIN MsTreatmentType tt
	ON t.TreatmentTypeId = tt.TreatmentTypeId
WHERE
	tt.TreatmentTypeName = 'Hair Treatment' AND
	t.Price BETWEEN 450000 AND 800000
GO

-- 4 --
CREATE VIEW ViewTransaction AS
SELECT
	s.StaffName,
	c.CustomerName,
	TransactionDate = CONVERT(VARCHAR(20), hss.TransactionDate, 106),
	hss.PaymentType
FROM
	HeaderSalonServices hss
	JOIN MsCustomer c
	ON hss.CustomerId = c.CustomerId
	JOIN MsStaff s
	ON hss.StaffId = s.StaffId
WHERE
	DATEPART(DAY, hss.TransactionDate) BETWEEN 21 AND 25 AND
	hss.PaymentType = 'Credit'
GO

-- 5 --
CREATE VIEW ViewBonusCustomer AS
SELECT
	BonusId = REPLACE(c.CustomerId, 'CU', 'BN'),
	Name = LOWER(SUBSTRING(c.CustomerName, CHARINDEX(' ', c.CustomerName, 1) + 1, LEN(c.CustomerName) - CHARINDEX(' ', c.CustomerName, 1) + 1)),
	Day = DATENAME(WEEKDAY, hss.TransactionDate),
	TransactionDate = CONVERT(VARCHAR(20), hss.TransactionDate, 101)
FROM
	MsCustomer c
	JOIN HeaderSalonServices hss
	ON c.CustomerId = hss.CustomerId
WHERE
	CHARINDEX(' ', c.CustomerName) > 0 AND
	RIGHT(c.CustomerName, 1) = 'a'
GO


-- 6 --
CREATE VIEW ViewTransactionByLivia AS
SELECT
	dss.TransactionId,
	[Date] = CONVERT(VARCHAR(20), hss.TransactionDate, 107),
	t.TreatmentName
FROM
	HeaderSalonServices hss
	JOIN MsStaff s
	ON hss.StaffId = s.StaffId
	JOIN DetailSalonServices dss
	ON hss.TransactionId = dss.TransactionId
	JOIN MsTreatment t
	ON dss.TreatmentId = t.TreatmentId
WHERE
	DATEPART(DAY, hss.TransactionDate) = 21 AND
	s.StaffName = 'Livia Ashianti'
GO


-- 7 --
ALTER VIEW ViewCustomerData AS
SELECT
	ID = RIGHT(c.CustomerId, 3),
	Name = c.CustomerName,
	Address = c.CustomerAddress,
	Phone = c.CustomerPhone
FROM
	MsCustomer c
WHERE
	CHARINDEX(' ', c.CustomerName) > 0
GO

-- 8 --
CREATE VIEW ViewCustomer AS
SELECT
	c.CustomerId,
	c.CustomerName,
	c.CustomerGender
FROM
	MsCustomer c
GO

INSERT INTO ViewCustomer
VALUES('CU006', 'Cristian', 'Male')
GO

SELECT *  FROM MsCustomer
GO

-- 9 --
DELETE FROM ViewCustomerData
WHERE ID = 005
GO

SELECT * FROM ViewCustomerData
GO

-- 10 --
DROP VIEW ViewCustomerData
GO