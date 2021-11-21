-- XML extract INTO TABLE (XML from DataLogData & DataLogDetail are transformed to columns)
IF OBJECT_ID('vwXmlExtractIntoTable') IS NOT NULL
	DROP VIEW vwXmlExtractIntoTable;
GO
CREATE VIEW vwXmlExtractIntoTable
AS
SELECT
	t.DataLogId,
	t.DataLogName,

	-- DataLogData XML "unpacked" data
	t.DataLogData.value('(SerializedData/@AccountCompany)[1]', 'VARCHAR(500)') AS DataLogData_AccountCompany,
	t.DataLogData.value('(SerializedData/@AccountServer)[1]', 'VARCHAR(500)') AS DataLogData_AccountServer,
	t.DataLogData.value('(SerializedData/@AccountNumber)[1]', 'BIGINT') AS DataLogData_AccountNumber,
	t.DataLogData.value('(SerializedData/@AccountClientName)[1]', 'VARCHAR(500)') AS DataLogData_AccountClientName,
	t.DataLogData.value('(SerializedData/@AccountCurrency)[1]', 'VARCHAR(10)') AS DataLogData_AccountCurrency,
	t.DataLogData.value('(SerializedData/@Symbol)[1]', 'VARCHAR(100)') AS DataLogData_Symbol,
	t.DataLogData.value('(SerializedData/@Period)[1]', 'VARCHAR(100)') AS DataLogData_Period,
	t.DataLogData.value('(SerializedData/@DecisionName)[1]', 'VARCHAR(1000)') AS DataLogData_DecisionName,
	t.DataLogData.value('(SerializedData/@TransactionName)[1]', 'VARCHAR(1000)') AS DataLogData_TransactionName,
	t.DataLogData.value('(SerializedData/@LotName)[1]', 'VARCHAR(1000)') AS DataLogData_LotName,
	t.DataLogData.value('(SerializedData/@Spread)[1]', 'NUMERIC(20,4)') AS DataLogData_Spread,
	t.DataLogData.value('(SerializedData/@SpreadPips)[1]', 'NUMERIC(20,4)') AS DataLogData_SpreadPips,
	t.DataLogData.value('(SerializedData/@Bars)[1]', 'INT') AS DataLogData_Bars,
	t.DataLogData.value('(SerializedData/@Volume)[1]', 'INT') AS DataLogData_Volume,
	t.DataLogData.value('(SerializedData/@PeriodStartTime)[1]', 'DATETIME') AS DataLogData_PeriodStartTime,
	t.DataLogData.value('(SerializedData/@PeriodEndTime)[1]', 'DATETIME') AS DataLogData_PeriodEndTime,
	t.DataLogData.value('(SerializedData/@OrdersCount)[1]', 'INT') AS DataLogData_OrdersCount,
	t.DataLogData.value('(SerializedData/@MinLots)[1]', 'NUMERIC(20,4)') AS DataLogData_MinLots,
	t.DataLogData.value('(SerializedData/@MinLotsMargin)[1]', 'NUMERIC(20,4)') AS DataLogData_MinLotsMargin,
	t.DataLogData.value('(SerializedData/@LastDecisionBar)[1]', 'INT') AS DataLogData_LastDecisionBar,
	t.DataLogData.value('(SerializedData/@LastDecisionTime)[1]', 'DATETIME') AS DataLogData_LastDecisionTime,
	t.DataLogData.value('(SerializedData/@LastDecisionType)[1]', 'VARCHAR(200)') AS DataLogData_LastDecisionType,
	t.DataLogTime,
	t.DataLogDetailId,

	-- DataLogDetail XML "unpacked" data for "SimulatedOrder/BaseSimulatedOrder"
	DataLogDetail_T.SimulatedOrder.value('(BaseSimulatedOrder/@Lots)[1]', 'NUMERIC(24,8)') AS DataLogDetail_Lots,
	DataLogDetail_T.SimulatedOrder.value('(BaseSimulatedOrder/@OpenPrice)[1]', 'NUMERIC(24,4)') AS DataLogDetail_OpenPrice,
	DataLogDetail_T.SimulatedOrder.value('(BaseSimulatedOrder/@InverseOpenPrice)[1]', 'NUMERIC(24,4)') AS DataLogDetail_InverseOpenPrice,
	
	-- DataLogDetail XML "unpacked" data for "SimulatedOrder/BaseSimulatedOrder/TransactionData" - this ~will~ (sadly) give duplicates
	TransactionData_T.BaseSimulatedOrder.value('(@Profit)', 'NUMERIC(20,8)') AS DataLogDetail_TranData_Profit,
	TransactionData_T.BaseSimulatedOrder.value('(@InverseProfit)', 'NUMERIC(20,8)') AS DataLogDetail_TranData_InverseProfit,
	TransactionData_T.BaseSimulatedOrder.value('(@TakeProfit)', 'NUMERIC(20,8)') AS DataLogDetail_TranData_TakeProfit,
	TransactionData_T.BaseSimulatedOrder.value('(@StopLoss)', 'NUMERIC(20,8)') AS DataLogDetail_TranData_StopLoss,
	TransactionData_T.BaseSimulatedOrder.value('(@InverseTakeProfit)', 'NUMERIC(20,8)') AS DataLogDetail_TranData_InverseTakeProfit,
	TransactionData_T.BaseSimulatedOrder.value('(@InverseStopLoss)', 'NUMERIC(20,8)') AS DataLogDetail_TranData_InverseStopLoss,
	TransactionData_T.BaseSimulatedOrder.value('(@TakeProfitPips)', 'NUMERIC(20,8)') AS DataLogDetail_TranData_TakeProfitPips,
	TransactionData_T.BaseSimulatedOrder.value('(@StopLossPips)', 'NUMERIC(20,8)') AS DataLogDetail_TranData_StopLossPips,
	CAST(CASE TransactionData_T.BaseSimulatedOrder.value('(@OrderIsClosed)', 'VARCHAR(10)') WHEN 'true' THEN 1 WHEN 'false' THEN 0 ELSE NULL END AS bit) AS DataLogDetail_TranData_OrderIsClosed,
	CAST(CASE TransactionData_T.BaseSimulatedOrder.value('(@InverseOrderIsClosed)', 'VARCHAR(10)') WHEN 'true' THEN 1 WHEN 'false' THEN 0 ELSE NULL END AS bit) AS DataLogDetail_TranData_InverseOrderIsClosed,
	TransactionData_T.BaseSimulatedOrder.value('(@ClosePrice)', 'NUMERIC(20,8)') AS DataLogDetail_TranData_ClosePrice,
	TransactionData_T.BaseSimulatedOrder.value('(@InverseClosePrice)', 'NUMERIC(20,8)') AS DataLogDetail_TranData_InverseClosePrice,
	TransactionData_T.BaseSimulatedOrder.value('(@OrderCloseTime)', 'DATETIME') AS DataLogDetail_TranData_OrderCloseTime,
	TransactionData_T.BaseSimulatedOrder.value('(@InverseOrderCloseTime)', 'DATETIME') AS DataLogDetail_TranData_InverseOrderCloseTime,
	CAST(CASE TransactionData_T.BaseSimulatedOrder.value('(@OrderClosedByStopLoss)', 'VARCHAR(10)') WHEN 'true' THEN 1 WHEN 'false' THEN 0 ELSE NULL END AS bit) AS DataLogDetail_TranData_OrderClosedByStopLoss,
	CAST(CASE TransactionData_T.BaseSimulatedOrder.value('(@OrderClosedByTakeProfit)', 'VARCHAR(10)') WHEN 'true' THEN 1 WHEN 'false' THEN 0 ELSE NULL END AS bit) AS DataLogDetail_TranData_OrderClosedByTakeProfit,
	CAST(CASE TransactionData_T.BaseSimulatedOrder.value('(@InverseOrderClosedByStopLoss)', 'VARCHAR(10)') WHEN 'true' THEN 1 WHEN 'false' THEN 0 ELSE NULL END AS bit) AS DataLogDetail_TranData_InverseOrderClosedByStopLoss,
	CAST(CASE TransactionData_T.BaseSimulatedOrder.value('(@InverseOrderClosedByTakeProfit)', 'VARCHAR(10)') WHEN 'true' THEN 1 WHEN 'false' THEN 0 ELSE NULL END AS bit) AS DataLogDetail_TranData_InverseOrderClosedByTakeProfit,

	t.DataLogDetailTime,
	t.DataLogDetailName,
	t.SessionId

