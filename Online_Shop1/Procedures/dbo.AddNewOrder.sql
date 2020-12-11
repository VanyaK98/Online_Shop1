CREATE PROCEDURE [dbo].[AddNewOrder]
@ProductsId varchar(100),
@clientsId int
	AS
	 BEGIN
	   BEGIN TRY
		 BEGIN TRAN
			DECLARE 
			@OperationName varchar(20) = 'AddNewOrder',
			@Description varchar(30) = 'Add New order',
			@ProcName varchar(20) = 'AddNewOrder',
			@ErrorMessege varchar(25),
			@Date date = GetDate(),
			@OrderId int,
			@EndVersion int

			EXEC dbo.OperationRuns @OperationName = @OperationName,
								   @Description = @Description,
								   @ProcName = @ProcName

			INSERT INTO Master.Orders(ClientId,Date,ShippingStatus)
				Values(@clientsId,@Date,'WaitForShipping')

				SET @OrderId = (SELECT Ident_current('Master.Orders'))

			INSERT INTO Master.DetailOrders(OrderId,ProductsID)
			SELECT @OrderId,value FROM string_split(@ProductsId, ',');


			INSERT INTO Config.Version(CreatedDate,RunID)
									VALUES(@date, (SELECT Ident_current('Log.OperationRuns')))
									SET @EndVersion = (SELECT Ident_current('Config.Version'))

			UPDATE master.Warehouse
			 SET EndVersion = @EndVersion
			 WHERE ProductsID IN (SELECT value FROM string_split(@ProductsId, ','))

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