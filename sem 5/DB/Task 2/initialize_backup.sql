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

INSERT INTO Gyms (Title, OpenTime, CloseTime, Address)
VALUES	('Safia', '7:00:00', '22:30:00', 'ул. Кутякова 68'),
		('First Gym', '7:00:00', '23:00:00', 'ул. Гоголя 83'),
		('MetroFitness', '6:00:00', '6:00:00', 'ул. Московская 129/133'),
		('Alex Fitness', '7:00:00', '23:00:00', 'ул. Дзержинского 24'),
		('Forte Club', '7:00:00', '23:00:00', 'ул. Вольская 29'),
		('IronShape', '6:00:00', '6:00:00', 'ул. Ипподромная 47'),
		('Big Muscle', '6:00:00', '6:00:00', 'ул. Пушкина 135');

INSERT INTO Clients (LastName, FirstName, Surname, BirthDate, PhoneNumber)
VALUES	('Иванов','Сергей', 'Иванович', '1984.03.27','+79277233766'),
		('Александров','Иван', 'Владимирович', '1987.06.02','+78937650103'),
		('Таран','Евгений', 'Вячеславович', '1991.12.08','+79238304445'),
		('Михайличенко','Виктор', 'Станиславович', '1993.04.05','+79235435544'),
		('Соловьёв','Руслан', 'Викторович', '1967.11.21','+79235540437'),
		('Полозков','Антон', 'Игоревич', '2003.02.25','+79272236534');

INSERT INTO Lockers (ID_gym, ID_client, LockerNumber, ExpiringDate, Expired)
VALUES	(2, 1, 7, '2023.12.01', 0),
		(2, 3, 9, '2023.11.01', 1);

INSERT INTO ItemTypes (Type)
VALUES	('Беговая дорожка'),
		('Гиря'),
		('Гантеля'),
		('Блин'),
		('Тренажёр'),
		('Стойка для блинов'),
		('Кулер'),
		('Шкаф для вещей'),
		('Другое');

INSERT INTO Inventory (ItemName, ID_type, ID_gym, SerialNumber, CheckDate, NeedReplacement)
VALUES	('Блин 5кг Зелёный', 4, 1, 120001, '2021.06.01', 0),
		('Блин 5кг Зелёный', 4, 1, 120002, '2021.06.01', 0),
		('Блин 5кг Зелёный', 4, 1, 120003, '2021.06.01', 0),
		('Блин 10кг Зелёный', 4, 2, 133001, '2021.06.01', 0),
		('Блин 10кг Зелёный', 4, 2, 133002, '2021.06.01', 0),
		('Блин 10кг Зелёный', 4, 2, 133003, '2021.06.01', 0),
		('Блин 15кг Оранжевый', 4, 3, 141001, '2019.09.01', 0),
		('Блин 15кг Оранжевый', 4, 3, 141002, '2019.09.01', 0),
		('Блин 15кг Оранжевый', 4, 3, 141003, '2020.07.23', 0),
		('Беговая дорожка RunnerFirst', 1, 1, 103001, '2018.03.01', 0),
		('Беговая дорожка RunnerFirst', 1, 2, 103002, '2018.06.01', 0),
		('Беговая дорожка RunnerFirst', 1, 2, 103003, '2018.06.01', 0),
		('Беговая дорожка RunnerFirst', 1, 2, 103004, '2018.06.01', 0),
		('Беговая дорожка RunnerFirst', 1, 5, 103005, '2018.09.01', 0),
		('Беговая дорожка RunnerFirst', 1, 6, 103006, '2018.12.01', 0),
		('Кулер Кристальный', 7, 3, 181001, '2022.12.01', 0);

INSERT INTO Employees (ID_gym, Lastname, FirstName, Surname, PhoneNumber, BirthDate, Occupation)
VALUES	(1, 'Евдокимов', 'Евпатий', NULL, '+79272415537', '1965.03.05', 'Administrator'),
		(2, 'Салтыков', 'Евгений', 'Павлович', '+78372444713', '1985.03.05', 'Administrator'),
		(3, 'Магомедов', 'Артур', NULL, '+76542659801', '1987.03.05', 'Administrator'),
		(4, 'Мадамова', 'Евгения', 'Сергеевна', '+79473457109', '1977.03.05', 'Administrator'),
		(3, 'Слонова', 'Севилья', 'Игоревна', '+79574355543', '1963.03.05', 'Cleaner'),
		(4, 'Сорокина', 'Анастасия', 'Викторовна', '+73481255144', '2001.03.05', 'Cleaner'),
		(5, 'Лизакина', 'Елизавета', 'Станиславовна', '+78345225137', '2000.03.05', 'Administrator'),
		(6, 'Дуров', 'Павел', 'Игоревич', '+79339546139', '1992.03.05', 'Administrator');

INSERT INTO Tariffs (Title, Price)
VALUES	('Базовый', 1900),
		('С тренером', 2900),
		('Премиум', 3500);

INSERT INTO Groups (ID_tariff)
VALUES	(1),
		(2),
		(1),
		(1),
		(3),
		(3);

INSERT INTO Clients_Groups (ID_client, ID_group)
VALUES	(1, 2),
		(2, 1),
		(2, 5),
		(3, 5),
		(4, 5),
		(5, 1),
		(6, 1);

INSERT INTO Subscriptions (ID_client, ID_gym, ID_tariff, StartingDate, ExpiringDate, Expired)
VALUES	(1, 2, 1, '2023.09.18', '2023.12.18', 0),
		(2, 1, 2, '2023.06.02', '2023.11.02', 1),
		(3, 3, 1, '2021.11.13', '2024.02.23', 0);

INSERT INTO Activities (ActivityName)
VALUES	('Футбол'),
		('Баскетбол'),
		('Гандбол'),
		('Армрестлинг'),
		('Растяжка'),
		('Личная тренировка');

INSERT INTO Coaches (Lastname, Firstname, Surname, Rating, BirthDate)
VALUES	('Сибирцев', 'Константин', 'Вадимович', 4.1, '1983.09.13'),
		('Алеутов', 'Святогор', 'Брониславович', 3.2, '1986.12.23'),
		('Лепетин', 'Егор', 'Евгеньевич', 3.3, '1993.11.02'),
		('Галкин', 'Виталий', 'Александрович', 4.8, '1970.03.19');

INSERT INTO CoachActivities (ID_coach, ID_activity)
VALUES	(4, 3),
		(4, 5),
		(2, 4),
		(1, 6),
		(3, 6);

INSERT INTO GymActivities (ID_gym, ID_activity)
VALUES	(1, 1),
		(1, 2),
		(1, 3),
		(1, 5),
		(2, 3),
		(2, 5),
		(3, 4),
		(3, 5),
		(3, 6),
		(4, 5),
		(4, 6),
		(5, 5),
		(4, 6),
		(6, 5),
		(6, 6);

INSERT INTO Schedule (ID_gym, ID_activity, ID_coach, ID_group, StartTime, EndTime, Day)
VALUES	(1, 3, 4, 5, '17:00:00', '19:00:00', '2023.11.04'),
		(1, 3, 4, 5, '17:00:00', '19:00:00', '2023.11.11'),
		(1, 3, 4, 5, '17:00:00', '19:00:00', '2023.11.18'),
		(1, 3, 4, 5, '17:00:00', '19:00:00', '2023.11.25'),
		(2, 5, 1, 3, '12:00:00', '13:30:00', '2023.11.03'),
		(2, 5, 1, 3, '12:00:00', '13:30:00', '2023.11.10'),
		(3, 6, 2, 2, '14:00:00', '15:00:00', '2023.11.04');