-- Data to XML (DataLog.Data, DataLogDetail.Detail are XML now)
IF OBJECT_ID('vwDataToXml') IS NOT NULL
	DROP VIEW vwDataToXml;
GO
CREATE VIEW vwDataToXml
AS
SELECT
	dl.DataLogId,
	dl.Name AS DataLogName, 
	CAST(
		REPLACE(
			REPLACE(
				REPLACE(
					REPLACE(dl.Data, '-*-.', '&'),
				'-_-.', '='),
			'&lt;', '<'),
		'&gt;', '>')
	AS xml) AS DataLogData, 
	dl.LogTime AS DataLogTime,
	dld.DataLogDetailId,
	CAST(
		--REPLACE(
			--REPLACE(
				REPLACE(
					REPLACE(
						REPLACE(
							REPLACE(dld.Detail, '-*-.', '&'),
						'-_-.', '='),
					'&lt;', '<'),
				'&gt;', '>') --,
			--' OrderIsClosed="true">', ' OrderIsClosed="true"/>'),
		--' OrderIsClosed="false">', ' OrderIsClosed="false"/>')
	AS xml) AS DataLogDetail,
	dld.LogTime AS DataLogDetailTime,
	dld.Name AS DataLogDetailName,
	dl.SessionId
FROM DataLog dl 
	LEFT JOIN DataLogDetail dld ON dld.DataLogId = dl.DataLogId
WHERE dl.Name <> 'OrdersToString'
GO


IF OBJECT_ID('XmlDataAndDetails') IS NOT NULL
	DROP TABLE XmlDataAndDetails
GO -- USP_GetDataAndDetailsFromSessionId
SELECT t.*
INTO XmlDataAndDetails
FROM vwDataToXml t
	JOIN TradingSession ts ON ts.SessionId = t.SessionId
WHERE ts.Name = 'DefaultSession'
GO
