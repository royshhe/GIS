USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_17_CSR_Incentive_Report_L2_CP]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		23 May 2006
--	Details		Sum all items, seperate in different columns (Summary)
--	Modification:		Name:		Date:		Detail:
--			Roy He			2008-01-04      
---------------------------------------------------------------------------------------------------------------------
CREATE View [dbo].[RP_Acc_17_CSR_Incentive_Report_L2_CP]

AS
SELECT
		
	RBR_Date, 	
	--Pick_Up_Location_ID,
(Case When Pick_Up_Location_ID=195 Then 20 When Pick_Up_Location_ID=194 Then 16 Else  Pick_Up_Location_ID End)  Pick_Up_Location_ID ,
   	CSR_Name,
   	Contract_number,
   Customer_Program_Number,
	Applicant_Status_Indicator,
	Confirmation_number,
	Vehicle_Type_ID,
	Walk_up,
	Rate_Name,
	bcd_number,
	Reservation_Revenue,
	
	SUM( CASE 	WHEN Charge_Type IN (10, 11, 20,50, 51, 52)
			THEN Amount
			ELSE 0
			END)  						as Contract_Revenue,
	
	SUM( CASE 	WHEN Charge_Type IN (10, 11,50, 51, 52)
			THEN Amount
			ELSE 0
			END)  						as Contract_TnKm_Revenue,

	
--------------------------------------------------------SALES-------------------------------------------------------------
	
	/*(case when Rate_Purpose<>'Tour Pkg' 
		then Contract_Rental_Days
		else 0
	 end) as Sales_Rental_Days,

        */
	Contract_Rental_Days,
        Rate_Purpose, 	
	
	Sum(case	when charge_type = 20 
			then amount
			else 0
			end)						as Upgrade,	--Include All Upgrade
	

	SUM(CASE	WHEN Charge_Type = 14 and ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											or pick_up_location_id not in ('16','20')  
											)
			THEN Amount
			ELSE 0
			END) 						as FPO,

	SUM(CASE	WHEN Charge_Type = 34 and  ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											or pick_up_location_id not in ('16','20')  
											)
			THEN Amount
			ELSE 0
			END) 						as Additional_Driver_Charge,
	SUM(Case	When Optional_Extra_ID in (1, 2, 3) and  ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											or pick_up_location_id not in ('16','20')  
											)
			Then Amount
			ELSE 0
			END)						as All_Seats,
        -- According to Estella's instruction on June 10, 2004, we will combine UnderAge and AllLdw together 
        -- Leave this alone in case they need.
	SUM(Case	When Optional_Extra_ID in (23, 25) 
			Then Amount
			ELSE 0
			END)						as Driver_Under_Age,
        -- combine here June 10, 2004
       -- Not Combine Any More, It will go to Other Extra Instead	
	/*SUM(Case	When Optional_Extra_ID in (23, 25) and Rate_Purpose<>'Tour Pkg' 
			Then Amount
			ELSE 0
			END)+
           */
--select *from lookup_table where category like '%charge type%'
--select * from contract_charge_item where contract_number=1202990

	SUM(Case When OptionalExtraType IN ('LDW','BUYDOWN') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type = 61 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for LDW
			OR (Charge_Type = 64 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for LDW
			Then Amount
			ELSE 0
			END)						as All_Level_LDW,

--	Case When OptionalExtraType IN ('LDW','BUYDOWN') --and Rate_Purpose<>'Tour Pkg' 
--			OR (Charge_Type = 61 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for LDW
--			Then Contract_Rental_Days
--			ELSE 0
--	END						as LDWDays,
--
--   SUM(Case When OptionalExtraType IN ('LDW','BUYDOWN') --and Rate_Purpose<>'Tour Pkg' 
--			OR (Charge_Type = 61 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for LDW
--			Then Quantity
--			ELSE 0
--			END)						as LDWQty,


	SUM(Case When OptionalExtraType IN ('PAI','PAE') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type = 62 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PAI
			Then Amount
			ELSE 0
			END)						as PAI,
	SUM(Case When OptionalExtraType IN ('PEC','RSN') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type = 63 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
			Then Amount
			ELSE 0
			END)						as PEC,

	 SUM(Case When OptionalExtraType IN ('ELI') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type = 67 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
			Then Amount
			ELSE 0
			END)						as ELI,

              SUM(Case When OptionalExtraType IN ('GPS','PHONE') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type = 68 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
			Then Amount
			ELSE 0
			END)						as GPS,


	SUM(Case	When Optional_Extra_ID in (4, 26) 
			Then Amount
			ELSE 0
			END)						as Ski_Rack,

	SUM(Case	When Optional_Extra_ID in (47) 
			Then Amount
			ELSE 0
			END)						as Seat_Storage,
	SUM(Case	When Optional_Extra_ID in (50,51,52,72,73,74,75) 
			Then Amount
			ELSE 0
			END)						as Our_Of_Area,

	
	SUM(Case	When Optional_Extra_id in (5, 6, 35) and ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											or pick_up_location_id not in ('16','20')  
											)
			Then Amount
			Else 0
			End)		as All_Dolly,

	Sum(Case 	When Optional_Extra_id in (17, 18) and ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											or pick_up_location_id not in ('16','20')  
											)
			Then Amount
			Else 0
			End)						as All_Gates,
	Sum(Case	When Optional_Extra_id = 7 and  ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											or pick_up_location_id not in ('16','20')  
											)
			Then Amount
			Else 0
			End)						as Blanket,
	SUM(Case	When Optional_Extra_ID in (88,89,90) 
			Then Amount
			ELSE 0
			END)						as Snow_Tire,
	SUM(Case	When Optional_Extra_ID in (196,197,198,199,200,201,202,203) 
			Then Amount
			ELSE 0
			END)						as KPO_Package,

