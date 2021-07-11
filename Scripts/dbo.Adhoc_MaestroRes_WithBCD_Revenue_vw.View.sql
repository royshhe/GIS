USE [GISData]
GO
/****** Object:  View [dbo].[Adhoc_MaestroRes_WithBCD_Revenue_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[Adhoc_MaestroRes_WithBCD_Revenue_vw]
AS
SELECT     dbo.Contract.Contract_Number, dbo.Contract.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, dbo.Reservation.Pick_Up_On, 
                      dbo.Reservation.Drop_Off_On, dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Contract_Rental_Days_vw.Rental_Day AS Contract_Rental_Days, 
                      dbo.RP__Last_Vehicle_On_Contract.Km_In - dbo.RP__Last_Vehicle_On_Contract.Km_Out AS KmDriven, 
                      CASE WHEN (dbo.Contract.Confirmation_Number IS NOT NULL) THEN 0 ELSE 1 END AS Walk_Up, dbo.Contract_Charge_Item.Charge_Type, 
                      dbo.Contract_Charge_Item.Charge_Item_Type, dbo.Contract_Charge_Item.Optional_Extra_ID, dbo.Contract.Reservation_Revenue, 
                      dbo.Contract_Charge_Item.Amount - dbo.Contract_Charge_Item.GST_Amount_Included - dbo.Contract_Charge_Item.PST_Amount_Included - dbo.Contract_Charge_Item.PVRT_Amount_Included
                       AS Amount, dbo.Vehicle_Rate.Rate_Name AS GISRate, dbo.Quoted_Vehicle_Rate.Rate_Name AS MaestroRate, 
                      dbo.Reservation.BCD_Number AS Maestro_BCD, dbo.Reservation.Status, PULoc.Location AS Pickup_Location, DOLOC.Location AS Drop_Off_Location, 
                      dbo.Optional_Extra.Type AS OptionalExtraType
FROM         dbo.Reservation INNER JOIN
                      dbo.Location DOLOC ON dbo.Reservation.Drop_Off_Location_ID = DOLOC.Location_ID LEFT OUTER JOIN
                      dbo.Vehicle_Class INNER JOIN
                      dbo.Contract ON dbo.Vehicle_Class.Vehicle_Class_Code = dbo.Contract.Vehicle_Class_Code INNER JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number INNER JOIN
                      dbo.Contract_Rental_Days_vw ON dbo.Contract.Contract_Number = dbo.Contract_Rental_Days_vw.Contract_Number INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number ON 
                      dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number LEFT OUTER JOIN
                      dbo.Location PULoc ON dbo.Reservation.Pick_Up_Location_ID = PULoc.Location_ID LEFT OUTER JOIN
                      dbo.Vehicle_Rate ON dbo.Contract.Rate_ID = dbo.Vehicle_Rate.Rate_ID AND dbo.Contract.Rate_Assigned_Date BETWEEN 
                      dbo.Vehicle_Rate.Effective_Date AND dbo.Vehicle_Rate.Termination_Date LEFT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Contract.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID LEFT OUTER JOIN
                      dbo.Optional_Extra ON dbo.Contract_Charge_Item.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID AND 
                      dbo.Optional_Extra.Delete_Flag = 0
WHERE  (dbo.Reservation.BCD_Number IS Not NULL) AND 
	(dbo.Reservation.Source_Code = 'Maestro')

GO
