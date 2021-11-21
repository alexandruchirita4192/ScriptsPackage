IF OBJECT_ID('USP_DebugLog') IS NOT NULL
	DROP PROCEDURE USP_DebugLog;
GO
CREATE PROCEDURE USP_DebugLog(@SessionName VARCHAR(8000), @DebugData VARCHAR(8000), @DebugTime DATETIME = NULL)
AS
BEGIN
	IF @DebugTime IS NULL
		SET @DebugTime = GETDATE();

	INSERT INTO DebugLog(DebugTime, DebugData, SessionId)
	SELECT @DebugTime, @DebugData, dbo.UDF_GetLastSession(@SessionName)
END
GO
