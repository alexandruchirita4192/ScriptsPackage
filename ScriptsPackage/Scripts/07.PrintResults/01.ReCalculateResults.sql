IF NOT EXISTS(SELECT 1 FROM DatabaseVersion dv WHERE dv.VersionNumber = CAST(CAST(CONTEXT_INFO() AS BINARY(8)) AS INT))
BEGIN
	EXEC USP_GetResultsFromSessionName

	INSERT INTO DatabaseVersion(UpdateDate, VersionNumber)
	SELECT GETDATE(), CAST(CAST(CONTEXT_INFO() AS BINARY(8)) AS INT)
END
GO

IF OBJECT_ID('MetatraderResults') IS NULL
BEGIN
	EXEC USP_GetResultsFromSessionId 1
END
GO
