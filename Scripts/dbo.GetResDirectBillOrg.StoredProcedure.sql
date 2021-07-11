USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResDirectBillOrg]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PURPOSE: To retrieve the direct bill org info for a given OrgId (customer code)
MOD HISTORY:
Name	Date        	Comments
Don K 	Mar 15 1999 	- Used outer join to bgt_armaster and aractcus 
CPY	Jan 6 2000	- removed Where criteria "Status_Type = 1"; return AR customer
			info even if it has been inactivated
*/
CREATE PROCEDURE [dbo].[GetResDirectBillOrg]
@OrgId Varchar(10)

AS

Set Rowcount 2000

IF @OrgId =''	SELECT @OrgId = NULL

SELECT	Distinct
	ACM.Customer_Code, ACM.Address_Name, ISNULL(BACM.PO_Num_Reqd_Flag, 0),
	ISNULL(BACM.Claim_Num_Reqd_Flag, 0),
	(ACM.Credit_Limit - ISNULL(ACustA.Amt_Balance, 0) - ACA.Daily_Contract_Total - ACA.Expected_Open_Contract_Charges)
--From
--	bgt_armaster BACM, armaster ACM,
--	AR_Credit_Authorization ACA, aractcus ACustA


From
		armaster ACM  WITH (NOLOCK)
Inner Join AR_Credit_Authorization ACA
			On ACM.Customer_Code= ACA.Customer_Code 
Left Join  bgt_armaster BACM
			On  ACM.Customer_Code= BACM.Customer_Code 	And ACM.Address_Type =BACM.Address_Type And ACM.Ship_To_Code=BACM.Ship_To_Code
Left Join 	 aractcus ACustA
			On  ACM.Customer_Code= ACustA.Customer_Code 

WHERE
	ACM.Customer_Code = @OrgId
--	And BACM.Customer_Code =* ACM.Customer_Code
--	And BACM.Address_Type =* ACM.Address_Type
--	And BACM.Ship_To_Code =* ACM.Ship_To_Code
--	And ACustA.Customer_Code =* ACM.Customer_Code
--	And ACA.Customer_Code = ACM.Customer_Code
	And ACM.Address_Type = 0
	And ACM.Status_Type = 1
Order By ACM.Address_Name
RETURN @@ROWCOUNT



--
--From
--		armaster ACM
--Inner Join AR_Credit_Authorization ACA
--			On ACM.Customer_Code= ACA.Customer_Code 
--Left Join  bgt_armaster BACM
--			On  ACM.Customer_Code= BACM.Customer_Code 	And ACM.Address_Type =BACM.Address_Type And ACM.Ship_To_Code=BACM.Ship_To_Code
--Left Join 	 aractcus ACustA
--			On  ACM.Customer_Code= ACustA.Customer_Code 
--
----	bgt_armaster BACM, armaster ACM,
----	AR_Credit_Authorization ACA, aractcus ACustA
--Where
--	ACM.Customer_Code = @OrgID
----	And BACM.Customer_Code =* ACM.Customer_Code
----	And BACM.Address_Type =* ACM.Address_Type
----	And BACM.Ship_To_Code =* ACM.Ship_To_Code
----	And ACustA.Customer_Code =* ACM.Customer_Code
----	And ACA.Customer_Code = ACM.Customer_Code
--	And ACM.Address_Type = 0
--	And ACM.Status_Type = 1
--Order By ACM.Address_Name
--Return 1
--
--
--
--
--
--

GO
