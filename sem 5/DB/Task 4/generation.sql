--Clients

declare @n int = 0;
declare @k int = 80;
--declare @myIdent uniqueidentifier;
--declare @AltKey nvarchar(25);
declare @a char = 'À', @z char = 'ÿ', @w int, @l int
SET @w = ascii(@z) - ascii(@a);
SET @l = ascii(@a);
declare @Lastname nvarchar(16) = 'aa'
declare @Firstname nvarchar(16) = 'a'
declare @Surname nvarchar(16) = 'aaa'
declare @BirthDate nvarchar(16)
declare @PhoneN bigint;
declare @PhoneNumber varchar(12);

DECLARE @StartDate AS date;
DECLARE @EndDate AS date;

SELECT @StartDate = '01/01/2019', -- Date Format - DD/MM/YYY
       @EndDate   = '12/31/2021';

SELECT DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @StartDate, @EndDate)),@StartDate) AS 'SalesDate';

/*
while (@n<10000)
begin
	--SET @myIdent = cast(NEWID() int);
	--SET @AltKey = left(replace(@myIdent,'-',''),10);
	if (len(@Lastname)>10) SET @Lastname = 'aa' else SET @Lastname = @Lastname+char(round(rand() * @w, 0) + @l)
	if (len(@Firstname)>20) SET @Firstname = 'a' else SET @Firstname = @Firstname+char(round(rand() * @w, 0) + @l)
	if (len(@Surname)>10) SET @Surname = 'aaa' else SET @Surname = @Surname+char(round(rand() * @w, 0) + @l)

	SET @PhoneN = RAND()*1000000000000
	SET @PhoneNumber = '+'+cast(@PhoneN as varchar(12))

	if (@k>80) SET @k=20
	SET @BirthDate  = dateadd(day, -@k, Getdate())
	SET @BirthDate = dateadd(year, -@k, Getdate())
	SET @BirthDate = dateadd(day, @k, @BirthDate)

	insert into [dbo].[Clients] ([Lastname], [Firstname], [Surname], [PhoneNumber], [BirthDate])
	values (@Lastname,@Firstname,@Surname,@PhoneNumber,@BirthDate)
	SET @k=@k+1
	SET @n=@n+1
end
*/
--Ñoaches
/*

SET @n=0
SET @k=80
SET @a = 'À' 
SET @z = 'ÿ'
SET @w = ascii(@z) - ascii(@a)
SET @l = ascii(@a)
SET @Lastname = 'aa'
SET @Firstname = 'a'
SET @Surname = 'aaa'

declare @Rating float;
while (@n<10000)
begin
	if (len(@Lastname)>10) SET @Lastname = 'aa' else SET @Lastname = @Lastname+char(round(rand() * @w, 0) + @l)
	if (len(@Firstname)>20) SET @Firstname = 'a' else SET @Firstname = @Firstname+char(round(rand() * @w, 0) + @l)
	if (len(@Surname)>10) SET @Surname = 'aaa' else SET @Surname = @Surname+char(round(rand() * @w, 0) + @l)

	--SET @PhoneN = RAND()*1000000000000
	SET @Rating = RAND()*(10-5); 

	if (@k>80) SET @k=20
	SET @BirthDate  = dateadd(day, -@k, Getdate())
	SET @BirthDate = dateadd(year, -@k, Getdate())
	SET @BirthDate = dateadd(day, @k, @BirthDate)

	insert into [dbo].[Coaches_unclustered] ([Lastname], [Firstname], [Surname], [Rating], [BirthDate])
	values (@Lastname,@Firstname,@Surname,@Rating,@BirthDate)
	SET @k=@k+1
	SET @n=@n+1
end

--activities
SET @n=0
SET @k=80
SET @a = 'À' 
SET @z = 'ÿ'
SET @w = ascii(@z) - ascii(@a)
SET @l = ascii(@a)
SET @Lastname = 'ACTIV'

while (@n<10000)
begin
	if (len(@Lastname)>12) SET @Lastname = 'aa' else SET @Lastname = @Lastname+char(round(rand() * @w, 0) + @l)
	
	insert into [dbo].[Activities] ([ActivityName])
	values (@Lastname)
	SET @n=@n+1
end
*/
/*
--gyms

SET @n=0
SET @k=80
SET @a = 'À' 
SET @z = 'ÿ'
SET @w = ascii(@z) - ascii(@a)
SET @l = ascii(@a)
SET @Lastname = 'TITLE'
SET @Surname = 'addr'

DECLARE @startTime Time = '01:00:00'
DECLARE @endTime TIME = '02:30:00'
-- Get the number of seconds between these two times
-- (eg. there are 5400 seconds between 1 AM and 2.30 AM)
DECLARE @maxSeconds int = DATEDIFF(ss, @startTime, @endTime)
DECLARE @randomSeconds1 int = (@maxSeconds + 1) 
* RAND(convert(varbinary, newId() )) 
DECLARE @randomTime1 Time
DECLARE @randomSeconds2 int = (@maxSeconds + 1) 
* RAND(convert(varbinary, newId() )) 
DECLARE @randomTime2 Time

while (@n<10000)
begin
	if (len(@Lastname)>12) SET @Lastname = 'TITLE' else SET @Lastname = @Lastname+char(round(rand() * @w, 0) + @l)
	if (len(@Surname)>12) SET @Surname = 'addr' else SET @Surname = @Surname+char(round(rand() * @w, 0) + @l)

	SET @randomSeconds1 = (@maxSeconds + 1) * RAND(convert(varbinary, newId()))
	SET @randomTime1 = convert(Time, DateAdd(second, @randomSeconds1, @startTime))
	SET @randomSeconds2 = (@maxSeconds + 1) * RAND(convert(varbinary, newId()))
	SET @randomTime2 = convert(Time, DateAdd(second, @randomSeconds2, @startTime))

	insert into [dbo].[Gyms_unclustered] ([Title], [OpenTime], [CloseTime], [Address])
	values (@Lastname, @randomTime1, @randomTime2, @Surname)
	SET @n=@n+1
end


--employees

declare @Occupation nvarchar(16) = 'WORK'
declare @ID int

while(@n<10000)
begin
	if (len(@Lastname)>10) SET @Lastname = 'aa' else SET @Lastname = @Lastname+char(round(rand() * @w, 0) + @l)
	if (len(@Firstname)>20) SET @Firstname = 'a' else SET @Firstname = @Firstname+char(round(rand() * @w, 0) + @l)
	if (len(@Surname)>10) SET @Surname = 'aaa' else SET @Surname = @Surname+char(round(rand() * @w, 0) + @l)
	if (len(@Occupation)>10) SET @Occupation = 'WORK' else SET @Occupation = @Occupation+char(round(rand() * @w, 0) + @l)

	SET @PhoneN = RAND()*1000000000000
	SET @PhoneNumber = '+'+cast(@PhoneN as varchar(12))

	if (@k>80) SET @k=20
	SET @BirthDate  = dateadd(day, -@k, Getdate())
	SET @BirthDate = dateadd(year, -@k, Getdate())
	SET @BirthDate = dateadd(day, @k, @BirthDate)
	SET @ID = ROUND(RAND() * 10000, 0)+1

	insert into [dbo].[Employees] ([ID_gym], [Lastname], [FirstName], [Surname], [PhoneNumber], [BirthDate], [Occupation])
	values (@ID, @Lastname,@Firstname,@Surname,@PhoneNumber,@BirthDate,@Occupation)
	SET @k=@k+1
	SET @n=@n+1
end


SET @Lastname = 'TARIFF'
DECLARE @Price int

while(@n<10000)
begin
	if (len(@Lastname)>12) SET @Lastname = 'TARIFF' else SET @Lastname = @Lastname+char(round(rand() * @w, 0) + @l)
	SET @Price = FLOOR(RAND()*(10000))+1

	insert into [dbo].[Tariffs]([Title], [Price])
	values (@Lastname, @Price)

	SET @n=@n+1
end



declare @ID_1 int
declare @ID_2 int

while(@n<10000)
begin
	
	SET @ID_1 = FLOOR(RAND()*(10000))+1
	SET @ID_2 = FLOOR(RAND()*(10000))+1
	if (@k>80) SET @k=20
	SET @BirthDate  = dateadd(day, -@k, Getdate())
	SET @BirthDate = dateadd(year, -@k, Getdate())
	SET @BirthDate = dateadd(day, @k, @BirthDate)

	insert into [dbo].[Lockers]([ID_client], [ID_gym], [ExpiringDate], [LockerNumber], [Expired])
	values (@ID_1, @ID_2, @BirthDate, @k, 0)
	SET @n=@n+1
	SET @k=@k+1
end
*/