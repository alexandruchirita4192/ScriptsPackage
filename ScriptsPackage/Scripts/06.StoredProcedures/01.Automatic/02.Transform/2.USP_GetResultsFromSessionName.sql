IF OBJECT_ID('USP_GetResultsFromSessionName') IS NOT NULL
	DROP PROCEDURE USP_GetResultsFromSessionName;
GO
CREATE PROCEDURE USP_GetResultsFromSessionName(@SessionName VARCHAR(8000) = NULL)
AS
BEGIN
	IF @SessionName IS NULL
	BEGIN
		SET @SessionName = 'DefaultSession'
		PRINT 'Defaulting @SessionName to ''DefaultSession'''
	END

	DECLARE @SessionId INT
	SET @SessionId = dbo.UDF_GetLastSession(@SessionName);
	PRINT 'Last session WITH @SessionName=''' + @SessionName + ''' has @SessionId=' + CAST(@SessionId AS VARCHAR)

	PRINT 'EXEC USP_GetResultsFromSessionId @SessionId=' + CAST(@SessionId AS VARCHAR)
	EXEC USP_GetResultsFromSessionId @SessionId
	
	-- EXEC USP_GetResultsFromSessionName 'TestSimulateTranSystem.mq4'
END
GO
