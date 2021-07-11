USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Revenue_vw]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
















	  --select top 1 * from VEhicle_on_Contract
 

CREATE View [dbo].[Contract_Revenue_vw]
as
Select 	
	bt.RBR_Date, 
	c.First_name,
	c.Last_name,
	
	c.Address_1, 
	c.Address_2, 
	c.Province_State, 
	c.Phone_Number,
	c.Company_Name, 
	c.Company_Phone_Number, 
	c.Local_Phone_Number, 
	c.Local_Address_1, 
    c.Local_Address_2, 
    c.Local_City,

	c.City,
	C.Postal_Code,	
	c.country,
	c.Pick_Up_On,
	rlv.Actual_Check_in,
    bt.Contract_Number,    
	rlv.KM_Out,
	rlv.KM_In,	
	c.pick_up_location_id	as Pick_Up_Location_ID, 	
	c.Drop_Off_Location_ID,
	PULoc.Location as PU_Location,
	DOLoc.Location as DO_Location,
	dbo.Optional_Extra.Type AS OptionalExtraType,

             veh.owning_company_id,
	PULoc.Owning_Company_ID as PULoc_OID,
	DOLoc.Owning_Company_ID as DOLoc_OID,
	rlv.unit_number,
	veh.serial_number,
	VLH.licence_Plate_Number,
    vc.Vehicle_Type_ID, 
	vc.Vehicle_Class_Name,
	vmy.model_name,
	vmy.model_year,
	vmy.Fuel_tank_size,
	--dbo.Contract_Rental_Days_vw.Rental_Day 	as Contract_Rental_Days,
	dbo.GetRentalDays(DATEDIFF(mi, c.Pick_Up_On, rlv.Actual_Check_In)/60.00)  as Contract_Rental_Days,
             rlv.km_in-rlv.km_out as KmDriven,
	Walk_Up = CASE 
		WHEN (c.Confirmation_Number is not null or c.Foreign_Contract_Number is not null)
			THEN 0
		ELSE 1
		END,
	cci.Charge_Type,
	cci.Charge_Description,
	cci.Charge_item_type,
	cci.Optional_Extra_ID,
	c.Reservation_Revenue,
	Amount = cci.Amount 	- cci.GST_Amount_Included
				- cci.PST_Amount_Included 
				- cci.PVRT_Amount_Included,
	Case When vr.rate_name is not Null then vr.rate_name
	         Else    dbo.Quoted_Vehicle_Rate.Rate_Name
	End as Rate_Name,
	vr.Rate_Purpose_ID,
	o.Org_Type,

            ( Case
		 when c.BCD_Rate_Organization_id is not null then BCD_Rate_Organization.BCD_number
		 when rev.BCD_number  is not null then rev.BCD_number 
		else null
	end ) BCD_number,
	GST_Amount+PST_Amount+PVRT_Amount+ 
	cci.GST_Amount_Included	+ cci.PST_Amount_Included + cci.PVRT_Amount_Included	AS TaxAmount
	
	--select *
FROM 	Contract c WITH(NOLOCK)
	INNER JOIN Location PULoc
		on c.pick_up_location_id=PULoc.Location_id
	INNER JOIN Location DOLoc
		on c.Drop_Off_Location_ID=DOLoc.Location_id
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
	vehicle_model_year vmy
		on veh.vehicle_model_id = vmy.vehicle_model_id
             --INNER JOIN
             --         dbo.Contract_Rental_Days_vw ON c.Contract_Number = dbo.Contract_Rental_Days_vw.Contract_Number
	
	left JOIN
    	Contract_Charge_Item cci
		ON c.Contract_Number = cci.Contract_Number
	left JOIN 
	Vehicle_Class vc
		ON  veh.Vehicle_Class_Code = vc.Vehicle_Class_Code
	
	LEFT JOIN
	Vehicle_Rate vr
		ON c.rate_id = vr.rate_id
		AND c.Rate_Assigned_Date between vr.Effective_Date and vr.Termination_Date
             LEFT  JOIN
                      dbo.Quoted_Vehicle_Rate ON c.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID
	left join organization o
		on o.Organization_ID = c.Referring_Organization_ID
	left join organization BCD_Rate_Organization
		on BCD_Rate_Organization.Organization_ID = c.BCD_Rate_Organization_id
	left join reservation rev
		on rev. confirmation_number = c. confirmation_number
	 LEFT OUTER JOIN
                      dbo.Optional_Extra ON cci.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID 
                      --AND 
                      --dbo.Optional_Extra.Delete_Flag = 0

	 LEFT JOIN Vehicle_Licence_History VLH
		 ON veh.unit_number = VLH.unit_number
WHERE 	
(bt.Transaction_Type = 'con') 
	AND 
    	(bt.Transaction_Description in ('check in') )
    	AND 	
	c.Status = 'CI'
             -- And 
	--veh.owning_company_id in (select code from lookup_table where category ='BudgetBC Company')
	

	--and c.Confirmation_number is null  -- Walk up Only
/*(bt.Transaction_Type = 'con') 
	AND 
    	(bt.Transaction_Description = 'Check Out') 
    	AND 
	c.Status not in ('vd', 'ca') 
	and c.Status = 'CO'
	--c.foreign_contract_number is null
	--and (BCD_Rate_Organization.BCD_number = 'A044300 '  or rev.BCD_number = 'A044300 ')
	--and vr.Rate_Name like '%SNBC%'
*/
	
