USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSalesAccessoryPrice]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateSalesAccessoryPrice    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccessoryPrice    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccessoryPrice    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccessoryPrice    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Sales_Accessory_Price table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateSalesAccessoryPrice]
	@SalesAccessoryID	VarChar(10),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@Price			VarChar(10),
	@GSTExempt		VarChar(1),
	@PSTExempt		VarChar(1),
	@User			VarChar(20)
AS
	If @ValidFrom = ''
		Select @ValidFrom = NULL
	If @ValidTo = ''
		Select @ValidTo = NULL
	
	If @Price = ''
		Select @Price = NULL
	INSERT INTO Sales_Accessory_Price
		(
		Sales_Accessory_ID,
		Sales_Accessory_Valid_From,
		Valid_To,
		Price,
		GST_Exempt,
		PST_Exempt,
		Last_Changed_By,
		Last_Changed_On
		)
	VALUES
		(
		CONVERT(SmallInt, @SalesAccessoryID),
		CONVERT(DateTime, @ValidFrom),
		CONVERT(DateTime, @ValidTo),
		CONVERT(Decimal(9,2), @Price),
		CONVERT(Bit, @GSTExempt),
		CONVERT(Bit, @PSTExempt),
		@User,
		GetDate()
		)
RETURN 1













GO
