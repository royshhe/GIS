USE [GISData]
GO
/****** Object:  View [dbo].[zTmpViewMaestroResCancelled]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*ORDER BY dbo.Reservation.Last_Name, dbo.Reservation.First_Name*/
CREATE VIEW [dbo].[zTmpViewMaestroResCancelled]
AS
SELECT DISTINCT 
                      dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Vehicle_Class.Vehicle_Class_Name, 
                      dbo.Reservation.Pick_Up_On, dbo.ViewResCreatedDate.Created, dbo.ViewResCancleDate.Changed_On AS CancelledDate, 
                      dbo.Reservation.First_Name, dbo.Reservation.Last_Name, dbo.Reservation.IATA_Number, dbo.Location.Location
FROM         dbo.Reservation INNER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Location ON dbo.Reservation.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.ViewResCreatedDate ON dbo.Reservation.Confirmation_Number = dbo.ViewResCreatedDate.Confirmation_Number INNER JOIN
                      dbo.ViewResCancleDate ON dbo.Reservation.Confirmation_Number = dbo.ViewResCancleDate.Confirmation_Number
WHERE     (dbo.ViewResCreatedDate.Created >= '2004-02-01') AND (dbo.ViewResCreatedDate.Created < '2004-03-01') AND 
                      (dbo.Reservation.Source_Code = 'Maestro') AND (dbo.Reservation.Status = 'c')


GO
