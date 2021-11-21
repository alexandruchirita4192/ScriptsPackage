IF OBJECT_ID('USP_LogLastProcedure') IS NOT NULL
	DROP PROCEDURE USP_LogLastProcedure;
GO
CREATE PROCEDURE USP_LogLastProcedure @LogText VARCHAR(1000)
AS
BEGIN
	INSERT INTO LastLogProcedure(LogText)
	SELECT @LogText

	DELETE llp
	FROM LastLogProcedure llp
		JOIN (
			SELECT LastLogProcedureId, ROW_NUMBER() OVER (ORDER BY LastLogProcedureId DESC) rn
			FROM LastLogProcedure x
		) x ON x.LastLogProcedureId = llp.LastLogProcedureId
			AND x.rn > 10
END
GO
