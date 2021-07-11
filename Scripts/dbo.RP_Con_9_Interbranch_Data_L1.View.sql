USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_9_Interbranch_Data_L1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* MOD - Sep 14, 2005 - Kenneth Wong - Fuel charges GST will not be included in the GST Amount*/
CREATE view [dbo].[RP_Con_9_Interbranch_Data_L1]

as

select distinct c.Contract_Number, 
	c.foreign_contract_number,
	bt.RBR_Date, 
	bt.Business_Transaction_ID,
	bt.transaction_description,
	c.last_name + ', ' + c.first_name as Customer_name,
	l1.location 			as Pick_up_location,
	l1.owning_company_id		as PULocOCID,
	l2.location			as Drop_off_location,
	l2.owning_company_id		as DOLocOCID,
    	rwo.User_ID 			as CSR_Name,
    	vc.Vehicle_Type_ID, 
	vc.vehicle_class_name,
	case when veh.foreign_vehicle_unit_number is null
		then convert(varchar(10), veh.unit_number)
		else veh.foreign_vehicle_unit_number
		end			as Unit_number,
	case when veh.Current_licence_plate != ''
		then veh.Current_licence_plate
		else vlh.licence_plate_number
		end			as licence_plate,
	oc.Name				as Vehicle_Owning_company,
	oc.Owning_company_id		as VehOCID,
	c.Pick_Up_On			as Date_out,
	rlv.Actual_Check_In		as Date_in,
	round(DATEDIFF(mi, c.Pick_Up_On,rlv.Actual_Check_In) / 1440.0,1)	as Rental_Length,
	rlv.km_out,
	rlv.km_in,
	(rlv.km_in - rlv.km_out) 	as Km_driven,
	cci.Charge_Type,
	cci.Charge_item_type,
	cci.Optional_Extra_ID,
        Optional_Extra.Type as OptionalExtraType,
	Amount = cci.Amount,
	/*Amount = cci.Amount 	- cci.GST_Amount_Included
				- cci.PST_Amount_Included 
				- cci.PVRT_Amount_Included,*/
	/*GST_Amount = CASE WHEN cci.GST_Amount_Included > 0 
			         THEN CASE WHEN cci.Charge_Type = 18 -- Fuel Charges only have GST
				      THEN 0
				      ELSE cci.GST_Amount_Included
				      END
			         ELSE cci.GST_Amount
			END,  
   	PST_Amount = CASE WHEN cci.PST_Amount_Included > 0 
			         THEN cci.PST_Amount_Included
			         ELSE cci.PST_Amount
			END, 
   	PVRT_Amount = CASE WHEN cci.PVRT_Amount_Included > 0 
			         THEN cci.PVRT_Amount_Included
			         ELSE cci.PVRT_Amount
			END,*/
	cci.GST_Amount,
	cci.PST_Amount,
	cci.PVRT_Amount,
	RateInclusiveFlag = Case When VR.GST_Included = 1 or VR.PST_Included = 1 or VR.PVRT_Included = 1 or VR.License_Fee_Included = 1 or VR.Location_Fee_Included = 1 
			      	THEN 1
				ELSE 0
				END, 
	QuotedInclusiveFlag = Case When QR.GST_Included = 1 or QR.PST_Included = 1 or QR.PVRT_Included = 1 or QR.License_Fee_Included = 1 or QR.Location_Fee_Included = 1 
				THEN 1
				ELSE 0
				END
from RP_Con_5_Interbranch_L1_Base_1
inner join
contract c
on c.contract_number = RP_Con_5_Interbranch_L1_Base_1.contract_number
inner join
business_transaction bt
on RP_Con_5_Interbranch_L1_Base_1.contract_number = bt.contract_number
INNER JOIN 
	Vehicle_Class vc
		ON c.Vehicle_Class_Code = vc.Vehicle_Class_Code
	inner JOIN
    	Contract_Charge_Item cci
		ON bt.business_transaction_id = cci.business_transaction_id
	left JOIN
    	RP__CSR_Who_Opened_The_Contract rwo 
		ON c.Contract_Number = rwo.Contract_Number
	left JOIN
   	RP__Last_Vehicle_On_Contract rlv
		ON c.Contract_Number = rlv.Contract_Number
	left join
	Vehicle veh
		on veh.unit_number = rlv.unit_number
	left join 
	owning_company oc
		on veh.owning_company_id = oc.owning_company_id
	left join
	vehicle_licence_history vlh
		on vlh.unit_number = rlv.unit_number
		and (rlv.Checked_out between vlh.attached_on and vlh.removed_on
			or vlh.removed_on is null)
	left join 
	location l1
		on rlv.pick_up_location_id = l1.location_id
	left join
	location l2
		on rlv.actual_drop_off_location_id = l2.location_id
        -- Add By Roy he to Remove the Hard Code
        LEFT JOIN
	       dbo.Optional_Extra ON cci.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID and dbo.Optional_Extra.Delete_flag=0
    	left Join Vehicle_Rate VR
		on (VR.Rate_id=c.Rate_id  and c.Rate_Assigned_Date between VR.Effective_date and VR.Termination_date)
	left Join Quoted_Vehicle_Rate QR
		on QR.Quoted_Rate_id = c.Quoted_Rate_id   
WHERE 	
	(bt.Transaction_Type = 'con') 
	AND 
    	bt.Transaction_Description in ('check in', 'Adjustments', 'Foreign Check In') 
    	AND 
	c.Status not in ('vd', 'ca')















GO
