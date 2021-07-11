USE [GISData]
GO
/****** Object:  View [dbo].[P_Rates_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[P_Rates_vw]
AS

select distinct v.* from 
(
SELECT DISTINCT Vehicle_Rate.Rate_Name
FROM         svbvm032.Geordydata.dbo.Reservation AS Reservation INNER JOIN
                      svbvm032.Geordydata.dbo.Vehicle_Rate AS Vehicle_Rate ON Reservation.Rate_ID = Vehicle_Rate.Rate_ID
WHERE     (Reservation.Status = 'a') AND (Reservation.Pick_Up_On > GETDATE()) AND (Vehicle_Rate.Termination_Date > GETDATE())

Union

SELECT DISTINCT  Vehicle_Rate.Rate_Name
FROM          svbvm032.Geordydata.dbo.Location_Vehicle_Rate_Level  Location_Vehicle_Rate_Level INNER JOIN
                       svbvm032.Geordydata.dbo.Vehicle_Rate Vehicle_Rate ON  Location_Vehicle_Rate_Level.Rate_ID =  Vehicle_Rate.Rate_ID
WHERE     ( Location_Vehicle_Rate_Level.Valid_To > GETDATE()) AND ( Vehicle_Rate.Termination_Date > GETDATE() OR
                       Vehicle_Rate.Termination_Date IS NULL)
Union 
SELECT DISTINCT Vehicle_Rate.Rate_Name
FROM         svbvm032.Geordydata.dbo.Organization_Rate AS Organization_Rate INNER JOIN
                      svbvm032.Geordydata.dbo.Vehicle_Rate AS Vehicle_Rate ON Organization_Rate.Rate_ID = Vehicle_Rate.Rate_ID
WHERE     (Organization_Rate.Termination_Date IS NULL) OR
                      (Organization_Rate.Termination_Date > GETDATE()) AND (Vehicle_Rate.Termination_Date IS NULL OR
                      Vehicle_Rate.Termination_Date > GETDATE()) AND (Organization_Rate.Valid_To > GETDATE() OR
                      Organization_Rate.Valid_To IS NULL)
) v
where V.Rate_Name not in (select Rate_Name from Vehicle_Rate)
GO
