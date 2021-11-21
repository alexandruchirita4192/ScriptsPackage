﻿IF OBJECT_ID('USP_ReadResults') IS NOT NULL
	DROP PROCEDURE USP_ReadResults;
GO
CREATE PROCEDURE USP_ReadResults
AS
BEGIN
	SELECT *
	FROM MetatraderResults
	ORDER BY OrderNo
END
GO
