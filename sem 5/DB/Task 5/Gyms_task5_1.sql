DROP TRIGGER IF EXISTS [dbo].[trClientUpdateCheck]
DROP TRIGGER IF EXISTS [dbo].[trEmployeeInsertCheck]
DROP TRIGGER IF EXISTS [dbo].[trLockerUpdateCheck]
DROP TRIGGER IF EXISTS [dbo].[trInventCheck]
DROP TRIGGER IF EXISTS [dbo].[tarDelete]
DROP TRIGGER IF EXISTS [dbo].[employeeDelete]

--AFTER TRIGGERS

--1. INSERT
--Если добавлено новое оборудование, то поставить дату проверки у него через год и установить NeedReplacement = 0. 
--Если добавлено оборудование типа 1, то поставить дату проверки через пять лет и установить NeedReplacement = 0.
GO
CREATE TRIGGER trInventCheck ON Inventory
AFTER INSERT
AS
BEGIN
  DECLARE 
	@ID_gym int,
	@ItemName nvarchar(16),
	@SerialNumber int,
	@ID_type int
  SELECT
    @ID_gym = ID_gym,
	@ItemName = ItemName,
	@SerialNumber = SerialNumber,
	@ID_type = ID_type
	FROM inserted
  IF @ID_type = 1
  BEGIN
    UPDATE Inventory
	  SET CheckDate = DATEADD(year, 5, GETDATE()),
	      NeedReplacement = 0
	  WHERE ID_item IN (SELECT ID_item FROM inserted)
  END
  ELSE
  BEGIN
    UPDATE Inventory
	  SET CheckDate = DATEADD(year, 1, GETDATE()),
	      NeedReplacement = 0
	  WHERE ID_item IN (SELECT ID_item FROM inserted)
  END
END
GO

--Тест
INSERT INTO Inventory(ItemName, ID_type, ID_gym, SerialNumber)
		VALUES	('Блин 10кг Чёрный', 1, 1, 120005)
SELECT * FROM Inventory

--2. DELETE
--При удалении сотрудника проверить, остались ли администраторы в зале, из которого удалили сотрудника
--Если количество администраторов равно нулю, то поставить префикс [NO ADMIN]
GO
CREATE TRIGGER employeeDelete ON Employees
AFTER DELETE
AS
IF @@ROWCOUNT = 1
BEGIN
  DECLARE 
    @Count int,
	@Title nvarchar(30),
	@ID_gym int = (SELECT ID_gym FROM deleted)
  SET @Title = (SELECT Title 
               FROM deleted AS e
			   INNER JOIN Gyms AS g
			   ON e.ID_gym = g.ID_gym)
  SET @Count = (SELECT COUNT(*) FROM Employees WHERE Occupation = 'Administrator' AND ID_gym IN (@ID_gym))
  IF (@Count = 0)
  BEGIN
    UPDATE Gyms
	  SET Title = CONCAT('[NO ADMIN]', @Title)
	  WHERE ID_gym = @ID_gym
  END
END
GO

--Тест
SELECT * FROM Employees
SELECT * FROM Gyms

SELECT * FROM Employees
WHERE ID_gym = 10010 AND Occupation = 'Administrator'
SELECT * FROM Gyms
WHERE ID_gym = 10010

DELETE FROM Employees
WHERE ID_employee = 10141

SELECT * FROM Employees
WHERE ID_gym = 10010 AND Occupation = 'Administrator'
SELECT * FROM Gyms
WHERE ID_gym = 10010

--Откат
UPDATE Gyms
  SET Title = 'MetroFitness'
  WHERE ID_gym = 10010
INSERT INTO Employees(ID_gym, Lastname, FirstName, Surname, PhoneNumber, BirthDate, Occupation)
	VALUES (10010, 'Мадамова', 'Евгения', 'Сергеевна', '+79473457109', '1977-03-05', 'Administrator')


