IF OBJECT_ID('USP_ReadLastDataLogDetail') IS NOT NULL
	DROP PROCEDURE USP_ReadLastDataLogDetail;
GO
CREATE PROCEDURE USP_ReadLastDataLogDetail(@SessionName VARCHAR(8000))
AS
BEGIN
	DECLARE @SessionId INT
	SET @SessionId = dbo.UDF_GetLastSession(@SessionName);
	SELECT dld.*
	FROM DataLogDetail dld
		JOIN DataLog dl ON dl.DataLogId = dld.DataLogId
	WHERE dl.SessionId = @SessionId
END
GO
