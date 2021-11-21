IF OBJECT_ID('DatabaseVersion') IS NULL
CREATE TABLE DatabaseVersion (
	DatabaseVersionId INT IDENTITY(1,1) PRIMARY KEY,
	UpdateDate DATETIME,
	VersionNumber INT
);
ELSE
UPDATE STATISTICS DatabaseVersion
GO