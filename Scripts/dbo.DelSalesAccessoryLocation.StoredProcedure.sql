USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelSalesAccessoryLocation]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DelSalesAccessoryLocation    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.DelSalesAccessoryLocation    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelSalesAccessoryLocation    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelSalesAccessoryLocation    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Location_Sales_Accessory table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DelSalesAccessoryLocation]
	@SalesAccessoryID	VarChar(10),
	@OldLocationId		VarChar(10),
	@OldValidFrom		VarChar(24)
AS
	
	DELETE	Location_Sales_Accessory
	WHERE	Sales_Accessory_ID = CONVERT(SmallInt, @SalesAccessoryID)
	AND	Location_ID	= CONVERT(SmallInt, @OldLocationID)
	AND	CONVERT(DateTime, CONVERT(VarChar, Valid_From, 111))	=
		CONVERT(DateTime, @OldValidFrom)
RETURN 1













GO
