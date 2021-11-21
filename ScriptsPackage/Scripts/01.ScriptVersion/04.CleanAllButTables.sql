/*
 * Script to drop all VIEWS, PROCEDURES, FUNCTIONS (exclude CLR functions). All VIEWS, PROCEDURES, FUNCTIONS will be automatically recreated by some other script packaged next.
 */

DECLARE DropCursor CURSOR FOR (
	SELECT T.ObjectType, T.ObjectName
	FROM (
		SELECT TOP 1000000000 -- Order by in cursor workaround
			CASE
				WHEN SO.[type] = 'V' THEN CAST(1 AS INT)
				WHEN SO.[type] = 'P' THEN CAST(3 AS INT)
				WHEN SO.[type] IN ('FN', 'IF') THEN CAST(2 AS INT)
			END AS OrderNumber,
			CASE
				WHEN SO.[type] = 'V' THEN CAST(N'VIEW' AS NVARCHAR(100))
				WHEN SO.[type] = 'P' THEN N'PROCEDURE'
				WHEN SO.[type] IN ('FN', 'IF') THEN N'FUNCTION'
			END AS ObjectType,
			SO.[name] AS ObjectName
		FROM [sys].[objects] SO
		WHERE [is_ms_shipped] = 0
			AND SO.[type] IN ('V', 'P', 'FN', 'IF')
		ORDER BY [OrderNumber] ASC
	) T
);
OPEN DropCursor;

DECLARE @ObjectType NVARCHAR(100), @ObjectName SYSNAME

FETCH NEXT FROM DropCursor INTO @ObjectType, @ObjectName;

WHILE @@FETCH_STATUS = 0  
BEGIN
	DECLARE @DropScriptSQL NVARCHAR(1000)
	SET @DropScriptSQL = 'DROP ' + @ObjectType + ' ' + @ObjectName
	
	PRINT @DropScriptSQL
	EXEC sp_executesql @DropScriptSQL

	FETCH NEXT FROM DropCursor INTO @ObjectType, @ObjectName;
END;

CLOSE DropCursor;
DEALLOCATE DropCursor;
GO
