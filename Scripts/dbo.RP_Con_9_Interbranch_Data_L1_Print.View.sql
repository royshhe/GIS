USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_9_Interbranch_Data_L1_Print]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[RP_Con_9_Interbranch_Data_L1_Print]

as



select distinct c.Contract_Number, 	
	bt.RBR_Date, 	
	l1.owning_company_id		as PULocOCID,	
	l2.owning_company_id		as DOLocOCID,	
	oc.Owning_company_id		as VehOCID
	
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
	location l1
		on rlv.pick_up_location_id = l1.location_id
	left join
	location l2
		on rlv.actual_drop_off_location_id = l2.location_id
        -- Add By Roy he to Remove the Hard Code
        
WHERE 	
	(bt.Transaction_Type = 'con') 
	AND 
    	bt.Transaction_Description in ('check in', 'Adjustments', 'Foreign Check In') 
    	AND 
	c.Status not in ('vd', 'ca')



GO
