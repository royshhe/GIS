USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetMilePointsByCtrct]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*
PURPOSE: 
REQUIRES: 
AUTHOR: Roy He
DATE CREATED: Sep 14, 2006
CALLED BY: Schedule Job
MOD HISTORY:
Name    Date        Comments
*/


CREATE PROCEDURE [dbo].[GetMilePointsByCtrct]  --1178560
	@CtrctNum varchar(11)
AS


DECLARE	@nCtrctNum Integer
	SELECT	@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))

Declare @CompanyID varchar(25)

SELECT @CompanyID=Code from dbo.Lookup_Table WHERE (dbo.Lookup_Table.Category = 'BudgetBC Company')


SELECT 	sum(dbo.AM_Contract_TnM_vw.TnM_Amount) AS Sales_Amount, 

	(Case 
			When  CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15) >100 then 100
			Else  CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15)
	End)
	+
	--CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15) +



--
--	(Case   When 
--              (		     Bonus_Offer_Code like '%92'   						
--						AND (dbo.Contract.AM_Coupon_Code in ('DBL-1192','DBL-1292','DBL-1392','DBL-1492'))  
--					    And dbo.Contract.Pick_Up_Location_ID in (16)			
--						And (dbo.AM_Contract_TnM_vw.Rental_Day>=6	 Or  DATEPART(dw, dbo.Contract.Pick_Up_On) in (5,6,7,1))		
--				)	 
--				Or
--				   
--			  (		Bonus_Offer_Code like '%92'   						
--						AND (dbo.Contract.AM_Coupon_Code in ('DBL-2292'))  
--					    And (
--									(dbo.AM_Contract_TnM_vw.Rental_Day>=3	 and  DATEPART(dw, dbo.Contract.Pick_Up_On) in (4,5,6,7))
--								Or
--									(dbo.AM_Contract_TnM_vw.Rental_Day>=5	 and  DATEPART(dw, dbo.Contract.Pick_Up_On) in (2,3,4,5,6,7))
--								)
--				)	                    
--			  THEN  
--				  (Case 
--							When  CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15) >100 then 100
--							Else  CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15)
--					End)
--
--
--		When 
--				 
--					  (		Bonus_Offer_Code like '%93'   						
--								AND (dbo.Contract.AM_Coupon_Code in ('TRI-1193','TRI-1393','TRI-1493'))  
--								And dbo.AM_Contract_TnM_vw.Rental_Day>=3						
--						)
--
--						OR 
--					 
--					  (		Bonus_Offer_Code like '%93'   					
--								AND (dbo.Contract.AM_Coupon_Code in ('TRI-1593','TRI-1693'))  
--								And dbo.Vehicle_Class.Vehicle_Type_ID ='Truck'		
--								And DATEPART(dw, dbo.Contract.Pick_Up_On) in (2,3,4,5,6)
--						)
--					
--						
--
--	      Then 
--				(Case 
--						When  CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15) >100 then 100
--						Else  CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15)
--				End)*2
----CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15)*2
--	      When Bonus_Offer_Code like '%94' 
--	      Then 
--				(Case 
--							When  CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15) >100 then 100
--							Else  CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15)
--				End)*3
--           	
--			When	(Bonus_Offer_Code in ('1013BUDG')						
--				  AND (dbo.Contract.AM_Coupon_Code in ('MCNZ059','UCNZ027','UCNZ025'))  
--			    	  And (	(dbo.AM_Contract_TnM_vw.Rental_Day=3	 and  DATEPART(dw, dbo.Contract.Pick_Up_On) in (5,6,7))
--					Or
--					(dbo.AM_Contract_TnM_vw.Rental_Day=4	 and  DATEPART(dw, dbo.Contract.Pick_Up_On) in (4,5,6,7))
--					)
--				  And upper(dbo.vehicle_class.maestro_code)>='C'
--				)
--				Then 25
--
--
----CONVERT(INT, sum(dbo.AM_Contract_TnM_vw.TnM_Amount) / 15)*3
--              Else 0
--	End)

	(Case
			 When 	ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)=1	
					and (		Bonus_Offer_Code in ('1313BUDG', '1318BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ003','UCNZ004'))  
							or  
								Bonus_Offer_Code in ('1513BUDG', '1518BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ032','UCNZ033'))  
							)	
				or  (ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3	
							And ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)<=4)	
					and 
						(		Bonus_Offer_Code in ('1413BUDG', '1418BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ005','UCNZ006')) 
							or
								Bonus_Offer_Code in ('1613BUDG', '1618BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ034','UCNZ035'))  
							OR
								Bonus_Offer_Code in ('1813BUDG', '1818BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ038','UCNZ039'))  
							or 	
								Bonus_Offer_Code in ('1918BUDG', '1913BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ008','UCNZ007'))  
							OR
								Bonus_Offer_Code in ('1713BUDG', '1718BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ013','MCNZ014'))  
							)	                           
			Then 25

			When 	ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=2
					and (		Bonus_Offer_Code in ('1313BUDG', '1318BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ003','UCNZ004'))  
							or	
								Bonus_Offer_Code in ('1513BUDG', '1518BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ032','UCNZ033'))  
							)	                           
				OR	
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=5
					and (		Bonus_Offer_Code in ('1413BUDG', '1418BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ005','UCNZ006'))  
							or 
								Bonus_Offer_Code in ('1613BUDG', '1618BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ034','UCNZ035'))  
							or	
								Bonus_Offer_Code in ('1813BUDG', '1818BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ038','UCNZ039')) 
							or
								Bonus_Offer_Code in ('1918BUDG', '1913BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ008','UCNZ007'))  	 	
							OR
								Bonus_Offer_Code in ('1713BUDG', '1718BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ013','MCNZ014'))  
						    or 
								Bonus_Offer_Code in ('1118BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ002'))  
							)	                           
			Then 50  
			 When 	ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)=1	
					and (		Bonus_Offer_Code in ('1516BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ009'))  
							)	
				OR
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=2
					and (		Bonus_Offer_Code in ('1616BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ010'))  
							)	                           
				OR
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=1
					and (		Bonus_Offer_Code in ('1916BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ012'))  
							OR
								Bonus_Offer_Code in ('8906BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ011'))  	
							)	                           
				OR
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=1
					and (		Bonus_Offer_Code in ('1416BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ015'))  
							)	                           
				OR
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=1
					and (		Bonus_Offer_Code in ('1316BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ014'))  
							)	                           
				OR
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=1
					and (		Bonus_Offer_Code in ('2114BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ013'))  
							)	                           
				OR
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
					and (		Bonus_Offer_Code in ('1640BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ004'))  
							)	                           
				OR
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
					and (		Bonus_Offer_Code in ('1641BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ005'))  
							)	
			then 40

			 When 	ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=2
					and (		Bonus_Offer_Code in ('1914BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ001'))  
							or  Bonus_Offer_Code in ('1814BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ011')) 
							)	                           
				OR
					(		Bonus_Offer_Code in ( '1714BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ002'))  
								And (	dbo.Vehicle_Class.Vehicle_Type_ID ='Truck'
										 and DATEPART(dw, dbo.Contract.Pick_Up_On) in (2,3,4,5)
										)
								
							)	                           	                        
			then 30

			 When 	ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3	
					and (		Bonus_Offer_Code in ('1912BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ013'))  
							)	
			then 20

			 When 	ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3	
					and (		Bonus_Offer_Code in ('2018BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ007'))  
							)	
			 or 	ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3	
					and (		Bonus_Offer_Code in ('1650BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ002'))  
							)	

			then 50

			 When 	ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3	
					and (		Bonus_Offer_Code in ('2013BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('UCNZ001'))  
							)	
				  OR 
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=1
					and (		Bonus_Offer_Code in ('8906BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ009')) 
							)	   
				  OR
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=6
					and (		Bonus_Offer_Code in ('8906BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ001')) 
							)	 			      		
			then 25

            Else 0
	End)

    + Max(Case When AMPointAdjust.MissingPoints is not Null	 Then AMPointAdjust.MissingPoints
		   Else 0
	  End)

	as Total_Mile_Point

