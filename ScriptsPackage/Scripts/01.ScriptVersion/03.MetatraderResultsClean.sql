IF OBJECT_ID('DatabaseVersion') IS NOT NULL
	AND OBJECT_ID('MetatraderResults') IS NOT NULL
BEGIN
	IF NOT EXISTS(SELECT 1 FROM DatabaseVersion WHERE VersionNumber = CAST(CAST(CONTEXT_INFO() AS BINARY(8)) AS INT))
		DROP TABLE MetatraderResults;
END
GO
