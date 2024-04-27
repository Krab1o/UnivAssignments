INSERT Holder (id, holder_surname, holder_name, holder_phone, holder_email)  
    VALUES (1, N'�������', N'���������', N'89658834740', N'elizchet@yandex.ru'), 
	       (2, N'�������', N'�������', N'89276457800', N'shevtsovav@mail.ru'),
		   (3, N'�������', N'��������', N'85336526193', N'libero.nec@icloud.org'),
		   (4, N'���������', N'�����', N'86917564728', N'iaculis.odio@hotmail.couk'),
		   (5, N'������ ', N'������', N'82322551087', N'velit@protonmail.org'),
		   (6, N'��������', N'�����', N'83017745683', N'et@protonmail.com'),
		   (7, N'�������', N'������', N'89857341647', N'fermentum.convallis@icloud.org'),
		   (8, N'�������', N'���������', N'84826397481', N'augue@hotmail.org'),
		   (9, N'������', N'�����', N'87164034716', N'fusce.mi@aol.edu'),
		   (10, N'���������', N'�������', N'85356582591', N'lizoklizo@yandex.ru')
GO

INSERT Buyer(id, buyer_surname, buyer_name, buyer_phone, buyer_email)  
    VALUES (1, N'������', N'����', N'88005553535', N'petrov.ivan@mail.ru'), 
	       (2, N'�������', N'�����', N'89272670610', N'88irensh9@mail.ru'),
		   (3, N'�������', N'����', N'88468582121', N'euismod.mauris@icloud.couk'),
		   (4, N'������', N'����������', N'85315769796', N'purus.accumsan@icloud.ca'),
		   (5, N'�����', N'������', N'87852828074', N'lectus.pede@icloud.couk'),
		   (6, N'����������', N'������', N'85173230788', N'in.tincidunt@hotmail.com'),
		   (7, N'�������', N'���������', N'87754765530', N'a.mi.fringilla@protonmail.com'),
		   (8, N'����������', N'������', N'83116370936', N'sed@yahoo.net'),
		   (9, N'�������', N'������', N'87127449937', N'mattis.ornare.lectus@protonmail.net'),
		   (10, N'���������', N'��������', N'86738536666', N'sit.amet.nulla@hotmail.couk')
GO

INSERT Realtor(id, realtor_surname, realtor_name, realtor_phone, realtor_email)  
    VALUES (1, N'������', N'������', N'89053331427', N'd.chind23@bk.ru'),
	       (2, N'�������', N'���������', N'84086236937', N'alexey8927@mail.ru'),
		   (3, N'�������', N'�������', N'87352931142', N'nec.ante.blandit@hotmail.org'),
		   (4, N'�����', N'��������', N'85547439143', N'egestas@icloud.com'),
		   (5, N'��������', N'������', N'88675725017', N'velit.justo@protonmail.edu'),
		   (6, N'������', N'�����', N'82737155174', N'tincidunt.vehicula@google.ca'),
		   (7, N'���������', N'����������', N'83686391671', N'vitae.aliquet@google.net'),
		   (8, N'������', N'�����', N'84907567704', N'tellus.lorem@yahoo.edu'),
		   (9, N'��������', N'�����', N'83797488111', N'elit@outlook.couk'),
		   (10, N'�������', N'������', N'84552281139', N'pulvinar@aol.edu')
GO

INSERT Address (id, city, street, house_num, num_of_floors, construction_year)  
	VALUES (1, N'������', N'����� �����', N'1', 5, 1940), 
	       (2, N'�������', N'������������', N'44', 9, 1980),
		   (3, N'�������', N'���������', N'18/40', 17, 1981),
		   (4, N'�����������', N'������', N'83', 9, 1947), 
		   (5, N'������', N'�����������', N'27', 15, 2000), 
		   (6, N'�����������', N'�.�������������', N'87', 2, 1979), 
		   (7, N'�������', N'�. ��������', N'33', 1, 1980), 
		   (8, N'�����-���������', N'������� ����������', N'24', 4, 1887),
		   (9, N'�����', N'��������', N'165', 2, 2012), 
		   (10, N'�������', N'���. �����������', N'3', 3, 2018)
GO

