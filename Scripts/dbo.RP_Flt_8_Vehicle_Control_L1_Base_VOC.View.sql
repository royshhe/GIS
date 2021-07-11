USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_8_Vehicle_Control_L1_Base_VOC]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: RP_Flt_8_Vehicle_Control_L1_Base_VOC
PURPOSE: Get the last contract associated with each unit number.

AUTHOR:	Joseph Tseung
DATE CREATED: 2000/03/08
USED BY: RP_Flt_8_Vehicle_Control_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/03/31	Select the record with maximum business transaction id if the check out/check in
				times in different voc records are the same.
Joseph Tseung	2000/04/05	Fix to select the record with maximum business transaction id if the check out/check in
				times in different voc records are the same.
Joseph Tseung	2000/04/05	Select actual check in field for the main view to check whether contract number should 
				be shown.
Joseph Tseung	2000/04/18	Fix select conditions for business transaction id criteria
Joseph Tseung	2000/04/18	Fix to improve performance
Joseph Tseung	2000/04/27	Select pick up location for the case of vehicle support check-in
*/
CREATE VIEW [dbo].[RP_Flt_8_Vehicle_Control_L1_Base_VOC]
AS
SELECT 	Vehicle_On_Contract .Contract_Number,
	Vehicle_On_Contract .Expected_Check_In,
	Vehicle_On_Contract .Unit_Number,
	Vehicle_On_Contract .Vehicle_Not_Present_Location,
	Vehicle_On_Contract .Checked_out,
	Vehicle_On_Contract .Actual_Check_In,
	-- if the contract is still checked out, get the pick up location
        -- if the contract is checked in, get the drop off location
	Location_ID = CASE WHEN (Vehicle_On_Contract .Actual_Check_In IS NULL AND Vehicle_On_Contract .Actual_Drop_Off_Location_ID IS NULL) 
				OR (Vehicle_On_Contract .Actual_Check_In IS NOT NULL AND Vehicle_On_Contract .Actual_Drop_Off_Location_ID IS NULL) -- case for vehicle support check-in
			   THEN Vehicle_On_Contract .Pick_Up_Location_ID 
			   ELSE Vehicle_On_Contract .Actual_Drop_Off_Location_ID
		      END,
	Km = CASE WHEN Km_In >= Km_Out
		THEN Km_In
		ELSE Km_Out
	     END,
	(Case When ITB.Contract_number is not null Then '*'
	     Else ''
	 End) as ITB_Indicator,
	  dbo.Contract.Pick_Up_On, 
	 (isnull(dbo.contract.first_name,'')+' '+isnull(dbo.contract.last_name,'')) as Renter_Name
	 
	        
	

FROM 	Vehicle_On_Contract WITH(NOLOCK)
INNER JOIN
                      dbo.Contract ON dbo.Vehicle_On_Contract.Contract_Number = dbo.Contract.Contract_Number
Left Join (SELECT Contract_Number,      
		  max(Interim_Bill_Date) First_Bill_date
		  FROM dbo.Interim_Bill
		  Group by Contract_number    
	) ITB
	on   dbo.Contract.Contract_number=ITB.Contract_number                     


WHERE 	

((dbo.Contract.Status <> 'VD') AND (dbo.Contract.Status <> 'CA'))
and
Checked_Out =
        		(SELECT MAX(voc.Checked_Out)
		      		FROM Vehicle_On_Contract voc
					WHERE voc.Unit_Number = Vehicle_On_Contract.Unit_Number)

	--AND
        --ISNULL(Actual_Check_In, 'Dec 31 2078') =
	--	      	(SELECT MAX(ISNULL(voc2.Actual_Check_In, 'Dec 31 2078'))
		--      		FROM Vehicle_On_Contract voc2
			--		WHERE voc2.Unit_Number = Vehicle_On_Contract.Unit_Number
				--	AND voc2.Checked_Out = Vehicle_On_Contract.Checked_Out)
	
	AND
	Business_Transaction_ID =
        		(SELECT MAX(voc3.Business_Transaction_ID)
		      		FROM Vehicle_On_Contract voc3
					WHERE voc3.Unit_Number = Vehicle_On_Contract.Unit_Number
					AND voc3.Checked_Out = Vehicle_On_Contract.Checked_Out
					AND ISNULL(voc3.Actual_Check_In, 'Dec 31 2078') = ISNULL(Vehicle_On_Contract.Actual_Check_In, 'Dec 31 2078'))
	AND
	-- If a vehicle is currently on more than one contract, only the contract
	-- for which there is no override check in for that vehicle will be shown.	
	Vehicle_On_Contract .Contract_Number NOT IN 
			(SELECT Overridden_Contract_Number 
				FROM Override_Check_In
					WHERE Vehicle_On_Contract.Unit_Number = Override_Check_In.Unit_Number
    					AND 
			   		Vehicle_On_Contract.Contract_Number = Override_Check_In.Overridden_Contract_Number
    					AND 
			   		Vehicle_On_Contract.Checked_Out = Override_Check_In.Checked_Out
			)
GO
