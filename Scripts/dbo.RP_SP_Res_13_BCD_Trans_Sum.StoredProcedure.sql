USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_13_BCD_Trans_Sum]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[RP_SP_Res_13_BCD_Trans_Sum]  --'2009-01-01', '2009-01-31'
(
	
	@PUD_Start_Date varchar(10) 	= '01 JUL 2007',
	@PUD_End_Date 	varchar(10) 	= '01 JUL 2007'
)
AS

 --convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime, @PUD_Start_Date+' 00:00:00'),
	@endDate	= CONVERT(datetime,  @PUD_End_Date+' 23:59:59')	



SELECT   BCDTransStat.BCD_Number, 
				BCDTransStat.IATA_Number,
				BCDTransStat.Organization_Name,
				BCDTransStat.Vehicle_Type_ID,
				(Case When BCDTransStat.Tour_Rate_Account=1 Then 'Yes' Else 'No' End) [Tour Rate Account],
                 SUM(BCDTransStat.Rental_Day) as [Rental Days],            

				 SUM(Case when  BCDTransStat.Status='O' then 1
						 Else 0
				End) Opened,

				 SUM(Case when  BCDTransStat.Status='C' then 1
						 Else 0
				End) Canclled,


				 SUM(Case when  BCDTransStat.Status='N' then 1
						 Else 0
				End) NoShows,

				 SUM(Case when  BCDTransStat.Status='O' then 1
						 Else 0
				End) +

				 SUM(Case when  BCDTransStat.Status='N' then 1
						 Else 0
				End) [Show+NS],
               SUM(Case When Confirmation_Number is Null Then 1 Else 0 End) Walkup,
				SUM(BCDTransStat.TnK) TnM, 	
				SUM(BCDTransStat.Upgrade) as Upgrade,
               Count(*) TotalCount
From 
(
		SELECT   Distinct  BCDTrans.Contract_Number,BCDTrans.Confirmation_Number,BCDTrans.Status, 
				(Case When BCDTrans.Organization_Name is Null or BCDTrans.Organization_Name='' 
						Then BCD.Organization 
						Else  BCDTrans.Organization_Name End) Organization_Name, --BCDTrans.Company_Name, 
				 BCDTrans.BCD_number,BCDTrans.IATA_Number, ConRentalDay.Rental_Day, ConRevenue.TnK, 
				 ConRevenue.Upgrade, ISNULL(Org.Tour_Rate_Account,0) Tour_Rate_Account,
				 BCDTrans.Vehicle_Type_ID
		From
		(
			Select Con.Contract_Number,
				 (CASE	WHEN Con.BCD_Rate_Organization_id IS NOT NULL 
							  THEN Con.Organization 
						WHEN res.BCD_number IS NOT NULL THEN res.Organization 
														ELSE NULL END) AS Organization_Name,  
				 (CASE	WHEN Con.BCD_Rate_Organization_id IS NOT NULL THEN Con.BCD_number 
						WHEN res.BCD_number IS NOT NULL THEN res.BCD_number ELSE NULL END) AS BCD_number,
				 (CASE	WHEN Con.IATA_Number IS NOT NULL THEN Con.IATA_Number
						WHEN res.IATA_Number IS NOT NULL THEN res.IATA_Number ELSE NULL END) AS IATA_Number,
				 Company_Name, Res.Confirmation_Number, Res.Status,
				 (CASE	WHEN Con.Vehicle_Type_ID IS NOT NULL THEN Con.Vehicle_Type_ID
						WHEN res.Vehicle_Type_ID IS NOT NULL THEN res.Vehicle_Type_ID
						ELSE NULL
				  END) as Vehicle_Type_ID
				 
			From
				(SELECT  c.Contract_Number, c.Confirmation_Number,   c.First_Name, c.Last_Name, c.Pick_Up_Location_ID, c.Drop_Off_Location_ID, c.Pick_Up_On, 
						c.Company_Name,   BCD_Rate_Organization.Organization, o.Org_Type,   
						BCD_Rate_Organization.BCD_number , c.BCD_Rate_Organization_ID ,
						c.IATA_Number, vc.Vehicle_Type_ID
					FROM         dbo.Contract AS c WITH (NOLOCK)
					 INNER JOIN
               dbo.Vehicle_Class AS vc ON c.Vehicle_Class_Code = vc.Vehicle_Class_Code
					
					 LEFT OUTER JOIN
							  dbo.Organization AS o ON o.Organization_ID = c.Referring_Organization_ID LEFT OUTER JOIN
							  dbo.Organization AS BCD_Rate_Organization ON BCD_Rate_Organization.Organization_ID = c.BCD_Rate_Organization_ID 
					Where c.Pick_Up_On>=@startDate and  c.Pick_Up_On<=@endDate
				) Con

				FULL OUTER JOIN
					(SELECT     dbo.Reservation.Confirmation_Number, dbo.Reservation.Status,
						(Case WHEN dbo.Reservation.BCD_Number is not null  Then dbo.Reservation.BCD_Number Else BCDOrg.BCD_Number End) BCD_Number, 
							dbo.Reservation.IATA_Number, dbo.Organization.Organization,vc.Vehicle_Type_ID
						FROM          dbo.Reservation 
						INNER JOIN
						dbo.Vehicle_Class AS vc ON dbo.Reservation.Vehicle_Class_Code = vc.Vehicle_Class_Code
               
						LEFT OUTER JOIN
											   dbo.Organization ON dbo.Reservation.BCD_Number = dbo.Organization.BCD_Number
                                          LEFT OUTER JOIN   dbo.Organization BCDOrg on  dbo.Reservation.BCD_Rate_Org_ID=BCDOrg.Organization_ID
						Where dbo.Reservation.Pick_Up_On>=@startDate and  dbo.Reservation.Pick_Up_On<=@endDate
					) Res    ON 
							con.Confirmation_Number = Res.Confirmation_Number


		WHERE    
							  (Con.BCD_Number  IS Not Null) Or
							  (Res.BCD_Number  IS Not NUll)

		 ) BCDTrans LEFT OUTER JOIN
							  dbo.Contract_Charge_Sum_vw  ConRevenue ON BCDTrans.Contract_Number =ConRevenue.Contract_Number
						LEFT OUTER JOIN dbo.Contract_Rental_Days_vw ConRentalDay On BCDTrans.Contract_Number=ConRentalDay.Contract_Number
						LEFT OUTER JOIN [BCD$] BCD on BCDTrans.BCD_number=BCD.BCD_number
						LEFT OUTER JOIN dbo.Organization Org ON BCDTrans.BCD_Number=Org.BCD_Number
					
) BCDTransStat
--WHERE BCDTransStat.BCD_Number IN ('A286000', 'A571600', 'A571601', 'A571900', 'A571603', 'Y492100', 'A376100', 'A312500',
--'A017600', 'A017601', 'A411700')
 
Group by  BCDTransStat.BCD_Number, BCDTransStat.Vehicle_Type_ID,BCDTransStat.IATA_Number,
			  BCDTransStat.Organization_Name, 
			  BCDTransStat.Tour_Rate_Account
order by  BCDTransStat.BCD_Number

GO
