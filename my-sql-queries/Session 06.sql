-- 1 --
SELECT
	tt.TreatmentTypeName,
	t.TreatmentName,
	t.Price
FROM
	MsTreatment t
	JOIN MsTreatmentType tt
	ON t.TreatmentTypeId = tt.TreatmentTypeId
WHERE
	(tt.TreatmentTypeName LIKE('%hair%') OR
	tt.TreatmentTypeName LIKE('nail%')) AND
	t.Price < 100000

-- 2 --
SELECT DISTINCT
	s.StaffName,
	LOWER(LEFT(s.StaffName, 1)) +
		LOWER(REVERSE(LEFT(REVERSE(s.StaffName), CHARINDEX(' ', REVERSE(s.StaffName)) - 1))) +
		'@oosalon.com' AS StaffEmail
FROM
	MsStaff s
	JOIN HeaderSalonServices hss
	ON s.StaffId = hss.StaffId
WHERE
	DATENAME(weekday, hss.TransactionDate) = 'Thursday'

-- 5 --
SELECT
	DATENAME(weekday, hss.TransactionDate) AS Day,
	c.CustomerName,
	t.TreatmentName
FROM
	(((HeaderSalonServices hss
	JOIN MsCustomer c
	ON hss.CustomerId = c.CustomerId)
	JOIN DetailSalonServices dss
	ON dss.TransactionId = hss.TransactionId)
	JOIN MsTreatment t
	ON t.TreatmentId = dss.TreatmentId)
WHERE
	hss.StaffId IN(
		SELECT
			StaffId
		FROM
			MsStaff
		WHERE
			StaffGender = 'Female' OR
			StaffPosition LIKE('TOP%')
	)
ORDER BY
	c.CustomerName ASC

-- 6 --
SELECT
	c.CustomerId,
	c.CustomerName,
	hss.TransactionId,
	COUNT(dss.TransactionId) AS [Total Treatment]
FROM
	MsCustomer c
	JOIN HeaderSalonServices hss
	ON c.CustomerId = hss.CustomerId
	JOIN DetailSalonServices dss
	ON dss.TransactionId = hss.TransactionId
GROUP BY
	c.CustomerId,
	c.CustomerName,
	hss.TransactionId
ORDER BY
	COUNT(dss.TransactionId) DESC