USE [GISData]
GO
/****** Object:  View [dbo].[ViewContractBaseRate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewContractBaseRate]
AS
SELECT     dbo.Contract.Contract_Number, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, DATEDIFF(mi, 
                      dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 60 AS RentalHours, 
                      dbo.LocationVehicleClassBaseRate.WeekDayBaseRateAmount, dbo.LocationVehicleClassBaseRate.WeekendBaseRateAmount, 
                      dbo.LocationVehicleClassBaseRate.WeeklyBaseRateAmount
FROM         dbo.Contract INNER JOIN
                      dbo.LocationVehicleClassBaseRate ON dbo.Contract.Pick_Up_Location_ID = dbo.LocationVehicleClassBaseRate.LocationID AND 
                      dbo.Contract.Vehicle_Class_Code = dbo.LocationVehicleClassBaseRate.VehicleClassID AND 
                      dbo.Contract.Pick_Up_On >= dbo.LocationVehicleClassBaseRate.EffectiveDate AND 
                      dbo.Contract.Pick_Up_On < dbo.LocationVehicleClassBaseRate.TerminateDate + 1 INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number
WHERE     (dbo.Contract.Status <> 'OP') AND (dbo.Contract.Status <> 'CO')
GO
