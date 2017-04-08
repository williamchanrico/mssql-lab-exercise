
-- 1 --
SELECT
	MAX(t.Price) AS [Maximum Price],
	MIN(t.Price) AS [Minimum Price],
	ROUND(CAST(AVG(t.Price) AS NUMERIC(10, 2)), 0) AS [Average Price]
FROM
	MsTreatment t

-- 2 --
SELECT
	s.StaffPosition,
	LEFT(s.StaffGender, 1),
	ROUND(CAST(AVG(s.StaffSalary) AS NUMERIC(10, 2)), 0) AS [Average Price]
FROM
	MsStaff s
GROUP BY
	s.StaffPosition,
	s.StaffGender

-- 3 --
SELECT
	hss.TransactionDate,
	COUNT(hss.TransactionId) AS [Total Transaction per Day]
FROM
	HeaderSalonServices hss
GROUP BY
	hss.TransactionDate	

-- 4 --
SELECT
	c.CustomerGender,
	COUNT(hss.TransactionId)
FROM 
	HeaderSalonServices hss
	JOIN MsCustomer c
	ON
		c.CustomerId = hss.CustomerId
GROUP BY
	c.CustomerGender

-- 5 --
SELECT
	tt.TreatmentTypeName,
	COUNT(t.TreatmentId) AS [Total Transaction]
FROM
	MsTreatment t
	JOIN MsTreatmentType tt
	ON
		t.TreatmentTypeId = tt.TreatmentTypeId
GROUP BY
	tt.TreatmentTypeName
ORDER BY
	COUNT(t.TreatmentId) DESC

-- 6 --
SELECT
	hss.TransactionDate AS [Date],
	'Rp. ' + CAST(CAST(SUM(t.Price) AS NUMERIC(10, 2)) AS VARCHAR(20)) AS [Revenue per Day]
FROM
	((HeaderSalonServices hss
	JOIN DetailSalonServices dss
	ON
		hss.TransactionId = dss.TransactionId)
	JOIN MsTreatment t
	ON
		dss.TreatmentId = t.TreatmentId)
GROUP BY
	hss.TransactionDate
HAVING
	SUM(t.Price)  BETWEEN 1000000 AND 5000000

-- 7 --
SELECT
	REPLACE(t.TreatmentTypeId, 'TT0', 'Treatment Type ') AS [ID],
	tt.TreatmentTypeName,
	COUNT(t.TreatmentName) AS [Total Treatment per Type]
FROM
	MsTreatment t,
	MsTreatmentType tt
WHERE
	t.TreatmentTypeId = tt.TreatmentTypeId
GROUP BY 
	tt.TreatmentTypeName,
	t.TreatmentTypeId
HAVING
	COUNT(t.TreatmentName) > 5
ORDER BY 
	COUNT(t.TreatmentName) DESC

-- 8 --
SELECT
	LEFT(s.StaffName, CHARINDEX(' ', s.StaffName)) AS [StaffName],
	dss.TransactionId,
	COUNT(dss.TreatmentId) AS [Total Treatment per Transaction]
FROM
	DetailSalonServices dss,
	MsStaff s,
	HeaderSalonServices hss
WHERE
	hss.TransactionId = dss.TransactionId AND
	s.StaffId = hss.StaffId
GROUP BY
	dss.TransactionId,
	s.StaffName

-- 9 --
SELECT
	hss.TransactionDate,
	c.CustomerName,
	t.TreatmentName,
	t.Price
FROM
	((((HeaderSalonServices hss
	JOIN MsCustomer c
	ON
		hss.CustomerId = c.CustomerId)
	JOIN MsStaff s
	ON
		hss.StaffId = s.StaffId)
	JOIN DetailSalonServices dss
	ON
		dss.TransactionId = hss.TransactionId)
	JOIN MsTreatment t
	ON
		t.TreatmentId = dss.TreatmentId)
WHERE
	s.StaffName LIKE('%Ryan%') AND
	DATENAME(weekday, hss.TransactionDate) = 'Thursday'
ORDER BY
	hss.TransactionDate ASC,
	c.CustomerName ASC

-- 10 --
SELECT
	hss.TransactionDate,
	c.CustomerName,
	SUM(t.Price)
FROM
	((HeaderSalonServices hss
	JOIN MsCustomer c
	ON
		hss.CustomerId = c.CustomerId)
	JOIN DetailSalonServices dss
	ON
		hss.TransactionId = dss.TransactionId)
	JOIN MsTreatment t
	ON
		t.TreatmentId = dss.TreatmentId
WHERE
	DATEPART(day, hss.TransactionDate) > 20
GROUP BY
	c.CustomerName,
	hss.TransactionDate
ORDER BY
	hss.TransactionDate ASC
	