CREATE FUNCTION [dbo].[RandomProducts]
(@date date)
RETURNS TABLE
AS
RETURN
SELECT   P.ID FROM Master.Products P
		JOIN Master.Warehouse W ON P.ID = W.ProductsID 
		WHERE ReceivingDate >= @date
			AND EndVersion = 999999999 