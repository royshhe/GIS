USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesAccPriceOverlapCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSalesAccPriceOverlapCount    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccPriceOverlapCount    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccPriceOverlapCount    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccPriceOverlapCount    Script Date: 11/23/98 3:55:34 PM ******/
/* 18/Oct/99 - Modified: Removed conversion to date part only before compare */

CREATE PROCEDURE [dbo].[GetSalesAccPriceOverlapCount]
	@SalesAccessoryID	VarChar(20),
	@ValidFrom		VarChar(24),	
	@OldValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@MaxSmallDateTime	VarChar(24)
AS
	If @ValidTo = ''
		Select @ValidTo = @MaxSmallDateTime
	
	SELECT	Count(*)
	FROM	Sales_Accessory_Price
	WHERE	Sales_Accessory_ID = CONVERT(SmallInt, @SalesAccessoryID)
	AND	Sales_Accessory_Valid_From <> CONVERT(DateTime, @OldValidFrom)
	AND	(
			(
			Sales_Accessory_Valid_From >= CONVERT(DateTime, @ValidFrom)
		  AND	Sales_Accessory_Valid_From <= CONVERT(DateTime, @ValidTo)
			)
		OR	
			(
			Valid_To >= CONVERT(DateTime, @ValidFrom)
		  AND	Valid_To <= CONVERT(DateTime, @ValidTo)
			)

		OR
			(
			Sales_Accessory_Valid_From <= CONVERT(DateTime, @ValidFrom)
		  AND	Valid_To >= CONVERT(DateTime, @ValidTo)
			)
		OR
			(
			Sales_Accessory_Valid_From <= CONVERT(DateTime, @ValidFrom)
		  AND	Valid_To Is Null
			)
		)
RETURN 1














GO
