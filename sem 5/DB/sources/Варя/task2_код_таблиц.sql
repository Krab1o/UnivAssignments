DROP TABLE IF EXISTS Contract
DROP TABLE IF EXISTS Rent
DROP TABLE IF EXISTS Buying
DROP TABLE IF EXISTS House
DROP TABLE IF EXISTS Flat
DROP TABLE IF EXISTS Address
DROP TABLE IF EXISTS Realtor
DROP TABLE IF EXISTS Buyer
DROP TABLE IF EXISTS Holder


CREATE TABLE [House] (
	[id] INT NOT NULL,
	[holder_id] INT NOT NULL,
	[address_id] INT NOT NULL,
	[has_open_space] INT NOT NULL,
	[num_of_floors] INT NOT NULL,
	[land_area] FLOAT NOT NULL,
	[live_square] FLOAT NOT NULL,
	[square] FLOAT NOT NULL,
	[is_redecorated] FLOAT NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Flat] (
	[id] INT NOT NULL,
	[holder_id] INT NOT NULL,
	[address_id] INT NOT NULL,
	[floor] INT NOT NULL,
	[flat_num] INT NOT NULL,
	[num_of_rooms] INT NOT NULL,
	[live_square] FLOAT NOT NULL,
	[square] FLOAT NOT NULL,
	[is_redecorated] INT NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Holder] (
	[id] INT NOT NULL,
	[holder_surname] VARCHAR(255) NOT NULL,
	[holder_name] VARCHAR(255) NOT NULL,
	[holder_phone] VARCHAR(255) NOT NULL,
	[holder_email] VARCHAR(255) NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Address] (
	[id] INT NOT NULL,
	[city] VARCHAR(255) NOT NULL,
	[street] VARCHAR(255) NOT NULL,
	[house_num] VARCHAR(255) NOT NULL,
	[num_of_floors] INT NOT NULL,
	[construction_year] INT NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Realtor] (
	[id] INT NOT NULL,
	[realtor_surname] VARCHAR(255) NOT NULL,
	[realtor_name] VARCHAR(255) NOT NULL,
	[realtor_phone] VARCHAR(255) NOT NULL,
	[realtor_email] VARCHAR(255) NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Contract] (
	[id] INT NOT NULL,
	[holder_id] INT NOT NULL,
	[realtor_id] INT NOT NULL,
	[buyer_id] INT NOT NULL,
	[flat_id] INT,
	[house_id] INT,
	[contract_num] INT NOT NULL,
	[rental_type] INT NOT NULL,
	[cost] INT NOT NULL,
	[date_begin] DATE NOT NULL,
	[date_end] DATE,
	PRIMARY KEY ([id])
);

CREATE TABLE [Buying] (
	[id] INT NOT NULL,
	[realtor_id] INT NOT NULL,
	[flat_id] INT,
	[house_id] INT,
	[date] DATE NOT NULL,
	[cost] INT NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Rent] (
	[id] INT NOT NULL,
	[realtor_id] INT NOT NULL,
	[flat_id] INT,
	[house_id] INT,
	[date_begin] DATE NOT NULL,
	[date_end] DATE NOT NULL,
	[cost] INT NOT NULL,
	[rent_type] INT NOT NULL,
	PRIMARY KEY ([id])
);

CREATE TABLE [Buyer] (
	[id] INT NOT NULL,
	[buyer_surname] VARCHAR(255) NOT NULL,
	[buyer_name] VARCHAR(255) NOT NULL,
	[buyer_phone] VARCHAR(255) NOT NULL,
	[buyer_email] VARCHAR(255) NOT NULL,
	PRIMARY KEY ([id])
);

ALTER TABLE [House] ADD CONSTRAINT [House_fk0] FOREIGN KEY ([holder_id]) REFERENCES [Holder]([id]);

ALTER TABLE [House] ADD CONSTRAINT [House_fk1] FOREIGN KEY ([address_id]) REFERENCES [Address]([id]);

ALTER TABLE [Flat] ADD CONSTRAINT [Flat_fk0] FOREIGN KEY ([holder_id]) REFERENCES [Holder]([id]);

ALTER TABLE [Flat] ADD CONSTRAINT [Flat_fk1] FOREIGN KEY ([address_id]) REFERENCES [Address]([id]);

ALTER TABLE [Contract] ADD CONSTRAINT [Contract_fk0] FOREIGN KEY ([holder_id]) REFERENCES [Holder]([id]);

ALTER TABLE [Contract] ADD CONSTRAINT [Contract_fk1] FOREIGN KEY ([realtor_id]) REFERENCES [Realtor]([id]);

ALTER TABLE [Contract] ADD CONSTRAINT [Contract_fk2] FOREIGN KEY ([buyer_id]) REFERENCES [Buyer]([id]);

ALTER TABLE [Contract] ADD CONSTRAINT [Contract_fk3] FOREIGN KEY ([flat_id]) REFERENCES [Flat]([id]);

ALTER TABLE [Contract] ADD CONSTRAINT [Contract_fk4] FOREIGN KEY ([house_id]) REFERENCES [House]([id]);

ALTER TABLE [Buying] ADD CONSTRAINT [Buying_fk0] FOREIGN KEY ([realtor_id]) REFERENCES [Realtor]([id]);

ALTER TABLE [Buying] ADD CONSTRAINT [Buying_fk1] FOREIGN KEY ([flat_id]) REFERENCES [Flat]([id]);

ALTER TABLE [Buying] ADD CONSTRAINT [Buying_fk2] FOREIGN KEY ([house_id]) REFERENCES [House]([id]);

ALTER TABLE [Rent] ADD CONSTRAINT [Rent_fk0] FOREIGN KEY ([realtor_id]) REFERENCES [Realtor]([id]);

ALTER TABLE [Rent] ADD CONSTRAINT [Rent_fk1] FOREIGN KEY ([flat_id]) REFERENCES [Flat]([id]);

ALTER TABLE [Rent] ADD CONSTRAINT [Rent_fk2] FOREIGN KEY ([house_id]) REFERENCES [House]([id]);