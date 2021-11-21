IF OBJECT_ID('vwInitialAggregateDetails') IS NOT NULL
	DROP VIEW vwInitialAggregateDetails;
GO
CREATE VIEW vwInitialAggregateDetails
AS
SELECT
	t.DataLogId,
	t.DataLogName,

	-- DataLogData XML "unpacked" data
	t.DataLogData_AccountCompany AS AccountCompany,
	t.DataLogData_AccountServer AS AccountServer,
	t.DataLogData_AccountNumber AS AccountNumber,
	t.DataLogData_AccountClientName AS AccountClientName,
	t.DataLogData_AccountCurrency AS AccountCurrency,
	t.DataLogData_Symbol AS Symbol,
	t.DataLogData_Period AS Period,
	t.DataLogData_DecisionName AS DecisionName,
	t.DataLogData_TransactionName AS TransactionName,
	t.DataLogData_LotName AS LotName,
	
	t.DataLogData_Volume AS Volume,
	t.DataLogData_Spread AS Spread,
	t.DataLogData_SpreadPips AS SpreadPips,
	t.DataLogData_Bars AS Bars,
	t.DataLogData_LastDecisionBar AS LastDecisionBar,
	t.DataLogData_LastDecisionTime AS LastDecisionTime,
	t.DataLogData_LastDecisionType AS LastDecisionType,
	max(t.DataLogDetailTime) AS LastOrderTime,
	t.DataLogData_PeriodStartTime AS PeriodStartTime,
	t.DataLogData_PeriodEndTime AS PeriodEndTime,
	SUM(t.DataLogData_OrdersCount) AS OrdersCount,
	t.DataLogData_MinLots AS MinLots,
	t.DataLogData_MinLotsMargin AS MinLotsMargin,
	--t.DataLogTime,
	--t.DataLogDetailId,
		
	-- DataLogDetail XML "unpacked" data for "SimulatedOrder/BaseSimulatedOrder"
	AVG(t.DataLogDetail_Lots) AS AvgLots,
	SUM(t.DataLogDetail_Lots) AS SumLots,
	--t.DataLogDetail_OpenPrice,
	--t.DataLogDetail_InverseOpenPrice,
		
	-- DataLogDetail XML "unpacked" data for "SimulatedOrder/BaseSimulatedOrder/TransactionData" - this ~will~ (sadly) give duplicates
	SUM(t.DataLogDetail_TranData_Profit) AS SumProfit,
	SUM(t.DataLogDetail_TranData_InverseProfit) AS SumInverseProfit,
	AVG(t.DataLogDetail_TranData_TakeProfit) AS AvgTakeProfit,
	AVG(t.DataLogDetail_TranData_StopLoss) AS AvgStopLoss,
	AVG(t.DataLogDetail_TranData_StopLossPips) AS AvgStopLossPips,
	AVG(t.DataLogDetail_TranData_TakeProfitPips) AS AvgTakeProfitPips,
	SUM(CAST(t.DataLogDetail_TranData_OrderIsClosed AS INT)) AS SumOrderIsClosed,
	--t.DataLogDetail_TranData_ClosePrice,
	--t.DataLogDetail_TranData_OrderCloseTime,
	SUM(CAST(t.DataLogDetail_TranData_OrderClosedByStopLoss AS INT)) AS SumOrderClosedByStopLoss,
	SUM(CAST(t.DataLogDetail_TranData_OrderClosedByTakeProfit AS INT)) AS SumOrderClosedByTakeProfit,

	SUM(CAST(CASE WHEN t.DataLogDetail_TranData_Profit > 0 THEN 1 ELSE 0 END AS INT)) AS SumOrderProfitable,
	SUM(CAST(CASE WHEN t.DataLogDetail_TranData_InverseProfit > 0 THEN 1 ELSE 0 END AS INT)) AS SumInverseOrderProfitable,

	--t.DataLogDetailTime, -- IS used up
	--t.DataLogDetailName,
	t.SessionId,
		
	-- Computed stuff
	SUM(CASE WHEN t.DataLogDetail_TranData_Profit > 0 THEN 1 ELSE 0 END)/SUM(1) AS ProcentualProfit, -- profitable/ALL
	SUM(CASE WHEN t.DataLogDetail_TranData_InverseProfit > 0 THEN 1 ELSE 0 END)/SUM(1) AS InverseProcentualProfit, -- (inverse)profitable/ALL
	--SUM(CAST(t.DataLogDetail_TranData_OrderClosedByTakeProfit AS NUMERIC(24,8)))/SUM(CAST(t.DataLogDetail_TranData_OrderIsClosed AS NUMERIC(24,8))) AS ProcentualProfit,
	--SUM(CAST(t.DataLogDetail_TranData_InverseOrderClosedByTakeProfit AS NUMERIC(24,8)))/SUM(CAST(t.DataLogDetail_TranData_OrderIsClosed AS NUMERIC(24,8))) AS InverseProcentualProfit,
	CASE WHEN SUM(t.DataLogDetail_TranData_Profit) > SUM(t.DataLogDetail_TranData_InverseProfit) THEN CAST(0 AS bit) ELSE CAST(1 AS bit) END AS IsInverseDecision,
	SUM(CAST(CASE WHEN t.DataLogDetail_TranData_OrderIsClosed = 1 THEN 0 ELSE 1 END AS INT)) AS SumNotClosedOrders

