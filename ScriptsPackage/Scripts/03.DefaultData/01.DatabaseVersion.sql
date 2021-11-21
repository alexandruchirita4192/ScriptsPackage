IF NOT EXISTS(SELECT 1 FROM DatabaseVersion dv WHERE dv.VersionNumber = 0)
BEGIN
	INSERT INTO DatabaseVersion(UpdateDate, VersionNumber)
	SELECT GETDATE(), 0
END
GO
