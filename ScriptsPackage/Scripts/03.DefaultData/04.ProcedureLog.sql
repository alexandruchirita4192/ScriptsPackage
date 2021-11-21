IF NOT EXISTS(
	SELECT 1 FROM ProcedureLog pl
		JOIN TradingSession ts ON ts.SessionId = pl.SessionId
	WHERE pl.Name = 'DefaultProcedureLog'
		AND ts.Name = 'DefaultSession'
)
BEGIN
	INSERT INTO ProcedureLog(Name, ParamsToString, StartTime, EndTime, SessionId)
	SELECT 'DefaultProcedureLog', 'DefaultParamsToString', GETDATE(), GETDATE(), ts.SessionId
	FROM TradingSession ts
	WHERE ts.Name = 'DefaultSession'
END
GO
