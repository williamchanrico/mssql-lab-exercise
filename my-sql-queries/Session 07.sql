-- 1 --
SELECT
	TreatmentId,
	TreatmentName
FROM
	MsTreatment
WHERE
	TreatmentId IN('TM001', 'TM002')

-- 2 --
SELECT
	t.TreatmentName,
	t.Price
FROM
	MsTreatment t
	JOIN MsTreatmentType tt
	ON t.TreatmentTypeId = tt.TreatmentTypeId
WHERE
	tt.TreatmentTypeName NOT IN('Hair Treatment', 'Message / Spa')

-- 3 --
SELECT
	c.CustomerName,
	c.CustomerPhone,
	c.CustomerAddress
FROM
	MsCustomer c
WHERE
	LEN(c.CustomerName) > 8 AND
	c.CustomerName IN(
		SELECT
			c.CustomerName
		FROM
			HeaderSalonServices hss
			JOIN MsCustomer c
			ON hss.CustomerId = c.CustomerId
		WHERE
			DATENAME(WEEKDAY, hss.TransactionDate) = 'Friday'
	)
	
-- 4 --
SELECT
	tt.TreatmentTypeName,
	t.TreatmentName,
	t.Price
FROM
	MsTreatment t
	JOIN MsTreatmentType tt
	ON t.TreatmentTypeId = tt.TreatmentTypeId
	JOIN DetailSalonServices dss
	ON dss.TreatmentId = t.TreatmentId
	JOIN HeaderSalonServices hss
	ON hss.TransactionId = dss.TransactionId
WHERE
	DATEPART(day, hss.TransactionDate) = 22 AND
	hss.CustomerId IN(
		SELECT
			c.CustomerId
		FROM
			MsCustomer c
		WHERE
			c.CustomerName LIKE('%Putra%')
	)

-- 5 --
SELECT
	s.StaffName,
	c.CustomerName,
	CONVERT(VARCHAR(20), hss.TransactionDate, 107)
FROM
	HeaderSalonServices hss
	JOIN MsStaff s
	ON s.StaffId = hss.StaffId
	JOIN MsCustomer c
	ON c.CustomerId = hss.CustomerId
WHERE
	EXISTS(
		SELECT
			*
		FROM
			DetailSalonServices dss
		WHERE
			hss.TransactionId = dss.TransactionId AND
			RIGHT(dss.TreatmentId, 1) % 2 = 0
	)

-- 6 --
SELECT
	c.CustomerName,
	c.CustomerPhone,
	c.CustomerAddress
FROM
	MsCustomer c
WHERE
	EXISTS(
		SELECT
			hss.CustomerId
		FROM
			HeaderSalonServices hss
			JOIN MsStaff s
			ON s.StaffId = hss.StaffId
		WHERE
			LEN(s.StaffName) % 2 = 1 AND
			c.CustomerId = hss.CustomerId
	)

-- 7 --
SELECT
	ID = RIGHT(s.StaffId, 3),
	Name = SUBSTRING(s.StaffName, CHARINDEX(' ', s.StaffName) + 1, CHARINDEX(' ', s.StaffName, CHARINDEX(' ', s.StaffName) + 1) - CHARINDEX(' ', s.StaffName) - 1)
FROM
	MsStaff s
WHERE
	s.StaffName LIKE('% % %') AND
	EXISTS(
		SELECT
			*
		FROM
			HeaderSalonServices hss
			JOIN MsCustomer c
			ON hss.CustomerId = c.CustomerId
		WHERE
			s.StaffId = hss.StaffId AND
			c.CustomerGender != 'Male'
	)
	
-- 8 --
SELECT
	tt.TreatmentTypeName,
	t.TreatmentName,
	t.Price
FROM
	MsTreatment t
	JOIN MsTreatmentType tt
	ON t.TreatmentTypeId = tt.TreatmentTypeId,
	(
		SELECT
			average = AVG(Price)
		FROM
			MsTreatment
	) AS AliasAvg
WHERE
	t.Price > AliasAvg.average

-- 9 --
SELECT
	s.StaffName,
	s.StaffPosition,
	s.StaffSalary
FROM
	MsStaff s,
	(
		SELECT
			maxCol = MAX(StaffSalary)
		FROM
			MsStaff
	) AS AliasMax,
	(
		SELECT
			minCol = MIN(StaffSalary)
		FROM
			MsStaff
	) AS AliasMin
WHERE
	s.StaffSalary IN(AliasMax.maxCol, AliasMin.minCol)

-- 10 --
SELECT
	c.CustomerName,
	c.CustomerPhone,
	c.CustomerAddress,
	COUNT(dss.TransactionId)
FROM
	MsCustomer c
	JOIN HeaderSalonServices hss
	ON c.CustomerId = hss.CustomerId
	JOIN DetailSalonServices dss
	ON hss.TransactionId = dss.TransactionId,
	(
		SELECT
			maxCol = MAX(AliasCount.countCol)
		FROM
			(
				SELECT
					dss.TransactionId,
					countCol = COUNT(dss.TreatmentId)
				FROM
					DetailSalonServices dss
				GROUP BY
					dss.TransactionId
			) AS AliasCount
	) AS AliasMax
GROUP BY
	c.CustomerName,
	c.CustomerPhone,
	c.CustomerAddress
HAVING
	COUNT(dss.TransactionId) = MAX(AliasMax.maxCol)
