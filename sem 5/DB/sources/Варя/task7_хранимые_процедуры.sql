-- 1. найти имена и телефоны владельцев, которые предлагают квартиры на n этаже и выше
CREATE PROCEDURE floor_flat @floor INT
AS
	BEGIN
	    --CREATE TABLE [Valid_floor]
            --(name       VARCHAR(255),
			--surname     VARCHAR(255),
			--phone       VARCHAR(255))
		--INSERT INTO Valid_floor (name, surname, phone)
			SELECT holder_name, holder_surname, holder_phone
			FROM Holder INNER JOIN Flat ON Flat.holder_id = Holder.id
			WHERE floor >= @floor
		--SELECT * FROM Valid_floor
		--DROP TABLE Valid_floor
	END
DROP PROCEDURE floor_flat

EXEC floor_flat 10

SELECT * FROM Flat
SELECT * FROM Holder


-- 2. по указанному id владельца вывести информацию о всех его продажах
CREATE PROCEDURE holder_info @holder_id INT
AS
    BEGIN
        DECLARE second_cur CURSOR FOR
        SELECT holder_id
        FROM Contract WHERE holder_id = @holder_id

        OPEN second_cur
            FETCH NEXT FROM second_cur INTO @holder_id
            WHILE @@FETCH_STATUS = 0
                BEGIN
					SELECT * FROM Contract WHERE holder_id = @holder_id
                    FETCH NEXT FROM second_cur INTO @holder_id
                END
	    CLOSE second_cur
	    DEALLOCATE second_cur
    END
DROP PROCEDURE holder_info

EXEC holder_info 3

SELECT * FROM Contract


-- 3. посчитать выручку за заданный период
CREATE PROCEDURE count_money @date_begin DATE, @date_end DATE, @money_out INT OUTPUT
AS
SELECT @money_out = SUM(cost) FROM Contract WHERE
(date_end IS NOT NULL AND date_end<=@date_end
                      AND date_end>=@date_begin
                      AND date_begin>=@date_begin
					  AND date_begin<=@date_end) OR (date_end IS NULL AND date_begin>=@date_begin
					                                                  AND date_begin<=@date_end)
DROP PROCEDURE count_money

DECLARE @money_out INT;
EXEC count_money '01.01.2020', '31.12.2020', @money_out OUTPUT
SELECT @money_out AS period_money

SELECT * FROM Contract


-- 4. вывести информацию о домах владельца по его фи
CREATE PROCEDURE holder_houses @name VARCHAR(255), @surname VARCHAR(255)
AS
	BEGIN
		SELECT * FROM House WHERE holder_id = (SELECT id FROM Holder
					                            WHERE holder_name = @name AND holder_surname = @surname)
	END
DROP PROCEDURE holder_houses

EXEC holder_houses 'Дарья', 'Соколова'

SELECT * FROM House
SELECT * FROM Holder


-- 5. посчитать количество проданных квартир на какую-то дату
CREATE PROCEDURE flats @date DATE
AS
BEGIN
	--DECLARE five_cur CURSOR FOR
        --SELECT date_begin
        --FROM Contract WHERE date_begin >= @date

        --OPEN five_cur
            --FETCH NEXT FROM five_cur INTO @date
            --WHILE @@FETCH_STATUS = 0
				--BEGIN
					SELECT COUNT(id) AS num FROM Contract
					WHERE date_begin >= @date AND flat_id IS NOT NULL AND rental_type = 1
				--END
	    --CLOSE five_cur
	    --DEALLOCATE five_cur
END
DROP PROCEDURE flats

EXEC flats '01.01.2020'

SELECT * FROM Contract