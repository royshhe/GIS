USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctSalesAccsByCtrctLong]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*  PURPOSE:		To retrieve all sales accessories, which are not included, for the given contract number.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctSalesAccsByCtrctLong]
	@ContractNum	varchar(11)
AS
	/* 2/18/99 - cpy created - copied GetCtrctSalesAccsByCtrct
				- return sales accessory name */
	/* 3/15/99 - cpy bug fix - add included_in_rate = 'N' */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	DECLARE	@nContractNum Integer
	SELECT	@nContractNum = CONVERT(int, NULLIF(@ContractNum,''))

	SELECT	csa.sales_accessory_id,
		sa.sales_accessory,
		csa.quantity,
		csa.price,
		CONVERT(int, csa.gst_exempt),
		CONVERT(int, csa.pst_exempt)
	  FROM	sales_accessory sa,
		contract_sales_accessory csa
	 WHERE	csa.sales_accessory_id = sa.sales_accessory_id
	   AND	csa.contract_number = @nContractNum
	   AND	csa.included_in_rate = 'N'
	 ORDER BY sales_accessory

	RETURN @@ROWCOUNT
















GO
