USE [GISData]
GO
/****** Object:  View [dbo].[ViewVehicletUnitRevenueAll]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[ViewVehicletUnitRevenueAll]
as
Select 	
	bt.RBR_Date,     
        veh.unit_number,
    	vc.Vehicle_Type_ID, 
	vc.Vehicle_Class_Name,
	vmy.model_name,
	vmy.model_year,
        	l.hub_id,
	ViewVehicleInServiceDate.InService,
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
				- cci.PVRT_Amount_Included
        
        
	
	
FROM 	Contract c WITH(NOLOCK)
	INNER JOIN
    	Business_Transaction bt 
		ON bt.Contract_Number = c.Contract_Number
	INNER JOIN
   	RP__Last_Vehicle_On_Contract rlv
		ON c.Contract_Number = rlv.Contract_Number
	inner join
	Vehicle veh
		on rlv.unit_number = veh.unit_number
	inner join 
	Lookup_Table lt
	        on veh.owning_company_id=lt.code
	inner join
	vehicle_model_year vmy
		on veh.vehicle_model_id = vmy.vehicle_model_id
        inner join location l
		on c.pick_up_location_id = l.location_id
	left JOIN
    	Contract_Charge_Item cci
		ON c.Contract_Number = cci.Contract_Number
	left JOIN 
	Vehicle_Class vc
		ON  veh.Vehicle_Class_Code = vc.Vehicle_Class_Code
           left join ViewVehicleInServiceDate on ViewVehicleInServiceDate.Unit_number= veh.unit_number
	
WHERE 	
	(bt.Transaction_Type = 'con') 
	AND    	(bt.Transaction_Description in ('check in', 'foreign check in') )
    	AND 	c.Status = 'CI'
	AND   (lt.Category = 'BudgetBC Company')   --	veh.owning_company_id = 7425
GO
