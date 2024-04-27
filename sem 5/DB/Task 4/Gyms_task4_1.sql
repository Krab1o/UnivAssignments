SET statistics TIME ON
SET statistics io ON

--КЛАСТЕРНЫЙ ИНДЕКС
/*
--1. Соединение
SELECT c1.Surname, c1.Rating
FROM Coaches_unclustered AS c1
INNER JOIN Coaches_unclustered AS c2
ON c1.ID_coach = c2.ID_coach
WHERE c1.ID_coach > 3000 AND c1.ID_coach < 4000

CREATE CLUSTERED INDEX idx_1 ON Coaches_unclustered(ID_coach)
	SELECT c1.Surname, c1.Rating
	FROM Coaches_unclustered AS c1
	INNER JOIN Coaches_unclustered AS c2
	ON c1.ID_coach = c2.ID_coach
	WHERE c1.ID_coach > 3000 AND c1.ID_coach < 4000
DROP INDEX idx_1 ON Coaches_unclustered

--2. Фильтрация

SELECT c.Firstname, c.Lastname
FROM Coaches_unclustered AS c
WHERE c.Firstname LIKE 'ааЖ%'

CREATE CLUSTERED INDEX idx_2 ON Coaches_unclustered(Firstname)
	SELECT c.Firstname
	FROM Coaches_unclustered AS c
	WHERE c.Firstname LIKE 'ааЖ%'
DROP INDEX idx_2 ON Coaches_unclustered

--3. Строки

SELECT SUBSTRING(c.Firstname, 1, 3)
FROM Coaches_unclustered AS c
WHERE c.ID_coach > 5000

CREATE CLUSTERED INDEX idx_3 ON Coaches_unclustered(ID_coach, Firstname)
	SELECT SUBSTRING(c.Firstname, 1, 3)
	FROM Coaches_unclustered AS c
	WHERE c.ID_coach > 5000
DROP INDEX idx_3 ON Coaches_unclustered


--4. Дата и время

SELECT DATEDIFF(day, c.BirthDate, GETDATE()) 
FROM Coaches_unclustered AS c


CREATE CLUSTERED INDEX idx_4 ON Coaches_unclustered(ID_coach, Birthdate)
	SELECT DATEDIFF(day, c.BirthDate, GETDATE()) 
	FROM Coaches_unclustered AS c
DROP INDEX idx_4 ON Coaches_unclustered
*/
--5. Агрегирование

SELECT c.Surname
FROM Coaches_unclustered AS c
GROUP BY Surname

CREATE CLUSTERED INDEX idx_5 ON Coaches_unclustered(Surname)
	SELECT c.Surname
	FROM Coaches_unclustered AS c
	GROUP BY Surname
DROP INDEX idx_5 ON Coaches_unclustered

--6. Вложенные запросы

SELECT c.Firstname, c.BirthDate
FROM Coaches_unclustered AS c
WHERE c.BirthDate IN (
    SELECT c.BirthDate
	FROM Coaches AS c
    WHERE c.BirthDate BETWEEN '1975-01-01' AND '1990-12-31'
)

CREATE CLUSTERED INDEX idx_6 ON Coaches_unclustered(Birthdate)
	SELECT c.Firstname, c.BirthDate
	FROM Coaches_unclustered AS c
	WHERE c.BirthDate IN (
		SELECT c.BirthDate
		FROM Coaches AS c
		WHERE c.BirthDate BETWEEN '1975-01-01' AND '1990-12-31'
	)
DROP INDEX idx_6 ON Coaches_unclustered

--7. UNION

SELECT c.Firstname
FROM Coaches_unclustered AS c
WHERE Firstname LIKE 'А%'
UNION 
SELECT c.Lastname
FROM Coaches_unclustered AS c
WHERE Lastname LIKE 'а%'

CREATE NONCLUSTERED INDEX idx_7 ON Coaches_unclustered(Firstname)
	SELECT c.Firstname
	FROM Coaches_unclustered AS c
	WHERE Firstname LIKE 'А%'
	UNION 
	SELECT c.Lastname
	FROM Coaches_unclustered AS c
	WHERE Lastname LIKE 'а%'
