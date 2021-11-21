IF OBJECT_ID('USP_MoveDataFromSessionId') IS NOT NULL
	DROP PROCEDURE USP_MoveDataFromSessionId;
GO
CREATE PROCEDURE USP_MoveDataFromSessionId(@OldTradingSessionId INT, @NewTradingSessionId INT)
AS
BEGIN
	UPDATE dl
	SET
		dl.SessionId = @NewTradingSessionId
	FROM DataLog dl
	WHERE dl.SessionId = @OldTradingSessionId
END
GO
