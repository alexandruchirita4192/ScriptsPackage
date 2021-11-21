IF OBJECT_ID('ProcedureLog') IS NULL
CREATE TABLE ProcedureLog (
	ProcedureLogId INT IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(250),
	ParamsToString VARCHAR(1000),
	StartTime DATETIME,
	EndTime DATETIME,
	SessionId INT,
	CONSTRAINT FK_ProcedureLog_SessionId FOREIGN KEY (SessionId) REFERENCES TradingSession(SessionId)
);
ELSE
UPDATE STATISTICS ProcedureLog
GO

