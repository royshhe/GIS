USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctAltPaymentMethod]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To return ALL alternate billing info for a contract
	- see GetCtrctAuthorizationDB for returning
	  primary billing info for direct bill customers 
MOD HISTORY:
Name	Date        	Comments
Don K 	Mar 15 1999 	- Made an outer join to aractcus
Don K 	Mar 17 1999 	- Removed CBP.Contract_Billing_Party_ID and sorted by it.
			Richard made me do it!
CPY	4/05/99 	- cpy bug fix - added Amt_Removed_From_Avail_Credit when calculating
			the available credit limit left 
CPY	6/30/99 	- removed CBP.Amt_Removed_From_Avail_Credit from calculation of
			available credit limit 
CPY 	9/8/99 		- Return Amt_Removed_From_Avail_Credit twice so the original value can 
			be preserved
CPY 	9/16/99 	- adjust Available_Credit_Limit_Left by adding back in the
			Amt_Removed_From_Avail_Credit so that credit limit takes into
			account the amount already billed 
CPY	10/22/99 	- do nullif outside of SQL statements 
CPY	Jan 6 2000	- removed Where criteria "Status_Type = 1"; return direct bill 
			info even if the direct bill org has been inactivated
Roy He Update for MS SQL 2008
*/
CREATE PROCEDURE [dbo].[GetCtrctAltPaymentMethod] --1079797
	@CtrctNum	VarChar(10)
AS
DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	CBP.Customer_Code,
		CBP.Billing_Method,
		AM.Address_Name,
		CBP.Amt_Removed_From_Avail_Credit,
		AM.Credit_Limit
			- ISNULL(AAC.Amt_Balance, 0)
			- ACA.Daily_Contract_Total
		 	- ACA.Expected_Open_Contract_Charges
			+ CBP.Amt_Removed_From_Avail_Credit as Available_Credit_Limit_Left,
		CBP.Amt_Removed_From_Avail_Credit

	FROM	Contract_Billing_Party CBP 
Inner Join	ARMaster AM
		  On  CBP.Customer_Code = AM.Customer_Code
 Inner Join AR_Credit_Authorization ACA
		  On CBP.Customer_Code = ACA.Customer_Code
  Left Join ARActCus AAC
		  On CBP.Customer_Code = AAC.Customer_Code
	
	WHERE	Contract_Number = @iCtrctNum
	AND	CBP.Billing_Type = 'a'
--	AND	CBP.Customer_Code = AM.Customer_Code
	AND	AM.Address_Type = 0
	--AND	AM.Status_Type = 1
	--AND	CBP.Customer_Code *= AAC.Customer_Code
	--AND	CBP.Customer_Code = ACA.Customer_Code
	ORDER
	BY	CBP.Contract_Billing_Party_ID

	RETURN @@ROWCOUNT


--select * from Contract_Billing_Party where Billing_Type = 'a' and  Customer_Code is not null
GO
