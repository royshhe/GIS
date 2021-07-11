USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_17_CSR_Incremental_Yield_L1_CP]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		15 Feb 2002
--	Details		Get all data for CSR Incremental Yield Performance Report
--	Modification:		Name:		Date:		Detail:
--
------------------------------------------------------------------------------------------------------------------------
CREATE View [dbo].[RP_Acc_17_CSR_Incremental_Yield_L1_CP]
as
Select 	
	bt.RBR_Date, 
    	bt.Contract_Number, 
c.Customer_Program_Number,
	res.Applicant_Status_Indicator as Applicant_Status_Indicator ,
   	c.pick_up_location_id		as Pick_Up_Location_ID, 
    	rwo.User_ID 			as CSR_Name, 
    	vc.Vehicle_Type_ID, 	
	CONVERT(decimal(5,2),dbo.GetRentalDays(DATEDIFF(mi, c.Pick_Up_On,rlv.Actual_Check_In) / 60.000)) as Contract_Rental_Days,	
	Walk_Up = CASE 
		WHEN (c.Confirmation_Number is not null )

/* and bt.contract_number not in (SELECT     dbo.Contract.Contract_Number
											FROM         dbo.Reservation INNER JOIN
											                      dbo.Contract ON dbo.Reservation.Last_Name = dbo.Contract.Last_Name AND dbo.Reservation.First_Name = dbo.Contract.First_Name
											WHERE     (dbo.Contract.Pick_Up_On BETWEEN '2006-10-06 12:00' AND '2006-10-07 23:15') AND (dbo.Contract.Confirmation_Number IS NULL) AND 
											                      (dbo.Reservation.Status NOT IN ('O', 'A', 'C'))
)*/

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
	Rate_Name=(case when vr.Rate_Name is not Null 
			   then vr.Rate_Name
        		   else qvr.Rate_Name
        	      end),
	Rate_Purpose=(case when vr.Rate_Purpose is not Null 
			   then vr.Rate_Purpose
        		   else qvr.Rate_Purpose
        	      end),

  (Case 
		When BCDRate.BCD_Number is not null then BCDRate.BCD_Number 
		 Else Res.BCD_Number 
 End) BCD_Number

	
	--select *
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
	LEFT OUTER JOIN
                      dbo.Organization BCDRate ON c.BCD_Rate_Organization_ID = BCDRate.Organization_ID
    LEFT OUTER JOIN
                      dbo.Reservation Res ON c.Confirmation_Number = Res.Confirmation_Number
	LEFT JOIN
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
	--Left Join RP__Maestro_KMCAP KMCap on c.confirmation_number=KMCap.confirmation_number
WHERE 	
	(bt.Transaction_Type = 'con') 
	AND 
    	(bt.Transaction_Description = 'check in') 
    	AND 
	c.Status not in ('vd', 'ca') 
	And 
	c.foreign_contract_number is null
	
	And 
	veh.owning_company_id in (select code from lookup_table where category ='BudgetBC Company')
	
--	And( c.Customer_Program_Number is null
----			and (res.Applicant_Status_Indicator<>1 or res.Applicant_Status_Indicator is null)
----		or c.pick_up_location_id in (select location_id 
----											from location where location in ( 'B-42 Chilliwack','B-40 Abbotsford Airport','B-39 Surrey') ) 
--		)	
--
GO
