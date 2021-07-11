USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_26_Toll_Charge]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[RP_SP_Acc_26_Toll_Charge]
As


Select	GISTC.Toll_Charge_Date, 
	GISTC.Charge_Amount, 
	GISTC.Licence_Plate, 
	GISTC.UNIT_NUMBER,
	GISTC.Contract_Number, 
	GISTC.Checked_Out, 
	GISTC.Actual_Check_In, 
	GISTC.Attached_On,
	GISTC.Removed_On, 
	GISTC.First_Name, 
	GISTC.Last_Name, 
	GISTC.Vehicle_Class_Code, 
	GISTC.Location, 
	TCIssuer.Value as Issuer, 
	CBP.Billing_Method,
	CCType.Credit_Card_Type,
	DBC.Address_Name as Direct_Bill_Company,
	DBC.PO_Number,
	GISTC.Email_Address,
	GISTC.Decal, GISTC.Bridge, GISTC.Tolling_Method, GISTC.Vehicle_Class
	From
	(	
	
	   SELECT distinct TC.Toll_Charge_Date, TC.Charge_Amount, TC.Licence_Plate,RA.UNIT_NUMBER, RA.Contract_Number, RA.Checked_Out, RA.Actual_Check_In, RA.Attached_On, RA.Removed_On, 
	   RA.First_Name, RA.Last_Name, RA.Vehicle_Class_Code, RA.Location, TC.Issuer, ra.Email_address, TC.Decal, TC.Bridge, TC.Tolling_Method, TC.Vehicle_Class
	
		FROM  (SELECT		VLH.Licence_Plate_Number,
						convert(varchar(30),CON.Contract_Number) as Contract_number,
						VOC.Checked_Out, 
						VOC.UNIT_NUMBER,
						VOC.Actual_Check_In, 
						VLH.Attached_On, 
						VLH.Removed_On, 
						CON.First_Name, 
						CON.Last_Name,
						CON.Vehicle_Class_Code, 
						LOC.Location,
						con.email_address
			FROM         dbo.Vehicle_On_Contract VOC  WITH (NOLOCK) INNER JOIN
						  dbo.Vehicle_Licence_History VLH ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On AND 
						  ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59')) INNER JOIN
						  dbo.Contract CON  WITH (NOLOCK) ON VOC.Contract_Number = CON.Contract_Number INNER JOIN
						  dbo.Location LOC ON CON.Pick_Up_Location_ID = LOC.Location_ID

			
			) AS RA INNER JOIN
				   dbo.Toll_Charge AS TC ON 
				   TC.Toll_Charge_Date BETWEEN RA.Checked_Out AND ISNULL(RA.Actual_Check_In, '2078-12-31 23:59')
				   AND RA.Licence_Plate_Number = TC.Licence_Plate	
				   And TC.Processed=0			   
			 	
			
	--order by  TC.Toll_Charge_Date
	) GISTC
	

		Inner Join 
		(	Select * from Contract_billing_Party 
			where Billing_Type='p' --and billing_method='Renter'
		 ) CBP
		On	 GISTC.Contract_Number=   CBP.Contract_Number
		  
		Inner Join (Select Category, Code, Value from Lookup_table where Category='Toll Charge Issuer') TCIssuer
					On GISTC.Issuer=  TCIssuer.Code
		left join (SELECT	RPB.Contract_number,CCT.Credit_Card_Type
						FROM	Renter_Primary_Billing RPB  WITH (NOLOCK)
								inner join Credit_Card CC on RPB.Credit_Card_Key = CC.Credit_Card_Key
								inner join Credit_Card_Type CCT on CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
					) CCType on GISTC.Contract_Number=   CCType.Contract_Number
		left join (SELECT	CBP.Contract_number,
							CBP.Customer_Code,
							DBP.PO_Number,
							AM.Address_Name
						FROM	Contract_Billing_Party CBP  WITH (NOLOCK)
								inner join ARMaster AM on CBP.Customer_Code = AM.Customer_Code
								inner join Direct_Bill_Primary_Billing DBP 
									on CBP.Contract_number=DBP.Contract_number
									and CBP.Contract_billing_Party_ID=DBP.Contract_billing_Party_ID
					where 	CBP.Billing_Type = 'p'	AND	CBP.Billing_Method = 'Direct Bill'
					) DBC on GISTC.Contract_Number=   DBC.Contract_Number


	
		
		Union
		
		Select	  TC.Toll_Charge_Date,TC.Charge_Amount, TC.Licence_Plate,VLH.Unit_Number,  
		NULL as Contract_Number, NULL Checked_Out, NULL Actual_Check_In, NULL Attached_On,
		NULL Removed_On, NULL First_Name, NULL Last_Name, 
		NULL Vehicle_Class_Code, NULL Location, TCIssuer.Value as Issuer, NULL	Billing_Method, 
		NULL Credit_Card_Type, NULL Direct_Bill_Company,NULL PO_NUmber, null Email_Address, TC.Decal, TC.Bridge, TC.Tolling_Method, TC.Vehicle_Class
		from dbo.Toll_Charge TC
		Inner Join (Select Category, Code, Value from Lookup_table where Category='Toll Charge Issuer') TCIssuer
					On TC.Issuer=  TCIssuer.Code
		LEFT JOIN dbo.Vehicle_Licence_History VLH
			On TC.Licence_Plate=	VLH.Licence_Plate_Number
			AND TC.Toll_Charge_Date BETWEEN VLH.Attached_On AND 
									  ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59'))
		 
		--and TC.Licence_Plate +replace(cast(Toll_Charge_Date as varchar), ' ','') not in
		Left join 
		(
		    -- continue here................
			SELECT  
			TC.Licence_Plate, 
			TC.Toll_Charge_Date, 
			RA.Contract_Number	
			FROM  (
			
					SELECT		VLH.Licence_Plate_Number,
									CON.Contract_Number as Contract_number,
								VOC.Checked_Out, 
								VOC.Actual_Check_In, 
								VLH.Attached_On, 
								VLH.Removed_On, 
								CON.First_Name, 
								CON.Last_Name,
								CON.Vehicle_Class_Code, 
								LOC.Location
					FROM         dbo.Vehicle_On_Contract VOC WITH(NOLOCK) INNER JOIN
								  dbo.Vehicle_Licence_History VLH ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On AND 
								  ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59')) INNER JOIN
								  dbo.Contract CON WITH(NOLOCK)ON VOC.Contract_Number = CON.Contract_Number INNER JOIN
								  dbo.Location LOC ON CON.Pick_Up_Location_ID = LOC.Location_ID

					
					) AS RA 
					INNER JOIN
						   dbo.Toll_Charge AS TC ON 
						   TC.Toll_Charge_Date BETWEEN RA.Checked_Out AND ISNULL(RA.Actual_Check_In, '2078-12-31 23:59')
						   AND RA.Licence_Plate_Number = TC.Licence_Plate	
					Where TC.Processed=0  
			) CONTC
			On TC.Licence_Plate = CONTC.Licence_Plate and TC.Toll_Charge_Date=CONTC.Toll_Charge_Date
			Where  CONTC.Contract_Number is null and TC.Processed=0
			--Union
			--  SELECT distinct TC.Licence_Plate +replace(cast(Toll_Charge_Date as varchar), ' ','') 
			--	FROM  (SELECT VLH.Licence_Plate_Number,
					 
			--		MV.Movement_Out, 
			--		MV.Movement_IN, 
			--		VLH.Attached_On, 
			--		VLH.Removed_On 
						 
			--FROM  dbo.Vehicle_Movement MV 
			--INNER JOIN dbo.Vehicle_Licence_History VLH ON MV.Unit_Number = VLH.Unit_Number 
			--	AND MV.Movement_Out BETWEEN VLH.Attached_On AND ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59'))  
			
			--) AS MV INNER JOIN
			--	   dbo.Toll_Charge AS TC ON 
			--	   TC.Toll_Charge_Date BETWEEN MV.Movement_Out AND ISNULL(MV.Movement_IN, '2078-12-31 23:59')
			--	   AND MV.Licence_Plate_Number = TC.Licence_Plate
				--Where TC.Processed=0	
					   
		--)
  
	   order by GISTC.contract_number
GO
