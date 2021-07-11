USE [GISData]
GO
/****** Object:  View [dbo].[ViewContractRevenueAll]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[ViewContractRevenueAll]
as
Select 	
	bt.RBR_Date, 
    	bt.Contract_Number, 
   	--rwo.location_id		as Pick_Up_Location_ID, 		-- Include Foreign contract using BRAC cars
	c.pick_up_location_id		as Pick_Up_Location_ID, 	-- Exslude all Foreign contracts using BRAC cars
    	vc.Vehicle_Type_ID, 
	vc.Vehicle_Class_Name,
	vmy.model_name,
	vmy.model_year,
	DATEDIFF(mi, c.Pick_Up_On,rlv.Actual_Check_In) / 1440.0	as Contract_Rental_Days,
             rlv.km_in-rlv.km_out as KmDriven,
	Walk_Up = CASE 
		WHEN (c.Confirmation_Number is not null or c.Foreign_Contract_Number is not null)
			THEN 0
		ELSE 1
		END,
	cci.Charge_Type,
	cci.Charge_item_type,
	cci.Optional_Extra_ID,
	c.Reservation_Revenue,
	Amount = cci.Amount 	- cci.GST_Amount_Included
				- cci.PST_Amount_Included 
				- cci.PVRT_Amount_Included,
	vr.rate_name,
	vr.Rate_Purpose_ID,
	o.Org_Type
	/*l.Percentage_Fee, 
	l.LicenseFeePerDay,
	l.FPO_Fuel_Price_Per_Liter,
	vr.Location_Fee_Included,
	vr.FPO_Purchased,
	vr.License_Fee_Included*/
	
FROM 	Contract c WITH(NOLOCK)
	INNER JOIN
    	Business_Transaction bt 
		ON bt.Contract_Number = c.Contract_Number
	/*inner join 
	RP__CSR_Who_Opened_The_Contract rwo 
		ON c.Contract_Number = rwo.Contract_Number*/
	INNER JOIN
   	RP__Last_Vehicle_On_Contract rlv
		ON c.Contract_Number = rlv.Contract_Number
	inner join
	Vehicle veh
		on rlv.unit_number = veh.unit_number
	inner join
	vehicle_model_year vmy
		on veh.vehicle_model_id = vmy.vehicle_model_id
	--INNER JOIN
      	--Reservation 
	--	ON c.Confirmation_Number = Reservation.Confirmation_Number
	left JOIN
    	Contract_Charge_Item cci
		ON c.Contract_Number = cci.Contract_Number
	left JOIN 
	Vehicle_Class vc
		ON  veh.Vehicle_Class_Code = vc.Vehicle_Class_Code
	/*left join location l
		on c.pick_up_location_id = l.location_id*/
	LEFT JOIN
	Vehicle_Rate vr
		ON c.rate_id = vr.rate_id
		AND c.Rate_Assigned_Date between vr.Effective_Date and vr.Termination_Date
	left join organization o
		on o.Organization_ID = c.Referring_Organization_ID
	left join reservation rev
		on rev. confirmation_number = c. confirmation_number
WHERE 	
	(bt.Transaction_Type = 'con') 
	AND 
    	(bt.Transaction_Description in ('check in', 'foreign check in') )
    	AND 
	--c.Status not in ('vd', 'ca') 
	c.Status = 'CI'
	--and 
	--( (rev.BCD_Number = 'A162000') or  vr.rate_name in ('PBC06A' , 'PBC06L', 'PBC06UH') )
	--and bt.rbr_date >= '2005-01-01' and bt.rbr_date < '2006-01-01'
	--and 
	--c.foreign_contract_number is null
	and 
	veh.owning_company_id = 7425
	--and  vr.rate_name in ('GOCAP06' , 'GOCLOCAL06')
	










































GO
