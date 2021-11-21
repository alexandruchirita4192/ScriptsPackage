IF OBJECT_ID('USP_GetResultsFromSessionId') IS NOT NULL
	DROP PROCEDURE USP_GetResultsFromSessionId;
GO
CREATE PROCEDURE USP_GetResultsFromSessionId(@SessionId INT = NULL)
AS
BEGIN
	IF @SessionId IS NULL
	BEGIN
		SET @SessionId = dbo.UDF_GetLastSession('DefaultSession');
		PRINT 'Defaulting @SessionId to SessionId of ''DefaultSession'' (' + CAST(@SessionId AS VARCHAR) + ')';
	END

	IF @SessionId IS NULL
		RETURN;

	IF OBJECT_ID('XmlDataAndDetails') IS NOT NULL
		DROP TABLE XmlDataAndDetails;
	
	IF NOT EXISTS(
		SELECT 1 FROM vwDataToXml WHERE SessionId = @SessionId
	)
	BEGIN
		SELECT 'Empty vwDataToXml for session ' + CAST(@SessionId AS VARCHAR(10)) + '; SELECT * FROM vwDataToXml WHERE SessionId = ' + CAST(@SessionId AS VARCHAR(10)) AS Error
		RETURN;
	END

	PRINT 'inserting INTO XmlDataAndDetails FROM vwDataToXml'
	SELECT *
	INTO XmlDataAndDetails
	FROM vwDataToXml
	WHERE SessionId = @SessionId

	IF OBJECT_ID('DataAndDetails') IS NOT NULL
		DROP TABLE DataAndDetails;
	
	IF NOT EXISTS(
		SELECT 1 FROM vwXmlExtractIntoTable WHERE SessionId = @SessionId
	)
	BEGIN
		SELECT 'Empty vwXmlExtractIntoTable for session ' + CAST(@SessionId AS VARCHAR(10)) + '; SELECT * FROM vwXmlExtractIntoTable WHERE SessionId = ' + CAST(@SessionId AS VARCHAR(10)) AS Error
		RETURN;
	END

	PRINT 'inserting INTO DataAndDetails FROM vwXmlExtractIntoTable'
	SELECT *
	INTO DataAndDetails
	FROM vwXmlExtractIntoTable
	
	-- ignore the fact that this IS NOT a real temp. TABLE; we let it live, though
	IF OBJECT_ID('InitialAggregateDetails') IS NOT NULL
		DROP TABLE InitialAggregateDetails;
	
	IF NOT EXISTS(
		SELECT 1 FROM vwInitialAggregateDetails
	)
	BEGIN
		SELECT 'Empty vwInitialAggregateDetails; SELECT * FROM vwInitialAggregateDetails' AS Error
		RETURN;
	END

	PRINT 'inserting INTO InitialAggregateDetails FROM vwInitialAggregateDetails'
	SELECT *
	INTO InitialAggregateDetails
	FROM vwInitialAggregateDetails

	IF OBJECT_ID('AggregateDetails') IS NOT NULL
		DROP TABLE AggregateDetails;
	
	IF NOT EXISTS(
		SELECT 1 FROM vwAggregateDetails
	)
	BEGIN
		SELECT 'Empty vwAggregateDetails; SELECT * FROM vwAggregateDetails' AS Error
		RETURN;
	END

	PRINT 'inserting INTO AggregateDetails FROM vwAggregateDetails'
	SELECT *
		, ROW_NUMBER() OVER(
			ORDER BY 
				MinLotsMarginDecision + 
				SpreadDecision +
				FullProcentualProfitDecision + 
				PositiveOrdersCountDecision +
				BestSumProfitDecision +
				VolumeDecision +
				BarsPerOrdersDecision 
			ASC
		) AS OrderNo
	INTO AggregateDetails
	FROM vwAggregateDetails
	ORDER BY OrderNo ASC
	
	
	/*
	DROP TABLE MetatraderResults
	*/
	IF OBJECT_ID('tempdb..#tmpMetatraderResults') IS NOT NULL
		DROP TABLE #tmpMetatraderResults;
		
	IF NOT EXISTS(
		SELECT 1 FROM vwResults
	)
	BEGIN
		SELECT 'Empty vwResults; SELECT * FROM vwResults' AS Error
		RETURN;
	END

	PRINT 'inserting INTO #tmpMetatraderResults FROM vwResults'
	SELECT *
	INTO #tmpMetatraderResults
	FROM vwResults
	
	IF OBJECT_ID('MetatraderResults') IS NULL
	BEGIN
		PRINT 'inserting INTO MetatraderResults FROM #tmpMetatraderResults'
		SELECT *
		INTO MetatraderResults
		FROM #tmpMetatraderResults
		
		-- Changes made to be able to ADD a PK (PK needed for edmx to include TABLE)
		--ALTER TABLE MetatraderResults ALTER COLUMN Symbol VARCHAR(100) NOT NULL
		--ALTER TABLE MetatraderResults ALTER COLUMN DecisionName VARCHAR(1000) NOT NULL
		--ALTER TABLE MetatraderResults ALTER COLUMN TransactionName VARCHAR(1000) NOT NULL
		--ALTER TABLE MetatraderResults ALTER COLUMN IsInverseDecision bit NOT NULL

		--ALTER TABLE MetatraderResults ADD CONSTRAINT PK_MetatraderResults_Symbol_DecisionName_TransactionName_IsInverseDecision PRIMARY KEY (Symbol, DecisionName, TransactionName, IsInverseDecision)
	END
	ELSE
	BEGIN
		PRINT 'deleting old MetatraderResults WITH same Symbol AS #tmpMetatraderResults'
		DELETE mr
		FROM MetatraderResults mr 
			JOIN #tmpMetatraderResults t ON t.Symbol = mr.Symbol
		
		PRINT 'inserting INTO MetatraderResults FROM #tmpMetatraderResults'
		INSERT INTO MetatraderResults
		SELECT * FROM #tmpMetatraderResults
		
		PRINT 'updating MetatraderResults.OrderNo'
		UPDATE mr
		SET
			mr.OrderNo = mr2.NewOrderNo,
			mr.MaxOrderNo = mr2.NewMaxOrderNo
		FROM MetatraderResults mr
			LEFT JOIN (
				SELECT
					row_number() OVER( -- OrderNo uses a little bit too many criterias; code duplicated IN vwResults too
						ORDER BY
							MinLotsMarginDecision +
							SpreadDecision +
							FullProcentualProfitDecision +
							PositiveOrdersCountDecision +
							BestSumProfitDecision +
							VolumeDecision +
							BarsPerOrdersDecision ASC
						) AS NewOrderNo,
						(SELECT COUNT(*) FROM MetatraderResults) AS NewMaxOrderNo,
						*
				FROM MetatraderResults
			) mr2 ON mr2.Symbol = mr.Symbol
				AND mr2.Period = mr.Period
				AND mr2.DecisionName = mr.DecisionName
				AND mr2.LotName = mr.LotName
				AND mr2.MinLots = mr.MinLots
				AND mr2.MinLotsMargin = mr.MinLotsMargin
				AND mr2.IsInverseDecision = mr.IsInverseDecision
				AND mr2.TransactionName = mr.TransactionName
				AND mr2.Bars = mr.Bars
				AND mr2.BarsPerOrders = mr.BarsPerOrders
				AND mr2.LastDecisionBar = mr.LastDecisionBar
				AND mr2.LastDecisionTime = mr.LastDecisionTime
				AND mr2.LastDecisionType = mr.LastDecisionType
				AND mr2.PositiveOrdersCount = mr.PositiveOrdersCount
				AND mr2.InversePositiveOrdersCount = mr.InversePositiveOrdersCount
				
				AND mr2.MinLotsMarginDecision = mr.MinLotsMarginDecision
				AND mr2.SpreadDecision = mr.SpreadDecision
				AND mr2.FullProcentualProfitDecision = mr.FullProcentualProfitDecision
				AND mr2.PositiveOrdersCountDecision = mr.PositiveOrdersCountDecision
				AND mr2.BestSumProfitDecision = mr.BestSumProfitDecision
				AND mr2.VolumeDecision = mr.VolumeDecision
				AND mr2.BarsPerOrdersDecision = mr.BarsPerOrdersDecision
	END

	-- For cleaning:
	--DROP TABLE MetatraderResults
END
GO
