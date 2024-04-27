SET statistics TIME ON
SET statistics io ON

DROP TABLE IF EXISTS Help

CREATE TABLE [Help] (
	[id] INT NOT NULL,
	[help_string] VARCHAR(255) NOT NULL,
	[help_int] INT NOT NULL,
	[help_float] FLOAT NOT NULL,
);


-- НЕКЛАСТЕРНЫЙ ИНДЕКС - содержит только те столбцы (ключевые), по которым определен данный индекс, а также содержит указатель на строки с реальными данными в таблице
-- 1. СОСТАВНОЙ ИНДЕКС - может содержать более одного столбца
CREATE NONCLUSTERED INDEX ind1_1 ON Holder(id, holder_phone);
CREATE NONCLUSTERED INDEX ind1_2 ON Buyer(id);
	SELECT Buyer.id, Holder.holder_phone FROM Holder INNER JOIN Buyer ON Buyer.id = Holder.id and holder_phone LIKE N'%1';
DROP INDEX ind1_1 ON Holder;
DROP INDEX ind1_2 ON Buyer;

CREATE NONCLUSTERED INDEX ind2 ON Contract(rental_type, cost);
	SELECT id, rental_type, cost FROM Contract WHERE rental_type = 0 AND EXISTS (SELECT id FROM Contract WHERE cost < 900000);
DROP INDEX ind2 ON Contract;

CREATE NONCLUSTERED INDEX ind3 ON Buyer(buyer_email);
	SELECT buyer_email FROM Buyer WHERE buyer_email LIKE N'S%';
DROP INDEX ind3 ON Buyer;

CREATE NONCLUSTERED INDEX ind4 ON Buying(cost);
	SELECT MIN(cost) AS min_cost, MAX(cost) AS max_cost FROM Buying	WHERE cost > 900000;
DROP INDEX ind4 ON Buying;

CREATE NONCLUSTERED INDEX ind5 ON Buying(date);
	SELECT id, date, DATEADD(day, 37, date) AS date_add_num FROM Buying;
DROP INDEX ind5 ON Buying;

CREATE NONCLUSTERED INDEX ind6 ON Buying(date);
	SELECT id, REPLACE(date, N'-', N'.') AS date_dot FROM Buying;
DROP INDEX ind6 ON Buying;

CREATE NONCLUSTERED INDEX ind7 ON Address(city);
	SELECT city, UNICODE(SUBSTRING(city, 1, 1)) AS city1_unicode FROM Address;
DROP INDEX ind7 ON Address;

CREATE NONCLUSTERED INDEX ind8 ON House(live_square, num_of_floors, id);
	SELECT id, num_of_floors FROM
	(SELECT id, num_of_floors, live_square FROM House WHERE live_square > 150) AS live_square_mt150
	WHERE num_of_floors = 4;
DROP INDEX ind8 ON House;


-- 2. ПОКРЫВАЮЩИЙ ИНДЕКС - позволяет конкретному запросу сразу получить все необходимые данные с листьев индекса без дополнительных обращений к записям самой таблицы
CREATE INDEX ind9 ON Flat(id) INCLUDE (holder_id)
	SELECT Flat.id FROM Flat INNER JOIN Holder ON Flat.holder_id = Holder.id;
DROP INDEX ind9 ON Flat;

CREATE INDEX ind10 ON Flat(id) INCLUDE (is_redecorated)
	SELECT id FROM Flat WHERE is_redecorated IN (0);
DROP INDEX ind10 ON Flat;

CREATE INDEX ind11 ON Holder(holder_name) INCLUDE (id)
	SELECT id, holder_name,
	  CASE
		WHEN holder_name LIKE N'А%' THEN N'А'
		WHEN holder_name LIKE N'A%' THEN N'A'
		WHEN holder_name LIKE N'Д%' THEN N'Д'
		ELSE N'not А and not Д'
	  END first_name_letter_WITH_ELSE,
	  CASE
		WHEN holder_name LIKE N'А%' THEN N'А'
		WHEN holder_name LIKE N'A%' THEN N'A'
		WHEN holder_name LIKE N'Д%' THEN N'Д'
	  END first_name_letter_WITHOUT_ELSE
	FROM Holder;
DROP INDEX ind11 ON Holder;

CREATE INDEX ind12 ON Flat(id) INCLUDE (live_square)
	SELECT AVG(live_square) AS average_live_square FROM Flat;
DROP INDEX ind12 ON Flat;

CREATE INDEX ind13 ON Realtor(id) INCLUDE (realtor_surname)
	SELECT id, realtor_surname, STUFF(STR(id), 2, 0, '_id') AS id_str FROM Realtor
DROP INDEX ind13 ON Realtor;

CREATE INDEX ind14 ON Rent(date_begin, date_end) INCLUDE (id)
	SELECT id, date_begin, date_end, DATEDIFF(day, date_begin, date_end) AS days_num FROM Rent WHERE date_end IS NOT NULL;
