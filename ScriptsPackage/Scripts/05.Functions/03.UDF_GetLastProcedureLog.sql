IF OBJECT_ID('UDF_GetLastProcedureLog') IS NOT NULL
	DROP FUNCTION UDF_GetLastProcedureLog;
GO
CREATE FUNCTION UDF_GetLastProcedureLog(@SessionName VARCHAR(8000), @Name VARCHAR(250))
RETURNS INT
AS
BEGIN
	RETURN (
		SELECT max(ProcedureLogId)
		FROM ProcedureLog
		WHERE Name = @Name
			AND SessionId = dbo.UDF_GetLastSession(@SessionName)
	);
END
GO
