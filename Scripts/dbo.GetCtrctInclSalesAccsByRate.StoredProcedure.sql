USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctInclSalesAccsByRate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctInclSalesAccsByRate    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInclSalesAccsByRate    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInclSalesAccsByRate    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInclSalesAccsByRate    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctInclSalesAccsByRate
PURPOSE: To retrieve all Sales Accessories that are included in the
	rate
AUTHOR: Don Kirkby
DATE CREATED: Aug 28, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns each sales accessory and details
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctInclSalesAccsByRate]
	@RateId		varchar(11),
	@LocId		varchar(6),
	@ValidOn 	varchar(24)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

	DECLARE @dValidOn datetime
	SELECT	@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, '')),
		@RateId = NULLIF(@RateId, ''),
		@LocId = NULLIF(@LocId, '')
	SELECT	sa.sales_accessory + ' ' + sa.unit_description,
		sa.sales_accessory_id,
		isa.quantity included_qty,
		isa.quantity qty,
		'N' csa_exists
	  FROM	sales_accessory sa,
		location_sales_accessory lsa,
		included_sales_accessory isa
	 WHERE	lsa.sales_accessory_id = sa.sales_accessory_id
	   AND	lsa.location_id = CONVERT(smallint, @LocId)
	   AND	@dValidOn
		BETWEEN lsa.valid_from
		    AND ISNULL(lsa.valid_to, @dValidOn)
	   AND	isa.sales_accessory_id = sa.sales_accessory_id
	   AND	isa.rate_id = CONVERT(int, @RateId)
	   AND	@dValidOn
		BETWEEN	isa.effective_date
		    AND	isa.termination_date
	 ORDER
	    BY	sales_accessory

	RETURN @@ROWCOUNT













GO
