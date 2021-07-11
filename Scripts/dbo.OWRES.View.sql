USE [GISData]
GO
/****** Object:  View [dbo].[OWRES]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[OWRES]
AS
SELECT     dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, DropOffLoc.Location AS DropOffLocatioin, 
                      PickupLoc.Location AS PickupLocation, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.First_Name, 
                      dbo.Reservation.Last_Name, dbo.Reservation.BCD_Number, dbo.Reservation.Coupon_Code, dbo.Quoted_Vehicle_Rate.Rate_Name, 
                      dbo.Quoted_Vehicle_Rate.Authorized_DO_Charge AS DropOffCharge, ResChgHist.ResMadeTime
FROM         dbo.Reservation INNER JOIN
                      dbo.Location PickupLoc ON dbo.Reservation.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN
                      dbo.Location DropOffLoc ON dbo.Reservation.Drop_Off_Location_ID = DropOffLoc.Location_ID INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Reservation.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID LEFT OUTER JOIN
                          (SELECT     dbo.Reservation_Change_History.Confirmation_Number, MIN(dbo.Reservation_Change_History.Changed_On) AS ResMadeTime
                            FROM          dbo.Reservation_Change_History
                            GROUP BY dbo.Reservation_Change_History.Confirmation_Number) ResChgHist ON 
                      ResChgHist.Confirmation_Number = dbo.Reservation.Confirmation_Number
WHERE     (PickupLoc.Owning_Company_ID = 7425) AND (DropOffLoc.Owning_Company_ID <> 7425) AND (dbo.Reservation.Status = 'A' OR
                      dbo.Reservation.Status = 'O') AND (dbo.Reservation.Foreign_Confirm_Number IS NOT NULL) AND (ResChgHist.ResMadeTime >= '2005-05-26 16:00:00')
             

GO
