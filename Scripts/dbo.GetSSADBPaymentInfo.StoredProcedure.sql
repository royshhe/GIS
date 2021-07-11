USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSSADBPaymentInfo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/* Programmer:  Jack Jian
    Date:             Feb 07, 2001
    Bug No:         Tracker Bug# 1787
    Details:          Get DirectBill Payment details in SeperateSales
                          reference sp: GetOrgDataByID, 
	Roy He MS SQL Update
*/


CREATE PROCEDURE [dbo].[GetSSADBPaymentInfo] --27070
  @SalesContractNum Varchar(11)

AS
	/* 9/27/99 - do type conversion outside of select */
DECLARE @iSalesCtrctNum Int

	SELECT @iSalesCtrctNum = CONVERT(int, NULLIF(@SalesContractNum,""))

SELECT
	Payment.Customer_Code,
	Payment.PO_Number,
	 ACM.Address_Name, ISNULL(BACM.PO_Num_Reqd_Flag, 0) ,
	ISNULL(BACM.Claim_Num_Reqd_Flag, 0),
	(ACM.Credit_Limit - ISNULL(ACustA.Amt_Balance, 0) - ACA.Daily_Contract_Total - ACA.Expected_Open_Contract_Charges),
             SalesPayment.Amount
--FROM
--	Sales_Accessory_AR_Payment Payment, 
--	bgt_armaster BACM, armaster ACM,
--	AR_Credit_Authorization ACA, aractcus ACustA,
--            Sales_Accessory_Sale_Payment SalesPayment


From
		Sales_Accessory_Sale_Payment SalesPayment
Inner Join	Sales_Accessory_AR_Payment Payment 
		On  SalesPayment.Sales_Contract_Number=Payment.Sales_Contract_Number
--Sales_Accessory_AR_Payment Payment 
Inner Join	armaster ACM
			ON  Payment.Customer_Code= ACM.Customer_Code 
Inner Join AR_Credit_Authorization ACA
			On ACM.Customer_Code= ACA.Customer_Code 
Left Join  bgt_armaster BACM
			On  ACM.Customer_Code= BACM.Customer_Code And ACM.Address_Type =BACM.Address_Type And ACM.Ship_To_Code=BACM.Ship_To_Code
Left Join 	 aractcus ACustA
			On  ACM.Customer_Code= ACustA.Customer_Code 
--Left Join  Sales_Accessory_Sale_Payment SalesPayment
--			On  SalesPayment.Sales_Contract_Number=Payment.Sales_Contract_Number 



WHERE
	Payment.Sales_Contract_Number = @iSalesCtrctNum
--	and ACM.Customer_Code = Payment.Customer_Code
--	And BACM.Customer_Code =* ACM.Customer_Code
--	And BACM.Address_Type =* ACM.Address_Type
--	And BACM.Ship_To_Code =* ACM.Ship_To_Code
--	And ACustA.Customer_Code =* ACM.Customer_Code
--	And ACA.Customer_Code = ACM.Customer_Code
	And ACM.Address_Type = 0
	And ACM.Status_Type = 1
--             And SalesPayment.Sales_Contract_Number=Payment.Sales_Contract_Number
Order By ACM.Address_Name            
	
RETURN @@ROWCOUNT


--
--select * from Sales_Accessory_AR_Payment
--select * from Sales_Accessory_Sale_Payment  where Sales_Contract_Number=27049
--
--
--select * from armaster_base where customer_code='BRAC01'
GO
