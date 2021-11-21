IF OBJECT_ID('USP_DeleteLastSession') IS NOT NULL
	DROP PROCEDURE USP_DeleteLastSession;
GO
CREATE PROCEDURE USP_DeleteLastSession(@SessionName VARCHAR(8000) = NULL)
AS
BEGIN
	DECLARE @LastSessionId INT, @DefaultSessionId INT, @DefaultDataLogId INT
	SELECT TOP 1 @DefaultSessionId = SessionId FROM TradingSession WHERE Name = 'DefaultSession'
	SELECT TOP 1 @DefaultDataLogId = DataLogId FROM DataLog WHERE SessionId = @DefaultSessionId
	
	IF(@SessionName IS NULL)
		SELECT TOP 1 @LastSessionId = ts.SessionId FROM TradingSession ts WHERE ts.SessionId <> @DefaultSessionId ORDER BY ts.SessionId DESC
	ELSE
		SELECT TOP 1 @LastSessionId = ts.SessionId FROM TradingSession ts WHERE ts.Name = @SessionName AND ts.SessionId <> @DefaultSessionId ORDER BY ts.SessionId DESC
		
	DELETE FROM DataLogDetail WHERE DataLogId IN (SELECT DataLogId FROM DataLog WHERE SessionId = @LastSessionId) AND DataLogId <> @DefaultDataLogId
	DELETE FROM DataLog WHERE SessionId = @LastSessionId AND SessionId <> @DefaultSessionId
	DELETE FROM ProcedureLog WHERE SessionId = @LastSessionId AND SessionId <> @DefaultSessionId
	DELETE FROM DebugLog WHERE SessionId = @LastSessionId AND SessionId <> @DefaultSessionId
	DELETE FROM TradingSession WHERE SessionId = @LastSessionId AND SessionId <> @DefaultSessionId
END
GO
