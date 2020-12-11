CREATE PROCEDURE [dbo].[OperationRunsUpdate]
	@InsertedRows int
	AS
		BEGIN
			UPDATE Log.OperationRuns
				SET EndTime = (SELECT GETDATE()),
			        STATUS = 'Successfully'
					,InsertedRows = @InsertedRows
 				WHERE id = (SELECT Ident_current('Log.OperationRuns'))
		
		END
GO
