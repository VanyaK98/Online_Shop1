CREATE PROCEDURE [dbo].[AddNewProduct]
@Name varchar(50),
@Type  varchar(50),
@Weight varchar(100),
@BatteryCapacity varchar(30) ,
@MemoryCapacity varchar(50),
@Processor varchar(50),
@ScreenDiagonal varchar(50),
@Color varchar(50),
@Price Money
  AS
	BEGIN
      BEGIN TRY
	   BEGIN TRAN
			DECLARE 
			@OperationName varchar(20) = 'AddNewProduct',
			@Description varchar(30) = 'Add New Product',
			@ProcName varchar(20) = 'AddNewProduct',
			@ErrorMessege varchar(25),
			@StartVersion int ,
			@Date date = GetDate()

			EXEC dbo.OperationRuns @OperationName = @OperationName,
								   @Description = @Description,
								   @ProcName = @ProcName

			INSERT master.Products(Name,Type)
				values(@Name,@Type)
				
			INSERT master.ConfigurationModels(Weight,BatteryCapacity,MemoryCapacity,Processor,ScreenDiagonal,Color)
						values(@Weight,@BatteryCapacity,@MemoryCapacity,@Processor,@ScreenDiagonal,@Color)

			

			INSERT INTO Config.Version(CreatedDate,RunID)
			VALUES(@Date,(SELECT Ident_current('Log.OperationRuns')))

			SET @StartVersion = ((SELECT Ident_current('Master.Version')))

			INSERT INTO Master.Warehouse(ProductsID,ConfigurationModelId,ReceivingDate,StartVersion,Price)
			VALUES((SELECT Ident_current('master.Products')),(SELECT Ident_current('master.ConfigurationModels')),@Date,@StartVersion,@Price)

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