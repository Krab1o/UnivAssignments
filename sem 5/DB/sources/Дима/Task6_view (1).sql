/*---1---*/
CREATE VIEW [dbo].[View_PIG]
AS
SELECT        dbo.PeopleInGroup.ID_Group, dbo.TypeOfSport.SportName, dbo.Clients.LastName
FROM            dbo.PeopleInGroup INNER JOIN
                         dbo.Clients ON dbo.PeopleInGroup.ID_Client = dbo.Clients.ID_Client INNER JOIN
                         dbo.Groups ON dbo.PeopleInGroup.ID_Group = dbo.Groups.ID_Group INNER JOIN
                         dbo.TypeOfSport ON dbo.Groups.ID_TypeOfSport = dbo.TypeOfSport.ID_TypeOfSport

SELECT * FROM [dbo].[View_PIG]

CREATE VIEW [dbo].[View_PurchasedST]
AS
SELECT        dbo.PurchasedST.ID_PurchasedST, dbo.PurchasedST.ID_STT, dbo.Clients.LastName, dbo.Clients.FirstName, dbo.PaymentType.TypeName
FROM            dbo.PaymentType INNER JOIN
                         dbo.PurchasedST ON dbo.PaymentType.ID_PaymentType = dbo.PurchasedST.ID_PaymentType INNER JOIN
                         dbo.Clients ON dbo.PurchasedST.ID_Client = dbo.Clients.ID_Client


SELECT * FROM [dbo].[View_PurchasedST]

EXEC sp_helptext 'View_PurchasedST'

CREATE VIEW [dbo].[View_Schedule]

WITH ENCRYPTION
AS
SELECT        dbo.Schedule.ID_Schedule, dbo.Gyms.GymName, dbo.Schedule.ID_Group, dbo.TypeOfSport.SportName, dbo.Coaches.LastName, dbo.Schedule.Day_of_week, dbo.Schedule.StartTime
FROM            dbo.Schedule INNER JOIN
                         dbo.Coaches ON dbo.Schedule.ID_Coach = dbo.Coaches.ID_Coach INNER JOIN
                         dbo.TypeOfSport ON dbo.Schedule.ID_TypeOfSport = dbo.TypeOfSport.ID_TypeOfSport INNER JOIN
                         dbo.Gyms ON dbo.Schedule.ID_Gym = dbo.Gyms.ID_Gym

SELECT * FROM [dbo].[View_Schedule]

EXEC sp_helptext 'View_Schedule'


/*---2---*/
CREATE VIEW [dbo].[View_Attendance]
AS
SELECT ID_Attendance, ID_PurchasedST, ID_Schedule, _Date
FROM            dbo.Attendance
WHERE        _Date <= '2023-12-03'
WITH CHECK OPTION;

INSERT INTO View_Attendance
VALUES (1, 3,  '2023-12-05');

select * from View_Attendance

INSERT INTO View_Attendance
VALUES (1, 3,  '2020-10-10');
/*---3---*/

-- Создать индексированное представление с привязкой к схеме

SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL,
ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

CREATE VIEW [dbo].[View_Gyms1]
WITH SCHEMABINDING 
AS
SELECT        g.ID_Gym, g.GymName, g.Adress, g.Rating, g.OpeningTime, g.ClosingTime, dbo.Equipment.EquipName, dbo.Equipment.ID_Equipment
FROM            dbo.Gyms AS g INNER JOIN
                         dbo.Equipment ON g.ID_Gym = dbo.Equipment.ID_Gym


CREATE UNIQUE CLUSTERED INDEX index_View_Gyms1
ON [dbo].[View_Gyms1] ([ID_Equipment]);

SELECT * FROM View_Gyms1
WITH (NOEXPAND)

DROP INDEX index_View_Gyms1 on View_Gyms1