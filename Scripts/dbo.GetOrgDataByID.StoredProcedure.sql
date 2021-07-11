USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgDataByID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetOrgDataByID    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgDataByID    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgDataByID    Script Date: 1/11/99 1:03:16 PM ******/

/* Don K - Mar 15 1999 - Used outer join to bgt_armaster and aractcus */
/*Roy He	 2011-03-16 MS SQL 2008*/

CREATE PROCEDURE [dbo].[GetOrgDataByID]
@OrgID varchar(255)
AS
Set Rowcount 2000
Select
	ACM.Customer_Code, ACM.Address_Name, ISNULL(ACM.PO_Num_Reqd_Flag, 0),
	ISNULL(ACM.Claim_Num_Reqd_Flag, 0),
	(ACM.Credit_Limit - ISNULL(ACustA.Amt_Balance, 0) - ACA.Daily_Contract_Total - ACA.Expected_Open_Contract_Charges)
From
		armaster ACM
Inner Join AR_Credit_Authorization ACA
			On ACM.Customer_Code= ACA.Customer_Code 
--Left Join  bgt_armaster BACM
--			On  ACM.Customer_Code= BACM.Customer_Code 	And ACM.Address_Type =BACM.Address_Type And ACM.Ship_To_Code=BACM.Ship_To_Code
Left Join 	 aractcus ACustA
			On  ACM.Customer_Code= ACustA.Customer_Code 

--	bgt_armaster BACM, armaster ACM,
--	AR_Credit_Authorization ACA, aractcus ACustA
Where
	ACM.Customer_Code = @OrgID
--	And BACM.Customer_Code =* ACM.Customer_Code
--	And BACM.Address_Type =* ACM.Address_Type
--	And BACM.Ship_To_Code =* ACM.Ship_To_Code
--	And ACustA.Customer_Code =* ACM.Customer_Code
--	And ACA.Customer_Code = ACM.Customer_Code
	And ACM.Address_Type = 0
	And ACM.Status_Type = 1
Order By ACM.Address_Name
Return 1
GO
