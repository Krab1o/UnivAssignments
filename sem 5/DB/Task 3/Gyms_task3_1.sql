--LEFT JOIN
SELECT Cl.*, Lock.LockerNumber FROM Clients AS Cl
	LEFT JOIN Lockers AS Lock
	ON Cl.ID_client = Lock.ID_client

--INNER JOIN
SELECT it.Type, inv.ItemName FROM Inventory AS inv
	INNER JOIN ItemTypes AS it
	ON it.ID_type = inv.ID_type

--RIGHT JOIN
SELECT Cl.*, Lock.LockerNumber FROM Lockers AS Lock
	RIGHT JOIN Clients AS Cl
	ON Cl.ID_client = Lock.ID_client

--FULL JOIN
SELECT g.Title, inv.* FROM Inventory AS inv
	FULL JOIN Gyms as g
	ON inv.ID_gym = g.ID_gym

--CROSS JOIN
SELECT * FROM Coaches
	CROSS JOIN Activities

--CROSS APPLY
SELECT * FROM Clients AS c 
CROSS APPLY (SELECT sub.ID_tariff FROM Subscriptions AS sub
			 WHERE sub.ID_tariff = sub.ID_Client) AS result

--самосоединение
SELECT g1.Title, g2.OpenTime, g2.CloseTime FROM Gyms g1, Gyms g2
WHERE g1.Title = g2.Title

--ALL, самый хороший по рейтингу
SELECT c.* FROM Coaches AS c
WHERE c.Rating >= ALL (SELECT c.Rating FROM Coaches AS c)  

--ANY/SOME, все кроме тренера с самым низким рейтингом
SELECT c.* FROM Coaches AS c
WHERE c.Rating > SOME (SELECT c.Rating FROM Coaches AS c)

--IN
SELECT tar.* FROM Tariffs AS tar
WHERE tar.Price IN (1900, 3500)

--EXISTS, только залы, где есть занятия
SELECT * FROM Gyms as g
WHERE EXISTS (SELECT * FROM Schedule AS Sc
			  WHERE g.ID_gym = sc.ID_gym)

--BETWEEN
SELECT c.* FROM Coaches AS c
WHERE c.Rating BETWEEN 4 AND 5

--LIKE
SELECT inv.* FROM Inventory AS inv
WHERE inv.ItemName LIKE 'Блин%'

--CASE
SELECT sch.*, 
	'Time' = 
		CASE
			WHEN  sch.StartTime <= '15:00' THEN 'Первая половина дня'
			ELSE 'Вторая половина дня'
		END
FROM Schedule AS sch

--CAST
SELECT inv.SerialNumber, CAST (SerialNumber AS nvarchar(40)) AS SerNum_CAST
FROM Inventory AS inv

--CONVERT
SELECT inv.SerialNumber, CONVERT (nvarchar(40), inv.SerialNumber) AS SerNum_CONVERT
FROM Inventory AS inv

--ISNULL & COALESCE
SELECT emp.FirstName, emp.Lastname, ISNULL(Surname, '---') AS NoSurname 
FROM Employees AS emp
SELECT emp.FirstName, emp.Lastname, COALESCE ((SELECT CASE
													WHEN emp.ID_employee = 1 THEN 'У ПЕРВОГО НЕТ ОТЧЕСТВА'
													ELSE NULL
													END),
											  (SELECT CASE
													WHEN emp.Surname IS NULL THEN 'НЕТ ОТЧЕСТВА'
													ELSE NULL
													END),
											  emp.Surname)
FROM Employees AS emp

--NULLIF
SELECT cg.ID_client, NULLIF(cg.ID_group, 5) AS 'Группа без 5'
FROM Clients_Groups AS cg


--CHOOSE
SELECT s.*, CHOOSE(s.ID_coach, 'Сибирцев', 'Алеутов', 'Лепетин', 'Галкин') AS chosen_coach
FROM Schedule AS s

--IIF
SELECT tar.*, 
IIF(tar.Price < 2500, 'Дешево', 'Дорого') AS 'Оценка'
FROM Tariffs AS tar

--REPLACE
SELECT REPLACE (emp.Occupation, 'Administrator','Admin') short_name,
REPLACE (emp.Occupation, 'Cleaner', 'Clean') short_name
FROM Employees AS emp

--SUBSTRING
SELECT c.FirstName, c.LastName, SUBSTRING (c.PhoneNumber, 9, 8) AS ShortNum
FROM Clients AS c

--STUFF
SELECT g.Address, STUFF(g.Address, 1, 0, 'г. Саратов, ') AS modifiedAdress
FROM Gyms AS g

--STR
SELECT c.Rating, STR(c.Rating, 4, 2) AS StrRating
FROM Coaches AS c

--UPPER
SELECT UPPER (c.Lastname) AS UpperLastname
FROM Coaches AS c

--DATEPART
SELECT cl.Lastname, DATEPART (YEAR,  cl.BirthDate) AS BirthYear
FROM Clients AS cl

--DATEDIFF
SELECT sub.StartingDate, sub.ExpiringDate, DATEDIFF (DAY, sub.StartingDate, sub.ExpiringDate) AS days_diff
FROM Subscriptions AS sub

--GETDATE, SYSDATETIMEOFFSET
SELECT GETDATE () AS SystemData
SELECT SYSDATETIMEOFFSET () AS SystemData


--MIN, MAX, AVG, SUM
SELECT 'Min price' = MIN (tar.Price), 
	   'Max price' = MAX (tar.Price), 
	   'Average price' = AVG (tar.Price),
	   'Sum' = SUM (tar.Price)
FROM Tariffs AS tar

--HAVING, GROUP BY
SELECT COUNT(inv.ID_type), inv.ID_type
FROM Inventory AS inv
GROUP BY inv.ID_type
HAVING COUNT(inv.ID_type) > 4