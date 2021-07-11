USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesAccessoryPrice]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSalesAccessoryPrice    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessoryPrice    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetSalesAccessoryPrice]
	@SalesAccessoryID	VarChar(10),
	@ValidFrom		VarChar(24)
AS
	SELECT	CONVERT(VarChar, Sales_Accessory_Valid_From, 111),
		CONVERT(VarChar, Sales_Accessory_Valid_From, 111),
		CONVERT(VarChar, Valid_To, 111) Valid_To,
		Price,
		CONVERT(VarChar, GST_Exempt) GST_Exempt,
		CONVERT(VarChar, PST_Exempt) PST_Exempt,
		Last_Changed_By,
		CONVERT(VarChar, Last_Changed_On, 111)
	FROM	Sales_Accessory_Price
	WHERE	Sales_Accessory_ID	= CONVERT(SmallInt, @SalesAccessoryID)
	AND	CONVERT(DateTime, CONVERT(VarChar, Sales_Accessory_Valid_From, 111)) =
		CONVERT(DateTime, @ValidFrom)
RETURN 1












GO
