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
	
			CREATE TABLE ##StagingTable (
				FirstName varchar(50),
				LastName varchar(50),
				Email varchar(100),
				Phone varchar(30) ,
				City varchar(50),
				Street varchar(50),
				)
				DECLARE @bcp_cmd4 VARCHAR(1000);
				DECLARE @exe_path4 VARCHAR(200) = 
				  'call "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\';
				SET @bcp_cmd4 =  @exe_path4 +
				   'BCP.EXE" [tempdb].[##StagingTable] in C:\temp\Clients_Address.csv -T -c -S LV4477\MSSQLSERVER19 -U SOFTSERVE\ikozlov -t "," ';
				PRINT @bcp_cmd4;
				EXEC master..xp_cmdshell @bcp_cmd4;
 
				Set @InsertedRows = @@ROWCOUNT 

				INSERT INTO Master.Address(City,Street)
				SELECT City,Street FROM ##StagingTable

				SET @CountRows = (SELECT COUNT(*) FROM Master.Address)

				INSERT INTO Master.Clients(FirstName,LastName,Email,Phone,AddressId)
				SELECT FirstName,LastName,Email,Phone, ABS(CHECKSUM(NEWID()) % @CountRows) + 1 as AddressId 
				FROM ##StagingTable
		
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
			  DROP Table ##StagingTable
			END CATCH  
 DROP Table ##StagingTable
	END
GO