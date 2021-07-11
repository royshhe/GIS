USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctTollCharge]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetCtrctTollCharge]
As 
Select V.* from 
(Select 

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
	 ConTCTotal.Issuer, 
	 CBP.Billing_Method, 	 
	 --CC.Credit_Card_Key,
	 (Case When CCPayment.Credit_Card_Key Is Null Then CC.Credit_Card_Key
		  Else   CCPayment.Credit_Card_Key
	 End) Credit_Card_Key,
	 
	 (Case When CCPayment.Electronic_Authorization Is Null Then CC.Electronic_Authorization
		  Else   CCPayment.Electronic_Authorization
	 End) Electronic_Authorization,
	 CBP.Customer_Code,
	 CBP.Contract_Billing_Party_ID, 
	 DBB.PO_Number, 
	 ConTCTotal.Vehicle_Class_Code,
	 ConTCTotal.Email_Address,
	 ARCU.address_name, 
	 ARCU.Price_code as ARCustomerGroup,
	 -- Pre-auth for force charge
	 (Case When CCAuth.Credit_Card_Key Is Null Then CCPayment.Credit_Card_Key
		  Else   CCAuth.Credit_Card_Key
	 End) Auth_CC_Key,	 
	 
	 (Case When CCAuth.Authorization_Number Is Null Then CCPayment.Authorization_Number
		  Else   CCAuth.Authorization_Number
	 End) Authorization_Number
	 --,	   	   
	 --CCAuth.Credit_Card_Key,
	 -- CCAuth.Authorization_Number
From 
(	
	Select Sum(GISTC.Charge_Amount) as TCTotal, GISTC.Contract_Number, Count(*) NumberOfCrossing,GISTC.Issuer, GISTC.Vehicle_Class_Code,GISTC.Email_Address 
	From
	(	SELECT distinct TC.Toll_Charge_Date, TC.Charge_Amount, TC.Licence_Plate, RA.Contract_Number, RA.Checked_Out, RA.Actual_Check_In, RA.Attached_On, RA.Removed_On, 
				   RA.First_Name, RA.Last_Name, RA.Vehicle_Class_Code, RA.Location, TC.Issuer, RA.Email_Address
		FROM  (SELECT		VLH.Licence_Plate_Number,
						convert(varchar(30),CON.Contract_Number) as Contract_number,
						VOC.Checked_Out, 
						VOC.Actual_Check_In, 
						VLH.Attached_On, 
						VLH.Removed_On, 
						CON.First_Name, 
						CON.Last_Name,
						CON.Vehicle_Class_Code, 						
						LOC.Location,
						CON.Email_Address
			FROM         dbo.Vehicle_On_Contract VOC WITH (NOLOCK) INNER JOIN
						  dbo.Vehicle_Licence_History VLH ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On AND 
						  ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59')) INNER JOIN
						  dbo.Contract CON WITH (NOLOCK) ON VOC.Contract_Number = CON.Contract_Number INNER JOIN
						  dbo.Location LOC ON CON.Pick_Up_Location_ID = LOC.Location_ID
						  --For  None Eigen Transaction
						  --where CON.Contract_number in
						  --(select contract_number from Credit_Card_Transaction where RBR_Date='2017-08-04' and collected_by='TOLLCHARGE')
						  

			
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
						FROM         dbo.Vehicle_On_Contract VOC WITH (NOLOCK) INNER JOIN
									  dbo.Vehicle_Licence_History VLH ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On AND 
									  ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59')) INNER JOIN
									  dbo.Contract CON WITH (NOLOCK) ON VOC.Contract_Number = CON.Contract_Number INNER JOIN
									  dbo.Location LOC ON CON.Pick_Up_Location_ID = LOC.Location_ID

						
						) AS RA INNER JOIN
							   dbo.Toll_Charge AS TC ON 
							   TC.Toll_Charge_Date BETWEEN RA.Checked_Out AND ISNULL(RA.Actual_Check_In, '2078-12-31 23:59')
							   AND RA.Licence_Plate_Number = TC.Licence_Plate
							Where TC.Processed=0
			
		)UnProcessed
		On GISTC.Contract_number = UnProcessed.Contract_number And	GISTC.Issuer=  UnProcessed.Issuer
		--And  GISTC.Licence_Plate  =UnProcessed.Licence_Plate  and GISTC.Toll_Charge_Date  =UnProcessed.Toll_Charge_Date
		  

	Group by	GISTC.Contract_Number,GISTC.Issuer,GISTC.Vehicle_Class_Code,GISTC.Email_Address 

)	ConTCTotal
Inner Join 
	(	Select * from Contract_billing_Party 
		where Billing_Type='p' --and billing_method='Renter'
	 ) CBP
 On	 ConTCTotal.Contract_Number=   CBP.Contract_Number
Inner Join  Renter_Primary_Billing RPB
		  On ConTCTotal.Contract_Number = RPB.Contract_Number
		  
Left Join Direct_bill_Primary_Billing DBB 
 On CBP.Contract_number=DBB.Contract_number 
	and CBP.Contract_Billing_Party_ID=DBB.Contract_Billing_Party_ID
Left Join dbo.armaster_base ARCU on CBP.Customer_Code=ARCU.Customer_Code

		   
Left Join (

	SELECT dbo.Credit_Card.Credit_Card_Key, dbo.Credit_Card.Credit_Card_Type_ID, dbo.Credit_Card.Credit_Card_Number, dbo.Credit_Card.Customer_ID, 
				   dbo.Credit_Card.Last_Name, dbo.Credit_Card.First_Name, dbo.Credit_Card.Expiry, dbo.Credit_Card.Sequence_Num,dbo.Credit_Card_Type.Electronic_Authorization
	FROM  dbo.Credit_Card INNER JOIN
				   dbo.Credit_Card_Type ON dbo.Credit_Card.Credit_Card_Type_ID = dbo.Credit_Card_Type.Credit_Card_Type_ID	
	--WHERE (dbo.Credit_Card_Type.Electronic_Authorization = 1)

) CC
On RPB.Credit_Card_Key = CC.Credit_Card_Key		  
		  
--Inner Join (

--	SELECT dbo.Credit_Card.Credit_Card_Key, dbo.Credit_Card.Credit_Card_Type_ID, dbo.Credit_Card.Credit_Card_Number, dbo.Credit_Card.Customer_ID, 
--				   dbo.Credit_Card.Last_Name, dbo.Credit_Card.First_Name, dbo.Credit_Card.Expiry, dbo.Credit_Card.Sequence_Num
--	FROM  dbo.Credit_Card WITH (NOLOCK)INNER JOIN
--				   dbo.Credit_Card_Type ON dbo.Credit_Card.Credit_Card_Type_ID = dbo.Credit_Card_Type.Credit_Card_Type_ID	
--	WHERE (dbo.Credit_Card_Type.Electronic_Authorization = 1)

--) CC
--On RPB.Credit_Card_Key = CC.Credit_Card_Key
		  
--If payment exist		  
LEFT OUTER JOIN
               
       (Select LCCP.Contract_Number,LCCP.Authorization_Number, CC.*, CCT.Electronic_Authorization 
                   from Credit_Card_Payment LCCP  
                   Inner join 
                         (SELECT   CCP.Contract_Number, Max(CCP.Sequence) Seq
                         FROM  dbo.Credit_Card_Payment AS CCP WITH (NOLOCK)
                         Group By   CCP.Contract_Number
                         ) ConPay
                         On LCCP.Contract_Number=ConPay.Contract_Number And LCCP.Sequence=     ConPay.Seq
                   INNER JOIN
                         dbo.Credit_Card AS CC WITH (NOLOCK) ON LCCP.Credit_Card_Key = CC.Credit_Card_Key                           
                   INNER JOIN
						 dbo.Credit_Card_Type CCT ON CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID	
				         
         ) CCPayment     on   ConTCTotal.Contract_Number=CCPayment.Contract_Number		
LEFT OUTER JOIN 
(SELECT   CONAuth.Contract_Number,  CONAuth.Authorization_Number, CONAuth.Credit_Card_Key
		FROM  dbo.Credit_Card_Authorization CONAuth 
		INNER JOIN
		(SELECT   CCA.Contract_Number, MIN(CCA.Sequence) Seq
                         FROM dbo.Credit_Card_Authorization  CCA   
                         Group By   CCA.Contract_Number
         ) FirstCCA
         On CONAuth.Contract_Number=FirstCCA.Contract_Number
           And CONAuth.Sequence = FirstCCA.Seq

 
) CCAuth on  ConTCTotal.Contract_Number=CCAuth.Contract_Number	

Left Join 

(	Select Contract_Number, Sum(Amount) as TotalCharged, Issuer from Contract_Charge_Item WITH (NOLOCK)
	Where Charge_type	= 48 
	Group by Contract_Number,Issuer 
) cci
on ConTCTotal.Contract_number=cci.Contract_Number and ConTCTotal.Issuer=cci.Issuer
Where (ARCU.Price_code<>'PRODUC' or ARCU.Price_code is null)



--SELECT top 1 Contract_Number,  Sequence, Authorization_Number, Credit_Card_Key
--FROM  dbo.Credit_Card_Authorization 
--where contract_number=2031983
--Order by Sequence


 --Exclude "Direct bill" as alternative billing	method for now.  Remove latter On
 -- Turn On alternative	 billing	method -2013-02-27
--Where 

--	ConTCTotal.Contract_Number not in 
--	(
--		Select Contract_Number from Contract_billing_Party 
--		where Billing_Type='a' and billing_method='Direct Bill'	 
--	)
	--And
	--ConTCTotal.TCTotal-	
	--(Case When cci.TotalCharged is Null then 0 
	--	  Else  cci.TotalCharged
	-- End)>0
)V
Where V.Credit_Card_Key is not null or Auth_CC_Key is not null
GO
