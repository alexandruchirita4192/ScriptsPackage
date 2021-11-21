IF OBJECT_ID('USP_ReadResultFromSymbol') IS NOT NULL
	DROP PROCEDURE USP_ReadResultFromSymbol;
GO
CREATE PROCEDURE USP_ReadResultFromSymbol(@Symbol VARCHAR(100))
AS
BEGIN
	SELECT TOP 1 *
	FROM MetatraderResults
	WHERE Symbol = @Symbol
	ORDER BY OrderNo
END
GO
