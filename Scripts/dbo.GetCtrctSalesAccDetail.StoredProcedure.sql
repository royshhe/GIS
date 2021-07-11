USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctSalesAccDetail]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctSalesAccDetail    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccDetail    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccDetail    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccDetail    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctSalesAccDetail
PURPOSE: To retrieve details for a sales accessory at a location
AUTHOR: Don Kirkby
DATE CREATED: Aug 12, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns the price of the sales accessory
PARAMETERS:
	LocId:	location to check for price override
	SalesAccId
	ValidOn:	price is effective on this date
MOD HISTORY:
Name    Date        Comments
Nov 01 - Moved data conversion code with NULLIF out of the where clause
*/

CREATE PROCEDURE [dbo].[GetCtrctSalesAccDetail]
	@LocId		varchar(6),
	@SalesAccId	varchar(6),
	@ValidOn 	varchar(24)
AS
	DECLARE @dValidOn datetime
	DECLARE @nSalesAccId SmallInt
	DECLARE @nLocId SmallInt

	SELECT	@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))
	SELECT	@nSalesAccId = CONVERT(smallint, NULLIF(@SalesAccId, ''))
	SELECT	@nLocId = CONVERT(smallint, NULLIF(@LocId, ''))
	
	SELECT	ISNULL(lsa.price, sap.price)
	  FROM	sales_accessory_price sap,
		location_sales_accessory lsa
	 WHERE	lsa.sales_accessory_id = @nSalesAccId
	   AND	sap.sales_accessory_id = lsa.sales_accessory_id
	   AND	lsa.location_id = @nLocId
	   AND	@dValidOn
		BETWEEN lsa.valid_from
		    AND ISNULL(lsa.valid_to, @dValidOn)
	   AND	@dValidOn
		BETWEEN sap.sales_accessory_valid_from
		    AND ISNULL(sap.valid_to, @dValidOn)
	RETURN @@ROWCOUNT













GO
