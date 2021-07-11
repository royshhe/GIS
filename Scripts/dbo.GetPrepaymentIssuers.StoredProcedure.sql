USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetPrepaymentIssuers]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetSearchOrgData    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.GetSearchOrgData    Script Date: 2/16/99 2:05:42 PM ******/
/* Don K - Mar 15 1999 - Used outer join to bgt_armaster and aractcus */
CREATE PROCEDURE [dbo].[GetPrepaymentIssuers] -- 'Cert'
	@PPType varchar(30)

AS

Set Rowcount 2000

Select
	ACM.Address_Name, ACM.Customer_Code, 
    (Case When @PPType='Cert'  Then 1 
			Else ISNULL(BACM.PO_Num_Reqd_Flag, 0)
    End) ,
	ISNULL(BACM.Claim_Num_Reqd_Flag, 0),
	(ACM.Credit_Limit - ISNULL(ACustA.Amt_Balance, 0) - ACA.Daily_Contract_Total - ACA.Expected_Open_Contract_Charges),
        ACM.resale_num,  
        ACM.attention_name, 
        ACM.attention_phone,
	ACM.FaxNo, 
	ACM.Address, 
        ACM.city, ACM.state, 
        ACM.postal_code, 
	ACM.country, 
	ACM.Comment
--From
--	bgt_armaster BACM, armaster ACM,
--	AR_Credit_Authorization ACA, aractcus ACustA
 

From
		armaster ACM WITH (NOLOCK)
Inner Join AR_Credit_Authorization ACA
			On ACM.Customer_Code= ACA.Customer_Code 
Left Join  bgt_armaster BACM
			On  ACM.Customer_Code= BACM.Customer_Code 	And ACM.Address_Type =BACM.Address_Type And ACM.Ship_To_Code=BACM.Ship_To_Code
Left Join 	 aractcus ACustA
			On  ACM.Customer_Code= ACustA.Customer_Code 


Where
	--ACM.Address_Name Like (LTrim(@OrgName) + '%')
	--And 
--    BACM.Customer_Code =* ACM.Customer_Code
--	And BACM.Address_Type =* ACM.Address_Type
--	And BACM.Ship_To_Code =* ACM.Ship_To_Code
--	And ACustA.Customer_Code =* ACM.Customer_Code
--	And ACA.Customer_Code = ACM.Customer_Code
--	And 
	ACM.Address_Type = 0
	And ACM.Status_Type = 1
	And Price_code =@PPType
Order By ACM.Address_Name
Return 1

GO
