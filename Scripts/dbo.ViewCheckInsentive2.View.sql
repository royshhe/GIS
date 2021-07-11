USE [GISData]
GO
/****** Object:  View [dbo].[ViewCheckInsentive2]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewCheckInsentive2]
AS
SELECT     dbo.ViewIncentiveUpsellChecking.CSR_Name, dbo.ViewIncentiveUpsellChecking.Contract_number, dbo.Vehicle_Rate.Rate_Name AS ContractRate, 
                      dbo.Reservation.Rate_ID AS ReservationRate, dbo.Contract.Vehicle_Class_Code, 
                      dbo.Vehicle_Class.Vehicle_Class_Name AS ContractVehicleClassName, Vehicle_Class_1.Vehicle_Class_Name AS ReservasionClassName
FROM         dbo.ViewIncentiveUpsellChecking INNER JOIN
                      dbo.Contract ON dbo.ViewIncentiveUpsellChecking.Contract_number = dbo.Contract.Contract_Number INNER JOIN
                      dbo.Reservation ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number INNER JOIN
                      dbo.Vehicle_Class ON dbo.Contract.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Contract.Rate_ID = dbo.Vehicle_Rate.Rate_ID INNER JOIN
                      dbo.Vehicle_Class Vehicle_Class_1 ON dbo.Reservation.Vehicle_Class_Code = Vehicle_Class_1.Vehicle_Class_Code
GO
