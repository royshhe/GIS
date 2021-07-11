USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Revenue_Sum_vw]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



------------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		06 Aug2005
--	Details		Time, Km charges and LDW total for each contract
--	Modification:		Name:		Date:		Detail:
--
------------------------------------------------------------------------------------------------------------------------
CREATE View [dbo].[Contract_Revenue_Sum_vw]
as
SELECT  RBR_Date, 
First_name,
	Last_name,
Address_1, 
	Address_2, 
	Province_State, 
	Phone_Number,
	Company_Name, 
	Company_Phone_Number, 
	Local_Phone_Number, 
	Local_Address_1, 
    Local_Address_2, 
    Local_City,
City,
Postal_Code,
country,	
Pick_Up_On,
Actual_Check_in,
Contract_Number,    	
PU_Location,
	DO_Location,
	KM_Out,
	KM_In,
	owning_company_id,
	PULoc_OID,
	 DOLoc_OID,
	 unit_number,
	 serial_number,
	 licence_plate_number,
    	Vehicle_Type_ID, 
	Vehicle_Class_Name,
	model_name,
	model_year,
	Contract_Rental_Days,
	Walk_Up,
	rate_name,
	Rate_Purpose_ID,
	Org_Type,
	BCD_Number,
             SUM( CASE 	WHEN (Charge_Type IN (10,  50, 51, 52)  or Optional_Extra_ID =216)
			THEN Amount
			ELSE 0
		END)  
            								as TimeCharge,
	SUM( CASE 	WHEN Charge_Type IN (20)
			THEN Amount
			ELSE 0
		END)  
            								as Upgrade,

	SUM( CASE 	WHEN Charge_Type IN (11)
			THEN Amount
			ELSE 0
		END)  
            								as KMCharge,
            SUM( CASE 	WHEN (Charge_Type IN (33) or Optional_Extra_ID=212  )
			THEN (Amount)
			ELSE 0
			END) 					AS DropOff_Charge,
	SUM(CASE	WHEN Charge_Type in (14,88)
			THEN Amount
			ELSE 0
		END) 							as FPO,
	
	SUM(Case	When (Optional_Extra_ID >=117 and Optional_Extra_ID <=186 ) or
					(Optional_Extra_ID >=196 and Optional_Extra_ID <=203 )	
			Then Amount
			ELSE 0
			END)						as KPO,
		
		
	SUM(CASE	WHEN Charge_Type = 34
			THEN Amount
			ELSE 0
			END) 						as Additional_Driver_Charge,
	--SUM(Case	When Optional_Extra_ID in (1, 2, 3) 
	--		Then Amount
	--		ELSE 0
	--		END)						as All_Seats,
	
	Sum(Case 	When    (OptionalExtraType in ( 'Seat' )) 	Or Charge_type=23		
			Then Amount
			ELSE 0
			END) As All_Seats,	
			
	SUM(Case	When Optional_Extra_ID in (23, 25,193,187,189)   Or Charge_type=36
			Then Amount
			ELSE 0
			END)						as Driver_Under_Age,
	SUM(Case
		When    (OptionalExtraType in ( 'LDW' , 'Buydown')) 
			OR (Charge_Type in (61,98) AND Charge_Item_Type = 'a') -- adjustment charge for LDW
			Then Amount
			ELSE 0
			END)						as All_Level_LDW,
	SUM(Case	When Optional_Extra_ID = 20
			OR (Charge_Type = 62 AND Charge_Item_Type = 'a') -- adjustment charge for PAI
			Then Amount
			ELSE 0
			END)						as PAI,
	SUM(Case	When (Optional_Extra_ID = 21 or Optional_Extra_ID = 19) -- PEC, CARGO
			OR (Charge_Type = 63 AND Charge_Item_Type = 'a') -- adjustment charge for PEC
			Then Amount
			ELSE 0
			END)						as PEC,
			
			
			 
	SUM(Case	When Optional_Extra_ID in (4, 26)
			Then Amount
			ELSE 0
			END)						as Ski_Rack,
	SUM(Case	When Optional_Extra_id in (5, 6, 35)
			Then Amount
			Else 0
			End)						as All_Dolly,
	Sum(Case 	When Optional_Extra_id in (17, 18)
			Then Amount
			Else 0
			End)						as All_Gates,
	--		SUM(Case
	
			
	Sum(Case	When Optional_Extra_id = 7
			Then Amount
			Else 0
			End)						as Blanket,
	SUM(Case
		When    (OptionalExtraType in ( 'OA' ) or Charge_Type in (37,47) ) 			
			Then Amount
			ELSE 0
			END) As OutOfArea,
	SUM(CASE	WHEN Charge_Type in (31,96, 97)
			THEN Amount
			ELSE 0
			END) 						as License_Recovery_fee,
			
	SUM(CASE	WHEN Charge_Type in (46)
			THEN Amount
			ELSE 0
			END) 						as Energy_Recovery_fee,
	
	
	SUM(Case
		When    (OptionalExtraType in ( 'GPS', 'PHONE' )) or Charge_type=68			
			Then Amount
			ELSE 0
			END) As GPS,
	
		--Sum(Case 	When Optional_Extra_id in (17,35,5)
		--	Then Amount
		--	Else 0
		--	End) Dollies_Tail_Gate,
				
		Sum(Case 	When Optional_Extra_id in (85,86,87,88,89,90,206,225)
		          or  Charge_Type=   89   or   OptionalExtraType in ( 'WT' )                         
			Then Amount
			Else 0
			End) Snow_Tire,
			--SUM(CASE	WHEN Charge_Type in (14)
			--THEN Amount
			--ELSE 0
			--END) 						as FPO,
			SUM(CASE	WHEN Charge_Type in (18)
			THEN Amount
			ELSE 0
			END) 						as Fuel,
	
			SUM(CASE When    (OptionalExtraType in ( 'ELI' ) OR (Charge_Type = 67 AND Charge_Item_Type = 'a') )			
			Then Amount
			ELSE 0
			END) As ELI	,
			
			SUM(CASE	WHEN (Charge_Type in (76)  or Optional_extra_id=47)
			THEN Amount
			ELSE 0
			END) 						as Seat_Storage,
			
			SUM(CASE	WHEN Charge_Type in (30,35)
			THEN Amount
			ELSE 0
			END) 						as Location_Fee,
			
			Sum(Case 	When Optional_Extra_id in (215)
		                        
			Then Amount
			Else 0
			End) USB_Connector,
								
			
			SUM(CASE	WHEN (Charge_Type in (13,65,66)   or Optional_extra_id=218)
			THEN Amount
			ELSE 0
			END) 						as Sales_Accessory   ,
			
			SUM(CASE	WHEN  Charge_Type in (22,25,32,60,64)  or Optional_extra_id=229
			THEN Amount
			ELSE 0
			END) 						as Other,
			sum(TaxAmount) as TaxAmount,  
			
			SUM(CASE WHEN
			      (
					charge_type in (70)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) LossOfUse,
			
			SUM(CASE WHEN
			      (
					charge_type in (49)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) TollAdmin,
			
			SUM(CASE WHEN
			      (
					charge_type in (17)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) TrafficAdmin,
			Sum(Case 	When Optional_Extra_id in (242)
		                        
			Then Amount
			Else 0
			End) RSN,
			
			Sum(Case 	When Optional_Extra_id in (241)
		                        
			Then Amount
			Else 0
			End) PAE,
			
 
			SUM(CASE WHEN
			      (
					charge_type in (38)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) DamageAdmin,

			SUM(CASE WHEN
			      (
					charge_type in 
					(
						12,
						15,
						16,
						--17,  --Traffic Violation Admin Charge
						19,
						21,
						24,
						--25,
						26,
						27,
						28,
						29,
						--32,
						--38,  --Damage Admin Charge
						39,
						40,
						41,
						43,
						44,
						45,
						48,
						--49,  --Toll Fee Admin Charge   
						58,
						--70,
						71,
						72,
						73,
						74,
						75,
						90,
						91,
						92,
						93,
						94,
						95

					)
					
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) NonApFeeItem,
			SUM(CASE WHEN
			      (
					charge_type in (12)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) OptionalExtra,
			SUM(CASE WHEN
			      (
					charge_type in (15)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) DamageClaim,					
			SUM(CASE WHEN
			      (
					charge_type in (16)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) TrafficViolationCharge,		 
			SUM(CASE WHEN
			      (
					charge_type in (19)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) CleaningCharge,		 
			SUM(CASE WHEN
			      (
					charge_type in (21)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) KeyCutCharge,		 
			SUM(CASE WHEN
			      (
					charge_type in (24)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) TireCharge,		 
			SUM(CASE WHEN
			      (
					charge_type in (26)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) TowingCharge,		 
			SUM(CASE WHEN
			      (
					charge_type in (27)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) RepairMaintenance,		 
			SUM(CASE WHEN
			      (
					charge_type in (28)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) TaxiCharge,		 
			SUM(CASE WHEN
			      (
					charge_type in (29)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) OilRefillCharge,		 
			SUM(CASE WHEN
			      (
					charge_type in (39)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) CustomerFacilityCharge,		 
			SUM(CASE WHEN
			      (
					charge_type in (40)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) NoShow,		 
			SUM(CASE WHEN
			      (
					charge_type in (41)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) GPSRecovery,		 
			SUM(CASE WHEN
			      (
					charge_type in (43)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) Postage,		 
			SUM(CASE WHEN
			      (
					charge_type in (44)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) UnredeemedPrepayment,		 
			SUM(CASE WHEN
			      (
					charge_type in (45)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) LocationFee_Manual,		 
			SUM(CASE WHEN
			      (
					charge_type in (48)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) TollFee,		 
			SUM(CASE WHEN
			      (
					charge_type in (71)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) [GST/HST],		 
			SUM(CASE WHEN
			      (
					charge_type in (72)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) PST,		 
			SUM(CASE WHEN
			      (
					charge_type in (73)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) PVRT,		 
			SUM(CASE WHEN
			      (
					charge_type in (74)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) CallOutFee,		 
			SUM(CASE WHEN
			      (
					charge_type in (75)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) DamageWriteoff,		 
			SUM(CASE WHEN
			      (
					charge_type in (90)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) RSOT,		 
			SUM(CASE WHEN
			      (
					charge_type in (91)	
					And  (optional_extra_ID is null )
				)	
				THEN Amount
				Else 0
			End) WindshieldChipRepair,
			
			sum(amount) as Amount
	
	--select * from lookup_table where category like '%charge type%'
	--select * from optional_extra
			
FROM Contract_Revenue_vw
GROUP BY RBR_Date,
First_name,
	Last_name,
Address_1, 
	Address_2, 
	Province_State, 
	Phone_Number,
	Company_Name, 
	Company_Phone_Number, 
	Local_Phone_Number, 
	Local_Address_1, 
    Local_Address_2, 
    Local_City,
	City,
	Postal_Code,
	country,
	Pick_Up_On,
	Actual_Check_in,
	contract_number,
	KM_Out,
	KM_In,
	PU_Location,
	DO_Location,
	Vehicle_Type_ID,
	Vehicle_Class_Name,
	unit_number,
	serial_number,
	licence_plate_number,
	model_name,
	model_year,
	Contract_Rental_Days,
	Walk_Up,
	RATE_NAME,
	Rate_Purpose_ID,
	ORG_TYPE,
	BCD_Number,
	owning_company_id,
	PULoc_OID,
	 DOLoc_OID


GO
