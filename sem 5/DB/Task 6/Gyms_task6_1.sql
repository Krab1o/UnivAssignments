--TASK 1
DROP VIEW IF EXISTS [dbo].[View_CoachActive]
DROP VIEW IF EXISTS [dbo].[View_Schedule]
DROP VIEW IF EXISTS [dbo].[View_GymsActive]
DROP VIEW IF EXISTS [dbo].[View_Lockers]

/*
GO
CREATE VIEW [dbo].[View_CoachActive] WITH ENCRYPTION
AS
SELECT 
	Coaches.Firstname, Coaches.Lastname, Coaches.Surname, Coaches.BirthDate,
	Coaches.Rating, 
	Activities.ActivityName
FROM
	Coaches FULL JOIN	
	CoachActivities ON Coaches.ID_coach = CoachActivities.ID_coach FULL JOIN
	Activities ON CoachActivities.ID_coach = Activities.ID_activity
WHERE
	Coaches.Rating > 3.0
WITH CHECK OPTION
GO

SELECT * FROM [dbo].[View_CoachActive]

EXEC sp_helptext 'View_CoachActive'

GO
CREATE VIEW [dbo].[View_Schedule]
AS
SELECT 
	Activities.ActivityName, 
	Coaches.Firstname, Coaches.Lastname, Coaches.Surname, 
	Gyms.Title, 
	Groups.ID_group,
	Schedule.Day, Schedule.StartTime, Schedule.EndTime
FROM 
    Schedule JOIN
    Coaches ON Schedule.ID_Coach = Coaches.ID_Coach JOIN
    Activities ON Schedule.ID_activity = Activities.ID_activity JOIN
    Gyms ON Schedule.ID_Gym = Gyms.ID_Gym JOIN
	Groups ON Schedule.ID_group = Groups.ID_group
GO

SELECT * FROM [dbo].[View_Schedule]

EXEC sp_helptext 'View_Schedule'

GO
CREATE VIEW [dbo].[View_GymsActive]
AS
SELECT 
	Gyms.*, Activities.ActivityName
FROM 
	Gyms JOIN
    Activities ON Gyms.ID_gym = Activities.ID_activity
GO

SELECT * FROM [dbo].[View_GymsActive]

EXEC sp_helptext 'View_Schedule'

--TASK 2

--Успешно вставится
INSERT INTO View_CoachActive(Firstname, Lastname, Surname, BirthDate, Rating)
	VALUES ('Тренер', 'Хорошев', 'Хорошевич', '1990.01.01', 4.2)

SELECT * FROM View_CoachActive

--Не вставится
INSERT INTO View_CoachActive(Firstname, Lastname, Surname, BirthDate, Rating)
	VALUES ('Тренер', 'Плохов', 'Плохович', '1985.01.01', 2.2)

SELECT * FROM View_CoachActive
*/
--TASK 3

SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL,
ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;

GO
CREATE VIEW View_Lockers
WITH SCHEMABINDING 
AS
SELECT 
  dbo.Lockers.ID_locker,
  dbo.Lockers.LockerNumber,
  dbo.Lockers.ExpiringDate
FROM
  dbo.Lockers
GO

GO 
SELECT * FROM View_Lockers

CREATE UNIQUE CLUSTERED INDEX idx_Lockers
ON [dbo].[View_Lockers] ([ID_locker])

GO
SELECT * FROM View_Lockers
WITH (NOEXPAND)

DROP INDEX idx_Lockers ON [dbo].[View_Lockers]