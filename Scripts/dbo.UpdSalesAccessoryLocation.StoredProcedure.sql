USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdSalesAccessoryLocation]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdSalesAccessoryLocation    Script Date: 2/18/99 12:12:06 PM ******/
/****** Object:  Stored Procedure dbo.UpdSalesAccessoryLocation    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdSalesAccessoryLocation    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdSalesAccessoryLocation    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Location_Sales_Accessory table .
MOD HISTORY:
Name    Date        Comments
*/
/* OCt 26 - Moved the data conversion out of the where clause */
CREATE PROCEDURE [dbo].[UpdSalesAccessoryLocation]
	@SalesAccessoryID	VarChar(10),
	@OldLocationId		VarChar(10),
	@OldValidFrom		VarChar(24),
	@LocationId		VarChar(10),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@Price			VarChar(10),
	@User			VarChar(20)
AS
	Declare	@nSalesAccessoryID SmallInt
	Declare	@nOldLocationID SmallInt
	Declare	@dOldValidFrom DateTime

	Select	@nSalesAccessoryID = CONVERT(SmallInt, NULLIF(@SalesAccessoryID, ''))
	Select	@nOldLocationID = CONVERT(SmallInt, NULLIF(@OldLocationID, ''))
	Select	@dOldValidFrom = CONVERT(DateTime, NULLIF(@OldValidFrom, ''))

	UPDATE	Location_Sales_Accessory
	SET	Location_ID	= CONVERT(SmallInt, NULLIF(@LocationID, '')),
		Valid_From	= CONVERT(DateTime, NULLIF(@ValidFrom, '')),
		Valid_To	= CONVERT(DateTime, NULLIF(@ValidTo, '')),
		Price		= CONVERT(Decimal(9,2), NULLIF(@Price, '')),
		Last_Changed_By	= @User,
		Last_Changed_On	= GetDate()

	WHERE	Sales_Accessory_ID = @nSalesAccessoryID
	AND		Location_ID = @nOldLocationID
	AND		Valid_From = @dOldValidFrom

RETURN 1














GO
