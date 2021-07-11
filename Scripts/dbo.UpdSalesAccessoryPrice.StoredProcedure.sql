USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdSalesAccessoryPrice]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdSalesAccessoryPrice    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdSalesAccessoryPrice    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdSalesAccessoryPrice    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdSalesAccessoryPrice    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Sales_Accessory_Price table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 18 1999 - Moved NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[UpdSalesAccessoryPrice]
	@SalesAccessoryID	VarChar(10),
	@OldValidFrom		VarChar(24),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@Price			VarChar(10),
	@GSTExempt		VarChar(1),
	@PSTExempt		VarChar(1),
	@User			VarChar(20)
AS
	Declare @nSalesAccessoryID SmallInt
	Select @nSalesAccessoryID = CONVERT(SmallInt, NULLIF(@SalesAccessoryID, ''))

	If @OldValidFrom = ''
		Select @OldValidFrom = NULL
	If @ValidFrom = ''
		Select @ValidFrom = NULL
	If @ValidTo = ''
		Select @ValidTo = NULL
	
	If @Price = ''
		Select @Price = NULL
	UPDATE	Sales_Accessory_Price
	SET	Sales_Accessory_Valid_From	= CONVERT(DateTime, @ValidFrom),
		Valid_To			= CONVERT(DateTime, @ValidTo),
		Price				= CONVERT(Decimal(9,2), @Price),
		GST_Exempt			= CONVERT(Bit, @GSTExempt),
		PST_Exempt			= CONVERT(Bit, @PSTExempt),
		Last_Changed_By			= @User,
		Last_Changed_On			= GetDate()

	WHERE	Sales_Accessory_ID		= @nSalesAccessoryID
	AND	Sales_Accessory_Valid_From	= CONVERT(DateTime, @OldValidFrom)
RETURN 1














GO
