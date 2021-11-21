/*
 * In CONTEXT_INFO is saved the current script version number, set only for the current @@SPID
 * For reading version use: select cast(cast(CONTEXT_INFO() as binary(8)) as int)
 */
DECLARE @VersionNumber BIGINT, @VersionNumberBinary BINARY(128)
SET @VersionNumber = 14
SET @VersionNumberBinary = CAST(@VersionNumber AS BINARY(128))
SET CONTEXT_INFO @VersionNumber
GO
