USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctTollPrepayment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetCtrctTollPrepayment]
As 


--SELECT   Code as Issuer, Value as Rate, Alias as Vehicle_Type_ID
--FROM  dbo.Lookup_Table
--WHERE (Category LIKE 'Toll Charge Rate%')
--Select * from lookup_table where category like '%toll%'
--Select * from Toll_Reporting where contract_number=2033888
--Select * from Contract_billing_Party

	 
SElect  TCR.Contract_number,	 
		Convert(decimal(9,2), Rate.RateAmount)*SUM(TCR.Number_Of_Crossing) Amount, 
		SUM(TCR.Number_Of_Crossing) Number_Of_Crossing,
		TCR.Issuer, 	
		CBP.Billing_Method, 
		CC.Credit_Card_Key, 
		CC.Electronic_Authorization,
		CBP.Customer_Code,
		CBP.Contract_Billing_Party_ID, 
		DBB.PO_Number, 
		CON.Vehicle_Class_Code,	
		CON.Email_Address, 
		ARCU.address_name, 
		ARCU.Price_code as ARCustomerGroup	 
from
(

	SELECT TR.Toll_Report_ID, 
	ISNULL(RA.Contract_Number,TR.Contract_number) as Contract_number, 
	TR.Renter_Last_Name, 
	TR.Licence_Plate_Number, 
	TR.Crossing_Date, 
	TR.Number_Of_Crossing, 
	TR.Issuer, 
	TR.Reporting_Time, 
	TR.Processed, 
	TR.Business_Transaction_ID 
	                 
	            
	FROM  dbo.Toll_Reporting AS TR
	LEFT OUTER JOIN
	(SELECT Con.Contract_Number, Res.Foreign_Confirm_Number
			FROM  dbo.Contract AS Con INNER JOIN
			dbo.Reservation AS Res 
			ON Con.Confirmation_Number = Res.Confirmation_Number
	) AS RA 
	ON TR.Confirmation_Number = RA.Foreign_Confirm_Number
	Where TR.Processed=0
) TCR
INNER JOIN dbo.Contract CON
	ON TCR.Contract_number=CON.Contract_number
INNER JOIN dbo.Vehicle_Class VC 
	ON CON.Vehicle_Class_Code=VC.Vehicle_Class_Code
INNER JOIN (SELECT   Code as Issuer, Value as RateAmount, Alias as Vehicle_Type_ID
				FROM  dbo.Lookup_Table
				WHERE (Category LIKE 'Toll Charge Rate%')
			) Rate
	 on VC.FA_Vehicle_Type_ID=Rate.Vehicle_Type_ID and  TCR.Issuer=Rate.Issuer

Inner Join 
	(	Select * from Contract_billing_Party 
		where Billing_Type='p' --and billing_method='Renter'
	 ) CBP
 On	 TCR.Contract_Number=   CBP.Contract_Number
Left Join Direct_bill_Primary_Billing DBB 
 On CBP.Contract_number=DBB.Contract_number 
	and CBP.Contract_Billing_Party_ID=DBB.Contract_Billing_Party_ID
Left Join dbo.armaster_base ARCU on CBP.Customer_Code=ARCU.Customer_Code
Left Join  Renter_Primary_Billing RPB
		  On TCR.Contract_Number = RPB.Contract_Number
		   
Left Join (

	SELECT dbo.Credit_Card.Credit_Card_Key, dbo.Credit_Card.Credit_Card_Type_ID, dbo.Credit_Card.Credit_Card_Number, dbo.Credit_Card.Customer_ID, 
				   dbo.Credit_Card.Last_Name, dbo.Credit_Card.First_Name, dbo.Credit_Card.Expiry, dbo.Credit_Card.Sequence_Num,dbo.Credit_Card_Type.Electronic_Authorization
	FROM  dbo.Credit_Card WITH (NOLOCK)INNER JOIN
				   dbo.Credit_Card_Type ON dbo.Credit_Card.Credit_Card_Type_ID = dbo.Credit_Card_Type.Credit_Card_Type_ID	
	--WHERE (dbo.Credit_Card_Type.Electronic_Authorization = 1)

) CC
On RPB.Credit_Card_Key = CC.Credit_Card_Key
Where (ARCU.Price_code<>'PRODUC' or ARCU.Price_code is null)
Group by TCR.Contract_number,
		VC.FA_Vehicle_Type_ID,
		CON.Vehicle_Class_Code,		 
		TCR.Issuer, 	
		CBP.Billing_Method, 
		CC.Credit_Card_Key, 
		CC.Electronic_Authorization,
		CBP.Customer_Code,
		CBP.Contract_Billing_Party_ID, 
		DBB.PO_Number, 
		Rate.RateAmount,
		CON.Email_Address,
		ARCU.address_name, 
		ARCU.Price_code 
		
		
		
		
		
GO
