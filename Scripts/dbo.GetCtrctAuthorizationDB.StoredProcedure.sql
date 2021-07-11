USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctAuthorizationDB]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PURPOSE: To return primary billing direct bill info for a contract
	- see GetCtrctAltPaymentMethod for returning alternate billing info
MOD HISTORY:
Name	Date        	Comments
Don K 	Mar 15 1999 	Used outer join to bgt_armaster and aractcus
CPY	4/05/99 	- cpy bug fix - added Amt_Removed_From_Avail_Credit when calculating
			the available credit limit left 
CPY	6/30/99 	- removed CBP.Amt_Removed_From_Avail_Credit from calculation of
			available credit limit left 
CPY	8/18/99 	- convert Issue_Interim_Bills to char(1) before returning
CPY	10/1/99 	- do type conversion and nullif outside of select 
CPY	Jan 6 2000	- removed Where criteria "Status_Type = 1"; return direct bill 
			info even if the direct bill org has been inactivated
Roy He Update for MS SQL 2008
*/
CREATE PROCEDURE [dbo].[GetCtrctAuthorizationDB]-- 1759554
	@CtrctNum	VarChar(10)
AS

DECLARE	@iCtrctNum Int
	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT
		CBP.Customer_Code,
		AM.Address_Name,
		DBPB.PO_Number,
		ISNULL(BGTAM.PO_Num_Reqd_Flag, 0),
		CBP.Amt_Removed_From_Avail_Credit,
		AM.Credit_Limit
			- ISNULL(AAC.Amt_Balance, 0)
			- ACA.Daily_Contract_Total
			- ACA.Expected_Open_Contract_Charges as Available_Credit_Limit_Left,
		Convert(Char(1), DBPB.Issue_Interim_Bills)

	FROM		Contract_Billing_Party CBP       
   Inner Join	Direct_Bill_Primary_Billing DBPB			
		On CBP.Contract_Billing_Party_ID = DBPB.Contract_Billing_Party_ID
    Inner Join 	ARMaster AM
		On CBP.Customer_Code = AM.Customer_Code
    Inner Join 	AR_Credit_Authorization ACA
		On CBP.Customer_Code = ACA.Customer_Code
     Left Join 	BGT_ARMaster BGTAM
		On 	AM.Customer_Code = BGTAM.Customer_Code
	AND	AM.Address_Type  = BGTAM.Address_Type
	AND	AM.Ship_To_Code = BGTAM.Ship_To_Code
	  Left Join 	ARActCus AAC
          On CBP.Customer_Code = AAC.Customer_Code

--       Direct_Bill_Primary_Billing DBPB,
--		Contract_Billing_Party CBP,
--		BGT_ARMaster BGTAM,
--		ARMaster AM,
--		ARActCus AAC,
--		AR_Credit_Authorization ACA
	
	WHERE	DBPB.Contract_Number = @iCtrctNum
	AND	CBP.Contract_Number = @iCtrctNum
	AND	CBP.Billing_Type = 'p'
	AND	CBP.Billing_Method = 'Direct Bill'
--	AND	CBP.Contract_Billing_Party_ID = DBPB.Contract_Billing_Party_ID
--	AND	CBP.Customer_Code = AM.Customer_Code
--	AND	AM.Customer_Code *= BGTAM.Customer_Code
--	AND	AM.Address_Type *= BGTAM.Address_Type
--	AND	AM.Ship_To_Code *= BGTAM.Ship_To_Code
	AND	AM.Address_Type = 0
	--AND	AM.Status_Type = 1
--	AND	CBP.Customer_Code *= AAC.Customer_Code
	--AND	CBP.Customer_Code not in ('ONEPROD')
	RETURN @@ROWCOUNT

GO