DROP INDEX ind14 ON Rent;

CREATE INDEX ind15 ON Buying(date) INCLUDE (id)
	SELECT id, [date] FROM Buying WHERE [date] = '05.05.2021' 
	INTERSECT 
	SELECT holder_name, holder_phone FROM Holder
DROP INDEX ind15 ON Buying

CREATE INDEX ind16 ON Realtor(realtor_name) INCLUDE (realtor_surname)
	SELECT realtor_name, realtor_surname FROM Realtor WHERE realtor_name LIKE 'S%'
	UNION 
	SELECT holder_name, holder_phone FROM Holder
DROP INDEX ind16 ON Realtor

CREATE INDEX ind17 ON Contract(cost) INCLUDE (realtor_id)
	SELECT realtor_id, SUM(cost) AS Pay FROM Contract GROUP BY realtor_id HAVING SUM(cost) BETWEEN 500000 AND 5000000
DROP INDEX ind17 ON Contract


-- 3. УНИКАЛЬНЫЙ ИНДЕКС - обеспечивает уникальность каждого значения в индексируемом столбце
CREATE UNIQUE INDEX ind18 ON Contract(cost, rental_type, id);
	SELECT id, rental_type, cost FROM Contract WHERE cost > ALL (SELECT cost FROM Contract WHERE rental_type = 0);
DROP INDEX ind18 ON Contract;

CREATE UNIQUE INDEX ind19 ON Buying(house_id, id);
	SELECT house_id, id FROM Buying WHERE house_id IS NULL;
DROP INDEX ind19 ON Buying;

CREATE UNIQUE INDEX ind20 ON House(square, holder_id);
	SELECT SUM(square) AS sum_square FROM House WHERE holder_id = 6;
DROP INDEX ind20 ON House;

CREATE UNIQUE INDEX ind21 ON Buyer(buyer_phone, id);
	SELECT id, SUBSTRING(buyer_phone, 6, 6) AS short_buyer_phone FROM Buyer;
DROP INDEX ind21 ON Buyer;

CREATE UNIQUE INDEX ind22 ON Address(city, id);
	SELECT city, LOWER(city) AS city_lower, UPPER(city) AS city_upper FROM Address;
DROP INDEX ind22 ON Address;

CREATE UNIQUE INDEX ind23 ON Rent(date_end, id);
	SELECT id, date_end, IIF(date_end > GETDATE(), 'договор не истёк', 'договор истёк') AS valid_contract FROM Rent;
DROP INDEX ind23 ON Rent;


-- 4. ФИЛЬТРОВАННЫЙ ИНДЕКС
CREATE NONCLUSTERED INDEX ind24 ON Address(num_of_floors, id) WHERE num_of_floors > 4
	SELECT id, num_of_floors FROM Address WHERE num_of_floors BETWEEN 5 AND 10;
DROP INDEX ind24 ON Address

CREATE NONCLUSTERED INDEX ind25 ON House(square, is_redecorated, id) WHERE square > 400
	SELECT id, square, COALESCE (CHOOSE (is_redecorated, 'с ремонтом'), 'без ремонта') AS decor FROM House WHERE square > 400;
DROP INDEX ind25 ON House

CREATE NONCLUSTERED INDEX ind26 ON Flat(live_square) WHERE live_square > 400
	SELECT live_square, CAST(live_square AS int) as live_square_int FROM Flat WHERE live_square > 400;
DROP INDEX ind26 ON Flat

CREATE NONCLUSTERED INDEX ind27 ON Contract(date_begin, date_end) WHERE date_begin > '30.12.2015'
	SELECT id, date_begin, date_end, IIF(DATEPART(year, date_begin) = DATEPART(year, date_end), 'один год', 'разные года') AS same_year
	FROM Contract WHERE date_end IS NOT NULL and date_begin > '30.12.2015';
DROP INDEX ind27 ON Contract

CREATE NONCLUSTERED INDEX ind28 ON Contract(buyer_id, cost) WHERE cost < 40000
	SELECT id, buyer_name, buyer_surname FROM Buyer WHERE id = ANY (SELECT buyer_id FROM Contract WHERE cost < 40000);
DROP INDEX ind28 ON Contract


-- 5. КЛАСТЕРНЫЙ ИНДЕКС - хранит реальные строки данных в листьях индекса
CREATE CLUSTERED INDEX ind29 ON Help(help_string);
  SELECT * FROM Help WHERE help_string = 'Brass'

  SELECT help_string FROM Help GROUP BY help_string HAVING help_string LIKE '%l';

  SELECT help_string FROM Help GROUP BY help_string
DROP INDEX ind29 ON Help;


SELECT * FROM Holder
SELECT * FROM Buyer
SELECT * FROM Realtor
SELECT * FROM Address
SELECT * FROM Flat
SELECT * FROM House
SELECT * FROM Buying
SELECT * FROM Rent
SELECT * FROM Contract
SELECT * FROM Help