USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctSalesAccsByRes]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctSalesAccsByRes    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccsByRes    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccsByRes    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccsByRes    Script Date: 11/23/98 3:55:33 PM ******/
/*  PURPOSE:		To retrieve all sales accessories for the given confirmation number.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctSalesAccsByRes]
	@ConfirmNum	varchar(11),
	@CurrLocId	Varchar(5),
	@CurrDate	Varchar(24)
AS
	DECLARE @dCurrDate Datetime
	DECLARE @dLastDatetime Datetime
	DECLARE @nConfirmNum Integer
	DECLARE @nCurrLocId SmallInt
	
	SELECT	@dCurrDate = Convert(Datetime,
			ISNULL(NULLIF(@CurrDate,""), GetDate()))
	
	SELECT 	@dLastDatetime = Convert(Datetime, "31 DEC 2078 23:59")
	SELECT	@nConfirmNum = CONVERT(int, NULLIF(@ConfirmNum,''))
	SELECT	@nCurrLocId = Convert(SmallInt, NULLIF(@CurrLocId,""))
	
	/* 980925 - cpy - get price according to currdate */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
	
	SELECT	RSA.sales_accessory_id,
		RSA.sales_accessory_id,

		RSA.quantity,
		ISNULL(LSA.price, SAP.price),
		CONVERT(Char(1), SAP.gst_exempt),
		CONVERT(Char(1), SAP.pst_exempt)
	  FROM	Sales_Accessory SA,
		Location_Sales_Accessory LSA,
		Sales_Accessory_Price SAP,
		Reserved_Sales_Accessory RSA
	 WHERE	RSA.Sales_Accessory_ID = SA.Sales_Accessory_ID
	   AND	RSA.Sales_Accessory_ID = SAP.Sales_Accessory_ID
	   AND	RSA.Sales_Accessory_ID = LSA.Sales_Accessory_ID
	   AND	@dCurrDate BETWEEN LSA.Valid_From AND
			ISNULL(LSA.Valid_To, @dLastDatetime)
	   AND	@dCurrDate BETWEEN SAP.Sales_Accessory_Valid_From AND
			ISNULL(SAP.Valid_To, @dLastDatetime)
	   AND	RSA.Confirmation_number =@nConfirmNum
	   AND  LSA.Location_ID = @nCurrLocId
	 ORDER BY SA.sales_accessory
	RETURN @@ROWCOUNT














GO
