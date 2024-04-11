-- //////////////////////////////
-- AFTER INSERT & DELETE TRIGGER
-- //////////////////////////////
-- ��� ��������� ������� PeopleInGroup (�������� ��� ���������� ������) 
-- � ������� Groups ���������� ���������� ����, ���������� �� ���-�� ����� � ������ � ������ ��������
CREATE TRIGGER INS_DEL_PIN_Trigger
ON PeopleInGroup
AFTER INSERT, DELETE
AS
IF @@ROWCOUNT=1
DECLARE @GroupID int;
BEGIN
    -- �������� ID ������, � ������� ��������� ����������� ��� ��������� ������
    SELECT @GroupID = ID_Group FROM inserted  -- ��� �������
    IF @GroupID IS NULL
        SELECT @GroupID = ID_Group FROM deleted  -- ��� ��������

    -- ��������� ���������� ����� � ������
    UPDATE Groups
    SET AmountPeople = (SELECT COUNT(*) FROM PeopleInGroup WHERE ID_Group = @GroupID)
    WHERE ID_Group = @GroupID;
END;
SELECT * FROM Clients
SELECT * FROM PeopleInGroup
SELECT * FROM Groups
INSERT INTO PeopleInGroup (ID_Client, ID_Group) VALUES (3, 1)
--SELECT * FROM PeopleInGroup
--SELECT * FROM Groups
DELETE FROM PeopleInGroup
WHERE ID_Group = 1;
--SELECT * FROM PeopleInGroup
--SELECT * FROM Groups
DROP TRIGGER INS_DEL_PIN_Trigger

-- //////////////////// 
-- AFTER UPDATE TRIGGER
-- ////////////////////
-- ���� ����� ���������� �������� � ������� ��� �������� ������� �� ������� [0.0 ; 5.0]
-- �� ������� ������ � �������� �������� 
CREATE TRIGGER tr_update_rating ON Coaches
AFTER UPDATE
AS
BEGIN

    DECLARE @CoachID int, @CoachRating float;

    -- ���������� ������ ��� ��������� ����������� �����
    DECLARE UpdatedCursor CURSOR FOR
    SELECT ID_Coach, Rating
    FROM inserted; -- �� ���������� inserted, ������ ��� �� ����� ��������� ����� �������� ����� ����������

    OPEN UpdatedCursor;
    FETCH NEXT FROM UpdatedCursor INTO @CoachID, @CoachRating;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @CoachRating < 0.0 OR @CoachRating > 5.0
        BEGIN
			ROLLBACK TRAN
            RAISERROR ('�������', 16, 10);
        END

        FETCH NEXT FROM UpdatedCursor INTO @CoachID, @CoachRating;
    END

    CLOSE UpdatedCursor;
    DEALLOCATE UpdatedCursor;
END

SELECT * FROM Coaches
UPDATE Coaches
SET Rating=-1.9
WHERE ID_Coach = 4 
SELECT * FROM Coaches
DROP TRIGGER UPD_CoachRating_Trigger

-- INSTEAD  OF INSERT TRIGGER
CREATE TRIGGER IO_INS_Attendanse_Trigger
ON Attendance
INSTEAD OF INSERT
AS
BEGIN
    
    -- ����������� ���������� ��� �������� ��������
    DECLARE @ID_PurchasedST int, @AttendanceDate date;

    -- ������� ������ ��� ��������� ����������� �����
    DECLARE InsertedCursor CURSOR FOR
    SELECT ID_PurchasedST, _Date
    FROM inserted;

    OPEN InsertedCursor;
    FETCH NEXT FROM InsertedCursor INTO @ID_PurchasedST, @AttendanceDate;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- ��������� �������� ���� ��������� � ���� ��������� ����������
        DECLARE @EndData date;
			SELECT @EndData = EndData
			FROM PurchasedST
			WHERE ID_PurchasedST = @ID_PurchasedST;

        IF @AttendanceDate > @EndData
        BEGIN
            -- ���� ���� ��������� ������ ���� ��������� ����������
			ROLLBACK TRAN
            RAISERROR ('���������', 16, 10);
        END
        ELSE
        BEGIN
            -- ��������� ������, ���� ������� �� �����������
            INSERT INTO Attendance (ID_PurchasedST, ID_Schedule, _Date)
            VALUES (@ID_PurchasedST, (SELECT ID_Schedule FROM inserted WHERE ID_PurchasedST = @ID_PurchasedST), @AttendanceDate);
        END

        FETCH NEXT FROM InsertedCursor INTO @ID_PurchasedST, @AttendanceDate;
    END

    CLOSE InsertedCursor;
    DEALLOCATE InsertedCursor;
END


SELECT * FROM Attendance
SELECT * FROM PurchasedST

