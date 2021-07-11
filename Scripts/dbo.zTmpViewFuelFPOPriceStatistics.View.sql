USE [GISData]
GO
/****** Object:  View [dbo].[zTmpViewFuelFPOPriceStatistics]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[zTmpViewFuelFPOPriceStatistics]
AS
SELECT     dbo.Location.Location, dbo.Contract_Charge_Item.Charge_description, SUM(dbo.Contract_Charge_Item.Amount) 
                      / SUM(dbo.Contract_Charge_Item.Quantity) AS UnitPrice, DATEPART([year], dbo.Business_Transaction.Transaction_Date) AS [year], DATEPART([month], 
                      dbo.Business_Transaction.Transaction_Date) AS [month]
FROM         dbo.Contract_Charge_Item INNER JOIN
                      dbo.Business_Transaction ON 
                      dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID INNER JOIN
                      dbo.Location ON dbo.Business_Transaction.Location_ID = dbo.Location.Location_ID
WHERE     (dbo.Contract_Charge_Item.Charge_Type IN (14, 18)) AND (dbo.Business_Transaction.Transaction_Date >= '2001-08-01') AND 
                      (dbo.Contract_Charge_Item.Quantity <> 0) AND (dbo.Contract_Charge_Item.Unit_Type = 'Litres') AND 
                      (dbo.Business_Transaction.Transaction_Description = 'Check In')
GROUP BY dbo.Contract_Charge_Item.Charge_description, DATEPART([year], dbo.Business_Transaction.Transaction_Date), DATEPART([month], 
                      dbo.Business_Transaction.Transaction_Date), dbo.Location.Location

GO
