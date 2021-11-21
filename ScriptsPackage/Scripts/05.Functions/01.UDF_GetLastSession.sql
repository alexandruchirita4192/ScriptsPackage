IF OBJECT_ID('UDF_GetLastSession') IS NOT NULL
	DROP FUNCTION UDF_GetLastSession;
GO
CREATE FUNCTION UDF_GetLastSession(@SessionName VARCHAR(8000) = NULL)
RETURNS INT
AS
BEGIN
	IF @SessionName IS NULL
		RETURN (SELECT max(SessionId) FROM TradingSession);
	RETURN (SELECT max(SessionId) FROM TradingSession WHERE Name = @SessionName);
END
GO
