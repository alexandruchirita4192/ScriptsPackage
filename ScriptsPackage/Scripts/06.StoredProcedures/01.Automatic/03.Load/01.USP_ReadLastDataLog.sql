IF OBJECT_ID('USP_ReadLastDataLog') IS NOT NULL
	DROP PROCEDURE USP_ReadLastDataLog;
GO
CREATE PROCEDURE USP_ReadLastDataLog(@SessionName VARCHAR(8000) = NULL)
AS
BEGIN
	DECLARE @SessionId INT
	SET @SessionId = dbo.UDF_GetLastSession(@SessionName);
	SELECT * FROM DataLog WHERE SessionId = @SessionId
END
GO
