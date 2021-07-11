USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctTCListing]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetCtrctTCListing]
As 
Select 

	ConTCTotal.Contract_Number, 
	ConTCTotal.TCTotal-	
	(Case When cci.TotalCharged is Null then 0 
		  Else  cci.TotalCharged
	 End) TotalCharge,		
	 Convert(int,
		 ConTCTotal.NumberOfCrossing *
		 (1.00 - 
			 (Case When cci.TotalCharged is Null then 0 
				  Else  cci.TotalCharged
			 End)/ConTCTotal.TCTotal
		 )
	 )NumberOfCrossing, 
	 TCIssuer.Value Issuer, 	 
	 CC.Credit_Card_Key,
	 ConTCTotal.Vehicle_Class_Code,
	 CBP.billing_method  
From 
(	
	Select Sum(GISTC.Charge_Amount) as TCTotal, GISTC.Contract_Number, Count(*) NumberOfCrossing,GISTC.Issuer, GISTC.Vehicle_Class_Code 
	From
	(	SELECT distinct TC.Toll_Charge_Date, TC.Charge_Amount, TC.Licence_Plate, RA.Contract_Number, RA.Checked_Out, RA.Actual_Check_In, RA.Attached_On, RA.Removed_On, 
				   RA.First_Name, RA.Last_Name, RA.Vehicle_Class_Code, RA.Location, TC.Issuer
		FROM  (SELECT		VLH.Licence_Plate_Number,
						convert(varchar(30),CON.Contract_Number) as Contract_number,
						VOC.Checked_Out, 
						VOC.Actual_Check_In, 
						VLH.Attached_On, 
						VLH.Removed_On, 
						CON.First_Name, 
						CON.Last_Name,
						CON.Vehicle_Class_Code, 
						LOC.Location
			FROM         dbo.Vehicle_On_Contract VOC INNER JOIN
						  dbo.Vehicle_Licence_History VLH ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On AND 
						  ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59')) INNER JOIN
						  dbo.Contract CON ON VOC.Contract_Number = CON.Contract_Number INNER JOIN
						  dbo.Location LOC ON CON.Pick_Up_Location_ID = LOC.Location_ID

			
			) AS RA INNER JOIN
				   dbo.Toll_Charge AS TC ON 
				   TC.Toll_Charge_Date BETWEEN RA.Checked_Out AND ISNULL(RA.Actual_Check_In, '2078-12-31 23:59')
				   AND RA.Licence_Plate_Number = TC.Licence_Plate
				   
			
			
	--order by  TC.Toll_Charge_Date
	) GISTC
	
	Inner Join 
    (
		    SELECT distinct --TC.Toll_Charge_Date,  TC.Licence_Plate, 
						RA.Contract_Number,  TC.Issuer
				FROM  (SELECT		VLH.Licence_Plate_Number,
									convert(varchar(30),CON.Contract_Number) as Contract_number,
									VOC.Checked_Out, 
									VOC.Actual_Check_In, 
									VLH.Attached_On, 
									VLH.Removed_On, 
									CON.First_Name, 
									CON.Last_Name, 
									LOC.Location
						FROM         dbo.Vehicle_On_Contract VOC INNER JOIN
									  dbo.Vehicle_Licence_History VLH ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On AND 
									  ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59')) INNER JOIN
									  dbo.Contract CON ON VOC.Contract_Number = CON.Contract_Number INNER JOIN
									  dbo.Location LOC ON CON.Pick_Up_Location_ID = LOC.Location_ID

						
						) AS RA INNER JOIN
							   dbo.Toll_Charge AS TC ON 
							   TC.Toll_Charge_Date BETWEEN RA.Checked_Out AND ISNULL(RA.Actual_Check_In, '2078-12-31 23:59')
							   AND RA.Licence_Plate_Number = TC.Licence_Plate
							Where TC.Processed=0
			
		)UnProcessed
		On GISTC.Contract_number = UnProcessed.Contract_number And	GISTC.Issuer=  UnProcessed.Issuer
		--And  GISTC.Licence_Plate  =UnProcessed.Licence_Plate  and GISTC.Toll_Charge_Date  =UnProcessed.Toll_Charge_Date
		  

	Group by	GISTC.Contract_Number,GISTC.Issuer,GISTC.Vehicle_Class_Code

)	ConTCTotal

Inner Join (Select Category, Code, Value from Lookup_table where Category='Toll Charge Issuer') TCIssuer
					On ConTCTotal.Issuer=  TCIssuer.Code
					
Inner Join 
	(	Select * from Contract_billing_Party 
		where Billing_Type='p' --and billing_method='Renter'
	 ) CBP
 On	 ConTCTotal.Contract_Number=   CBP.Contract_Number
Left Join  Renter_Primary_Billing RPB
		  On ConTCTotal.Contract_Number = RPB.Contract_Number
Left Join Credit_Card CC
		  On RPB.Credit_Card_Key = CC.Credit_Card_Key

Left Join 

(	Select Contract_Number, Sum(Amount) as TotalCharged, Issuer from Contract_Charge_Item 
	Where Charge_type	= 48 
	Group by Contract_Number,Issuer 
) cci
on ConTCTotal.Contract_number=cci.Contract_Number and ConTCTotal.Issuer=cci.Issuer
Where
ConTCTotal.TCTotal-	
	(Case When cci.TotalCharged is Null then 0 
		  Else  cci.TotalCharged
	 End)<>0

 


    
GO
