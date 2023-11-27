IF OBJECT_ID (N'Schedule', N'U') IS NOT NULL
	DROP TABLE Schedule
IF OBJECT_ID (N'GymActivities', N'U') IS NOT NULL
	DROP TABLE GymActivities
IF OBJECT_ID (N'CoachActivities', N'U') IS NOT NULL
	DROP TABLE CoachActivities
IF OBJECT_ID (N'Coaches', N'U') IS NOT NULL
	DROP TABLE Coaches
IF OBJECT_ID (N'Activities', N'U') IS NOT NULL
	DROP TABLE Activities
IF OBJECT_ID (N'Subscriptions', N'U') IS NOT NULL
	DROP TABLE Subscriptions
IF OBJECT_ID (N'Clients_Groups', N'U') IS NOT NULL
	DROP TABLE Clients_Groups
IF OBJECT_ID (N'Groups', N'U') IS NOT NULL
	DROP TABLE Groups
IF OBJECT_ID (N'Tariffs', N'U') IS NOT NULL
	DROP TABLE Tariffs
IF OBJECT_ID (N'Employees', N'U') IS NOT NULL
	DROP TABLE Employees
IF OBJECT_ID (N'Inventory', N'U') IS NOT NULL
	DROP TABLE Inventory
IF OBJECT_ID (N'ItemTypes', N'U') IS NOT NULL
	DROP TABLE ItemTypes
IF OBJECT_ID (N'Lockers', N'U') IS NOT NULL
	DROP TABLE Lockers
IF OBJECT_ID (N'Clients', N'U') IS NOT NULL
	DROP TABLE Clients
IF OBJECT_ID (N'Gyms', N'U') IS NOT NULL
	DROP TABLE Gyms

CREATE TABLE Gyms
(
	ID_gym			int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Gyms PRIMARY KEY,
	Title			nvarchar(30) NOT NULL,
	OpenTime		time NOT NULL,
	CloseTime		time NOT NULL,
	Address			nvarchar(50) NOT NULL
)

CREATE TABLE Clients
(
	ID_client		int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Clients PRIMARY KEY,
	Lastname		nvarchar(16) NOT NULL,
	Firstname		nvarchar(16) NOT NULL,
	Surname			nvarchar(16),
	PhoneNumber		nvarchar(16) NOT NULL,
	BirthDate		date NOT NULL
)

CREATE TABLE Lockers
(
	ID_locker		int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Lockers PRIMARY KEY,
	ID_client		int FOREIGN KEY REFERENCES Clients(ID_client) NOT NULL,
	ID_gym			int FOREIGN KEY REFERENCES Gyms(ID_gym) NOT NULL,
	LockerNumber	int NOT NULL,
	ExpiringDate	date NOT NULL,
	Expired			bit NOT NULL,
)

CREATE TABLE ItemTypes
(
	ID_type			int IDENTITY(1,1) NOT NULL CONSTRAINT PK_ItemTypes PRIMARY KEY,
	Type			nvarchar(40) NOT NULL
)

CREATE TABLE Inventory
(
	ID_item			int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Inventory PRIMARY KEY,
	ID_gym			int FOREIGN KEY REFERENCES Gyms(ID_gym) NOT NULL,
	ItemName		nvarchar(40) NOT NULL,
	SerialNumber	int NOT NULL,
	ID_type			int FOREIGN KEY REFERENCES ItemTypes(ID_type) NOT NULL,
	CheckDate		date NOT NULL,
	NeedReplacement	bit NOT NULL
)

CREATE TABLE Employees
(
	ID_employee		int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Employees PRIMARY KEY,
	ID_gym			int FOREIGN KEY REFERENCES Gyms(ID_gym) NOT NULL,
	Lastname		nvarchar(16) NOT NULL,
	FirstName		nvarchar(16) NOT NULL,
	Surname			nvarchar(16),
	PhoneNumber		nvarchar(16) NOT NULL,
	BirthDate		date NOT NULL,
	Occupation		nvarchar(40) NOT NULL
)

CREATE TABLE Tariffs
(
	ID_tariff		int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Tariffs PRIMARY KEY,
	Title			nvarchar(16) NOT NULL,
	Price			money NOT NULL
)

CREATE TABLE Groups
(
	ID_group		int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Groups PRIMARY KEY,
	ID_tariff		int FOREIGN KEY REFERENCES Tariffs(ID_tariff)
)

CREATE TABLE Clients_Groups
(
	ID_client		int FOREIGN KEY REFERENCES Clients(ID_client),
	ID_group		int FOREIGN KEY REFERENCES Groups(ID_group)
)

CREATE TABLE Subscriptions
(
	ID_client		int FOREIGN KEY REFERENCES Clients(ID_client) NOT NULL,
	StartingDate	date NOT NULL,
	ExpiringDate	date NOT NULL,
	Expired			bit NOT NULL,
	ID_tariff		int FOREIGN KEY REFERENCES Tariffs(ID_tariff) NOT NULL,
	ID_gym			int FOREIGN KEY REFERENCES Gyms(ID_gym) NOT NULL
)

CREATE TABLE Activities
(
	ID_activity		int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Activities PRIMARY KEY,
	ActivityName	nvarchar(40) NOT NULL
)

CREATE TABLE Coaches
(
	ID_coach		int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Coaches PRIMARY KEY,
	Lastname		nvarchar(16) NOT NULL,
	Firstname		nvarchar(16) NOT NULL,
	Surname			nvarchar(16),
	Rating			float,
	BirthDate		date NOT NULL
)

CREATE TABLE CoachActivities
(
	ID_coach		int FOREIGN KEY REFERENCES Coaches(ID_coach),
	ID_activity		int FOREIGN KEY REFERENCES Activities(ID_activity)
)

CREATE TABLE GymActivities
(
	ID_gym			int FOREIGN KEY REFERENCES Gyms(ID_gym),
	ID_activity		int FOREIGN KEY REFERENCES Activities(ID_activity)
)

CREATE TABLE Schedule
(
	ID_event		int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Schedule PRIMARY KEY,
	ID_gym			int FOREIGN KEY REFERENCES Gyms(ID_gym),
	ID_coach		int FOREIGN KEY REFERENCES Coaches(ID_coach),
	ID_activity		int FOREIGN KEY REFERENCES Activities(ID_activity),
	ID_group		int FOREIGN KEY REFERENCES Groups(ID_group),
	StartTime		time NOT NULL,
	EndTime			time NOT NULL,
	Day				date NOT NULL
)