USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctInclSalesAccsByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetCtrctInclSalesAccsByCtrct    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInclSalesAccsByCtrct    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInclSalesAccsByCtrct    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInclSalesAccsByCtrct    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctInclSalesAccsByCtrct
PURPOSE: To retrieve all Sales Accessories that are included in the
	rate as well as the quantity requested for a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 28, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns each sales accessory and details
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctInclSalesAccsByCtrct]
	@RateId		varchar(11),
	@LocId		varchar(6),
	@ValidOn 	varchar(24),
	@CtrctNum	varchar(11)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int,
	@iRateId Int,
	@iLocId SmallInt

	SELECT 	@iCtrctNum = CONVERT(int, NULLIF(@CtrctNum, '')),
		@iRateId = CONVERT(int, NULLIF(@RateId, '')),
		@iLocId = CONVERT(smallint, NULLIF(@LocId, ''))

	DECLARE @dValidOn datetime
	SELECT	@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))
	SELECT	sa.sales_accessory + ' ' + sa.unit_description,
		sa.sales_accessory_id,
		isa.quantity included_qty,
		ISNULL(csa.quantity, 0) qty,
		CASE csa.sales_accessory_id
		  WHEN NULL THEN 'N'
		  ELSE 'Y'
		END csa_exists
	  FROM	    sales_accessory sa 
		inner join	location_sales_accessory lsa 
		On lsa.sales_accessory_id = sa.sales_accessory_id
		inner join	included_sales_accessory isa
		On 	isa.sales_accessory_id = sa.sales_accessory_id
		inner join	contract_sales_accessory csa
		On 	 sa.sales_accessory_id= csa.sales_accessory_id
--	   sales_accessory sa,
--		location_sales_accessory lsa,
--		included_sales_accessory isa,
--		contract_sales_accessory csa
	 WHERE	
		--lsa.sales_accessory_id = sa.sales_accessory_id	   AND	
		lsa.location_id = @iLocId
	   AND	(@dValidOn	BETWEEN lsa.valid_from	    AND ISNULL(lsa.valid_to, @dValidOn))
	   --AND	isa.sales_accessory_id = sa.sales_accessory_id
	   AND	isa.rate_id = @iRateId
	   AND	(@dValidOn	BETWEEN	isa.effective_date    AND	isa.termination_date)
	   --AND	csa.sales_accessory_id =* sa.sales_accessory_id
	   AND	csa.contract_number = @iCtrctNum
	   AND	csa.included_in_rate = 'Y'
	 ORDER
	    BY	sales_accessory
	RETURN @@ROWCOUNT
GO
