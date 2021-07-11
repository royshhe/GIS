USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesAccessoryLastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetSalesAccessoryLastUpdated]
	@SalesAccessory VarChar(10)
AS

/*  PURPOSE:		To retrieve the last update date for the given sales accessory number
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
	DECLARE	@iSalesAccessory SmallInt
	SELECT @iSalesAccessory = CONVERT(SmallInt, NULLIF(@SalesAccessory, ''))

	SELECT	
			Sales_Accessory_Id,
			CONVERT(VarChar, Last_Updated_On, 113) Last_Updated_On
	
	FROM		Sales_Accessory

	WHERE	Sales_Accessory_Id = @iSalesAccessory
	
RETURN @@ROWCOUNT


GO
