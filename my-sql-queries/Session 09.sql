-- INTERMEZZO --
sp_msforeachtable 'SELECT * FROM ?'

-- CURSOR --
DECLARE @staffName VARCHAR(20)
DECLARE @db_cursor CURSOR

SET @db_cursor = CURSOR FOR
SELECT staffName FROM MsStaff

OPEN @db_cursor
FETCH NEXT FROM @db_cursor INTO @staffName

WHILE @@FETCH_STATUS = 0
BEGIN
	IF(LEN(@staffName) % 2 = 0)
		PRINT @staffName + 'is Even (' + CAST(LEN(@staffName) AS VARCHAR(20)) + ').'
	ELSE
		PRINT @staffName + 'is Odd (' + CAST(LEN(@staffName) AS VARCHAR(20)) + ').'

	FETCH NEXT FROM @db_cursor INTO @staffName
END

-- TRIGGER --
CREATE TRIGGER trig1 ON MsStaff
FOR DELETE AS
SELECT
	*
FROM
	DELETED
GO

BEGIN TRAN
	DELETE FROM MsStaff WHERE StaffId = 'SF001'
ROLLBACK
GO

CREATE TRIGGER trig2 ON MsStaff
FOR UPDATE AS
	SELECT
		*
	FROM
		DELETED
	UNION
	SELECT
		*
	FROM
		INSERTED
	GO

BEGIN TRAN
UPDATE MsStaff
	SET StaffId = 'SF156'
	WHERE StaffId = 'SF001'
ROLLBACK
GO

-- FUNCTION --
CREATE FUNCTION dbo.func1(@x INT, @y INT)
RETURNS INT
BEGIN
	RETURN (@x + @y)
END
GO

SELECT dbo.func1(2,5)
GO

DROP FUNCTION dbo.func1
GO

CREATE FUNCTION dbo.func2(@keyword VARCHAR(255))
RETURNS TABLE
	RETURN
		SELECT
			*
		FROM
			MsStaff
		WHERE
			StaffName LIKE('%' + @keyword + '%')
GO

SELECT * FROM dbo.func2('e')
GO

DROP FUNCTION dbo.func2
GO

-- PROCEDURE --
CREATE PROC prog1(@name VARCHAR(255)) AS
	SELECT
		*
	FROM
		MsStaff
	WHERE
		StaffName LIKE('%' + @name + '%')
GO

EXEC prog1 'e'
GO