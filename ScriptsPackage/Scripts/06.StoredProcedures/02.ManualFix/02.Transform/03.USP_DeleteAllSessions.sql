IF OBJECT_ID('USP_DeleteAllSessions') IS NOT NULL
	DROP PROCEDURE USP_DeleteAllSessions;
GO
CREATE PROCEDURE USP_DeleteAllSessions
AS
BEGIN
	DECLARE @DefaultSessionId INT, @DefaultDataLogId INT
	SELECT TOP 1 @DefaultSessionId = SessionId FROM TradingSession WHERE Name = 'DefaultSession'
	SELECT TOP 1 @DefaultDataLogId = DataLogId FROM DataLog WHERE SessionId = @DefaultSessionId

	DELETE FROM DataLogDetail WHERE DataLogId <> @DefaultDataLogId
	DELETE FROM DataLog WHERE SessionId <> @DefaultSessionId
	DELETE FROM ProcedureLog WHERE SessionId <> @DefaultSessionId
	DELETE FROM DebugLog WHERE SessionId <> @DefaultSessionId
	DELETE FROM TradingSession WHERE SessionId <> @DefaultSessionId
END
GO
