IF NOT EXISTS(SELECT 1 FROM ConfigTable)
BEGIN
	INSERT INTO ConfigTable(Config,Value)
	SELECT 'BaseWebServiceURL', 'http://localhost/MetatraderWebLog/WebService.asmx'
	UNION ALL
	SELECT 'WebServiceURLs', 'NewTradingSession/1/name, EndTradingSession/1/name, StartProcedureLog/3/sessionName;name;parameters, EndProcedureLog/2/sessionName;name, DataLog/3/sessionName;name;data, DataLogDetail/3/sessionName;name;detail, DebugLog/3/sessionName;debugData;debugTime, DeleteLastSession/1/sessionName, DeleteAllSessions/0/, ReadLastDataLog/1/sessionName, ReadLastDataLogAndDetail/1/sessionName, ReadLastDataLogDetail/1/sessionName, ReadLastProcedureLog/1/sessionName, GetPartialResults/1/sessionName, GetResultsFromPartialResults/0/, GetDecisionsIntoResultsTable/0/, GetResults/1/sessionName, ReadResults/0/, ReadResult/1/orderNo, ReadLastSymbol/1/sessionName, ReadResultFromSymbol/1/symbolName'
	UNION ALL
	SELECT 'BulkWebServiceURLs', 'TestMethod2/TestStruct/3/sessionName;debugData;debugTime, BulkDataLog/BulkDataLogStruct/3/sessionName;name;data, BulkDataLogDetail/BulkDataLogDetailStruct/3/sessionName;name;detail, BulkDebugLog/BulkDebugLogStruct/3/sessionName;debugData;debugTime'
	UNION ALL
	SELECT 'IsExpertAdviser', 'false'
	UNION ALL
	SELECT 'UseChartSymbol', 'true'
	UNION ALL
	SELECT 'OnlyOneSymbol', 'false'
	UNION ALL
	SELECT 'OnlyOnePeriod', 'true'
	UNION ALL
	SELECT 'ConfigFile', 'TestChangeChartGlobalVar.mq4'
	UNION ALL
	SELECT 'Period', '1'
	UNION ALL
	SELECT 'NewTime', '2017.04.23 11:08'
	UNION ALL
	SELECT 'IsTradeAllowedOnEA', 'true'
	UNION ALL
	SELECT 'DoWebServiceCalls', 'true'
	UNION ALL
	SELECT 'ObjectsLimit', '0'
	UNION ALL
	SELECT 'GetBestTPandSL', 'true'
	UNION ALL
	SELECT 'GetBestTPandSLPrintZeroProfit', 'false'
	UNION ALL
	SELECT 'GetBestTPandSLWithTPandSL', 'false'
	UNION ALL
	SELECT 'UseLightSystem', 'false'
	UNION ALL
	SELECT 'UseFullSystem', 'false'
	UNION ALL
	SELECT 'StartSimulationAgain', 'false'
	UNION ALL
	SELECT 'KeepAllObjects', 'true'
	UNION ALL
	SELECT 'UseEA', 'false'
	UNION ALL
	SELECT 'MakeOnlyOneOrder', 'false'
	UNION ALL
	SELECT 'UseManualDecisionEA', 'true'
	UNION ALL
	SELECT 'DecisionEA', 'DecisionDoubleBB'
	UNION ALL
	SELECT 'LotManagementEA', 'BaseLotManagement'
	UNION ALL
	SELECT 'TransactionManagementEA', 'BaseTransactionManagement'
	UNION ALL
	SELECT 'IsInverseDecisionEA', 'false'
	UNION ALL
	SELECT 'OnlyCurrentSymbol', 'true'
	UNION ALL
	SELECT 'AllowChangingSymbol', 'true'
	UNION ALL
	SELECT 'UseKeyBoardChangeChart', 'false'
	UNION ALL
	SELECT 'UseIndicatorChangeChart', 'true'
	UNION ALL
	SELECT 'Debug', 'true'
	UNION ALL
	SELECT 'UseOnlyFirstDecisionAndConfirmItWithOtherDecisions', 'false'
END
GO
