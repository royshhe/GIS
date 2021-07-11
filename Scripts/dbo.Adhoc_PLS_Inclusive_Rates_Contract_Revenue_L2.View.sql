USE [GISData]
GO
/****** Object:  View [dbo].[Adhoc_PLS_Inclusive_Rates_Contract_Revenue_L2]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Adhoc_PLS_Inclusive_Rates_Contract_Revenue_L2]
AS
SELECT     dbo.Location.Location, dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.RBR_Date, 
                      dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.Contract_Number, dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.Contract_Rental_Days, 
                      dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.Charge_description, dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.OptionalExtraType, 
                      dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.Amount, dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.GSTAmt, 
                      dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.PSTAmt, dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.PVRTAmt
FROM         dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue INNER JOIN
                      dbo.Location ON dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.Pick_Up_Location_ID = dbo.Location.Location_ID
WHERE     (dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.RBR_Date >= '2005-04-01') AND 
                      (dbo.Adhoc_PLS_Inclusive_Rates_Contract_Revenue.RBR_Date < '2005-05-01')
GO
