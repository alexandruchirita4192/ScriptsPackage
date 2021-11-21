IF OBJECT_ID('USP_StartProcedureLog') IS NOT NULL
	DROP PROCEDURE USP_StartProcedureLog;
GO
CREATE PROCEDURE USP_StartProcedureLog(@SessionName VARCHAR(8000), @Name VARCHAR(250), @ParamsToString VARCHAR(1000))
AS
BEGIN
	INSERT INTO ProcedureLog(StartTime, Name, ParamsToString, SessionId)
	SELECT GETDATE(), @Name, @ParamsToString, dbo.UDF_GetLastSession(@SessionName)
END
GO
