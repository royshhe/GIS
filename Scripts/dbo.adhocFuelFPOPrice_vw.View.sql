USE [GISData]
GO
/****** Object:  View [dbo].[adhocFuelFPOPrice_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[adhocFuelFPOPrice_vw]
AS
SELECT     dbo.Contract_Charge_Item.Charge_description, SUM(dbo.Contract_Charge_Item.Amount) / SUM(dbo.Contract_Charge_Item.Quantity) AS AvgPrice, 
                      YEAR(dbo.Business_Transaction.RBR_Date) AS nYear, MONTH(dbo.Business_Transaction.RBR_Date) AS nMonth, dbo.Location.Location
FROM         dbo.Contract_Charge_Item INNER JOIN
                      dbo.Business_Transaction ON 
                      dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID INNER JOIN
                      dbo.Location ON dbo.Business_Transaction.Location_ID = dbo.Location.Location_ID
WHERE     (dbo.Contract_Charge_Item.Charge_Type IN (14, 18)) AND (dbo.Contract_Charge_Item.Unit_Type = 'Litres') AND 
                      (dbo.Business_Transaction.RBR_Date >= '2003-08-01') AND (dbo.Business_Transaction.RBR_Date < '2004-08-31') AND 
                      (dbo.Location.Location_ID IN (16, 20, 23))
GROUP BY dbo.Contract_Charge_Item.Charge_Type, dbo.Contract_Charge_Item.Charge_description, YEAR(dbo.Business_Transaction.RBR_Date), 
                      MONTH(dbo.Business_Transaction.RBR_Date), dbo.Location.Location
GO
