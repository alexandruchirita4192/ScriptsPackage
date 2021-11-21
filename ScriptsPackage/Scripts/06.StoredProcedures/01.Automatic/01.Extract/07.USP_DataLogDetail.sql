IF OBJECT_ID('USP_DataLogDetail') IS NOT NULL
	DROP PROCEDURE USP_DataLogDetail;
GO
CREATE PROCEDURE USP_DataLogDetail(@SessionName VARCHAR(8000), @Name VARCHAR(250), @Detail VARCHAR(8000))
AS
BEGIN
	INSERT INTO DataLogDetail(LogTime, Name, Detail, DataLogId)
	SELECT GETDATE(), @Name, @Detail, dbo.UDF_GetLastDataLog(@SessionName)
END
GO
