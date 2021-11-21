IF OBJECT_ID('USP_ReadResult') IS NOT NULL
	DROP PROCEDURE USP_ReadResult;
GO
CREATE PROCEDURE USP_ReadResult(@OrderNo BIGINT)
AS
BEGIN
	SELECT TOP 1 *
	FROM MetatraderResults
	WHERE OrderNo = @OrderNo
		AND Symbol <> 'NOPNOP'
	UNION
	SELECT mr.*
	FROM MetatraderResults mr
		JOIN MetatraderResults mr2 ON mr2.OrderNo = @OrderNo
			AND mr2.Symbol = 'NOPNOP'
	WHERE mr.OrderNo = @OrderNo + 1
END
GO
