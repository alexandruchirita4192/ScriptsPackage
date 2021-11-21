IF OBJECT_ID('vwResults') IS NOT NULL
	DROP VIEW vwResults;
GO
CREATE VIEW vwResults
AS
SELECT
	OrderNo,
	COUNT(*) AS MaxOrderNo,
	Symbol,
	Period,
	DecisionName,
	TransactionName,
	AccountCompany,
	AccountCurrency,
	LotName,
	MinLots,
	MinLotsMargin,
	AvgLots,
	AvgLotsMargin,
	SumLotsMargin,
	BestSumProfit,
	IsInverseDecision,
	Bars,
	BarsPerOrders,
	LastDecisionBar,
	LastDecisionTime,
	LastDecisionType,
	SUM(SumClosedOrders) AS SumClosedOrders,
	SUM(PositiveOrdersCount) AS PositiveOrdersCount,
	SUM(InversePositiveOrdersCount) AS InversePositiveOrdersCount,
	CAST(AVG(ProcentualProfitResult)*100 AS NUMERIC(10,2)) AS ProcentualProfitResult,
	
	-- Decisions
	OrdersCountDecision,
	LastDecisionBarDecision,
	MinLotsMarginDecision,
	SpreadDecision,
	FullProcentualProfitDecision,
	PositiveOrdersCountDecision,
	BestSumProfitDecision,
	VolumeDecision,
	BarsPerOrdersDecision

FROM AggregateDetails

GROUP BY
	OrderNo,
	Symbol,
	Period,
	DecisionName,
	TransactionName,
	AccountCompany,
	AccountCurrency,
	LotName,
	MinLots,
	MinLotsMargin,
	AvgLots,
	AvgLotsMargin,
	SumLotsMargin,
	BestSumProfit,
	IsInverseDecision,
	Bars,
	LastDecisionBar,
	BarsPerOrders,
	LastDecisionTime,
	LastDecisionType,
	
	-- Decisions
	OrdersCountDecision,
	LastDecisionBarDecision,
	MinLotsMarginDecision,
	SpreadDecision,
	FullProcentualProfitDecision,
	PositiveOrdersCountDecision,
	BestSumProfitDecision,
	VolumeDecision,
	BarsPerOrdersDecision
GO