FROM         dbo.Contract WITH(NOLOCK) 
		INNER JOIN dbo.Vehicle_Class WITH(NOLOCK) 
			ON dbo.Contract.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
		INNER JOIN  dbo.Frequent_Flyer_Plan WITH(NOLOCK) 
			ON dbo.Contract.Frequent_Flyer_Plan_ID = dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID 
		INNER JOIN   dbo.AM_Contract_TnM_vw WITH(NOLOCK) 
			ON dbo.Contract.Contract_Number = dbo.AM_Contract_TnM_vw.Contract_Number 
		INNER JOIN dbo.RP__Last_Vehicle_On_Contract WITH(NOLOCK) 
			ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number        
       	INNER JOIN dbo.Location WITH(NOLOCK) 
			ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID 	
		LEFT OUTER JOIN  dbo.Air_Miles_Coupon WITH(NOLOCK) 
			ON dbo.Contract.AM_Coupon_Code=dbo.Air_Miles_Coupon.Coupon_Code and dbo.Contract.Pick_Up_On>=dbo.Air_Miles_Coupon.Effective_Date and  dbo.Contract.Pick_Up_On<=dbo.Air_Miles_Coupon.Termination_date --'2008-12-16'		
		LEFT OUTER JOIN dbo.AM_Contract_Sales_Accessory_vw  SA WITH(NOLOCK) 
			ON dbo.Contract.Contract_Number = SA.Contract_Number 
		LEFT OUTER JOIN	 			 
		(SELECT Contract_Number, Sum(Missing_Points) as MissingPoints
		FROM  dbo.Air_Miles_Points_Adjustment
		where Missing_Points is not null
		Group by  Contract_Number  ) AMPointAdjust
		 ON dbo.Contract.Contract_Number = AMPointAdjust.Contract_Number        

WHERE     (dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan = 'Air Miles') 
	   and dbo.Location.Owning_Company_ID=@CompanyID and dbo.Contract.Pick_Up_On>='2007-01-08' 
	   and dbo.Contract.Contract_number=@nCtrctNum
group by dbo.Contract.Pick_Up_On,dbo.Contract.Contract_number,dbo.Contract.AM_Coupon_Code,
--dbo.AM_Contract_TnM_vw.Rental_Day,
dbo.Contract.Pick_Up_Location_ID,dbo.Vehicle_Class.Vehicle_Type_ID,
dbo.vehicle_class.maestro_code, SA.Amount,Bonus_Offer_Code,dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In








GO
