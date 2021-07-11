USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ITB_GetARCustListByRBRDate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[ITB_GetARCustListByRBRDate]-- '2015-03-10' 
	@paramRBRDate varchar(20) = '15 April 1999' 
	 
AS
 -- convert strings to datetime
DECLARE 	@RBRDate datetime 
SELECT	@RBRDate	= CONVERT(datetime, @paramRBRDate) 
	 

SELECT distinct  ar.Customer_Account, ar.RBR_Date, 
					ITB.Email_Address --'pni@budgetbc.com' as Email_Address--	   
	   
	  		 
FROM  dbo.AR_Export ar 
		
Inner Join 
		Interim_bill_vw ITB
		On  ar.Contract_Number=	 ITB.Contract_Number And  ar.RBR_Date=ITB.RBR_Date
			And ar.ITB_BU_ID=ITB.Business_transaction_id
		Inner Join dbo.Contract Con On ar.Contract_Number=con.Contract_Number                   
WHERE (ar.Doc_Ctrl_Num_Base LIKE '%M') AND (ar.RBR_Date =@RBRDate)
and customer_account<>'BRACCRE'


GO
