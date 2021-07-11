USE [GISData]
GO
/****** Object:  View [dbo].[Adhoc_OneWay_Meeting]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[Adhoc_OneWay_Meeting]
AS
SELECT     dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Contract_Number, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Foreign_Contract_Number, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.First_Name, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Last_Name, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.PickupLoc, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.DropOffLoc, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Unit_Number, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Current_Licence_Plate, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Owning_Company, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Vehicle_Class_Name, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Checked_Out, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Actual_Check_In, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Km_Out, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Km_In, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Contract_Rental_Days, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Confirmation_Number, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.BCD_Number, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.FF_Member_Number, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.IATA_Number, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Rate_Name, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Rate_Level, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Daily_rate, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Addnl_Daily_rate, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Weekly_rate, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Hourly_rate, dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Monthly_rate, 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Rate_Type, dbo.Contract_AirMile_Points_vw.TotalMilePoints, dbo.Contract_Charge_Sum_vw.Upgrade, 
                      dbo.Contract_Charge_Sum_vw.DropOffCharge, dbo.Contract_Charge_Sum_vw.TnK, dbo.Contract_Charge_Sum_vw.FPO, 
                      dbo.Contract_Charge_Sum_vw.Fuel, dbo.Contract_Charge_Sum_vw.Additional_Driver_Charge, dbo.Contract_Charge_Sum_vw.Location_Fee, 
                      dbo.Contract_Charge_Sum_vw.Licence_Fee, dbo.Contract_Charge_Sum_vw.CFC, dbo.Contract_Charge_Sum_vw.All_Seats, 
                      dbo.Contract_Charge_Sum_vw.Driver_Under_Age, dbo.Contract_Charge_Sum_vw.All_Level_LDW, dbo.Contract_Charge_Sum_vw.PAI, 
                      dbo.Contract_Charge_Sum_vw.PEC, dbo.Contract_Charge_Sum_vw.Ski_Rack, dbo.Contract_Charge_Sum_vw.All_Dolly, 
                      dbo.Contract_Charge_Sum_vw.Our_Of_Area, dbo.Contract_Charge_Sum_vw.All_Gates, dbo.Contract_Charge_Sum_vw.Blanket, 
                      dbo.Contract_Charge_Sum_vw.GPS, dbo.Contract_Charge_Sum_vw.Misc, dbo.Contract_Charge_Sum_vw.GST, dbo.Contract_Charge_Sum_vw.PST, 
                      dbo.Contract_Charge_Sum_vw.PVRT, IBCommission.CommissionAount, IBCommission.CommissionType
FROM         dbo.Contract_Vehicle_Rate_Detail_Oneway_vw INNER JOIN
                      dbo.RP_Con_5_Interbranch_L1_Base_1 ON 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Contract_Number = dbo.RP_Con_5_Interbranch_L1_Base_1.Contract_Number INNER JOIN
                      dbo.Contract_Charge_Sum_vw ON 
                      dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Contract_Number = dbo.Contract_Charge_Sum_vw.Contract_Number LEFT OUTER JOIN
                      dbo.Contract_AirMile_Points_vw ON dbo.Contract_Vehicle_Rate_Detail_Oneway_vw.Contract_Number = dbo.Contract_AirMile_Points_vw.Contract_Number
						LEFT OUTER JOIN
                      dbo.IB_Rental_Commision_vw AS IBCommission ON dbo.RP_Con_5_Interbranch_L1_Base_1.Contract_Number = IBCommission.Contract_Number
GO
