USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesAccessoryMaint]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSalesAccessoryMaint    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessoryMaint    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessoryMaint    Script Date: 1/11/99 1:03:17 PM ******/
CREATE PROCEDURE [dbo].[GetSalesAccessoryMaint]
	@SalesAccessoryID	VarChar(10)
AS
	SELECT	Sales_Accessory_ID,
		Sales_Accessory,
		Unit_Description,
		GL_Revenue_Account
	FROM	Sales_Accessory
	WHERE	Sales_Accessory_ID	= CONVERT(SmallInt, @SalesAccessoryID)
	AND	Delete_Flag		= 0
RETURN 1












GO
