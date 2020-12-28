CREATE PROCEDURE [dbo].[ConfigOff]
AS
BEGIN
DECLARE 
@prevAdvancedOptions INT,
@prevXpCmdshell INT

SELECT @prevAdvancedOptions = cast(value_in_use as int) from sys.configurations where name = 'show advanced options'
SELECT @prevXpCmdshell = cast(value_in_use as int) from sys.configurations where name = 'xp_cmdshell'


IF (@prevXpCmdshell = 1)
BEGIN

	SELECT @prevAdvancedOptions
	exec sp_configure 'xp_cmdshell', 0
    reconfigure
END

IF (@prevAdvancedOptions = 1)
BEGIN
	SELECT @prevXpCmdshell
    exec sp_configure 'show advanced options', 0
    reconfigure
END
END