-- 1 - ���� ������, 0 - ��� ������� (is_redecorated)
INSERT Flat (id, holder_id, address_id, floor, flat_num, num_of_rooms, live_square, square, is_redecorated)  
    VALUES (1, 1, 1, 5, 22, 7, 200.5, 240, 1),
	       (2, 2, 2, 1, 2, 2, 31, 37.7, 0),
		   (3, 3, 3, 15, 345, 4, 56, 66, 1),
		   (4, 4, 4, 7, 123, 1, 18.1, 20, 1),
		   (5, 5, 5, 13, 278, 4, 57.7, 66, 0),
		   (6, 6, 1, 4, 17, 8, 210, 260.4, 0),
		   (7, 7, 2, 4, 16, 3, 88, 96, 1),
		   (8, 8, 3, 10, 89, 3, 79.9, 87, 1),
		   (9, 9, 4, 5, 50, 2, 54, 65.1, 0),
		   (10, 10, 5, 15, 333, 1, 23.5, 27, 1)
GO

-- 1 - ���� ������, 0 - ��� ������� (is_redecorated)
-- 1 - ���� �������, 0 - ��� ������� (has_open_space)
INSERT House (id, holder_id, address_id, has_open_space, num_of_floors, land_area, live_square, square, is_redecorated)  
    VALUES (1, 6, 6, 1, 2, 20, 41, 45.8, 0), 
	       (2, 7, 7, 0, 1, 5, 21.3, 27, 0), 
		   (3, 1, 8, 0, 4, 50.5, 187.9, 203.6, 1), 
		   (4, 3, 9, 0, 2, 30, 39, 46.1, 1), 
		   (5, 6, 10, 1, 3, 10.7, 88.8, 100.9, 1)
GO

INSERT Buying (id, realtor_id, flat_id, house_id, date, cost)  
    VALUES (1, 1, 1, null, '12.10.2022', 90000000),
	       (2, 2, 2, null, '11.09.2022', 7000000),
		   (3, 3, 3, null, '28.07.2021', 20000000),
		   (4, 4, 4, null, '01.02.2020', 10000000),
		   (5, 5, null, 1, '17.11.2018', 150000000),
		   (6, 6, null, 2, '05.11.2020', 100000000)
GO

-- 1 - �������, 0 - ������ (rent_type)
INSERT Rent (id, realtor_id, flat_id, house_id, date_begin, date_end, cost, rent_type)  
    VALUES (1, 7, 5, null, '11.12.2021', '13.12.2021', 15000, 0),
	       (2, 8, 6, null, '11.11.2022', '12.11.2022', 5500, 0),
		   (3, 9, 7, null, '01.03.2020', '01.07.2020', 34700, 1),
		   (4, 10, 8, null, '17.04.2020', '17.04.2021', 60000, 1),
		   (5, 1, 9, null, '22.08.2017', '22.10.2017', 20000, 1),
		   (6, 2, 10, null, '23.01.2012', '24.01.2012', 1500, 0),
		   (7, 3, null, 3, '18.01.2016', '18.07.2016', 130000, 1),
		   (8, 4, null, 4, '06.05.2016', '06.05.2018', 200000, 1),
		   (9, 5, null, 5, '09.06.2018', '13.06.2018', 13400, 0)
GO

-- 1 - �������, 0 - ������ (rental_type)
INSERT Contract (id, holder_id, realtor_id, buyer_id, flat_id, house_id, contract_num, rental_type, cost, date_begin, date_end)  
    VALUES (1, 1, 1, 1, 1, null, 1, 1, 90000000, '12.10.2022', null), 
	       (2, 2, 2, 1, 2, null, 2, 1, 7000000, '11.09.2022', null),
		   (3, 3, 3, 2, 3, null, 3, 1, 20000000, '28.07.2021', null),
		   (4, 4, 4, 1, 4, null, 4, 1, 10000000, '01.02.2020', null),
		   (5, 6, 5, 2, null, 1, 5, 1, 150000000, '17.11.2018', null),
		   (6, 7, 6, 2, null, 2, 6, 1, 100000000, '05.11.2020', null),
		   (7, 5, 7, 2, 5, null, 7, 0, 15000, '11.12.2021', '13.12.2021'),
		   (8, 6, 8, 3, 6, null, 8, 0, 5500, '11.11.2022', '12.11.2022'),
		   (9, 7, 9, 4, 7, null, 9, 0, 34700, '01.03.2020', '01.07.2020'),
		   (10, 8, 10, 5, 8, null, 10, 0, 60000, '17.04.2020', '17.04.2021'),
		   (11, 9, 1, 6, 9, null, 11, 0, 20000, '22.08.2017', '22.10.2017'),
		   (12, 10, 2, 7, 10, null, 12, 0, 1500, '23.01.2012', '24.01.2012'),
		   (13, 1, 3, 8, null, 3, 13, 0, 130000, '18.01.2016', '18.07.2016'),
		   (14, 3, 4, 9, null, 4, 14, 0, 200000, '06.05.2016', '06.05.2018'),
		   (15, 6, 5, 10, null, 5, 15, 0, 13400, '09.06.2018', '13.06.2018')
