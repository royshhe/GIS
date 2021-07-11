USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FPG_CSR_Incentive]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[FPG_CSR_Incentive]  --'2016-10-01','2016-10-31'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS

-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime 
		 
SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	
Select *  from 
( 
Select --	top 100
   
	GISUsers.EmployeeID,
	ccisum.TnK TnM,
	(Case 
	 WHEN charge_type = 20 THEN 'Upgrade'		 
	 WHEN charge_type = 33 THEN 'DropOffCharge'
	
	 WHEN Charge_Type = 14 THEN 'FPO' 
	 WHEN Charge_Type = 18 THEN 'Fuel' 
	 WHEN Charge_Type = 34 THEN 'Additional Driver Charge' 

	

	 WHEN cci.Optional_Extra_ID IN (1, 2, 3)   THEN 'All Seats' 
	 WHEN cci.Optional_Extra_ID IN (23, 25) THEN 'Driver Under Age' 
	 --WHEN Optional_Extra.Type IN ('LDW', 'BUYDOWN') OR (Charge_Type = 61 AND Charge_Item_Type = 'a')  or Charge_Type in (93) THEN 'All_Level_LDW'  
	 
	 
	 When Optional_Extra.Type IN ('LDW') 	
			OR (Charge_Type = 61 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for LDW
			OR (Charge_Type = 64 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for LDW
			Then 'LDW'
			
	  When Optional_Extra.Type IN ('BUYDOWN') 	Then 'Buydown'
			
	 
	When Optional_Extra.Type IN ('PAI','PAE','PEC') --and Rate_Purpose<>'Tour Pkg' 
			OR (Charge_Type in ( 62,63) AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PAI
			Then 'PAE'
	When Optional_Extra.Type IN ('RSN') 
			OR (Charge_Type = 83  AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
			Then 'RSN'

	 When Optional_Extra.Type IN ('ELI') 
			OR (Charge_Type = 67 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
			Then 'ELI'	 	 
	 WHEN cci.Optional_Extra_ID IN (4, 26)  THEN 'Ski Rack'  
	 WHEN cci.Optional_Extra_id IN (5, 6, 35) THEN 'All Dolly'  
	 When Optional_Extra.Type in ('OA') Then 'Our Of Area' 
	 WHEN cci.Optional_Extra_id IN (17, 18) THEN 'All Gates'  
	 WHEN cci.Optional_Extra_id = 7 THEN 'Blanket' 
	 WHEN Optional_Extra.Type IN ('GPS') THEN 'GPS' 
	 When cci.Optional_Extra_ID in (88,89,90,206,225) OR (Charge_Type = 89)	Then 'Snow Tire'
	 WHEN Charge_Type in (30,35) THEN 'Location Fee'
	 WHEN Charge_Type in (96,97) THEN 'VLF'
	 WHEN Charge_Type = 39 THEN 'CFC'
     WHEN Charge_Type = 46 THEN 'ERF'
     WHEN Charge_Type = 48 THEN 'Toll Fee'
     WHEN Charge_Type = 49  THEN 'Admin Charge' 
	 Else 'Other'
	End) ProductSold,
    c.Pick_Up_On,
    cci.Unit_Amount,
	bt.Contract_Number, 
    DATEDIFF(mi, c.Pick_Up_On,rlv.Actual_Check_In) / 1440.000	as Rental_Days,
    'Leisure' as MarketSegment,   
    vc.SIPP OriginalCarClass,
    vc.SIPP UpgradedCarClass, 
	rlv.Actual_Check_In as CheckInDate,
    cci.Unit_Type,
	cci.Quantity,
  	Amount = cci.Amount 	- cci.GST_Amount_Included
				- cci.PST_Amount_Included 
				- cci.PVRT_Amount_Included,
	bt.RBR_Date,
	l.Location as PickUpLocation,
	(Case 
		When BCDRate.BCD_Number is not null then BCDRate.BCD_Number 
		 Else Res.BCD_Number 
 End) BCD_Number,
 Rate_Name=(case when vr.Rate_Name is not Null 
			   then vr.Rate_Name
        		   else qvr.Rate_Name
        	      end),
 Rate_Purpose=(case when vr.Rate_Purpose is not Null 
			   then vr.Rate_Purpose
        		   else qvr.Rate_Purpose
        	      end)

FROM 	Contract c WITH(NOLOCK)
	INNER JOIN Business_Transaction bt 
		ON bt.Contract_Number = c.Contract_Number
	INNER JOIN RP__CSR_Who_Opened_The_Contract rwo 
		ON c.Contract_Number = rwo.Contract_Number
    INNER JOIN Vehicle_Class vc
		ON c.Vehicle_Class_Code = vc.Vehicle_Class_Code
	INNER JOIN Contract_Charge_Item cci
		ON c.Contract_Number = cci.Contract_Number
	INNER JOIN Contract_Charge_Sum_vw ccisum
		on c.Contract_Number=ccisum.Contract_Number
	INNER JOIN RP__Last_Vehicle_On_Contract rlv
		ON c.Contract_Number = rlv.Contract_Number
	inner join Vehicle veh
		on veh.unit_number = rlv.unit_number
	left join location l
		on c.pick_up_location_id = l.location_id
	LEFT OUTER JOIN dbo.Organization BCDRate 
		ON c.BCD_Rate_Organization_ID = BCDRate.Organization_ID
    LEFT OUTER JOIN dbo.Reservation Res 
		ON c.Confirmation_Number = Res.Confirmation_Number
	LEFT JOIN
		(SELECT      dbo.Rate_Purpose.Rate_Purpose,dbo.Vehicle_Rate.Rate_ID,dbo.Vehicle_Rate.Rate_Name,  dbo.Vehicle_Rate.Location_Fee_Included, dbo.Vehicle_Rate.License_Fee_Included, 
					  dbo.Vehicle_Rate.FPO_Purchased, dbo.Vehicle_Rate.Effective_Date, dbo.Vehicle_Rate.Termination_Date
		 FROM         dbo.Vehicle_Rate INNER JOIN
							  dbo.Rate_Purpose ON dbo.Vehicle_Rate.Rate_Purpose_ID = dbo.Rate_Purpose.Rate_Purpose_ID
        ) vr
		ON c.rate_id = vr.rate_id	AND c.Rate_Assigned_Date between vr.Effective_Date and vr.Termination_Date
	LEFT OUTER JOIN
            (SELECT     dbo.Rate_Purpose.Rate_Purpose, dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID, dbo.Quoted_Vehicle_Rate.Rate_Name, 
                      dbo.Quoted_Vehicle_Rate.Location_Fee_Included, dbo.Quoted_Vehicle_Rate.License_Fee_Included, dbo.Quoted_Vehicle_Rate.FPO_Purchased
			FROM         dbo.Rate_Purpose RIGHT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Rate_Purpose.Rate_Purpose_ID = dbo.Quoted_Vehicle_Rate.Rate_Purpose_ID)  qvr 
		ON c.Quoted_Rate_ID = qvr.Quoted_Rate_ID

    LEFT JOIN dbo.Optional_Extra 
		ON cci.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID and dbo.Optional_Extra.Delete_flag=0
	LEFT JOIN GISUsers 
	       On GISUsers.User_Name=rwo.User_ID   	       
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
	
	And( c.Customer_Program_Number is null
		)	
	and (BCDRate.organization is null or BCDRate.organization not like '%CN Rail%' and  BCDRate.organization not like '%Maple Leaf%')
	And c.Status not in ('vd', 'ca')  and cci.Charge_Type NOt IN (10, 11, 50, 51, 52)	
	and bt.RBR_Date between @startDate and @endDate
	--order by  c.Contract_Number desc
) Revenue
where ((
		(
			(
				bcd_number not in ('A162000','A044300','Z801586','S367200''A111700',
									'A111701',
									'A111702',
									'A111703',
									'A111704',
									'A111705',
									'A111706',
									'A111707',
									'A111708',
									'A111709',
									'A111710',
									'A111711',
									'A111713',
									'A111714',
									'A111715',
									'A111780',
									'A111781',
									'A111790',
									'X061804',
									'X113843',
									'Y919340',
									'Z801460',
									'Z801586'
									)
				--and 
				--bcd_number not in (Select BCD_number from organization 
				--					where organization like 'Canada Post%')
				
			
			)
			or 
			(bcd_number is null)
		 )
	 and  rate_name not like 'PBC%' 
	 and  rate_name not like 'GOC%'
	 and rate_name <>'14i'
	 and rate_name<>'01i') --and pick_up_location_id  in ('16','20')  --exclude monthly rate
		--per Greg exclude for new locations
		--or (((bcd_number<>'A162000' and bcd_number<>'A044300')or (bcd_number is null))
		--		and  rate_name not like 'PBC%' 
		--		and  rate_name not like 'GOC%'
		--		and  rate_name not in ('14i','RCM','RCMP')
		--		and rate_name<>'01i'
		--		and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
		--	) 	and  pick_up_location_id not in ('16','20')
--where   rate_name not like 'PBC%'  and rate_name <>'14i'--exclude monthly rate
--A162000/'PBC%'    BC PROVINCIAL GOVERNMENT
--A044300/'GOC%'   GOVERNMENT OF CANADA

			)  
	and (rate_name <>'DND' or Rate_name is null) --rate for ASU Chilliwack  Excluded
	and (rate_name not like 'DHL%' or Rate_name is null) --rate for DHL2014  Excluded

	--and rate_name <>'ICBC2011' --remove per Greg from March 1st. 2012
	and (Rate_Purpose<>'ICBC' or Rate_Purpose is null ) --per Greg required.
	--and ( Rate_Purpose<>'Film Production' or Rate_Purpose is null )--Kevin required for exclude Production rate on Jan 23 2014
	and (Rate_Purpose<>'Special Events' or Rate_Purpose is null)--Ke
GO
