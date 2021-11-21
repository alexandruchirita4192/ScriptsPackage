IF NOT EXISTS(SELECT 1 FROM TradingSession ts WHERE ts.Name = 'DefaultSession')
BEGIN
	INSERT INTO TradingSession(Name, StartTime, EndTime)
	SELECT 'DefaultSession', GETDATE(), GETDATE()
END
GO
