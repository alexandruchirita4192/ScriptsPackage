IF OBJECT_ID('UDF_GetLastDataLog') IS NOT NULL
	DROP FUNCTION UDF_GetLastDataLog;
GO
CREATE FUNCTION UDF_GetLastDataLog(@SessionName VARCHAR(8000) = NULL)
RETURNS INT
AS
BEGIN
	IF @SessionName IS NULL
		RETURN (SELECT max(DataLogId) FROM DataLog);
	RETURN (SELECT max(DataLogId) FROM DataLog WHERE SessionId = dbo.UDF_GetLastSession(@SessionName));
END
GO
