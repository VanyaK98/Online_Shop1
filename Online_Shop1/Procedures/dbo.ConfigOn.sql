CREATE PROCEDURE [dbo].[ConfigOn]
AS
BEGIN 
DECLARE 
@prevAdvancedOptions INT,
 @prevXpCmdshell INT

SELECT @prevAdvancedOptions = cast(value_in_use as int) from sys.configurations where name = 'show advanced options'
SELECT @prevXpCmdshell = cast(value_in_use as int) from sys.configurations where name = 'xp_cmdshell'

IF (@prevAdvancedOptions = 0)
BEGIN

	SELECT @prevAdvancedOptions
	exec sp_configure 'show advanced options', 1
    reconfigure
END

IF (@prevXpCmdshell = 0)
BEGIN
	SELECT @prevXpCmdshell
	exec sp_configure 'xp_cmdshell', 1
    reconfigure
END
END