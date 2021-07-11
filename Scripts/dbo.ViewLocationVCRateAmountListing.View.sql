USE [GISData]
GO
/****** Object:  View [dbo].[ViewLocationVCRateAmountListing]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewLocationVCRateAmountListing]
AS
SELECT     dbo.ViewLocationVehicleRatesListing.Location, dbo.ViewLocationVehicleRatesListing.Vehicle_Class_Name, 
                      dbo.ViewLocationVehicleRatesListing.Location_Vehicle_Rate_Type, dbo.ViewRateVCAmount.Rate_Name, 
                      dbo.ViewLocationVehicleRatesListing.Rate_Level, dbo.ViewLocationVehicleRatesListing.Valid_From, dbo.ViewLocationVehicleRatesListing.Valid_To, 
                      dbo.ViewLocationVehicleRatesListing.Rate_Selection_Type, dbo.ViewRateVCAmount.Time_Period, dbo.ViewRateVCAmount.Time_Period_Start, 
                      dbo.ViewRateVCAmount.Time_period_End, dbo.ViewRateVCAmount.Amount, dbo.ViewRateVCAmount.Type
FROM         dbo.ViewRateVCAmount INNER JOIN
                      dbo.ViewLocationVehicleRatesListing ON dbo.ViewRateVCAmount.Rate_ID = dbo.ViewLocationVehicleRatesListing.Rate_ID AND 
                      dbo.ViewRateVCAmount.Vehicle_Class_Code = dbo.ViewLocationVehicleRatesListing.Vehicle_Class_Code AND 
                      dbo.ViewRateVCAmount.Rate_Level = dbo.ViewLocationVehicleRatesListing.Rate_Level
GO