DROP INDEX idx_7 ON Coaches_unclustered

/*
--НЕКЛАСТЕРНЫЙ СОСТАВНОЙ ИНДЕКС

--1, 2. Соединения, LIKE


SELECT e.ID_employee, e.FirstName, e.PhoneNumber 
	FROM Employees AS e
		INNER JOIN Gyms AS g
		ON e.ID_gym = g.ID_gym 
		AND PhoneNumber LIKE N'%1'

CREATE NONCLUSTERED INDEX idx1_1 ON Employees(PhoneNumber, FirstName)
CREATE NONCLUSTERED INDEX idx1_2 ON Gyms(ID_gym)
	SELECT e.ID_employee, e.FirstName, e.PhoneNumber 
	FROM Employees AS e
		INNER JOIN Gyms AS g
		ON e.ID_gym = g.ID_gym 
		AND PhoneNumber LIKE N'%1'
DROP INDEX idx1_1 ON Employees
DROP INDEX idx1_2 ON Gyms

--3. Работа со строками

SELECT cl.ID_client, REPLACE(cl.BirthDate, N'-', N'.') AS newDate 
FROM Clients AS cl

CREATE NONCLUSTERED INDEX idx1_3 ON Clients(BirthDate, ID_client)
	SELECT cl.ID_client, REPLACE(cl.BirthDate, N'-', N'.') AS newDate 
	FROM Clients AS cl
DROP INDEX idx1_3 ON Clients


--4. Дата и время

SELECT c.ID_coach, DATEPART(yy, c.BirthDate) 
FROM Coaches AS c

CREATE NONCLUSTERED INDEX idx1_4 ON Coaches(BirthDate, ID_coach)
	SELECT c.ID_coach, DATEPART(yy, c.BirthDate) 
	FROM Coaches AS c
DROP INDEX idx1_4 ON Coaches

--5. GROUP BY

SELECT g.Address, COUNT(g.Title)
FROM Gyms AS g
GROUP BY g.Address

CREATE NONCLUSTERED INDEX idx1_5 ON Gyms(Address, Title)
	SELECT g.Address, COUNT(g.Title)
	FROM Gyms AS g
	GROUP BY g.Address
DROP INDEX idx1_5 ON Gyms


--6. Вложенные запросы

SELECT e.Occupation, e.BirthDate
FROM Employees AS e
WHERE e.BirthDate IN (
    SELECT e.BirthDate
	FROM Employees AS e
    WHERE e.BirthDate BETWEEN '1975-01-01' AND '1990-12-31'
)

CREATE NONCLUSTERED INDEX idx1_6 ON Employees(BirthDate, ID_employee, Occupation)
	SELECT e.Occupation, e.BirthDate
	FROM Employees AS e
	WHERE e.Birthdate IN (
		SELECT e.Birthdate
		FROM Employees AS e
		WHERE e.BirthDate BETWEEN '1975-01-01' AND '1990-12-31'
)
DROP INDEX idx1_6 ON Employees

--7. Union

SELECT e.Firstname
FROM Employees AS e
WHERE Firstname LIKE 'А%'
UNION 
SELECT e.Lastname
FROM Employees AS e
WHERE Lastname LIKE 'а%'

CREATE NONCLUSTERED INDEX idx1_7 ON Employees(Firstname, Lastname)
	SELECT e.Firstname
	FROM Employees AS e
	WHERE Firstname LIKE 'А%'
	UNION 
	SELECT e.Lastname
	FROM Employees AS e
	WHERE Lastname LIKE 'а%'
DROP INDEX idx1_7 ON Employees

--НЕКЛАСТЕРНЫЙ ПОКРЫВАЮЩИЙ ИНДЕКС

--1. Соединения

SELECT g.Title, inv.ItemName FROM Inventory AS inv
	FULL JOIN Gyms as g
	ON inv.ID_gym = g.ID_gym

CREATE NONCLUSTERED INDEX idx2_1 ON Gyms(ID_gym) INCLUDE (Title)
	SELECT g.Title, inv.ItemName FROM Inventory AS inv
		FULL JOIN Gyms as g
		ON inv.ID_gym = g.ID_gym
DROP INDEX idx2_1 ON Gyms

--2. Предикаты

SELECT c.Firstname, c.Surname, c.Rating
FROM Coaches AS c
	WHERE Rating BETWEEN 3.0 AND 4.5

CREATE NONCLUSTERED INDEX idx2_2 ON Coaches(Rating) INCLUDE (Firstname, Surname)
	SELECT c.Firstname, c.Surname, c.Rating
	FROM Coaches AS c
		WHERE Rating BETWEEN 3.0 AND 4.5
DROP INDEX idx2_2 ON Coaches

--3. Работа со строками

SELECT STUFF(cl.Firstname, 1, 3, '___'), cl.Lastname
FROM Clients AS cl

CREATE NONCLUSTERED INDEX idx2_3 ON Clients(Firstname) INCLUDE (Lastname)
	SELECT STUFF(cl.Firstname, 1, 3, '___'), cl.Lastname
	FROM Clients AS cl
DROP INDEX idx2_3 ON Clients

--4. Дата и время 

SELECT e.Firstname, e.Surname
FROM Employees AS e
WHERE DATEDIFF(year, '2024/01/01', e.BirthDate) > 25

CREATE NONCLUSTERED INDEX idx2_4 ON Employees(BirthDate) INCLUDE (Firstname, Surname)
	SELECT e.Firstname, e.Surname
	FROM Employees AS e
	WHERE DATEDIFF(year, '2024/01/01', e.BirthDate) > 25
DROP INDEX idx2_4 ON Employees

--5. Агрегация данных

SELECT COUNT(Price), tar.Title
FROM Tariffs AS tar
GROUP BY Title

CREATE NONCLUSTERED INDEX idx2_5 ON Tariffs(Title) INCLUDE (Price)
	SELECT COUNT(Price), tar.Title
	FROM Tariffs AS tar
	GROUP BY Title
DROP INDEX idx2_5 ON Tariffs

--6. Вложенные запросы

SELECT c.Firstname, c.Surname, c.Rating
FROM Coaches AS c
WHERE Rating >= ANY
	(SELECT c.Rating
	FROM Coaches
	WHERE c.Firstname = 'аа')

CREATE NONCLUSTERED INDEX idx2_6 ON Coaches(Firstname) INCLUDE (Rating, Surname)
	SELECT c.Firstname, c.Surname, c.Rating
	FROM Coaches AS c
	WHERE Rating >= ANY
		(SELECT c.Rating
		FROM Coaches
		WHERE c.Firstname = 'аа')
DROP INDEX idx2_6 ON Coaches

--7. INTERSECT

SELECT c.Firstname
FROM Coaches AS c 
WHERE SUBSTRING(c.Firstname,5,1) = 'в'
INTERSECT 
SELECT c.Lastname
FROM Coaches AS c 
WHERE SUBSTRING(c.Lastname,3,1) = 'А'

CREATE NONCLUSTERED INDEX idx2_7 ON Coaches(Firstname) INCLUDE (Lastname)
	SELECT c.Firstname
	FROM Coaches AS c 
	WHERE SUBSTRING(c.Firstname,5,1) = 'в'
	INTERSECT 
	SELECT c.Lastname
	FROM Coaches AS c 
	WHERE SUBSTRING(c.Lastname,3,1) = 'А'
DROP INDEX idx2_7 ON Coaches

--НЕКЛАСТЕРНЫЙ УНИКАЛЬНЫЙ ИНДЕКС

--1. Соединения

SELECT cl.Firstname, lock.LockerNumber FROM Clients AS cl
	LEFT JOIN Lockers AS lock
	ON cl.ID_client = lock.ID_client


CREATE UNIQUE NONCLUSTERED INDEX idx3_1 ON Clients(Firstname, ID_client)
	SELECT cl.Firstname, lock.LockerNumber FROM Clients AS cl
		LEFT JOIN Lockers AS lock
		ON cl.ID_client = lock.ID_client
DROP INDEX idx3_1 ON Clients

--2. Использование предикатов

SELECT c.Firstname, c.Lastname, c.Surname
FROM Coaches AS c
WHERE c.Surname IS NULL

CREATE UNIQUE NONCLUSTERED INDEX idx3_2 ON Coaches(Surname, ID_coach)
	SELECT c.Firstname, c.Lastname, c.Surname
	FROM Coaches AS c
	WHERE c.Surname IS NULL
DROP INDEX idx3_2 ON Coaches

--3. Работа со строками

SELECT STUFF(e.Firstname, 0, 4, 'NEW_NAME_')
FROM Employees AS e

CREATE UNIQUE NONCLUSTERED INDEX idx3_3 ON Employees(Firstname, ID_employee)
	SELECT STUFF(e.Firstname, 0, 4, 'NEW_NAME_')
	FROM Employees AS e
DROP INDEX idx3_3 ON Employees


--4. Дата и время

SELECT DATEDIFF(day, e.BirthDate, GETDATE()) 
FROM Employees AS e

CREATE UNIQUE NONCLUSTERED INDEX idx3_4 ON Employees(Birthdate, ID_employee)
	SELECT DATEDIFF(day, e.BirthDate, GETDATE()) 
	FROM Employees AS e
DROP INDEX idx3_4 ON Employees

--5. Агрегатные функции

SELECT l.LockerNumber, COUNT(l.LockerNumber)
FROM Lockers AS l
WHERE LockerNumber > 40
GROUP BY LockerNumber
ORDER BY LockerNumber

CREATE UNIQUE NONCLUSTERED INDEX idx3_5 ON Lockers(LockerNumber, ID_locker)
	SELECT l.LockerNumber, COUNT(l.LockerNumber)
	FROM Lockers AS l
	WHERE LockerNumber > 40
	GROUP BY LockerNumber
	ORDER BY LockerNumber
DROP INDEX idx3_5 ON Lockers

--6. Вложенные запросы

SELECT e.Occupation, e.BirthDate 
FROM Employees AS e
WHERE Occupation IN 
	(SELECT Occupation
	FROM Employees AS e
	WHERE LEN(Occupation) > 5)

CREATE UNIQUE INDEX idx3_6 ON Employees(ID_employee, Occupation)
	SELECT e.Occupation, e.BirthDate 
	FROM Employees AS e
	WHERE Occupation IN 
		(SELECT Occupation
		FROM Employees AS e
		WHERE LEN(Occupation) > 5)
DROP INDEX idx3_6 ON Employees

--7. UNION

SELECT c.Lastname, c.Rating
FROM Coaches AS c
WHERE c.Rating BETWEEN 1.0 AND 2.0
UNION
SELECT c.Lastname, c.Rating
FROM Coaches AS c
WHERE c.Rating BETWEEN 4.0 AND 5.0

CREATE UNIQUE NONCLUSTERED INDEX idx3_7 ON Coaches(Rating, Lastname)
	SELECT c.Lastname, c.Rating
	FROM Coaches AS c
	WHERE c.Rating BETWEEN 1.0 AND 2.0
	UNION
	SELECT c.Lastname, c.Rating
	FROM Coaches AS c
	WHERE c.Rating BETWEEN 4.0 AND 5.0
DROP INDEX idx3_7 ON Coaches

--НЕКЛАСТЕРНЫЙ ФИЛЬТРОВАННЫЙ ИНДЕКС

--1. Соединение

SELECT e.Occupation, e.FirstName
FROM Employees AS e
	LEFT JOIN Gyms AS g
	ON e.ID_gym = g.ID_gym
WHERE ID_employee < 8000

CREATE NONCLUSTERED INDEX idx4_1 ON Employees(Occupation, Firstname) WHERE ID_employee < 8000
	SELECT e.Occupation, e.FirstName
	FROM Employees AS e
		LEFT JOIN Gyms AS g
		ON e.ID_gym = g.ID_gym
	WHERE ID_employee < 8000
DROP INDEX idx4_1 ON Employees

--2. Использование предикатов

SELECT l.ExpiringDate, l.LockerNumber
FROM Lockers AS l
WHERE l.ExpiringDate BETWEEN '1960.01.01' AND '1990.01.01'

CREATE NONCLUSTERED INDEX idx4_2 ON Lockers(ExpiringDate, LockerNumber) 
WHERE ExpiringDate > '1950.01.01'
	SELECT l.ExpiringDate, l.LockerNumber
	FROM Lockers AS l
	WHERE l.ExpiringDate BETWEEN '1960.01.01' AND '1990.01.01'
DROP INDEX idx4_2 ON Lockers

--3. Работа со строками

SELECT STUFF(cl.Firstname, 2, 1, '___')
FROM Clients AS cl
WHERE ID_client < 5000

CREATE NONCLUSTERED INDEX idx4_3 ON Clients(Firstname) WHERE ID_client < 5000
	SELECT STUFF(cl.Firstname, 2, 1, '___')
	FROM Clients AS cl
	WHERE ID_client < 5000
DROP INDEX idx4_3 ON Clients

--4. Дата и время 

SELECT e.Firstname, e.Surname
FROM Employees AS e
WHERE DATEDIFF(year, '2024/01/01', e.BirthDate) > 25
	  AND BirthDate > '1990.01.01'

CREATE NONCLUSTERED INDEX idx4_4 ON Employees(BirthDate) WHERE BirthDate > '1980.01.01'
	SELECT e.Firstname, e.Surname
	FROM Employees AS e
	WHERE DATEDIFF(year, '2024/01/01', e.BirthDate) > 25
		  AND BirthDate > '1990.01.01'
DROP INDEX idx4_4 ON Employees

--5. Группировка

SELECT g.Address, COUNT(g.OpenTime)
FROM Gyms AS g
WHERE OpenTime > '1:00:00'
GROUP BY g.Address

CREATE NONCLUSTERED INDEX idx4_5 ON Gyms(Address, Title) WHERE OpenTime > '1:00:00'
SELECT g.Address, COUNT(g.OpenTime)
	FROM Gyms AS g
	WHERE OpenTime > '1:00:00'
	GROUP BY g.Address
DROP INDEX idx4_5 ON Gyms

--6. Вложенные запросы

SELECT tar.Title, tar.Price 
FROM Tariffs AS tar
WHERE Title IN 
	(SELECT Title FROM Tariffs
	WHERE Price > 2000 GROUP BY Title)

CREATE INDEX idx4_6 ON Tariffs(Title) WHERE Price > 2000
	SELECT tar.Title, tar.Price 
	FROM Tariffs AS tar
	WHERE Title IN 
		(SELECT Title FROM Tariffs
		WHERE Price > 2000 GROUP BY Title)
DROP INDEX idx4_6 ON Tariffs

--7. UNION
SELECT tar.Title, tar.Price
FROM Tariffs AS tar
WHERE tar.Price > 500 AND tar.Price < 1000
UNION
SELECT tar.Title, tar.Price
FROM Tariffs AS tar
WHERE tar.Price > 2500 AND tar.Price < 3500

CREATE NONCLUSTERED INDEX idx4_7 ON Tariffs(Price, Title) WHERE Price < 5000
	SELECT tar.Title, tar.Price
	FROM Tariffs AS tar
	WHERE tar.Price > 500 AND tar.Price < 1000
	UNION
	SELECT tar.Title, tar.Price
	FROM Tariffs AS tar
	WHERE tar.Price > 2500 AND tar.Price < 3500
DROP INDEX idx4_7 ON Tariffs
*/
