USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_12_CSR_Incremental_Yield_L1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








------------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		15 Feb 2002
--	Details		Get all data for CSR Incremental Yield Performance Report
--	Modification:		Name:		Date:		Detail:
--
------------------------------------------------------------------------------------------------------------------------
CREATE View [dbo].[RP_Acc_12_CSR_Incremental_Yield_L1]
as
Select 	
	bt.RBR_Date, 
    	bt.Contract_Number, 
   	rwo.Location_ID			as Pick_Up_Location_ID, 
    	rwo.User_ID 			as CSR_Name, 
            veh.owning_company_id,
    	vc.Vehicle_Type_ID, 
	DATEDIFF(mi, c.Pick_Up_On,rlv.Actual_Check_In) / 1440.000	as Contract_Rental_Days,
	DATEDIFF(mi, c.Pick_Up_On,rlv.Actual_Check_In) / 60.000	as Contract_Rental_Hours,
	
	Walk_Up = CASE 
		WHEN (c.Confirmation_Number is not null or c.Foreign_Contract_Number is not null)
			THEN 0
		ELSE 1
		END,
	cci.Charge_Type,
             cci.Unit_Type,
	cci.Quantity,
	cci.Charge_item_type,
	cci.Optional_Extra_ID,
	Optional_Extra.Type as OptionalExtraType,
	c.Reservation_Revenue,
             c.Confirmation_number,
	--KMCap.Km_Cap,
             --KMCap.Per_KM_Charge,	
	Amount = cci.Amount 	- cci.GST_Amount_Included
				- cci.PST_Amount_Included 
				- cci.PVRT_Amount_Included,
	l.Percentage_Fee, 
	l.LicenseFeePerDay,
	l.FPO_Fuel_Price_Per_Liter,
	vr.Location_Fee_Included,
	vr.FPO_Purchased,
	vr.License_Fee_Included
	
FROM 	Contract c WITH(NOLOCK)
	INNER JOIN
    	Business_Transaction bt 
		ON bt.Contract_Number = c.Contract_Number
	INNER JOIN
    	RP__CSR_Who_Opened_The_Contract rwo 
		ON c.Contract_Number = rwo.Contract_Number
     	INNER JOIN 
	Vehicle_Class vc
		ON c.Vehicle_Class_Code = vc.Vehicle_Class_Code
	INNER JOIN
    	Contract_Charge_Item cci
		ON c.Contract_Number = cci.Contract_Number
	INNER JOIN
   	RP__Last_Vehicle_On_Contract rlv
		ON c.Contract_Number = rlv.Contract_Number
	inner join
	Vehicle veh
		on veh.unit_number = rlv.unit_number
	left join location l
		on c.pick_up_location_id = l.location_id
	LEFT JOIN
	Vehicle_Rate vr
		ON c.rate_id = vr.rate_id
		AND c.Rate_Assigned_Date between vr.Effective_Date and vr.Termination_Date
        LEFT JOIN
	       dbo.Optional_Extra ON cci.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID and dbo.Optional_Extra.Delete_flag=0
	--Left Join RP__Maestro_KMCAP KMCap on c.confirmation_number=KMCap.confirmation_number
WHERE 	
	(bt.Transaction_Type = 'con') 
	AND 
    	--(bt.Transaction_Description = 'Check Out')  for Estella's upgrade and vehicle sub report
	( bt.Transaction_Description in ('check in', 'Foreign Check In') )
    	AND 
	c.Status not in ('vd', 'ca') 
	--and 
	--c.foreign_contract_number is null
	--and 
	--veh.owning_company_id = 7425
	
































GO
