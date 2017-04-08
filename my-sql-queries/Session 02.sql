CREATE DATABASE [Test3];
GO

USE [Test3];
GO

CREATE TABLE [MsCustomer](
	[CustomerId] CHAR(5) NOT NULL,
	[CustomerName] VARCHAR(50),
	[CustomerGender] VARCHAR(10),
	[CustomerPhone] VARCHAR(13),
	[CustomerAddress] VARCHAR(100),

	PRIMARY KEY([CustomerId]),

	CONSTRAINT chk_CustomerId
	CHECK([CustomerId] LIKE 'CU[0-9][0-9][0-9]'),

	CONSTRAINT chk_CustomerGender
	CHECK([CustomerGender] IN('MALE', 'FEMALE')),
);
GO

CREATE TABLE [MsStaff](
	[StaffId] CHAR(5) NOT NULL,
	[StaffName] VARCHAR(50),
	[StaffGender] VARCHAR(10),
	[StaffPhone] VARCHAR(13),
	[StaffAddress] VARCHAR(100),
	[StaffSalary] NUMERIC(11, 2),
	[StaffPosition] VARCHAR(20),

	PRIMARY KEY([StaffId]),

	CONSTRAINT chk_StaffId
	CHECK([StaffId] LIKE 'SF[0-9][0-9][0-9]'),

	CONSTRAINT chk_StaffGender
	CHECK([StaffGender] IN('MALE', 'FEMALE')),
);
GO

CREATE TABLE [MsTreatmentType](
	[TreatmentTypeId] CHAR(5) NOT NULL,
	[TreatmentTypeName] VARCHAR(50),

	PRIMARY KEY([TreatmentTypeId]),

	CONSTRAINT chk_TreatmentTypeId
	CHECK([TreatmentTypeId] LIKE 'TT[0-9][0-9][0-9]')
);
GO

CREATE TABLE [MsTreatment](
	[TreatmentId] CHAR(5) NOT NULL,
	[TreatmentTypeId] CHAR(5) NOT NULL,
	[TreatmentName] VARCHAR(50),
	[Price] NUMERIC(11, 2),

	PRIMARY KEY([TreatmentId]),

	FOREIGN KEY([TreatmentTypeId])
		REFERENCES [MsTreatmentType]([TreatmentTypeId]),

	CONSTRAINT chk_TreatmentId
		CHECK([TreatmentId] LIKE 'TM[0-9][0-9][0-9]')
);
GO

CREATE TABLE [HeaderSalonServices](
	[TransactionId] CHAR(5) NOT NULL,
	[CustomerId] CHAR(5) NOT NULL,
	[StaffId] CHAR(5) NOT NULL,
	[TransactionDate] DATE,
	[PaymentType] VARCHAR(20),

	PRIMARY KEY([TransactionId]),

	CONSTRAINT chk_TransactionId
		CHECK([TransactionId] LIKE 'TR[0-9][0-9][0-9]'),

	FOREIGN KEY([CustomerId])
		REFERENCES [MsCustomer]([CustomerId]),

	FOREIGN KEY([StaffId])
		REFERENCES [MsStaff]([StaffId])
);
GO

CREATE TABLE [DetailSalonServices](
	[TransactionId] CHAR(5) NOT NULL,
	[TreatmentId] CHAR(5) NOT NULL,

	PRIMARY KEY([TransactionId], [TreatmentId]),

	FOREIGN KEY([TransactionId])
		REFERENCES [HeaderSalonServices]([TransactionId]),

	FOREIGN KEY([TreatmentId])
		REFERENCES [MsTreatment]([TreatmentId])
);
GO

DROP TABLE [DetailSalonServices];
GO

CREATE TABLE [DetailSalonServices](
	[TransactionId] CHAR(5) NOT NULL,
	[TreatmentId] CHAR(5) NOT NULL,

	FOREIGN KEY([TransactionId])
		REFERENCES [HeaderSalonServices]([TransactionId])
		ON UPDATE CASCADE ON DELETE CASCADE,

	FOREIGN KEY([TreatmentId])
		REFERENCES [MsTreatment]([TreatmentId])
		ON UPDATE CASCADE ON DELETE CASCADE
);
GO

ALTER TABLE [DetailSalonServices]
	ADD PRIMARY KEY([TransactionId], [TreatmentId]);
GO

ALTER TABLE [MsStaff]
	ADD CONSTRAINT chk_StaffName
		CHECK(LEN([StaffName]) BETWEEN 5 AND 20);
GO

DBCC CHECKCONSTRAINTS([MsStaff]);
GO

ALTER TABLE [MsTreatment]
	ADD [Description] VARCHAR(100);
GO

ALTER TABLE [MsTreatment]
	DROP COLUMN [Description];
GO
