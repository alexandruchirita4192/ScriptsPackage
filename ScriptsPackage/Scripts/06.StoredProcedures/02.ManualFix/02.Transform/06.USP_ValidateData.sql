IF OBJECT_ID('USP_ValidateData') IS NOT NULL
	DROP PROCEDURE USP_ValidateData;
GO
CREATE PROCEDURE USP_ValidateData
AS
BEGIN
	SELECT 'Proper validation of data happens after you run "EXEC USP_GetResultsFromSessionName ''TestSimulateTranSystem.mq4''"' AS HelpMessage
	SELECT 'OR run "EXEC USP_GetValidTradingSessionsAndQueries" for other queries that might help' AS HelpMessage2

	IF EXISTS(SELECT 1 FROM DataAndDetails WHERE DataLogDetailId IS NULL HAVING COUNT(*) > 1)
	SELECT 'DataLogDetailId IS NULL IN DataAndDetails for' AS Warning, COUNT(*) cnt FROM DataAndDetails WHERE DataLogDetailId IS NULL HAVING COUNT(*) > 1

	IF EXISTS(SELECT 1 FROM DataAndDetails WHERE DataLogDetail_Lots IS NULL HAVING COUNT(*) > 1)
	SELECT 'DataLogDetail_Lots IS NULL IN DataAndDetails for' AS Warning, COUNT(*) cnt FROM DataAndDetails WHERE DataLogDetail_Lots IS NULL HAVING COUNT(*) > 1
	
	IF EXISTS(SELECT 1 FROM DataAndDetails WHERE DataLogDetail_TranData_Profit IS NULL HAVING COUNT(*) > 1)
	SELECT 'DataLogDetail_TranData_Profit IS NULL IN DataAndDetails for' AS Warning, COUNT(*) cnt FROM DataAndDetails WHERE DataLogDetail_TranData_Profit IS NULL HAVING COUNT(*) > 1
	
	IF EXISTS(SELECT 1 FROM DataAndDetails WHERE DataLogDetail_TranData_InverseProfit IS NULL HAVING COUNT(*) > 1)
	SELECT 'DataLogDetail_TranData_InverseProfit IS NULL IN DataAndDetails for' AS Warning, COUNT(*) cnt FROM DataAndDetails WHERE DataLogDetail_TranData_InverseProfit IS NULL HAVING COUNT(*) > 1
	
	IF EXISTS(SELECT 1 FROM DataAndDetails WHERE DataLogDetail_TranData_TakeProfit IS NULL HAVING COUNT(*) > 1)
	SELECT 'DataLogDetail_TranData_TakeProfit IS NULL IN DataAndDetails for' AS Warning, COUNT(*) cnt FROM DataAndDetails WHERE DataLogDetail_TranData_TakeProfit IS NULL HAVING COUNT(*) > 1
	
	IF EXISTS(SELECT 1 FROM DataAndDetails WHERE DataLogDetail_TranData_StopLoss IS NULL HAVING COUNT(*) > 1)
	SELECT 'DataLogDetail_TranData_StopLoss IS NULL IN DataAndDetails for' AS Warning, COUNT(*) cnt FROM DataAndDetails WHERE DataLogDetail_TranData_StopLoss IS NULL HAVING COUNT(*) > 1


	IF EXISTS(SELECT 1 FROM InitialAggregateDetails WHERE SumProfit = 0.0 HAVING COUNT(*) > 1)
	SELECT 'SumProfit IS 0.0 for' AS Warning, COUNT(*) AS cnt FROM InitialAggregateDetails WHERE SumProfit = 0.0 HAVING COUNT(*) > 1
	
	IF EXISTS(SELECT 1 FROM InitialAggregateDetails WHERE AvgTakeProfit = 0.0 HAVING COUNT(*) > 1)
	SELECT 'AvgTakeProfit IS 0.0 for' AS Warning, COUNT(*) AS cnt FROM InitialAggregateDetails WHERE AvgTakeProfit = 0.0 HAVING COUNT(*) > 1
	
	IF EXISTS(SELECT 1 FROM InitialAggregateDetails WHERE AvgStopLoss = 0.0 HAVING COUNT(*) > 1)
	SELECT 'AvgStopLoss IS 0.0 for' AS Warning, COUNT(*) AS cnt FROM InitialAggregateDetails WHERE AvgStopLoss = 0.0 HAVING COUNT(*) > 1
	
	IF EXISTS(SELECT 1 FROM InitialAggregateDetails WHERE SumOrderIsClosed = 0.0 HAVING COUNT(*) > 1)
	SELECT 'SumOrderIsClosed IS 0.0 for' AS Warning, COUNT(*) AS cnt FROM InitialAggregateDetails WHERE SumOrderIsClosed = 0.0 HAVING COUNT(*) > 1

	--IF EXISTS(SELECT 1 FROM InitialAggregateDetails WHERE DataLogName NOT LIKE '%Bollinger Bands%' AND IrregularLimits = 1 GROUP BY DataLogName HAVING COUNT(*) > 1)
	--SELECT 'Decisions NOT 2BB HAVING irregular limits = 1' AS Warning, DataLogName, COUNT(*) AS [COUNT]
	--FROM InitialAggregateDetails
	--WHERE DataLogName NOT LIKE '%Bollinger Bands%'
	--GROUP BY DataLogName
	--HAVING COUNT(*) > 1
	--ORDER BY DataLogName

	--IF EXISTS(SELECT 1 FROM InitialAggregateDetails WHERE DataLogName LIKE '%Bollinger Bands%' AND IrregularLimits = 0 GROUP BY DataLogName HAVING COUNT(*) > 1)
	--SELECT 'Decision 2BB HAVING irregular limits = 0' AS Warning, DataLogName, COUNT(*) AS [COUNT]
	--FROM InitialAggregateDetails
	--WHERE DataLogName LIKE '%Bollinger Bands%'
	--	AND IrregularLimits = 0
	--GROUP BY DataLogName
	--HAVING COUNT(*) > 1
	--ORDER BY DataLogName
END
GO
