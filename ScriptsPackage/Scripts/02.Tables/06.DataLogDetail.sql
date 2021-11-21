IF OBJECT_ID('DataLogDetail') IS NULL
CREATE TABLE DataLogDetail (
	DataLogDetailId INT IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(250),
	Detail VARCHAR(8000),
	LogTime DATETIME,
	DataLogId INT,
	CONSTRAINT FK_DataLogDetail_DataLogId FOREIGN KEY (DataLogId) REFERENCES DataLog(DataLogId)
);
ELSE
UPDATE STATISTICS DataLogDetail
GO


IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IDX_DataLogDetail_DataLogId')
CREATE NONCLUSTERED INDEX IDX_DataLogDetail_DataLogId ON [dbo].[DataLogDetail] ([DataLogId]) INCLUDE ([DataLogDetailId],[Name],[Detail],[LogTime])
GO
