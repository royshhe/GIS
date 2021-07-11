USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctSalesAccsByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctSalesAccsByCtrct    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccsByCtrct    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccsByCtrct    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctSalesAccsByCtrct    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctSalesAccsByCtrct
PURPOSE: To retrieve all Sales Accessories for a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 12, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns each sales accessory name, unit description,
	and id
PARAMETERS:
	CtrctNum
MOD HISTORY:

Name    Date        Comments
Don K	04 Sep 1998 Filtered out records that are included in the rate.
Nov 01 - Moved data conversion code with NULLIF out of the where clause
*/

CREATE PROCEDURE [dbo].[GetCtrctSalesAccsByCtrct]
	@CtrctNum	varchar(11)
AS
	DECLARE	@nCtrctNum Integer
	SELECT	@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))

	SELECT	csa.sales_accessory_id,
		csa.sales_accessory_id,
		csa.quantity,
		csa.price,
		CONVERT(int, csa.gst_exempt),
		CONVERT(int, csa.pst_exempt)
	  FROM	sales_accessory sa,
		contract_sales_accessory csa
	 WHERE	csa.sales_accessory_id = sa.sales_accessory_id
	   AND	csa.contract_number = @nCtrctNum
	   AND	csa.included_in_rate = 'N'
	 ORDER
	    BY	sales_accessory
	RETURN @@ROWCOUNT













GO
