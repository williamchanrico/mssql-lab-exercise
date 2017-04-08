-- 2 --
SELECT
	c.CustomerName,
	c.CustomerGender,
	c.CustomerEmail,
	[Age] = DATEDIFF(YEAR, c.CustomerDOB, '2016-03-15')
FROM
	Customer c
	JOIN HeaderTransaction ht
	ON c.CustomerID = ht.CustomerID
	JOIN Staff s
	ON ht.StaffID = s.StaffID
WHERE
	s.StaffID IN ('SF003')

-- 3 --
SELECT
	Name = 'Mr. ' + c.CustomerName,
	Phone = c.CustomerPhone,
	[Transaction Count] = CAST(COUNT(ht.TransactionID) AS VARCHAR(10)) + ' Times'
FROM
	Customer c
	JOIN HeaderTransaction ht
	ON c.CustomerID = ht.CustomerID
	JOIN Branch b
	ON ht.BranchID = b.BranchID
WHERE
	b.BranchOwner = 'Raymond'
GROUP BY
	c.CustomerName,
	c.CustomerPhone
HAVING
	COUNT(ht.TransactionID) = 1
UNION
SELECT
	Name = 'Mrs. ' + c.CustomerName,
	Phone = c.CustomerPhone,
	[Transaction Count] = CAST(COUNT(ht.TransactionID) AS VARCHAR(10)) + ' Times'
FROM
	Customer c
	JOIN HeaderTransaction ht
	ON c.CustomerID = ht.CustomerID
	JOIN Branch b
	ON ht.BranchID = b.BranchID
WHERE
	b.BranchOwner = 'Paulus Robin' AND
	c.CustomerGender = 'Female'
GROUP BY
	c.CustomerName,
	c.CustomerPhone
HAVING
	COUNT(ht.TransactionID) = 1

-- 4 --
SELECT
	c.CakeID,
	c.CakeName,
	c.CakeSize,
	c.CakePrice,
	[Count] = CAST(COUNT(dt.CakeID) AS VARCHAR(20)) + ' Times'
FROM
	Cake c
	JOIN DetailTransaction dt
	ON c.CakeID = dt.CakeID
	JOIN HeaderTransaction ht
	ON dt.TransactionID = ht.TransactionID
	JOIN Branch b
	ON ht.BranchID = b.BranchID
WHERE
	b.BranchID = 'BR002' AND
	dt.CakeDecoration = 'NO'
GROUP BY
	c.CakeID,
	c.CakeName,
	c.CakeSize,
	c.CakePrice
ORDER BY
	c.CakePrice ASC

-- 5 --
SELECT
	[StaffCode] = STUFF(s.StaffID, 1, 2, 'Staff '),
	s.StaffName,
	s.StaffGender,
	[StaffDOB] = CONVERT(VARCHAR(20), s.StaffDOB, 107),
	s.StaffPhone
FROM
	Staff s
	JOIN HeaderTransaction ht
	ON s.StaffID = ht.StaffID
	JOIN Customer cu
	ON ht.CustomerID = cu.CustomerID,
	(
	SELECT
		[AvgCakePrice] = AVG(c.CakePrice)
	FROM
		Cake c
	) AS c2
WHERE
	(s.StaffSalary / 30) < c2.AvgCakePrice AND
	DATENAME(MONTH, cu.CustomerDOB) = 'July'

