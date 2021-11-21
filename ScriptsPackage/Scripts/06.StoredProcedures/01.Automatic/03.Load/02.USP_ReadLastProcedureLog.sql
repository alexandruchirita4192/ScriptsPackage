IF OBJECT_ID('USP_ReadLastProcedureLog') IS NOT NULL
	DROP PROCEDURE USP_ReadLastProcedureLog;
GO
CREATE PROCEDURE USP_ReadLastProcedureLog(@SessionName VARCHAR(8000) = NULL)
AS
BEGIN
	DECLARE @SessionId INT
	SET @SessionId = dbo.UDF_GetLastSession(@SessionName);
	SELECT * FROM ProcedureLog WHERE SessionId = @SessionId
END
GO
