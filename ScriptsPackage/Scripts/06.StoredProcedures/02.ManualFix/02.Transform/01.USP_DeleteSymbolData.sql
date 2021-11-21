IF OBJECT_ID('USP_DeleteSymbolData') IS NOT NULL
	DROP PROCEDURE USP_DeleteSymbolData;
GO
CREATE PROCEDURE USP_DeleteSymbolData(@SessionName VARCHAR(8000) = NULL, @SymbolName VARCHAR(8000) = NULL)
AS
BEGIN
	DECLARE @LastSessionId INT, @DefaultSessionId INT, @DefaultDataLogId INT
	SELECT TOP 1 @DefaultSessionId = SessionId FROM TradingSession WHERE Name = 'DefaultSession'
	SELECT TOP 1 @DefaultDataLogId = DataLogId FROM DataLog WHERE SessionId = @DefaultSessionId
	
	IF(@SessionName IS NULL)
		SELECT TOP 1 @LastSessionId = ts.SessionId FROM TradingSession ts WHERE ts.SessionId <> @DefaultSessionId ORDER BY ts.SessionId DESC
	ELSE
		SELECT TOP 1 @LastSessionId = ts.SessionId FROM TradingSession ts WHERE ts.Name = @SessionName AND ts.SessionId <> @DefaultSessionId ORDER BY ts.SessionId DESC
	
	IF(@SymbolName IS NULL)
	BEGIN
		DELETE dld FROM DataLogDetail dld
			JOIN DataLog dl ON dl.DataLogId = dld.DataLogId
		WHERE dl.SessionId = @LastSessionId
			AND dl.DataLogId <> @DefaultDataLogId

		DELETE dl FROM DataLog dl
		WHERE dl.SessionId = @LastSessionId
			AND dl.DataLogId <> @DefaultDataLogId
	END
	ELSE
	BEGIN
		DELETE dld FROM DataLogDetail dld JOIN DataLog dl ON dl.DataLogId = dld.DataLogId WHERE dl.SessionId = @LastSessionId
			AND dl.Name LIKE '% ON ' + @SymbolName + ' AND period %'
			AND dl.DataLogId <> @DefaultDataLogId
		DELETE dl FROM DataLog dl WHERE dl.SessionId = @LastSessionId
			AND dl.Name LIKE '% ON ' + @SymbolName + ' AND period %'
			AND dl.DataLogId <> @DefaultDataLogId
	END
END
GO
