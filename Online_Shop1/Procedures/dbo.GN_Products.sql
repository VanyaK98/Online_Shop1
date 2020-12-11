CREATE PROCEDURE [dbo].[GN_Products]
AS 
BEGIN 
BEGIN TRY
	DECLARE 
	@Name varchar(25),
	@Type varchar(15),
	@Weight varchar(10),
	@BatteryCapacity varchar(20),
	@Processor varchar(20),
	@ScreenDiagonal Varchar(20), 
	@MemoryCapacity varchar(20),
	@Color varchar(20),
	@date date,
	@Price money,
	@Counter int,
	@OperationName varchar(20) = 'GN_Products',
	@Description varchar(100) = 'Populate tables ConfigurationModels,Products,Warehouse',
	@ProcName varchar(20) = 'GN_Products',
	@ErrorMessege varchar(25),
	@StartVersion int,
    @RunID int

	EXEC dbo.OperationRuns	@OperationName = @OperationName,
								  @Description = @Description,
								  @ProcName = @ProcName

	CREATE TABLE #StagingTable (
	Name varchar(20),
	Type varchar(20),
	Weight varchar(20),
	BatteryCapacity varchar(20),
	MemoryCapacity varchar(20),
	Processor varchar(20),
	ScreenDiagonal varchar(29) ,
	Color varchar(20),  
	date date,
	Price money
	)

	BULK INSERT #StagingTable 
	FROM 'C:\Users\ikozlov\source\repos\Online_Shop1\Online_Shop1\CSV\Сharacteristics.csv'
	WITH (FIRSTROW = 2,
				  FIELDTERMINATOR = ',',
				  ROWTERMINATOR='\n'
				  );
	BULK INSERT #StagingTable 
	FROM 'C:\Users\ikozlov\source\repos\Online_Shop1\Online_Shop1\CSV\СharacteristicsIPad.csv'
	WITH (FIRSTROW = 2,
				  FIELDTERMINATOR = ',',
				  ROWTERMINATOR='\n'
				  );

	DELETE  FROM #StagingTable 
	WHERE Name + Type + Weight + BatteryCapacity +
	Processor + MemoryCapacity + Color  + ScreenDiagonal is null 

	DECLARE Cursor1 Cursor LOCAL READ_ONLY FASt_FORWARD FOR SELECT * FROM #StagingTable
	OPEN Cursor1

	FETCH NEXT FROM Cursor1 
	INTO @Name,@Type,@Weight,@BatteryCapacity,@MemoryCapacity,@Processor,@ScreenDiagonal,@Color, @date,@Price


		WHILE  @@FETCH_STATUS = 0
			BEGIN 
				

				INSERT INTO Master.Products(Name,Type)
				VALUES (@Name,@Type)

				INSERT INTO Master.ConfigurationModels(Weight,BatteryCapacity,MemoryCapacity,Processor,ScreenDiagonal,Color)
				VALUES (@Weight,@BatteryCapacity,@MemoryCapacity,@Processor,@ScreenDiagonal,@Color)

				

		     
				SET @RunID = (SELECT Ident_current('Log.OperationRuns'))
				 
				 IF @date not  in (SELECT CreatedDate FROM Config.Version)
					BEGIN
						INSERT INTO Config.Version(CreatedDate,RunID)
						VALUES(@date, @RunID)
						SET @StartVersion = (SELECT Ident_current('Config.Version'))
					END

				  ELSE
					SET @StartVersion = (SELECT ID FROM Config.Version WHERE CreatedDate = @date)

				INSERT INTO Master.Warehouse(ProductsID,ConfigurationModelId,ReceivingDate,StartVersion, Price)
				VALUES ((SELECT Ident_current('Master.Products')),(SELECT Ident_current('Master.ConfigurationModels')),@date,@StartVersion,@Price)
				
				FETCH NEXT FROM Cursor1 
				INTO @Name,@Type,@Weight,@BatteryCapacity,@MemoryCapacity,@Processor,@ScreenDiagonal,@Color, @date,@Price
			END 

			UPDATE Log.OperationRuns
				SET EndTime = (SELECT GETDATE()),
			        STATUS = 'Successfully'
				WHERE id = (SELECT Ident_current('Log.OperationRuns'))

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
				 	Close Cursor1 
					DEALLOCATE  Cursor1
					DROP TABLE #StagingTable 
			END CATCH  


	Close Cursor1 
	DEALLOCATE  Cursor1
	DROP TABLE #StagingTable 
END
GO