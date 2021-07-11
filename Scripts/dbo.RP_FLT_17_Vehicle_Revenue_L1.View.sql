USE [GISData]
GO
/****** Object:  View [dbo].[RP_FLT_17_Vehicle_Revenue_L1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





------------------------------------------------------------------------------------------------------------------------
--	Developed By:	Roy he
--	Date:		08 Jan 2014
--	Details		Get all data for Vehicle Revenue
--	Modification:		Name:		Date:		Detail:
--
-----------------------------------------------------------------------------------------------------------------------

CREATE View [dbo].[RP_FLT_17_Vehicle_Revenue_L1]
as
Select 	
	c.Pick_Up_On,
	(Case When c.Status='CO' then c.Drop_Off_On
	     When c.Status='CI' then rlv.Actual_Check_In
	End) Check_IN,  
	
	c.Contract_Number, 
	c.confirmation_number,
	c.First_Name+' '+Last_Name Renter_Name,  
	c.Company_name, 
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
    rlv.km_in-rlv.km_out as KmDriven,
	Walk_Up = CASE 
		WHEN (c.Confirmation_Number is not null or c.Foreign_Contract_Number is not null)
			THEN 0
		ELSE 1
		END,	
	cci.Charge_item_type,
	cci.Optional_Extra_ID,
	Optional_Extra.Type as OptionalExtraType,
	Optional_Extra.Optional_Extra as Optional_Extra,
	Rate_Name=(case when vr.Rate_Name is not Null 
			   then vr.Rate_Name
        		   else qvr.Rate_Name
        	      end),
	lt_ChargeType.Value as Charge_Type,
	c.Reservation_Revenue,
	Amount = cci.Amount 	- cci.GST_Amount_Included
				- cci.PST_Amount_Included 
				- cci.PVRT_Amount_Included

FROM  dbo.Contract c WITH(NOLOCK)
 
	Inner JOIN
   	(SELECT Contract_Number, Unit_Number, Checked_Out, Pick_Up_Location_ID, Actual_Check_In, Actual_Drop_Off_Location_ID, Km_Out, Km_In, Fuel_Level, 
              -- Modified on Aug 03, 2016 Per Syd's request, before the trip 
              (Case 
				 When Actual_Vehicle_Class_Code in ('b', 'l') then 'b'
				 When Actual_Vehicle_Class_Code in ('1', '3', '4', 'c') then 'c'
			     When Actual_Vehicle_Class_Code in ( 'd', 'e', 'f') then 'e'
			     When Actual_Vehicle_Class_Code in ('0','o',  'v', '5') then 'v'
			     When Actual_Vehicle_Class_Code in ('+', '=') then '+'
			     When Actual_Vehicle_Class_Code in ('9', '}', '-','{' ) then '9'
			     Else Actual_Vehicle_Class_Code
			End)  Actual_Vehicle_Class_Code
              
               
		FROM  dbo.RP__Last_Vehicle_On_Contract) rlv
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
		ON  rlv.Actual_Vehicle_Class_Code = vc.Vehicle_Class_Code   
	left JOIN 	
	(SELECT      dbo.Rate_Purpose.Rate_Purpose,dbo.Vehicle_Rate.Rate_ID,dbo.Vehicle_Rate.Rate_Name,  dbo.Vehicle_Rate.Location_Fee_Included, dbo.Vehicle_Rate.License_Fee_Included, 
                      dbo.Vehicle_Rate.FPO_Purchased, dbo.Vehicle_Rate.Effective_Date, dbo.Vehicle_Rate.Termination_Date
	FROM         dbo.Vehicle_Rate INNER JOIN
                      dbo.Rate_Purpose ON dbo.Vehicle_Rate.Rate_Purpose_ID = dbo.Rate_Purpose.Rate_Purpose_ID) vr
		ON c.rate_id = vr.rate_id
		AND c.Rate_Assigned_Date between vr.Effective_Date and vr.Termination_Date
	LEFT OUTER JOIN
                       (SELECT     dbo.Rate_Purpose.Rate_Purpose, dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID, dbo.Quoted_Vehicle_Rate.Rate_Name, 
                      dbo.Quoted_Vehicle_Rate.Location_Fee_Included, dbo.Quoted_Vehicle_Rate.License_Fee_Included, dbo.Quoted_Vehicle_Rate.FPO_Purchased
						FROM         dbo.Rate_Purpose RIGHT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Rate_Purpose.Rate_Purpose_ID = dbo.Quoted_Vehicle_Rate.Rate_Purpose_ID)  qvr 
		ON c.Quoted_Rate_ID = qvr.Quoted_Rate_ID
			         
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
	
WHERE   c.Status in ('CI', 'CO')    
    And (lt_OwningCompany.Category = 'BudgetBC Company')





GO