GO


-- 1. ������� id ���������� ������, � ������� ��������� < 9000 (EXISTS)
 SELECT id FROM Contract
	  WHERE rental_type = 0
      AND EXISTS (SELECT
      id FROM Rent
      WHERE cost < 9000);

-- 2. ������� ���������� � ���������, � ������� ��� �������������� ������� (IN)
SELECT * FROM Flat
WHERE is_redecorated IN (0);

-- 3. ������� ���������� � ���������, � ������� ��������� ������ ��� ��������� �� ���� ���������� ������ (ALL)
SELECT flat_id, house_id, contract_num, rental_type
   FROM Contract
   WHERE cost > ALL (SELECT 
   cost FROM Contract 
   WHERE rental_type = 0);

-- 4. ������� ���������� � �����������, � ������� ���� � ��������� < 40000 (SOME/ANY)
 SELECT id, buyer_name, buyer_surname
   FROM Buyer
   WHERE id = ANY (SELECT 
   buyer_id FROM Contract 
   WHERE cost<40000);

-- 5. ������� ���������� � �����, � ������� �� 5 �� 10 ���� (BETWEEN)
SELECT id, city, street, house_num FROM Address
WHERE num_of_floors BETWEEN 5 AND 10;

-- 6. ������� ���� ����������� � ������� ����� @mail.ru (LIKE)
SELECT * FROM Buyer
WHERE buyer_email LIKE N'%@mail.ru';

-- 7. ������� ��������� ����� ����� ���������, ���� ��� � ��� � (CASE)
SELECT
  id, holder_surname, holder_name,

  CASE
    WHEN holder_name LIKE N'�%' THEN N'�'
	WHEN holder_name LIKE N'�%' THEN N'�'
    ELSE N'not � and not �'
  END first_name_letter_WITH_ELSE,

  CASE
    WHEN holder_name LIKE N'�%' THEN N'�'
	WHEN holder_name LIKE N'�%' THEN N'�'
  END first_name_letter_WITHOUT_ELSE

FROM Holder;

-- 8. �������� ����� �������� ����� ������� �������� (CAST/CONVERT)
SELECT CAST(live_square AS int) FROM Flat;

-- 9. ������� ���������� � ������� ������� (NULL)
SELECT * FROM Buying WHERE house_id IS NULL;

-- 10. ���� � �����. ������� �� 0 - �� ��� ������� �����. ����� (ISNULL)
SELECT id, 
	ISNULL(flat_id, 0) AS buying_flat,
	ISNULL(house_id, 0) AS buying_house
FROM Buying;

-- 11. ������� null, ���� � ����� � ������� �������� ���������� ���-�� ����; ����� ������� ���-�� ���� � ����� (ISNULL)
SELECT id, realtor_name, realtor_surname,
	NULLIF(LEN(realtor_name), LEN(realtor_surname)) result
FROM Realtor

-- 12. ������� ���������� � ������� ������� (CHOOSE + COALESCE)
SELECT id, is_redecorated,
	  COALESCE (CHOOSE (is_redecorated, '� ��������'), '��� �������') AS decor
FROM House;

-- 13. �������, ����� �������� �������� ����������, ���� ����� �������� � ������������� �������� (IIF + COALESCE)
SELECT id,
	COALESCE (IIF(is_redecorated = 1, '��������', '�� ��������'), NULL) AS suitable_flat
FROM Flat;

-- 14. �������� - �� . � ����� ������� (REPLACE)
SELECT id, REPLACE(date, N'-', N'.') AS date_dot FROM Buying;

-- 15. ������� ��������� 6 ���� ������� ����������� (SUBSTRING)
SELECT id, buyer_name, buyer_surname, SUBSTRING(buyer_phone, 6, 6) AS short_buyer_phone FROM Buyer;

