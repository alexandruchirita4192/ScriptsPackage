IF OBJECT_ID('USP_EndTradingSession') IS NOT NULL
	DROP PROCEDURE USP_EndTradingSession;
GO
CREATE PROCEDURE USP_EndTradingSession(@Name VARCHAR(8000))
AS
BEGIN
	UPDATE ts
	SET
		ts.EndTime = GETDATE()
	FROM TradingSession ts
	WHERE ts.EndTime IS NULL
		AND ts.Name = @Name
		AND ts.SessionId = dbo.UDF_GetLastSession(NULL)
END
GO