--3. UPDATE
--Если новая дата окончания аренды шкафчика становится позже текущей, то установить 0 (иначе установить единицу)
GO
CREATE TRIGGER trLockerUpdateCheck ON Lockers
AFTER UPDATE
AS
BEGIN
  DECLARE @ExpiringDate date
  SELECT @ExpiringDate = ExpiringDate
  FROM inserted
  IF @ExpiringDate > GETDATE()
  BEGIN
	UPDATE Lockers
	  SET Expired = 0
	  WHERE ID_locker = (SELECT ID_locker FROM inserted)
  END
  ELSE
  BEGIN
	UPDATE Lockers
	  SET Expired = 1
	  WHERE ID_locker = (SELECT ID_locker FROM inserted)
  END
END
GO

--Тест
UPDATE Lockers
	SET ExpiringDate = '2024.04.07'
	WHERE ID_locker = 1

SELECT * FROM Lockers

--INSTEAD OF TRIGGER
--1. INSERT
--Запрос вставки дополняется проверкой на дату: если дата рождения больше текущей, то выводится сообщение об ошибке
GO
CREATE TRIGGER trEmployeeInsertCheck ON Employees
INSTEAD OF INSERT
AS
BEGIN
  DECLARE 
	@ID_gym int,
	@Lastname nvarchar(16),
	@Firstname nvarchar(16),
	@Surname nvarchar(16),
	@PhoneNumber nvarchar(16),
	@BirthDate date,
	@Occupation nvarchar(40)
  SELECT
    @ID_gym = ID_gym,
	@Lastname = Lastname,
	@Firstname = Firstname,
	@Surname = Surname,
	@PhoneNumber = PhoneNumber,
	@BirthDate = BirthDate,
	@Occupation = Occupation
	FROM inserted
  IF @BirthDate > GETDATE()
  BEGIN
	ROLLBACK TRAN
    RAISERROR('Эта дата ещё не наступила!', 0, 1) WITH NOWAIT
  END
  ELSE
  BEGIN
    INSERT Employees(ID_gym, Lastname, FirstName, Surname, PhoneNumber, BirthDate, Occupation)
	VALUES (@ID_gym, @Lastname, @Firstname, @Surname, @PhoneNumber, @BirthDate, @Occupation)
  END
END;
GO

--Тест
DECLARE @BirDate date = '1915.03.05'
INSERT INTO Employees (ID_gym, Lastname, FirstName, Surname, PhoneNumber, BirthDate, Occupation)
		VALUES (40, 'Евдокимов', 'Константин', NULL, '+79272415537', @BirDate, 'Administrator')
SELECT * FROM Employees
WHERE BirthDate = @BirDate

--Откат
DELETE FROM Employees
WHERE BirthDate = @BirDate

--2. DELETE
--При удалении тарифа поставить значения NULL в группы, которые занимались по данному тарифу
GO
CREATE TRIGGER tarDelete ON Tariffs
INSTEAD OF DELETE
AS
BEGIN
  UPDATE Groups
	SET ID_tariff = NULL
	WHERE ID_tariff IN (SELECT ID_tariff FROM deleted)
END
GO

--Тест
SELECT * FROM Groups
SELECT * FROM Tariffs

DELETE FROM Tariffs
WHERE ID_tariff = 1

SELECT * FROM Groups
SELECT * FROM Tariffs

--Откат
UPDATE Groups
  SET ID_tariff = 1
  WHERE ID_tariff IS NULL

--3. UPDATE
--Проверяет, начинается ли обновляемый номер с +7 и содержит ли он 12 символов (+ и ещё 11 цифр) 
GO
CREATE TRIGGER trClientUpdateCheck ON Clients 
INSTEAD OF UPDATE
AS
BEGIN
  DECLARE @Phone nvarchar(16) 
  SELECT @Phone = PhoneNumber FROM inserted
  IF @Phone NOT LIKE '+%'
  OR LEN(@Phone) != 12 
  BEGIN
    ROLLBACK TRAN
    RAISERROR('Номер телефона начинается с +7', 0, 1) WITH NOWAIT
  END
  ELSE
	  UPDATE Clients
		SET PhoneNumber = @Phone
		WHERE ID_client IN (SELECT ID_client FROM inserted);
END;
GO

--Тест
UPDATE Clients 
	SET PhoneNumber = '+71234567890' 
	WHERE ID_client = 1

SELECT * FROM Clients
WHERE ID_client = 1