INSERT INTO Attendance (ID_PurchasedST, ID_Schedule, _Date)
VALUES	(2, 1 , '10-09-2023'),
		(3, 4 , '10-11-2024');

DROP TRIGGER IO_INS_Attendanse_Trigger

-- INSTEAD OF UPDATE TRIGGER
CREATE TRIGGER IO_UPD_Price_trigger
ON SeasonTicketType
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @CurrentPrice DECIMAL, @NewPrice DECIMAL, @PercentageChange DECIMAL;

    SELECT @CurrentPrice = Price FROM SeasonTicketType WHERE ID_STT IN (SELECT ID_STT FROM inserted);
    SELECT @NewPrice = Price FROM inserted;

    IF (@NewPrice > @CurrentPrice * 1.1)
    BEGIN
        -- ���� ����� ���� �� 10% ������ �������
		ROLLBACK TRAN
        RAISERROR ('������ ���������, ��� ������� �����������', 16, 10)
    END
    ELSE IF (@NewPrice < @CurrentPrice * 0.9)
    BEGIN
        -- ���� ����� ���� �� 10% ������ �������
		ROLLBACK TRAN
        RAISERROR ('������ ���������, �������� ���������', 16, 10);
    END
    ELSE
    BEGIN
        -- ��������� ����, ���� ��� ������������� ��������
        UPDATE SeasonTicketType
        SET Price = @NewPrice
        WHERE ID_STT IN (SELECT ID_STT FROM inserted);
    END
END

SELECT * FROM SeasonTicketType

UPDATE SeasonTicketType
SET Price = 200
WHERE ID_Gym = 2 

SELECT * FROM SeasonTicketType

UPDATE SeasonTicketType
SET Price = Price * 1.2
WHERE ID_TypeOfSport = 2

SELECT * FROM SeasonTicketType

DROP TRIGGER IO_UPD_Price_trigger

-- //////////////////////////
-- INSTEAD OF DELETE TRIGGER 
-- /////////////////////////
CREATE TRIGGER IO_DEL_Coach_Trigger
ON Coaches
INSTEAD OF DELETE
AS
BEGIN

    DECLARE @DeletedCoachID int;
    
    -- ������� ��������� ������� ��� �������� ���������� �������� ������� ID_Coach � ������� Schedule
    CREATE TABLE #CoachUsage (CoachID INT, UsageCount INT);

    -- ��������� ������� ID_Coach � ������� Schedule � ��������� ��������� �� ��������� �������
    INSERT INTO #CoachUsage (CoachID, UsageCount)
    SELECT s.ID_Coach, COUNT(*) AS UsageCount
    FROM Schedule s
    WHERE s.ID_Coach IN (SELECT ID_Coach FROM deleted)
    GROUP BY s.ID_Coach;

    -- ��������� ID_Coach, ��� �������� ���� ������� ������������� � ������� Schedule
    SELECT @DeletedCoachID = CoachID FROM #CoachUsage WHERE UsageCount > 0;

    -- ������� ��������� ��� ���������� �������� � ����������� �� ����������
    IF @DeletedCoachID IS NOT NULL
    BEGIN
        -- ���� ID_Coach ������ � ������� Schedule
		ROLLBACK TRAN
        RAISERROR ('���������� ����� ������ ������� ����� ���������', 16, 10);
    END
    ELSE
    BEGIN
        -- ���� ID_Coach �� ������ � ������� Schedule, ��������� ��������
        DELETE FROM Coaches WHERE ID_Coach IN (SELECT ID_Coach FROM deleted);
    END

    -- ������� ��������� �������
    DROP TABLE #CoachUsage;
END

-- ����������� ������� � ��������� ��������� �� ������� Attendance
CREATE TRIGGER IO_DEL_Coach_Trigger
ON Coaches
INSTEAD OF DELETE
AS
BEGIN
    -- ������� ��������������� ������ �� ������� Schedule, ��������� JOIN � �������� deleted
    DELETE FROM Schedule
    WHERE ID_Coach IN (SELECT ID_Coach FROM deleted);

    -- ������� ��������������� ������ �� ������� Attendance, ��������� JOIN � �������� Schedule
    DELETE FROM Attendance
    WHERE ID_Schedule IN (SELECT ID_Schedule FROM Schedule);

    -- ������� �������� �� ������� Coaches, ��������� JOIN � �������� deleted
    DELETE FROM Coaches 
    WHERE ID_Coach IN (SELECT ID_Coach FROM deleted);
END



SELECT * FROM Schedule
SELECT * FROM Coaches

DELETE FROM Coaches
WHERE LastName = '��������'

DELETE FROM Coaches
WHERE ID_Coach = 6
SELECT * FROM Schedule
SELECT * FROM Coaches

DROP TRIGGER IO_DEL_Coach_Trigger
