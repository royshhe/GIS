USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctSalesAccs]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctSalesAccs    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccs    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccs    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccs    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctSalesAccs
PURPOSE: To retrieve all Sales Accessories
AUTHOR: Don Kirkby
DATE CREATED: Aug 12, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns each sales accessory name, unit description,
	and id
PARAMETERS:
	LocId:	sales accessories are available at this location
	ValidOn:	on this date
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctSalesAccs] --'43','11 oct 2012',''
	@LocId		varchar(6),
	@ValidOn 	varchar(24),
	@CtrctNum	varchar(11)
AS
	/* 4/23/99 - cpy comment - this only returns sales accessories that:
				* are valid for this @LocId on @ValidOn date
				  (ie. have an active valid record in sales_accessory_price)
				* have a default price record active during @ValidOn date
				  (ie. have an active valid record in sales_accessory) */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	DECLARE	@dValidOn datetime
	DECLARE	@nLocId SmallInt
	DECLARE	@nCtrctNum Integer

	SELECT	@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))
	SELECT	@nLocId = CONVERT(smallint, NULLIF(@LocId, ''))
	SELECT	@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))

	SELECT	sa.sales_accessory,
		sa.sales_accessory_id,
		sa.unit_description,
		ISNULL(lsa.price, sap.price),
		CONVERT(int, sap.gst_exempt),
		CONVERT(int, sap.pst_exempt)
	  FROM	sales_accessory sa,
		sales_accessory_price sap,
		location_sales_accessory lsa
	 WHERE	sa.delete_flag = 0 and sa.sell_on_contract=1
	   AND	lsa.sales_accessory_id = sa.sales_accessory_id
	   AND	sap.sales_accessory_id = sa.sales_accessory_id
	   AND	lsa.location_id = @nLocId
	   AND	@dValidOn
		BETWEEN lsa.valid_from
		    AND ISNULL(lsa.valid_to, @dValidOn)
	   AND	@dValidOn
		BETWEEN sap.sales_accessory_valid_from
		    AND ISNULL(sap.valid_to, @dValidOn)
	 UNION
	   ALL
	SELECT	sa.sales_accessory,
		sa.sales_accessory_id,
		sa.unit_description,
		csa.price,
		CONVERT(int, csa.gst_exempt),
		CONVERT(int, csa.pst_exempt)
	  FROM	sales_accessory sa,
		contract_sales_accessory csa
	 WHERE	csa.sales_accessory_id = sa.sales_accessory_id
	   AND	csa.contract_number = @nCtrctNum
	   AND	csa.included_in_rate = 'N'
	   AND	sa.sales_accessory_id NOT IN
		(
		SELECT	sa.sales_accessory_id
		  FROM	sales_accessory sa,
			sales_accessory_price sap,
			location_sales_accessory lsa
		 WHERE	sa.delete_flag = 0 and sa.sell_on_contract=1
		   AND	lsa.sales_accessory_id = sa.sales_accessory_id
		   AND	sap.sales_accessory_id = sa.sales_accessory_id
		   AND	lsa.location_id = @nLocId
		   AND	@dValidOn
			BETWEEN lsa.valid_from
			    AND ISNULL(lsa.valid_to, @dValidOn)
		   AND	@dValidOn
			BETWEEN sap.sales_accessory_valid_from
			    AND ISNULL(sap.valid_to, @dValidOn)
		)
	 ORDER
	    BY	1
	RETURN @@ROWCOUNT
GO
