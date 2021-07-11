USE [GISData]
GO
/****** Object:  View [dbo].[zTmpWorldFisheries]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[zTmpWorldFisheries]
AS
SELECT     dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Location.Location, dbo.Vehicle_Class.Vehicle_Class_Name, 
                      dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.Flight_Number, dbo.Reservation.IATA_Number, 
                      dbo.Reservation.First_Name, dbo.Reservation.Last_Name
FROM         dbo.Reservation INNER JOIN
                      dbo.Location ON dbo.Reservation.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Reservation.BCD_Rate_Org_ID = 929)

GO
