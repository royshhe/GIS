USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetIBOutstandingListing]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create PROCEDURE [dbo].[GetIBOutstandingListing]
as 
Declare @CompanyCode int 
Select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'	

Select distinct 	
		convert(varchar(10),Con.Contract_number) as Contract_Number,
		v.Unit_Number,
		oc.Name, 
		puloc.Location as Pick_Up_Location,
		con.Pick_Up_On as Pick_Up_On,
		DOLoc.Location as Drop_Off_Location,
		con.Drop_Off_On as Drop_Off_On
		--EptLoc.Location  ,
		--voc.Expected_Check_In,
		--voc.Actual_Check_In ,
		--ActLoc.Location  
		--voc.Checked_In_By ,
		--voc.Check_In_Reason ,
		    	
	from business_transaction bt
	join contract con
		on bt.contract_number = con.contract_number 
	join location PULoc
		on con.Pick_Up_Location_ID = PULoc.location_id 	
	join (SELECT Contract_Number, Unit_Number, Checked_Out, Pick_Up_Location_ID, Expected_Check_In, 
				Expected_Drop_Off_Location_ID,
				(Case When Actual_Drop_Off_Location_ID is not null Then Actual_Drop_Off_Location_ID
					 Else Expected_Drop_Off_Location_ID
				End) Drop_Off_Location_ID,
				Actual_Drop_Off_Location_ID,
				Actual_Check_In,Km_Out, Km_In, Fuel_Level, Fuel_Remaining, Fuel_Added_Dollar_Amt, Fuel_Added_Litres, Fuel_Price_Per_Litre, 
                Vehicle_Condition_Status, Vehicle_Not_Present_Reason, Vehicle_Not_Present_Location, Checked_In_By, Check_In_Reason, Actual_Vehicle_Class_Code, 
                FPO_Purchased, Calculated_Fuel_Charge, Calculated_Fuel_Litre, Upgrade_Charge, Calculated_Upgrade_Charge, Foreign_FPO_Charge, 
                Replacement_Contract_Number, Business_Transaction_ID
			FROM         Last_Vehicle_On_Contract_vw) voc
		on bt.contract_number = voc.contract_number and bt.Business_Transaction_ID=voc.Business_Transaction_ID
	join location DOLoc
		on voc.Drop_Off_Location_ID = DOLoc.location_id 
	join vehicle v
		on voc.Unit_Number = v.unit_number 
	left join location EptLoc on voc.Expected_Drop_Off_Location_ID =Eptloc.Location_ID 
	left join location ActLoc on voc.Actual_Drop_Off_Location_ID=Actloc.Location_ID 	
	left join Owning_Company OC on OC.Owning_Company_ID=v.Owning_Company_ID 
		
		
	where
	( 
		puloc.Owning_Company_ID = @CompanyCode
		And 
		(
		 --v.Owning_Company_ID <> @CompanyCode
		 --Or
 		 doloc.Owning_Company_ID <> @CompanyCode
 		)
 	) And COn.Status='CO' and VOC.Actual_Check_In is not null
GO
