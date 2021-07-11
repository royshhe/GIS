USE [GISData]
GO
/****** Object:  View [dbo].[FA_Fleet_Amo_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[FA_Fleet_Amo_vw]
AS
SELECT     dbo.Vehicle.Unit_Number, dbo.Vehicle.Serial_Number, dbo.Vehicle_Model_Year.Model_Name, dbo.Vehicle_Model_Year.Model_Year, 
                      dbo.Vehicle_Class.FA_Vehicle_Type_ID, dbo.Vehicle.Lessee_id, dbo.Vehicle.ISD, dbo.Vehicle.OSD, dbo.Vehicle.Program, dbo.Vehicle.Vehicle_Cost, 
                      dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage, 
                      dbo.FA_Vehicle_Amortization.AMO_Amount, dbo.FA_Vehicle_Amortization.InService_Months, dbo.FA_Vehicle_Amortization.Balance, 
                      dbo.Vehicle.Selling_Price, dbo.FA_Vehicle_Amortization.AMO_Month, dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date, 
                      dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date
FROM         dbo.FA_Vehicle_Amortization INNER JOIN
                      dbo.Vehicle ON dbo.FA_Vehicle_Amortization.Unit_Number = dbo.Vehicle.Unit_Number INNER JOIN
                      dbo.Vehicle_Model_Year ON dbo.Vehicle.Vehicle_Model_ID = dbo.Vehicle_Model_Year.Vehicle_Model_ID INNER JOIN
                      dbo.FA_Vehicle_Depreciation_History ON dbo.FA_Vehicle_Amortization.Unit_Number = dbo.FA_Vehicle_Depreciation_History.Unit_Number INNER JOIN
                      dbo.Vehicle_Class ON dbo.Vehicle.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.FA_Vehicle_Amortization.AMO_Month BETWEEN '2008-10-01' AND '2008-10-31')
GO
