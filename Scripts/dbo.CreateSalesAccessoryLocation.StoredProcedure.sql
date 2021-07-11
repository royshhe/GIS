USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSalesAccessoryLocation]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateSalesAccessoryLocation    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccessoryLocation    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccessoryLocation    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccessoryLocation    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Location_Sales_Accessory table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateSalesAccessoryLocation]
	@SalesAccessoryID	VarChar(10),
	@LocationId		VarChar(10),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@Price			VarChar(10),
	@User			VarChar(20)
AS
	If @ValidFrom = ''
		Select @ValidFrom = NULL
	If @ValidTo = ''
		Select @ValidTo = NULL
	If @Price = ''
		Select @Price = NULL
	INSERT INTO Location_Sales_Accessory
		(
		Sales_Accessory_ID,
		Location_ID,
		Valid_From,
		Valid_To,
		Price,
		Last_Changed_By,
		Last_Changed_On
		)
	VALUES
		(
		CONVERT(SmallInt, @SalesAccessoryID),
		CONVERT(SmallInt, @LocationID),
		CONVERT(DateTime, @ValidFrom),
		CONVERT(DateTime, @ValidTo),
		CONVERT(Decimal(9,2), @Price),
		@User,
		GetDate()
		)
RETURN 1













GO
