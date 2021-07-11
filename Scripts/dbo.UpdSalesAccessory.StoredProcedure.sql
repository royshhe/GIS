USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdSalesAccessory]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdSalesAccessory    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.UpdSalesAccessory    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdSalesAccessory    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdSalesAccessory    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Sales_Accessory table .
MOD HISTORY:
Name    Date        	Comments
NP	Jan/12/2000	Add audit info.
*/
/* Oct 26 - Moved the data conversion out of the where clause */
CREATE PROCEDURE [dbo].[UpdSalesAccessory]
	@SalesAccessoryID		VarChar(10),
	@SalesAccessory		VarChar(20),
	@UnitDescription		VarChar(20),
	@GLRevenueAccount	VarChar(32),
	@LastUpdatedBy		VarChar(20)
AS
	Declare @nSalesAccessoryID SmallInt

	Select @nSalesAccessoryID = CONVERT(SmallInt, NULLIF(@SalesAccessoryID, ''))

	UPDATE	Sales_Accessory

	SET	Sales_Accessory		= NULLIF(@SalesAccessory, ''),
		Unit_Description		= NULLIF(@UnitDescription, ''),
		GL_Revenue_Account	= NULLIF(@GLRevenueAccount, ''),
		Last_Updated_By		= @LastUpdatedBy,
		Last_Updated_On		= GetDate()

	WHERE	Sales_Accessory_ID	= @nSalesAccessoryID

RETURN @nSalesAccessoryID















GO
