USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetIncludedSalesAccData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To retrieve a list of included sales accessories for a rate
AUTHOR: ?
DATE CREATED: ?
MOD HISTORY:
Name    Date        Comments
Don K	Aug 5 1999  Added price and included amount.
*/
CREATE PROCEDURE [dbo].[GetIncludedSalesAccData]
@RateID varchar(20)
AS
Set Rowcount 2000

DECLARE	@dtNow datetime
SELECT	@dtNow = GETDATE()

Select
	ISA.Sales_Accessory_ID,
	ISA.Sales_Accessory_ID,
	sap.price,
	isa.included_amount,
	ISA.Quantity
From
	Included_Sales_Accessory ISA
JOIN	Sales_Accessory SA
  ON	ISA.Sales_Accessory_ID = SA.Sales_Accessory_ID
LEFT
JOIN	sales_accessory_price sap
  ON	sa.sales_accessory_id = sap.sales_accessory_id
 AND	@dtNow
	BETWEEN sap.sales_accessory_valid_from AND ISNULL(sap.valid_to, @dtNow)
Where
	ISA.Rate_ID = Convert(int, @RateID)
	And ISA.Termination_Date = 'Dec 31 2078 11:59PM'
Order By
	SA.Sales_Accessory + ' - ' + SA.Unit_Description
Return 1






GO
