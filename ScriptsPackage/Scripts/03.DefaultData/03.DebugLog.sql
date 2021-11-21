IF NOT EXISTS(
	SELECT 1 FROM DebugLog dl
		JOIN TradingSession ts ON ts.SessionId = dl.SessionId
	WHERE dl.DebugData = 'DefaultDebug'
		AND ts.Name = 'DefaultSession'
)
BEGIN
	INSERT INTO DebugLog(DebugData, DebugTime, SessionId)
	SELECT 'DefaultDebug', GETDATE(), ts.SessionId
	FROM TradingSession ts
	WHERE ts.Name = 'DefaultSession'
END
GO
