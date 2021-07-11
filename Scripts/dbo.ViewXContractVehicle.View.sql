USE [GISData]
GO
/****** Object:  View [dbo].[ViewXContractVehicle]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* AND dbo.Vehicle_On_Contract.Actual_Check_In BETWEEN dbo.Vehicle_Licence_History.Attached_On AND dbo.Vehicle_Licence_History.Removed_On


*/
CREATE VIEW [dbo].[ViewXContractVehicle]
AS
SELECT    dbo.Vehicle_On_Contract.Contract_Number, 
dbo.Vehicle_On_Contract.Unit_Number AS VehicleNumber, 
                      dbo.Vehicle_Licence_History.Licence_Plate_Number AS PlateNumber, dbo.Owning_Company.Name AS FleetOwner, 
                      dbo.Vehicle_On_Contract.Km_Out AS MilesOut, dbo.Vehicle_On_Contract.Km_In AS MilesIn,'' as FuelOut, '' as FuelIn, dbo.Vehicle_On_Contract.Checked_Out AS DateOut, 
                      dbo.Vehicle_On_Contract.Actual_Check_In AS DateIn, dbo.Vehicle_On_Contract.Checked_Out AS TimeOut, 
                      dbo.Vehicle_On_Contract.Actual_Check_In AS TimeIn, '' AS FuelUnitCharge, '' AS empid
FROM         dbo.Vehicle_On_Contract INNER JOIN
                      dbo.Vehicle ON dbo.Vehicle_On_Contract.Unit_Number = dbo.Vehicle.Unit_Number INNER JOIN
                      dbo.Owning_Company ON dbo.Vehicle.Owning_Company_ID = dbo.Owning_Company.Owning_Company_ID LEFT OUTER JOIN
                      dbo.Vehicle_Licence_History ON dbo.Vehicle.Unit_Number = dbo.Vehicle_Licence_History.Unit_Number AND 
                      ((dbo.Vehicle_On_Contract.Checked_Out BETWEEN dbo.Vehicle_Licence_History.Attached_On AND dbo.Vehicle_Licence_History.Removed_On) or (dbo.Vehicle_On_Contract.Checked_Out>=dbo.Vehicle_Licence_History.Attached_On and dbo.Vehicle_Licence_History.Removed_On is null))



GO
