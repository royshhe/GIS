USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_Local_Sales_BCD_Trans_Sum]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[RP_SP_Con_Local_Sales_BCD_Trans_Sum]   --  '2008-01-01', '2009-06-30'
(
	
	@PUD_Start_Date varchar(10) 	= '01 JUL 2007',
	@PUD_End_Date 	varchar(10) 	= '01 JUL 2007'
)
AS

 --convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @PUD_Start_Date),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @PUD_End_Date)	



SELECT   rtrim(ltrim(BCDTransStat.BCD_Number)), 
--				BCDTransStat.Organization_Name,
--				BCDTransStat.Company_Name,
--				(Case When BCDTransStat.Tour_Rate_Account=1 Then 'Yes' Else 'No' End) [Tour Rate Account],
--                 SUM(BCDTransStat.Rental_Day) as [Rental Days],            
--
--				 SUM(Case when  BCDTransStat.Status='O' then 1
--						 Else 0
--				End) Opened,
--
--				 SUM(Case when  BCDTransStat.Status='C' then 1
--						 Else 0
--				End) Canclled,
--
--
--				 SUM(Case when  BCDTransStat.Status='N' then 1
--						 Else 0
--				End) NoShows,
--
--				 SUM(Case when  BCDTransStat.Status='O' then 1
--						 Else 0
--				End) +
--
--				 SUM(Case when  BCDTransStat.Status='N' then 1
--						 Else 0
--				End) [Show+NS],
--               SUM(Case When Confirmation_Number is Null Then 1 Else 0 End) Walkup,
				SUM(BCDTransStat.TnK) TnM
                --, 	
--				SUM(BCDTransStat.Upgrade) as Upgrade,
--               Count(*) TotalCount
From 
(
		SELECT    BCDTrans.Contract_Number,BCDTrans.Confirmation_Number,BCDTrans.Status, 
		(Case When LocalSalesBCD.Account is not null then LocalSalesBCD.Account
--				  When  BCDTrans.Organization_Name is Null or BCDTrans.Organization_Name=''  Then BCD.Organization 
				 Else  BCDTrans.Organization_Name End
         ) Organization_Name,
		 BCDTrans.Company_Name, 
		(Case When BCDTrans.BCD_number is not null then BCDTrans.BCD_number Else LocalSalesBCD.BCD_Number End) as BCD_Number, ConRentalDay.Rental_Day, ConRevenue.TnK, ConRevenue.Upgrade, Org.Tour_Rate_Account
		From
		(
		Select Con.Contract_Number, (CASE WHEN Con.BCD_Rate_Organization_id IS NOT NULL 
							  THEN Con.Organization WHEN res.BCD_number IS NOT NULL THEN res.Organization ELSE NULL END) AS Organization_Name,  
							  (CASE WHEN Con.BCD_Rate_Organization_id IS NOT NULL THEN Con.BCD_number WHEN res.BCD_number IS NOT NULL 
							  THEN res.BCD_number ELSE NULL END) AS BCD_number, Company_Name,
				Res.Confirmation_Number, Res.Status From
				(
				 SELECT  c.Contract_Number, c.Confirmation_Number,   c.First_Name, c.Last_Name, c.Pick_Up_Location_ID, c.Drop_Off_Location_ID, c.Pick_Up_On, 
				 c.Company_Name,   BCD_Rate_Organization.Organization,   BCD_Rate_Organization.BCD_number , c.BCD_Rate_Organization_ID 
				FROM         dbo.Contract AS c WITH (NOLOCK)  LEFT OUTER JOIN
									  dbo.Organization AS BCD_Rate_Organization ON BCD_Rate_Organization.Organization_ID = c.BCD_Rate_Organization_ID 
				 Where c.Pick_Up_On>=@startDate and  c.Pick_Up_On<=@endDate
				  and (			BCD_Rate_Organization.BCD_Number  in (select BCD_Number from LocalSalesBCD)  or
									(c.Company_Name in (select rtrim( ltrim(Account)) from LocalSalesBCD) ) or
									(c.Confirmation_Number  
											in 
											( SELECT     dbo.Reservation.Confirmation_Number
												FROM          dbo.Reservation 
												Where (dbo.Reservation.Pick_Up_On>=@startDate and  dbo.Reservation.Pick_Up_On<=@endDate) 
													and   (dbo.Reservation.BCD_Number  in (select BCD_Number from LocalSalesBCD))
											)
									  )
									or 
								  (BCD_Rate_Organization.Organization in (select rtrim( ltrim(Account)) from LocalSalesBCD))
						
                         )
		                  
				) Con

				LEFT OUTER JOIN
				  (SELECT     dbo.Reservation.Confirmation_Number, dbo.Reservation.Status, dbo.Reservation.BCD_Number, dbo.Organization.Organization
								FROM          dbo.Reservation LEFT OUTER JOIN
													   dbo.Organization ON dbo.Reservation.BCD_Number = dbo.Organization.BCD_Number
				 --  Where (dbo.Reservation.Pick_Up_On>=@startDate and  dbo.Reservation.Pick_Up_On<=@endDate) and   (dbo.Reservation.BCD_Number  in (select BCD_Number from LocalSalesBCD))

					 ) Res ON 
						  con.Confirmation_Number = Res.Confirmation_Number
--                   Left Join LocalSalesBCD on BCDTrans.Company_Name =LocalSalesBCD.Account
									
				 ) BCDTrans LEFT OUTER JOIN
							  dbo.Contract_Charge_Sum_vw  ConRevenue ON BCDTrans.Contract_Number =ConRevenue.Contract_Number
						LEFT OUTER JOIN dbo.Contract_Rental_Days_vw ConRentalDay On BCDTrans.Contract_Number=ConRentalDay.Contract_Number
--						LEFT OUTER JOIN [BCD$] BCD on BCDTrans.BCD_number=BCD.BCD_number
						LEFT OUTER JOIN dbo.Organization Org ON BCDTrans.BCD_Number=Org.BCD_Number
						Left Join LocalSalesBCD on BCDTrans.Company_Name =LocalSalesBCD.Account
					
) BCDTransStat  
 
Group by  BCDTransStat.BCD_Number--,
--			  BCDTransStat.Organization_Name, 
--			  BCDTransStat.Company_Name
--			  BCDTransStat.Tour_Rate_Account



 
GO
