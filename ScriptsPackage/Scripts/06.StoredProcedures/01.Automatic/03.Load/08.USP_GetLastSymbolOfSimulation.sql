IF OBJECT_ID('USP_GetLastSymbolOfSimulation') IS NOT NULL
	DROP PROCEDURE USP_GetLastSymbolOfSimulation;
GO
CREATE PROCEDURE USP_GetLastSymbolOfSimulation (
	@TradingSessionName VARCHAR(1000) = 'SystemProcessor.mq4'
)
AS
BEGIN 
	SELECT Symbol
	FROM (
		SELECT DISTINCT t.DataLogId, t.DataLogData.value('(SerializedData/@Symbol)[1]', 'VARCHAR(100)') AS Symbol, ROW_NUMBER() OVER (ORDER BY DataLogId DESC) AS rn
		FROM vwDataToXml t
			JOIN TradingSession ts ON ts.SessionId = t.SessionId
				AND ts.EndTime IS NULL
		WHERE t.SessionId = dbo.UDF_GetLastSession(@TradingSessionName)
	) t
	WHERE t.rn = 1
END
GO
