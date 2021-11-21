IF NOT EXISTS(SELECT 1 FROM DecisionsConfig)
BEGIN
	INSERT INTO DecisionsConfig(OrdersCountDecision,LastDecisionBarDecision,MinLotsMarginDecision,
		SpreadDecision,FullProcentualProfitDecision,PositiveOrdersCountDecision,BestSumProfitDecision,
		VolumeDecision,BarsPerOrdersDecision)
	SELECT 1.0, 1.0, 3.0,
		3.0, 4.0, 4.0, 2.0,
		1.0, 2.0
END
GO
