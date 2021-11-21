IF OBJECT_ID('USP_MoveDataFromSessionName') IS NOT NULL
	DROP PROCEDURE USP_MoveDataFromSessionName;
GO
CREATE PROCEDURE USP_MoveDataFromSessionName (
	@OldTradingSessionName VARCHAR(1000) = 'TestSimulateTranSystemOneSymbol.mq4',
	@NewTradingSessionName VARCHAR(1000) = 'TestSimulateTranSystem.mq4'
)
AS
BEGIN
	DECLARE @NewTradingSessionId INT, @OldTradingSessionId INT
	SET @OldTradingSessionId = dbo.UDF_GetLastSession(@OldTradingSessionName)
	SET @NewTradingSessionId = dbo.UDF_GetLastSession(@NewTradingSessionName)

	EXEC USP_MoveDataFromSessionId @OldTradingSessionId, @NewTradingSessionId
END
GO
