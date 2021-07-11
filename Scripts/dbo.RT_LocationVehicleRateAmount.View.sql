USE [GISData]
GO
/****** Object:  View [dbo].[RT_LocationVehicleRateAmount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
VIEW NAME: RT_Contract_BaseRate_Amount
PURPOSE: Get Rate Amount Listing for each Vehicle Class in each location.	 
AUTHOR:	Roy He
DATE CREATED: 2005/08/01
USED BY: CSR Incentive Report
MOD HISTORY:
Name 		Date		Comments
				is not defined in the lookup table.
*/


CREATE VIEW [dbo].[RT_LocationVehicleRateAmount]
AS
SELECT     dbo.RT_RateAmount_Base.Vehicle_Class_Code, dbo.RT_LocationVehicleRates.Location_ID, 
                      dbo.RT_LocationVehicleRates.Location_Vehicle_Rate_Type, dbo.RT_LocationVehicleRates.Rate_Level, dbo.RT_LocationVehicleRates.Valid_From, 
                      dbo.RT_LocationVehicleRates.Valid_To, dbo.RT_LocationVehicleRates.Rate_Selection_Type, dbo.RT_RateAmount_Base.Time_Period, 
                      dbo.RT_RateAmount_Base.Time_Period_Start, dbo.RT_RateAmount_Base.Time_period_End, dbo.RT_RateAmount_Base.Amount, 
                      dbo.RT_RateAmount_Base.Type, dbo.RT_RateAmount_Base.Rate_ID
FROM         dbo.RT_RateAmount_Base INNER JOIN
                      dbo.RT_LocationVehicleRates ON dbo.RT_RateAmount_Base.Rate_ID = dbo.RT_LocationVehicleRates.Rate_ID AND 
                      dbo.RT_RateAmount_Base.Vehicle_Class_Code = dbo.RT_LocationVehicleRates.Vehicle_Class_Code AND 
                      dbo.RT_RateAmount_Base.Rate_Level = dbo.RT_LocationVehicleRates.Rate_Level



GO
