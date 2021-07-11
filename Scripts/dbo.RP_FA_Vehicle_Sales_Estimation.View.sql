USE [GISData]
GO
/****** Object:  View [dbo].[RP_FA_Vehicle_Sales_Estimation]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE View [dbo].[RP_FA_Vehicle_Sales_Estimation]
 as 

SELECT 	Vehicle.Unit_Number, 
Serial_Number,	    	
Vehicle_Model_Year.Model_Name, 
Vehicle_Model_Year.Model_Year,
Vehicle_Class.Vehicle_Type_ID,
Vehicle_Class.FA_Vehicle_Type_ID,
Vehicle_Class.Vehicle_Class_Code, 
Vehicle_Class.Vehicle_Class_Name, 
--Vehicle.Exterior_Colour, 
--Vehicle.Interior_Colour, 
--Vehicle.Current_Licence_Plate, 
dbo.UpdatedVehicleISD(Vehicle.Unit_Number)	 InServiceDate,
DATEDIFF(Day, dbo.UpdatedVehicleISD(Vehicle.Unit_Number),  
	(Case When getdate()<LastVDH.Depreciation_End_Date then getdate()
             Else LastVDH.Depreciation_End_Date-1 
        End
     )
 ) AS InserviceDays,
  Vehicle.Owning_Company_ID AS Vehicle_Owning_Company_ID, 
  Owning_Company.Name AS Vehicle_Owning_Company_Name, 
  lt2.Value AS Vehicle_Rental_Status, 
  lt3.Value AS Vehicle_Condition_Status, 
  vm.Last_Move_Time AS Available_Since, 
  --DATEDIFF(Day, vm.Last_Move_Time, GETDATE()) AS Idle_Days,
VTP.LastPFDDAte,
 Location.Location AS Vehicle_Location_Name, 
 Vehicle.Current_Location_ID AS Vehicle_Location_ID,
Vehicle.Current_Km, 
Vehicle.Ownership_Date,
--Vehicle.Do_Not_Rent_Past_Km, 
--Vehicle.Do_Not_Rent_Past_Days,



(Case When Vehicle.Lessee_id Is Not NULL Then 'Lease'
								 Else 'Rental'
						End) VehicleUse,

	(Case When VTH.HeldDays is not Null then VTH.HeldDays Else 0 End) HeldDays,
							(Case When VTP.PFDDays is not Null then VTP.PFDDays Else 0 End) PullForDisposalDays,							
							(Case When Vehicle.Program =1 Then 'Program' Else RiskType.Value End) As OrderType ,

(Case When getdate()<LastVDH.Depreciation_End_Date then getdate() Else LastVDH.Depreciation_End_Date-1 End) DepreciationUpToDate,
LastAMO.Balance,
(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
					 When LastVDH.Depreciation_Rate_Percentage is Not Null Then  Round(Vehicle.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100,2)
					 Else 0
 End) as MonthlyDepRate,

 Round(
				(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
						 When LastVDH.Depreciation_Rate_Percentage is Not Null Then Vehicle.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100
						 Else 0
				End)*12/365 ,
				2 
    ) As DailyDepRate ,
 
	(
	 Datediff(d,  
	  DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month))),
     (Case When getdate()<LastVDH.Depreciation_End_Date then getdate() Else LastVDH.Depreciation_End_Date-1 End))
	)  As DepDaysInCurrentMonth,
 
   Vehicle.Vehicle_Cost,
   dbo.VehCurrentBookValue(Vehicle.Unit_Number, Getdate()) -dbo.ZeroIfNull(Price_Difference) AS BookValue,
   (Case When Vehicle.Damage_Amount>2000 Then Vehicle.Damage_Amount Else NULL End) as DamageOver2K,
  (Case 
	When Vehicle.Volume_Incentive is not null 
		 and  Vehicle.Planned_Days_In_Service is   null
		  
	 then Vehicle.Volume_Incentive
  else
	0
  End) Manufacturer_Cost,

Sales_Acc_Dep,
  Deduction,	
  KM_Charge,
  Cap_Cost-ISNULL(Sales_Acc_Dep,0.00)-ISNULL(Deduction,0.00)-ISNULL(KM_Charge,0.00) as EstSellingPrice
-- txtEstSellingPrice = Val(txtCapCost) - Val(txtAccumulatedDep) - Val(txtDeduction) - Val(txtKMCharge)
FROM 	Vehicle  
	INNER JOIN
    	Vehicle_Model_Year 
		ON Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
     	INNER JOIN
    	Vehicle_Class 
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	Location 
		ON Vehicle.Current_Location_ID = Location.Location_ID 	
	INNER 
	JOIN
    	Lookup_Table 
		ON Vehicle.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER JOIN
	Owning_Company 
		ON Vehicle.Owning_Company_ID = Owning_Company.Owning_Company_ID
	inner join 
	(SELECT MAX(VM1.Date_In) AS Last_Move_Time, VM1.Unit_Number As Unit_number FROM
		(SELECT     Movement_In as Date_in, Unit_Number
			FROM         dbo.Vehicle_Movement
		 UNION
		 SELECT Actual_Check_In as Date_in, Unit_Number
			FROM	 vehicle_on_contract) VM1 Group By VM1.Unit_Number) VM
		on vehicle.unit_number=vm.unit_number

  INNER JOIN
				(
						SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
											dbo.FA_Vehicle_Amortization.AMO_Amount, 											
											dbo.FA_Vehicle_Amortization.Balance,  -- Book Value
											dbo.FA_Vehicle_Amortization.AMO_Month
						FROM         dbo.FA_Vehicle_Amortization
						Inner Join 
						(		SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 												
													Max(AMO_Month) as AMOMonth
								FROM         dbo.FA_Vehicle_Amortization							
								Group By Unit_Number								
						) LastMonth
						On dbo.FA_Vehicle_Amortization.Unit_Number=LastMonth.Unit_Number and dbo.FA_Vehicle_Amortization.AMO_Month=LastMonth.AMOMonth
				 ) LastAMO
    	On Vehicle.Unit_Number =LastAMO.Unit_Number
		Left JOIN
		 ( Select dbo.FA_Vehicle_Depreciation_History.Unit_Number,  
			dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date, 
			(Case When dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date is not Null then dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date
					Else Convert (Datetime,  '2078-12-31')
			End) Depreciation_End_Date,
			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, 
			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage
			from dbo.FA_Vehicle_Depreciation_History  
					Inner Join 
					(	SELECT     Unit_Number, Max(Depreciation_Start_Date) As Last_Start_Date
						FROM         FA_Vehicle_Depreciation_History						
							Group By Unit_Number									
				) LastDep
				On dbo.FA_Vehicle_Depreciation_History.Unit_Number=LastDep.Unit_Number and dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date=LastDep.Last_Start_Date
			
			) LastVDH

		 On  Vehicle.Unit_Number =LastVDH.Unit_Number

	
--   LEFT OUTER JOIN   dbo.FA_Inservcie_Date_vw FAISD 
--		ON Vehicle.Unit_Number = FAISD.Unit_Number
	Left Join Vehicle_Total_Held_Days_vw VTH 
		On Vehicle.Unit_Number=VTH.Unit_Number
	Left Join Vehicle_Total_PFD_Days_vw VTP 
		On Vehicle.Unit_Number=VTP.Unit_Number
	Left Join (Select * from lookup_table where Category='Risk Type') RiskType
		On Vehicle.Risk_Type=RiskType.Code
	Left Join FA_Buyer Buyer on Vehicle.Sell_To= Buyer.Customer_Code			
   -- Last Pull For Disposal
	LEFT OUTER JOIN
              (Select Unit_number, Vehicle_Status, max(Effective_On) Effective_On from Vehicle_History 
					Group by Unit_number, Vehicle_Status)  FAOSD 
			ON Vehicle.Unit_Number = FAOSD.Unit_Number AND (Vehicle.Program = 0 AND FAOSD.Vehicle_Status = 'f' OR
                      Vehicle.Program = 1 AND FAOSD.Vehicle_Status = 'g')
  Left JOIN
				 (Select Unit_Number,  
							Min(Depreciation_Start_Date) ISD, 
							Max(Depreciation_End_Date)  OSD
					from dbo.FA_Vehicle_Depreciation_History 
						Group By Unit_Number
					) VDH
    ON
      Vehicle.Unit_Number = VDH.Unit_Number 
    

    LEFT OUTER JOIN
    	Lookup_Table lt2
		ON Vehicle.Current_Rental_Status = lt2.Code 	
		AND (lt2.Category = 'vehicle rental status') 
	LEFT OUTER JOIN
    	Lookup_Table lt3
		ON Vehicle.Current_Condition_Status = lt3.Code
		AND (lt3.Category = 'vehicle condition status') 

WHERE 	
   	(Vehicle.Current_Vehicle_Status  not in ('g', 'i'))
	AND
	Vehicle.Deleted = 0


 

GO