-- 16. �������� - � ������ ����������� (STUFF)
SELECT id, buyer_name, buyer_surname, STUFF(STUFF(buyer_phone,2,0,'-'),6,0,'-') AS date_dot FROM Buyer;

-- 17. �������� � int id ��������� _id (STR)
SELECT id, realtor_name, realtor_surname, STUFF(STR(id), 2, 0, '_id') AS id_str FROM Realtor

-- 18. �������� unicode ������ ����� ������ (UNICODE)
SELECT city, UNICODE(SUBSTRING(city, 1, 1)) AS city1_unicode FROM Address;

-- 19. ��������� ����� � �������� ������ � ������ � ������� ������� �������������� (LOWER + UPPER)
SELECT city, LOWER(city) AS city_lower, UPPER(city) AS city_upper FROM Address;

-- 20. �������, � ���� �� ��� ���������� � ������������� �������� ������ ����� (DATEPART)
SELECT id, date_begin, date_end, IIF(DATEPART(year, date_begin) = DATEPART(year, date_end), '���� ���', '������ ����')
AS same_year FROM Contract 
WHERE date_end IS NOT NULL;

-- 21. ��������� � ���� ������� 37 ���� (DATEADD)
SELECT id, date, DATEADD(day, 37, date) AS date_add_num FROM Buying;

-- 22. ����������, ������� ���� ������ ������� ������ (DATEDIFF)
SELECT id, date_begin, date_end, DATEDIFF(day, date_begin, date_end) AS days_num FROM Rent WHERE date_end IS NOT NULL;

-- 23. ���������, ���� �� ������� ������ �� ������ ������ (GETDATE())
SELECT id, date_end, IIF(date_end > GETDATE(), '������� �� ����', '������� ����')
AS valid_contract FROM Rent ;

-- 24. ������� ������� ���� � ����� (SYSDATETIMEOFFSET())
SELECT SYSDATETIMEOFFSET() AS cur_date_time;

-- 25. ������� ����������� � ������������ ��������� ����� (MIN, MAX)
SELECT MIN(cost) AS min_cost, MAX(cost) AS max_cost FROM Buying;

-- 26. ������� ������� ����� ������� ������� (AVG)
SELECT AVG(live_square) AS average_live_square FROM Flat;

-- 27. ������� ����� ������� ������������ ��������� � id = 6 (SUM)
SELECT SUM(square) AS sum_square FROM House WHERE holder_id = 6;

-- 28. ������� ��� ������ � ������� ��� ���������� (GROUP BY)
SELECT city FROM Address GROUP BY city;

-- 29. ������� �����������, ������� ��������� ������ 100000 �� ������������ (HAVING)
SELECT buyer_id FROM Contract GROUP BY buyer_id HAVING SUM(cost) > 100000;
SELECT * FROM Contract; -- ��� ���������

-- Inner join, Outer join, Cross join, Cross apply, ��������������
-- ����������
-- 1. ������� ���������� � ������� ���� ����� �� ������� House (INNER JOIN)
SELECT House.id, address_id, num_of_floors, live_square, Buying.id, date, cost, house_id
FROM House INNER JOIN Buying
ON House.id = Buying.house_id;

-- 2. ������� ���������� � ���������� � �� ��������� (LEFT OUTER JOIN)
SELECT Flat.id AS flat_id, floor, flat_num, holder_id, holder_surname, holder_name
FROM Flat
LEFT OUTER JOIN Holder ON Flat.holder_id = Holder.id;

-- 3. ������� ���������� � ���������� � �� ��������� (RIGHT OUTER JOIN)
SELECT Flat.id AS flat_id, floor, flat_num, holder_id, holder_surname, holder_name
FROM Flat
RIGHT OUTER JOIN Holder ON Flat.holder_id = Holder.id;

-- 4. ���������� ��������� ������������ ������ ����������� � ����� (CROSS JOIN)
SELECT * FROM Buyer CROSS JOIN House;

-- 5. CROSS APPLY
SELECT realtor_surname, realtor_name, realtor_id, date_begin, rental_type FROM Realtor CROSS APPLY Contract;

-- 6. �������������� (JOIN)
SELECT c1.id, c1.date_begin, c1.realtor_id, c1.rental_type
    FROM Contract c1 JOIN Contract c2
        ON c1.realtor_id = c2.realtor_id
    WHERE c1.date_begin <> c2.date_begin;

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