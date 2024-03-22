/*

SET statistics TIME ON
SET statistics io ON

DROP TABLE IF EXISTS Help

CREATE TABLE [Help] (
	[id] INT NOT NULL,
	[help_string] VARCHAR(255) NOT NULL,
	[help_int] INT NOT NULL,
	[help_float] FLOAT NOT NULL,
);

*/

SELECT * 
FROM Clients AS Cl
LEFT JOIN Lockers AS Lock
ON CL.ID_client = Lock.ID_client

