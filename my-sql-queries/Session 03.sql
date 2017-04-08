INSERT INTO MsStaff
VALUES(
	'SF006',
	'Jeklin Harefa',
	'Female',
	'08526543332',
	'Kebon Jeruk Street no 140',
	3000000,
	'Stylist'
);


INSERT INTO HeaderSalonServices
VALUES(
	'TR010',
	'CU001',
	'SF004',
	'2012/12/23',
	'Credit'
);


INSERT INTO HeaderSalonServices
VALUES(
	'TR018',
	'CU005',
	'SF001',
	'2012/12/27',
	'Debit'
);


INSERT INTO DetailSalonServices
VALUES(
	'TR010',
	'TM003'
);


INSERT INTO HeaderSalonServices(
	TransactionId,
	CustomerId,
	StaffId,
	TransactionDate,
	PaymentType
)
VALUES(
	'TR019',
	'CU005',
	'SF004',
	DATEADD(day, 3, GETDATE()),
	'Credit'
);


INSERT INTO MsStaff
VALUES(
	'SF010',
	'Effendy Lesmana',
	'Male',
	'085218587878',
	'Tanggerang City Street no 88',
	ROUND(RAND() * (5000000 - 3000000 - 1) + 3000000, 0),
	'Stylist'
);


UPDATE MsCustomer
SET 
	CustomerPhone = '628' + RIGHT(CustomerPhone, LEN(CustomerPhone) - 2)
WHERE
	LEFT(CustomerPhone, 2) = '08'
/* REPLACE(CustomerPhone, '08', '628') */


UPDATE MsStaff
SET
	StaffPosition = 'Top Stylist', StaffSalary += 7000000
WHERE
	StaffName = 'Effendy Lesmana';


UPDATE MsCustomer
SET
	CustomerName = LEFT(CustomerName, CHARINDEX(' ', CustomerName))
FROM
	MsCustomer
	JOIN HeaderSalonServices
	ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE
	DATEPART(day, HeaderSalonServices.TransactionDate) = 21
	AND CHARINDEX(' ', CustomerName) != 0;


UPDATE MsCustomer
SET
	CustomerName = 'Ms. ' + CustomerName
WHERE
	CustomerId IN('CU002', 'CU003');

UPDATE MsCustomer
SET
	CustomerAddress = 'Daan Mogot Baru Street No. 23'
FROM
	
	((MsCustomer
	JOIN HeaderSalonServices
	ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId)
	JOIN MsStaff
	ON HeaderSalonServices.StaffId = MsStaff.StaffId)
WHERE
	MsStaff.StaffName = 'Indra Saswita'
	AND DATENAME(weekday, HeaderSalonServices.TransactionDate) = 'Thursday';


DELETE HeaderSalonServices
FROM
	HeaderSalonServices
	JOIN MsCustomer
	ON
		HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE
CHARINDEX(' ', MsCustomer.CustomerName) = 0


ROLLBACK
COMMIT TRAN

SELECT DATEPART(weekday, GETDATE());

SELECT * FROM MsStaff;

SELECT * FROM HeaderSalonServices;

SELECT * FROM DetailSalonServices;

SELECT * FROM MsCustomer;

SELECT DATEADD(day, 30, GETDATE()) AS NextMonth;

SELECT *, DATENAME(weekday, HeaderSalonServices.TransactionDate)
	FROM ((MsCustomer
		JOIN HeaderSalonServices
		ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId)
		JOIN MsStaff
		ON HeaderSalonServices.StaffId = MsStaff.StaffId)
	WHERE MsStaff.StaffName = 'Indra Saswita' AND DATENAME(weekday, HeaderSalonServices.TransactionDate) = 'Thursday';

SELECT DATENAME(weekday, '2012/12/20');

SELECT ABS(CHECKSUM(NewID()) % 10 + 1);
SELECT RAND() * 5;
SELECT ROUND(RAND() * (15 - 10 - 1) + 10, 0);
