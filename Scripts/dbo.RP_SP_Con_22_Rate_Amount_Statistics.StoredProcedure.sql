USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_22_Rate_Amount_Statistics]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[RP_SP_Con_22_Rate_Amount_Statistics]    --'2017-11-01', '2017-11-20'
    @paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS



DECLARE 	@startDate datetime,
		@endDate datetime 
		 

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	



SELECT --con.Contract_Number, 
 --con.Pick_Up_On, 
 --ci.Charge_Type,
 --ci.Charge_description, 
 --LVOC.Actual_Check_In, 
 ci.Unit_Amount,
 --(Case When ci.Unit_Type='Day' Then '01-Day'
	--  When ci.Unit_Type='Week' Then '02-Week'
	--  When ci.Unit_Type='Month' Then '03-Month'
 --End) Unit_Type, 
 ci.Unit_Type, 
 vc.Alias as Vehicle_Class_Name, 
 count(*) as iCount

 
 --ci.Quantity, 
              
 --ci.Amount, 
 --dbo.GetChargeRentalDays(DATEDIFF(mi, con.Pick_Up_On, 
	--							  ISNULL(LVOC.Actual_Check_In, con.Drop_Off_On)
	--							  )
	--			         ) AS Contract_Rental_Days 
 
FROM  dbo.Contract_Charge_Item AS ci INNER JOIN
   dbo.Contract AS con ON ci.Contract_Number = con.Contract_Number 
   INNER JOIN
   dbo.RP__Last_Vehicle_On_Contract AS LVOC 
   ON ci.Contract_Number = LVOC.Contract_Number
   INNER JOIN
               dbo.Vehicle_Class AS vc ON con.Vehicle_Class_Code = vc.Vehicle_Class_Code

   Inner Join (
		SELECT ci.Contract_Number,
						 max(
							 Case When ci.Unit_Type='Day' Then '01-Day'
								  When ci.Unit_Type='Week' Then '02-Week'
								  When ci.Unit_Type='Month' Then '03-Month'
							 End
							
							) 
					   Unit_Type 
							 	 
		FROM  dbo.Contract_Charge_Item AS ci  
		WHERE  
		  (ci.Charge_Type = 10) 
		  AND ci.Unit_type in ('Hour', 'Day', 'Week', 'Month')
		  AND (ci.Charge_item_type='c')
		--order by ci.Unit_type
		Group by ci.Contract_Number
		)RateType   
   On Con.Contract_number=RateType.Contract_number and 
   --ci.Unit_Type
    (Case When ci.Unit_Type='Day' Then '01-Day'
	  When ci.Unit_Type='Week' Then '02-Week'
	  When ci.Unit_Type='Month' Then '03-Month'
	End)   =RateType.Unit_Type

   
WHERE (con.Pick_Up_On >= @startDate) 
AND (con.Pick_Up_On < @endDate+1) 
AND (ci.Charge_Type = 10)
AND (ci.Charge_item_type='c')
Group by ci.Unit_Type, ci.Unit_Amount, vc.Alias
--order by ci.Contract_number
 
GO
