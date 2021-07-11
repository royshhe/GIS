USE [GISData]
GO
/****** Object:  View [dbo].[P_ResChgHistCopy]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[P_ResChgHistCopy]
AS
SELECT     dbo.P_Reservation_Change_History.Confirmation_Number, dbo.P_Reservation_Change_History.Changed_By, dbo.P_Reservation_Change_History.Changed_On, 
                      dbo.P_Reservation_Change_History.Pick_Up_Location_ID, dbo.P_Reservation_Change_History.Pick_Up_On, 
                      dbo.P_Reservation_Change_History.Drop_Off_Location_ID, dbo.P_Reservation_Change_History.Drop_Off_On, 
                      dbo.P_Reservation_Change_History.Vehicle_Class_Code, dbo.P_Reservation_Change_History.Last_Name, dbo.P_Reservation_Change_History.First_Name, 
                      dbo.P_Reservation_Change_History.Rate_ID, dbo.P_Reservation_Change_History.Date_Rate_Assigned, dbo.P_Reservation_Change_History.Rate_Level, 
                      dbo.P_Reservation_Change_History.Status, PLOC.Mnemonic_Code AS PUCode, DLOC.Mnemonic_Code AS DOCode, dbo.VC_Mapping.VC_Code, 
                      dbo.P_Vehicle_Rate.Rate_Name
FROM         dbo.P_Reservation_Change_History INNER JOIN
                      dbo.P_Location AS PLOC ON dbo.P_Reservation_Change_History.Pick_Up_Location_ID = PLOC.Location_ID INNER JOIN
                      dbo.P_Location AS DLOC ON dbo.P_Reservation_Change_History.Drop_Off_Location_ID = DLOC.Location_ID INNER JOIN
                      dbo.P_Vehicle_Rate ON dbo.P_Reservation_Change_History.Rate_ID = dbo.P_Vehicle_Rate.Rate_ID INNER JOIN
                      dbo.VC_Mapping ON dbo.P_Reservation_Change_History.Vehicle_Class_Code = dbo.VC_Mapping.P_VC_Code

GO
