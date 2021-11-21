IF OBJECT_ID('USP_EndProcedureLog') IS NOT NULL
	DROP PROCEDURE USP_EndProcedureLog;
GO
CREATE PROCEDURE USP_EndProcedureLog(@SessionName VARCHAR(8000), @Name VARCHAR(250))
AS
BEGIN
	UPDATE pl
	SET
		pl.EndTime = GETDATE()
	FROM ProcedureLog pl
	WHERE pl.EndTime IS NULL
		AND pl.Name LIKE @Name + '%'
		AND pl.SessionId = dbo.UDF_GetLastSession(@SessionName)
END
GO
