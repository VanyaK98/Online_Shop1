CREATE PROCEDURE [dbo].[GN_Orders]
AS
	BEGIN 
	 BEGIN TRY
		DECLARE 
		@OperationName varchar(20) = 'GN_Orders',
		@Description varchar(30) = 'Populate table Orders',
		@ProcName varchar(20) = 'GN_Orders',
		@ErrorMessege varchar(100),
		@ClientID int,
		@Date date,
		@FromDate date = '2020-01-10',
		@ToDate date = '2020-12-06',
		@CountOrders int = 5000,
		@OrderId int,
		@EndVersion int,
		@InsertedRows int = 0


		EXEC dbo.OperationRuns 
					@OperationName = @OperationName,
					@Description = @Description,
					@ProcName = @ProcName




		WHILE @CountOrders > 1
			BEGIN
 	
					SET @ClientID = (SELECT top 1 Id FROM Master.Clients ORDER BY NEWID())

				    SET @Date = (select dateadd(day, 
								 rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), 
								 @FromDate))


				    INSERT INTO Master.Orders(ClientId,Date)
					VALUES(@ClientID,@Date)

					SET @OrderId = (SELECT Ident_current('Master.Orders'))

					INSERT INTO master.DetailOrders(OrderId,ProductsID)
					SELECT TOP 1 @OrderId,   * FROM RandomProducts(@Date)ORDER BY NEWID()
		           
				   INSERT INTO Config.Version(CreatedDate,RunID)
						VALUES(@date, (SELECT Ident_current('Log.OperationRuns')))
						SET @EndVersion = (SELECT Ident_current('Config.Version'))

					UPDATE master.Warehouse
					SET EndVersion = @EndVersion
						WHERE ProductsID = (SELECT ProductsID 
											FROM master.DetailOrders
											where ID =(SELECT Ident_current('master.DetailOrders')))
			        SET @CountOrders -=1
					SET @InsertedRows +=1

			END


				EXEC OperationRunsUpdate  @InsertedRows = @InsertedRows

		 END TRY
					
		 BEGIN CATCH
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

		Update Master.Orders
		SET ShippingStatus = 'Sent'

END
GO