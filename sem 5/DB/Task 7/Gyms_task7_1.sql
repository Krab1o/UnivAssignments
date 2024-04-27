DROP PROCEDURE IF EXISTS [dbo].[MostFrequentDay]
DROP PROCEDURE IF EXISTS [dbo].[GetEmployees]
DROP PROCEDURE IF EXISTS [dbo].[GetInvent]
DROP PROCEDURE IF EXISTS [dbo].[GetEmployeePhoneNumber]
DROP PROCEDURE IF EXISTS [dbo].[GetCoachesOlder]

SELECT * FROM Schedule
--1. Поиск самого загруженного дня в расписании 
--(Простая процедура)
GO
CREATE PROCEDURE MostFrequentDay
AS
    WITH DayOfWeekCounts AS (
        SELECT Day, COUNT(*) AS DayCount
        FROM Schedule
        GROUP BY Day
    )
    SELECT Day AS MostFrequentDayOfWeek, DayCount
    FROM DayOfWeekCounts
    WHERE DayCount = (SELECT MAX(DayCount) FROM DayOfWeekCounts)
GO

--Test
EXEC MostFrequentDay
SELECT Employees.*, Gyms.Title FROM Employees LEFT JOIN Gyms ON Employees.ID_gym = Gyms.ID_gym

--2. Поиск 
--(С передаваемыми переменными)
GO
CREATE PROCEDURE GetEmployees @Title1 varchar(255), @Title2 varchar(255)
AS
  BEGIN
	SELECT * FROM Employees WHERE ID_gym = (SELECT ID_gym FROM Gyms
	      			                        WHERE Title = @Title1 OR
												  Title = @Title2)
  END
GO

--Test
EXEC GetEmployees 'FirstGym', 'Safia'

--3. Вывод всех инвентарных принадлежностей данного зала
--(С курсором)
GO
CREATE PROCEDURE GetInvent @ID_gym int
AS
	DECLARE @ItemName nvarchar(50)
    DECLARE @CheckDate date
    DECLARE @Type nvarchar(50)

    DECLARE invent_cursor CURSOR FOR
    SELECT inv.ItemName, inv.CheckDate, t.Type
    FROM Inventory AS inv
		LEFT JOIN ItemTypes AS t
		ON inv.ID_type = t.ID_type
    WHERE ID_gym = @ID_gym;

    OPEN invent_cursor
    FETCH NEXT FROM invent_cursor INTO @ItemName, @CheckDate, @Type
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Item Name: ' + @ItemName 
			  + ' Check Date: ' + CAST(@CheckDate AS nvarchar(12)) 
			  + ' Type: ' + @Type
        FETCH NEXT FROM invent_cursor INTO @ItemName, @CheckDate, @Type
    END

    CLOSE invent_cursor
    DEALLOCATE invent_cursor
GO

--Test
EXEC GetInvent 2;

--4. Процедура возвращает номер телефона
GO
CREATE PROCEDURE GetEmployeePhoneNumber
    @ID_employee int,
    @PhoneNumber nvarchar(16) OUTPUT
AS
    SELECT @PhoneNumber = PhoneNumber
    FROM Employees
    WHERE ID_Employee = @ID_employee
GO

--Test
SELECT * FROM Employees

DECLARE @EmployeePhoneNumber nvarchar(16)
EXEC GetEmployeePhoneNumber 5, @PhoneNumber = @EmployeePhoneNumber OUTPUT

SELECT FirstName, LastName, @EmployeePhoneNumber AS PhoneNumber FROM Employees
WHERE ID_Employee = 5

SELECT PhoneNumber FROM Employees
WHERE ID_Employee = 5

--5. Подсчёт первых N людей с ID > данного, которые старше данного тренера
--Циклы, условия, возвращаемое значение

GO 
CREATE PROCEDURE GetCoachesOlder
	@TargetID int,
	@N int
AS
	CREATE TABLE #FinalTable (
		ID_coach int,
		FirstName nvarchar(16),
		Lastname nvarchar(16),
		Surname nvarchar(16),
		Rating float,
		BirthDate date
	)
	DECLARE	@TargetCoachBirthDate date
	SELECT @TargetCoachBirthDate = BirthDate FROM Coaches WHERE ID_Coach = @TargetID
	--New Coach Declaration
	DECLARE
	    @ID_coach int,
		@FirstName nvarchar(16),
		@Lastname nvarchar(16),
		@Surname nvarchar(16),
		@Rating float,
		@BirthDate date

	--Iterating Coach Parameters
	DECLARE
	  @currentN int = 0,
	  @currentCoach int = @TargetID + 1,
	  @previousCoachID int = 0

	WHILE (@currentN < @N AND @currentCoach < (SELECT COUNT(*) FROM Coaches))
	BEGIN
	  --New Coach Init
	  SELECT
	    @ID_coach = ID_coach,
		@FirstName = Firstname,
		@Lastname = Lastname,
		@Surname = Surname,
		@Rating = Rating,
		@BirthDate = BirthDate
		FROM Coaches
		WHERE ID_coach = @currentCoach

	  IF (@previousCoachID = @ID_coach)
	  BEGIN
	    SET @currentCoach = @currentCoach + 1
	    CONTINUE
	  END
	  IF (@BirthDate < @TargetCoachBirthDate)
		BEGIN
		  INSERT INTO #FinalTable
		    VALUES (@ID_coach, @FirstName, @Lastname, @Surname, @Rating, @BirthDate)
		  SET @CurrentN = @CurrentN + 1
		END
	  SET @previousCoachID = @ID_coach
	  SET @currentCoach = @currentCoach + 1
	END

	SELECT * FROM #FinalTable

	IF (@currentN = @N)
		RETURN 0
	ELSE
		RETURN 1
GO

--Test
SELECT * FROM Coaches
EXEC GetCoachesOlder 1, 7

