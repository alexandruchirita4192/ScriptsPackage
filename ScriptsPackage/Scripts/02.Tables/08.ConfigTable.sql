IF OBJECT_ID('ConfigTable') IS NULL
CREATE TABLE ConfigTable (
	ConfigTableId INT IDENTITY(1,1) PRIMARY KEY,
	Config VARCHAR(200),
	Value VARCHAR(max)
);
ELSE
UPDATE STATISTICS ConfigTable
GO

