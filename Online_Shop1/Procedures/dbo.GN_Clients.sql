CREATE PROCEDURE [dbo].[GN_Clients]
AS 
	BEGIN 
		BEGIN TRY
			DECLARE 
			@OperationName varchar(20) = 'GN_Clients',
			@Description varchar(30) = 'Populate table Clients,Address',
			@StartTime dateTime  = (SELECT GETDATE()),
			@EndTime dateTime,
			@Status varchar(20) = 'Runs',
			@User varchar(25) = (SELECT USER_NAME()),
			@ProcName varchar(20) = 'GN_Clients',
			@ErrorMessege varchar(25),
			@CountRows int,
			@InsertedRows int

			EXEC dbo.OperationRuns @OperationName = @OperationName,
								  @Description = @Description,
								  @ProcName = @ProcName
	
			CREATE TABLE #StagingTable (
				FirstName varchar(50),
				LastName varchar(50),
				Email varchar(100),
				Phone varchar(30) ,
				City varchar(50),
				Street varchar(50),
				)
				BULK INSERT #StagingTable 
				FROM 'C:\Users\ikozlov\source\repos\Online_Shop\Online_Shop\CSV\Clients_Address.csv'
				WITH (FIRSTROW = 1,
				  FIELDTERMINATOR = ',',
				  ROWTERMINATOR='\n'
				  );
 
				Set @InsertedRows = @@ROWCOUNT 

				INSERT INTO Master.Address(City,Street)
				SELECT City,Street FROM #StagingTable

				SET @CountRows = (SELECT COUNT(*) FROM Master.Address)

				INSERT INTO Master.Clients(FirstName,LastName,Email,Phone,AddressId)
				SELECT FirstName,LastName,Email,Phone, ABS(CHECKSUM(NEWID()) % @CountRows) + 1 as AddressId 
				FROM #StagingTable
		
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
			  DROP Table #StagingTable
			END CATCH  
 DROP Table #StagingTable
	END
GO