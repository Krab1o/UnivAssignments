/*

SET statistics TIME ON
SET statistics io ON

*/

--КЛАСТЕРНЫЙ ИНДЕКС

--1. Соединения

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

CREATE NONCLUSTERED INDEX idx1_5 ON Gyms(Title, Address)
	SELECT g.Address, COUNT(g.Title)
	FROM Gyms AS g
	GROUP BY g.Address
DROP INDEX idx1_5 ON Gyms

--6. Вложенные запросы НЕ РАБОТАЕТ

SELECT e.FirstName, e.Occupation
FROM Employees AS e
WHERE e.ID_employee IN (
    SELECT e.ID_employee
    FROM Employees AS emp
    WHERE emp.BirthDate BETWEEN '1975-01-01' AND '1990-12-31'
)

CREATE NONCLUSTERED INDEX idx1_6 ON Employees(BirthDate, Occupation, ID_employee)
	SELECT e.FirstName, e.Occupation
	FROM Employees AS e
	WHERE e.ID_employee IN (
		SELECT e.ID_employee
		FROM Employees AS emp
		WHERE emp.BirthDate BETWEEN '1975-01-01' AND '1990-12-31'
)
DROP INDEX idx1_6 ON Employees

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


/*
SELECT * FROM Gyms
SELECT * FROM Clients
SELECT * FROM Activities
SELECT * FROM Coaches
SELECT * FROM Employees
*/