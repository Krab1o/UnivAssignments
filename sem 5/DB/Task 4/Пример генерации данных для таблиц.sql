-- заполнение таблицы товаров

declare @n int = 0;
declare @myIdent uniqueidentifier;
declare @AltKey nvarchar(25);
declare @a char = 'А', @z char = 'я', @w int, @l int
SET @w = ascii(@z) - ascii(@a);
SET @l = ascii(@a);
declare @CatProd nvarchar(50) = 'aa';
declare @NameProd nvarchar(50) = 'a';
declare @Manfact nvarchar(50) = 'aaa';
declare @CountGeo int
select @CountGeo = count(*) from [dbo].[dimGeography]
declare @GeoKey int = 1;
declare @Color nvarchar (30);
declare @Weigth decimal(8,2);
declare @Size nvarchar (10);
declare @Material nvarchar (30);
declare @Type nvarchar (15);

while (@n<100000)
begin
	SET @myIdent = NEWID();
	SET @AltKey = left(replace(@myIdent,'-',''),10);
	if (len(@CatProd)>10) SET @CatProd = 'aa' else SET @CatProd = @CatProd+char(round(rand() * @w, 0) + @l)
	if (len(@NameProd)>20) SET @NameProd = 'a' else SET @NameProd = @NameProd+char(round(rand() * @w, 0) + @l)
	if (len(@Manfact)>10) SET @NameProd = 'aaa' else SET @Manfact = @Manfact+char(round(rand() * @w, 0) + @l)
	if (@GeoKey > @CountGeo) SET @GeoKey = @GeoKey%@CountGeo
	SET @Color = left(replace(@myIdent,'-',''),5);
	SET @Weigth = RAND();
	SET @Size = char(round(rand() * 8, 0) + ascii(1))+'X'+char(round(rand() * 8, 0) + ascii(1))+'X'+char(round(rand() * 8, 0) + ascii(1))
	SET @Material = left(replace(@myIdent,'-',''),7);
	SET @Type = left(replace(@myIdent,'-',''),5);
	insert into [dbo].[dimProduct]
	values (@AltKey,@CatProd,@NameProd,@Manfact,@GeoKey, @Color,@Weigth, @Size, @Material, @Type, char(rand()*25 + 65))
	SET @n=@n+1
	SET @GeoKey = @GeoKey+1;
end

-- заполнение таблицы клиентов
/*
declare @n int = 0;
declare @k int = 20;
declare @myIdent uniqueidentifier;
declare @AltKey nvarchar(12);
declare @a char = 'А', @z char = 'я', @w int, @l int
SET @w = ascii(@z) - ascii(@a);
SET @l = ascii(@a);
declare @TaxN bigint;
declare @TaxNumber varchar(12);
declare @Date_of_entry Date;
declare @Name nvarchar(50) = 'Ива';
declare @Gender char(1);
declare @BirthDate Date;
declare @CountGeo int
select @CountGeo = count(*) from [dbo].[dimGeography]
declare @GeoKey int = 1;

while (@n<100000)
begin
	SET @myIdent = NEWID();
	SET @AltKey = left(replace(@myIdent,'-',''),12);
	SET @TaxN = RAND()*1000000000000
	SET @TaxNumber = cast(@TaxN as varchar(12))
	if (@k>80) SET @k=20
	SET @Date_of_entry  = dateadd(day, -@k, Getdate())
	if (len(@Name)>25) SET @Name = 'Ива' else SET @Name = @Name+char(round(rand() * @w, 0) + @l)
	if (@k%3=0 or @k%5=0) SET @Gender = 'Ж' else SET @Gender = 'М'
	SET @BirthDate = dateadd(year, -@k, Getdate())
	SET @BirthDate = dateadd(day,@k, @BirthDate)
	if (@GeoKey>@CountGeo) SET @GeoKey = @GeoKey%@CountGeo

	insert into [dbo].[dimCustomer]([CustomerAlternateKey], [TaxNumber],[Date_of_entry],[Name],[Gender],[BirthDate],[GeographyKey],[flag])
	values (@AltKey,@TaxNumber,@Date_of_entry,@Name,@Gender,@BirthDate,@GeoKey,1)
	SET @n=@n+1
	SET @k=@k+1
	SET @GeoKey = @GeoKey+1;
end
*/
