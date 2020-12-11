CREATE PROCEDURE [dbo].[OperationRuns]
@OperationName varchar(50),
	@Description varchar(50),
	@ProcName varchar(20)
	AS
		BEGIN
			DECLARE 
			@StartTime dateTime  = (SELECT GETDATE()),
			@Status varchar(20) = 'Runs',
			@User varchar(25) = (SELECT USER_NAME())		
			

				INSERT INTO Log.Operations(OperationName,Description)
					Values(@OperationName,@Description)

				INSERT INTO Log.OperationRuns(OperationId,StartTime,Status)
					VALUES ((SELECT MAX(Id) FROM Log.Operations),@StartTime,@Status)

				INSERT INTO Log.EventLog([User],ProcName,OperationRunId)
					VALUES (@User,@ProcName,(SELECT Ident_current('Log.OperationRuns')))
		
		END
GO