USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesAccessoryPriceDates]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSalesAccessoryPriceDates    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessoryPriceDates    Script Date: 2/16/99 2:05:42 PM ******/

/* Oct 20 1999 - return the actual valid from and valid to without truncate the time */

CREATE PROCEDURE [dbo].[GetSalesAccessoryPriceDates]
	@SalesAccessoryID	VarChar(10)
AS
SELECT
--	CONVERT(VarChar, Sales_Accessory_Valid_From, 111),
--	CONVERT(VarChar, Valid_To, 111) Valid_To
	Sales_Accessory_Valid_From,
	Valid_To
FROM
	Sales_Accessory_Price
WHERE
	Sales_Accessory_ID = CONVERT(SmallInt, @SalesAccessoryID)
RETURN 1














GO
