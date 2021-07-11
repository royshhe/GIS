USE [GISData]
GO
/****** Object:  View [dbo].[zTmpViewNavagator2003PST]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[zTmpViewNavagator2003PST]
AS
SELECT     dbo.Vehicle_On_Contract.Contract_Number, dbo.Vehicle_On_Contract.Unit_Number, dbo.Vehicle_Model_Year.Model_Year, 
                      dbo.Vehicle_On_Contract.Checked_Out, dbo.Vehicle_On_Contract.Actual_Check_In, dbo.Contract_Charge_Item.Charge_Item_Type, 
                      dbo.Contract_Charge_Item.Charge_Type, dbo.Contract_Charge_Item.Charge_description, dbo.Contract_Charge_Item.Amount, 
                      dbo.Contract_Charge_Item.GST_Amount, dbo.Contract_Charge_Item.PST_Amount, dbo.Vehicle_Model_Year.Vehicle_Model_ID, 
                      dbo.Vehicle_Model_Year.Model_Name
FROM         dbo.Vehicle_On_Contract INNER JOIN
                      dbo.Vehicle ON dbo.Vehicle_On_Contract.Unit_Number = dbo.Vehicle.Unit_Number INNER JOIN
                      dbo.Vehicle_Model_Year ON dbo.Vehicle.Vehicle_Model_ID = dbo.Vehicle_Model_Year.Vehicle_Model_ID INNER JOIN
                      dbo.Contract_Charge_Item ON dbo.Vehicle_On_Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number
WHERE     (dbo.Contract_Charge_Item.Charge_Type = 10) AND (dbo.Contract_Charge_Item.Charge_Item_Type = 'c') AND 
                      (dbo.Vehicle_Model_Year.Model_Name LIKE '%navigator%') AND (dbo.Vehicle_Model_Year.Model_Year = '2003') AND 
                      (dbo.Contract_Charge_Item.Charge_Item_Type = 'c') OR
                      (dbo.Contract_Charge_Item.Charge_description = 'Vehicle Rental') AND (dbo.Contract_Charge_Item.Charge_Item_Type = 'c') AND 
                      (dbo.Vehicle_Model_Year.Model_Name LIKE '%navigator%') AND (dbo.Vehicle_Model_Year.Model_Year = '2003') AND 
                      (dbo.Contract_Charge_Item.Charge_Item_Type = 'c')

GO
