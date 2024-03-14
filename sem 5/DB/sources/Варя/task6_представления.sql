-- задание 1
ALTER VIEW AddressView
WITH ENCRYPTION
AS SELECT * FROM Address

SELECT * FROM Address
SELECT * FROM AddressView
exec sp_helptext 'AddressView'


-- задание 2
SELECT * FROM ContractView
SELECT * FROM Contract
-- DROP VIEW ContractView

CREATE VIEW ContractView AS
SELECT * FROM Contract
WHERE holder_id > 0
      AND realtor_id > 0
      AND buyer_id > 0
	  AND (flat_id > 0 OR flat_id IS NULL)
	  AND (house_id > 0 OR house_id IS NULL)
	  AND contract_num > 0
	  AND (rental_type = 0 OR rental_type = 1)
	  AND cost > 0
	  AND (date_begin > '01-01-1980')
	  AND (date_end > '01-01-1980' OR date_end IS NULL)
	  AND (is_archived IS NULL)
WITH CHECK OPTION

-- будет добавлено
INSERT INTO ContractView VALUES (16, 5, 3, 7, 4, NULL, 16, 1, 10000000, '2020-03-04', NULL, NULL)
DELETE FROM ContractView WHERE id = 16
-- не будет добавлено
INSERT INTO ContractView VALUES (16, 0, 3, 7, 4, NULL, 16, 1, 10000000, '2020-03-04', NULL, NULL)


-- задание 3
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL,
    ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

SELECT * FROM Help
SELECT * FROM HelpView
-- DROP VIEW HelpView

CREATE VIEW HelpView
WITH SCHEMABINDING
AS SELECT id, help_string, help_int, help_float FROM dbo.Help

CREATE UNIQUE CLUSTERED INDEX ind ON HelpView (help_string, help_int, help_float)
-- DROP INDEX ind ON HelpView

-- без noexpand
SELECT * FROM HelpView
WHERE id = 8 AND help_string = 'Wood'

-- с noexpand
SELECT * FROM HelpView WITH (NOEXPAND)
WHERE id = 8 AND help_string = 'Wood'