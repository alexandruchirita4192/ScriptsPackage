-- vwTradingSession is an optional view
IF OBJECT_ID('vwTradingSession') IS NOT NULL
	DROP VIEW vwTradingSession;
GO
CREATE VIEW vwTradingSession
AS
SELECT ts.SessionId,
	ts.StartTime,
	ts.EndTime,
	ts.Name,
	DATEDIFF(MINUTE, ts.StartTime, ts.EndTime) AS RunMinutes
FROM TradingSession ts
GO
