USE [GISData]
GO
/****** Object:  View [dbo].[adhoc_Expedia_Active_res]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[adhoc_Expedia_Active_res]
AS
SELECT     dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, DropOffLoc.Location AS DropOffLocatioin, 
                      PickupLoc.Location AS PickupLocation, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.First_Name, 
                      dbo.Reservation.Last_Name, dbo.Reservation.BCD_Number, dbo.Reservation.Coupon_Code, dbo.Quoted_Vehicle_Rate.Rate_Name, 
                      dbo.Quoted_Vehicle_Rate.Authorized_DO_Charge AS DropOffCharge, ResChgHist.ResMadeTime
FROM         dbo.Reservation LEFT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Reservation.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID LEFT OUTER JOIN
                      dbo.Location PickupLoc ON dbo.Reservation.Pick_Up_Location_ID = PickupLoc.Location_ID LEFT OUTER JOIN
                      dbo.Location DropOffLoc ON dbo.Reservation.Drop_Off_Location_ID = DropOffLoc.Location_ID LEFT OUTER JOIN
                      dbo.RP__Reservation_Make_Time ResChgHist ON ResChgHist.Confirmation_Number = dbo.Reservation.Confirmation_Number
WHERE     (dbo.Reservation.BCD_Number = 'A411700') AND (dbo.Reservation.Status = 'A')
GO
