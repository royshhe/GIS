USE [GISData]
GO
/****** Object:  View [dbo].[Adhoc_OneWay_Reservation_Rate_Amount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Adhoc_OneWay_Reservation_Rate_Amount]
AS
SELECT DISTINCT 
                      dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, Pickup_Location.Location AS Pickup_Location, 
                      DropOff_Location.Location AS DropOff_location, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.First_Name, 
                      dbo.Reservation.Last_Name, dbo.Vehicle_Classs_Rate_Amount_vw.Time_Period, dbo.Vehicle_Classs_Rate_Amount_vw.Amount, 
                      dbo.Vehicle_Class.Vehicle_Class_Name
FROM         dbo.Reservation INNER JOIN
                      dbo.Vehicle_Classs_Rate_Amount_vw ON dbo.Reservation.Rate_ID = dbo.Vehicle_Classs_Rate_Amount_vw.Rate_ID AND 
                      dbo.Reservation.Rate_Level = dbo.Vehicle_Classs_Rate_Amount_vw.Rate_Level AND 
                      dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Classs_Rate_Amount_vw.Vehicle_Class_Code INNER JOIN
                      dbo.Location Pickup_Location ON dbo.Reservation.Pick_Up_Location_ID = Pickup_Location.Location_ID INNER JOIN
                      dbo.Location DropOff_Location ON dbo.Reservation.Drop_Off_Location_ID = DropOff_Location.Location_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Reservation.Drop_Off_Location_ID IN (15, 19, 149)) AND (dbo.Reservation.Status = 'A') AND (dbo.Reservation.Date_Rate_Assigned BETWEEN 
                      dbo.Vehicle_Classs_Rate_Amount_vw.RPT_Effective_date AND dbo.Vehicle_Classs_Rate_Amount_vw.RTP_Termination_Date) AND 
                      (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.Vehicle_Classs_Rate_Amount_vw.RCA_Effective_Date AND 
                      dbo.Vehicle_Classs_Rate_Amount_vw.RCA_Termination_Date) AND (dbo.Reservation.Date_Rate_Assigned BETWEEN 
                      dbo.Vehicle_Classs_Rate_Amount_vw.RVC_Effective_date AND dbo.Vehicle_Classs_Rate_Amount_vw.RVC_Termination_date) AND 
                      (Pickup_Location.Owning_Company_ID = 7425) AND (dbo.Vehicle_Classs_Rate_Amount_vw.Time_Period = 'day' OR
                      dbo.Vehicle_Classs_Rate_Amount_vw.Time_Period = 'Week') AND (dbo.Vehicle_Classs_Rate_Amount_vw.Time_Period_Start = 1)
UNION
SELECT     dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, Pickup_location.Location AS Pickup_location, 
                      DropOffLocation.Location AS DropOff_Location, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.First_Name, 
                      dbo.Reservation.Last_Name, dbo.Vehicle_Class_NONGIS_Rate_Amount_vw.Time_Period, dbo.Vehicle_Class_NONGIS_Rate_Amount_vw.Amount, 
                      dbo.Vehicle_Class.Vehicle_Class_Name
FROM         dbo.Reservation INNER JOIN
                      dbo.Vehicle_Class_NONGIS_Rate_Amount_vw ON 
                      dbo.Reservation.Quoted_Rate_ID = dbo.Vehicle_Class_NONGIS_Rate_Amount_vw.Quoted_Rate_ID INNER JOIN
                      dbo.Location Pickup_location ON dbo.Reservation.Pick_Up_Location_ID = Pickup_location.Location_ID INNER JOIN
                      dbo.Location DropOffLocation ON dbo.Reservation.Drop_Off_Location_ID = DropOffLocation.Location_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Reservation.Drop_Off_Location_ID IN (15, 19, 149)) AND (dbo.Reservation.Status = 'A') AND Time_Period IN ('day', 'week') AND 
                      Time_Period_Start = 1

GO
