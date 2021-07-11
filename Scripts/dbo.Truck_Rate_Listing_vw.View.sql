USE [GISData]
GO
/****** Object:  View [dbo].[Truck_Rate_Listing_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[Truck_Rate_Listing_vw]
AS
SELECT DISTINCT TOP 100 PERCENT VR.Rate_ID, VR.Rate_Name
FROM  dbo.Vehicle_Rate AS VR INNER JOIN
               dbo.Rate_Vehicle_Class AS VRC ON VR.Rate_ID = VRC.Rate_ID INNER JOIN
               dbo.Vehicle_Class AS VC ON VRC.Vehicle_Class_Code = VC.Vehicle_Class_Code
WHERE (VC.Vehicle_Type_ID = 'Truck') AND (VR.Termination_Date > GETDATE()) AND (VRC.Termination_Date > GETDATE())
ORDER BY VR.Rate_Name
GO
