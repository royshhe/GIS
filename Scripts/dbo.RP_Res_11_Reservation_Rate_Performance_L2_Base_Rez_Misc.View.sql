USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_11_Reservation_Rate_Performance_L2_Base_Rez_Misc]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP_Res_11_Reservation_Rate_Performance_L2_Base_Rez_Misc]
AS
SELECT     Reservation.Source_Code, Vehicle_Class.Vehicle_Type_ID, Reservation.Vehicle_Class_Code, Vehicle_Class.Vehicle_Class_Name, 
                      Location.Owning_Company_ID AS Owning_Company_ID, Owning_Company.Name AS Owning_Company_Name, Reservation.Pick_Up_Location_ID, 
                      Location.Location AS Pick_Up_Location_Name, CONVERT(datetime, CONVERT(varchar(20), DATENAME(day, rch.Changed_On) + ' ' + DATENAME(month, 
                      rch.Changed_On) + ' ' + DATENAME(Year, rch.Changed_On))) AS Booking_Date, CONVERT(datetime, CONVERT(varchar(20), DATENAME(day, Reservation.Pick_Up_On) 
                      + ' ' + DATENAME(month, Reservation.Pick_Up_On) + ' ' + DATENAME(Year, Reservation.Pick_Up_On))) AS Pick_Up_Date, rch.Changed_By AS Operator_Name, 
                      Reservation.Confirmation_Number AS GIS_Confirmation_Number, Reservation.Foreign_Confirm_Number AS Foreign_Confirmation_Number, 
                      Status = CASE WHEN Reservation.Status = 'A' THEN 'Active' WHEN Reservation.Status = 'N' THEN 'No Show' WHEN Reservation.Status = 'O' THEN 'On Contract' WHEN
                       Reservation.Status = 'C' THEN 'Cancelled' END, Reservation.Last_Name + ', ' + Reservation.First_Name AS Renter_Name, 'GIS' AS Rate_Type, Reservation.Rate_ID, 
                      Vehicle_Rate.Rate_Name, Reservation.Rate_Level, Reservation.IATA_Number, Reservation.BCD_Number, Reservation.Res_Booking_City
FROM         Location INNER JOIN
                      Reservation ON Location.Location_ID = Reservation.Pick_Up_Location_ID AND Location.Rental_Location = 1 AND Reservation.Status IN ('N', 'O', 'A', 'C') INNER JOIN
                      Owning_Company ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID INNER JOIN
                      Reservation_Change_History rch ON Reservation.Confirmation_Number = rch.Confirmation_Number AND rch.Changed_On =
                          (SELECT     MIN(Reservation_Change_History.Changed_On)
                            FROM          Reservation_Change_History
                            WHERE      Reservation_Change_History.Confirmation_Number = Reservation.Confirmation_Number) INNER JOIN
                      Vehicle_Class ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      Vehicle_Rate ON Reservation.Rate_ID = Vehicle_Rate.Rate_ID AND Reservation.Date_Rate_Assigned >= Vehicle_Rate.Effective_Date AND 
                      Reservation.Date_Rate_Assigned <= Vehicle_Rate.Termination_Date
UNION ALL
SELECT     Reservation.Source_Code, Vehicle_Class.Vehicle_Type_ID, Reservation.Vehicle_Class_Code, Vehicle_Class.Vehicle_Class_Name, 
                      Location.Owning_Company_ID AS Owning_Company_ID, Owning_Company.Name AS Owning_Company_Name, Reservation.Pick_Up_Location_ID, 
                      Location.Location AS Pick_Up_Location_Name, CONVERT(datetime, CONVERT(varchar(20), DATENAME(day, rch.Changed_On) + ' ' + DATENAME(month, 
                      rch.Changed_On) + ' ' + DATENAME(Year, rch.Changed_On))) AS Create_Date, CONVERT(datetime, CONVERT(varchar(20), DATENAME(day, Reservation.Pick_Up_On) 
                      + ' ' + DATENAME(month, Reservation.Pick_Up_On) + ' ' + DATENAME(Year, Reservation.Pick_Up_On))) AS Pick_Up_Date, rch.Changed_By AS Operator_Name, 
                      Reservation.Confirmation_Number AS GIS_Confirmation_Number, Reservation.Foreign_Confirm_Number AS Foreign_Confirmation_Number, 
                      Status = CASE WHEN Reservation.Status = 'A' THEN 'Active' WHEN Reservation.Status = 'N' THEN 'No Show' WHEN Reservation.Status = 'O' THEN 'On Contract' WHEN
                       Reservation.Status = 'C' THEN 'Cancelled' END, Reservation.Last_Name + ', ' + Reservation.First_Name AS Renter_Name, 'Maestro' AS Rate_Type, 
                      Reservation.Quoted_Rate_ID, Quoted_Vehicle_Rate.Rate_Name, NULL AS Rate_Level, Reservation.IATA_Number, Reservation.BCD_Number, Reservation.Res_Booking_City
FROM         Location INNER JOIN
                      Reservation ON Location.Location_ID = Reservation.Pick_Up_Location_ID AND Location.Rental_Location = 1 AND Reservation.Status IN ('N', 'O', 'A', 'C') AND 
                      Reservation.Source_Code = 'Maestro' INNER JOIN
                      Owning_Company ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID INNER JOIN
                      Reservation_Change_History rch ON Reservation.Confirmation_Number = rch.Confirmation_Number AND rch.Changed_On =
                          (SELECT     MIN(Reservation_Change_History.Changed_On)
                            FROM          Reservation_Change_History
                            WHERE      Reservation_Change_History.Confirmation_Number = Reservation.Confirmation_Number) INNER JOIN
                      Vehicle_Class ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      Quoted_Vehicle_Rate ON Reservation.Quoted_Rate_ID = Quoted_Vehicle_Rate.Quoted_Rate_ID

GO
