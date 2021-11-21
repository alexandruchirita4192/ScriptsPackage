IF OBJECT_ID('USP_ReadLastDataLogAndDetail') IS NOT NULL
	DROP PROCEDURE USP_ReadLastDataLogAndDetail;
GO
CREATE PROCEDURE USP_ReadLastDataLogAndDetail(@SessionName VARCHAR(8000))
AS
BEGIN
	DECLARE @SessionId INT
	SET @SessionId = dbo.UDF_GetLastSession(@SessionName);
	SELECT dl.DataLogId, dl.Name AS DataLogName, dl.Data AS DataLogData, dl.LogTime AS DataLogTime, dld.DataLogDetailId, dld.Detail AS DataLogDetail, dld.LogTime AS DataLogDetailTime, dld.Name AS DataLogDetailName, dl.SessionId
	FROM DataLog dl 
		LEFT JOIN DataLogDetail dld ON dld.DataLogId = dl.DataLogId
	WHERE dl.SessionId = @SessionId
END
GO
