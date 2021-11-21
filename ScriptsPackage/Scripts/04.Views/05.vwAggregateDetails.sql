IF OBJECT_ID('vwAggregateDetails') IS NOT NULL
	DROP VIEW vwAggregateDetails;
GO
CREATE VIEW vwAggregateDetails
AS
SELECT
	t.DataLogName,
	t.AccountCompany,
	t.AccountServer,
	t.AccountNumber,
	t.AccountClientName,
	t.AccountCurrency,
	t.Symbol,
	t.Period,
	t.DecisionName,
	t.TransactionName,
	t.LotName,
	SUM(t.OrdersCount) AS OrdersCount,
	t.MinLots,
	t.MinLotsMargin,
	t.AvgLots,
	t.MinLotsMargin * (t.AvgLots / t.MinLots) AS AvgLotsMargin, -- AVG risked SUM
	t.MinLotsMargin * (t.SumLots / t.MinLots) AS SumLotsMargin, -- ALL risked SUM
	t.Bars,
	Bars / OrdersCount AS BarsPerOrders,
	t.LastDecisionBar,
	t.LastDecisionTime,
	t.LastDecisionType,
	CASE WHEN t.SumProfit > t.SumInverseProfit THEN t.ProcentualProfit ELSE t.InverseProcentualProfit END AS ProcentualProfitResult,
	SUM(t.SumOrderProfitable) AS PositiveOrdersCount,
	SUM(t.SumInverseOrderProfitable) AS InversePositiveOrdersCount,
	CASE WHEN t.SumProfit > t.SumInverseProfit THEN t.SumProfit ELSE t.SumInverseProfit END AS BestSumProfit, -- ALL profit
	t.SumProfit,
	t.SumInverseProfit,
	t.IsInverseDecision,
	t.AvgTakeProfit,
	t.AvgStopLoss,
	t.AvgTakeProfitPips,
	t.AvgStopLossPips,
	SUM(t.SumOrderIsClosed) AS SumClosedOrders,
	SUM(t.SumNotClosedOrders) AS SumNotClosedOrders,

	-- Decisions
	DENSE_RANK() OVER(ORDER BY t.OrdersCount DESC) AS OrdersCountDecision,
	DENSE_RANK() OVER(ORDER BY t.LastDecisionBar ASC) AS LastDecisionBarDecision,
	DENSE_RANK() OVER(ORDER BY t.MinLotsMargin ASC) AS MinLotsMarginDecision,
	DENSE_RANK() OVER(ORDER BY t.Spread ASC) AS SpreadDecision,
	DENSE_RANK() OVER(ORDER BY CASE WHEN t.SumProfit > t.SumInverseProfit THEN t.ProcentualProfit ELSE t.InverseProcentualProfit END DESC) AS FullProcentualProfitDecision,
	
	DENSE_RANK() OVER(ORDER BY
		CASE
			WHEN SUM(t.SumOrderProfitable) > SUM(t.SumInverseOrderProfitable)
			THEN SUM(t.SumOrderProfitable)
			ELSE SUM(t.SumInverseOrderProfitable)
		END
			DESC) AS PositiveOrdersCountDecision,

	DENSE_RANK() OVER(ORDER BY CASE WHEN t.SumProfit > t.SumInverseProfit THEN t.SumProfit ELSE t.SumInverseProfit END DESC) AS BestSumProfitDecision,
	DENSE_RANK() OVER(ORDER BY t.Volume DESC) AS VolumeDecision,
	DENSE_RANK() OVER(ORDER BY t.Bars / t.OrdersCount ASC) AS BarsPerOrdersDecision

FROM InitialAggregateDetails t

WHERE t.SumOrderIsClosed > 0 -- Exclude no closed orders
	AND t.MinLots <> 0 -- What the MinLots are that? (still need this for "divide BY zero" assurance)
	AND t.OrdersCount <> 0

	-- Exclude 50% PERCENT profit (nothing to get out of it)
	AND t.ProcentualProfit != 0.5
	AND t.InverseProcentualProfit != 0.5

	--AND (
	--	t.ProcentualProfit > 0.9
	--	OR t.InverseProcentualProfit > 0.9
	--)

	---- Get round profit (preferrably 100% vs 0%)
	--AND t.ProcentualProfit + t.InverseProcentualProfit = 1.0

	--	AND CASE WHEN t.SumProfit > t.SumInverseProfit THEN t.SumProfit ELSE t.SumInverseProfit END > 0
	--	AND t.TakeProfitPips > 0

GROUP BY
	t.DataLogName,
	t.AccountCompany,
	t.AccountServer,
	t.AccountNumber,
	t.AccountClientName,
	t.AccountCurrency,
	t.Symbol,
	t.Period,
	t.DecisionName,
	t.TransactionName,
	t.LotName,
	t.Bars,
	t.OrdersCount,
	t.Spread,
	t.Volume,
	t.LastDecisionBar,
	t.LastDecisionTime,
	t.LastDecisionType,
	t.SumProfit,
	t.SumInverseProfit,
	t.ProcentualProfit,
	t.InverseProcentualProfit,
	t.IsInverseDecision,
--	t.OrdersCount,
	t.MinLots,
	t.MinLotsMargin,
	t.AvgLots,
	t.SumLots,
--	t.PositiveOrdersCount,
--	t.NegativeOrdersCount,
	t.AvgTakeProfit,
	t.AvgStopLoss,
	t.AvgTakeProfitPips,
	t.AvgStopLossPips
GO


IF OBJECT_ID('AggregateDetails') IS NOT NULL
	DROP TABLE AggregateDetails
GO -- USP_GetAggregatesFromDetails
SELECT t.*
	, ROW_NUMBER() OVER(
		ORDER BY
			t.OrdersCountDecision +
			t.LastDecisionBarDecision +
			t.MinLotsMarginDecision + 
			t.SpreadDecision +
			t.FullProcentualProfitDecision + 
			t.PositiveOrdersCountDecision +
			t.BestSumProfitDecision +
			t.VolumeDecision +
			t.BarsPerOrdersDecision 
		ASC
	) AS OrderNo
INTO AggregateDetails
FROM vwAggregateDetails t
ORDER BY OrderNo ASC
GO
