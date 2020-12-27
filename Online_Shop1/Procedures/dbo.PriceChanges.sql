CREATE PROCEDURE [dbo].[PriceChanges]
@Interest int,
@Action nvarchar
AS 
	BEGIN 
	  BEGIN TRY
			BEGIN TRAN
			DECLARE 
			@OperationName varchar(20) = 'PriceChanges',
			@Description varchar(30) = 'Price Changes',
			@ProcName varchar(20) = 'PriceChanges'

			EXEC dbo.OperationRuns @OperationName = @OperationName,
								  @Description = @Description,
								  @ProcName = @ProcName
 

			INSERT INTO Config.Version(CreatedDate,RunID)
			VALUES(Getdate(),(SELECT Ident_current('Log.OperationRuns')))


			 UPDATE Master.Warehouse
			 SET EndVersion = (SELECT Ident_current('Config.Version'))
			 WHERE EndVersion = 999999999

			 
			INSERT INTO Master.Warehouse(ProductsID,ConfigurationModelId,ReceivingDate,StartVersion,Price)
			SELECT ProductsID,ConfigurationModelId,ReceivingDate,EndVersion,
			CASE
			when @Action = '-' then Price - ((Price * @Interest) / 100)   
			else Price + ((Price * @Interest) / 100) end 
			FROM Master.Warehouse 
			WHERE EndVersion = (SELECT Ident_current('Config.Version'))


		 EXEC OperationRunsUpdate  @InsertedRows = 1

             COMMIT TRAN
			END TRY
				BEGIN CATCH
					ROLLBACK TRAN
					INSERT INTO Log.ErrorLog(ErrorNumber,ErrorSeverty,ErrorState,ErrorProc,ErrorLine,ErrorMessege,EventLogId)
						SELECT  
						 ERROR_NUMBER() AS ErrorNumber,  
						 ERROR_SEVERITY() AS ErrorSeverity,  
						 ERROR_STATE() AS ErrorState,  
						 ERROR_PROCEDURE() AS ErrorProcedure,  
						 ERROR_LINE() AS ErrorLine,  
						 ERROR_MESSAGE() AS ErrorMessage,
						 (SELECT Ident_current('Log.EventLog'))
					 EXEC  dbo.ErrorLog
				END CATCH  
	 END

GO


