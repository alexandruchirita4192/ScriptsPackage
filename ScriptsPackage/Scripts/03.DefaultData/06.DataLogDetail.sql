IF NOT EXISTS(
	SELECT 1 FROM DataLogDetail dld
		JOIN DataLog dl ON dl.DataLogId = dld.DataLogId
		JOIN TradingSession ts ON ts.SessionId = dl.SessionId
	WHERE dld.Name = 'DefaultDataLogDetail'
		AND dl.Name = 'DefaultDataLog'
		AND ts.Name = 'DefaultSession'
)
BEGIN
	INSERT INTO DataLogDetail(Name, Detail, LogTime, DataLogId)
	SELECT 'DefaultDataLogDetail', '-*-.lt;SimulatedOrder-*-.gt;-*-.lt;BaseSimulatedOrder Lots-_-."100.00000000" OpenPrice-_-."8.5830" InverseOpenPrice-_-."8.5830" DecisionType-_-."4" BuyDecisionType-_-."4" SellDecisionType-_-."4" UninitializedProfit-_-."true"-*-.gt;-*-.lt;TransactionData Profit-_-."0.0000" InverseProfit-_-."0.0000" TakeProfit-_-."8.58297000" StopLoss-_-."8.58297100" InverseTakeProfit-_-."0.00001000" InverseStopLoss-_-."0.00000000" TakeProfitPips-_-."0.00000000" StopLossPips-_-."-1.00000000" OrderIsClosed-_-."true" InverseOrderIsClosed-_-."true" ClosePrice-_-."8.58297000" InverseClosePrice-_-."8.58297000" OrderCloseTime-_-."2013.02.03 00:00" InverseOrderCloseTime-_-."2013.02.03 00:00" OrderClosedByStopLoss-_-."true" OrderClosedByTakeProfit-_-."true" InverseOrderClosedByStopLoss-_-."true" InverseOrderClosedByTakeProfit-_-."false" /-*-.gt; -*-.lt;/BaseSimulatedOrder-*-.gt;-*-.lt;/SimulatedOrder-*-.gt;', GETDATE(), dl.DataLogId
	FROM DataLog dl
		JOIN TradingSession ts ON ts.SessionId = dl.SessionId
	WHERE dl.Name = 'DefaultDataLog'
		AND ts.Name = 'DefaultSession'
END
GO
