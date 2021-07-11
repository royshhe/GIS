USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AM_Create_EFT_File]    Script Date: 2021-07-10 1:50:47 PM ******/
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

CREATE   PROCEDURE [dbo].[AM_Create_EFT_File]  --   '12 sep 2017', '12 sep 2017'
	@paramStartDate datetime = '15 April 1999',
	@paramEndDate datetime = '15 April 1999'
AS
--Generate Air Miles EFT Files
Delete Air_Miles_EFT_Header Where Starting_RBR_Date= @paramStartDate and Ending_RBR_Date =@paramEndDate 

Declare @dtToday datetime
Declare @File_Name varchar(13)
Declare @Transaction_Type_Header varchar(2)
Declare @Originator_ID varchar(10)
Declare @File_Creation_Number int

--Transaciton Detail
Declare @Transaction_Type_Detail varchar(2)
Declare @SponsorNumber varchar(4)
Declare @CustomerNumber varchar(4)
Declare @CompanyID varchar(25)


--Header
Select @dtToday=getdate()
Select @Transaction_Type_Header='00'

SELECT    @File_Name= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AMRPEFT') AND (dbo.SystemSettingValues.ValueName = 'FileName')
SELECT    @Originator_ID= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AMRPEFT') AND (dbo.SystemSettingValues.ValueName = 'OriginatorID')

Insert into Air_Miles_EFT_Header
	(
	Starting_RBR_Date ,
	Ending_RBR_Date,
	File_Name,
	Transaction_Type,
	Originator_ID,
	File_CreatetionDate
	)
SELECT  @paramStartDate,
	@paramEndDate, 
	@File_Name,
	@Transaction_Type_Header,
	@Originator_ID,
	@dtToday
 

Select @File_Creation_Number=@@IDENTITY


--Detail
Select @Transaction_Type_Detail='65'

SELECT    @SponsorNumber= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AMRPEFT') AND (dbo.SystemSettingValues.ValueName = 'SponsorNumber')
SELECT    @CustomerNumber= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AMRPEFT') AND (dbo.SystemSettingValues.ValueName = 'CustomerNumber')
SELECT @CompanyID=Code from dbo.Lookup_Table
WHERE (dbo.Lookup_Table.Category = 'BudgetBC Company ') 


Delete Air_Miles_EFT_Detail Where (RBR_Date >= @paramStartDate) and (RBR_Date < @paramEndDate+1) 
	
Insert into Air_Miles_EFT_Detail ( File_Creation_number, Invoice_Number, Business_Transaction_ID, RBR_Date, Customer_Number, Store_Number, Terminal_Number, Transaction_Type, 
                      Card_Number, AMTM_Tran_Type, Entry_Mode, Transaction_Time, Transaction_Date, Payment_Type, Sponsor_Number, Base_Offer_Code, Sales_Amount, 
                      Standard_Mile_Points, Multiply_Factor, Multiplier_Miles, Bonus_Offer_Code, Offer_Quantity, Bonus_Miles, Offer_Type
          )


SELECT @@IDENTITY as File_Creation_Number,
	Right(convert(varchar(15),(dbo.Contract.Contract_Number +10000000)),7) AS Invoice_Number, 
        dbo.AM_Contract_TnM_vw.Business_Transaction_ID, 
	
	(Case When dbo.Air_Miles_Points_Adjustment.RBR_Date is Null then		dbo.AM_Contract_TnM_vw.RBR_Date
			  Else dbo.Air_Miles_Points_Adjustment.RBR_Date
	End) RBR_Date,

	@CustomerNumber as Customer_Number,  
	ltrim(rtrim(dbo.Location.StationNumber)) AS Store_Number, 
	'0001' as Terminla_Number,
	@Transaction_Type_Detail as Transaction_Type,
    Replace
    (
			(CASE WHEN	dbo.Air_Miles_Points_Adjustment .Missing_Number  IS NOT NULL THEN Missing_Number
						ELSE dbo.Contract.FF_Member_Number
			END) ,
       ' ', '')  as Card_Number,
 
	(Case When dbo.AM_Contract_TnM_vw.TnM_Amount>=0 then '00'
	     Else '30'
        End) AS AMTM_Tran_Type, 	

	(Case when dbo.Contract.FF_Swiped=1 then 'S'
	     Else 'M'
	End) AS Entry_Mode,
 
        Right(CONVERT(varchar(3), DATEPART(hh, dbo.AM_Contract_TnM_vw.Transaction_Date)+100),2) + Right(CONVERT(varchar(3), DATEPART(mi, dbo.AM_Contract_TnM_vw.Transaction_Date)+100),2) AS Transaction_Time,				

		Right(CONVERT(varchar(3), DAY(dbo.AM_Contract_TnM_vw.Transaction_Date)+100),2)	+ 
		RIGHT(CONVERT(varchar(3), MONTH(dbo.AM_Contract_TnM_vw.Transaction_Date)+100),2) + 
		RIGHT(CONVERT(varchar(4), YEAR(dbo.AM_Contract_TnM_vw.Transaction_Date)), 2) 
	AS Transaction_Date,
	(Case when Payment_Type='Credit Card' then '3'
	     when Payment_Type='Cash' then '1'
	     Else '1'
	End) as Payment_Type,
	@SponsorNumber as Sponsor_Number,
	'STANDAR2' AS Base_Offer_Code, 
	dbo.AM_Contract_TnM_vw.TnM_Amount AS Sales_Amount, 
	(Case 
			When CONVERT(INT, dbo.AM_Contract_TnM_vw.TnM_Amount / 15) >100 then 100
			Else CONVERT(INT, dbo.AM_Contract_TnM_vw.TnM_Amount / 15) 
	End) AS Mile_Points, 
     1 AS Multiply_Factor, 
	0 AS Multipler_Miles, 

				 
