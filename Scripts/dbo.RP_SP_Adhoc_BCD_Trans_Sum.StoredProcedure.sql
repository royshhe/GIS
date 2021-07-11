USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Adhoc_BCD_Trans_Sum]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


				
--drop procedure  RP_SP_Adhoc_MaestroRes_WithBCD_Revenue_Sum
--go

CREATE  procedure  [dbo].[RP_SP_Adhoc_BCD_Trans_Sum] --'2009-01-01', '2009-12-31'
(
	
	@PUD_Start_Date varchar(10) 	= '01 JUL 2007',
	@PUD_End_Date 	varchar(10) 	= '01 JUL 2007'
)
AS


-- convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @PUD_Start_Date),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @PUD_End_Date)	


SELECT     
               BCDTrans.BCD_Number, 
				BCDTrans.IATA_Number,
				(Case when  BCDs.Organization  is not null  Then  BCDs.Organization 
						When dbo.Organization.Organization is not null  Then dbo.Organization.Organization 					
						Else NULL
				End) Organization,   				
				(Case When isnull( dbo.Organization.Tour_Rate_Account,0)=1 Then 'True' Else 'False ' End) Tour_Account,

                 SUM(BCDTrans.Rental_Day) as RentalDays,       

				 SUM(BCDTrans.TnK) TnM,      

				 SUM(Case when  BCDTrans.Status='O' And  BCDTrans.Source_Code='Maestro' then 1
						 Else 0
				End) MaestroOpened,

				 SUM(Case when  BCDTrans.Status='C' And  BCDTrans.Source_Code='Maestro'  then 1
						 Else 0
				End) MaestroCanclled,

				 SUM(Case when  BCDTrans.Status='N' And  BCDTrans.Source_Code='Maestro'  then 1
						 Else 0
				End) MaestroNoShows,

               SUM(Case when  BCDTrans.Status='O' And  BCDTrans.Source_Code<>'Maestro' then 1
						 Else 0
				End) GISOpened,

				 SUM(Case when  BCDTrans.Status='C' And  BCDTrans.Source_Code<>'Maestro'  then 1
						 Else 0
				End) GISCanclled,

				 SUM(Case when  BCDTrans.Status='N' And  BCDTrans.Source_Code<>'Maestro'  then 1
						 Else 0
				End) GISNoShows,
				
				 SUM(Case when  BCDTrans.Confirmation_Number is Null then 1
						 Else 0
				End) WalkUP,
				Count(*) as TotalTrans
--Confirmation_Number,
-- Contract_Number, 
--Count(*)
FROM        
( SELECT               distinct
           
							   Reservation.Confirmation_Number, 
								Reservation.Foreign_Confirm_Number, 
								Reservation.Status, 
								Reservation.Source_Code,
								(Case When Contract.Pick_Up_On is Not Null Then Contract.Pick_Up_On
										  When Reservation.Pick_Up_On is Not Null Then Reservation.Pick_Up_On										 
										 Else NULL
								End) as  Pick_Up_On,
								(Case 
										 When Contract.Drop_Off_On is Not Null Then Contract.Drop_Off_On
										 When Reservation.Drop_Off_On is Not Null Then Reservation.Drop_Off_On
										 Else NULL
								End) as  Drop_Off_On,
								
								 (CASE WHEN (Reservation.BCD_Number IS NOT NULL AND Reservation.BCD_Number <> '') 
															 THEN Reservation.BCD_Number 
											 WHEN (Contract.BCD_Number IS NOT NULL AND Contract.BCD_Number <> '') 
															 THEN Contract.BCD_Number 
											ELSE NULL
								END) AS BCD_Number, 
								 (CASE WHEN (Reservation.IATA_Number IS NOT NULL AND Reservation.IATA_Number <> '') 
															 THEN Reservation.IATA_Number 
											 WHEN (Contract.IATA_Number IS NOT NULL AND Contract.IATA_Number <> '') 
															 THEN Contract.IATA_Number 
											ELSE NULL
								END) AS IATA_Number, 
								Contract.Contract_Number, 
								Contract.Rental_Day, 
								Contract.TnK, 
								Contract.Upgrade
				FROM      
				(
				SELECT     Con.Contract_Number, Con.Pick_Up_On, Con.Drop_Off_On, ConRentalDays.Rental_Day, ConChargeSum.TnK, ConChargeSum.Upgrade, Org.BCD_Number, 
									  Con.Confirmation_Number,con.IATA_Number
				FROM         dbo.Contract AS Con INNER JOIN
									  dbo.Contract_Charge_Sum_vw AS ConChargeSum ON Con.Contract_Number = ConChargeSum.Contract_Number INNER JOIN
									  dbo.Contract_Rental_Days_vw AS ConRentalDays ON Con.Contract_Number = ConRentalDays.Contract_Number LEFT OUTER JOIN
									  dbo.Organization AS Org ON Con.BCD_Rate_Organization_ID = Org.Organization_ID and Org.Inactive=0
									 --where (Con.Pick_Up_On>=@startDate and  Con.Pick_Up_On<=@endDate) --and  BCD_Rate_Organization_ID is not null
				) Contract

				 FULL OUTER JOIN
				(
								  SELECT     Res.Confirmation_Number, Res.Foreign_Confirm_Number, Res.Pick_Up_On, Res.Drop_Off_On, 
								  ( Case When Org.BCD_Number is Not Null Then Org.BCD_Number
											Else		Res.BCD_Number
								  End)  BCD_Number,
									res.IATA_Number,
									 Res.Status, Res.Source_Code

								FROM         dbo.Reservation AS Res LEFT OUTER JOIN	  dbo.Organization AS Org ON Res.BCD_Rate_Org_ID = Org.Organization_ID --and Org.Inactive=0
								where res.Status<>'A' 
								-- where Res.Pick_Up_On>=@startDate and  Res.Pick_Up_On<=@endDate   
--											and  (Res.BCD_Rate_Org_ID is not null or Res.BCD_Number is not null)
				) Reservation on Contract.Confirmation_Number=Reservation.Confirmation_Number
               where (Contract.BCD_Number is not null or Reservation.BCD_Number is not null) 
--And ((Contract.Pick_Up_On>=@startDate and  Contract.Pick_Up_On<=@endDate)  or (Reservation.Pick_Up_On>=@startDate and  Reservation.Pick_Up_On<=@endDate ))
			
)

BCDTrans 

LEFT OUTER JOIN				
					dbo.BCD$ BCDs ON BCDTrans.BCD_Number =  BCDs.BCD_Number LEFT OUTER JOIN
--					dbo.Organization ON substring(BCDTrans.BCD_Number,1,7) = substring(dbo.Organization.BCD_Number,1,7)
 dbo.Organization ON BCDTrans.BCD_Number =dbo.Organization.BCD_Number
				    where BCDTrans.Pick_Up_On>=@startDate and  BCDTrans.Pick_Up_On<=@endDate
-- 
Group by BCDTrans.BCD_Number, BCDTrans.IATA_Number,
				 BCDs.Organization,  dbo.Organization.Organization, 
				dbo.Organization.Tour_Rate_Account
order by BCDTrans.BCD_Number
GO
