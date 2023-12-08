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

/*
/* CROSS APPLY */
SELECT * FROM Clients AS c 
CROSS APPLY (SELECT ID_PaymentType, PurchaseDate FROM PurchasedST 
			 WHERE PurchasedST.ID_Client = c.ID_Client) AS newww

/* самосоединение */
SELECT * FROM Gyms T1, Gyms T2
WHERE T1.GymName = T2.GymName
*/

/* ALL */
SELECT c.* FROM Coaches AS c
WHERE c.Rating > ALL (SELECT g.Rating FROM Gyms AS g)  
/*
/* ANY/SOME */
SELECT c.* FROM Coaches AS c
WHERE c.Rating > SOME (SELECT g.Rating FROM Gyms AS g)  
/* IN */
SELECT stt.* FROM SeasonTicketType AS stt
WHERE stt.Price IN (1000, 3000, 4200)

/* EXISTS */
SELECT * FROM Gyms as g
WHERE EXISTS (SELECT * FROM Equipment AS e
			  WHERE e.ID_Gym = g.ID_Gym)
/* BETWEEN */
SELECT G.* FROM Gyms AS G
WHERE G.Rating BETWEEN 4.5 AND 5

/* LIKE */
SELECT stt. * FROM SeasonTicketType AS stt
WHERE stt.Duratuon LIKE 'на 90 дней'

/* CASE */
SELECT GymName, Rating, 
	'Review' = 
		CASE
			WHEN g.Rating > 3.5   THEN 'Рекомендую'
			ELSE 'Не рекомендую'
		END
FROM Gyms AS g

/* CAST */
SELECT stt.Price, CAST (Price AS money) AS Cost
FROM SeasonTicketType AS stt 

/* CONVERT */
SELECT _Date, CONVERT (datetime, _Date) AS date_time
FROM Attendance

/* ISNULL/ COALESCE */
SELECT e.EquipName, e.AmountOfEq, ISNULL(e.AmountOfEq, 0) AS new_amount_of_eq 
FROM Equipment AS e
SELECT e.EquipName, e.AmountOfEq, COALESCE(e.AmountOfEq, 0) AS new_amount_of_eq 
FROM Equipment AS e

/* NULLIF */
SELECT e.EquipName, NULLIF(e.EquipName, 'Гантели 4 кг') AS 'EquipName'
FROM Equipment AS e

/* CHOOSE */
SELECT s.ID_Gym, s.Day_of_week , CHOOSE(2, 'Васильев', 'Столоне', 'Тимофеев') AS chosen_coach
FROM Schedule AS s

/* IIF */
SELECT c.FirstName, c.LastName, 
IIF( Rating >= 4, 'Специалист', 'Неопытный') AS coach_status
FROM  Coaches AS  c

/* REPLACE */
SELECT REPLACE (e.EquipName, 'Гантели 4 кг','Гантели 10 кг') modified_column
FROM Equipment AS e

/* SUBSTRING */
SELECT c.FirstName, c.LastName, SUBSTRING (c.PhoneNumber, 9, 8) AS ShortNum
FROM Clients AS c

/* STUFF */
SELECT g.Adress, STUFF(g.Adress, 1, 0, 'г. Саратов, ') AS modifiedAdress
FROM Gyms AS g

/* STR */

SELECT g.Rating,  STR(g.Rating) AS StrRating 
FROM Gyms AS  g
/* UPPER */

SELECT UPPER (g.Adress) AS UpperAdress
FROM Gyms AS g

/* DATEPART */
SELECT p.PurchaseDate, DATEPART (DAY,  p.PurchaseDate) AS PurshaseDay
FROM PurchasedST AS p

/* DATEDIFF */
SELECT p.PurchaseDate, p.EndData ,DATEDIFF (DAY, p.PurchaseDate, p.EndData ) AS days_diff
FROM PurchasedST AS p

/* GETDATE, SYSDATETIMEOFFSET */
SELECT GETDATE () AS SystemData
SELECT SYSDATETIMEOFFSET () AS SystemData

/* MIN, MAX, AVG, SUM */
SELECT 'Min price' = MIN (stt.Price), 
	   'Max price' = MAX (stt.Price), 
	   'Average price' = AVG (stt.Price),
	   'Summa' = SUM (stt.Price)
FROM SeasonTicketType AS stt

/* HAVING , GROUP BY */

SELECT Duratuon, SUM (Price) FROM PurchasedST AS pst
INNER JOIN SeasonTicketType ON pst.ID_STT = SeasonTicketType.ID_STT
GROUP BY Duratuon
HAVING SUM(Price) > 15000
*/