--1 - Sunday
--2 - Monday
--3 - Tuesday
--4 - Wedesday
--5 - Thursday
--6 - Friday
--7 - Saturday

			 
	(Case
			--When 	(		Bonus_Offer_Code in ('1760BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ001'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1760BUDG'  
			 
			
			--When 	(		Bonus_Offer_Code in ('1750BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ002'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=1
			--							)
								
			--				)	                           
			--Then '1750BUDG'  
			
				
			--When 	(		Bonus_Offer_Code in ('1740BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ004'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1740BUDG'  
			
				
			--When 	(		Bonus_Offer_Code in ('1741BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ005'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1741BUDG'  


			--When 	(		Bonus_Offer_Code in ('1761BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ006'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1761BUDG'  


			--When 	(		Bonus_Offer_Code in ('1762BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ008'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1762BUDG'  


			--When 	(		Bonus_Offer_Code in ('1763BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ009'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1763BUDG'  


			--When 	(		Bonus_Offer_Code in ('1764BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ010'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1764BUDG'  


			--When 	(		Bonus_Offer_Code in ('1765BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ011'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1765BUDG'  


			--When 	(		Bonus_Offer_Code in ('1766BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ012'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1766BUDG'  


			--When 	(		Bonus_Offer_Code in ('1767BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ013'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1767BUDG'  
			

			--When 	(		Bonus_Offer_Code in ('1875BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ014'))  
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1875BUDG'  
			

			--When 	(		Bonus_Offer_Code in ('1860BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ003'))
								
			--				)	                           
			--Then '1860BUDG'  
			

			--When 	(		Bonus_Offer_Code in ('1830BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ007'))
								
			--				)	                           
			--Then '1876BUDG'  

			--When 	(		Bonus_Offer_Code in ('1876BUDG')						
			--					AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ016'))
			--					And (
			--								ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--							)
								
			--				)	                           
			--Then '1876BUDG'  
			
			-- 1876BUG 
			When 	(		Bonus_Offer_Code in ('1876BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ( 'MCNZ016'))
								And (
											ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
									)
								AND (dbo.RP__Last_Vehicle_On_Contract.Actual_Vehicle_Class_Code NOT IN ('A', 'L', 'B'))
								
							)	                           
			Then '1876BUDG'  

			 
			

          Else '00000000'
	End) AS BONUS_OFFER_CODE,


	(Case
			 When 	ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=1
					and (	 
								Bonus_Offer_Code in ('1876BUDG')						
								AND (dbo.Contract.AM_Coupon_Code in ('MCNZ016'))  		
								 
						)	
					AND (dbo.RP__Last_Vehicle_On_Contract.Actual_Vehicle_Class_Code NOT IN ('A', 'L', 'B'))                                       
		       Then 1
               Else 0
	End) AS Offer_Quantity,

 

(Case
			 
			-- When 	
			--	 ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=1
			--	 and
			--	 (dbo.Contract_Payment_Item.amount>=75)	
			--	 and
			--		 (Bonus_Offer_Code in ('1830BUDG')						
			-- 				AND (dbo.Contract.AM_Coupon_Code in ('MCNZ007')))
			
			--then 30
			 
			-- When 	  
			--		ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--	    And 
			--	    ( 		
			--				Bonus_Offer_Code in ('1760BUDG','1740BUDG','1741BUDG','1761BUDG', '1762BUDG')						
			--				AND (dbo.Contract.AM_Coupon_Code in ('MCNZ004', 'MCNZ005', 'MCNZ001', 'MCNZ006', 'MCNZ008'))  								
			--	    )	
								   
			--then 40

			--When 	
			--	 ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=1	
			--		and
			--		 (		Bonus_Offer_Code in ('1750BUDG')						
			-- 				AND (dbo.Contract.AM_Coupon_Code in ('MCNZ002'))  
			--		)						

			--then 50

			--When 	
			--	 ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=1
			--	 and
			--	 (dbo.Contract_Payment_Item.amount>=125)	
			--	 and
			--		 (		Bonus_Offer_Code in ('1860BUDG')						
			-- 				AND (dbo.Contract.AM_Coupon_Code in ('MCNZ003'))  
			--		)						

			--then 60

			--When 	
			--	 ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--	 and
			--	 (dbo.RP__Last_Vehicle_On_Contract.Actual_Vehicle_Class_Code NOT IN ('A', 'L', 'B'))
				 
			--	 and
			--	(Bonus_Offer_Code in ('1875BUDG')						
			-- 	 AND (dbo.Contract.AM_Coupon_Code in ('MCNZ014'))  
			--	)						

			--then 75

			--When 	  
			--		ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--	    And 
			--	    ( 		
			--				Bonus_Offer_Code in ('1763BUDG','1764BUDG','1767BUDG','1876BUDG')						
			--				AND (dbo.Contract.AM_Coupon_Code in ('MCNZ009', 'MCNZ010', 'MCNZ013','MCNZ016'))  								
			--	    )	
								   
			--then 75

			--When 	  
			--		ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
			--	    And 
			--	    ( 		
			--				Bonus_Offer_Code in ('1765BUDG','1766BUDG')						
			--				AND (dbo.Contract.AM_Coupon_Code in ('MCNZ011', 'MCNZ012'))  								
			--	    )	
								   
			--then 100


			When 	  
					ROUND(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 0)>=3
				    And 
				    ( 		
							Bonus_Offer_Code in ('1876BUDG')						
							AND (dbo.Contract.AM_Coupon_Code in ('MCNZ016'))  								
				    )	
					AND (dbo.RP__Last_Vehicle_On_Contract.Actual_Vehicle_Class_Code NOT IN ('A', 'L', 'B'))
								   
			then 75
 			

            Else 0
	End) AS   Bonus_Miles,

         
	2 AS Offer_Type

FROM         dbo.Contract 
	INNER JOIN dbo.Vehicle_Class 
		ON dbo.Contract.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
	
	INNER JOIN dbo.AM_Contract_TnM_vw 
		ON dbo.Contract.Contract_Number = dbo.AM_Contract_TnM_vw.Contract_Number 
    INNER JOIN dbo.RP__Last_Vehicle_On_Contract
		ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number 
	INNER JOIN dbo.Location 
		ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID 
	LEFT OUTER JOIN  dbo.Air_Miles_Coupon
		ON dbo.Contract.AM_Coupon_Code=dbo.Air_Miles_Coupon.Coupon_Code and dbo.Contract.Pick_Up_On>=dbo.Air_Miles_Coupon.Effective_Date and  dbo.Contract.Pick_Up_On<=dbo.Air_Miles_Coupon.Termination_date --'2008-12-16'
	LEFT OUTER JOIN dbo.Frequent_Flyer_Plan 
		ON dbo.Contract.Frequent_Flyer_Plan_ID = dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID 

	LEFT OUTER JOIN dbo.AM_Contract_Sales_Accessory_vw  SA
		ON dbo.Contract.Contract_Number = SA.Contract_Number 

	LEFT OUTER JOIN dbo.Contract_Payment_Item 
		ON dbo.Contract.Contract_Number = dbo.Contract_Payment_Item.Contract_Number and dbo.Contract_Payment_Item.Sequence=0
    	LEFT OUTER JOIN
                      dbo.Air_Miles_Points_Adjustment ON dbo.Contract.Contract_Number = dbo.Air_Miles_Points_Adjustment.Contract_Number
	left outer join dbo.air_miles_card 
		on dbo.Contract.FF_Member_Number=dbo.air_miles_card.card_Number

WHERE    ( (
						(dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan = 'Air Miles') AND (dbo.AM_Contract_TnM_vw.Checkin_RBR_Date >= @paramStartDate) and (dbo.AM_Contract_TnM_vw.Checkin_RBR_Date < @paramEndDate+1) 
					   and dbo.Location.Owning_Company_ID=@CompanyID and dbo.Contract.Pick_Up_On>='2007-01-08'  
					   and len(dbo.Contract.FF_Member_Number )=11
					)
                   --- TO INCLUDE THE MISSING NUMBERS
					or 
					(
						dbo.Contract.Contract_Number in  (select contract_Number from dbo.Air_Miles_Points_Adjustment where RBR_Date >= @paramStartDate and RBR_Date< @paramEndDate+1) and Missing_Number is not Null
                    ))
	
Union


--- Missing Points


SELECT @@IDENTITY as File_Creation_Number,
	Right(convert(varchar(15),(dbo.Contract.Contract_Number +10000000)),7) AS Invoice_Number, 
        -- Make it unique
     
max(dbo.AM_Contract_TnM_vw.Business_Transaction_ID)+(select count(*)+1 from Air_Miles_EFT_Detail where Invoice_number= Right(convert(varchar(15),(dbo.AM_Contract_TnM_vw.Contract_Number +10000000)),7)),
	--dbo.AM_Contract_TnM_vw.RBR_Date,
	dbo.Air_Miles_Points_Adjustment.RBR_Date,
	@CustomerNumber as Customer_Number,  
	ltrim(rtrim(dbo.Location.StationNumber)) AS Store_Number, 
	'0001' as Terminla_Number,
	@Transaction_Type_Detail as Transaction_Type,

    replace((
	CASE WHEN	dbo.Air_Miles_Points_Adjustment.Missing_Number IS NOT NULL THEN Missing_Number
				ELSE dbo.Contract.FF_Member_Number
	END),' ','')  as Card_Number,
 
	(Case When Missing_Points>=0 then '00'
	     Else '30'
        End) AS AMTM_Tran_Type, 	

	(Case when dbo.Contract.FF_Swiped=1 then 'S'
	     Else 'M'
	End) AS Entry_Mode,
 
        Right(CONVERT(varchar(3), DATEPART(hh, dbo.Air_Miles_Points_Adjustment.Processed_On)+100),2) + Right(CONVERT(varchar(3), DATEPART(mi, dbo.Air_Miles_Points_Adjustment.Processed_On)+100),2) AS Transaction_Time,				

		Right(CONVERT(varchar(3), DAY(dbo.Air_Miles_Points_Adjustment.Processed_On)+100),2)	+ 
		RIGHT(CONVERT(varchar(3), MONTH(dbo.Air_Miles_Points_Adjustment.Processed_On)+100),2) + 
		RIGHT(CONVERT(varchar(4), YEAR(dbo.Air_Miles_Points_Adjustment.Processed_On)), 2) 
	AS Transaction_Date,
	(Case when Payment_Type='Credit Card' then '3'
	     when Payment_Type='Cash' then '1'
	     Else '1'
	End) as Payment_Type,
	@SponsorNumber as Sponsor_Number,
	'STANDARD' AS Base_Offer_Code, 
	Missing_Points*10 AS Sales_Amount, 
	Missing_Points AS Mile_Points, 
    1 AS Multiply_Factor, 
	0 AS Multipler_Miles, 		
	 '00000000' AS BONUS_OFFER_CODE,
	 0	 AS Offer_Quantity,
	0 AS Bonus_Miles,
	2 AS Offer_Type


FROM         dbo.Contract 
	 
	INNER JOIN dbo.AM_Contract_TnM_vw 
		ON dbo.Contract.Contract_Number = dbo.AM_Contract_TnM_vw.Contract_Number 
	INNER JOIN dbo.Location 
		ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID 
    INNER JOIN
                      dbo.Air_Miles_Points_Adjustment ON dbo.Contract.Contract_Number = dbo.Air_Miles_Points_Adjustment.Contract_Number
	
	LEFT OUTER JOIN dbo.Frequent_Flyer_Plan 
		ON dbo.Contract.Frequent_Flyer_Plan_ID = dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID 

	LEFT OUTER JOIN dbo.Contract_Payment_Item with (nolock)
		ON dbo.Contract.Contract_Number = dbo.Contract_Payment_Item.Contract_Number and dbo.Contract_Payment_Item.Sequence=0

WHERE    ( (
					  (
						   (dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan = 'Air Miles')  
						   OR 
						   (dbo.Contract.Contract_Number in (Select Contract_Number from  Air_Miles_Points_Adjustment where Missing_Number is not null))
					   )
						
					 						
					   and dbo.Location.Owning_Company_ID=@CompanyID and dbo.Contract.Pick_Up_On>='2007-01-08'  
					  
					)
                   And
					
					(
						 dbo.Air_Miles_Points_Adjustment.RBR_Date >= @paramStartDate and dbo.Air_Miles_Points_Adjustment.RBR_Date< @paramEndDate+1 and Missing_Points is not Null
                    ))
	 

GROUP BY dbo.Air_Miles_Points_Adjustment.RBR_Date,
dbo.Contract.Contract_Number,
dbo.AM_Contract_TnM_vw.Contract_Number,
dbo.Location.StationNumber,
dbo.Air_Miles_Points_Adjustment.Missing_Number,
dbo.Contract.FF_Member_Number,
dbo.Air_Miles_Points_Adjustment.Missing_Points,
dbo.Contract.FF_Swiped,
dbo.Air_Miles_Points_Adjustment.Processed_On,	 
dbo.Contract_Payment_Item.Payment_Type
GO
