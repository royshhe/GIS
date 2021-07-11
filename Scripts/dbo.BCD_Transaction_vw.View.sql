USE [GISData]
GO
/****** Object:  View [dbo].[BCD_Transaction_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[BCD_Transaction_vw]
AS

-- Get All BCD Related Reservation, Contract Transaction
SELECT  

			   Reservation.Confirmation_Number, 
				Reservation.Foreign_Confirm_Number, 
				Reservation.Status, 
				Reservation.Source_Code,
				(Case When Reservation.Pick_Up_On is Not Null Then Reservation.Pick_Up_On
						 When Contract.Pick_Up_On is Not Null Then Contract.Pick_Up_On
				         Else NULL
				End) as  Pick_Up_On,
				(Case When Reservation.Drop_Off_On is Not Null Then Reservation.Drop_Off_On
						 When Contract.Drop_Off_On is Not Null Then Contract.Drop_Off_On
				         Else NULL
				End) as  Drop_Off_On,
				
				 (CASE WHEN (Reservation.BCD_Number IS NOT NULL AND Reservation.BCD_Number <> '') 
											 THEN Reservation.BCD_Number 
							 WHEN (Contract.BCD_Number IS NOT NULL AND Contract.BCD_Number <> '') 
											 THEN Contract.BCD_Number 
							ELSE NULL
				END) AS BCD_Number, 
                Contract.Contract_Number, 
                Contract.Rental_Day, 
                Contract.TnK, 
                Contract.Upgrade
FROM      
(
SELECT     Con.Contract_Number, Con.Pick_Up_On, Con.Drop_Off_On, ConRentalDays.Rental_Day, ConChargeSum.TnK, ConChargeSum.Upgrade, Org.BCD_Number, 
                      Con.Confirmation_Number
FROM         dbo.Contract AS Con INNER JOIN
                      dbo.Contract_Charge_Sum_vw AS ConChargeSum ON Con.Contract_Number = ConChargeSum.Contract_Number INNER JOIN
                      dbo.Contract_Rental_Days_vw AS ConRentalDays ON Con.Contract_Number = ConRentalDays.Contract_Number LEFT OUTER JOIN
                      dbo.Organization AS Org ON Con.BCD_Rate_Organization_ID = Org.Organization_ID
) Contract

 FULL OUTER JOIN
(
                  SELECT     Res.Confirmation_Number, Res.Foreign_Confirm_Number, Res.Pick_Up_On, Res.Drop_Off_On, 
                  ( Case When Org.BCD_Number is Not Null Then Org.BCD_Number
						    Else		Res.BCD_Number
				  End)  BCD_Number, Res.Status, Res.Source_Code

				FROM         dbo.Reservation AS Res LEFT OUTER JOIN	  dbo.Organization AS Org ON Res.BCD_Rate_Org_ID = Org.Organization_ID
) Reservation on Contract.Confirmation_Number=Reservation.Confirmation_Number





 
GO
