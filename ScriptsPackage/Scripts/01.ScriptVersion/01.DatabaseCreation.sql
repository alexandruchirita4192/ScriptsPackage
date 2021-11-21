IF NOT EXISTS (SELECT 1 FROM sys.databases d WHERE d.name = 'MetatraderLog')
	CREATE DATABASE MetatraderLog;
GO
USE MetatraderLog;
GO
