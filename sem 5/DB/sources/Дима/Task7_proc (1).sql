--расчет суммарной прибыли от покупки абонементов за какой-то период
CREATE PROCEDURE CalculateTotalCost
    @StartDate DATE,
    @EndDate DATE
AS
    SELECT SUM(ST.Price) AS TotalCost
    FROM PurchasedST AS PST
    INNER JOIN SeasonTicketType AS ST ON PST.ID_STT = ST.ID_STT
    WHERE PST.PurchaseDate >= @StartDate
    AND PST.PurchaseDate <= @EndDate



SELECT PST.PurchaseDate, SeasonTicketType.Price FROM PurchasedST AS PST
	INNER JOIN SeasonTicketType
	ON PST.ID_STT = SeasonTicketType.ID_STT 

EXEC CalculateTotalCost '2020-01-01', '2024-12-31'

DROP PROCEDURE CalculateTotalCost

-- Посчёт потраченных средств для каждого клиента
CREATE PROCEDURE ClientExpenses

AS
    SELECT C.LastName + ' ' + C.FirstName AS ClientName, 
           SUM(ST.Price) AS TotalSpentAmount
    FROM Clients AS C
    INNER JOIN PurchasedST AS PST ON C.ID_Client = PST.ID_Client
    INNER JOIN SeasonTicketType AS ST ON PST.ID_STT = ST.ID_STT
    GROUP BY C.ID_Client, C.LastName, C.FirstName

EXEC ClientExpenses

DROP PROCEDURE ClientExpenses

-- Нахождения самого загруженного дня
CREATE PROCEDURE MostFrequentDay
AS
    WITH DayOfWeekCounts AS (
        SELECT Day_of_week, COUNT(*) AS DayCount
        FROM Schedule
        GROUP BY Day_of_week
    )
    SELECT Day_of_week AS MostFrequentDayOfWeek, DayCount
    FROM DayOfWeekCounts
    WHERE DayCount = (SELECT MAX(DayCount) FROM DayOfWeekCounts)

EXEC MostFrequentDay


DROP PROCEDURE MostFrequentDay

-- Проверка наличия фамилии в списке клиентов 

CREATE PROCEDURE ReturnBasedOnCondition
    @ClientLastName varchar
AS
    IF EXISTS (SELECT 1 FROM Clients WHERE LastName = @ClientLastName)
    RETURN 1
    ELSE
	RETURN 0

EXEC ReturnBasedOnCondition 'Колдман'

DROP PROCEDURE ReturnBasedOnCondition

-- Возврат номера телефонна в переменной

CREATE PROCEDURE GetClientPhoneNumber
    @ClientID int,
    @PhoneNumber nvarchar(16) OUTPUT
AS
    SELECT @PhoneNumber = PhoneNumber
    FROM Clients
    WHERE ID_Client = @ClientID


DECLARE @ClientPhoneNumber nvarchar(16)
EXEC GetClientPhoneNumber @ClientID = 5, @PhoneNumber = @ClientPhoneNumber OUTPUT
SELECT FirstName, LastName, @ClientPhoneNumber as PhoneNumber FROM Clients
WHERE ID_Client = 5

DROP PROCEDURE GetClientPhoneNumber

-- КУРСОР 

CREATE PROCEDURE GetPeopleInGroup
    @GroupID int
AS
    DECLARE @ClientID int
    DECLARE @LastName nvarchar(60)
    DECLARE @FirstName nvarchar(50)

    DECLARE people_cursor CURSOR FOR
    SELECT PiN.ID_Client, LastName, FirstName
    FROM PeopleInGroup AS PiN
    INNER JOIN Clients ON PiN.ID_Client = Clients.ID_Client
    WHERE ID_Group = @GroupID;

    OPEN people_cursor
    FETCH NEXT FROM people_cursor INTO @ClientID, @LastName, @FirstName
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'ID: ' + CAST(@ClientID AS nvarchar(10)) + ', Last Name: ' + @LastName + ', First Name: ' + @FirstName
        FETCH NEXT FROM people_cursor INTO @ClientID, @LastName, @FirstName
    END

    CLOSE people_cursor
    DEALLOCATE people_cursor

EXEC GetPeopleInGroup @GroupID = 1;

DROP PROCEDURE GetPeopleInGroup