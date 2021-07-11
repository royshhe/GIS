USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetIncludedSalesAccessories]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To retrieve a list of sales accessories
AUTHOR: ?
DATE CREATED: ?
MOD HISTORY:
Name    Date        Comments
Don K	Aug 5 1999  Added price information.
*/
CREATE PROCEDURE [dbo].[GetIncludedSalesAccessories]
AS
Set Rowcount 2000

DECLARE	@dtNow datetime
SELECT	@dtNow = GETDATE()

Select
	sa.Sales_Accessory + ' - ' + sa.Unit_Description String,
	sa.Sales_Accessory_ID,
	sap.price
From
	Sales_Accessory sa
LEFT
JOIN	sales_accessory_price sap
  ON	sa.sales_accessory_id = sap.sales_accessory_id
 AND	@dtNow
	BETWEEN sap.sales_accessory_valid_from AND ISNULL(sap.valid_to, @dtNow)
Where
	sa.Delete_Flag=0
Order By
	String
Return 1







GO
