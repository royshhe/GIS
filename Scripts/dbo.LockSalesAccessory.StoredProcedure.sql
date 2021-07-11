USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockSalesAccessory]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To lock a sales accessory
AUTHOR: Niem Phan
DATE CREATED: Jan 12, 2000
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockSalesAccessory]
	@SalesAccessoryId varchar(11)
AS

	DECLARE @iSalesAccessoryId SmallInt
	SELECT @iSalesAccessoryId = CAST(NULLIF(@SalesAccessoryId, '') AS SmallInt)

	SELECT	COUNT(*)
	  FROM	Sales_Accessory WITH(UPDLOCK)
	 WHERE	Sales_Accessory_ID = @iSalesAccessoryId




GO