-- --------------------------------------------Walk up-------------------------------------------------------------------
	(case when ( Rate_Purpose<>'One Way' and  ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											)
											or pick_up_location_id not in ('16','20')  
											) and Walk_up=1 and rate_name not in ('PROD2011','BLUE','Business Truck','Corporate Rate','Courier','DAVID HALLIDAY','Direct Bill Truck','ICBC2011','JW','Microserve','Movie 2012','Special Events')
		then Contract_Rental_Days
		else 0
	end) as Walkup_Rental_Days, 
	-- Calculation Without Hours
 	SUM( CASE 	WHEN Charge_Type IN (10) and Unit_Type<>'Hour' and Walk_up=1 and(  Rate_Purpose<>'One Way' and  ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											)
											or pick_up_location_id not in ('16','20')  
											 ) and rate_name not in ('PROD2011','BLUE','Business Truck','Corporate Rate','Courier','DAVID HALLIDAY','Direct Bill Truck','ICBC2011','JW','Microserve','Movie 2012','Special Events')
			THEN Amount
			ELSE 0				
			END)  	
	+
	SUM( CASE 	WHEN Charge_Type IN ( 50, 51, 52) and Walk_up=1  and (Rate_Purpose<>'One Way' and  ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											)
											or pick_up_location_id not in ('16','20')  
											) and rate_name not in ('PROD2011','BLUE','Business Truck','Corporate Rate','Courier','DAVID HALLIDAY','Direct Bill Truck','ICBC2011','JW','Microserve','Movie 2012','Special Events')
			THEN Amount
			ELSE 0
			END)  as Walkup_Rental_Time_Revenue,
            

	SUM( CASE 	WHEN Charge_Type IN (11) and Walk_up=1 and (Rate_Purpose<>'One Way' and  ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											)
											or pick_up_location_id not in ('16','20')  
											) and rate_name not in ('PROD2011','BLUE','Business Truck','Corporate Rate','Courier','DAVID HALLIDAY','Direct Bill Truck','ICBC2011','JW','Microserve','Movie 2012','Special Events')
			THEN Amount
			ELSE 0
			END)  						as Walkup_Rental_KM_Charge,


        (CASE 	WHEN  Walk_up=1 and (Rate_Purpose<>'One Way' and  ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											)
											or pick_up_location_id not in ('16','20')  
											) and rate_name not in ('PROD2011','BLUE','Business Truck','Corporate Rate','Courier','DAVID HALLIDAY','Direct Bill Truck','ICBC2011','JW','Microserve','Movie 2012','Special Events')
			THEN 1
			ELSE 0
			END)  						as Walkup_Count,



-- -------------------------------------------------------- FPO-----------------------------------------------------------
        (case when ( (Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											or pick_up_location_id not in ('16','20')  
											)
		then 1
		else 0
	end) as FPO_Contract_Count,

	
	SUM(CASE	WHEN Charge_Type = 14 and  ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											or pick_up_location_id not in ('16','20')  
											) and Amount>0
			THEN 1
			WHEN Charge_Type = 14 and  ((Rate_Purpose<>'Tour Pkg'  or Rate_Purpose is Null)
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
											or pick_up_location_id not in ('16','20')  
											) and Amount<0
			THEN -1
			ELSE 0
			END) 						as FPOCount
	--select * from vehicle_rate where Rate_Name  like 'PBC%'
--select *
FROM 	RP_Acc_17_CSR_Incremental_Yield_L1_CP
--where (((bcd_number<>'A162000' and bcd_number<>'A044300')or (bcd_number is null))
--	 and  rate_name not like 'PBC%' 
--	 and  rate_name not like 'GOC%'
--	 and rate_name <>'14i'
--	 and rate_name<>'01i') and pick_up_location_id  in ('16','20')  --exclude monthly rate
--		--per Greg exclude for new locations
--		or (((bcd_number<>'A162000' and bcd_number<>'A044300')or (bcd_number is null))
--				and  rate_name not like 'PBC%' 
--				and  rate_name not like 'GOC%'
--				and  rate_name not in ('14i','RCM','RCMP')
--				and rate_name<>'01i'
--				and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
--			) 	and  pick_up_location_id not in ('16','20')  
----where   rate_name not like 'PBC%'  and rate_name <>'14i'--exclude monthly rate
----A162000/'PBC%'    BC PROVINCIAL GOVERNMENT
----A044300/'GOC%'   GOVERNMENT OF CANADA
--
--	and rate_name <>'DND' --rate for ASU Chilliwack  Excluded
--	and rate_name <>'ICBC2011' --remove per Greg from March 1st. 2012


GROUP BY 	RBR_Date,
		Pick_Up_Location_ID,
   		CSR_Name,
		Reservation_Revenue,
		Contract_number,
       Customer_Program_Number,
		Applicant_Status_Indicator,
		Confirmation_number,
		Vehicle_Type_ID,
		Walk_up,
		Contract_Rental_Days,
        Rate_Purpose,
		Rate_Name,
		bcd_number
GO
