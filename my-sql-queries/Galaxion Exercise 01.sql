CREATE DATABASE [Soal1];
GO

USE [Soal1];
GO

-- SOAL 1 --
CREATE TABLE [CustomerType](
	[CustomerTypeID] CHAR(5),
	[CustomerTypeName] VARCHAR(50) NOT NULL,
	[CustomerDiscount] INT NOT NULL,

	PRIMARY KEY([CustomerTypeID]),

	CONSTRAINT chk_CustomerTypeID
	CHECK(
		[CustomerTypeID] LIKE('CT[0-9][0-9][0-9]')
	),

	CONSTRAINT chk_CustomerTypeName
	CHECK(
		[CustomerTypeName] IN('Guest', 'Regular', 'Premium')
	)
);


-- SOAL 2 --
ALTER TABLE [Staff]
	ADD [JoinedDate] DATE;

ALTER TABLE [Staff]
	ADD CONSTRAINT chk_StaffSalary
		CHECK(
			[StaffSalary] BETWEEN 2700000 AND 8250000
		);

-- SOAL 3 --
INSERT INTO [Staff](
	[StaffId],
	[StaffName],
	[StaffGender],
	[StaffDOB],
	[StaffEmail],
	[StaffPhone],
	[StaffAddress],
	[StaffSalary
)
VALUES(
	'SF006',
	'Andi Muqsith Ashari',
	'Male',
	'1996-02-13',
	'uccth@gmail.com',
	'087778260771',
	'Jl. Kemerah X no.21',
	4500000
);

-- SOAL 4 --
CREATE VIEW AdminView AS
	SELECT
		b.BranchID AS [Branch ID],
		b.BranchName AS [Branch Name],
		h.TransactionDate AS [Transaction Date]
	FROM
		Branch AS b
		JOIN HeaderTransaction AS h
		ON b.BranchID = h.BranchID
		AND MONTH(h.TransactionDate) = 3

-- SOAL 5 --
UPDATE s
SET
	s.StaffSalary += 800000
FROM
	Staff s
	JOIN HeaderTransaction h
	ON MONTH(h.TransactionDate) = 2
WHERE
	s.StaffID = h.StaffID
