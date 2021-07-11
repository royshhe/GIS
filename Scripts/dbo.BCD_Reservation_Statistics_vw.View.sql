USE [GISData]
GO
/****** Object:  View [dbo].[BCD_Reservation_Statistics_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE VIEW [dbo].[BCD_Reservation_Statistics_vw]
AS
SELECT      dbo.Reservation.Confirmation_Number, 
					dbo.Reservation.Foreign_Confirm_Number,   
				    dbo.Reservation.Pick_Up_On, 
					 dbo.Reservation.Drop_Off_On, 
					(CASE WHEN (dbo.Organization.BCD_Number IS NOT NULL and dbo.Organization.BCD_Number <>'') 
                                THEN dbo.Organization.BCD_Number 
                                ELSE dbo.Reservation.BCD_Number 
                    END) AS BCD_Number, 
					dbo.Reservation.Status, 
                    dbo.Contract.Contract_Number, 
                    dbo.Contract_Rental_Days_vw.Rental_Day, 
                    dbo.Contract_Charge_Sum_vw.TnK, 
                    dbo.Contract_Charge_Sum_vw.Upgrade
FROM         dbo.Contract_Charge_Sum_vw INNER JOIN
                    dbo.Contract ON dbo.Contract_Charge_Sum_vw.Contract_Number = dbo.Contract.Contract_Number INNER JOIN
                    dbo.Contract_Rental_Days_vw ON dbo.Contract.Contract_Number = dbo.Contract_Rental_Days_vw.Contract_Number RIGHT OUTER JOIN
                    dbo.Reservation ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number LEFT OUTER JOIN
                    dbo.Organization ON dbo.Reservation.BCD_Rate_Org_ID = dbo.Organization.Organization_ID
WHERE     (dbo.Reservation.BCD_Number IS NOT NULL) OR  (dbo.Reservation.BCD_Rate_Org_ID IS NOT NULL)

GO
