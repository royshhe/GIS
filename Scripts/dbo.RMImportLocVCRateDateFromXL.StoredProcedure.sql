USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RMImportLocVCRateDateFromXL]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[RMImportLocVCRateDateFromXL]
as
Insert into LocationVehicleRateLevel
SELECT     dbo.Location.Location_ID, dbo.Vehicle_Class.Vehicle_Class_Code, dbo.Vehicle_Rate.Rate_ID, dbo.TmpLocationVehicleRateLevel.Rate_Level, 
                      dbo.TmpLocationVehicleRateLevel.Location_Vehicle_Rate_Type, dbo.TmpLocationVehicleRateLevel.Valid_From, 
                      dbo.TmpLocationVehicleRateLevel.Valid_To, dbo.TmpLocationVehicleRateLevel.Rate_Selection_Type
FROM         dbo.TmpLocationVehicleRateLevel LEFT OUTER JOIN
                      dbo.Location ON dbo.TmpLocationVehicleRateLevel.Location = dbo.Location.Location LEFT OUTER JOIN
                      dbo.Vehicle_Class ON dbo.TmpLocationVehicleRateLevel.Vehicle_Class = dbo.Vehicle_Class.Vehicle_Class_Name LEFT OUTER JOIN
                      dbo.Vehicle_Rate ON dbo.TmpLocationVehicleRateLevel.Rate = dbo.Vehicle_Rate.Rate_Name
WHERE     (dbo.Vehicle_Rate.Termination_Date > GETDATE())

return @@error
GO
