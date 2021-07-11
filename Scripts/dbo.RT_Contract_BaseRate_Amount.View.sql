USE [GISData]
GO
/****** Object:  View [dbo].[RT_Contract_BaseRate_Amount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RT_Contract_BaseRate_Amount
PURPOSE: Get Base Rate Amount for the Contract
	 Based on the assumption of weekly rate name contains 'Weekly' 		
AUTHOR:	Roy He
DATE CREATED: 2005/08/01
USED BY: CSR Incentive Report
MOD HISTORY:
Name 		Date		Comments
				is not defined in the lookup table.
*/
CREATE View [dbo].[RT_Contract_BaseRate_Amount]
as


SELECT     	dbo.Contract.Contract_Number, dbo.Contract.Pick_Up_On, 
		dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, DATEDIFF(mi, 
		dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 60.000  AS RentalHours,
		DailyBaseAmount= max((case 
			when Rate_Selection_Type = 'Rack' then dbo.RT_LocationVehicleRateAmount.Amount
			else 0
			end)),
		
			WeeklyBaeRateAmount
			=
			max((case 
				when Rate_Selection_Type = 'Package'  AND (vrbase.Rate_Name LIKE '%Weekly%')  then dbo.RT_LocationVehicleRateAmount.Amount
				else 0
			end)) ,
			


    		/*	DailyBaseRateName= max(case  when  Rate_Selection_Type = 'Rack' --when vrbase.Rate_Name LIKE '%Weekly%'
                                                then   vrbase.Rate_Name
                                                else ''--vrbase.Rate_Name
                                        end),
                     
                       WeeklyBaseRateName= max(case when Rate_Selection_Type = 'Package'  AND (vrbase.Rate_Name LIKE '%Weekly%')
                                then   vrbase.Rate_Name
                                else ''
                        end),*/
		
		max (CASE	 WHEN  dbo.Contract_Charge_Item.Unit_Type='Day' Then 'Day'
			ELSE ''
			END) DayPeriod,
		
		max(CASE	 WHEN  dbo.Contract_Charge_Item.Unit_Type='Week' Then 'Week'
			ELSE ''
		  END) WeekPeriod,  
		       vrcontract.Rate_name,
		 dbo.Contract.Rate_Level		


FROM         dbo.Contract INNER JOIN
	dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number INNER JOIN
	dbo.RT_LocationVehicleRateAmount ON dbo.Contract.Pick_Up_Location_ID = dbo.RT_LocationVehicleRateAmount.Location_ID AND 
	dbo.Contract.Vehicle_Class_Code = dbo.RT_LocationVehicleRateAmount.Vehicle_Class_Code AND 
	dbo.Contract.Pick_Up_On > dbo.RT_LocationVehicleRateAmount.Valid_From AND 
	dbo.Contract.Pick_Up_On <= dbo.RT_LocationVehicleRateAmount.Valid_To INNER JOIN
	dbo.Vehicle_Rate vrbase ON dbo.RT_LocationVehicleRateAmount.Rate_ID = vrbase.Rate_ID
	INNER JOIN  dbo.Vehicle_Rate  vrcontract ON dbo.Contract.Rate_id=vrcontract.Rate_ID
	INNER JOIN dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number



WHERE 
(    
	(dbo.Contract.Status <> 'OP') AND (dbo.Contract.Status <> 'CO') AND (dbo.RT_LocationVehicleRateAmount.Location_Vehicle_Rate_Type = 'Walk UP') 
   	AND (dbo.RT_LocationVehicleRateAmount.Rate_Selection_Type = 'Rack') 
	AND (dbo.RT_LocationVehicleRateAmount.Time_Period = 'Day') 
	AND (Time_Period_Start=1)  
	AND (vrbase.Termination_Date>GETDATE())
	AND (vrbase.Rate_Purpose_ID=13 )
	AND (vrbase.Rate_name not like 'm-%')
	AND (vrbase.Rate_name not like 'WJ%')
	AND (vrbase.rate_name not like 'One%Way%')
	AND (vrbase.rate_name not like 'M-One%Way%') 
	AND (vrcontract.Termination_Date > GETDATE())
	AND (vrcontract.Rate_Purpose_ID=13 )
	AND (vrcontract.Rate_name not like 'm-%')
	AND (vrcontract.Rate_name not like 'WJ%')
	AND (vrcontract.rate_name not like 'One%Way%')
	AND (vrcontract.rate_name not like 'M-One%Way%') 
	AND contract.confirmation_number is null
	AND dbo.Contract_Charge_Item.Charge_Type=10
)

OR
 (
    	(dbo.Contract.Status <> 'OP') 
	AND (dbo.Contract.Status <> 'CO') 
	AND (dbo.RT_LocationVehicleRateAmount.Location_Vehicle_Rate_Type = 'Walk UP') 
    	AND (dbo.RT_LocationVehicleRateAmount.Rate_Selection_Type = 'Package') 
	AND (vrbase.Rate_Name LIKE '%Weekly%') 
	AND (dbo.RT_LocationVehicleRateAmount.Time_Period = 'Week')
	AND (Time_Period_Start=1) 
	AND (vrbase.Termination_Date>GETDATE())
	AND (vrbase.Rate_Purpose_ID=13 )
	AND (vrbase.Rate_name not like 'm-%')
	AND (vrbase.Rate_name not like 'WJ%')
	AND (vrbase.rate_name not like 'One%Way%')
	AND (vrbase.rate_name not like 'M-One%Way%') 
	AND (vrcontract.Termination_Date > GETDATE())
	AND (vrcontract.Rate_Purpose_ID=13 )
	AND (vrcontract.Rate_name not like 'm-%')
	AND (vrcontract.Rate_name not like 'WJ%')
	AND (vrcontract.rate_name not like 'One%Way%')
	AND (vrcontract.rate_name not like 'M-One%Way%') 
	AND contract.confirmation_number is null
	AND dbo.Contract_Charge_Item.Charge_Type=10
 
	
 )

group by dbo.Contract.Contract_Number, dbo.Contract.Pick_Up_On,  dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In,   vrcontract.Rate_name,dbo.Contract.Rate_Level		



































GO
