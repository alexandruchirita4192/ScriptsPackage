IF NOT EXISTS(SELECT 1 FROM DatabaseVersion WHERE VersionNumber = CAST(CAST(CONTEXT_INFO() AS BINARY(8)) AS INT))
	OR NOT EXISTS(
		SELECT 1 FROM DataLog dl
			JOIN TradingSession ts ON ts.SessionId = dl.SessionId
		WHERE dl.Name = 'DefaultDataLog'
			AND ts.Name = 'DefaultSession'
	)
BEGIN
	-- DELETE existing data to be able to INSERT it (used IF VersionNumber IS old)
	IF OBJECT_ID('DataLogDetail') IS NOT NULL
		DELETE dld
		FROM DataLogDetail dld
			JOIN DataLog dl ON dl.DataLogId = dld.DataLogId
			JOIN TradingSession ts ON ts.SessionId = dl.SessionId
		WHERE dld.Name = 'DefaultDataLogDetail'
			AND dl.Name = 'DefaultDataLog'
			AND ts.Name = 'DefaultSession'

	DELETE dl FROM DataLog dl
		JOIN TradingSession ts ON ts.SessionId = dl.SessionId
	WHERE dl.Name = 'DefaultDataLog'
		AND ts.Name = 'DefaultSession'

	-- INSERT DEFAULT data (for invented "NOPNOP" symbol)
	INSERT INTO DataLog(Name, Data, LogTime, SessionId)
	SELECT 'DefaultDataLog', '-*-.lt;SerializedData AccountCompany-_-."SimpleFX Ltd." AccountServer-_-."SimpleFX-DemoUK" AccountNumber-_-."180437" AccountClientName-_-."alexandru.chirita4192" AccountCurrency-_-."BIT" Symbol-_-."NOPNOP" Period-_-."PERIOD_H1" PeriodStartTime-_-."2016.09.02 06:00" PeriodEndTime-_-."2017.02.13 21:00" Bars-_-."2789" Spread-_-."0.0002" SpreadPips-_-."200.0000" Volatility-_-."0.0000" VolatilityPips-_-."0.0000" DecisionName-_-."DecisionDoubleBB" TransactionName-_-."BaseTransactionManagement" LotName-_-."BaseLotManagement" OrdersCount-_-."60" MinLots-_-."0.0100" MinLotsMargin-_-."1567.2797" LastDecisionBar-_-."2761" LastDecisionTime-_-."2017.02.13 18:00" LastDecisionType-_-."buy" /-*-.gt;', GETDATE(), ts.SessionId
	FROM TradingSession ts
	WHERE ts.Name = 'DefaultSession'
END
GO
