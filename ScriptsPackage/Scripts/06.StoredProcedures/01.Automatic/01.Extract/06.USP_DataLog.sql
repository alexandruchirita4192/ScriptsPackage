IF OBJECT_ID('USP_DataLog') IS NOT NULL
	DROP PROCEDURE USP_DataLog;
GO
CREATE PROCEDURE USP_DataLog(@SessionName VARCHAR(8000), @Name VARCHAR(250), @Data VARCHAR(8000))
AS
BEGIN
	INSERT INTO DataLog(LogTime, Name, Data, SessionId)
	SELECT GETDATE(), @Name, @Data, dbo.UDF_GetLastSession(@SessionName)
END
GO
