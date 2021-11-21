IF OBJECT_ID('DecisionsConfig') IS NULL
CREATE TABLE DecisionsConfig (
	DecisionsConfigId INT IDENTITY(1,1) PRIMARY KEY,
	OrdersCountDecision NUMERIC(10,4),
	LastDecisionBarDecision NUMERIC(10,4),
	MinLotsMarginDecision NUMERIC(10,4),
	SpreadDecision NUMERIC(10,4),
	FullProcentualProfitDecision NUMERIC(10,4),
	PositiveOrdersCountDecision NUMERIC(10,4),
	BestSumProfitDecision NUMERIC(10,4),
	VolumeDecision NUMERIC(10,4),
	BarsPerOrdersDecision NUMERIC(10,4)
);
ELSE
UPDATE STATISTICS DecisionsConfig
GO

