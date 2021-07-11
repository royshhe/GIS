USE [GISData]
GO
/****** Object:  View [dbo].[RP_FLT_14_Vehicle_Revenue_L1]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









------------------------------------------------------------------------------------------------------------------------
--	Developed By:	Roy he
--	Date:		15 Jan 2002
--	Details		Get all data for Vehicle Revenue
--	Modification:		Name:		Date:		Detail:
--
-----------------------------------------------------------------------------------------------------------------------

CREATE View [dbo].[RP_FLT_14_Vehicle_Revenue_L1]
as
Select 	
	bt.RBR_Date,  
	bt.Contract_Number,    
        veh.unit_number,
    	vc.Vehicle_Type_ID, 
	vc.Vehicle_Class_Code,
	vc.Alias Vehicle_Class_Name,
	vc.DisplayOrder,
	vmy.model_name,
	vmy.model_year,
       	l.hub_id,
	LocationHub.Value as Hub_Name,
	l.Location_id,
        l.location as Location_Name,
	/*ViewVehicleInServiceDate.InService,
	ViewVehicleSold.[Sold Date],
	DaysInService=
	case 
		WHEN (ViewVehicleSold.[Sold Date] is not null)
		THEN DATEDIFF(mi, ViewVehicleInServiceDate.InService,ViewVehicleSold.[Sold Date]) / 1440.0	
	          	ELSE
			DATEDIFF(mi, ViewVehicleInServiceDate.InService,GETDATE()) / 1440.0	
	 END,
         */

	

	--DATEDIFF(mi, c.Pick_Up_On,rlv.Actual_Check_In) / 1440.0	as Contract_Rental_Days,
             rlv.km_in-rlv.km_out as KmDriven,
	Walk_Up = CASE 
		WHEN (c.Confirmation_Number is not null or c.Foreign_Contract_Number is not null)
			THEN 0
		ELSE 1
		END,
	--cci.Charge_Type,
	cci.Charge_item_type,
	cci.Optional_Extra_ID,
	Optional_Extra.Type as OptionalExtraType,
	Optional_Extra.Optional_Extra as Optional_Extra,
	lt_ChargeType.Value as Charge_Type,
	c.Reservation_Revenue,
	Amount = cci.Amount 	- cci.GST_Amount_Included
				- cci.PST_Amount_Included 
				- cci.PVRT_Amount_Included

FROM  dbo.Contract c WITH(NOLOCK)
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
	Lookup_Table lt_OwningCompany
	        on veh.owning_company_id=lt_OwningCompany.code
	inner join
	vehicle_model_year vmy
		on veh.vehicle_model_id = vmy.vehicle_model_id
             inner join location l
		on c.pick_up_location_id = l.location_id
	left join 
	Lookup_Table LocationHub
		on l.hub_id= LocationHub.Code  and LocationHub.Category='Hub'
	left JOIN
    	Contract_Charge_Item cci
		ON c.Contract_Number = cci.Contract_Number
	left JOIN 
		Vehicle_Class vc
		ON  veh.Vehicle_Class_Code = vc.Vehicle_Class_Code
            --left join ViewVehicleInServiceDate on ViewVehicleInServiceDate.Unit_number= veh.unit_number
            --left join ViewVehicleSold on ViewVehicleSold.Unit_number= veh.unit_number

 	LEFT JOIN
	       dbo.Optional_Extra ON cci.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID and dbo.Optional_Extra.Delete_flag=0
	Left join 
	Lookup_Table lt_ChargeType
	        on cci.Charge_Type=lt_ChargeType.code and  
		(
			(lt_ChargeType.Category='Charge Type Adjustment' and cci.Charge_item_type='a')
			or (lt_ChargeType.Category='Charge Type Calculated' and cci.Charge_item_type='c')
			or (lt_ChargeType.Category='Charge Type Manual' and cci.Charge_item_type='m')
			--or (lt_ChargeType.Category='Charge Type Reimbursement' and cci.Charge_item_type='a')
			or (lt_ChargeType.Category='Charge Type Rentback' and cci.Charge_item_type='r')
                )
	
WHERE 	
	(bt.Transaction_Type = 'con') 
	AND    	(bt.Transaction_Description in ('check in', 'foreign check in') )
    	AND 	c.Status = 'CI'
	AND   (lt_OwningCompany.Category = 'BudgetBC Company')   --	veh.owning_company_id = 7425
	And l.location not like '% m'
	




























































GO