FROM XmlDataAndDetails t
	OUTER APPLY t.DataLogDetail.nodes('SimulatedOrder') AS DataLogDetail_T(SimulatedOrder)
	OUTER APPLY DataLogDetail_T.SimulatedOrder.nodes('BaseSimulatedOrder/TransactionData') AS TransactionData_T(BaseSimulatedOrder)
WHERE LEN(t.DataLogData.value('(SerializedData/@Spread)[1]', 'VARCHAR(300)'))<20
	AND LEN(t.DataLogData.value('(SerializedData/@SpreadPips)[1]', 'VARCHAR(300)'))<20
	AND LEN(TransactionData_T.BaseSimulatedOrder.value('(@Profit)', 'VARCHAR(300)'))<20
	AND LEN(TransactionData_T.BaseSimulatedOrder.value('(@InverseProfit)', 'VARCHAR(300)'))<20
	AND LEN(TransactionData_T.BaseSimulatedOrder.value('(@TakeProfit)', 'VARCHAR(300)'))<20
	AND LEN(TransactionData_T.BaseSimulatedOrder.value('(@StopLoss)', 'VARCHAR(300)'))<20
	AND LEN(TransactionData_T.BaseSimulatedOrder.value('(@InverseTakeProfit)', 'VARCHAR(300)'))<20
	AND LEN(TransactionData_T.BaseSimulatedOrder.value('(@InverseStopLoss)', 'VARCHAR(300)'))<20
	AND LEN(TransactionData_T.BaseSimulatedOrder.value('(@TakeProfitPips)', 'VARCHAR(300)'))<20
	AND LEN(TransactionData_T.BaseSimulatedOrder.value('(@StopLossPips)', 'VARCHAR(300)'))<20
	AND LEN(TransactionData_T.BaseSimulatedOrder.value('(@ClosePrice)', 'NUMERIC(20,8)'))<20
	AND LEN(TransactionData_T.BaseSimulatedOrder.value('(@InverseClosePrice)', 'NUMERIC(20,8)'))<20
GO


IF OBJECT_ID('DataAndDetails') IS NOT NULL
	DROP TABLE DataAndDetails
GO -- USP_GetDataAndDetailsFromSessionId
SELECT t.*
INTO DataAndDetails
FROM vwXmlExtractIntoTable t
	JOIN TradingSession ts ON ts.SessionId = t.SessionId
WHERE ts.Name = 'DefaultSession'
GO