FROM DataAndDetails t

-- we need data to do something; exclude no details rows
WHERE DataLogDetailId IS NOT NULL
	AND DataLogDetail_Lots IS NOT NULL
	--AND DataLogDetail_TranData_Profit IS NOT NULL
	--AND DataLogDetail_TranData_InverseProfit IS NOT NULL
	--AND DataLogDetail_TranData_TakeProfit IS NOT NULL
	--AND DataLogDetail_TranData_StopLoss IS NOT NULL

GROUP BY
	t.DataLogId,
	t.DataLogName,

	-- DataLogData XML "unpacked" data
	t.DataLogData_AccountCompany,
	t.DataLogData_AccountServer,
	t.DataLogData_AccountNumber,
	t.DataLogData_AccountClientName,
	t.DataLogData_AccountCurrency,
	t.DataLogData_Symbol,
	t.DataLogData_Period,
	t.DataLogData_DecisionName,
	t.DataLogData_TransactionName,
	t.DataLogData_LotName,
	t.DataLogData_Spread,
	t.DataLogData_Volume,
	t.DataLogData_SpreadPips,
	t.DataLogData_Bars,
	t.DataLogData_LastDecisionBar,
	t.DataLogData_LastDecisionTime,
	t.DataLogData_LastDecisionType,
	t.DataLogData_PeriodStartTime,
	t.DataLogData_PeriodEndTime,
	--t.DataLogData_OrdersCount,
	t.DataLogData_MinLots,
	t.DataLogData_MinLotsMargin,
	--t.DataLogTime,
	--t.DataLogDetailId,
		
	-- DataLogDetail XML "unpacked" data for "SimulatedOrder/BaseSimulatedOrder"
	--t.DataLogDetail_Lots,
	--t.DataLogDetail_OpenPrice,
	--t.DataLogDetail_InverseOpenPrice,
		
	-- DataLogDetail XML "unpacked" data for "SimulatedOrder/BaseSimulatedOrder/TransactionData" - this ~will~ (sadly) give duplicates
	--SUM(t.DataLogDetail_TranData_Profit) AS SumProfit,
	--SUM(t.DataLogDetail_TranData_InverseProfit) AS SumInverseProfit,
	--t.DataLogDetail_TranData_TakeProfit,
	--t.DataLogDetail_TranData_StopLoss,
	--SUM(t.DataLogDetail_TranData_OrderIsClosed) AS SumOrderIsClosed,
	--t.DataLogDetail_TranData_ClosePrice,
	--t.DataLogDetail_TranData_OrderCloseTime,
	--SUM(t.DataLogDetail_TranData_OrderClosedByStopLoss) AS SumOrderClosedByStopLoss,
	--SUM(t.DataLogDetail_OrderClosedByTakeProfit) AS SumOrderClosedByTakeProfit,

	--t.DataLogDetailTime,
	--t.DataLogDetailName,
	t.SessionId
GO


IF OBJECT_ID('InitialAggregateDetails') IS NOT NULL
	DROP TABLE InitialAggregateDetails
GO -- USP_GetAggregatesFromDetails
SELECT t.*
INTO InitialAggregateDetails
FROM vwInitialAggregateDetails t
	JOIN TradingSession ts ON ts.SessionId = t.SessionId
WHERE ts.Name = 'DefaultSession'
GO
