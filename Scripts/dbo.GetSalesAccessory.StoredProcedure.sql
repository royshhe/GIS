USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesAccessory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSalesAccessory    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessory    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessory    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessory    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetSalesAccessory]
@SalesContractNum Varchar(20)
AS
	/* 9/27/99 - do type conversion outside of select */

DECLARE @iSalesCtrctNum Int
	SELECT	@iSalesCtrctNum = CONVERT(int, NULLIF(@SalesContractNum,""))

	SELECT
		Sales_Accessory_ID, Quantity, Amount,
		GST_Exempt, PST_Exempt, GST_Amount,
		PST_Amount, Valid_From
	FROM
		Sales_Accessory_Sale_Item
	WHERE
		Sales_Contract_Number = @iSalesCtrctNum
	
	RETURN @@ROWCOUNT
















GO
