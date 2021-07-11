USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_Business_Transaction_Detail]    Script Date: 2021-07-10 1:50:45 PM ******/
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
CREATE View [dbo].[RP_Con_Business_Transaction_Detail]
as
Select 	
	bt.RBR_Date, 
    	c.Contract_Number, 
	c.Foreign_Contract_number,
   	rwo.Location_ID			as Pick_Up_Location_ID, 
   	rlv.actual_Drop_off_Location_ID	as Drop_Off_Location_ID, 
    	rwo.User_ID 			as CSR_Name, 
    	vc.Vehicle_Type_ID, 
              rlv.unit_number,
	v.Foreign_Vehicle_Unit_Number,
              rlv.Actual_Check_In,
	DATEDIFF(mi, c.Pick_Up_On,rlv.Actual_Check_In) / 1440.0	as Contract_Rental_Days,
	Walk_Up = CASE 
		WHEN c.Confirmation_Number is not null
			THEN 0
		ELSE 1
		END,
	cci.Charge_Type,
	cci.Optional_Extra_ID,
	c.Reservation_Revenue,
	cci.Amount as Amount,
	cci.GST_Amount_Included as GST,
	cci.PST_Amount_Included   as PST,
	cci.PVRT_Amount_Included as PVRT	

FROM 	Contract c WITH(NOLOCK)
	INNER JOIN
    	Business_Transaction bt 
		ON bt.Contract_Number = c.Contract_Number
            INNER JOIN
    	Contract_Charge_Item cci
		ON bt.Business_Transaction_ID = cci.Business_Transaction_ID
		--on c.contract_number = cci.contract_number
	INNER JOIN
    	RP__CSR_Who_Opened_The_Contract rwo 
		ON c.Contract_Number = rwo.Contract_Number
     	INNER JOIN 
	Vehicle_Class vc
		ON c.Vehicle_Class_Code = vc.Vehicle_Class_Code
	
	INNER JOIN
   	RP__Last_Vehicle_On_Contract rlv
		ON c.Contract_Number = rlv.Contract_Number
	inner join
	Vehicle v
		on v.unit_number = rlv.unit_number
WHERE 	
	(bt.Transaction_Type = 'con') 
	AND 
	(NOT (c.Status = 'vd')) 
	
 
















GO
