IF OBJECT_ID('USP_GetValidTradingSessionsAndQueries') IS NOT NULL
	DROP PROCEDURE USP_GetValidTradingSessionsAndQueries;
GO
CREATE PROCEDURE USP_GetValidTradingSessionsAndQueries
AS
BEGIN
	SELECT ts.*, COUNT(*) AS [COUNT]
	FROM TradingSession ts
		JOIN DataLog dl ON dl.SessionId = ts.SessionId
		JOIN DataLogDetail dld ON dld.DataLogId = dl.DataLogId
	WHERE ts.Name IN ('DefaultSession', 'TestSimulateTranSystem.mq4', 'TestSimulateTranSystemOneSymbol.mq4', 'SystemProcessor.mq4')
	GROUP BY ts.SessionId, ts.StartTime, ts.EndTime, ts.Name
	ORDER BY [COUNT] DESC, ts.StartTime DESC
	
	-- Sadly it IS the same query AS before, WITH a little change
	DECLARE @SessionId INT
	SELECT TOP 1 @SessionId = ts.SessionId
	FROM TradingSession ts
		JOIN DataLog dl ON dl.SessionId = ts.SessionId
		JOIN DataLogDetail dld ON dld.DataLogId = dl.DataLogId
	WHERE ts.Name IN ('DefaultSession', 'TestSimulateTranSystem.mq4', 'TestSimulateTranSystemOneSymbol.mq4', 'SystemProcessor.mq4')
	GROUP BY ts.SessionId, ts.StartTime, ts.EndTime, ts.Name
	ORDER BY COUNT(*) DESC, ts.StartTime DESC
	
	SELECT 'EXEC USP_GetResultsFromSessionId ' + ISNULL(CAST(@SessionId AS VARCHAR(100)),'NULL') AS SqlQueriesForBestTradingSession
	UNION ALL
	SELECT 'EXEC USP_ValidateData'
	UNION ALL
	SELECT 'SELECT * FROM MetatraderResults ORDER BY OrderNo'
END
GO