union  all

SELECT
	bt.RBR_Date, 
	c.First_name,
	c.Last_name,
	c.Address_1, 
	c.Address_2, 
	c.Province_State, 
	c.Phone_Number,
	c.Company_Name, 
	c.Company_Phone_Number, 
	c.Local_Phone_Number, 
	c.Local_Address_1, 
    c.Local_Address_2, 
    c.Local_City,
    
	c.City,
	C.Postal_Code,	
	c.country,
	c.Pick_Up_On,
	rlv.Actual_Check_in,
    bt.Contract_Number,    
	rlv.KM_Out,
	rlv.KM_In,	
	c.pick_up_location_id	as Pick_Up_Location_ID, 	
	c.Drop_Off_Location_ID,
	PULoc.Location as PU_Location,
	DOLoc.Location as DO_Location,
	NULL AS OptionalExtraType,
    veh.owning_company_id,
	PULoc.Owning_Company_ID as PULoc_OID,
	DOLoc.Owning_Company_ID as DOLoc_OID,
	rlv.unit_number,
	veh.serial_number,
	licence_Plate_Number,
    vc.Vehicle_Type_ID, 
	vc.Vehicle_Class_Name,
	vmy.model_name,
	vmy.model_year,
	vmy.Fuel_tank_size,
	--dbo.Contract_Rental_Days_vw.Rental_Day 	as Contract_Rental_Days,
	dbo.GetRentalDays(DATEDIFF(mi, c.Pick_Up_On, rlv.Actual_Check_In)/60.00)  as Contract_Rental_Days,
             rlv.km_in-rlv.km_out as KmDriven,
	Walk_Up = CASE 
		WHEN (c.Confirmation_Number is not null or c.Foreign_Contract_Number is not null)
			THEN 0
		ELSE 1
		END,
	(Case When cci.Reimbursement_Reason in ('Customer Service Charge', 'Miscellaneous Charge') then '60'
	     When  cci.Reimbursement_Reason ='Repair and Maintenance' then   '27'
		 When  cci.Reimbursement_Reason ='Oil Refill Charge' then  '29'
		 When  cci.Reimbursement_Reason ='Taxi Charge' then	 '28'
		 When  cci.Reimbursement_Reason ='Tire Charge' then	 '24'
		 When  cci.Reimbursement_Reason ='Towing Charge' then  '26'
		 When  cci.Reimbursement_Reason ='Drop Charge' then	'33'
    End)  Charge_Type,


	cci.Reimbursement_Reason Charge_Description,
	'c' Charge_item_type,
	NULL Optional_Extra_ID,
	c.Reservation_Revenue,
	Amount = cci.Flat_Amount*(-1), 	 
	Case When vr.rate_name is not Null then vr.rate_name
	         Else    dbo.Quoted_Vehicle_Rate.Rate_Name
	End as Rate_Name,
	vr.Rate_Purpose_ID,
	o.Org_Type,

            ( Case
		 when c.BCD_Rate_Organization_id is not null then BCD_Rate_Organization.BCD_number
		 when rev.BCD_number  is not null then rev.BCD_number 
		else null
	end ) BCD_number,
	0	AS TaxAmount
	
	
   
FROM  dbo.Contract AS c
INNER JOIN Location PULoc
	on c.pick_up_location_id=PULoc.Location_id
INNER JOIN Location DOLoc
	on c.Drop_Off_Location_ID=DOLoc.Location_id
INNER JOIN dbo.Business_Transaction AS bt 
    ON c.Contract_Number = bt.Contract_Number 
INNER JOIN dbo.Contract_Reimbur_and_Discount AS cci 
	ON c.Contract_Number = cci.Contract_Number and cci.type='Reimbursement'             
INNER JOIN dbo.RP__Last_Vehicle_On_Contract AS rlv 
     ON c.Contract_Number = rlv.Contract_Number 
INNER JOIN dbo.Vehicle AS veh 
	ON rlv.Unit_Number = veh.Unit_Number 
INNER JOIN dbo.Vehicle_Model_Year AS vmy 
	ON veh.Vehicle_Model_ID = vmy.Vehicle_Model_ID 
INNER JOIN dbo.Contract_Rental_Days_vw 
	ON c.Contract_Number = dbo.Contract_Rental_Days_vw.Contract_Number 
INNER JOIN dbo.Vehicle_Class AS vc 
	ON veh.Vehicle_Class_Code = vc.Vehicle_Class_Code 
LEFT OUTER JOIN  dbo.Vehicle_Rate AS vr 
	ON c.Rate_ID = vr.Rate_ID AND c.Rate_Assigned_Date BETWEEN vr.Effective_Date AND vr.Termination_Date 
LEFT OUTER JOIN dbo.Quoted_Vehicle_Rate 
	ON c.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID
left join organization o
	on o.Organization_ID = c.Referring_Organization_ID
left join organization BCD_Rate_Organization
	on BCD_Rate_Organization.Organization_ID = c.BCD_Rate_Organization_id
left join reservation rev
	on rev. confirmation_number = c. confirmation_number

LEFT JOIN Vehicle_Licence_History VLH
		 ON veh.unit_number = VLH.unit_number
where 
(bt.Transaction_Type = 'con') 
	AND 
    	(bt.Transaction_Description in ('check in', 'foreign check in') )
    	AND 	
	c.Status = 'CI'											   
















































































GO
