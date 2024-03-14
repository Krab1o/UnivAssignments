-- DELETE FROM Help
-- DELETE FROM Contract
-- DELETE FROM Rent
-- DELETE FROM Buying
-- DELETE FROM House
-- DELETE FROM Flat
-- DELETE FROM Address
-- DELETE FROM Realtor
-- DELETE FROM Buyer
-- DELETE FROM Holder

-- далее вставляем данные из задания 3
SELECT * FROM Holder
SELECT * FROM Buyer
SELECT * FROM Realtor
SELECT * FROM Address
SELECT * FROM Flat
SELECT * FROM House
SELECT * FROM Buying
SELECT * FROM Rent
SELECT * FROM Contract


--INSERT
CREATE TRIGGER tr1 ON Contract
INSTEAD OF INSERT
AS
BEGIN
  DECLARE @c_id INT, @c_holder_id INT, @c_realtor_id INT, @c_buyer_id INT, @c_flat_id INT, @c_house_id INT, @c_contract_num INT, 
	      @c_rental_type INT, @c_cost INT, @c_date_begin DATE, @c_date_end DATE, @c_is_archived INT
  SELECT @c_id = id, @c_holder_id = holder_id, @c_realtor_id = realtor_id, @c_buyer_id = buyer_id, @c_flat_id = flat_id, @c_house_id = house_id, 
	     @c_contract_num = contract_num, @c_rental_type = rental_type, @c_cost = cost, @c_date_begin = date_begin, 
		 @c_date_end = date_end, @c_is_archived = is_archived FROM inserted
  IF ((SELECT rental_type FROM inserted) = 1)
  BEGIN
    SET @c_date_end = NULL
    INSERT Contract (id, holder_id, realtor_id, buyer_id, flat_id, house_id, contract_num, rental_type, cost, date_begin, date_end, is_archived)  
      VALUES (@c_id, @c_holder_id, @c_realtor_id, @c_buyer_id, @c_flat_id, @c_house_id, @c_contract_num, @c_rental_type, @c_cost, @c_date_begin, @c_date_end, @c_is_archived)
  END
  ELSE
  INSERT Contract (id, holder_id, realtor_id, buyer_id, flat_id, house_id, contract_num, rental_type, cost, date_begin, date_end, is_archived)  
    VALUES (@c_id, @c_holder_id, @c_realtor_id, @c_buyer_id, @c_flat_id, @c_house_id, @c_contract_num, @c_rental_type, @c_cost, @c_date_begin, @c_date_end, @c_is_archived)
END
DROP TRIGGER tr1

-- показ работы триггера
INSERT Contract (id, holder_id, realtor_id, buyer_id, flat_id, house_id, contract_num, rental_type, cost, date_begin, date_end)  
    VALUES (16, 1, 1, 1, 1, null, 16, 1, 90000000, '12.10.2022', '01.01.2023')
INSERT Contract (id, holder_id, realtor_id, buyer_id, flat_id, house_id, contract_num, rental_type, cost, date_begin, date_end)  
    VALUES (17, 1, 1, 1, 1, null, 16, 0, 90000000, '12.10.2022', '01.01.2023')
SELECT * FROM Contract
-- откат назад
DELETE FROM Contract WHERE id = 16
DELETE FROM Contract WHERE id = 17


--UPDATE
CREATE TRIGGER tr2 ON Flat
INSTEAD OF UPDATE
AS
BEGIN
  DECLARE @f_floor_upd INT, @f_floor_real INT
  SELECT @f_floor_upd = floor FROM inserted
  SELECT @f_floor_real = floor FROM Flat WHERE id = (SELECT id FROM inserted)
  IF (@f_floor_upd <> @f_floor_real)
  BEGIN
    UPDATE Flat
    SET floor = @f_floor_real
    WHERE id = (SELECT id FROM deleted)
  END
  ELSE
  BEGIN
    UPDATE Flat
    SET floor = @f_floor_upd
    WHERE id = (SELECT id FROM deleted)
  END
END
DROP TRIGGER tr2

-- показ работы триггера
UPDATE Flat SET floor = 222 WHERE id = 1
UPDATE Flat SET floor = 1 WHERE id = 2
SELECT * FROM Flat


--DELETE
-- если аренда бессрочная, и человек захотел расторгнуть договор, то дата окончания аренды изменяется на текущую дату
CREATE TRIGGER tr3 ON Contract
INSTEAD OF DELETE
AS 
BEGIN
	UPDATE Contract
    SET date_end = GETDATE()
    WHERE id = (SELECT id FROM deleted)
END
DROP TRIGGER tr3

-- показ работы триггера
DELETE FROM Contract WHERE id = 1
SELECT * FROM Contract
-- откат назад
UPDATE Contract SET date_end = NULL WHERE id = 1 


--INSERT
CREATE TRIGGER tr4 ON Holder
FOR INSERT
AS
BEGIN
  IF (SELECT holder_name FROM inserted) LIKE '%[0-9]%'
  BEGIN
    ROLLBACK TRAN
    RAISERROR('Российское законодательство запрещает иметь имя, содержащее цифры', 0, 1) WITH NOWAIT
  END
END
DROP TRIGGER tr4

-- показ работы триггера
INSERT Holder (id, holder_surname, holder_name, holder_phone, holder_email)  
    VALUES (11, N'Абобов', N'Абоба2007', N'89658834740', N'elizchet@yandex.ru')
SELECT * FROM Holder


--UPDATE
CREATE TRIGGER tr5 ON Holder
FOR UPDATE
AS
BEGIN
  IF (SELECT holder_phone FROM inserted) NOT LIKE '8%' -- + len
  BEGIN
    ROLLBACK TRAN
    RAISERROR('Номер телефона начинается с 8', 0, 1) WITH NOWAIT
  END
END
DROP TRIGGER tr5

-- показ работы триггера
UPDATE Holder SET holder_phone = 'aboba' WHERE id = 1
SELECT * FROM Holder


--DELETE
--ALTER TABLE Contract ADD is_archived INT
CREATE TRIGGER tr6 ON Contract
INSTEAD OF DELETE
AS
BEGIN
	UPDATE Contract
    SET is_archived = 1
    WHERE id = (SELECT id FROM deleted)
END
DROP TRIGGER tr6

-- показ работы триггера
DELETE FROM Contract WHERE id = 8
SELECT * FROM Contract
-- откат назад
UPDATE Contract SET is_archived = NULL WHERE id = 8