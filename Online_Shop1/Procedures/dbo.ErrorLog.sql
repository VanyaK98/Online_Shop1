CREATE PROCEDURE [dbo].[ErrorLog]
	
	AS 
	 BEGIN 
	 UPDATE Log.OperationRuns
				SET EndTime = (SELECT GETDATE()),
			        STATUS = 'faild'
				WHERE id = (SELECT Ident_current('Log.OperationRuns'))
	    
	 END